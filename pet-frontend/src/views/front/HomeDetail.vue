<template>
  <div class="home-container">
    <div class="particles-bg" style="pointer-events: none;"></div>

    <div class="main-content">
      <!-- 动物详情主体 -->
      <div class="animal-card">
        <div class="card-image">
          <img :src="animal.img"  :alt="animal.nickname">
        </div>

        <div class="card-content">
          <div class="card-header">
            <h2 class="animal-name">{{ animal.nickname  }}</h2>
            <div class="meta-info">
              <span><i class="el-icon-user"></i> {{ animal.sex  }}</span>
              <span><i class="el-icon-star-off"></i> {{ animal.age  }}</span>
              <span><i class="el-icon-location"></i> {{ animal.address  }}</span>
            </div>
          </div>

          <div class="info-grid">
            <div class="info-item">
              <b>种类:</b>
              <span>{{ animal.type  }}</span>
            </div>
            <div class="info-item">
              <b>身体状态:</b>
              <span>{{ animal.status  }}</span>
            </div>
            <div class="info-item full-width">
              <b>详细描述:</b>
              <p>{{ animal.information  }}</p>
            </div>

            <div class="praise-section">
              <el-tooltip content="点赞支持" placement="top">
                <transition name="praise-bounce">
                  <img
                      src="../../assets/点赞.png"
                      @click="praiseClick"
                      :class="{ 'praise-active': praise }"
                  >
                </transition>
              </el-tooltip>
              <span class="praise-count">{{ animal.praise  }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 评论区域 -->
      <div class="notice-board">
        <div class="board-header">
          <i class="el-icon-chat-dot-round"></i>
          <h3>用户评论 ({{ comments.length  }})</h3>
        </div>

        <div class="comment-editor">
          <el-input
              type="textarea"
              :rows="3"
              v-model="form.content"
              placeholder="留下你的温暖寄语..."
              resize="none"
          ></el-input>
          <el-button
              type="primary"
              class="confirm-btn"
              @click="saveComment"
          >
            <i class="el-icon-s-promotion"></i> 发布评论
          </el-button>
        </div>

        <!-- 评论列表 -->
        <div class="comment-list">
          <div
              v-for="item in comments"
              :key="item.id"
              class="comment-item"
          >
            <div class="user-avatar">
              <el-avatar :src="item.avatar"></el-avatar>
            </div>

            <div class="comment-body">
              <div class="comment-header">
                <span class="username">{{ item.user  }}</span>
                <span class="comment-time">{{ item.time  }}</span>
              </div>
              <p class="comment-content">{{ item.content  }}</p>

              <div class="comment-actions">
                <el-button
                    type="text"
                    @click="handleAddComment(item.id)"
                >
                  <i class="el-icon-chat-line-round"></i> 回复
                </el-button>
                <el-button
                    v-if="user.nickname  === item.user"
                    type="text"
                    class="danger"
                    @click="delComment(item.id)"
                >
                  <i class="el-icon-delete"></i> 删除
                </el-button>
              </div>

              <!-- 子评论 -->
              <div
                  v-for="subitem in item.children"
                  :key="subitem.id"
                  class="child-comment"
              >
                <div class="user-avatar">
                  <el-avatar :src="subitem.avatar"  size="small"></el-avatar>
                </div>
                <div class="comment-body">
                  <div class="comment-header">
                    <span class="username">{{ subitem.user  }}</span>
                    <span class="comment-time">{{ subitem.time  }}</span>
                  </div>
                  <p class="comment-content">{{ subitem.content  }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 回复对话框 -->
    <el-dialog
        :visible.sync="dialogFormVisible"
        width="500px"
        :close-on-click-modal="false"
        custom-class="modern-dialog">
      <!-- 自定义标题区域 -->
      <div slot="title" class="dialog-header">
        <span class="title-text">回复评论</span>
        <div class="title-gradient"></div>
      </div>

      <!-- 表单内容 -->
      <el-form label-width="100px" class="dialog-form">
        <el-form-item label="回复内容">
          <el-input
              type="textarea"
              :rows="4"
              v-model="form.contentr"
              placeholder="请输入回复内容"
              class="modern-input"
              resize="none">
            <i slot="prefix" class="el-icon-edit"></i>
          </el-input>
        </el-form-item>
      </el-form>

      <!-- 对话框底部 -->
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false" class="cancel-btn">取消</el-button>
        <el-button type="primary" @click="saveComment" class="confirm-btn">提交回复</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "HomeDetail",
  data() {
    return {
      id: this.$route.query.id,
      animal: {},
      comments: [],
      form: {},
      dialogFormVisible: false,
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      praise: false
    }
  },
  created() {
    this.load()
    this.loadComment()
  },
  methods: {
    praiseClick() {
      if(this.praise) {
        return
      }
      this.animal.praise += 1
      this.request.post("/animal", this.animal).then(res => {
        this.load()
        this.praise = true
      })
    },
    load() {
      this.request.get("/animal/" + this.id).then(res => {
        this.animal = res.data
      })
    },
    loadComment() {
      this.request.get("/comment/article/1/" + this.id).then(res => {
        this.comments = res.data
      })
    },
    handleAddComment(pid) {
      this.dialogFormVisible = true
      this.form = {pid: pid}
    },
    saveComment() {
      if (!this.user.username) {
        this.$message.warning("请登录后评论")
        return
      }
      if (this.form.contentr) {
        this.form.content = this.form.contentr
      }
      if (!this.form.content) {
        this.$message.warning("请输入评论")
        return
      }
      this.form.type = 1
      this.form.articleId = this.id
      this.request.post("/comment", this.form).then(res => {
        if (res.code === '200') {
          this.$message.success("回复成功")
          this.dialogFormVisible = false
          this.form = {}  // 清空数据
          this.loadComment()
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    delComment(id) {
      this.request.delete("/comment/" + id).then(res => {
        if (res.code === '200') {
          this.$message.success("删除成功")
          this.loadComment()
        } else {
          this.$message.error("删除失败")
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
  padding: 20px;
  position: relative;
  z-index: 1;

  .particles-bg {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 0;
    pointer-events: none; /* 确保点击事件穿透 */
  }

  .main-content {
    max-width: 1200px;
    margin: 0 auto;
    position: relative;
    z-index: 2;
  }

  .animal-card {
    background: white;
    border-radius: 12px;
    padding: 24px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    display: flex;
    gap: 30px;
    margin-bottom: 30px;

    .card-image {
      flex: 0 0 300px;
      border-radius: 8px;
      overflow: hidden;

      img {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }
    }

    .card-content {
      flex: 1;

      .card-header {
        margin-bottom: 20px;

        .animal-name {
          font-size: 28px;
          color: #2d3748;
          margin-bottom: 8px;
        }

        .meta-info {
          display: flex;
          gap: 20px;
          color: #718096;
          font-size: 14px;
        }
      }

      .info-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 16px;

        .info-item {
          padding: 12px;
          background: #f8fafc;
          border-radius: 6px;

          b {
            color: #4a5568;
            margin-right: 8px;
          }

          &.full-width {
            grid-column: 1 / -1;
          }
        }
      }

      .praise-section {
        margin-top: 20px;
        display: flex;
        align-items: center;
        gap: 10px;

        img {
          width: 36px;
          cursor: pointer;
          transition: transform 0.3s ease;

          &:hover {
            transform: scale(1.1);
          }

          &.praise-active {
            filter: hue-rotate(120deg);
          }
        }

        .praise-count {
          font-size: 18px;
          color: #ff9f43;
          font-weight: 500;
        }
      }
    }
  }

  .notice-board {
    background: white;
    border-radius: 12px;
    padding: 24px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);

    .board-header {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 20px;

      h3 {
        font-size: 20px;
        color: #2d3748;
        margin: 0;
      }

      i {
        font-size: 24px;
        color: #ff9f43;
      }
    }

    .comment-editor {
      margin-bottom: 30px;
    }

    .comment-list {
      .comment-item {
        padding: 16px;
        background: #f8fafc;
        border-radius: 8px;
        margin-bottom: 16px;
        display: flex;
        gap: 16px;

        .user-avatar {
          flex: 0 0 40px;
        }

        .comment-body {
          flex: 1;

          .comment-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;

            .username {
              font-weight: 500;
              color: #4a5568;
            }

            .comment-time {
              color: #718096;
              font-size: 12px;
            }
          }

          .comment-content {
            color: #4a5568;
            line-height: 1.5;
            margin: 0;
          }

          .comment-actions {
            margin-top: 8px;

            .danger {
              color: #f56565;
            }
          }

          .child-comment {
            margin-top: 12px;
            padding: 12px;
            background: white;
            border-radius: 6px;
            display: flex;
            gap: 12px;
            align-items: flex-start;
          }
        }
      }
    }
  }
}

// 点赞动画
.praise-bounce-enter-active {
  animation: praise-bounce 0.5s;
}

@keyframes praise-bounce {
  0% { transform: scale(1); }
  50% { transform: scale(1.2); }
  100% { transform: scale(1); }
}

// 对话框样式
::v-deep .reply-dialog {
  border-radius: 12px;

  .el-dialog__header {
    border-bottom: 1px solid #e2e8f0;
  }

  .el-textarea__inner {
    border-radius: 8px;
    padding: 12px;
  }
}
.modern-dialog {
  border-radius: 12px;
  overflow: hidden;
  
  ::v-deep .el-dialog__wrapper {
    z-index: 2001; /* 确保低于导航栏 */
  }
  
  // 标题样式
  .dialog-header {
    position: relative;
    padding: 20px 24px;
    background: linear-gradient(135deg, #ff9f43, #ff6b6b);

    .title-text {
      color: white;
      font-size: 20px;
      font-weight: 600;
      letter-spacing: 1px;
    }

    .title-gradient {
      position: absolute;
      bottom: 0;
      left: 0;
      width: 100%;
      height: 3px;
      background: linear-gradient(90deg, #ff9f43 0%, #ff6b6b 100%);
    }
  }

  // 表单容器
  .dialog-form {
    padding: 20px 30px;

    .el-form-item {
      margin-bottom: 22px;

      &:last-child {
        margin-bottom: 0;
      }
    }

    // 输入框样式
    .modern-input {
      .el-input__inner {
        border-radius: 8px;
        border: 1px solid #e2e8f0;
        padding-left: 35px;
        transition: all 0.3s ease;

        &:hover {
          border-color: #ff9f43;
          box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
        }

        &::placeholder {
          color: #cbd5e0;
        }
      }

      .el-input__prefix {
        left: 10px;
        color: #ff9f43;
      }
    }

    // 上传组件
    .modern-upload {
      .upload-btn {
        background: linear-gradient(135deg, #ff9f43, #ff6b6b);
        border: none;
        color: white;
        border-radius: 6px;
        padding: 10px 20px;

        &:hover {
          opacity: 0.9;
          transform: translateY(-1px);
        }
      }

      .upload-tip {
        color: #718096;
        font-size: 12px;
        margin-top: 8px;
      }
    }

    // 日期选择器
    .modern-datepicker {
      width: 100%;

      .el-input__inner {
        border-radius: 8px;
      }

      .el-date-picker__time-header {
        background: #f8fafc;
      }
    }
  }

  // 底部按钮
  .dialog-footer {
    padding: 15px 24px;
    background: #f8fafc;

    .cancel-btn {
      border-radius: 6px;
      border: 1px solid #e2e8f0;
      color: #ff9f43;
      padding: 10px 25px;

      &:hover {
        border-color: #ff9f43;
        background: rgba(102, 126, 234, 0.1);
      }
    }

    .confirm-btn {
      background: linear-gradient(135deg, #ff9f43, #ff6b6b);
      border: none;
      border-radius: 6px;
      padding: 10px 25px;
      letter-spacing: 1px;

      &:hover {
        opacity: 0.9;
        transform: translateY(-1px);
      }
    }
  }
}

</style>
