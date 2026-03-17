import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getRoleList, getRoleById, deleteRole, updateRole, insertRole } from '@/api/role'

export const useRoleStore = defineStore('role', () => {
  // 状态
  const roles = ref([])
  const loading = ref(false)
  const error = ref(null)

  // 获取角色列表
  const fetchRoles = async () => {
    loading.value = true
    error.value = null
    try {
      const response = await getRoleList()
      console.log('角色列表数据:', response)
      if (response && response.code === 200 && response.data) {
        roles.value = response.data
      }
    } catch (err) {
      console.error('获取角色列表失败:', err)
      error.value = err.message
    } finally {
      loading.value = false
    }
  }

  // 根据ID获取角色详情
  const fetchRoleById = async (id) => {
    try {
      const response = await getRoleById(id)
      console.log('角色详情:', response)
      if (response && response.code === 200 && response.data) {
        return response.data
      }
    } catch (err) {
      console.error('获取角色详情失败:', err)
      error.value = err.message
    }
  }

  // 删除角色
  const removeRole = async (id) => {
    try {
      const response = await deleteRole(id)
      console.log('删除角色响应:', response)
      // 后端返回 code 为 200 表示成功
      if (response && (response.code === 200 || response.code === '200')) {
        // 删除成功，从列表中移除
        roles.value = roles.value.filter(role => role.id !== id)
        return true
      } else {
        error.value = response?.message || '删除失败'
        return false
      }
    } catch (err) {
      console.error('删除角色失败:', err)
      error.value = err.message || '删除失败'
      return false
    }
  }

  // 更新角色
  const updateRoleData = async (role) => {
    try {
      const response = await updateRole(role)
      console.log('更新角色响应:', response)
      if (response && response.code === 200) {
        // 更新成功，刷新列表
        await fetchRoles()
        return true
      }
    } catch (err) {
      console.error('更新角色失败:', err)
      error.value = err.message
    }
    return false
  }

  // 新增角色
  const addRole = async (role) => {
    try {
      const response = await insertRole(role)
      console.log('新增角色响应:', response)
      if (response && response.code === 200) {
        // 新增成功，刷新列表
        await fetchRoles()
        return true
      }
    } catch (err) {
      console.error('新增角色失败:', err)
      error.value = err.message
    }
    return false
  }

  return {
    roles,
    loading,
    error,
    fetchRoles,
    fetchRoleById,
    removeRole,
    updateRoleData,
    addRole
  }
})
