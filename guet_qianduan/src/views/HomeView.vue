<template>
  <div class="admin-layout">
    <!-- 左侧导航菜单 -->
    <aside class="sidebar">
      <div class="logo">
        <img src="@/assets/imgs/guetimg.png" alt="Guet" class="logo-img">
        <span class="logo-text">羊城货运平台</span>
      </div>
      <el-scrollbar class="menu-scrollbar">
        <el-menu
          class="sidebar-menu"
          :default-active="activeMenu"
          @select="handleMenuSelect"
        >
          <el-menu-item
            v-for="item in filteredMenuItems"
            :key="item.id"
            :index="item.id"
          >
            <el-icon><component :is="getIcon(item.id)" /></el-icon>
            <span>{{ item.name }}</span>
          </el-menu-item>
        </el-menu>
      </el-scrollbar>
    </aside>

    <!-- 右侧内容区域 -->
    <main class="content">
      <el-header class="top-bar">
        <el-row class="header-row" align="middle" justify="space-between">
          <el-col :span="6" class="header-left">
            <el-icon class="breadcrumb-icon"><Location /></el-icon>
            <span class="current-menu">{{ currentMenuName }}</span>
          </el-col>
          <el-col :span="18" class="header-right">
            <el-dropdown trigger="click" @command="handleCommand">
              <div class="user-info-trigger">
                <el-icon :size="18"><User /></el-icon>
                <span class="username">{{ currentUser }}</span>
                <el-icon class="dropdown-icon"><ArrowDown /></el-icon>
              </div>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="profile">
                    <el-icon><User /></el-icon>
                    <span>个人信息</span>
                  </el-dropdown-item>
                  <el-dropdown-item divided command="logout">
                    <el-icon><SwitchButton /></el-icon>
                    <span>退出登录</span>
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </el-col>
        </el-row>
      </el-header>
      <div class="content-area">
        <!-- 使用router-view显示子路由组件 -->
        <router-view />
      </div>
    </main>

    <!-- 用户信息对话框 -->
    <el-dialog
      v-model="showUserInfoModal"
      title="个人信息"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-descriptions :column="1" border>
        <el-descriptions-item label="用户ID">{{ userInfo?.id || '-' }}</el-descriptions-item>
        <el-descriptions-item label="用户名">{{ userInfo?.username || '-' }}</el-descriptions-item>
        <el-descriptions-item label="姓名">{{ userInfo?.name || '-' }}</el-descriptions-item>
        <el-descriptions-item label="电话">{{ userInfo?.phone || '-' }}</el-descriptions-item>
        <el-descriptions-item label="性别">{{ userInfo?.sex || '-' }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="userInfo?.status === 1 ? 'success' : 'danger'">
            {{ userInfo?.status === 1 ? '启用' : '禁用' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ formatDate(userInfo?.createTime) }}</el-descriptions-item>
        <el-descriptions-item label="描述">{{ userInfo?.memo || '-' }}</el-descriptions-item>
        <el-descriptions-item label="职位">
          {{ Array.isArray(permission) && permission.length > 0 ? permission.join('、') : '-' }}
        </el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button type="primary" @click="showUserInfoModal = false">确定</el-button>
      </template>
    </el-dialog>

    <!-- AI 智能客服 -->
    <AiChat />
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AiChat from '@/components/AiChat.vue'

const router = useRouter()
const route = useRoute()
const activeMenu = ref('dashboard')
const currentUser = ref('Admin')
const showUserInfoModal = ref(false)
const userInfo = ref(null)
const permission = ref([])

// 监听路由变化，更新activeMenu
watch(() => route.name, (newRouteName) => {
  if (newRouteName) {
    activeMenu.value = newRouteName
  }
}, { immediate: true })

// 在组件挂载时从 localStorage 读取用户信息
onMounted(() => {
  const userInfoStr = localStorage.getItem('userInfo')
  const username = localStorage.getItem('username')
  if (username) {
    currentUser.value = username
  }
  if (userInfoStr) {
    userInfo.value = JSON.parse(userInfoStr)
    console.log('当前登录用户信息:', userInfo.value)
  }
  const permissionStr = localStorage.getItem('permission')
  if (permissionStr) {
    permission.value = JSON.parse(permissionStr)
  }
})

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN')
}

// 菜单项（带权限控制）
const menuItems = ref([
  { id: 'dashboard', name: '首页', path: '/dashboard' },
  { id: 'basicdata', name: '基础数据', path: '/basicdata' },
  { id: 'users', name: '用户管理', role: '平台管理员', path: '/users' },
  { id: 'roles', name: '角色管理', role: '平台管理员', path: '/roles' },
  { id: 'customers', name: '客户管理', path: '/customers' },
  { id: 'orders', name: '我的订单', path: '/orders' },
  { id: 'finance', name: '财务管理', path: '/finance' },
  { id: 'logs', name: '操作日志', path: '/logs' }
])

