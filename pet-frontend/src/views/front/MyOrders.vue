<template>
  <div class="home-container">
    <!-- 动态粒子背景 -->
    <div id="particles" class="particles-bg"></div>

    <!-- 主内容区 -->
    <div class="main-content">
      <div class="orders-header">
        <h2 class="title">我的订单</h2>
        <div class="actions">
          <el-button type="primary" @click="goToShop" icon="el-icon-shopping-cart-full">继续购物</el-button>
        </div>
      </div>

      <div class="orders-content">
        <el-tabs v-model="activeTab" type="card" @tab-click="handleTabClick">
          <el-tab-pane label="全部订单" name="all"></el-tab-pane>
          <el-tab-pane label="待付款" name="待付款"></el-tab-pane>
          <el-tab-pane label="待发货" name="待发货"></el-tab-pane>
          <el-tab-pane label="待收货" name="待收货"></el-tab-pane>
          <el-tab-pane label="已完成" name="已完成"></el-tab-pane>
          <el-tab-pane label="已取消" name="已取消"></el-tab-pane>
        </el-tabs>

        <div v-if="tableData.length === 0" class="empty-tab-content">
          <i class="el-icon-tickets"></i>
          <p>当前没有{{ activeTab === 'all' ? '' : activeTab }}订单记录</p>
          <el-button type="primary" @click="goToShop">去购物</el-button>
        </div>

        <div v-else class="order-list">
          <div v-for="(order, index) in tableData" :key="order.id" class="order-item">
            <div class="order-header">
              <div class="order-info">
                <span class="order-no">订单号：{{ order.orderNo }}</span>
                <span class="order-time">下单时间：{{ order.createTime }}</span>
              </div>
              <div class="order-status">
                <el-tag :type="getStatusType(order.status)">{{ order.status }}</el-tag>
              </div>
            </div>

            <div class="order-products">
              <div class="product-item">
                <div class="product-image">
                  <el-image :src="order.img || '/default.png'" :preview-src-list="[order.img || '/default.png']" style="width: 80px; height: 80px; object-fit: cover;"></el-image>
                </div>
                <div class="product-info">
                  <div class="product-name">{{ order.productName }}</div>
                  <div class="product-price">¥{{ order.productPrice }} × {{ order.quantity }}</div>
                </div>
              </div>
            </div>

            <div class="order-footer">
              <div class="order-amount">
                <span>共{{ order.quantity }}件商品，实付：</span>
                <span class="price">¥{{ order.totalAmount }}</span>
              </div>
              <div class="order-actions">
                <el-button 
                  v-if="order.status === '待付款'" 
                  type="primary" 
                  size="small" 
                  @click="showPayDialog(order.id)">去支付</el-button>
                <el-button 
                  v-if="order.status === '待付款'" 
                  type="danger" 
                  size="small" 
                  @click="cancelOrder(order.id)">取消订单</el-button>
                <el-button 
                  v-if="order.status === '待发货'" 
                  type="info" 
                  size="small" 
                  disabled>等待发货</el-button>
                <el-button 
                  v-if="order.status === '待收货'" 
                  type="success" 
                  size="small" 
                  @click="confirmReceive(order.id)">确认收货</el-button>
                <el-button 
                  v-if="['已完成', '已取消'].includes(order.status)" 
                  type="danger" 
                  size="small" 
                  @click="deleteOrder(order.id)">删除订单</el-button>
                <el-button 
                  v-if="order.status === '已完成'" 
                  type="primary" 
                  size="small" 
                  @click="reviewOrder(order)">评价</el-button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 支付方式对话框 -->
    <el-dialog title="选择支付方式" :visible.sync="payDialogVisible" width="400px" class="pay-dialog">
      <div class="pay-methods">
        <div class="pay-method" :class="{ active: payMethod === 'alipay' }" @click="payMethod = 'alipay'">
          <i class="el-icon-money"></i>
          <span>支付宝支付</span>
        </div>
        <div class="pay-method" :class="{ active: payMethod === 'wechat' }" @click="payMethod = 'wechat'">
          <i class="el-icon-mobile-phone"></i>
          <span>微信支付</span>
        </div>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="payDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="pay">确认支付</el-button>
      </div>
    </el-dialog>

    <!-- 评价对话框 -->
    <el-dialog title="评价订单" :visible.sync="reviewDialogVisible" width="500px" class="review-dialog">
      <div class="review-form">
        <div v-for="(item, index) in currentOrderItems" :key="index" class="review-item">
          <div class="product-info">
            <el-image :src="item.img" style="width: 60px; height: 60px; object-fit: cover;"></el-image>
            <div class="product-name">{{ item.productName }}</div>
          </div>
          <div class="rating">
            <span>评分：</span>
            <el-rate v-model="item.rating" :colors="['#99A9BF', '#F7BA2A', '#FF9900']"></el-rate>
          </div>
          <el-input
            type="textarea"
            :rows="3"
            placeholder="请输入您的评价内容"
            v-model="item.comment">
          </el-input>
        </div>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="reviewDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitReview">提交评价</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "MyOrders",
  data() {
    return {
      tableData: [],
      originalData: [],
      activeTab: 'all',
      payDialogVisible: false,
      reviewDialogVisible: false,
      payMethod: 'alipay',
      currentOrderId: null,
      currentOrderItems: []
    }
  },
  created() {
    this.loadOrders();
  },
  methods: {
    loadOrders() {
      this.request.get("/pet-order/user/page", {
        params: {
          pageNum: 1,
          pageSize: 10,
          status: this.activeTab !== 'all' ? this.activeTab : ''
        }
      }).then(res => {
        if (res.code === '200') {
          console.log("订单数据响应:", res.data);
          this.originalData = res.data.records || [];
          this.tableData = [...this.originalData];
        } else {
          console.error("获取订单失败:", res.msg);
        }
      }).catch(err => {
        console.error("请求出错:", err);
      });
    },
    handleTabClick() {
      console.log("切换到标签:", this.activeTab);
      
      // 从服务器重新加载数据
      this.request.get("/pet-order/user/page", {
        params: {
          pageNum: 1,
          pageSize: 10,
          status: this.activeTab !== 'all' ? this.activeTab : ''
        }
      }).then(res => {
        if (res.code === '200') {
          console.log("订单数据响应:", res.data);
          this.originalData = res.data.records || [];
          this.tableData = [...this.originalData];
        } else {
          this.$message.error(res.msg || "获取订单失败");
          console.error("获取订单失败:", res.msg);
        }
      }).catch(err => {
        this.$message.error("请求出错");
        console.error("请求出错:", err);
      });
    },
    getStatusType(status) {
      const statusMap = {
        '待付款': 'warning',
        '待发货': 'primary',
        '待收货': 'success',
        '已完成': 'info',
        '已取消': 'danger'
      };
      return statusMap[status] || 'info';
    },
    goToShop() {
      this.$router.push('/front/petShop');
    },
    showPayDialog(orderId) {
      this.currentOrderId = orderId;
      this.payDialogVisible = true;
    },
    pay() {
      // 模拟支付过程
      this.request.post(`/pet-order/pay/${this.currentOrderId}`, {
        payMethod: this.payMethod,
        tradeNo: 'MOCK_' + Date.now() // 模拟交易号
      }).then(res => {
        if (res.code === '200') {
          this.$message.success(`使用${this.payMethod === 'alipay' ? '支付宝' : '微信'}支付成功`);
          this.payDialogVisible = false;
          this.loadOrders(); // 重新加载订单列表
        } else {
          this.$message.error(res.msg || "支付失败");
        }
      });
    },
    cancelOrder(orderId) {
      this.$confirm('确定要取消该订单吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.request.post(`/pet-order/cancel/${orderId}`).then(res => {
          if (res.code === '200') {
            this.$message.success("订单已取消");
            this.loadOrders();
          } else {
            this.$message.error(res.msg || "取消失败");
          }
        });
      }).catch(() => {});
    },
    confirmReceive(orderId) {
      this.$confirm('确认已收到商品?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'info'
      }).then(() => {
        this.request.post(`/pet-order/complete/${orderId}`).then(res => {
          if (res.code === '200') {
            this.$message.success("确认收货成功");
            this.loadOrders();
          } else {
            this.$message.error(res.msg || "操作失败");
          }
        });
      }).catch(() => {});
    },
    deleteOrder(orderId) {
      this.$confirm('确定要删除该订单吗? 删除后将无法恢复', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.request.delete(`/pet-order/${orderId}`).then(res => {
          if (res.code === '200') {
            this.$message.success("订单已删除");
            this.loadOrders();
          } else {
            this.$message.error(res.msg || "删除失败");
          }
        });
      }).catch(() => {});
    },
    reviewOrder(order) {
      // 准备评价数据
      this.currentOrderItems = [{
        img: order.img || '/default.png',
        productName: order.productName,
        rating: 5, // 默认5星
        comment: ''
      }];
      this.reviewDialogVisible = true;
    },
    submitReview() {
      // 在实际项目中，这里应该调用后端接口保存评价
      this.$message.success("评价提交成功");
      this.reviewDialogVisible = false;
    }
  }
}
</script>

