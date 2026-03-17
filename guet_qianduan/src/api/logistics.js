import request from './request'

// 根据订单ID查询物流轨迹
export const getLogisticsByOrderId = (orderId) => {
  return request.get(`/logistics/order/${orderId}`)
}

// 查询订单最新物流状态
export const getLatestLogistics = (orderId) => {
  return request.get(`/logistics/latest/${orderId}`)
}

// 新增物流记录（更新物流状态）
export const addLogistics = (data) => {
  return request.post('/logistics/add', data)
}
