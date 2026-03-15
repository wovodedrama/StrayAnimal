<template>
  <div class="home-container">
    <!-- 动态粒子背景 -->
    <div id="particles" class="particles-bg"></div>

    <!-- 主内容区 -->
    <div class="main-content">
      <div class="cart-header">
        <h2 class="title">我的购物车</h2>
        <div class="actions">
          <el-button type="danger" @click="clearCart" icon="el-icon-delete">清空购物车</el-button>
          <el-button type="primary" @click="goToShop" icon="el-icon-shopping-cart-full">继续购物</el-button>
        </div>
      </div>

      <div v-if="tableData.length === 0" class="empty-cart">
        <i class="el-icon-shopping-cart-2"></i>
        <p>购物车为空，快去选购商品吧！</p>
        <el-button type="primary" @click="goToShop">去购物</el-button>
      </div>

      <div v-else class="cart-content">
        <el-table :data="tableData" border stripe class="cart-table">
          <el-table-column type="selection" width="55"></el-table-column>
          <el-table-column label="商品图片" width="180">
            <template slot-scope="scope">
              <el-image style="width: 100px; height: 100px; object-fit: cover;" 
                       :src="scope.row.img" :preview-src-list="[scope.row.img]">
              </el-image>
            </template>
          </el-table-column>
          <el-table-column prop="productName" label="商品名称"></el-table-column>
          <el-table-column label="单价" width="120">
            <template slot-scope="scope">
              <span class="price">¥{{ scope.row.price }}</span>
            </template>
          </el-table-column>
          <el-table-column label="数量" width="200">
            <template slot-scope="scope">
              <el-input-number v-model="scope.row.quantity" 
                             @change="(value) => updateQuantity(scope.row.id, value)"
                             :min="1" :max="scope.row.stock" size="mini">
              </el-input-number>
            </template>
          </el-table-column>
          <el-table-column label="小计" width="120">
            <template slot-scope="scope">
              <span class="price">¥{{ (scope.row.price * scope.row.quantity).toFixed(2) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="120" align="center">
            <template slot-scope="scope">
              <el-button type="danger" size="mini" @click="removeItem(scope.row.id)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>

        <div class="cart-footer">
          <div class="total-info">
            <div class="item">
              <span class="label">已选商品</span>
              <span class="value">{{ totalSelectedItems }}件</span>
            </div>
            <div class="item">
              <span class="label">合计</span>
              <span class="value price">¥{{ totalPrice.toFixed(2) }}</span>
            </div>
          </div>
          <el-button type="primary" size="large" class="checkout-btn" @click="checkout">去结算</el-button>
        </div>
      </div>
    </div>

    <!-- 结算对话框 -->
    <el-dialog title="订单确认" :visible.sync="checkoutDialogVisible" width="500px" class="checkout-dialog">
      <el-form :model="orderForm" label-width="100px" class="checkout-form">
        <el-form-item label="收货地址" required>
          <el-input v-model="orderForm.address" placeholder="请输入收货地址"></el-input>
        </el-form-item>
        <el-form-item label="联系电话" required>
          <el-input v-model="orderForm.phone" placeholder="请输入联系电话"></el-input>
        </el-form-item>
        <div class="order-summary">
          <h3>订单商品信息</h3>
          <div class="order-items">
            <div v-for="(item, index) in tableData" :key="index" class="order-item">
              <div class="item-name">{{ item.productName }} x {{ item.quantity }}</div>
              <div class="item-price">¥{{ (item.price * item.quantity).toFixed(2) }}</div>
            </div>
          </div>
          <div class="order-total">
            <span>合计：</span>
            <span class="price">¥{{ totalPrice.toFixed(2) }}</span>
          </div>
        </div>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="checkoutDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitOrder">提交订单</el-button>
      </div>
    </el-dialog>

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
  </div>
</template>

<script>
export default {
  name: "Cart",
  data() {
    return {
      tableData: [],
      checkoutDialogVisible: false,
      payDialogVisible: false,
      orderForm: {
        address: '',
        phone: ''
      },
      payMethod: 'alipay',
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      orderId: null
    }
  },
  created() {
    this.loadCart();
    
    // 初始化地址和电话
    if (this.user.address) {
      this.orderForm.address = this.user.address;
    }
    if (this.user.phone) {
      this.orderForm.phone = this.user.phone;
    }
  },
  computed: {
    totalSelectedItems() {
      return this.tableData.reduce((sum, item) => sum + item.quantity, 0);
    },
    totalPrice() {
      return this.tableData.reduce((sum, item) => sum + item.price * item.quantity, 0);
    }
  },
  methods: {
    loadCart() {
      this.request.get("/pet-cart").then(res => {
        if (res.code === '200') {
          this.tableData = res.data;
        }
      });
    },
    updateQuantity(id, quantity) {
      this.request.put(`/pet-cart/${id}?quantity=${quantity}`).then(res => {
        if (res.code === '200') {
          this.$message.success("数量已更新");
        } else {
          this.$message.error(res.msg || "更新失败");
          this.loadCart(); // 重新加载购物车
        }
      });
    },
    removeItem(id) {
      this.$confirm('确定要从购物车中删除该商品吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.request.delete(`/pet-cart/${id}`).then(res => {
          if (res.code === '200') {
            this.$message.success("商品已从购物车中移除");
            this.loadCart();
          } else {
            this.$message.error(res.msg || "删除失败");
          }
        });
      }).catch(() => {});
    },
    clearCart() {
      if (this.tableData.length === 0) {
        this.$message.warning("购物车已经为空");
        return;
      }
      
      this.$confirm('确定要清空购物车吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.request.delete('/pet-cart/clear').then(res => {
          if (res.code === '200') {
            this.$message.success("购物车已清空");
            this.tableData = [];
          } else {
            this.$message.error(res.msg || "清空失败");
          }
        });
      }).catch(() => {});
    },
    goToShop() {
      this.$router.push('/front/petShop');
    },
    checkout() {
      if (this.tableData.length === 0) {
        this.$message.warning("购物车为空，不能结算");
        return;
      }
      this.checkoutDialogVisible = true;
    },
    submitOrder() {
      if (!this.orderForm.address || !this.orderForm.phone) {
        this.$message.warning("请填写完整的收货信息");
        return;
      }
      
      this.request.post('/pet-order/create-from-cart', this.orderForm).then(res => {
        if (res.code === '200') {
          this.$message.success("订单创建成功，请选择支付方式");
          this.checkoutDialogVisible = false;
          this.payDialogVisible = true;
          // 假设响应中包含了新创建的订单ID
          this.orderId = res.data;
        } else {
          this.$message.error(res.msg || "创建订单失败");
        }
      });
    },
    pay() {
      // 在实际项目中，这里应该跳转到支付页面或调用支付接口
      // 这里使用模拟支付
      
      // 如果未获取到orderId（通常应在submitOrder的响应中获取）
      // 这里模拟一个创建成功的情况，跳转到我的订单页面
      this.$message.success(`使用${this.payMethod === 'alipay' ? '支付宝' : '微信'}支付成功`);
      this.payDialogVisible = false;
      this.$router.push('/front/myOrders');
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

    .cart-header {
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

    .empty-cart {
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

    .cart-content {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 15px;
      overflow: hidden;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);

      .cart-table {
        width: 100%;
        border: none;

        .el-table__header-wrapper th {
          background-color: #f9fafb;
          color: #4a5568;
        }

        .price {
          color: #f56c6c;
          font-weight: bold;
        }
      }

      .cart-footer {
        padding: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #f9fafb;
        border-top: 1px solid #edf2f7;

        .total-info {
          display: flex;
          gap: 30px;

          .item {
            display: flex;
            align-items: center;
            gap: 10px;

            .label {
              color: #4a5568;
            }

            .value {
              font-weight: bold;
              color: #2d3748;
            }

            .price {
              color: #f56c6c;
              font-size: 20px;
            }
          }
        }

        .checkout-btn {
          padding: 12px 30px;
          font-size: 16px;
          border-radius: 20px;
        }
      }
    }
  }
}

.checkout-dialog {
  .el-dialog {
    border-radius: 15px;
    overflow: hidden;
  }

  .checkout-form {
    .order-summary {
      margin-top: 20px;
      background: #f9fafb;
      border-radius: 10px;
      padding: 15px;

      h3 {
        margin-top: 0;
        margin-bottom: 15px;
        color: #2d3748;
        font-size: 16px;
      }

      .order-items {
        margin-bottom: 15px;

        .order-item {
          display: flex;
          justify-content: space-between;
          padding: 8px 0;
          border-bottom: 1px dashed #e2e8f0;

          &:last-child {
            border-bottom: none;
          }

          .item-name {
            color: #4a5568;
          }

          .item-price {
            color: #f56c6c;
            font-weight: bold;
          }
        }
      }

      .order-total {
        text-align: right;
        font-weight: bold;
        font-size: 18px;
        color: #2d3748;

        .price {
          color: #f56c6c;
          margin-left: 10px;
        }
      }
    }
  }
}

.pay-dialog {
  .el-dialog {
    border-radius: 15px;
    overflow: hidden;
  }

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
</style> 