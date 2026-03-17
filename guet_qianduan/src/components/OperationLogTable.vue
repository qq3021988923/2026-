<template>
  <div class="log-container">
    <el-card class="header-card" shadow="never">
      <template #header>
        <div class="page-header">
          <span class="subtitle">系统操作记录查询</span>
        </div>
      </template>
      <el-form :inline="true" :model="searchParams" class="search-form">
        <el-form-item label="操作模块">
          <el-select v-model="searchParams.module" placeholder="全部" clearable style="width: 120px">
            <el-option label="全部" value="" />
            <el-option label="用户管理" value="用户管理" />
            <el-option label="角色管理" value="角色管理" />
            <el-option label="客户管理" value="客户管理" />
            <el-option label="订单管理" value="订单管理" />
            <el-option label="物流管理" value="物流管理" />
            <el-option label="系统" value="系统" />
          </el-select>
        </el-form-item>
        <el-form-item label="操作类型">
          <el-input v-model="searchParams.operation" placeholder="请输入操作类型" clearable style="width: 150px" />
        </el-form-item>
        <el-form-item label="操作用户">
          <el-input v-model="searchParams.username" placeholder="请输入用户名" clearable style="width: 150px" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchParams.status" placeholder="全部" clearable style="width: 100px">
            <el-option label="全部" value="" />
            <el-option label="成功" value="1" />
            <el-option label="失败" value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button @click="handleReset">
            <el-icon><Refresh /></el-icon>
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card" shadow="never">
      <template #header>
        <div class="action-bar">
          <el-button v-if="isAdmin" type="danger" @click="handleClear" :disabled="logList.length === 0">
            <el-icon><Delete /></el-icon>
            清空日志
          </el-button>
          <span class="total-info">共 {{ total }} 条记录</span>
        </div>
      </template>

      <el-table :data="logList" stripe style="width: 100%">
        <el-table-column type="index" label="序号" width="70" :index="indexMethod" />
        <el-table-column prop="module" label="操作模块" :width="isAdmin ? 100 : 120">
          <template #default="{ row }">
            <el-tag :type="getModuleType(row.module)" size="small">
              {{ row.module || '-' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="operation" label="操作类型" :width="isAdmin ? 100 : 140" />
        <el-table-column prop="username" label="操作用户" :width="isAdmin ? 100 : 120" />
        <el-table-column prop="ip" label="IP地址" :width="isAdmin ? 120 : 150" />
        <el-table-column prop="status" label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
              {{ row.status === 1 ? '成功' : '失败' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column v-if="isAdmin" prop="method" label="请求方法" min-width="150">
          <template #default="{ row }">
            <el-tooltip :content="row.method" placement="top" :disabled="!row.method">
              <span class="method-text">{{ formatMethod(row.method) }}</span>
            </el-tooltip>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="操作时间" :width="isAdmin ? 160 : 200">
          <template #default="{ row }">
            {{ formatDate(row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column v-if="isAdmin" label="操作" width="80" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="showDetail(row)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        class="pagination"
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50]"
        :total="total"
        layout="total, sizes, prev, pager, next, jumper"
        background
        @current-change="fetchLogs"
        @size-change="handlePageSizeChange"
      />
    </el-card>

    <el-dialog 
      v-model="showDetailModal" 
      title="日志详情" 
      width="600px" 
      destroy-on-close 
      close-on-click-modal="false"
      modal-class="log-detail-dialog"
      append-to-body
    >
      <el-descriptions :column="2" border>
        <el-descriptions-item label="操作模块">{{ currentLog.module || '-' }}</el-descriptions-item>
        <el-descriptions-item label="操作类型">{{ currentLog.operation || '-' }}</el-descriptions-item>
        <el-descriptions-item label="操作用户">{{ currentLog.username || '-' }}</el-descriptions-item>
        <el-descriptions-item label="用户ID">{{ currentLog.userId || '-' }}</el-descriptions-item>
        <el-descriptions-item label="IP地址">{{ currentLog.ip || '-' }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="currentLog.status === 1 ? 'success' : 'danger'" size="small">
            {{ currentLog.status === 1 ? '成功' : '失败' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="操作时间" :span="2">{{ formatDate(currentLog.createTime) }}</el-descriptions-item>
        <el-descriptions-item label="请求方法" :span="2">
          <code class="code-text">{{ currentLog.method || '-' }}</code>
        </el-descriptions-item>
        <el-descriptions-item label="请求参数" :span="2">
          <pre class="params-pre">{{ formatParams(currentLog.params) }}</pre>
        </el-descriptions-item>
        <el-descriptions-item v-if="currentLog.status === 0" label="错误信息" :span="2">
          <span class="error-text">{{ currentLog.errorMsg || '-' }}</span>
        </el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="showDetailModal = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getOperationLogPage, clearOperationLog } from '@/api/operationLog'

const logList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const showDetailModal = ref(false)
const currentLog = ref({})
const isAdmin = ref(false)

const searchParams = ref({
  module: '',
  operation: '',
  username: '',
  status: ''
})

const totalPages = computed(() => Math.ceil(total.value / pageSize.value) || 1)

onMounted(() => {
  const permission = JSON.parse(localStorage.getItem('permission') || '[]')
  isAdmin.value = permission.includes('平台管理员')
  fetchLogs()
})

const indexMethod = (index) => {
  return (currentPage.value - 1) * pageSize.value + index + 1
}

const fetchLogs = async () => {
  try {
    const params = {
      page: currentPage.value,
      size: pageSize.value,
      ...searchParams.value
    }
    Object.keys(params).forEach(key => {
      if (params[key] === '') delete params[key]
    })
    
    const res = await getOperationLogPage(params)
    if (res.code === 200) {
      logList.value = res.data.records || res.data || []
      total.value = res.data.total || logList.value.length
    }
  } catch (error) {
    console.error('获取日志失败:', error)
  }
}

const handleSearch = () => {
  currentPage.value = 1
  fetchLogs()
}

const handleReset = () => {
  searchParams.value = { module: '', operation: '', username: '', status: '' }
  currentPage.value = 1
  fetchLogs()
}

const handleClear = async () => {
  try {
    await ElMessageBox.confirm('确定要清空所有操作日志吗？此操作不可恢复！', '警告', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const res = await clearOperationLog()
    if (res.code === 200) {
      ElMessage.success('清空成功')
      fetchLogs()
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('清空失败:', error)
    }
  }
}

const handlePageSizeChange = () => {
  currentPage.value = 1
  fetchLogs()
}

const showDetail = (log) => {
  currentLog.value = log
  showDetailModal.value = true
}

const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleString('zh-CN')
}

const formatMethod = (method) => {
  if (!method) return '-'
  const parts = method.split('.')
  return parts.length > 1 ? `...${parts.slice(-2).join('.')}` : method
}

const formatParams = (params) => {
  if (!params) return '-'
  try {
    return JSON.stringify(JSON.parse(params), null, 2)
  } catch {
    return params
  }
}

const getModuleType = (module) => {
  const map = {
    '用户管理': 'primary',
    '角色管理': 'warning',
    '客户管理': 'success',
    '订单管理': 'info',
    '物流管理': '',
    '系统': 'danger'
  }
  return map[module] || 'info'
}
</script>

<style scoped lang="scss">
.log-container {
  .header-card {
    margin-bottom: 16px;

    :deep(.el-card__header) {
      padding: 16px;
      border-bottom: 1px solid #ebeef5;
    }

    :deep(.el-card__body) {
      padding: 16px;
    }

    .page-header {
      display: flex;
      align-items: center;
      gap: 12px;

      h3 {
        margin: 0;
        font-size: 18px;
        color: #303133;
      }

      .subtitle {
        font-size: 13px;
        color: #909399;
      }
    }

    .search-form {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
    }
  }

  .table-card {
    :deep(.el-card__header) {
      padding: 12px 16px;
    }

    :deep(.el-card__body) {
      padding: 16px;
    }

    .action-bar {
      display: flex;
      align-items: center;
      gap: 16px;

      .total-info {
        color: #909399;
        font-size: 14px;
      }
    }

    .method-text {
      color: #909399;
      font-size: 12px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      display: block;
    }
  }

  .pagination {
    margin-top: 16px;
    display: flex;
    justify-content: center;
  }

  .code-text {
    font-family: monospace;
    font-size: 12px;
    color: #606266;
    background: #f5f7fa;
    padding: 2px 6px;
    border-radius: 4px;
  }

  .params-pre {
    background: #f5f7fa;
    padding: 10px;
    border-radius: 4px;
    font-size: 12px;
    overflow-x: auto;
    max-height: 200px;
    margin: 0;
    font-family: monospace;
  }

  .error-text {
    color: #f56c6c;
    font-size: 13px;
  }
}

:deep(.log-detail-dialog) {
  .el-dialog__body {
    padding: 20px !important;
  }
}
</style>
