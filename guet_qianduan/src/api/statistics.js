import request from './request'

// 获取综合统计数据
export const getOverviewStats = (userId) => {
  return request.get('/statistics/overview', { params: { userId } })
}