<style lang="scss">
.home-container {
  min-height: 100vh;
  background: #FFFBF0;
  position: relative;
  overflow: hidden;

  .particles-bg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
  }

  .main-content {
    position: relative;
    z-index: 2;
    padding: 30px;
    max-width: 1200px;
    margin: 0 auto;

    .orders-header {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 15px;
      padding: 20px;
      margin-bottom: 25px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);

      .title {
        margin: 0;
        color: #2d3748;
        font-size: 24px;
      }

      .actions {
        display: flex;
        gap: 10px;
      }
    }

    .empty-orders {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 15px;
      padding: 80px 20px;
      text-align: center;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);

      i {
        font-size: 60px;
        color: #a0aec0;
        margin-bottom: 20px;
      }

      p {
        font-size: 18px;
        color: #4a5568;
        margin-bottom: 30px;
      }
    }

    .orders-content {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 15px;
      overflow: hidden;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
      padding: 20px;

      .el-tabs {
        margin-bottom: 20px;
      }

      .order-list {
        .order-item {
          border: 1px solid #e2e8f0;
          border-radius: 10px;
          margin-bottom: 20px;
          overflow: hidden;

          .order-header {
            background: #f9fafb;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e2e8f0;

            .order-info {
              display: flex;
              gap: 20px;

              .order-no, .order-time {
                color: #4a5568;
                font-size: 14px;
              }
            }
          }

          .order-products {
            padding: 15px;

            .product-item {
              display: flex;
              padding: 10px 0;
              border-bottom: 1px dashed #e2e8f0;

              &:last-child {
                border-bottom: none;
              }

              .product-info {
                margin-left: 15px;
                display: flex;
                flex-direction: column;
                justify-content: center;

                .product-name {
                  font-size: 16px;
                  color: #2d3748;
                  margin-bottom: 5px;
                }

                .product-price {
                  color: #a0aec0;
                  font-size: 14px;
                }
              }
            }
          }

          .order-footer {
            padding: 15px;
            background: #f9fafb;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid #e2e8f0;

            .order-amount {
              color: #4a5568;
              
              .price {
                font-size: 18px;
                font-weight: bold;
                color: #f56c6c;
              }
            }

            .order-actions {
              display: flex;
              gap: 10px;
            }
          }
        }
      }
    }

    .empty-tab-content {
      padding: 60px 20px;
      text-align: center;
      
      i {
        font-size: 60px;
        color: #a0aec0;
        margin-bottom: 20px;
      }

      p {
        font-size: 18px;
        color: #4a5568;
        margin-bottom: 30px;
      }
    }
  }
}

