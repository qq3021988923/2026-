<template>
  <div class="login-layout">
    <div class="login-box">
      <div class="left-box">
        <img src="@/assets/imgs/guetimg.png" alt="Guet" class="login-img">
        <div class="system-title">羊城货运平台</div>
      </div>
      <div class="right-box">
        <div class="greeting">
          <div>登录入口</div>
        </div>
        <div class="form-area">
          <el-input
            v-model="loginForm.username"
            placeholder="用户账户"
            size="large"
            class="login-input"
          >
            <template #prefix>
              <el-icon><User /></el-icon>
            </template>
          </el-input>
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="账户密码"
            size="large"
            show-password
            class="login-input"
            @keyup.enter="handleLogin"
          >
            <template #prefix>
              <el-icon><Lock /></el-icon>
            </template>
          </el-input>
        </div>
        <el-button type="primary" size="large" class="login-btn" :loading="loading" @click="handleLogin">
          登录
        </el-button>
        <div class="tips">
          <el-tag type="info" effect="plain" size="small">测试账号: admin / 123456</el-tag>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock } from '@element-plus/icons-vue'
import { login } from '@/api/user'

const router = useRouter()
const loading = ref(false)

const loginForm = reactive({
  username: 'admin',
  password: '123456'
})

const handleLogin = async () => {
  if (!loginForm.username.trim()) {
    ElMessage.error('请输入用户名')
    return
  }
  if (!loginForm.password) {
    ElMessage.error('请输入密码')
    return
  }

  loading.value = true
  try {
    const response = await login(loginForm.username, loginForm.password)
    
    if (response && response.code === 200) {
      if (!response.data) {
        ElMessage.error('用户名或密码错误')
        return
      }
      
      const userData = response.data
      
      if (userData.user?.status === 0) {
        ElMessage.error('此账号已被禁用，禁止登录')
        return
      }
      
      localStorage.setItem('isLoggedIn', 'true')
      localStorage.setItem('userInfo', JSON.stringify(userData.user))
      localStorage.setItem('username', userData.user?.name || userData.user?.username || loginForm.username)
      localStorage.setItem('userId', userData.user?.id || '')
      localStorage.setItem('permission', JSON.stringify(userData.permission || []))
      
      if (userData.token) {
        localStorage.setItem('token', userData.token)
      }
      
      ElMessage.success('登录成功')
      
      setTimeout(() => {
        router.push('/dashboard').catch(err => console.error('路由跳转错误:', err))
      }, 500)
    } else if (response && response.code === 500) {
      ElMessage.error('用户名或密码错误')
    } else {
      ElMessage.error(response?.message || '登录失败')
    }
  } catch (err) {
    console.error('登录错误:', err)
    if (err.response?.status === 401) {
      ElMessage.error('用户名或密码错误')
    } else if (err.response?.status === 404) {
      ElMessage.error('用户不存在')
    } else if (err.response?.status === 500) {
      ElMessage.error('服务器错误，请稍后重试')
    } else {
      ElMessage.error(err.response?.data?.message || err.message || '登录失败，请检查网络连接')
    }
  } finally {
    loading.value = false
  }
}
</script>

<style scoped lang="scss">
.login-layout {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  background: #F8FAFC;
  display: flex;
  justify-content: center;
  align-items: center;
}

.login-box {
  display: flex;
  width: calc(100vw - 88px);
  height: calc(100vh - 160px);
  max-width: 1200px;
  min-height: 500px;
  background: #fff;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border-radius: 8px;
  overflow: hidden;
}

.left-box {
  width: 53%;
  height: 100%;
  position: relative;
  background: linear-gradient(45deg, #e8ecef 0%, #f5f7fa 100%);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;

  .login-img {
    width: 160px;
    height: 160px;
    border-radius: 16px;
    margin-bottom: 24px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }

  .system-title {
    font-size: 28px;
    font-weight: 600;
    color: #303133;
    text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
  }
}

.right-box {
  flex: 1;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 0 10%;

  .greeting {
    margin-bottom: 40px;

    div {
      font-size: 28px;
      font-weight: 600;
      color: #303133;
      line-height: 1.4;
    }
  }

  .form-area {
    margin-bottom: 20px;

    .login-input {
      width: 100%;
      max-width: 328px;
      margin-bottom: 16px;
    }
  }

  .login-btn {
    width: 100%;
    max-width: 328px;
    height: 44px;
    font-size: 16px;
  }

  .tips {
    margin-top: 24px;
    text-align: center;
  }
}

@media (max-width: 768px) {
  .login-box {
    flex-direction: column;
    width: 90%;
    height: auto;
    min-height: auto;
  }

  .left-box {
    width: 100%;
    height: 200px;
    padding: 40px;

    .login-img {
      width: 80px;
      height: 80px;
    }

    .system-title {
      font-size: 22px;
    }
  }

  .right-box {
    padding: 40px 20px;

    .greeting div {
      font-size: 24px;
    }

    .form-area .login-input,
    .login-btn {
      max-width: 100%;
    }
  }
}
</style>
