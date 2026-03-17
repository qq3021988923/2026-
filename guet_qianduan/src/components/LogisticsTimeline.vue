<template>
  <div class="logistics-container">
    <el-card class="progress-card" shadow="never">
      <template #header>
        <span class="card-title">物流状态</span>
      </template>
      <el-steps :active="currentStatus" align-center>
        <el-step v-for="step in statusSteps" :key="step.status" :title="step.label">
          <template #icon>
            <span class="step-icon">{{ step.icon }}</span>
          </template>
        </el-step>
      </el-steps>
    </el-card>

    <el-card class="timeline-card" shadow="never">
      <template #header>
        <span class="card-title">物流轨迹</span>
      </template>
      
      <el-skeleton v-if="loading" :rows="3" animated />
      <el-empty v-else-if="logisticsList.length === 0" description="暂无物流信息" />
      
      <el-timeline v-else>
        <el-timeline-item
          v-for="(item, index) in logisticsList"
          :key="item.id"
          :timestamp="item.createTime"
          placement="top"
          :type="getTimelineType(item.status)"
          :hollow="index !== 0"
          :size="index === 0 ? 'large' : 'normal'"
        >
          <el-card class="timeline-content" :class="{ first: index === 0 }" shadow="hover">
            <div class="timeline-header">
              <el-tag :type="getStatusType(item.status)" size="small">
                {{ item.statusText }}
              </el-tag>
            </div>
            <div class="timeline-body">
              <p v-if="item.location">
                <el-icon><Location /></el-icon>
                {{ item.location }}
              </p>
              <p v-if="item.operator">
                <el-icon><User /></el-icon>
                {{ item.operator }}
              </p>
              <p v-if="item.remark">
                <el-icon><Document /></el-icon>
                {{ item.remark }}
              </p>
            </div>
          </el-card>
        </el-timeline-item>
      </el-timeline>
    </el-card>

    <div v-if="showUpdateBtn && currentStatus < 5" class="update-section">
      <el-button type="primary" size="large" @click="showUpdateModal = true">
        <el-icon><Edit /></el-icon>
        更新物流状态
      </el-button>
    </div>
    <el-alert
      v-if="currentStatus === 5"
      type="success"
      title="订单已签收完成"
      :closable="false"
      show-icon
      center
    />

    <el-dialog v-model="showUpdateModal" title="更新物流状态" width="500px">
      <el-form :model="updateForm" label-width="80px">
        <el-form-item label="物流状态">
          <el-select v-model="updateForm.status" placeholder="请选择状态" style="width: 100%">
            <el-option
              v-for="step in availableSteps"
              :key="step.status"
              :label="step.label"
              :value="step.status"
            >
              <span>{{ step.icon }} {{ step.label }}</span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="当前位置">
          <el-input v-model="updateForm.location" placeholder="请输入当前位置" />
        </el-form-item>
        <el-form-item label="操作人">
          <el-input v-model="updateForm.operator" disabled />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="updateForm.remark" type="textarea" :rows="3" placeholder="请输入备注信息" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showUpdateModal = false">取消</el-button>
        <el-button type="primary" @click="handleUpdateLogistics">确认更新</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getLogisticsByOrderId, addLogistics } from '@/api/logistics'
import { getFinanceByOrderId } from '@/api/finance'

