<template>
  <div class="table-container">
    <div class="header-section">
      <div class="toolbar">
        <div class="search-box">
          <input 
            v-model="searchKeyword" 
            type="text" 
            placeholder="按用户名搜索"
            @keyup.enter="handleSearch"
          >
          <button class="btn-search" @click="handleSearch">🔍 搜索</button>
        </div>
        <button class="btn-add" @click="handleAdd">➕ 新增用户</button>
      </div>
    </div>

    <!-- 加载状态 -->
    <div v-if="userStore.loading" class="loading">加载中...</div>

    <!-- 错误信息 -->
    <div v-if="userStore.error" class="error">{{ userStore.error }}</div>

    <!-- 数据表格 -->
    <table v-if="!userStore.loading && userStore.users.length > 0" class="data-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>用户名</th>
          <th>姓名</th>
          <th>电话</th>
          <th>性别</th>
          <th>状态</th>
          <th>创建时间</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in pagedUsers" :key="user.id">
          <td>{{ user.id }}</td>
          <td>{{ user.username }}</td>
          <td>{{ user.name }}</td>
          <td>{{ user.phone || '-' }}</td>
          <td>{{ user.sex }}</td>
          <td>
            <button 
              :class="['status-btn', user.status === 1 ? 'active' : 'inactive']"
              @click="handleStatusToggle(user)"
            >
              {{ user.status === 1 ? '启用' : '禁用' }}
            </button>
          </td>
          <td>{{ formatDate(user.createTime) }}</td>
          <td>
            <button class="btn-edit" @click="handleEdit(user)">编辑</button>
            <button class="btn-delete" @click="handleDelete(user.id)">删除</button>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- 空状态 -->
    <div v-if="!userStore.loading && userStore.users.length === 0" class="empty">
      暂无用户数据
    </div>

    <!-- 分页 -->
    <el-pagination
      v-if="userStore.users.length > 0"
      class="pagination"
      v-model:current-page="currentPage"
      v-model:page-size="pageSize"
      :page-sizes="[10, 20, 50]"
      :total="userStore.users.length"
      layout="total, sizes, prev, pager, next, jumper"
      background
    />

    <!-- 编辑模态框 -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <div class="modal-header">
          <h4>{{ editingUser ? '编辑用户' : '新增用户' }}</h4>
          <button class="btn-close" @click="closeModal">✕</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>用户名</label>
            <input v-model="formData.username" type="text" placeholder="请输入用户名">
          </div>
          <div class="form-group">
            <label>姓名</label>
            <input v-model="formData.name" type="text" placeholder="请输入姓名">
          </div>
          <div class="form-group">
            <label>密码</label>
            <input v-model="formData.password" type="password" placeholder="请输入密码">
          </div>
          <div class="form-group">
            <label>电话</label>
            <input v-model="formData.phone" type="text" placeholder="请输入电话">
          </div>
          <div class="form-group">
            <label>性别</label>
            <select v-model="formData.sex">
              <option value="">请选择</option>
              <option value="男">男</option>
              <option value="女">女</option>
            </select>
          </div>
          <div class="form-group">
            <label>描述</label>
            <textarea v-model="formData.memo" placeholder="请输入描述"></textarea>
          </div>
          <div class="form-group role-section" v-if="roles.length > 0">
            <label>职位分配</label>
            <div class="role-checkbox-group">
              <label v-for="role in roles" :key="role.id" class="role-checkbox-item">
                <input 
                  type="checkbox" 
                  :value="role.id" 
                  v-model="selectedRoleIds"
                >
                <span>{{ role.roleName }}</span>
              </label>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-cancel" @click="closeModal">取消</button>
          <button class="btn-submit" @click="handleSubmit" :disabled="isSubmitting">{{ isSubmitting ? '提交中...' : '确定' }}</button>
        </div>
      </div>
    </div>

    <!-- Toast 提示 -->
    <div v-if="toast.show" :class="['toast', toast.type]">
      {{ toast.message }}
    </div>

    <!-- 删除确认对话框 -->
    <div v-if="deleteConfirmModal" class="modal-overlay" @click.self="cancelDelete">
      <div class="confirm-modal-content">
        <div class="confirm-header">
          <h4>⚠️ 删除确认</h4>
        </div>
        <div class="confirm-body">
          <p>确定要删除此用户吗？删除后将无法恢复。</p>
        </div>
        <div class="confirm-footer">
          <button class="btn-cancel" @click="cancelDelete">取消</button>
          <button class="btn-delete-confirm" @click="confirmDelete">删除</button>
        </div>
      </div>
    </div>

    <!-- 状态切换确认对话框 -->
    <div v-if="statusToggleModal" class="modal-overlay" @click.self="cancelStatusToggle">
      <div class="confirm-modal-content">
        <div class="confirm-header">
          <h4>⚠️ 状态切换</h4>
        </div>
        <div class="confirm-body">
          <p>确定要{{ statusToggleUser?.status === 1 ? '禁用' : '启用' }}此用户吗？</p>
        </div>
        <div class="confirm-footer">
          <button class="btn-cancel" @click="cancelStatusToggle">取消</button>
          <button class="btn-submit" @click="confirmStatusToggle">确定</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { useUserStore } from '@/stores/userStore'
