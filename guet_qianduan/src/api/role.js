import request from './request'

// 查询角色列表
export const getRoleList = () => {
  return request.get('/role')
}

// 根据ID查询一条角色记录
export const getRoleById = (id) => {
  return request.get(`/role/select/${id}`)
}

// 删除角色 - 使用 GET 方法调用 /role/delete/{id}
export const deleteRole = (id) => {
  console.log('调用 deleteRole API，ID:', id)
  return request.get(`/role/delete/${id}`)
}

// 更新角色
export const updateRole = (role) => {
  return request.post('/role/update', role)
}

// 新增角色
export const insertRole = (role) => {
  return request.post('/role/insert', role)
}

export default request
