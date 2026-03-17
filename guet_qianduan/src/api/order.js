import request from './request'

// 获取订单列表（按用户ID，带客户名称）
export const getOrderList = (userId) => {
  return request.get(`/order/selectUsercus/${userId}`)
}

// 搜索订单（模糊查询）
export const searchOrder = (data) => {
  return request.post('/order/query', data)
}

// 新增订单
export const addOrder = (data) => {
  return request.post('/order/addorder', data)
}

// 更新订单
export const updateOrder = (data) => {
  return request.post('/order/update', data)
}

// 删除订单
export const deleteOrder = (id) => {
  return request.get(`/order/delete/${id}`)
}

// 获取订单详情（新增订单时获取关联数据）
export const getOrderDetails = (userId) => {
  return request.get(`/order/orderdetails/${userId}`)
}

// 导出订单
export const exportOrders = (params = {}) => {
  return request({
    method: 'get',
    url: '/order/export',
    params: params,
    responseType: 'blob', // 重要：设置响应类型为blob以处理文件下载
    timeout: 30000 // 导出可能需要更长时间
  })
}