import { getUserById } from '@/api/user'

const userStore = useUserStore()

// 分页
const currentPage = ref(1)
const pageSize = ref(10)
const pagedUsers = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  return userStore.users.slice(start, start + pageSize.value)
})

// 模态框和表单数据
const showModal = ref(false)
const editingUser = ref(null)
const isSubmitting = ref(false)
const deleteConfirmModal = ref(false)
const deleteUserId = ref(null)
const statusToggleModal = ref(false)
const statusToggleUser = ref(null)
const searchKeyword = ref('')
const formData = reactive({
  username: '',
  name: '',
  password: '',
  phone: '',
  sex: '',
  memo: ''
})

// 角色相关
const roles = ref([])
const selectedRoleIds = ref([])

// Toast 提示
const toast = ref({
  show: false,
  message: '',
  type: 'success'
})

// 初始化：获取用户列表
userStore.fetchUsers()

// 显示 toast 提示
const showToast = (message, type = 'success') => {
  toast.value = { show: true, message, type }
  setTimeout(() => {
    toast.value.show = false
  }, 2000)
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN')
}

// 搜索用户
const handleSearch = async () => {
  if (!searchKeyword.value.trim()) {
    userStore.fetchUsers()
    return
  }
  await userStore.searchUsers(searchKeyword.value.trim())
}

// 新增用户
const handleAdd = async () => {
  editingUser.value = null
  formData.username = ''
  formData.name = ''
  formData.password = ''
  formData.phone = ''
  formData.sex = ''
  formData.memo = ''
  selectedRoleIds.value = []
  // 获取角色列表（通过查询任意用户获取）
  try {
    const res = await getUserById(1)
    if (res && res.code === 200 && res.data && res.data.roles) {
      roles.value = res.data.roles
    }
  } catch (err) {
    console.error('获取角色列表失败:', err)
  }
  showModal.value = true
}

// 编辑用户
const handleEdit = async (user) => {
  try {
    const res = await getUserById(user.id)
    if (res && res.code === 200 && res.data) {
      const userData = res.data.user
      editingUser.value = userData
      formData.username = userData.username
      formData.name = userData.name
      formData.password = ''
      formData.phone = userData.phone || ''
      formData.sex = userData.sex || ''
      formData.memo = userData.memo || ''
      // 设置角色列表和已选角色
      roles.value = res.data.roles || []
      selectedRoleIds.value = res.data.ownerRoleIds || []
      showModal.value = true
    } else {
      showToast('获取用户信息失败', 'error')
    }
  } catch (err) {
    console.error('获取用户信息失败:', err)
    showToast('获取用户信息失败', 'error')
  }
}

// 关闭模态框
const closeModal = () => {
  showModal.value = false
  editingUser.value = null
  formData.username = ''
  formData.name = ''
  formData.password = ''
  formData.phone = ''
  formData.sex = ''
  formData.memo = ''
  roles.value = []
  selectedRoleIds.value = []
}

// 提交表单
const handleSubmit = async () => {
  if (!formData.username.trim() || !formData.name.trim()) {
    showToast('用户名和姓名不能为空', 'error')
    return
  }

  isSubmitting.value = true
  try {
    if (editingUser.value) {
      // 更新用户
      const updateData = {
        id: editingUser.value.id,
        username: formData.username,
        name: formData.name,
        phone: formData.phone,
        sex: formData.sex,
        memo: formData.memo
      }
      if (formData.password) {
        updateData.password = formData.password
      }
      const success = await userStore.updateUserData(updateData, selectedRoleIds.value)
      if (success) {
        showToast('用户更新成功')
        closeModal()
      } else {
        showToast('用户更新失败', 'error')
      }
    } else {
      // 新增用户 - 检查用户名是否已存在
      const usernameExists = userStore.users.some(user => user.username === formData.username.trim())
      if (usernameExists) {
        showToast('该用户名已存在，请使用其他用户名', 'error')
        return
      }
      
      const newUser = {
        username: formData.username,
        name: formData.name,
        password: formData.password,
        phone: formData.phone,
        sex: formData.sex,
        memo: formData.memo,
        status: 1
      }
      const success = await userStore.addUser(newUser, selectedRoleIds.value)
      if (success) {
        showToast('用户新增成功')
        closeModal()
      } else {
        showToast('用户新增失败', 'error')
      }
    }
  } finally {
    isSubmitting.value = false
  }
}