.pay-dialog {
  .pay-methods {
    display: flex;
    justify-content: space-around;
    padding: 20px 0;

    .pay-method {
      width: 120px;
      height: 120px;
      border-radius: 10px;
      border: 2px solid #e2e8f0;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      cursor: pointer;
      transition: all 0.3s ease;

      i {
        font-size: 40px;
        margin-bottom: 10px;
        color: #a0aec0;
      }

      span {
        color: #4a5568;
      }

      &:hover {
        border-color: #ff9f43;
        background: rgba(102, 126, 234, 0.05);
      }

      &.active {
        border-color: #ff9f43;
        background: rgba(102, 126, 234, 0.1);

        i {
          color: #ff9f43;
        }

        span {
          color: #2d3748;
          font-weight: bold;
        }
      }
    }
  }
}

.review-dialog {
  .review-form {
    .review-item {
      margin-bottom: 20px;
      padding-bottom: 20px;
      border-bottom: 1px dashed #e2e8f0;

      &:last-child {
        border-bottom: none;
      }

      .product-info {
        display: flex;
        align-items: center;
        margin-bottom: 15px;

        .product-name {
          margin-left: 15px;
          color: #2d3748;
        }
      }

      .rating {
        margin-bottom: 15px;
        display: flex;
        align-items: center;

        span {
          margin-right: 10px;
          color: #4a5568;
        }
      }
    }
  }
}
</style> 