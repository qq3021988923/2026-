<template>
  <div class="ai-chat-wrapper">
    <!-- 悬浮按钮 -->
    <div class="chat-trigger" @click="toggleChat" :class="{ active: isOpen }">
      <span v-if="!isOpen">🤖</span>
      <span v-else>✕</span>
    </div>

    <!-- 聊天窗口 -->
    <transition name="slide">
      <div v-if="isOpen" class="chat-window">
        <div class="chat-header">
          <span class="avatar">🤖</span>
          <div class="info">
            <h4>智能客服小羊</h4>
            <p>在线为您服务</p>
          </div>
        </div>

        <div class="chat-messages" ref="messagesRef">
          <div v-for="(msg, index) in messages" :key="index" 
               class="message" :class="msg.role">
            <div class="bubble">{{ msg.content }}</div>
          </div>
          <div v-if="loading" class="message assistant">
            <div class="bubble typing">
              <span></span><span></span><span></span>
            </div>
          </div>
        </div>

        <div class="chat-input">
          <input 
            v-model="inputText" 
            @keyup.enter="sendMessage"
            placeholder="输入您的问题..."
            :disabled="loading"
          />
          <button @click="sendMessage" :disabled="loading || !inputText.trim()">
            发送
          </button>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, nextTick } from 'vue'
import { chatWithAi } from '@/api/ai'

const isOpen = ref(false)
const inputText = ref('')
const loading = ref(false)
const messagesRef = ref(null)

const messages = ref([
  { role: 'assistant', content: '您好！我是智能客服小羊，有什么可以帮您的吗？' }
])

const toggleChat = () => {
  isOpen.value = !isOpen.value
}

const scrollToBottom = async () => {
  await nextTick()
  if (messagesRef.value) {
    messagesRef.value.scrollTop = messagesRef.value.scrollHeight
  }
}

const sendMessage = async () => {
  const text = inputText.value.trim()
  if (!text || loading.value) return

  // 添加用户消息
  messages.value.push({ role: 'user', content: text })
  inputText.value = ''
  loading.value = true
  scrollToBottom()

  try {
    const res = await chatWithAi(text)
    if (res.code === 200) {
      messages.value.push({ role: 'assistant', content: res.data })
    } else {
      messages.value.push({ role: 'assistant', content: '抱歉，服务暂时不可用，请稍后再试。' })
    }
  } catch (error) {
    console.error('AI请求失败:', error)
    messages.value.push({ role: 'assistant', content: '网络异常，请检查网络后重试。' })
  } finally {
    loading.value = false
    scrollToBottom()
  }
}
</script>

<style scoped lang="scss">
.ai-chat-wrapper {
  position: fixed;
  bottom: 30px;
  right: 30px;
  z-index: 9999;
}

.chat-trigger {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 4px 20px rgba(107, 114, 128, 0.4);
  transition: all 0.3s;
  font-size: 28px;

  &:hover {
    transform: scale(1.1);
    box-shadow: 0 6px 25px rgba(107, 114, 128, 0.5);
  }

  &.active {
    background: #ff4757;
    font-size: 20px;
    color: white;
  }
}

.chat-window {
  position: absolute;
  bottom: 70px;
  right: 0;
  width: 360px;
  height: 500px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.chat-header {
  padding: 16px;
  background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%);
  color: white;
  display: flex;
  align-items: center;
  gap: 12px;

  .avatar {
    font-size: 36px;
  }

  .info {
    h4 { margin: 0; font-size: 16px; }
    p { margin: 4px 0 0; font-size: 12px; opacity: 0.9; }
  }
}

.chat-messages {
  flex: 1;
  padding: 16px;
  overflow-y: auto;
  background: #f8f9fa;

  .message {
    margin-bottom: 12px;
    display: flex;

    &.user {
      justify-content: flex-end;
      .bubble {
        background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%);
        color: white;
        border-radius: 16px 16px 4px 16px;
      }
    }

    &.assistant {
      justify-content: flex-start;
      .bubble {
        background: white;
        color: #333;
        border-radius: 16px 16px 16px 4px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
      }
    }

    .bubble {
      max-width: 80%;
      padding: 10px 14px;
      font-size: 14px;
      line-height: 1.6;
      word-break: break-word;
      white-space: pre-wrap;
    }

    .typing {
      display: flex;
      gap: 4px;
      padding: 12px 16px;

      span {
        width: 8px;
        height: 8px;
        background: #6b7280;
        border-radius: 50%;
        animation: typing 1.4s infinite;

        &:nth-child(2) { animation-delay: 0.2s; }
        &:nth-child(3) { animation-delay: 0.4s; }
      }
    }
  }
}

@keyframes typing {
  0%, 60%, 100% { transform: translateY(0); opacity: 0.6; }
  30% { transform: translateY(-6px); opacity: 1; }
}

.chat-input {
  padding: 12px;
  background: white;
  border-top: 1px solid #eee;
  display: flex;
  gap: 8px;

  input {
    flex: 1;
    padding: 10px 14px;
    border: 1px solid #e0e0e0;
    border-radius: 20px;
    font-size: 14px;
    outline: none;

    &:focus {
      border-color: #6b7280;
    }

    &:disabled {
      background: #f5f5f5;
    }
  }

  button {
    padding: 10px 20px;
    background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%);
    color: white;
    border: none;
    border-radius: 20px;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.3s;

    &:hover:not(:disabled) {
      transform: scale(1.05);
    }

    &:disabled {
      opacity: 0.6;
      cursor: not-allowed;
    }
  }
}

.slide-enter-active, .slide-leave-active {
  transition: all 0.3s ease;
}

.slide-enter-from, .slide-leave-to {
  opacity: 0;
  transform: translateY(20px) scale(0.9);
}
</style>
