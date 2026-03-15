<template>
  <div class="home-container">
    <div class="particles-bg"></div>
    <div class="main-content">
      <!-- 标题与说明 -->
      <div class="notice-board">
        <div class="board-header">
          <i class="el-icon-star-on"></i>
          <h3>您可能喜欢</h3>
          <div class="header-description">根据您的偏好为您筛选可能喜欢的宠物</div>
        </div>
      </div>

      <!-- 加载状态 -->
      <div v-if="loading" class="loading-container">
        <el-skeleton :rows="3" animated />
      </div>

      <!-- 空状态 -->
      <div v-else-if="recommendedAnimals.length === 0" class="empty-recommend">
        <i class="el-icon-info"></i>
        <span>暂无推荐，完善个人信息可获得更精准推荐</span>
        <div style="margin-top: 20px;">
          <el-button type="primary" @click="evaluationDialogVisible = true">填写评估表单</el-button>
        </div>
      </div>
      
      <!-- 动物列表 -->
      <div v-else class="animal-cards">
        <div v-for="item in recommendedAnimals" :key="item.id" class="animal-card">
          <div class="card-image" @click="handleViewDetail(item)">
            <img :src="item.img" alt="宠物图片">
          </div>
          <div class="card-content">
            <div class="card-header">
              <h2 class="animal-name">{{ item.nickname }}</h2>
              <div class="meta-info">
                <span>{{ item.sex }}</span>
                <span>{{ item.age }}</span>
              </div>
            </div>
            <div class="info-section">
              <div class="info-item">
                <b>类型：</b>{{ item.type }}
              </div>
              <div class="info-item" v-if="item.sterilization">
                <b>是否绝育：</b>{{ item.sterilization }}
              </div>
              <div class="info-item" v-if="item.vaccine">
                <b>疫苗接种：</b>{{ item.vaccine }}
              </div>
              <div class="info-item">
                <b>身体状态：</b>{{ item.status }}
              </div>
              <div class="info-item">
                <b>其他描述：</b>{{ item.information || '暂无描述' }}
              </div>
              <div style="text-align: right; margin-top: 20px">
                <el-button type="primary" @click="handleViewDetail(item)" class="confirm-btn">查看详情</el-button>
                <el-button type="success" @click="handleApply(item.id)" class="confirm-btn">申请领养</el-button>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 分页 -->
      <div v-if="recommendedAnimals.length > 0" class="pagination-wrapper">
        <el-pagination
          class="modern-pagination"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="pageNum"
          :page-sizes="[2, 5, 10, 20]"
          :page-size="pageSize"
          layout="total, prev, pager, next"
          :total="total">
        </el-pagination>
      </div>
      
      <!-- 使用原生对话框，但设置更高的z-index -->
      <el-dialog 
        title="申请领养" 
        :visible.sync="dialogFormVisible" 
        width="30%" 
        :close-on-click-modal="false"
        append-to-body
        custom-class="adopt-dialog"
        top="10vh">
        <el-form label-width="100px" size="small" style="width: 90%">
          <el-form-item label="姓名">
            <el-input v-model="form.name" autocomplete="off"></el-input>
          </el-form-item>
          <el-form-item label="性别">
            <el-radio v-model="form.sex" label="男">男</el-radio>
            <el-radio v-model="form.sex" label="女">女</el-radio>
          </el-form-item>
          <el-form-item label="年龄">
            <el-input v-model="form.age" autocomplete="off"></el-input>
          </el-form-item>
          <el-form-item label="养宠经验">
            <el-radio v-model="form.experience" label="无经验">无经验</el-radio>
            <el-radio v-model="form.experience" label="有经验">有经验</el-radio>
          </el-form-item>
          <el-form-item label="联系方式">
            <el-input v-model="form.phone" autocomplete="off"></el-input>
          </el-form-item>
          <el-form-item label="住址">
            <el-input v-model="form.address" autocomplete="off"></el-input>
          </el-form-item>
          <el-form-item label="住房性质">
            <el-radio v-model="form.housing" label="租房">租房</el-radio>
            <el-radio v-model="form.housing" label="自住">自住</el-radio>
        </el-form-item>
          <el-form-item label="领养理由">
            <el-input v-model="form.reason" type="textarea" :rows="3" autocomplete="off"></el-input>
          </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button @click="dialogFormVisible = false">取 消</el-button>
          <el-button type="primary" @click="saveApplication" :loading="submitLoading">确 定</el-button>
        </div>
      </el-dialog>

            <el-dialog 
      title="领养倾向评估" 
      :visible.sync="evaluationDialogVisible" 
      width="40%" 
      :close-on-click-modal="false"
      append-to-body>
      <el-form :model="profileForm" label-width="140px" size="small">
        <el-form-item label="每天可陪伴时长">
          <el-radio-group v-model="profileForm.dailyTime">
            <el-radio :label="0">少于2小时</el-radio>
            <el-radio :label="1">2-5小时</el-radio>
            <el-radio :label="2">5小时以上</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="您的活动量">
          <el-radio-group v-model="profileForm.activityLevel">
            <el-radio :label="0">低(居家静止)</el-radio>
            <el-radio :label="1">中(偶尔散步)</el-radio>
            <el-radio :label="2">高(经常户外)</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="养宠经验">
          <el-radio-group v-model="profileForm.experienceLevel">
            <el-radio :label="0">新手小白</el-radio>
            <el-radio :label="1">有一定经验</el-radio>
            <el-radio :label="2">资深大佬</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="居住空间">
          <el-radio-group v-model="profileForm.spaceSize">
            <el-radio :label="0">公寓/开间</el-radio>
            <el-radio :label="1">普通套房</el-radio>
            <el-radio :label="2">自带院子</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="是否接受掉毛">
          <el-switch v-model="profileForm.acceptShedding" :active-value="1" :inactive-value="0"></el-switch>
        </el-form-item>
        <el-form-item label="是否接受吵闹">
          <el-switch v-model="profileForm.acceptNoise" :active-value="1" :inactive-value="0"></el-switch>
        </el-form-item>
        <el-form-item label="倾向的性格">
          <el-checkbox-group v-model="profileForm.personalityList">
            <el-checkbox label="温顺"></el-checkbox>
            <el-checkbox label="独立"></el-checkbox>
            <el-checkbox label="粘人"></el-checkbox>
            <el-checkbox label="活泼"></el-checkbox>
          </el-checkbox-group>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="evaluationDialogVisible = false">暂不填写</el-button>
        <el-button type="primary" @click="saveProfile">提交评估</el-button>
      </div>
    </el-dialog>
    </div>
  </div>
