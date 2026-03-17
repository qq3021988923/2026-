<template>
  <div class="dashboard-container">
    <div class="welcome-section">
      <h2>欢迎回来，{{ username }}</h2>
      <p class="date">{{ currentDate }}</p>
    </div>

    <!-- 统计卡片 -->
    <el-row :gutter="16" class="stats-row">
      <el-col :xs="24" :sm="12" :md="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <el-icon class="stat-icon" :size="32"><Box /></el-icon>
            <div class="stat-info">
              <el-statistic title="我的订单" :value="stats.orderCount" />
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <el-icon class="stat-icon" :size="32"><Wallet /></el-icon>
            <div class="stat-info">
              <el-statistic title="总营收" :value="stats.totalRevenue" :precision="2" prefix="¥" />
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <el-icon class="stat-icon" :size="32"><User /></el-icon>
            <div class="stat-info">
              <el-statistic title="我的客户" :value="stats.customerCount" />
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <el-icon class="stat-icon" :size="32"><TrendCharts /></el-icon>
            <div class="stat-info">
              <el-statistic title="平均订单金额" :value="stats.avgRevenue" :precision="2" prefix="¥" />
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 图表区域 -->
    <el-row :gutter="16" class="charts-row">
      <el-col :xs="24" :lg="16">
        <el-card class="chart-card" shadow="hover">
          <template #header>
            <div class="card-header">
              <span>热门目的地城市 TOP5</span>
            </div>
          </template>
          <div class="ranking-list">
            <div v-for="(item, index) in cityRanking" :key="index" class="ranking-item">
              <el-tag :type="getRankType(index)" size="small" effect="dark" class="rank-tag">{{ index + 1 }}</el-tag>
              <span class="name">{{ item.name }}</span>
              <span class="value">{{ item.value }} 单</span>
              <el-progress :percentage="getPercentage(item.value)" :show-text="false" :stroke-width="4" class="progress-bar" />
            </div>
            <el-empty v-if="cityRanking.length === 0" description="暂无数据" :image-size="60" />
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="8">
        <el-card class="chart-card" shadow="hover">
          <template #header>
            <div class="card-header">
              <span>订单状态分布</span>
            </div>
          </template>
          <div ref="logisticsChart" class="chart-container"></div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 订单趋势和快捷操作 -->
    <el-row :gutter="16" class="bottom-row">
      <el-col :xs="24" :lg="12">
        <el-card class="ranking-card" shadow="hover">
          <template #header>
            <div class="card-header">
              <span>订单趋势（近30天）</span>
            </div>
          </template>
          <div ref="orderTrendChart" class="chart-container"></div>
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="12">
        <el-card class="quick-card" shadow="hover">
          <template #header>
            <div class="card-header">
              <span>快捷操作</span>
            </div>
          </template>
          <div class="quick-actions">
            <el-button class="action-btn" @click="router.push('/orders')">
              <el-icon><Box /></el-icon>
              <span>我的订单</span>
            </el-button>
            <el-button class="action-btn" @click="router.push('/customers')">
              <el-icon><User /></el-icon>
              <span>客户管理</span>
            </el-button>
            <el-button class="action-btn" @click="router.push('/users')">
              <el-icon><UserFilled /></el-icon>
              <span>用户管理</span>
            </el-button>
            <el-button class="action-btn" @click="router.push('/basicdata')">
              <el-icon><DataAnalysis /></el-icon>
              <span>基础数据</span>
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import * as echarts from 'echarts'
import { getOverviewStats } from '@/api/statistics'
import { getCustomerList } from '@/api/customer'

const router = useRouter()

const username = ref('')
const currentDate = ref('')

const stats = ref({
  orderCount: 0,
  totalRevenue: 0,
  avgRevenue: 0,
  customerCount: 0
})

const cityRanking = ref([])

const orderTrendChart = ref(null)
const logisticsChart = ref(null)
let chartInstances = []

const getRankType = (index) => {
  const types = ['warning', 'info', 'success']
  return types[index] || ''
}

const getPercentage = (value) => {
  if (cityRanking.value.length === 0) return 0
  const max = Math.max(...cityRanking.value.map(i => i.value))
  return max > 0 ? Math.round((value / max) * 100) : 0
}

