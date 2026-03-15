<template>
  <div class="home-container">
    <div class="particles-bg"></div>
    <div class="main-content">
      <!-- 搜索和操作区域 -->
      <div class="notice-board">
        <div class="board-header">
          <i class="el-icon-search"></i>
          <el-input v-model="nickname" style="width: 400px" size="mid"></el-input>
          <el-button type="primary" size="mid" style="margin-left: 10px" @click="load()" class="confirm-btn">搜 索</el-button>
          <el-button type="success" size="mid" @click="$router.push('/front/myAdopt')" class="confirm-btn"> 查看我的领养</el-button>
        </div>
      </div>
      <div
        class="ai-float-container"
        :style="{ left: btnX + 'px',top: btnY + 'px'}"
      >
      <div 
          class="ai-float-btn"
          @mousedown="startDrag"
          @click.stop="togglePanel"  
        >
        🤖
      </div>

      <!-- 聊天窗口 -->
      <div class="ai-chat-panel" v-show="visible">
        <div class="ai-chat-header">
          AI 助手
        </div>

        <div class="ai-chat-body">
          <div 
            v-for="(msg, index) in messages"
            :key="index"
            class="msg"
            :class="msg.role"
          >
            {{ msg.content }}
          </div>
          <div v-if="loading" class="msg ai">
            思考中..
          </div>
        </div>

        <div class="ai-chat-footer">
          <input
            v-model="inputText" 
            placeholder="请输入您的问题…" 
            @keyup.enter="sendMessage"
          />
          <button @click="sendMessage">发送</button>
        </div>
      </div>
      </div>


      <!-- 动物卡片列表 -->
      <div class="animal-cards">
        <div v-for="item in tableData" :key="item.id"  class="animal-card">
          <div class="card-image" @click="$router.push('/front/homeDetail?id='  + item.id)">
            <img :src="item.img"  alt="宠物图片">
          </div>
          <div class="card-content">
            <div class="card-header">
              <h2 class="animal-name">{{ item.nickname  }}</h2>
              <div class="meta-info">
                <span>{{ item.sex  }}</span>
                <span>{{ item.age  }}</span>
              </div>
            </div>
            <div class="info-section">
              <div class="info-item">
                <b>是否绝育：</b>{{ item.sterilization  }}
              </div>
              <div class="info-item">
                <b>疫苗接种：</b>{{ item.vaccine  }}
              </div>
              <div class="info-item">
                <b>身体状态：</b>{{ item.status  }}
              </div>
              <div class="info-item">
                <b>其他描述：</b>{{ item.information  }}
              </div>
              <div style="text-align: right; margin-top: 20px">
                <el-button type="primary" @click="handleApply(item.id)" class="confirm-btn"> 申请领养</el-button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 分页 -->
      <div class="pagination-wrapper">
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
    </div>
    <el-dialog title="信息" :visible.sync="dialogFormVisible" width="30%" class="modern-dialog" :close-on-click-modal="false">
      <el-form label-width="100px" size="small" style="width: 90%">
        <el-form-item label="姓名">
          <el-input v-model="form.name" autocomplete="off" class="modern-input"></el-input>
        </el-form-item>
        <el-form-item label="性别">
          <el-radio v-model="form.sex" label="男">男</el-radio>
          <el-radio v-model="form.sex" label="女">女</el-radio>
        </el-form-item>
        <el-form-item label="年龄">
          <el-input v-model="form.age" autocomplete="off" class="modern-input"></el-input>
        </el-form-item>
        <el-form-item label="养宠经验">
          <el-radio v-model="form.experience" label="无经验">无经验</el-radio>
          <el-radio v-model="form.experience" label="有经验">有经验</el-radio>
        </el-form-item>
        <!--        <el-form-item label="宠物">-->
        <!--          <el-input v-model="form.pet" autocomplete="off"></el-input>-->
        <!--        </el-form-item>-->
        <el-form-item label="联系方式">
          <el-input v-model="form.phone" autocomplete="off" class="modern-input"></el-input>
        </el-form-item>
        <el-form-item label="住址">
          <el-input v-model="form.address" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="住房性质">
          <el-radio v-model="form.housing" label="租房">租房</el-radio>
          <el-radio v-model="form.housing" label="自住">自住</el-radio>
        </el-form-item>
        <el-form-item label="领养理由">
          <el-input 
            type="textarea" 
            :rows="4" 
            v-model="form.reason" 
            autocomplete="off"
            placeholder="请输入详细的领养理由，如家庭环境、养宠经验等..."
            resize="none"> </el-input>
        </el-form-item>
        <!--        <el-form-item label="状态">-->
        <!--          <el-input v-model="form.state" autocomplete="off"></el-input>-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="动物id">-->
        <!--          <el-input v-model="form.animalId" autocomplete="off"></el-input>-->
        <!--        </el-form-item>-->
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>


