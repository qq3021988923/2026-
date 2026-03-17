<template>
  <div class="order-container">
    <el-card class="header-card" shadow="never">
      <div class="header-section">
        <div class="toolbar">
          <el-input
            v-model="searchKeyword"
            placeholder="按订单号搜索"
            clearable
            style="width: 200px"
            @keyup.enter="handleSearch"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button type="info" @click="openAddModal">
            <el-icon><Plus /></el-icon>
            新增订单
          </el-button>
          <el-button type="warning" @click="exportExcel">
            <el-icon><Download /></el-icon>
            导出Excel
          </el-button>
        </div>
      </div>
    </el-card>

    <el-skeleton v-if="loading" :rows="5" animated />
    <el-empty v-else-if="error" :description="error" />
    
    <template v-else>
      <el-row :gutter="16" class="order-cards" v-if="orders.length > 0">
        <el-col :xs="24" :sm="12" :lg="8" v-for="order in pagedOrders" :key="order.id">
          <el-card class="order-card" shadow="hover">
            <template #header>
              <div class="card-header">
                <div class="order-title">
                  <el-tag type="info" size="small">订单</el-tag>
                  <span class="order-num">{{ order.num || '-' }}</span>
                </div>
                <el-tag :type="order.logisticsStatus === 5 ? 'success' : 'warning'" size="small">
                  {{ order.logisticsStatus === 5 ? '已完成' : getLogisticsStatusText(order.logisticsStatus) }}
                </el-tag>
              </div>
            </template>
            <div class="card-body">
              <div class="goods-info">
                <span class="goods-name">{{ order.name || '-' }}</span>
                <el-tag v-if="order.brand" size="small" effect="plain">{{ order.brand }}</el-tag>
              </div>
              <div class="order-detail">
                <span class="quantity">数量: {{ order.number || 0 }} {{ order.unit || '件' }}</span>
                <span class="price">¥{{ order.total || 0 }}</span>
              </div>
            </div>
            <template #footer>
              <div class="card-footer">
                <span class="order-time">
                  <el-icon><Clock /></el-icon>
                  {{ order.createTime || '-' }}
                </span>
                <div class="card-actions">
                  <el-button type="primary" size="small" @click="openDetailModal(order)">
                    <el-icon><View /></el-icon>
                    详情
                  </el-button>
                  <el-button type="danger" size="small" @click="handleDelete(order.id)">
                    <el-icon><Delete /></el-icon>
                    删除
                  </el-button>
                </div>
              </div>
            </template>
          </el-card>
        </el-col>
      </el-row>
      <el-empty v-else description="暂无订单数据" />
    </template>

    <el-pagination
      v-if="orders.length > 0"
      class="pagination"
      v-model:current-page="currentPage"
      v-model:page-size="pageSize"
      :page-sizes="[6, 12, 24]"
      :total="orders.length"
      layout="total, sizes, prev, pager, next, jumper"
      background
    />

    <!-- 新增/编辑弹窗 -->
    <el-dialog
      v-model="showModal"
      :title="isEdit ? '编辑订单' : '新增订单'"
      width="900px"
      :close-on-click-modal="false"
    >
      <el-form :model="formData" label-width="80px">
        <el-divider content-position="left">基本信息</el-divider>
        <el-row :gutter="16">
          <el-col :span="8">
            <el-form-item label="业务员">
              <el-input :value="userName" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户">
              <el-select v-model="formData.customerId" placeholder="请选择客户" style="width: 100%">
                <el-option v-for="customer in customerOptions" :key="customer.id" :label="customer.name" :value="customer.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="到达城市">
              <el-select v-model="formData.citi" placeholder="请选择城市" style="width: 100%">
                <el-option v-for="item in intervalOptions" :key="item.baseId" :label="item.baseName" :value="item.baseName" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="8">
            <el-form-item label="收货地址">
              <el-input v-model="formData.address" placeholder="请输入收货地址" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="收货人">
              <el-input v-model="formData.person" placeholder="请输入收货人" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="联系电话">
              <el-input v-model="formData.phone" placeholder="请输入联系电话" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="8">
            <el-form-item label="付款方式">
              <el-select v-model="formData.payment" placeholder="请选择" style="width: 100%">
                <el-option v-for="item in paymentOptions" :key="item.baseId" :label="item.baseName" :value="item.baseName" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="货运方式">
              <el-select v-model="formData.shipping" placeholder="请选择" style="width: 100%">
                <el-option v-for="item in shippingOptions" :key="item.baseId" :label="item.baseName" :value="item.baseName" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="取件方式">
              <el-select v-model="formData.takeMethod" placeholder="请选择" style="width: 100%">
                <el-option v-for="item in pickupOptions" :key="item.baseId" :label="item.baseName" :value="item.baseName" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="订单备注">
              <el-input v-model="formData.desc" placeholder="请输入订单备注" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-divider content-position="left">
          货物明细
          <el-button type="primary" size="small" @click="addGoodsRow" style="margin-left: 10px">
            <el-icon><Plus /></el-icon>
            添加货物
          </el-button>
        </el-divider>
        <el-table :data="goodsList" border style="width: 100%">
          <el-table-column label="货物名称" min-width="120">
            <template #default="{ row }">
              <el-input v-model="row.name" placeholder="货物名称" />
            </template>
          </el-table-column>
          <el-table-column label="数量" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.number" :min="0" controls-position="right" @change="calculateRowTotal(goodsList.indexOf(row))" />
            </template>
          </el-table-column>
          <el-table-column label="单位" width="100">
            <template #default="{ row }">
              <el-select v-model="row.unit" style="width: 100%">
                <el-option v-for="u in unitOptions" :key="u.baseId" :label="u.baseName" :value="u.baseName" />
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="单价" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.price" :min="0" :precision="2" controls-position="right" @change="calculateRowTotal(goodsList.indexOf(row))" />
            </template>
          </el-table-column>
          <el-table-column label="总价" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.total" :disabled="true" controls-position="right" />
            </template>
          </el-table-column>
          <el-table-column label="品牌" min-width="100">
            <template #default="{ row }">
              <el-input v-model="row.brand" placeholder="品牌" />
            </template>
          </el-table-column>
          <el-table-column label="操作" width="70">
            <template #default="{ $index }">
              <el-button type="danger" size="small" :disabled="goodsList.length <= 1" @click="removeGoodsRow($index)">
                <el-icon><Delete /></el-icon>
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-form>
      <template #footer>
        <el-button @click="showModal = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">提交订单</el-button>
      </template>
    </el-dialog>

    <!-- 订单详情弹窗 -->
    <el-dialog
      v-model="showDetailModal"
      title="订单详情"
      width="700px"
    >
      <el-tabs v-model="detailTab">
        <el-tab-pane label="订单信息" name="info">
          <el-descriptions title="基本信息" :column="2" border>
            <el-descriptions-item label="订单号">{{ detailOrder.num || '-' }}</el-descriptions-item>
            <el-descriptions-item label="业务员">{{ userName || '-' }}</el-descriptions-item>
            <el-descriptions-item label="下单时间">{{ detailOrder.createTime || '-' }}</el-descriptions-item>
            <el-descriptions-item label="订单状态">
              <el-tag :type="detailOrder.logisticsStatus === 5 ? 'success' : 'warning'" size="small">
                {{ detailOrder.logisticsStatus === 5 ? '已完成' : getLogisticsStatusText(detailOrder.logisticsStatus) }}
              </el-tag>
            </el-descriptions-item>
          </el-descriptions>
          <el-descriptions title="收货信息" :column="2" border style="margin-top: 16px">
            <el-descriptions-item label="收货人">{{ detailOrder.person || '-' }}</el-descriptions-item>
            <el-descriptions-item label="联系电话">{{ detailOrder.phone || '-' }}</el-descriptions-item>
            <el-descriptions-item label="到达城市">{{ detailOrder.citi || '-' }}</el-descriptions-item>
            <el-descriptions-item label="收货地址">{{ detailOrder.address || '-' }}</el-descriptions-item>
          </el-descriptions>
          <el-descriptions title="货物信息" :column="2" border style="margin-top: 16px">
            <el-descriptions-item label="货物名称">{{ detailOrder.name || '-' }}</el-descriptions-item>
            <el-descriptions-item label="品牌">{{ detailOrder.brand || '-' }}</el-descriptions-item>
            <el-descriptions-item label="数量">{{ detailOrder.number || 0 }} {{ detailOrder.unit || '件' }}</el-descriptions-item>
            <el-descriptions-item label="单价">¥{{ detailOrder.price || 0 }}</el-descriptions-item>
            <el-descriptions-item label="总价">
              <span style="color: #f56c6c; font-size: 16px; font-weight: bold">¥{{ detailOrder.total || 0 }}</span>
            </el-descriptions-item>
          </el-descriptions>
          <el-descriptions title="配送信息" :column="2" border style="margin-top: 16px">
            <el-descriptions-item label="货运方式">{{ detailOrder.shipping || '-' }}</el-descriptions-item>
            <el-descriptions-item label="付款方式">{{ detailOrder.payment || '-' }}</el-descriptions-item>
            <el-descriptions-item label="取件方式">{{ detailOrder.pickup || '-' }}</el-descriptions-item>
            <el-descriptions-item label="备注">{{ detailOrder.desc || '-' }}</el-descriptions-item>
          </el-descriptions>
        </el-tab-pane>
        <el-tab-pane label="物流追踪" name="logistics">
          <LogisticsTimeline :orderId="detailOrder.id" :showUpdateBtn="true" @updated="onLogisticsUpdated" />
        </el-tab-pane>
      </el-tabs>
      <template #footer>
        <el-button type="warning" @click="editFromDetail">
          <el-icon><Edit /></el-icon>
          编辑订单
        </el-button>
        <el-button type="primary" @click="handlePrint">
          <el-icon><Printer /></el-icon>
          打印运单
        </el-button>
        <el-button @click="showDetailModal = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 删除确认对话框 -->
    <el-dialog
      v-model="deleteConfirmModal"
      title="删除确认"
      width="400px"
    >
      <p style="text-align: center; color: #606266;">确定要删除此订单吗？删除后将无法恢复。</p>
      <template #footer>
        <el-button @click="cancelDelete">取消</el-button>
        <el-button type="danger" @click="confirmDelete">删除</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getOrderList, searchOrder, addOrder, updateOrder, deleteOrder, getOrderDetails, exportOrders } from '@/api/order'