const props = defineProps({
  orderId: {
    type: Number,
    required: true
  },
  showUpdateBtn: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['updated'])

const statusSteps = [
  { status: 1, label: '待取件', icon: '📋' },
  { status: 2, label: '已取件', icon: '📦' },
  { status: 3, label: '运输中', icon: '🚚' },
  { status: 4, label: '已送达', icon: '🏢' },
  { status: 5, label: '已签收', icon: '✅' }
]

const logisticsList = ref([])
const loading = ref(false)
const currentStatus = ref(0)
const showUpdateModal = ref(false)
const currentUserName = localStorage.getItem('username') || ''

const updateForm = ref({
  status: 2,
  location: '',
  operator: currentUserName,
  remark: ''
})

const availableSteps = computed(() => {
  return statusSteps.filter(step => step.status > currentStatus.value)
})

const getStatusType = (status) => {
  const types = {
    1: 'warning',
    2: 'info',
    3: '',
    4: 'success',
    5: 'success'
  }
  return types[status] || 'info'
}

const getPaymentStatusText = (paymentStatus) => {
  if (paymentStatus === null || paymentStatus === undefined) return '未知'
  switch (paymentStatus) {
    case 1: return '未结算'
    case 2: return '部分结算'
    case 3: return '已结算'
    default: return '未知'
  }
}

const getTimelineType = (status) => {
  const types = {
    1: 'warning',
    2: 'primary',
    3: 'primary',
    4: 'success',
    5: 'success'
  }
  return types[status] || 'primary'
}

const fetchLogistics = async () => {
  if (!props.orderId) return
  loading.value = true
  try {
    const res = await getLogisticsByOrderId(props.orderId)
    if (res && res.code === 200) {
      logisticsList.value = res.data || []
      if (logisticsList.value.length > 0) {
        currentStatus.value = logisticsList.value[0].status || 0
        if (currentStatus.value < 5) {
          updateForm.value.status = currentStatus.value + 1
        }
      }
    } else if (Array.isArray(res)) {
      logisticsList.value = res
      if (res.length > 0) {
        currentStatus.value = res[0].status || 0
        if (currentStatus.value < 5) {
          updateForm.value.status = currentStatus.value + 1
        }
      }
    }
  } catch (err) {
    console.error('获取物流信息失败:', err)
  } finally {
    loading.value = false
  }
}

const handleUpdateLogistics = async () => {
  if (!updateForm.value.location?.trim()) {
    ElMessage.warning('请输入当前位置')
    return
  }

  // 如果更新到"已签收"状态（状态5），检查运费结算状态
  if (updateForm.value.status === 5) {
    try {
      // 获取订单的财务结算状态
      console.log(`[物流签收] 获取订单${props.orderId}的财务结算状态`)
      const financeRes = await getFinanceByOrderId(props.orderId)
      console.log('[物流签收] 财务API响应:', financeRes)
      
      let paymentStatusText = '未知'
      let paymentStatus = null
      
      // 处理API响应格式
      if (financeRes && financeRes.code === 200) {
        // Result包装的响应 {code:200, data:{...}, message:''}
        const finance = financeRes.data
        if (finance) {
          paymentStatus = finance.paymentStatus
          paymentStatusText = getPaymentStatusText(paymentStatus)
          console.log(`[物流签收] 财务记录存在，结算状态码: ${paymentStatus}, 状态文本: ${paymentStatusText}`)
        } else {
          // 财务记录不存在，视为"未结算"
          paymentStatusText = '未结算'
          console.log(`[物流签收] 财务记录不存在，默认状态: ${paymentStatusText}`)
        }
      } else if (financeRes && financeRes.paymentStatus !== undefined) {
        // 直接返回Finance对象的情况
        paymentStatus = financeRes.paymentStatus
        paymentStatusText = getPaymentStatusText(paymentStatus)
        console.log(`[物流签收] 直接返回Finance对象，结算状态码: ${paymentStatus}, 状态文本: ${paymentStatusText}`)
      } else if (financeRes === null || financeRes === undefined) {
        // 响应为null或undefined
        paymentStatusText = '未结算'
        console.log(`[物流签收] API返回null，默认状态: ${paymentStatusText}`)
      } else {
        // 其他未知响应格式
        console.warn('[物流签收] 未知的API响应格式:', financeRes)
        paymentStatusText = '未知'
      }

      // 显示确认对话框
      try {
        await ElMessageBox.confirm(
          `运费结算状态：${paymentStatusText}，是否确认签收？`,
          '运费结算状态',
          {
            confirmButtonText: '确认签收',
            cancelButtonText: '取消',
            type: 'warning',
            distinguishCancelAndClose: true
          }
        )
        console.log(`[物流签收] 用户确认签收，运费结算状态: ${paymentStatusText}`)
      } catch (confirmErr) {
        // 用户点击取消
        console.log('[物流签收] 用户取消签收')
        return
      }
    } catch (err) {
      console.error('[物流签收] 获取财务结算状态失败:', err)
      // 即使获取失败，也允许继续更新，但给出提示
      try {
        await ElMessageBox.confirm(
          '无法获取运费结算状态，是否继续签收？',
          '运费结算状态',
          {
            confirmButtonText: '继续签收',
            cancelButtonText: '取消',
            type: 'warning'
          }
        )
        console.log('[物流签收] 用户选择继续签收（无法获取结算状态）')
      } catch (confirmErr) {
        console.log('[物流签收] 用户取消签收（无法获取结算状态）')
        return
      }
    }
  }

  try {
    const data = {
      orderId: props.orderId,
      status: updateForm.value.status,
      location: updateForm.value.location,
      operator: updateForm.value.operator || localStorage.getItem('username') || '',
      remark: updateForm.value.remark
    }
    const res = await addLogistics(data)
    if (res && (res.code === 200 || res === 1)) {
      ElMessage.success('物流状态更新成功')
      showUpdateModal.value = false
      updateForm.value = { 
        status: Math.min(currentStatus.value + 2, 5), 
        location: '', 
        operator: currentUserName, 
        remark: '' 
      }
      fetchLogistics()
      emit('updated')
    } else {
      ElMessage.error(res?.message || '更新失败')
    }
  } catch (err) {
    console.error('更新物流状态失败:', err)
    ElMessage.error('更新失败')
  }
}

watch(() => props.orderId, (newVal) => {
  if (newVal) fetchLogistics()
}, { immediate: true })

onMounted(() => {
  fetchLogistics()
})

defineExpose({ refresh: fetchLogistics })
</script>

<style scoped lang="scss">
.logistics-container {
  .progress-card {
    margin-bottom: 16px;

    :deep(.el-card__header) {
      padding: 12px 16px;
      border-bottom: 1px solid #ebeef5;
    }

    :deep(.el-card__body) {
      padding: 24px 16px;
    }

    .card-title {
      font-size: 15px;
      font-weight: 600;
      color: #303133;
    }

    .step-icon {
      font-size: 20px;
    }

    :deep(.el-step__title) {
      font-size: 13px;
    }

    :deep(.el-step.is-process .el-step__title) {
      color: #409eff;
      font-weight: 600;
    }

    :deep(.el-step.is-finish .el-step__title) {
      color: #67c23a;
    }
  }

  .timeline-card {
    :deep(.el-card__header) {
      padding: 12px 16px;
      border-bottom: 1px solid #ebeef5;
    }

    :deep(.el-card__body) {
      padding: 20px 16px;
    }

    .card-title {
      font-size: 15px;
      font-weight: 600;
      color: #303133;
    }

    :deep(.el-timeline) {
      padding-left: 0;
    }

    .timeline-content {
      :deep(.el-card__body) {
        padding: 12px 16px;
      }

      &.first {
        border-left: 3px solid #409eff;
        background: #f0f7ff;
      }

      .timeline-header {
        margin-bottom: 8px;
      }

      .timeline-body {
        p {
          margin: 6px 0;
          font-size: 13px;
          color: #606266;
          display: flex;
          align-items: center;
          gap: 6px;

          .el-icon {
            color: #909399;
          }
        }
      }
    }
  }

  .update-section {
    margin-top: 20px;
    text-align: center;
  }
}
</style>