// 删除用户
const handleDelete = (id) => {
  deleteUserId.value = id
  deleteConfirmModal.value = true
}

// 确认删除
const confirmDelete = async () => {
  if (deleteUserId.value) {
    const result = await userStore.removeUser(deleteUserId.value)
    if (result.success) {
      showToast('用户删除成功')
    } else {
      showToast(result.message || '用户删除失败', 'error')
    }
    deleteConfirmModal.value = false
    deleteUserId.value = null
  }
}

// 取消删除
const cancelDelete = () => {
  deleteConfirmModal.value = false
  deleteUserId.value = null
}

// 状态切换
const handleStatusToggle = (user) => {
  statusToggleUser.value = user
  statusToggleModal.value = true
}

// 确认状态切换
const confirmStatusToggle = async () => {
  if (statusToggleUser.value) {
    const success = await userStore.toggleUserStatus(statusToggleUser.value.id, statusToggleUser.value.status)
    if (success) {
      const action = statusToggleUser.value.status === 1 ? '禁用' : '启用'
      showToast(`用户${action}成功`)
    } else {
      showToast('状态更新失败', 'error')
    }
    statusToggleModal.value = false
    statusToggleUser.value = null
  }
}

// 取消状态切换
const cancelStatusToggle = () => {
  statusToggleModal.value = false
  statusToggleUser.value = null
}
</script>