import { getLatestLogistics } from '@/api/logistics'
import { getFinanceByOrderId } from '@/api/finance'
import LogisticsTimeline from '@/components/LogisticsTimeline.vue'

const orders = ref([])
const loading = ref(false)
const error = ref(null)

const currentPage = ref(1)
const pageSize = ref(6)
const totalPages = computed(() => Math.ceil(orders.value.length / pageSize.value) || 1)
const pagedOrders = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  return orders.value.slice(start, start + pageSize.value)
})
const searchKeyword = ref('')
const showModal = ref(false)
const isEdit = ref(false)
const showDetailModal = ref(false)
const detailOrder = ref({})
const detailTab = ref('info')
const detailPaidAmount = ref(0)
const formData = ref({
  id: null,
  num: '',
  address: '',
  phone: '',
  desc: '',
  person: '',
  customerId: '',
  citi: '',
  shippingName: '',
  payment: '全款',
  shipping: '海运',
  takeMethod: '上门取件'
})

const userName = ref('')
const userPhone = ref('')
const customerOptions = ref([])
const intervalOptions = ref([])
const shippingOptions = ref([])
const paymentOptions = ref([])
const pickupOptions = ref([])
const unitOptions = ref([])

const goodsList = ref([
  { name: '', number: null, unit: '件', price: null, total: null, brand: '' }
])

