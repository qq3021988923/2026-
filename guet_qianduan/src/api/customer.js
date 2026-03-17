import request from './request'

// 获取客户列表（按用户ID）
export const getCustomerList = (userId) => {
  return request.get('/cust/sbyuserid', { params: { userId } })
}

// 搜索客户
export const searchCustomer = (data) => {
  return request.post('/cust/query', data)
}

// 新增客户
export const insertCustomer = (data) => {
  return request.post('/cust/insert', data)
}

// 更新客户
export const updateCustomer = (data) => {
  return request.post('/cust/update', data)
}

// 删除客户
export const deleteCustomer = (id) => {
  return request.get(`/cust/delete/${id}`)
}
