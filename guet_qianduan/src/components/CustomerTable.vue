<template>
  <div class="table-container">
    <div class="header-section">
      <div class="toolbar">
        <div class="search-box">
          <input 
            v-model="searchKeyword" 
            type="text" 
            placeholder="按姓名搜索"
            @keyup.enter="handleSearch"
          >
          <button class="btn-search" @click="handleSearch">🔍 搜索</button>
        </div>
        <button class="btn-add" @click="openAddModal">➕ 新增客户</button>
      </div>
    </div>

    <div v-if="loading" class="loading">加载中...</div>
    <div v-else-if="error" class="error">{{ error }}</div>

    <table v-else class="data-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>姓名</th>
          <th>电话</th>
          <th>邮箱</th>
          <th>地址</th>
          <th>性别</th>
          <th>描述</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="customer in pagedCustomers" :key="customer.id">
          <td>{{ customer.id }}</td>
          <td>{{ customer.name || '-' }}</td>
          <td>{{ customer.phone || '-' }}</td>
          <td>{{ customer.email || '-' }}</td>
          <td>{{ customer.address || '-' }}</td>
          <td>{{ customer.sex || '-' }}</td>
          <td>{{ customer.desc || '-' }}</td>
          <td>
            <button class="btn-edit" @click="openEditModal(customer)">编辑</button>
            <button class="btn-delete" @click="handleDelete(customer.id)">删除</button>
          </td>
        </tr>
        <tr v-if="customers.length === 0">
          <td colspan="8" class="empty">暂无数据</td>
        </tr>
      </tbody>
    </table>

    <!-- 分页 -->
    <el-pagination
      v-if="customers.length > 0"
      class="pagination"
      v-model:current-page="currentPage"
      v-model:page-size="pageSize"
      :page-sizes="[10, 20, 50]"
      :total="customers.length"
      layout="total, sizes, prev, pager, next, jumper"
      background
    />

    <!-- 新增/编辑弹窗 -->
    <div v-if="showModal" class="modal-overlay" @click.self="showModal = false">
      <div class="modal-content">
        <div class="modal-header">
          <h4>{{ isEdit ? '编辑客户' : '新增客户' }}</h4>
          <button class="btn-close" @click="showModal = false">✕</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>姓名</label>
            <input v-model="formData.name" placeholder="请输入姓名" />
          </div>
          <div class="form-group">
            <label>电话</label>
            <input v-model="formData.phone" placeholder="请输入电话" />
          </div>
          <div class="form-group">
            <label>邮箱</label>
            <input v-model="formData.email" placeholder="请输入邮箱" />
          </div>
          <div class="form-group">
            <label>地址</label>
            <input v-model="formData.address" placeholder="请输入地址" />
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
            <textarea v-model="formData.desc" placeholder="请输入描述"></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-cancel" @click="showModal = false">取消</button>
          <button class="btn-submit" @click="handleSubmit">确定</button>
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
          <p>确定要删除此客户吗？删除后将无法恢复。</p>
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
import { ref, computed, onMounted } from 'vue'
import { getCustomerList, searchCustomer, insertCustomer, updateCustomer, deleteCustomer } from '@/api/customer'

const customers = ref([])
const loading = ref(false)
const error = ref(null)

// 分页
const currentPage = ref(1)
const pageSize = ref(10)
const pagedCustomers = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  return customers.value.slice(start, start + pageSize.value)
})
const searchKeyword = ref('')
const showModal = ref(false)
const isEdit = ref(false)
const formData = ref({
  id: null,
  name: '',
  phone: '',
  email: '',
  address: '',
  sex: '',
  desc: ''
})

// Toast 提示
const toast = ref({
  show: false,
  message: '',
  type: 'success'
})

const showToast = (message, type = 'success') => {
  toast.value = { show: true, message, type }
  setTimeout(() => {
    toast.value.show = false
  }, 2000)
}

// 删除确认弹窗
const deleteConfirmModal = ref(false)
const deleteCustomerId = ref(null)