const calculateRowTotal = (index) => {
  const item = goodsList.value[index]
  const num = item.number || 0
  const price = item.price || 0
  item.total = num * price
}

const addGoodsRow = () => {
  goodsList.value.push({ name: '', number: null, unit: '件', price: null, total: null, brand: '' })
}

const removeGoodsRow = (index) => {
  if (goodsList.value.length > 1) {
    goodsList.value.splice(index, 1)
  }
}

const deleteConfirmModal = ref(false)
const deleteOrderId = ref(null)

const getLogisticsStatusText = (status) => {
  const statusMap = {
    1: '待取件',
    2: '已取件', 
    3: '运输中',
    4: '已送达',
    5: '已完成'
  }
  return statusMap[status] || '待处理'
}

// 获取订单列表
const fetchOrders = async () => {
  loading.value = true
  error.value = null
  try {
    const userId = localStorage.getItem('userId')
    const res = await getOrderList(userId)
    if (res && res.code === 200) {
      const orderList = res.data || []
      // 并行获取所有订单的物流状态
      await Promise.all(orderList.map(async (order) => {
        try {
          const logRes = await getLatestLogistics(order.id)
          order.logisticsStatus = (logRes && logRes.code === 200 && logRes.data) ? logRes.data.status : 0
        } catch {
          order.logisticsStatus = 0
        }
      }))
      orders.value = orderList
    }
  } catch (err) {
    console.error('获取订单列表失败:', err)
    error.value = err.message
  } finally {
    loading.value = false
  }
}