// 图标映射
const iconMap = {
  dashboard: 'HomeFilled',
  basicdata: 'DataAnalysis',
  users: 'UserFilled',
  roles: 'Lock',
  customers: 'User',
  orders: 'Box',
  finance: 'Wallet',
  logs: 'Document'
}

const getIcon = (id) => {
  return iconMap[id] || 'Menu'
}

// 处理菜单选择
const handleMenuSelect = (index) => {
  const menuItem = menuItems.value.find(item => item.id === index)
  if (menuItem && menuItem.path) {
    router.push(menuItem.path)
  }
}

// 过滤后的菜单（根据权限显示）
const filteredMenuItems = computed(() => {
  return menuItems.value.filter(item => {
    if (!item.role) return true
    return permission.value.includes(item.role)
  })
})

// 当前菜单名称
const currentMenuName = computed(() => {
  const menuItem = menuItems.value.find(item => item.id === activeMenu.value)
  return menuItem ? menuItem.name : '首页'
})

// 退出登录
const logout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('isLoggedIn')
  localStorage.removeItem('userInfo')
  localStorage.removeItem('username')
  localStorage.removeItem('userId')
  localStorage.removeItem('permission')
  router.push('/login')
}

// 处理下拉菜单命令
const handleCommand = (command) => {
  if (command === 'profile') {
    showUserInfoModal.value = true
  } else if (command === 'logout') {
    logout()
  }
}
</script>

<style scoped lang="scss">
.admin-layout {
  display: flex;
  min-height: 100vh;
  background-color: #f0f2f5;

  .sidebar {
    width: 200px;
    background: #fff;
    border-right: 1px solid #e4e7ed;
    position: fixed;
    left: 0;
    top: 0;
    bottom: 0;
    display: flex;
    flex-direction: column;

    .logo {
      padding: 16px;
      display: flex;
      align-items: center;
      border-bottom: 1px solid #e4e7ed;

      .logo-img {
        width: 32px;
        height: 32px;
        border-radius: 6px;
        margin-right: 10px;
      }

      .logo-text {
        font-size: 15px;
        font-weight: 600;
        color: #303133;
      }
    }

    .menu-scrollbar {
      flex: 1;
      height: calc(100vh - 65px);
    }

    .sidebar-menu {
      border-right: none;
      padding: 8px;

      :deep(.el-menu-item) {
        height: 44px;
        line-height: 44px;
        border-radius: 8px;
        margin-bottom: 4px;
        color: #606266;

        &:hover {
          background-color: #ecf5ff;
          color: #409eff;
        }

        &.is-active {
          background-color: #909399;
          color: #fff;

          .el-icon {
            color: #fff;
          }
        }

        .el-icon {
          font-size: 18px;
          margin-right: 8px;
          color: #909399;
        }
      }

      :deep(.el-menu-item.is-active .el-icon) {
        color: #fff;
      }
    }
  }

  .content {
    flex: 1;
    margin-left: 200px;
    display: flex;
    flex-direction: column;

    .top-bar {
      background: linear-gradient(180deg, rgba(179, 228, 253, 0.5), #ffffff);
      padding: 0 20px;
      height: 56px;
      border-bottom: 1px solid #e4e7ed;

      :deep(.el-header) {
        --el-header-padding: 0;
        --el-header-height: auto;
      }

      .header-row {
        height: 100%;
      }

      .header-left {
        display: flex;
        align-items: center;

        .breadcrumb-icon {
          font-size: 18px;
          color: #409eff;
          margin-right: 8px;
        }

        .current-menu {
          font-size: 16px;
          font-weight: 600;
          color: #303133;
        }
      }

      .header-right {
        display: flex;
        justify-content: flex-end;
        align-items: center;

        .user-info-trigger {
          display: flex;
          align-items: center;
          gap: 8px;
          cursor: pointer;
          padding: 8px 12px;
          border-radius: 6px;
          transition: all 0.3s;

          &:hover {
            background-color: #f5f7fa;
          }

          .username {
            font-size: 14px;
            color: #606266;
            font-weight: 500;
          }

          .dropdown-icon {
            color: #909399;
            font-size: 12px;
          }
        }
      }
    }

    .content-area {
      flex: 1;
      padding: 20px;
      overflow-y: auto;
      background-color: #f5f7fa;
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .admin-layout {
    .sidebar {
      width: 180px;
    }

    .content {
      margin-left: 180px;
    }
  }
}
</style>