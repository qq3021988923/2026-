<template>
  <div class="finance-container">
    <el-card class="header-card" shadow="never">
      <div class="header-section">
        <div class="filter-section">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索运单号/货物名称/客户"
            clearable
            @clear="handleSearch"
            @keyup.enter="handleSearch"
            style="width: 250px; margin-right: 20px"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-select v-model="filterStatus" placeholder="全部状态" clearable @change="fetchFinanceList" style="width: 150px">
            <el-option label="全部状态" value="" />
            <el-option label="待结算" value="1" />
            <el-option label="部分结算" value="2" />
            <el-option label="已结算" value="3" />
          </el-select>
        </div>
      </div>
    </el-card>

    <el-row :gutter="16" class="stats-row">
      <el-col :xs="12" :sm="8" :md="4">
        <el-card class="stat-card" shadow="hover">
          <el-statistic title="运单总数" :value="statistics.orderCount || 0" />
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="8" :md="4">
        <el-card class="stat-card" shadow="hover">
          <el-statistic title="运费总额" :value="statistics.totalAmount || 0" :precision="2" prefix="¥" />
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="8" :md="4">
        <el-card class="stat-card" shadow="hover">
          <el-statistic title="已结算" :value="statistics.paidAmount || 0" :precision="2" prefix="¥">
            <template #suffix>
              <span style="color: #67c23a; font-size: 14px"></span>
            </template>
          </el-statistic>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="8" :md="4">
        <el-card class="stat-card" shadow="hover">
          <el-statistic title="待结算" :value="statistics.unpaidAmount || 0" :precision="2" prefix="¥">
            <template #suffix>
              <span style="color: #f56c6c; font-size: 14px"></span>
            </template>
          </el-statistic>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="8" :md="4">
        <el-card class="stat-card" shadow="hover">
          <el-statistic title="结算率" :value="statistics.paymentRate || 0" suffix="%" />
        </el-card>
      </el-col>
    </el-row>

    <el-skeleton v-if="loading" :rows="5" animated />
    <el-empty v-else-if="error" :description="error" />
    
    <template v-else>
      <el-table :data="pagedFinanceList" stripe style="width: 100%" v-if="financeList.length > 0">
        <el-table-column prop="orderNum" label="运单号" min-width="120" />
        <el-table-column prop="orderName" label="货物名称" min-width="100" />
        <el-table-column prop="customerName" label="客户" min-width="80" />
        <el-table-column prop="shippingMethod" label="运输方式" width="100">
          <template #default="{ row }">
            <el-tag size="small" effect="plain">{{ row.shippingMethod || '-' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="logisticsStatus" label="物流状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getLogisticsType(row.logisticsStatus)" size="small">
              {{ getLogisticsText(row.logisticsStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="totalAmount" label="运费总额" width="110" align="right">
          <template #default="{ row }">
            <span class="money">¥{{ formatMoney(row.totalAmount) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="paidAmount" label="已结算" width="110" align="right">
          <template #default="{ row }">
            <span class="money success">¥{{ formatMoney(row.paidAmount) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="unpaidAmount" label="待结算" width="110" align="right">
          <template #default="{ row }">
            <span class="money danger">¥{{ formatMoney(row.unpaidAmount) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="paymentStatus" label="结算状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.paymentStatus)" size="small">
              {{ getStatusText(row.paymentStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="openPayModal(row)" :disabled="row.paymentStatus === 3">
              <el-icon><Money /></el-icon>
              结算
            </el-button>
            <el-button type="success" size="small" plain @click="openRecordModal(row)">
              <el-icon><Document /></el-icon>
              记录
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-empty v-else description="暂无运费结算数据" />
    </template>

    <el-pagination
      v-if="financeList.length > 0"
      class="pagination"
      v-model:current-page="currentPage"
      v-model:page-size="pageSize"
      :page-sizes="[10, 20, 50]"
      :total="financeList.length"
      layout="total, sizes, prev, pager, next, jumper"
      background
    />

    <el-dialog v-model="showPayModal" title="运费结算" width="500px">
      <el-descriptions :column="1" border>
        <el-descriptions-item label="运单号">{{ currentFinance.orderNum }}</el-descriptions-item>
        <el-descriptions-item label="运输方式">{{ currentFinance.shippingMethod || '-' }}</el-descriptions-item>
        <el-descriptions-item label="运费总额">
          <span class="money">¥{{ formatMoney(currentFinance.totalAmount) }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="已结算">
          <span class="money success">¥{{ formatMoney(currentFinance.paidAmount) }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="待结算">
          <span class="money danger">¥{{ formatMoney(currentFinance.unpaidAmount) }}</span>
        </el-descriptions-item>
      </el-descriptions>
      <el-form :model="payForm" label-width="80px" style="margin-top: 20px">
        <el-form-item label="结算金额">
          <el-input-number v-model="payForm.paymentAmount" :min="0" :precision="2" style="width: 100%" />
          <div style="color: #909399; font-size: 12px; margin-top: 4px;">
            待结算金额：¥{{ formatMoney(currentFinance.unpaidAmount) }}
          </div>
        </el-form-item>
        <el-form-item label="结算方式">
          <el-select v-model="payForm.paymentMethod" style="width: 100%">
            <el-option label="银行转账" value="银行转账" />
            <el-option label="现金" value="现金" />
            <el-option label="支付宝" value="支付宝" />
            <el-option label="微信" value="微信" />
            <el-option label="月结" value="月结" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showPayModal = false">取消</el-button>
        <el-button type="primary" @click="handlePaySubmit">确认结算</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="showRecordModal" :title="'结算记录 - ' + currentFinance.orderNum" width="600px">
      <el-empty v-if="paymentRecords.length === 0" description="暂无结算记录" />
      <el-table v-else :data="paymentRecords" stripe>
        <el-table-column type="index" label="序号" width="60" />
        <el-table-column prop="paymentAmount" label="结算金额" width="120" align="right">
          <template #default="{ row }">
            <span class="money success">¥{{ formatMoney(row.paymentAmount) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="paymentMethod" label="结算方式" width="100" />
        <el-table-column prop="paymentTime" label="结算时间">
          <template #default="{ row }">
            {{ formatDate(row.paymentTime || row.createTime) }}
          </template>
        </el-table-column>
      </el-table>
      <template #footer>
        <el-button @click="showRecordModal = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getFinanceList, addPayment, getPaymentRecords } from '@/api/finance'
import { getOverviewStats } from '@/api/statistics'

const financeList = ref([])
const statistics = ref({})
const loading = ref(false)
const error = ref(null)
const filterStatus = ref('')
const searchKeyword = ref('')

const currentPage = ref(1)
const pageSize = ref(10)
const totalPages = computed(() => Math.ceil(financeList.value.length / pageSize.value) || 1)
const pagedFinanceList = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  return financeList.value.slice(start, start + pageSize.value)
})

const showPayModal = ref(false)
const showRecordModal = ref(false)
const currentFinance = ref({})
const paymentRecords = ref([])

const payForm = ref({
  paymentAmount: null,
  paymentMethod: '银行转账'
})

const formatMoney = (val) => {
  if (val === null || val === undefined) return '0.00'
  return Number(val).toFixed(2)
}

const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleString('zh-CN')
}

const getStatusType = (status) => {
  switch (status) {
    case 1: return 'danger'
    case 2: return 'warning'
    case 3: return 'success'
    default: return 'info'
  }
}

const getStatusText = (status) => {
  switch (status) {
    case 1: return '待结算'
    case 2: return '部分结算'
    case 3: return '已结算'
    default: return '未知'
  }
}

const getLogisticsType = (status) => {
  const types = { 1: 'warning', 2: 'info', 3: '', 4: 'success', 5: 'success' }
  return types[status] || 'info'
}

const getLogisticsText = (status) => {
  const map = { 1: '待取件', 2: '已取件', 3: '运输中', 4: '已送达', 5: '已签收' }
  return map[status] || '待处理'
}

const fetchFinanceList = async () => {
  loading.value = true
  error.value = null
  try {
    const permission = JSON.parse(localStorage.getItem('permission') || '[]')
    const isAdmin = permission.includes('平台管理员')
    const currentUserId = localStorage.getItem('userId')
    const financeUserId = isAdmin ? null : currentUserId
    
    const [financeRes, statsRes] = await Promise.all([
      getFinanceList(financeUserId, filterStatus.value || null, searchKeyword.value || null),
      getOverviewStats(currentUserId)
    ])
    
    if (financeRes && financeRes.code === 200 && financeRes.data) {
      financeList.value = financeRes.data.list || []
    }
    
    if (statsRes && statsRes.code === 200 && statsRes.data && statsRes.data.revenue) {
      const orderCount = statsRes.data.revenue.orderCount || 0
      const totalAmount = statsRes.data.revenue.totalRevenue || 0
      const paidAmount = financeRes?.data?.statistics?.paidAmount || 0
      const unpaidAmount = totalAmount - paidAmount
      const paymentRate = totalAmount > 0 ? ((paidAmount / totalAmount) * 100).toFixed(2) : 0
      
      statistics.value = {
        orderCount: orderCount,
        totalAmount: totalAmount,
        paidAmount: paidAmount,
        unpaidAmount: unpaidAmount,
        paymentRate: paymentRate
      }
    }
  } catch (err) {
    console.error('获取运费结算列表失败:', err)
    error.value = err.message
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  currentPage.value = 1
  fetchFinanceList()
}

const openPayModal = (item) => {
  currentFinance.value = { ...item }
  payForm.value = { paymentAmount: null, paymentMethod: '银行转账' }
  showPayModal.value = true
}

const handlePaySubmit = async () => {
  if (!payForm.value.paymentAmount || payForm.value.paymentAmount <= 0) {
    ElMessage.warning('请输入有效的结算金额')
    return
  }
  if (payForm.value.paymentAmount > currentFinance.value.unpaidAmount) {
    ElMessage.warning('结算金额不能超过待结算金额')
    return
  }
  try {
    const userId = localStorage.getItem('userId')
    const data = {
      financeId: currentFinance.value.id,
      orderId: currentFinance.value.orderId,
      paymentAmount: payForm.value.paymentAmount,
      paymentMethod: payForm.value.paymentMethod,
      operatorId: userId ? Number(userId) : null
    }
    const res = await addPayment(data)
    if (res && res.code === 200) {
      ElMessage.success('结算成功')
      showPayModal.value = false
      fetchFinanceList()
    } else {
      ElMessage.error(res?.message || '结算失败')
    }
  } catch (err) {
    console.error('结算失败:', err)
    ElMessage.error('结算失败')
  }
}

const openRecordModal = async (item) => {
  currentFinance.value = { ...item }
  try {
    const res = await getPaymentRecords(item.id)
    if (res && res.code === 200) {
      paymentRecords.value = res.data || []
    }
  } catch (err) {
    console.error('获取结算记录失败:', err)
    paymentRecords.value = []
  }
  showRecordModal.value = true
}

onMounted(() => {
  fetchFinanceList()
})
</script>

<style scoped lang="scss">
.finance-container {
  .header-card {
    margin-bottom: 16px;

    :deep(.el-card__body) {
      padding: 16px;
    }

    .header-section {
      display: flex;
      justify-content: space-between;
      align-items: center;

      h3 {
        margin: 0;
        font-size: 18px;
        color: #303133;
      }

      .filter-section {
        display: flex;
        align-items: center;
        gap: 12px;
      }
    }
  }

  .stats-row {
    margin-bottom: 16px;

    .stat-card {
      margin-bottom: 16px;

      :deep(.el-card__body) {
        padding: 16px;
      }
    }
  }

  .money {
    font-family: 'Courier New', monospace;
    font-weight: 600;

    &.success {
      color: #67c23a;
    }

    &.danger {
      color: #f56c6c;
    }
  }

  .pagination {
    margin-top: 16px;
    display: flex;
    justify-content: center;
  }
}
</style>