// 搜索订单
const handleSearch = async () => {
  if (!searchKeyword.value.trim()) {
    fetchOrders()
    return
  }
  loading.value = true
  error.value = null
  try {
    const userId = localStorage.getItem('userId')
    const res = await searchOrder({ 
      userId: userId ? Number(userId) : null,
      num: searchKeyword.value.trim() 
    })
    if (res && res.code === 200) {
      const orderList = res.data || []
      // 并行获取所有订单的物流状态
      await Promise.all(orderList.map(async (order) => {
        try {
          const logRes = await getLatestLogistics(order.id)
          order.logisticsStatus = (logRes && logRes.code === 200 && logRes.data) ? logRes.data.status : 0
        } catch {
          order.logisticsStatus = 0
        }
      }))
      orders.value = orderList
    }
  } catch (err) {
    console.error('搜索订单失败:', err)
    error.value = err.message
  } finally {
    loading.value = false
  }
}

// 打开详情弹窗
const openDetailModal = async (order) => {
  detailOrder.value = { ...order }
  detailTab.value = 'info'
  detailPaidAmount.value = 0
  // 获取业务员信息
  if (!userName.value || !userPhone.value) {
    try {
      const userId = localStorage.getItem('userId')
      if (userId) {
        const res = await getOrderDetails(userId)
        if (res && res.code === 200 && res.data) {
          userName.value = res.data.uname || ''
          // 从localStorage获取完整用户信息
          const userInfoStr = localStorage.getItem('userInfo')
          if (userInfoStr) {
            const userInfo = JSON.parse(userInfoStr)
            userPhone.value = userInfo.phone || ''
          }
        }
      }
    } catch (err) {
      console.error('获取业务员信息失败:', err)
    }
  }
  // 获取财务信息
  try {
    const financeRes = await getFinanceByOrderId(order.id)
    if (financeRes && financeRes.code === 200 && financeRes.data) {
      detailPaidAmount.value = financeRes.data.paidAmount || 0
    }
  } catch (err) {
    console.error('获取财务信息失败:', err)
  }
  showDetailModal.value = true
}

// 物流状态更新后的回调
const onLogisticsUpdated = async () => {
  // 更新当前订单的物流状态
  try {
    const logRes = await getLatestLogistics(detailOrder.value.id)
    if (logRes && logRes.code === 200 && logRes.data) {
      detailOrder.value.logisticsStatus = logRes.data.status
      // 同步更新列表中的订单状态
      const order = orders.value.find(o => o.id === detailOrder.value.id)
      if (order) {
        order.logisticsStatus = logRes.data.status
      }
    }
  } catch (err) {
    console.error('更新物流状态失败:', err)
  }
}

