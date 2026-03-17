<template>
  <div class="table-container">
    <div class="header-section">
      <!-- 操作按钮 -->
      <div class="toolbar">
        <button class="btn-add" @click="handleAdd">➕ 新增角色</button>
      </div>
    </div>

    <!-- 加载状态 -->
    <div v-if="roleStore.loading" class="loading">加载中...</div>

    <!-- 错误信息 -->
    <div v-if="roleStore.error" class="error">{{ roleStore.error }}</div>

    <!-- 数据表格 -->
    <table v-if="!roleStore.loading && roleStore.roles.length > 0" class="data-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>角色名称</th>
          <th>描述</th>
          <th>创建时间</th>
          <th>更新时间</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="role in pagedRoles" :key="role.id">
          <td>{{ role.id }}</td>
          <td>{{ role.roleName }}</td>
          <td>{{ role.memo || '-' }}</td>
          <td>{{ formatDate(role.createTime) }}</td>
          <td>{{ formatDate(role.updateTime) }}</td>
          <td>
            <button class="btn-edit" @click="handleEdit(role)">编辑</button>
            <button class="btn-delete" @click="handleDelete(role.id)">删除</button>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- 空状态 -->
    <div v-if="!roleStore.loading && roleStore.roles.length === 0" class="empty">
      暂无角色数据
    </div>

    <!-- 分页 -->
    <el-pagination
      v-if="roleStore.roles.length > 0"
      class="pagination"
      v-model:current-page="currentPage"
      v-model:page-size="pageSize"
      :page-sizes="[10, 20, 50]"
      :total="roleStore.roles.length"
      layout="total, sizes, prev, pager, next, jumper"
      background
    />

    <!-- 编辑模态框 -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <div class="modal-header">
          <h4>{{ editingRole ? '编辑角色' : '新增角色' }}</h4>
          <button class="btn-close" @click="closeModal">✕</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>角色名称</label>
            <input v-model="formData.roleName" type="text" placeholder="请输入角色名称">
          </div>
          <div class="form-group">
            <label>角色代码</label>
            <input v-model="formData.roleCode" type="text" placeholder="请输入角色代码">
          </div>
          <div class="form-group">
            <label>描述</label>
            <textarea v-model="formData.memo" placeholder="请输入描述"></textarea>
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
          <p>确定要删除此角色吗？删除后将无法恢复。</p>
        </div>
        <div class="confirm-footer">
          <button class="btn-cancel" @click="cancelDelete">取消</button>
          <button class="btn-delete-confirm" @click="confirmDelete">删除</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { useRoleStore } from '@/stores/roleStore'

const roleStore = useRoleStore()

// 分页
const currentPage = ref(1)
const pageSize = ref(10)
const pagedRoles = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  return roleStore.roles.slice(start, start + pageSize.value)
})

// 模态框和表单数据
const showModal = ref(false)
const editingRole = ref(null)
const isSubmitting = ref(false)
const deleteConfirmModal = ref(false)
const deleteRoleId = ref(null)
const formData = reactive({
  roleName: '',
  roleCode: '',
  memo: ''
})

// Toast 提示
const toast = reactive({
  show: false,
  message: '',
  type: 'success'
})

// 初始化：获取角色列表
roleStore.fetchRoles()

// 显示 toast 提示
const showToast = (message, type = 'success', duration = 2000) => {
  toast.message = message
  toast.type = type
  toast.show = true
  setTimeout(() => {
    toast.show = false
  }, duration)
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN')
}

// 新增角色
const handleAdd = () => {
  editingRole.value = null
  formData.roleName = ''
  formData.roleCode = ''
  formData.memo = ''
  showModal.value = true
}

// 编辑角色
const handleEdit = (role) => {
  editingRole.value = role
  formData.roleName = role.roleName
  formData.roleCode = role.roleCode || ''
  formData.memo = role.memo || ''
  showModal.value = true
}

// 关闭模态框
const closeModal = () => {
  showModal.value = false
  editingRole.value = null
  formData.roleName = ''
  formData.roleCode = ''
  formData.memo = ''
}

// 提交表单
const handleSubmit = async () => {
  if (!formData.roleName.trim()) {
    showToast('角色名称不能为空', 'error')
    return
  }

  isSubmitting.value = true
  try {
    if (editingRole.value) {
      // 更新角色
      const updateData = {
        id: editingRole.value.id,
        roleName: formData.roleName,
        roleCode: formData.roleCode,
        memo: formData.memo
      }
      const success = await roleStore.updateRoleData(updateData)
      if (success) {
        showToast('角色更新成功')
        closeModal()
      } else {
        showToast('角色更新失败', 'error')
      }
    } else {
      // 新增角色
      const newRole = {
        roleName: formData.roleName,
        roleCode: formData.roleCode,
        memo: formData.memo
      }
      const success = await roleStore.addRole(newRole)
      if (success) {
        showToast('角色新增成功')
        closeModal()
      } else {
        showToast('角色新增失败', 'error')
      }
    }
  } finally {
    isSubmitting.value = false
  }
}

// 删除角色
const handleDelete = async (id) => {
  deleteRoleId.value = id
  deleteConfirmModal.value = true
}

// 确认删除
const confirmDelete = async () => {
  if (deleteRoleId.value) {
    const success = await roleStore.removeRole(deleteRoleId.value)
    if (success) {
      showToast('角色删除成功')
    } else {
      showToast('角色删除失败', 'error')
    }
    deleteConfirmModal.value = false
    deleteRoleId.value = null
  }
}

// 取消删除
const cancelDelete = () => {
  deleteConfirmModal.value = false
  deleteRoleId.value = null
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
