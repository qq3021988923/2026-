<template>
  <div class="basic-data">
    <div class="header-section">
      <div class="toolbar">
        <button class="btn-add" @click="openAddModal(0)">➕ 新增大类</button>
      </div>
    </div>

    <table class="data-table">
        <thead>
          <tr>
            <th width="80">编号</th>
            <th>数据名称</th>
            <th>数据描述</th>
            <th width="100">父数据编号</th>
            <th width="180">操作</th>
          </tr>
        </thead>
        <tbody>
          <template v-for="parent in parentList" :key="parent.baseId">
            <!-- 父级数据 -->
            <tr class="parent-row">
              <td>{{ parent.baseId }}</td>
              <td class="name-cell">
                <span class="expand-icon" @click="toggleExpand(parent.baseId)">
                  {{ expandedIds.includes(parent.baseId) ? '▼' : '▶' }}
                </span>
                {{ parent.baseName }}
              </td>
              <td>{{ parent.baseDesc || '-' }}</td>
              <td>{{ parent.parentId }}</td>
              <td>
                <button class="btn-link" @click="openEditModal(parent)">更新</button>
                <button class="btn-link" @click="openAddModal(parent.baseId)">添加子项</button>
                <button class="btn-link danger" @click="handleDelete(parent.baseId)">删除</button>
              </td>
            </tr>
            <!-- 子级数据 -->
            <template v-if="expandedIds.includes(parent.baseId)">
              <tr v-for="child in getChildren(parent.baseId)" :key="child.baseId" class="child-row">
                <td class="indent">{{ child.baseId }}</td>
                <td class="indent">{{ child.baseName }}</td>
                <td>{{ child.baseDesc || '-' }}</td>
                <td>{{ child.parentId }}</td>
                <td>
                  <button class="btn-link" @click="openEditModal(child)">更新</button>
                  <button class="btn-link danger" @click="handleDelete(child.baseId)">删除</button>
                </td>
              </tr>
            </template>
          </template>
          <tr v-if="parentList.length === 0 && !loading">
            <td colspan="5" class="empty-text">暂无数据</td>
          </tr>
        </tbody>
    </table>
    <div v-if="loading" class="loading">加载中...</div>

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
          <p>确定要删除此数据吗？删除后将无法恢复。</p>
        </div>
        <div class="confirm-footer">
          <button class="btn-cancel" @click="cancelDelete">取消</button>
          <button class="btn-delete-confirm" @click="confirmDelete">删除</button>
        </div>
      </div>
    </div>

    <!-- 新增/编辑弹窗 -->
    <div v-if="showModal" class="modal-overlay" @click.self="showModal = false">
      <div class="modal-content">
        <div class="modal-header">
          <h4>{{ isEdit ? '编辑数据' : '新增数据' }}</h4>
          <button class="btn-close" @click="showModal = false">✕</button>
        </div>
        <div class="modal-body">
          <div class="form-item">
            <label>数据名称</label>
            <input v-model="formData.baseName" placeholder="请输入数据名称" />
          </div>
          <div class="form-item">
            <label>数据描述</label>
            <input v-model="formData.baseDesc" placeholder="请输入数据描述" />
          </div>
          <div class="form-item">
            <label>父级数据</label>
            <select v-model="formData.parentId" :disabled="isEdit">
              <option :value="0">无（作为大类）</option>
              <option v-for="p in parentList" :key="p.baseId" :value="p.baseId">
                {{ p.baseName }}
              </option>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-cancel" @click="showModal = false">取消</button>
          <button class="btn-confirm" @click="handleSubmit">确定</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { getBasicList, insertBasic, updateBasic, deleteBasic } from '@/api/basic'

