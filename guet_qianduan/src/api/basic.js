import request from './request'

// 获取基础数据列表
export const getBasicList = () => {
  return request.get('/basic/list')
}

// 新增基础数据
export const insertBasic = (data) => {
  return request.post('/basic/insert', data)
}

// 更新基础数据
export const updateBasic = (data) => {
  return request.post('/basic/update', data)
}

// 删除基础数据
export const deleteBasic = (id) => {
  return request.get(`/basic/delete/${id}`)
}
