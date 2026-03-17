import axios from 'axios'

// API 基础 URL
// 开发环境使用相对路径（由 devServer proxy 转发到 http://localhost:8088）
// 生产环境使用完整 URL
const API_BASE_URL = process.env.NODE_ENV === 'development' ? '/consumer/api' : 'http://localhost:8088/consumer/api'

console.log('[API配置] 环境:', process.env.NODE_ENV, '基础URL:', API_BASE_URL)

// 创建公共 axios 实例
const request = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器
request.interceptors.request.use(
  config => {
    console.log('[请求] 方法:', config.method, '地址:', config.url, '完整URL:', config.baseURL + config.url)
    
    // 添加token到请求头
    const token = localStorage.getItem('token')
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`
    }
    
    // 添加用户信息到请求头（用于操作日志记录）
    const userId = localStorage.getItem('userId')
    const username = localStorage.getItem('username')
    if (userId) {
      config.headers['X-User-Id'] = userId
    }
    if (username) {
      // 中文需要编码，否则请求头会报错
      config.headers['X-Username'] = encodeURIComponent(username)
    }
    
    return config
  },
  error => {
    console.error('[请求错误]', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  response => {
    console.log('[响应] 状态码:', response.status, '数据类型:', response.data instanceof Blob ? 'Blob' : typeof response.data)
    
    // 如果是blob类型（文件下载），直接返回blob数据
    if (response.data instanceof Blob) {
      return response.data
    }
    
    // 其他情况返回响应数据
    return response.data
  },
  error => {
    const errorInfo = {
      message: error.message,
      status: error.response?.status,
      statusText: error.response?.statusText,
      data: error.response?.data,
      url: error.config?.url
    }
    console.error('[响应错误]', errorInfo)
    
    // 处理token过期或无效的情况
    if (error.response?.status === 401) {
      console.log('[Token过期] 清除本地存储，跳转到登录页')
      // 清除本地存储
      localStorage.removeItem('token')
      localStorage.removeItem('isLoggedIn')
      localStorage.removeItem('userInfo')
      localStorage.removeItem('username')
      localStorage.removeItem('userId')
      localStorage.removeItem('permission')
      
      // 跳转到登录页
      if (window.location.hash !== '#/login') {
        window.location.hash = '#/login'
        window.location.reload()
      }
    }
    
    return Promise.reject(error)
  }
)

export default request
