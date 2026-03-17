import request from '@/api/request'

// 分页查询操作日志
export function getOperationLogPage(params) {
  return request.get('/log/page', { params })
}

// 清空操作日志
export function clearOperationLog() {
  return request.delete('/log/clear')
}