const formatCurrentDate = () => {
  const now = new Date()
  const options = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' }
  return now.toLocaleDateString('zh-CN', options)
}

const initOrderTrendChart = (data) => {
  if (!orderTrendChart.value) return
  const chart = echarts.init(orderTrendChart.value)
  chartInstances.push(chart)

  const formatDateStr = (date) => {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  }

  const dateMap = new Map()
  data.forEach(item => {
    let dateStr
    if (item.date instanceof Date) {
      dateStr = formatDateStr(item.date)
    } else {
      dateStr = String(item.date).substring(0, 10)
    }
    dateMap.set(dateStr, { count: item.count, total: item.total })
  })

  const allDates = []
  const allCounts = []
  const allTotals = []
  
  const today = new Date()
  for (let i = 29; i >= 0; i--) {
    const date = new Date(today)
    date.setDate(date.getDate() - i)
    const dateStr = formatDateStr(date)
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    const displayDate = `${month}-${day}`
    
    allDates.push(displayDate)
    const dayData = dateMap.get(dateStr)
    allCounts.push(dayData ? dayData.count : 0)
    allTotals.push(dayData ? Number(dayData.total) : 0)
  }

  chart.setOption({
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'shadow' }
    },
    legend: {
      data: ['订单数', '营收(元)'],
      top: 10
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: allDates,
      axisLabel: {
        interval: 4
      }
    },
    yAxis: [
      {
        type: 'value',
        name: '订单数',
        position: 'left',
        minInterval: 1
      },
      {
        type: 'value',
        name: '营收(元)',
        position: 'right'
      }
    ],
    series: [
      {
        name: '订单数',
        type: 'bar',
        data: allCounts,
        itemStyle: {
          color: '#409eff',
          borderRadius: [4, 4, 0, 0]
        }
      },
      {
        name: '营收(元)',
        type: 'line',
        yAxisIndex: 1,
        data: allTotals,
        smooth: true,
        itemStyle: { color: '#67c23a' }
      }
    ]
  })
}

const initLogisticsChart = (data) => {
  if (!logisticsChart.value) return
  const chart = echarts.init(logisticsChart.value)
  chartInstances.push(chart)

  const statusMap = new Map()
  data.forEach(item => {
    statusMap.set(item.name, item.value)
  })

  const allStatuses = [
    { name: '待取件', value: statusMap.get('待取件') || 0 },
    { name: '已取件', value: statusMap.get('已取件') || 0 },
    { name: '运输中', value: statusMap.get('运输中') || 0 },
    { name: '已送达', value: statusMap.get('已送达') || 0 },
    { name: '已签收', value: statusMap.get('已签收') || 0 }
  ]

  const colors = ['#f5a623', '#4a90d9', '#8e8e93', '#7ed321', '#e74c3c']

  chart.setOption({
    tooltip: {
      trigger: 'item',
      backgroundColor: 'rgba(255, 255, 255, 0.95)',
      borderColor: '#eee',
      borderWidth: 1,
      padding: [8, 12],
      textStyle: { color: '#333', fontSize: 13 },
      formatter: '{b}: <b>{c}单</b> ({d}%)'
    },
    legend: {
      orient: 'vertical',
      right: 20,
      top: 'center',
      itemWidth: 10,
      itemHeight: 10,
      itemGap: 12,
      textStyle: {
        fontSize: 13,
        color: '#606266'
      },
      formatter: (name) => {
        const item = allStatuses.find(s => s.name === name)
        return `${name}  ${item ? item.value : 0}单`
      }
    },
    series: [
      {
        type: 'pie',
        radius: ['45%', '75%'],
        center: ['35%', '50%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 6,
          borderColor: '#fff',
          borderWidth: 3
        },
        label: { show: false },
        emphasis: {
          scale: true,
          scaleSize: 8,
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.15)'
          }
        },
        data: allStatuses,
        color: colors
      }
    ]
  })
}