<style scoped lang="scss">
.table-container {
  padding: 20px;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);

  .header-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;

    h3 {
      margin: 0;
      font-size: 18px;
      color: #333;
    }

    .toolbar {
      display: flex;
      gap: 10px;
      align-items: center;

      .search-box {
        display: flex;
        gap: 5px;

        input {
          padding: 8px 12px;
          border: 1px solid #ddd;
          border-radius: 4px;
          font-size: 14px;
          width: 180px;
          box-sizing: border-box;

          &:focus {
            outline: none;
            border-color: #2196f3;
            box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
          }
        }

        .btn-search {
          padding: 8px 12px;
          background-color: #2196f3;
          color: white;
          border: none;
          border-radius: 4px;
          cursor: pointer;
          font-size: 14px;
          transition: all 0.3s;

          &:hover {
            background-color: #1976d2;
            transform: translateY(-2px);
          }
        }
      }

      .btn-add {
        padding: 8px 16px;
        background-color: #999;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        transition: all 0.3s;

        &:hover {
          background-color: #777;
          transform: translateY(-2px);
        }
      }
    }
  }

  .loading,
  .error,
  .empty {
    padding: 20px;
    text-align: center;
    font-size: 14px;
    border-radius: 4px;
  }

  .loading {
    color: #1976d2;
    background-color: #e3f2fd;
  }

  .error {
    color: #c62828;
    background-color: #ffebee;
  }

  .empty {
    color: #666;
    background-color: #f5f5f5;
  }

  .data-table {
    width: 100%;
    border-collapse: collapse;

    thead {
      background-color: #f5f5f5;

      th {
        padding: 12px;
        text-align: left;
        font-weight: 600;
        color: #333;
        border-bottom: 2px solid #ddd;
      }
    }

    tbody {
      tr {
        border-bottom: 1px solid #eee;

        &:hover {
          background-color: #fafafa;
        }

        td {
          padding: 12px;
          color: #666;

          .status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;

            &.active {
              background-color: #e8f5e9;
              color: #2e7d32;
            }

            &.inactive {
              background-color: #ffebee;
              color: #c62828;
            }
          }

          .status-btn {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: all 0.3s;

            &.active {
              background-color: #e8f5e9;
              color: #2e7d32;

              &:hover {
                background-color: #c8e6c9;
              }
            }

            &.inactive {
              background-color: #ffebee;
              color: #c62828;

              &:hover {
                background-color: #ffcdd2;
              }
            }
          }

          .btn-edit,
          .btn-delete {
            margin: 0 4px;
            padding: 6px 12px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s;

            &:hover {
              transform: scale(1.05);
            }
          }

          .btn-edit {
            background-color: #2196f3;
            color: white;

            &:hover {
              background-color: #1976d2;
            }
          }

          .btn-delete {
            background-color: #f44336;
            color: white;

            &:hover {
              background-color: #da190b;
            }
          }
        }
      }
    }
  }

  .pagination {
    margin-top: 20px;
    display: flex;
    justify-content: center;
  }

  // 模态框样式
  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;

    .modal-content {
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
      width: 90%;
      max-width: 500px;

      .modal-header {
        padding: 20px;
        border-bottom: 1px solid #eee;
        display: flex;
        justify-content: space-between;
        align-items: center;

        h4 {
          margin: 0;
          font-size: 16px;
          color: #333;
        }

        .btn-close {
          background: none;
          border: none;
          font-size: 20px;
          cursor: pointer;
          color: #999;

          &:hover {
            color: #333;
          }
        }
      }

      .modal-body {
        padding: 20px;
        max-height: 60vh;
        overflow-y: auto;

        .form-group {
          margin-bottom: 20px;

          label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
            font-size: 14px;
          }

          input,
          select,
          textarea {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            font-family: inherit;
            box-sizing: border-box;

            &:focus {
              outline: none;
              border-color: #2196f3;
              box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
            }
          }

          textarea {
            resize: vertical;
            min-height: 80px;
          }

          &.role-section {
            border-top: 1px solid #eee;
            padding-top: 20px;
            margin-top: 10px;
          }

          .role-checkbox-group {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            padding: 12px;
            background-color: #fafafa;
            border-radius: 4px;
            border: 1px solid #eee;

            .role-checkbox-item {
              display: flex;
              align-items: center;
              gap: 6px;
              cursor: pointer;
              font-weight: normal;
              margin-bottom: 0;
              padding: 4px 8px;
              background-color: #fff;
              border-radius: 4px;
              border: 1px solid #ddd;
              transition: all 0.2s;

              &:hover {
                border-color: #2196f3;
              }

              input[type="checkbox"] {
                width: auto;
                cursor: pointer;
              }

              span {
                font-size: 14px;
                color: #333;
              }
            }
          }
        }
      }

      .modal-footer {
        padding: 20px;
        border-top: 1px solid #eee;
        display: flex;
        justify-content: flex-end;
        gap: 10px;

        button {
          padding: 8px 20px;
          border: none;
          border-radius: 4px;
          cursor: pointer;
          font-size: 14px;
          transition: all 0.3s;

          &:hover {
            transform: translateY(-2px);
          }

          &:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
          }
        }

        .btn-cancel {
          background-color: #e0e0e0;
          color: #333;

          &:hover:not(:disabled) {
            background-color: #d0d0d0;
          }
        }

        .btn-submit {
          background-color: #2196f3;
          color: white;

          &:hover:not(:disabled) {
            background-color: #1976d2;
          }
        }
      }
    }
  }

  // Toast 提示样式
  .toast {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    padding: 16px 24px;
    border-radius: 4px;
    color: white;
    font-size: 14px;
    z-index: 2000;
    animation: slideIn 0.3s ease-in-out;

    &.success {
      background-color: #666;
    }

    &.error {
      background-color: #555;
    }

    @keyframes slideIn {
      from {
        opacity: 0;
        transform: translate(-50%, -60%);
      }
      to {
        opacity: 1;
        transform: translate(-50%, -50%);
      }
    }
  }

  // 删除确认对话框样式
  .confirm-modal-content {
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
    width: 90%;
    max-width: 400px;
    z-index: 1001;

    .confirm-header {
      padding: 20px;
      border-bottom: 1px solid #eee;

      h4 {
        margin: 0;
        font-size: 16px;
        color: #333;
      }
    }

    .confirm-body {
      padding: 20px;

      p {
        margin: 0;
        font-size: 14px;
        color: #666;
        line-height: 1.6;
      }
    }

    .confirm-footer {
      padding: 20px;
      border-top: 1px solid #eee;
      display: flex;
      justify-content: flex-end;
      gap: 10px;

      button {
        padding: 8px 20px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        transition: all 0.3s;

        &:hover {
          transform: translateY(-2px);
        }
      }

      .btn-cancel {
        background-color: #e0e0e0;
        color: #333;

        &:hover {
          background-color: #d0d0d0;
        }
      }

      .btn-delete-confirm {
        background-color: #f44336;
        color: white;

        &:hover {
          background-color: #da190b;
        }
      }
    }
  }
}
</style>
