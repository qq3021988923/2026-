import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getUserList, searchUser, insertUser, updateUser, deleteUser, disableUser, enableUser } from '@/api/user'

export const useUserStore = defineStore('user', () => {
  // 状态
  const users = ref([])
  const loading = ref(false)
  const error = ref(null)

  // 获取用户列表
  const fetchUsers = async () => {
    loading.value = true
    error.value = null
    try {
      const response = await getUserList()
      console.log('用户列表数据:', response)
      if (response && response.code === 200 && response.data) {
        users.value = response.data
      }
    } catch (err) {
      console.error('获取用户列表失败:', err)
      error.value = err.message
    } finally {
      loading.value = false
    }
  }

  // 搜索用户
  const searchUsers = async (keyword) => {
    loading.value = true
    error.value = null
    try {
      const response = await searchUser({ username: keyword })
      console.log('搜索结果:', response)
      if (response && response.code === 200 && response.data) {
        users.value = response.data
      }
    } catch (err) {
      console.error('搜索用户失败:', err)
      error.value = err.message
    } finally {
      loading.value = false
    }
  }

  // 新增用户
  const addUser = async (userData, roleIds = []) => {
    try {
      const response = await insertUser({ user: userData, roleIds })
      console.log('新增用户响应:', response)
      if (response && (response.code === 200 || response.code === '200')) {
        await fetchUsers()
        return true
      } else {
        error.value = response?.message || '新增失败'
        return false
      }
    } catch (err) {
      console.error('新增用户失败:', err)
      error.value = err.message || '新增失败'
      return false
    }
  }

  // 更新用户
  const updateUserData = async (userData, roleIds = []) => {
    try {
      const response = await updateUser({ user: userData, roleIds })
      console.log('更新用户响应:', response)
      if (response && (response.code === 200 || response.code === '200')) {
        await fetchUsers()
        return true
      } else {
        error.value = response?.message || '更新失败'
        return false
      }
    } catch (err) {
      console.error('更新用户失败:', err)
      error.value = err.message || '更新失败'
      return false
    }
  }

  // 删除用户
  const removeUser = async (id) => {
    try {
      const response = await deleteUser(id)
      console.log('删除用户响应:', response)
      if (response && (response.code === 200 || response.code === '200')) {
        users.value = users.value.filter(user => user.id !== id)
        return { success: true }
      } else {
        return { success: false, message: response?.message || '删除失败' }
      }
    } catch (err) {
      console.error('删除用户失败:', err)
      return { success: false, message: err.message || '删除失败' }
    }
  }

  // 切换用户状态
  const toggleUserStatus = async (id, currentStatus) => {
    try {
      let response
      if (currentStatus === 1) {
        // 当前是启用状态，调用禁用接口
        response = await disableUser(id)
      } else {
        // 当前是禁用状态，调用启用接口
        response = await enableUser(id)
      }
      console.log('更新用户状态响应:', response)
      if (response && response.code === 200) {
        // 更新本地用户数据中的状态
        const user = users.value.find(u => u.id === id)
        if (user) {
          user.status = currentStatus === 1 ? 0 : 1
        }
        return true
      } else {
        error.value = response?.message || '状态更新失败'
        return false
      }
    } catch (err) {
      console.error('更新用户状态失败:', err)
      error.value = err.message || '状态更新失败'
      return false
    }
  }

  return {
    users,
    loading,
    error,
    fetchUsers,
    searchUsers,
    addUser,
    updateUserData,
    removeUser,
    toggleUserStatus
  }
})

