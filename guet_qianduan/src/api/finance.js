import request from './request'

// 获取运费结算列表
export const getFinanceList = (userId, paymentStatus, keyword) => {
  const params = {}
  if (userId) params.userId = userId
  if (paymentStatus) params.paymentStatus = paymentStatus
  if (keyword) params.keyword = keyword
  return request.get('/finance/list', { params })
}

// 添加运费结算
export const addPayment = (data) => {
  return request.post('/finance/payment', data)
}

// 获取结算记录
export const getPaymentRecords = (financeId) => {
  return request.get(`/finance/payment/${financeId}`)
}

// 根据订单ID获取财务结算状态
export const getFinanceByOrderId = (orderId) => {
  return request.get(`/finance/order/${orderId}`)
}