// 打开新增弹窗
const openAddModal = async () => {
  isEdit.value = false
  formData.value = { 
    id: null, num: '', address: '', phone: '', desc: '',
    person: '', customerId: '', citi: '', shippingName: '',
    payment: '', shipping: '', takeMethod: ''
  }
  goodsList.value = [{ name: '', number: null, unit: '', price: null, total: null, brand: '' }]
  
  // 获取关联数据
  try {
    const userId = localStorage.getItem('userId')
    if (userId) {
      const res = await getOrderDetails(userId)
      if (res && res.code === 200 && res.data) {
        const data = res.data
        // 业务员名字（只读）
        userName.value = data.uname || ''
        // 客户列表
        if (data.customers && data.customers.length > 0) {
          customerOptions.value = data.customers
          formData.value.customerId = data.customers[0].id
        }
        // 到达城市
        if (data.interval && data.interval.length > 0) {
          intervalOptions.value = data.interval
          formData.value.citi = data.interval[0].baseName
        }
        // 运货方式
        if (data.shipping && data.shipping.length > 0) {
          shippingOptions.value = data.shipping
          formData.value.shipping = data.shipping[0].baseName
        }
        // 付款方式
        if (data.payment && data.payment.length > 0) {
          paymentOptions.value = data.payment
          formData.value.payment = data.payment[0].baseName
        }
        // 取货方式
        if (data.pickup && data.pickup.length > 0) {
          pickupOptions.value = data.pickup
          formData.value.takeMethod = data.pickup[0].baseName
        }
        // 单位
        if (data.unit && data.unit.length > 0) {
          unitOptions.value = data.unit
          goodsList.value[0].unit = data.unit[0].baseName
        }
      }
    }
  } catch (err) {
    console.error('获取订单详情数据失败:', err)
  }
  
  showModal.value = true
}

// 打开编辑弹窗
const openEditModal = async (order) => {
  isEdit.value = true
  formData.value = { ...order }
  goodsList.value = [{ 
    name: order.name || '', 
    number: order.number || null, 
    unit: order.unit || '', 
    price: order.price || null, 
    total: order.total || null, 
    brand: order.brand || '' 
  }]
  
  // 获取关联数据
  try {
    const userId = localStorage.getItem('userId')
    if (userId) {
      const res = await getOrderDetails(userId)
      if (res && res.code === 200 && res.data) {
        const data = res.data
        userName.value = data.uname || ''
        if (data.customers) customerOptions.value = data.customers
        if (data.interval) intervalOptions.value = data.interval
        if (data.shipping) shippingOptions.value = data.shipping
        if (data.payment) paymentOptions.value = data.payment
        if (data.pickup) pickupOptions.value = data.pickup
        if (data.unit) unitOptions.value = data.unit
      }
    }
  } catch (err) {
    console.error('获取订单详情数据失败:', err)
  }
  
  showModal.value = true
}

const handleSubmit = async () => {
  for (let i = 0; i < goodsList.value.length; i++) {
    if (!goodsList.value[i].name?.trim()) {
      ElMessage.error(`请填写第${i + 1}个货物名称`)
      return
    }
  }
  try {
    let res
    const userId = localStorage.getItem('userId')
    
    if (isEdit.value) {
      const firstGoods = goodsList.value[0]
      const submitData = {
        id: formData.value.id,
        userId: Number(userId),
        customerId: formData.value.customerId,
        address: formData.value.address,
        phone: formData.value.phone,
        person: formData.value.person,
        citi: formData.value.citi,
        payment: formData.value.payment,
        shipping: formData.value.shipping,
        pickup: formData.value.takeMethod,
        desc: formData.value.desc,
        name: firstGoods.name,
        number: firstGoods.number,
        unit: firstGoods.unit,
        price: firstGoods.price,
        total: firstGoods.total,
        brand: firstGoods.brand
      }
      res = await updateOrder(submitData)
    } else {
      const submitData = {
        userId: Number(userId),
        customerId: formData.value.customerId,
        address: formData.value.address,
        phone: formData.value.phone,
        person: formData.value.person,
        citi: formData.value.citi,
        payment: formData.value.payment,
        shipping: formData.value.shipping,
        pickup: formData.value.takeMethod,
        desc: formData.value.desc,
        items: goodsList.value
      }
      console.log('提交订单数据:', submitData)
      res = await addOrder(submitData)
    }
    
    if (res && res.code === 200) {
      showModal.value = false
      const count = isEdit.value ? 1 : goodsList.value.length
      ElMessage.success(isEdit.value ? '订单更新成功' : `下单成功，共${count}个订单`)
      fetchOrders()
    } else {
      ElMessage.error(res?.message || '操作失败')
    }
  } catch (err) {
    console.error('操作失败:', err)
    ElMessage.error('操作失败')
  }
}

// 从详情页编辑订单
const editFromDetail = () => {
  showDetailModal.value = false
  openEditModal(detailOrder.value)
}