const fetchStats = async () => {
  try {
    const userId = localStorage.getItem('userId')
    
    if (!userId || userId === 'undefined' || userId === 'null') {
      console.error('用户ID无效')
      return
    }
    
    const res = await getOverviewStats(userId)
    if (res && res.code === 200 && res.data) {
      const data = res.data
      
      if (data.revenue) {
        stats.value.orderCount = data.revenue.orderCount || 0
        stats.value.totalRevenue = data.revenue.totalRevenue || 0
        stats.value.avgRevenue = data.revenue.avgRevenue || 0
      }

      await nextTick()
      
      if (data.dateStats) {
        initOrderTrendChart(data.dateStats)
      }
      if (data.logisticsStats) {
        initLogisticsChart(data.logisticsStats)
      }
      if (data.cityStats) {
        cityRanking.value = data.cityStats.slice(0, 5)
      }
    }

    const customerRes = await getCustomerList(userId).catch(() => ({ data: [] }))
    stats.value.customerCount = customerRes?.data?.length || 0

  } catch (err) {
    console.error('获取统计数据失败:', err)
  }
}

// 窗口大小变化时重绘图表
const handleResize = () => {
  chartInstances.forEach(chart => chart.resize())
}

onMounted(() => {
  username.value = localStorage.getItem('username') || 'Admin'
  currentDate.value = formatCurrentDate()
  fetchStats()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  chartInstances.forEach(chart => chart.dispose())
})
</script>

<style scoped lang="scss">
.dashboard-container {
  .welcome-section {
    margin-bottom: 20px;

    h2 {
      margin: 0 0 6px 0;
      font-size: 20px;
      color: #303133;
      font-weight: 600;
    }

    .date {
      margin: 0;
      color: #909399;
      font-size: 13px;
    }
  }

  .stats-row {
    margin-bottom: 16px;

    .stat-card {
      margin-bottom: 16px;
      border-radius: 8px;

      :deep(.el-card__body) {
        padding: 16px;
      }

      .stat-content {
        display: flex;
        align-items: center;
        gap: 12px;
      }

      .stat-icon {
        width: 48px;
        height: 48px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #ecf5ff;
        border-radius: 8px;
        color: #409eff;
        flex-shrink: 0;
      }

      .stat-info {
        flex: 1;

        :deep(.el-statistic__head) {
          font-size: 13px;
          color: #909399;
        }

        :deep(.el-statistic__content) {
          font-size: 22px;
          color: #303133;
        }
      }
    }
  }

  .charts-row {
    margin-bottom: 16px;

    .chart-card {
      margin-bottom: 16px;
      border-radius: 8px;

      :deep(.el-card__header) {
        padding: 12px 16px;
        border-bottom: 1px solid #ebeef5;
      }

      :deep(.el-card__body) {
        padding: 16px;
      }

      .card-header {
        font-size: 14px;
        font-weight: 600;
        color: #303133;
      }

      .chart-container {
        height: 280px;
      }

      .ranking-list {
        .ranking-item {
          display: flex;
          align-items: center;
          padding: 10px 0;
          border-bottom: 1px solid #f5f7fa;

          &:last-child {
            border-bottom: none;
          }

          .rank-tag {
            width: 22px;
            height: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
          }

          .name {
            flex: 1;
            font-size: 13px;
            color: #606266;
          }

          .value {
            font-size: 13px;
            color: #409eff;
            font-weight: 600;
            margin-right: 12px;
          }

          .progress-bar {
            width: 80px;
          }
        }
      }
    }
  }

  .bottom-row {
    .ranking-card, .quick-card {
      margin-bottom: 16px;
      border-radius: 8px;

      :deep(.el-card__header) {
        padding: 12px 16px;
        border-bottom: 1px solid #ebeef5;
      }

      :deep(.el-card__body) {
        padding: 16px;
      }

      .card-header {
        font-size: 14px;
        font-weight: 600;
        color: #303133;
      }

      .chart-container {
        height: 280px;
      }
    }

    .quick-actions {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 10px;

      .action-btn {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 8px;
        padding: 16px;
        background: #f5f7fa;
        border: 1px solid #e4e7ed;
        border-radius: 8px;
        color: #606266;
        transition: all 0.3s;

        &:hover {
          background: #409eff;
          color: #fff;
          border-color: #409eff;
        }

        .el-icon {
          font-size: 20px;
        }

        span:last-child {
          font-size: 13px;
        }
      }
    }
  }
}

@media (max-width: 1200px) {
  .dashboard-container {
    .charts-row {
      .chart-card {
        .chart-container {
          height: 240px;
        }
      }
    }
  }
}
</style>
