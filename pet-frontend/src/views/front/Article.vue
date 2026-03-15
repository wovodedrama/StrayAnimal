<template>
  <div class="home-container">
    <div class="main-content">
      <!-- 搜索和操作区域 -->
      <div class="operation-bar">
        <el-input v-model="name" placeholder="请输入名称" class="search-input">
          <i slot="prefix" class="el-icon-search"></i>
        </el-input>
        <el-button type="success" class="confirm-btn" @click="load">搜索</el-button>
        <el-button type="primary" class="confirm-btn" @click="handleAdd">发表帖子</el-button>
      </div>

      <!-- 帖子列表 -->
      <div class="post-list">
        <div
            v-for="item in tableData"
            :key="item.id"
            class="post-item"
        >
          <div class="post-header">
            <h3 class="post-title" @click="view(item.id,  item.content)">
              {{ item.name  }}
            </h3>
            <div class="post-actions">
              <el-button
                  v-if="item.userId  === user.id"
                  type="text"
                  class="danger-btn"
                  @click="del(item.id)"
              >
                删除
              </el-button>
              <el-button
                  v-if="item.userId  === user.id"
                  type="text"
                  @click="handleEdit(item)"
              >
                编辑
              </el-button>
              <el-button
                  type="text"
                  class="comment-btn"
                  @click="handleComment(item.id)"
              >
                评论
              </el-button>
            </div>
          </div>

          <div class="post-meta">
            <div class="meta-item">
              <i class="el-icon-user-solid"></i>
              <span>{{ item.user  }}</span>
            </div>
            <div class="meta-item">
              <i class="el-icon-time"></i>
              <span>{{ item.time  }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="pagination-wrapper">
        <el-pagination
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            :current-page="pageNum"
            :page-sizes="[2, 5, 10, 20]"
            :page-size="pageSize"
            layout="total, prev, pager, next"
            :total="total"
            class="modern-pagination">
        </el-pagination>
      </div>
    </div>

    <el-dialog
        title="内容编辑"
        :visible.sync="dialogFormVisible"
        width="50%"
        top="20vh"
        :close-on-click-modal="false"
        class="modern-dialog">
      <el-form label-width="80px" size="medium" class="dialog-form">
        <el-form-item label="标题" class="form-item">
          <el-input
              v-model="form.name"
              autocomplete="off"
              class="modern-input"
              placeholder="请输入标题">
            <i slot="prefix" class="el-icon-edit-outline"></i>
          </el-input>
        </el-form-item>

        <el-form-item label="内容" class="form-item">
          <mavon-editor
              ref="md"
              v-model="form.content"
              :ishljs="true"
              @imgAdd="imgAdd"
              class="modern-editor"
              placeholder="开始你的创作..."
              :toolbars="markdownOption"/>
        </el-form-item>
      </el-form>

      <div slot="footer" class="dialog-footer">
        <el-button class="modern-btn" @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" class="modern-btn primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 详情查看弹窗 -->
    <el-dialog
        title="内容详情"
        :visible.sync="vis"
        width="60%"
        :close-on-click-modal="false"
        class="modern-dialog preview-dialog">
      <mavon-editor
          class="modern-preview"
          :value="content"
          :subfield="false"
          :defaultOpen="'preview'"
          :toolbarsFlag="false"
          :editable="false"
          :scrollStyle="true"
          :ishljs="true"/>

      <div class="comment-section">
        <h3 class="section-title">
          <i class="el-icon-chat-dot-round"></i>
          评论列表
        </h3>
        <div v-for="item in comments" class="comment-item">
          <div class="user-info">
            <el-image :src="item.avatar"  class="user-avatar"></el-image>
            <div class="meta-info">
              <span class="username">{{item.user  }}</span>
              <time class="post-time"><i class="el-icon-time"></i>{{ item.time  }}</time>
            </div>
            <el-button
                v-if="user.nickname  === item.user"
                type="text"
                class="delete-btn"
                @click="delComment(item.id)">
              删除
            </el-button>
          </div>
          <div class="comment-content">{{ item.content  }}</div>
        </div>
      </div>
    </el-dialog>

    <!-- 评论弹窗 -->
    <el-dialog
        title="发表评论"
        :visible.sync="commentVis"
        width="40%"
        :close-on-click-modal="false"
        class="modern-dialog comment-dialog">
      <el-form class="comment-form">
        <el-form-item>
          <el-input
              type="textarea"
              :rows="4"
              v-model="comment.content"
              class="modern-textarea"
              placeholder="输入你的精彩评论..."
              resize="none">
            <i slot="prefix" class="el-icon-edit" style="top: -5px"></i>
          </el-input>
        </el-form-item>
      </el-form>

      <div slot="footer" class="dialog-footer">
        <el-button class="modern-btn" @click="commentVis = false">取 消</el-button>
        <el-button type="primary" class="modern-btn primary" @click="saveComment">发 表</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Article",
  data() {
    return {
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 10,
      name: "",
      form: {},
      dialogFormVisible: false,
      multipleSelection: [],
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      vis: false,
      content: '',
      comment: {},
      commentVis: false,
      comments: []
    }
  },
  created() {
    if (!this.user.id) {
      this.$message.warning("请登录")
      this.$router.push("/login")
      return
    }
    this.load()
  },
  methods: {
    saveComment() {
      if (!this.user.username) {
        this.$message.warning("请登录后评论")
        return
      }
      if (this.comment.contentr) {
        this.comment.content = this.form.contentr
      }
      if (!this.comment.content) {
        this.$message.warning("请输入评论")
        return
      }
      this.comment.type = 2
      this.request.post("/comment", this.comment).then(res => {
        if (res.code === '200') {
          this.$message.success("评论成功")
          this.commentVis = false
          this.comment = {}  // 清空数据
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
    },
    loadComment(id) {
      this.request.get("/comment/article/2/" + id).then(res => {
        this.comments = res.data
      })
    },
    handleComment(id) {
      this.comment.articleId = id
      this.commentVis = true
    },
    view(id, content) {
      this.content = content
      this.vis = true
      this.loadComment(id)
    },
    // 绑定@imgAdd event
    imgAdd(pos, $file) {
      let $vm = this.$refs.md
      // 第一步.将图片上传到服务器.
      const formData = new FormData();
      formData.append('file', $file);
      axios({
        url: 'http://localhost:9090/file/upload',
        method: 'post',
        data: formData,
        headers: {'Content-Type': 'multipart/form-data'},
      }).then((res) => {
        // 第二步.将返回的url替换到文本原位置![...](./0) -> ![...](url)
        $vm.$img2Url(pos, res.data);
      })
    },
    load() {
      this.request.get("/article/page", {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          name: this.name,
        }
      }).then(res => {
        this.tableData = res.data.records
        this.total = res.data.total
      })
    },
    save() {
      if (!this.form.name) {
        this.$message.error("标题不能为空！")
        return
      }
      if (!this.form.content) {
        this.$message.error("内容不能为空！")
        return
      }
      this.request.post("/article", this.form).then(res => {
        if (res.code === '200') {
          this.$message.success("保存成功")
          this.dialogFormVisible = false
          this.load()
        } else {
          this.$message.error("保存失败")
        }
      })
    },
    handleAdd() {
      this.dialogFormVisible = true
      this.form = {}
      this.$nextTick(() => {
        if(this.$refs.img) {
           this.$refs.img.clearFiles();
         }
         if(this.$refs.file) {
          this.$refs.file.clearFiles();
         }
      })
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row))
      this.dialogFormVisible = true
       this.$nextTick(() => {
         if(this.$refs.img) {
           this.$refs.img.clearFiles();
         }
         if(this.$refs.file) {
          this.$refs.file.clearFiles();
         }
       })
    },
    del(id) {
      this.request.delete("/article/" + id).then(res => {
        if (res.code === '200') {
          this.$message.success("删除成功")
          this.load()
        } else {
          this.$message.error("删除失败")
        }
      })
    },
    handleSelectionChange(val) {
      console.log(val)
      this.multipleSelection = val
    },
    delBatch() {
      if (!this.multipleSelection.length) {
        this.$message.error("请选择需要删除的数据")
        return
      }
      let ids = this.multipleSelection.map(v => v.id)  // [{}, {}, {}] => [1,2,3]
      this.request.post("/article/del/batch", ids).then(res => {
        if (res.code === '200') {
          this.$message.success("批量删除成功")
          this.load()
        } else {
          this.$message.error("批量删除失败")
        }
      })
    },
    reset() {
      this.name = ""
      this.load()
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
    handleFileUploadSuccess(res) {
      this.form.file = res
    },
    handleImgUploadSuccess(res) {
      this.form.img = res
    },
    download(url) {
      window.open(url)
    },
    exp() {
      window.open("http://localhost:9090/article/export")
    },
    handleExcelImportSuccess() {
      this.$message.success("导入成功")
      this.load()
    }
  }
}
</script>


<style>
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
  }

  .main-content {
    position: relative;
    z-index: 2;
    padding: 30px;
    max-width: 1200px;
    margin: 0 auto;

    .operation-bar {
      background: rgba(255,255,255,0.95);
      padding: 20px;
      border-radius: 15px;
      margin-bottom: 25px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);

      .search-input {
        width: 400px;
        margin-right: 15px;
      }
    }
  }

  .modern-table {
    ::v-deep .el-table__header {
      th {
        background: linear-gradient(135deg, #ff9f43, #ff6b6b) !important;
        color: white;
        font-size: 16px;
        font-weight: 500;
      }
    }

    .post-title {
      cursor: pointer;
      color: #5D4037;
      font-family: '黑体';
      font-weight: bold;
      &:hover {
        text-decoration: underline;
      }
    }

    .info-item {
      display: flex;
      align-items: center;
      gap: 10px;
      color: #4a5568;

      i {
        color: #ff9f43;
        font-size: 18px;
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
        border: 1px solid #eee;
      }

      .el-pager {
        li {
          border-radius: 8px;
          margin: 0 5px;
          background: transparent;

          &.active {
            background: linear-gradient(135deg, #ff9f43, #ff6b6b);
            color: white;
          }
        }
      }
    }
  }
}
.post-list {
  margin: 25px 0;
  border-radius: 12px;
  overflow: hidden;

  .post-item {
    background: rgba(255, 255, 255, 0.95);
    padding: 20px;
    margin-bottom: 15px;
    border-radius: 10px;
    box-shadow: 0 3px 12px rgba(0, 0, 0, 0.08);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);

    &:hover {
      transform: translateY(-3px);
      box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
    }

    .post-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 15px;

      .post-title {
        color: #5d4037;
        font-size: 1.4rem;
        font-weight: 600;
        cursor: pointer;
        transition: color 0.3s;
        margin: 0;

        &:hover {
          color: #e67e22;
          text-decoration: underline;
        }
      }

      .post-actions {
        .el-button {
          font-size: 14px;
          padding: 8px 12px;

          &.danger-btn {
            color: #ff4d4f;
            &:hover {
              color: #ff7875;
            }
          }

          &.comment-btn {
            color: #10b981;
            &:hover {
              color: #34d399;
            }
          }
        }
      }
    }

    .post-meta {
      display: flex;
      gap: 25px;
      color: #666;
      font-size: 13px;

      .meta-item {
        display: flex;
        align-items: center;
        gap: 6px;

        i {
          font-size: 16px;
          color: #ff9f43;
        }
      }
    }
  }
}
</style>
