<template>
  <div class="home-container">
    <!-- 动态粒子背景 -->
    <div id="particles" class="particles-bg"></div>

    <!-- 主内容区 -->
    <div class="main-content">
      <div class="search-section">
        <el-input style="width: 200px" placeholder="请输入商品名称" suffix-icon="el-icon-search" v-model="name"></el-input>
        <el-select clearable v-model="category" placeholder="请选择分类" class="ml-5">
          <el-option v-for="item in ['玩具', '食品', '日用品', '医疗保健']" :key="item" :label="item" :value="item"></el-option>
        </el-select>
        <el-button class="ml-5 search-btn" type="primary" @click="load">搜索</el-button>
        <el-button class="reset-btn" type="warning" @click="reset">重置</el-button>
      </div>

      <div class="product-grid">
        <el-row :gutter="20">
          <el-col :span="6" v-for="item in tableData" :key="item.id">
            <div class="product-card">
              <div class="product-image">
                <img :src="item.img" class="image">
              </div>
              <div class="product-content">
                <div class="product-title">{{ item.name }}</div>
                <div class="product-price">¥{{ item.price }}</div>
                <div class="product-stock">库存: {{ item.stock }}</div>
                <div class="product-description">{{ item.description }}</div>
                <div class="product-action">
                  <el-button type="primary" @click="showBuyDialog(item)">立即购买</el-button>
                </div>
              </div>
            </div>
          </el-col>
        </el-row>
      </div>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <el-pagination
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            :current-page="pageNum"
            :page-sizes="[8, 12, 16, 20]"
            :page-size="pageSize"
            layout="total, prev, pager, next"
            :total="total"
            class="modern-pagination">
        </el-pagination>
      </div>
    </div>

    <!-- 购买对话框 -->
    <el-dialog title="购买商品" :visible.sync="dialogFormVisible" width="30%" :close-on-click-modal="false" class="purchase-dialog">
      <el-form label-width="100px" size="small" style="width: 90%">
        <el-form-item label="商品名称">
          <span>{{ form.name }}</span>
        </el-form-item>
        <el-form-item label="商品价格">
          <span class="price-tag">¥{{ form.price }}</span>
        </el-form-item>
        <el-form-item label="购买数量">
          <el-input-number v-model="form.quantity" :min="1" :max="form.stock"></el-input-number>
        </el-form-item>
        <el-form-item label="收货地址">
          <el-input v-model="form.address" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="联系电话">
          <el-input v-model="form.phone" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="buy">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "PetShop",
  data() {
    return {
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 8,
      name: "",
      category: "",
      form: {
        quantity: 1
      },
      dialogFormVisible: false,
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {}
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.request.get("/pet-product/front/page", {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          name: this.name,
          category: this.category
        }
      }).then(res => {
        this.tableData = res.data.records
        this.total = res.data.total
      })
    },
    showBuyDialog(item) {
      // 检查是否登录
      if (!this.user.id) {
        this.$message.warning("请先登录")
        this.$router.push("/login")
        return
      }
      
      this.form = {
        productId: item.id,
        name: item.name,
        price: item.price,
        stock: item.stock,
        quantity: 1,
        address: this.user.address || '',
        phone: this.user.phone || ''
      }
      this.dialogFormVisible = true
    },
    buy() {
      // 创建订单
      this.request.post("/pet-order/create", {
        productId: this.form.productId,
        quantity: this.form.quantity,
        address: this.form.address,
        phone: this.form.phone
      }).then(res => {
        if (res.code === '200') {
          this.$message.success("下单成功")
          this.dialogFormVisible = false
          this.load()
        } else {
          this.$message.error(res.msg || "下单失败")
        }
      })
    },
    reset() {
      this.name = ""
      this.category = ""
      this.load()
    },
    handleSizeChange(pageSize) {
      this.pageSize = pageSize
      this.load()
    },
    handleCurrentChange(pageNum) {
      this.pageNum = pageNum
      this.load()
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

    .search-section {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 15px;
      padding: 20px;
      margin-bottom: 25px;
      display: flex;
      align-items: center;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);

      .el-input {
        margin-right: 10px;
      }

      .search-btn, .reset-btn {
        margin-left: 10px;
        border-radius: 20px;
        padding: 10px 20px;
      }
    }

    .product-grid {
      margin-bottom: 20px;

      .el-row {
        display: flex;
        flex-wrap: wrap;
      }

      .el-col {
        margin-bottom: 25px;
      }

      .product-card {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        height: 100%;
        transition: transform 0.3s ease;

        &:hover {
          transform: translateY(-5px);
        }

        .product-image {
          height: 200px;
          overflow: hidden;

          img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;

            &:hover {
              transform: scale(1.05);
            }
          }
        }

        .product-content {
          padding: 15px;

          .product-title {
            font-size: 18px;
            font-weight: bold;
            color: #2d3748;
            margin-bottom: 10px;
            height: 25px;
            overflow: hidden;
          }

          .product-price {
            color: #f56c6c;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 10px;
          }

          .product-stock {
            color: #718096;
            font-size: 14px;
            margin-bottom: 10px;
          }

          .product-description {
            color: #4a5568;
            height: 40px;
            overflow: hidden;
            margin-bottom: 15px;
            font-size: 14px;
          }

          .product-action {
            text-align: center;

            .el-button {
              padding: 10px 25px;
              border-radius: 20px;
            }
          }
        }
      }
    }

    .pagination-wrapper {
      background: rgba(255, 255, 255, 0.9);
      border-radius: 10px;
      padding: 15px;
      margin-top: 20px;
      text-align: center;

      .modern-pagination {
        .btn-prev, .btn-next {
          border-radius: 20px;
          padding: 0 15px;
        }

        .el-pager {
          li {
            border-radius: 50%;
            margin: 0 5px;

            &.active {
              background: linear-gradient(135deg, #ff9f43, #ff6b6b);
            }
          }
        }
      }
    }
  }
}

.purchase-dialog {
  .el-dialog {
    border-radius: 15px;
    overflow: hidden;
  }

  .el-dialog__header {
    background: #f9f9f9;
    padding: 15px 20px;
  }

  .price-tag {
    color: #f56c6c;
    font-size: 18px;
    font-weight: bold;
  }

  .el-form-item {
    margin-bottom: 20px;
  }

  .dialog-footer {
    display: flex;
    justify-content: flex-end;
    
    .el-button {
      padding: 10px 25px;
      border-radius: 20px;
    }
  }
}
</style> 