// 删除订单
const handleDelete = (id) => {
  deleteOrderId.value = id
  deleteConfirmModal.value = true
}

const confirmDelete = async () => {
  try {
    const res = await deleteOrder(deleteOrderId.value)
    if (res && res.code === 200) {
      ElMessage.success('订单删除成功')
      fetchOrders()
    } else {
      ElMessage.error(res?.message || '删除失败')
    }
  } catch (err) {
    console.error('删除失败:', err)
    ElMessage.error('删除失败')
  } finally {
    deleteConfirmModal.value = false
    deleteOrderId.value = null
  }
}

const cancelDelete = () => {
  deleteConfirmModal.value = false
  deleteOrderId.value = null
}

const exportExcel = async () => {
  if (orders.value.length === 0) {
    ElMessage.warning('暂无数据可导出')
    return
  }
  
  try {
    ElMessage.info('正在导出，请稍候...')
    
    const userId = localStorage.getItem('userId')
    const params = userId ? { userId: Number(userId) } : {}
    
    const response = await exportOrders(params)
    
    const url = window.URL.createObjectURL(response)
    const link = document.createElement('a')
    link.href = url
    link.download = `订单导出_${new Date().toLocaleDateString()}.xlsx`
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    window.URL.revokeObjectURL(url)
    
    ElMessage.success('导出成功')
  } catch (error) {
    console.error('导出失败:', error)
    ElMessage.error('导出失败，请重试')
  }
}

// 打印运单
const handlePrint = () => {
  const order = detailOrder.value
  const printWindow = window.open('', '_blank')
  const printContent = `
    <!DOCTYPE html>
    <html>
    <head>
      <title>运单 - ${order.num}</title>
      <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Microsoft YaHei', sans-serif; padding: 20px; background: #fff; }
        .waybill { width: 800px; margin: 0 auto; border: 2px solid #000; }
        .header { background: #f0f0f0; color: #000; padding: 15px; text-align: center; border-bottom: 2px solid #000; }
        .header h1 { font-size: 26px; margin-bottom: 5px; letter-spacing: 2px; font-weight: bold; }
        .header p { font-size: 14px; color: #666; }
        .info-row { display: flex; border-bottom: 1px solid #000; }
        .info-section { flex: 1; padding: 12px 15px; border-right: 1px solid #000; }
        .info-section:last-child { border-right: none; }
        .section-title { font-weight: bold; color: #000; margin-bottom: 10px; font-size: 14px; border-bottom: 1px dashed #999; padding-bottom: 5px; }
        .info-item { display: flex; margin-bottom: 6px; font-size: 13px; }
        .info-item label { width: 70px; color: #333; flex-shrink: 0; font-weight: 500; }
        .info-item span { color: #000; flex: 1; }
        .goods-section { padding: 12px 15px; border-bottom: 1px solid #000; }
        .goods-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .goods-table th, .goods-table td { border: 1px solid #000; padding: 8px; text-align: center; font-size: 13px; }
        .goods-table th { background: #e8e8e8; font-weight: bold; }
        .total-row { background: #f5f5f5; }
        .total-row td { font-weight: bold; }
        .sign-section { display: flex; padding: 15px; border-bottom: 1px solid #000; }
        .sign-item { flex: 1; font-size: 13px; }
        .sign-line { border-bottom: 1px solid #000; width: 120px; display: inline-block; margin-left: 5px; }
        .footer { background: #f5f5f5; padding: 10px; text-align: center; font-size: 11px; color: #333; }
        @media print {
          body { padding: 0; }
          .waybill { border: 2px solid #000; }
        }
      </style>
    </head>
    <body>
      <div class="waybill">
        <div class="header">
          <h1>Guet 运货单据</h1>
          <p>Waybill</p>
        </div>
        
        <div class="info-row">
          <div class="info-section">
            <div class="section-title">订单信息</div>
            <div class="info-item"><label>运单号:</label><span>${order.num || '-'}</span></div>
            <div class="info-item"><label>下单时间:</label><span>${order.createTime || '-'}</span></div>
            <div class="info-item"><label>业务员:</label><span>${userName.value || '-'}${userPhone.value ? ' | phone :' + userPhone.value : ''}</span></div>
          </div>
          <div class="info-section">
            <div class="section-title">配送信息</div>
            <div class="info-item"><label>运输方式:</label><span>${order.shipping || '-'}</span></div>
            <div class="info-item"><label>付款方式:</label><span>${order.payment || '-'}</span></div>
            <div class="info-item"><label>取件方式:</label><span>${order.pickup || '-'}</span></div>
          </div>
        </div>
        
        <div class="info-row">
          <div class="info-section">
            <div class="section-title">收货人信息</div>
            <div class="info-item"><label>客户名称:</label><span>${order.customerName || '-'}</span></div>
            <div class="info-item"><label>联系电话:</label><span>${order.phone || '-'}</span></div>
            <div class="info-item"><label>到达城市:</label><span>${order.citi || '-'}</span></div>
            <div class="info-item"><label>详细地址:</label><span>${order.address || '-'}</span></div>
          </div>
          <div class="info-section">
            <div class="section-title">付款信息</div>
            <div class="info-item"><label>已付金额:</label><span style="font-weight: 500; border-bottom: 1px solid #999;">¥${detailPaidAmount.value || 0}</span></div>
            <div class="info-item"><label>未付金额:</label><span style="font-weight: 500; border-bottom: 1px solid #999;">¥${(order.total || 0) - (detailPaidAmount.value || 0)}</span></div>
          </div>
        </div>
        
        <div class="goods-section">
          <div class="section-title">货物明细</div>
          <table class="goods-table">
            <thead>
              <tr>
                <th>货物名称</th>
                <th>品牌</th>
                <th>数量</th>
                <th>单位</th>
                <th>单价(元)</th>
                <th>总价(元)</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>${order.name || '-'}</td>
                <td>${order.brand || '-'}</td>
                <td>${order.number || 0}</td>
                <td>${order.unit || '件'}</td>
                <td>${order.price || 0}</td>
                <td>${order.total || 0}</td>
              </tr>
              <tr class="total-row">
                <td colspan="5" style="text-align: right;">合计金额:</td>
                <td>¥${order.total || 0}</td>
              </tr>
            </tbody>
          </table>
        </div>
        
        <div class="sign-section">
          <div class="sign-item">签收人:<span class="sign-line"></span></div>
          <div class="sign-item">签收时间:<span class="sign-line"></span></div>
          <div class="sign-item">备注: ${order.desc || '无'}</div>
        </div>
        
        <div class="footer">
          打印时间: ${new Date().toLocaleString('zh-CN')} | Guet 运货单据
        </div>
      </div>
      
      <script>
        window.onload = function() {
          window.print();
        }
      <\/script>
    </body>
    </html>
  `
  printWindow.document.write(printContent)
  printWindow.document.close()
}