</template>

<script>
export default {
  name: "RecommendPage",
  data() {
    return {
      recommendedAnimals: [],
      loading: true,
      dialogFormVisible: false,
      form: {},
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      total: 0,
      pageNum: 1,
      pageSize: 10,
      submitLoading: false,
      evaluationDialogVisible: false,
      profileForm: {
        dailyTime: 1,
        activityLevel: 1,
        experienceLevel: 0,
        spaceSize: 1,
        acceptShedding: 1,
        acceptNoise: 1,
        personalityList: []
      }
    }
  },
  created() {
    // 如果用户未登录，跳转到登录页面
    if (!this.user.username) {
      this.$message.warning("请先登录")
      this.$router.push('/login')
      return
    }
    this.loadRecommendations();
  },
  methods: {
    loadRecommendations() {
      this.loading = true;
      this.request.get('/recommend/animals', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize
        }
      }).then(res => {
        if (res.code === '200') {
          this.recommendedAnimals = res.data.records || res.data || [];
          this.total = res.data.total || this.recommendedAnimals.length;
        } else if (res.code == '401') {
          // 用户未填写表单
          this.recommendedAnimals = [];
          this.evaluationDialogVisible = true; // 弹出表单
        } else {
          this.$message.error("获取推荐失败: " + res.msg);
        }
        this.loading = false;
      }).catch(() => {
        this.loading = false;
      });
    },
    handleViewDetail(animal) {
      // 导航到动物详情页
      this.$router.push('/front/homeDetail?id=' + animal.id);
    },
    handleApply(animalId) {
      // 初始化表单数据
      this.form = {
        animalId: animalId,
        userId: this.user.id,
        name: this.user.nickname || '',
        sex: '',
        age: '',
        experience: '',
        phone: '',
        address: '',
        reason: '',
        state: '待审核'
      }
      // 显示对话框
      this.dialogFormVisible = true
      
      // 使用延迟确保对话框已完全渲染
      setTimeout(() => {
        // 尝试聚焦第一个输入框
        const inputs = document.querySelectorAll('.adopt-dialog .el-input__inner')
        if (inputs && inputs.length > 0) {
          inputs[0].focus()
        }
      }, 300)
    },
    saveApplication() {
      // 基本验证
      if (!this.form.name) {
        this.$message.warning("请输入姓名")
        return
      }
      if (!this.form.phone) {
        this.$message.warning("请输入联系方式")
        return
      }
      
      this.submitLoading = true;
      this.request.post("/application", this.form).then(res => {
        if (res.code === '200') {
          this.$message.success("申请提交成功")
          this.dialogFormVisible = false
          this.form = {} 
        } else {
          this.$message.error(res.msg || "申请提交失败")
        }
      }).catch(err => {
        console.error(err)
        this.$message.error("系统错误，请稍后再试")
      }).finally(() => {
        this.submitLoading = false;
      })
    },
    handleSizeChange(pageSize) {
      this.pageSize = pageSize
      this.loadRecommendations()
    },
    handleCurrentChange(pageNum) {
      this.pageNum = pageNum
      this.loadRecommendations()
    },
    saveProfile() {
      // 性格转换成字符串
      const postData = {
        ...this.profileForm,
        userId:this.user.id,
        prefPersonality: this.profileForm.personalityList.join(',')
      };

      this.request.post("/profile",postData).then(res => {
        if (res.code == '200') {
          this.$message.success("评估完成！正在为您生成推荐结果...");
          this.evaluationDialogVisible = false;
          this.loadRecommendations();
        } else {
          this.$message.error('保存失败')
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.home-container {
  min-height: 100vh;
  background: #FFFBF0;
  position: relative;
  overflow-x: hidden;

  .particles-bg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
    background: rgba(0,0,0,0.03);
    pointer-events: none;
  }

  .notice-board {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 15px;
    margin: 25px 0;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);

    .board-header {
      padding: 20px;
      display: flex;
      align-items: center;
      gap: 15px;
      flex-wrap: wrap;
      
      i {
        font-size: 24px;
        color: #ff9f43;
      }
      
      h3 {
        font-size: 20px;
        color: #2d3748;
        margin: 0;
      }
      
      .header-description {
        font-family: '黑体';
        color: #718096;
        font-size: 14px;
        margin-left: auto;
      }
    }
  }
  
  .loading-container {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 15px;
    margin: 25px 0;
    padding: 30px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  }
  
  .empty-recommend {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 50px 0;
    background: rgba(255, 255, 255, 0.95);
    border-radius: 15px;
    margin: 25px 0;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    
    i {
      font-size: 48px;
      color: #ff9f43;
      margin-bottom: 20px;
    }
    
    span {
      color: #4a5568;
      font-size: 16px;
    }
  }

  .main-content {
    position: relative;
    z-index: 2;
    padding: 30px;
    max-width: 1200px;
    margin: 0 auto;
  }
  
  .animal-cards {
    margin-top: 30px;

    .animal-card {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 15px;
      padding: 20px;
      margin-bottom: 20px;
      display: flex;
      gap: 25px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
      transition: transform 0.3s ease;

      &:hover {
        transform: translateY(-5px);
      }

      .card-image {
        flex: 0 0 250px;
        cursor: pointer;
        img {
          width: 100%;
          height: 200px;
          border-radius: 10px;
          object-fit: cover;
        }
      }

      .card-content {
        flex: 1;

        .card-header {
          border-bottom: 1px solid #eee;
          padding-bottom: 15px;
          margin-bottom: 15px;

          .animal-name {
            font-size: 24px;
            color: #2d3748;
            margin: 0 0 10px;
          }

          .meta-info {
            display: flex;
            gap: 20px;
            color: #718096;
          }
        }

        .info-item {
          display: flex;
          align-items: center;
          gap: 10px;
          margin-bottom: 12px;
          color: #4a5568;

          b {
            color: #2d3748;
            min-width: 80px;
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

    :deep(.modern-pagination) {
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
            color: white;
          }
        }
      }
    }
  }
}

.confirm-btn {
  margin-left: 8px;
}

/* 覆盖Element UI对话框样式 */
:deep(.adopt-dialog) {
  border-radius: 12px;
  overflow: hidden;
  
  .el-dialog__header {
    background: #ff9f43;
    padding: 15px 20px;
    margin-right: 0;
    
    .el-dialog__title {
      color: white;
      font-weight: 600;
      font-size: 18px;
    }
    
    .el-dialog__headerbtn {
      top: 15px;
      
      .el-dialog__close {
        color: white;
      }
    }
  }
  
  .el-dialog__body {
    padding: 20px 20px 10px;
  }
  
  .el-dialog__footer {
    padding: 10px 20px 20px;
  }
}
</style> 