export default {
  name: "FrontHome",
  data() {
    return {
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 10,
      nickname: "",
      dialogFormVisible: false,
      form: {},
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      visible: false,
      loading: false,
      btnX: window.innerWidth - 250,
      btnY: window.innerHeight - 700,
      dragging: false,
      moved: false,
      startX: 0,
      startY: 0,
      offsetX: 0,
      offsetY: 0,

      inputText: '',
      messages: [

      ]
    }
  },
  created() {
    this.load()
  },
  methods: {
    save() {
      this.form.userId = this.user.id
      this.request.post("/application", this.form).then(res => {
        if (res.code === '200') {
          this.$message.success("提交成功")
          this.dialogFormVisible = false
        } else {
          this.$message.error("提交失败")
        }
      })
    },
    handleApply(animalId) {
      this.form = {animalId: animalId}
      this.dialogFormVisible = true
    },
    load() {
      this.request.get("/animal/page/user", {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          name: this.nickname,
        }
      }).then(res => {
        this.tableData = res.data.records
        this.total = res.data.total
      })
    },
    handleSizeChange(pageSize) {
      console.log(pageSize)
      this.pageSize = pageSize
      this.load()
    },
    handleCurrentChange(pageNum) {
      console.log(pageNum)
      this.pageNum = pageNum
      this.load()
    },
    togglePanel() {
      // 如果只是拖动，不打开面板
      if (this.moved) return 
      this.visible = !this.visible
    },
    startDrag(e) {
      // 拖动button
      this.dragging = true
      this.moved = false

      this.startX = e.clientX
      this.startY = e.clientY
      this.offsetX = e.clientX - this.btnX
      this.offsetY = e.clientY - this.btnY

      document.addEventListener('mousemove',this.onDrag)
      document.addEventListener('mouseup',this.stopDrag)
    },
    onDrag(e) {
      if (!this.dragging) return
      const dx = Math.abs(e.clientX - this.startX)
      const dy = Math.abs(e.clientY - this.startY)

      // 判断是否为拖动（如果是就不打开面板）
      if (dx > 3 || dy > 3) {
        this.moved = true
      }

      this.btnX = e.clientX - this.offsetX
      this.btnY = e.clientY - this.offsetY
    },
    stopDrag() {
      this.dragging = false
      document.removeEventListener('mousemove',this.onDrag)
      document.removeEventListener('mouseup',this.stopDrag)
    },
    async sendMessage() {
      if (!this.inputText.trim()) return;

      const question = this.inputText;
      if (question.length > 500) {
        return Result.error("输入内容过长，请简要描述问题")
      }
      this.messages.push({
        role: 'user',
        content: question
      });
      this.inputText = ''

      this.loading = true
      // axios调用后端/ai/chat
      try {
        const res = await this.request.post('/ai/chat', {
          message: question
        });
        // 获取返回结果并显示
        this.messages.push({
          role: 'ai',
          content: res.data
        })
      } catch (e) {
        this.messages.push({
          role:'ai',
          content: '出错了，请稍后重试'
        })
      } finally {
        this.loading  = false
      }
    }
  }
}
</script>

<style>

.home-container {
  min-height: 100vh;
  background: #FFFBF0;
  position: relative;


  .particles-bg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
    background: rgba(0,0,0,0.03);
  }

  .notice-board {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 15px;
    margin: 0px 0;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);

    .board-header {
      padding: 20px;
      display: flex;
      align-items: center;
      gap: 15px;
    }
  }

  .main-content {
    position: relative;
    z-index: 2;
    padding: 30px;
    max-width: 1200px;
    margin: 0 auto;
  }

  .ai-float-container {
    position: fixed;
    z-index: 9999;
  }

  .ai-float-btn {
    position: fixed;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: linear-gradient(135deg, #9bb4f9, #375bdd);
    color: #fff;
    font-size: 26px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    z-index: 9999;
    user-select: none;
    box-shadow: 0 2px 2px rgba(0,0,0,.35);
  }

  .ai-float-btn:active {
    cursor: grabbing;
  }

  .ai-chat-panel {
    width: 340px;
    height: 460px;
    background: #9bb4f9;
    border-radius: 12px;
    display: flex;
    flex-direction: column;
    box-shadow: 0 5px 10px rgb(20, 115, 240);
    transform: translateX(-290px);
  }

  .ai-chat-header {
    height: 53px;
    padding: 0 14px;
    color: white;
    font-family: '黑体';
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-bottom: 1px solid white;
  }

  .ai-chat-header .close {
    cursor: pointer;
    font-size: 18px;
  }

  .ai-chat-body {
    flex: 1;
    padding: 12px;
    overflow-y: auto;
}

  .msg {
    margin-bottom: 10px;
    padding: 8px 10px;
    border-radius: 6px;
    max-width: 85%;
  }

  .msg.ai {
    background: rgba(255, 255, 255, 0.142);
    font-size: 15px;
    color: #ffffff;
  }

  .msg.user {
    background: rgba(102,126,234,.25);
    font-size: 15px;
    color: #fff;
    margin-left: auto;
  }

  .ai-chat-footer {
    padding: 10px;
    display: flex;
    gap: 8px;
    border-top: 1px solid rgba(255,255,255,.1);
  }

  .ai-chat-footer input {
    flex: 1;
    background: rgb(255, 255, 255);
    border: none;
    color: #000000;
    padding: 6px 8px;
    border-radius: 4px;
    outline: none;
  }

  .ai-chat-footer input::placeholder {
    color: #adb2b8;
  }

  .ai-chat-footer button {
    background: #375bdd;
    border: none;
    color: #fff;
    padding: 0 12px;
    border-radius: 4px;
    cursor: pointer;
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

    ::v-deep .modern-pagination {
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
</style>
