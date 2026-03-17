import request from './request'

// AI 聊天
export const chatWithAi = (message) => {
  return request.post('/ai/chat', { message })
}