// 获取客户列表
const fetchCustomers = async () => {
  loading.value = true
  error.value = null
  try {
    const userId = localStorage.getItem('userId')
    const res = await getCustomerList(userId)
    if (res && res.code === 200) {
      customers.value = res.data || []
    }
  } catch (err) {
    console.error('获取客户列表失败:', err)
    error.value = err.message
  } finally {
    loading.value = false
  }
}

// 搜索客户
const handleSearch = async () => {
  if (!searchKeyword.value.trim()) {
    fetchCustomers()
    return
  }
  loading.value = true
  error.value = null
  try {
    const res = await searchCustomer({ name: searchKeyword.value.trim() })
    if (res && res.code === 200) {
      customers.value = res.data || []
    }
  } catch (err) {
    console.error('搜索客户失败:', err)
    error.value = err.message
  } finally {
    loading.value = false
  }
}

// 打开新增弹窗
const openAddModal = () => {
  isEdit.value = false
  formData.value = { id: null, name: '', phone: '', email: '', address: '', sex: '', desc: '' }
  showModal.value = true
}

// 打开编辑弹窗
const openEditModal = (customer) => {
  isEdit.value = true
  formData.value = { ...customer }
  showModal.value = true
}

// 提交表单
const handleSubmit = async () => {
  if (!formData.value.name?.trim()) {
    alert('请输入姓名')
    return
  }
  try {
    let res
    if (isEdit.value) {
      res = await updateCustomer(formData.value)
    } else {
      // 新增时带上当前登录用户的 id 作为 userId，不传 id 字段
      // 空字符串转 null，避免数据库类型错误
      const userId = localStorage.getItem('userId')
      const { id, ...rest } = formData.value
      const data = {
        name: rest.name || null,
        phone: rest.phone || null,
        email: rest.email || null,
        address: rest.address || null,
        sex: rest.sex || null,
        desc: rest.desc || null,
        userId: Number(userId)
      }
      res = await insertCustomer(data)
    }
    if (res && res.code === 200) {
      showModal.value = false
      showToast(isEdit.value ? '客户更新成功' : '客户新增成功')
      fetchCustomers()
    } else {
      showToast(res?.message || '操作失败', 'error')
    }
  } catch (err) {
    console.error('操作失败:', err)
    showToast('操作失败', 'error')
  }
}

// 删除客户
const handleDelete = (id) => {
  deleteCustomerId.value = id
  deleteConfirmModal.value = true
}

// 确认删除
const confirmDelete = async () => {
  try {
    const res = await deleteCustomer(deleteCustomerId.value)
    if (res && res.code === 200) {
      showToast('客户删除成功')
      fetchCustomers()
    } else {
      showToast(res?.message || '删除失败', 'error')
    }
  } catch (err) {
    console.error('删除失败:', err)
    showToast('删除失败', 'error')
  } finally {
    deleteConfirmModal.value = false
    deleteCustomerId.value = null
  }
}

// 取消删除
const cancelDelete = () => {
  deleteConfirmModal.value = false
  deleteCustomerId.value = null
}

onMounted(() => {
  fetchCustomers()
})
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
    text-align: center;
    padding: 40px;
    font-size: 14px;
    color: #999;
  }

  .error {
    color: #f44336;
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
}

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
        margin-bottom: 16px;

        label {
          display: block;
          margin-bottom: 6px;
          font-size: 14px;
          color: #333;
        }

        input,
        select,
        textarea {
          width: 100%;
          padding: 8px 12px;
          border: 1px solid #ddd;
          border-radius: 4px;
          font-size: 14px;
          box-sizing: border-box;

          &:focus {
            outline: none;
            border-color: #667eea;
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

      .btn-cancel {
        padding: 8px 16px;
        background: #f5f5f5;
        border: 1px solid #ddd;
        border-radius: 4px;
        cursor: pointer;

        &:hover {
          background: #eee;
        }
      }

      .btn-submit {
        padding: 8px 16px;
        background: #667eea;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;

        &:hover {
          background: #5568d3;
        }
      }
    }
  }
}

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

.confirm-modal-content {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  width: 90%;
  max-width: 400px;

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
</style>
