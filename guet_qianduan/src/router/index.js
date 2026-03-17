import { createRouter, createWebHashHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import LoginView from '../views/LoginView.vue' // 导入登录组件

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'dashboard',
        component: () => import('../components/Dashboard.vue')
      },
      {
        path: 'basicdata',
        name: 'basicdata',
        component: () => import('../components/BasicDataTable.vue')
      },
      {
        path: 'users',
        name: 'users',
        component: () => import('../components/UserTable.vue')
      },
      {
        path: 'roles',
        name: 'roles',
        component: () => import('../components/RoleTable.vue')
      },
      {
        path: 'customers',
        name: 'customers',
        component: () => import('../components/CustomerTable.vue')
      },
      {
        path: 'orders',
        name: 'orders',
        component: () => import('../components/OrderTable.vue')
      },
      {
        path: 'finance',
        name: 'finance',
        component: () => import('../components/FinanceTable.vue')
      },
      {
        path: 'logs',
        name: 'logs',
        component: () => import('../components/OperationLogTable.vue')
      }
    ]
  },
  {
    path: '/login',
    name: 'login',
    component: LoginView
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/login'
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

// 全局前置守卫：基于token的身份验证
router.beforeEach((to, _from, next) => {
  // 判断是否是登录页
  const isLoginPage = to.path === '/login'
  
  // 检查token是否存在且有效
  const token = localStorage.getItem('token')
  const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true'
  
  // 简单的token有效性检查（实际项目中可以解析JWT或调用验证接口）
  const hasValidToken = token && isLoggedIn

  if (isLoginPage) {
    // 如果已经登录，访问登录页时跳转到首页
    hasValidToken ? next('/dashboard') : next()
  } else {
    // 非登录页：有有效token则正常访问，否则跳转到登录页
    hasValidToken ? next() : next('/login')
  }
})

export default router