const dataList = ref([])
const loading = ref(false)
const showModal = ref(false)
const isEdit = ref(false)
const expandedIds = ref([])
const formData = ref({
  baseId: null,
  baseName: '',
  baseDesc: '',
  parentId: 0
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
const deleteId = ref(null)

// 获取所有父级数据（parentId 为 0）
const parentList = computed(() => {
  return dataList.value.filter(item => item.parentId === 0)
})

// 获取某个父级下的子数据
const getChildren = (parentId) => {
  return dataList.value.filter(item => item.parentId === parentId)
}

// 展开/收起
const toggleExpand = (id) => {
  const index = expandedIds.value.indexOf(id)
  if (index > -1) {
    expandedIds.value.splice(index, 1)
  } else {
    expandedIds.value.push(id)
  }
}

// 获取数据列表
const fetchData = async () => {
  loading.value = true
  try {
    const res = await getBasicList()
    if (res && res.code === 200) {
      dataList.value = res.data || []
      // 默认展开所有父级
      expandedIds.value = parentList.value.map(p => p.baseId)
    }
  } catch (err) {
    console.error('获取基础数据失败:', err)
  } finally {
    loading.value = false
  }
}

// 打开新增弹窗
const openAddModal = (parentId = 0) => {
  isEdit.value = false
  formData.value = {
    baseId: null,
    baseName: '',
    baseDesc: '',
    parentId
  }
  showModal.value = true
}

// 打开编辑弹窗
const openEditModal = (item) => {
  isEdit.value = true
  formData.value = { ...item }
  showModal.value = true
}

// 提交表单
const handleSubmit = async () => {
  if (!formData.value.baseName.trim()) {
    showToast('请输入数据名称', 'error')
    return
  }
  try {
    let res
    if (isEdit.value) {
      res = await updateBasic(formData.value)
    } else {
      res = await insertBasic(formData.value)
    }
    if (res && res.code === 200) {
      showModal.value = false
      showToast(isEdit.value ? '数据更新成功' : '数据新增成功')
      fetchData()
    } else {
      showToast(res?.message || '操作失败', 'error')
    }
  } catch (err) {
    console.error('操作失败:', err)
    showToast('操作失败', 'error')
  }
}

// 删除
const handleDelete = (id) => {
  // 检查是否有子数据
  const children = getChildren(id)
  if (children.length > 0) {
    showToast('该数据下有子数据，请先删除子数据', 'error')
    return
  }
  deleteId.value = id
  deleteConfirmModal.value = true
}

// 确认删除
const confirmDelete = async () => {
  try {
    const res = await deleteBasic(deleteId.value)
    if (res && res.code === 200) {
      showToast('数据删除成功')
      fetchData()
    } else {
      showToast(res?.message || '删除失败', 'error')
    }
  } catch (err) {
    console.error('删除失败:', err)
    showToast('删除失败', 'error')
  } finally {
    deleteConfirmModal.value = false
    deleteId.value = null
  }
}

// 取消删除
const cancelDelete = () => {
  deleteConfirmModal.value = false
  deleteId.value = null
}

onMounted(() => {
  fetchData()
})
</script>


<style scoped lang="scss">
.basic-data {
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
      .parent-row {
        background-color: #fafafa;
        font-weight: 500;

        &:hover {
          background-color: #f0f0f0;
        }
      }

      .child-row {
        &:hover {
          background-color: #fafafa;
        }
      }

      tr {
        border-bottom: 1px solid #eee;

        td {
          padding: 12px;
          font-size: 13px;
          color: #666;

          &.indent {
            padding-left: 40px;
          }

          &.name-cell {
            .expand-icon {
              cursor: pointer;
              margin-right: 8px;
              font-size: 10px;
              color: #999;
            }
          }
        }

        .empty-text {
          text-align: center;
          color: #999;
          padding: 30px;
        }
      }

      .btn-link {
        background: none;
        border: none;
        color: #667eea;
        cursor: pointer;
        font-size: 13px;
        margin-right: 10px;

        &:hover {
          text-decoration: underline;
        }

        &.danger {
          color: #f56c6c;
        }
      }
    }
  }

  .loading {
    text-align: center;
    padding: 20px;
    color: #999;
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
    max-width: 450px;

    .modal-header {
      padding: 16px 20px;
      border-bottom: 1px solid #eee;
      display: flex;
      justify-content: space-between;
      align-items: center;

      h4 {
        margin: 0;
        font-size: 16px;
      }

      .btn-close {
        background: none;
        border: none;
        font-size: 18px;
        cursor: pointer;
        color: #999;

        &:hover {
          color: #333;
        }
      }
    }

    .modal-body {
      padding: 20px;

      .form-item {
        margin-bottom: 16px;

        label {
          display: block;
          margin-bottom: 6px;
          font-size: 14px;
          color: #333;
        }

        input, select {
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

          &:disabled {
            background-color: #f5f5f5;
          }
        }
      }
    }

    .modal-footer {
      padding: 16px 20px;
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

      .btn-confirm {
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