onMounted(() => {
  fetchOrders()
})
</script>


<style scoped lang="scss">
.order-container {
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

      .toolbar {
        display: flex;
        gap: 10px;
        align-items: center;
      }
    }
  }

  .order-cards {
    .order-card {
      margin-bottom: 16px;

      :deep(.el-card__header) {
        padding: 12px 16px;
        background: #f5f7fa;
      }

      :deep(.el-card__body) {
        padding: 16px;
      }

      :deep(.el-card__footer) {
        padding: 12px 16px;
        background: #fafafa;
      }

      .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;

        .order-title {
          display: flex;
          align-items: center;
          gap: 8px;

          .order-num {
            font-weight: 600;
            color: #303133;
          }
        }
      }

      .card-body {
        .goods-info {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 12px;

          .goods-name {
            font-size: 16px;
            font-weight: 600;
            color: #303133;
          }
        }

        .order-detail {
          display: flex;
          justify-content: space-between;
          align-items: center;

          .quantity {
            color: #909399;
            font-size: 14px;
          }

          .price {
            font-size: 18px;
            font-weight: 700;
            color: #f56c6c;
          }
        }
      }

      .card-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;

        .order-time {
          display: flex;
          align-items: center;
          gap: 4px;
          font-size: 13px;
          color: #909399;
        }

        .card-actions {
          display: flex;
          gap: 8px;
        }
      }
    }
  }

  .pagination {
    margin-top: 16px;
    display: flex;
    justify-content: center;
  }
}
</style>
