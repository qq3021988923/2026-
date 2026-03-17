import request from './request'

// 完整的登录接口
export const login = (username, password) => {
  return request.post('/user/login', { username, password })
}

// 获取用户列表
export const getUserList = () => {
  return request.get('/user/query')
}

// 根据ID查询用户
export const getUserById = (id) => {
  return request.get(`/user/select/${id}`)
}

// 搜索用户（用户名模糊查询）
export const searchUser = (guetUser) => {
  return request.post('/user/search', guetUser)
}

// 新增/更新用户（统一接口）
export const saveUser = (guetUser) => {
  return request.post('/user/save', guetUser)
}

// 新增用户（兼容旧代码）
export const insertUser = (guetUser) => {
  return request.post('/user/save', guetUser)
}

// 更新用户（兼容旧代码）
export const updateUser = (guetUser) => {
  return request.post('/user/save', guetUser)
}

// 删除用户
export const deleteUser = (id) => {
  return request.get(`/user/pydelete/${id}`)
}

// 禁用用户（status=0）
export const disableUser = (id) => {
  return request.get(`/user/delete/${id}`)
}

// 启用用户（status=1）
export const enableUser = (id) => {
  return request.get(`/user/upstatus/${id}`)
}

export default request
