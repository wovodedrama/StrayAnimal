<template>
  <div class="home-container" style="min-height: calc(100vh - 60px); margin: 10px 0">
    <div class="particles-bg"></div>

    <div class="main-content">
      <div style="margin: 10px 0;">
        <div v-for="item in tableData"
             class="modern-table-item"
             style="padding: 20px; border-radius: 10px; background-color: #fff; margin: 10px 0">
          <div style="display: flex">

            <div style="flex: 1">
              <div style="font-size: 20px; font-weight: bold; color: #5d4037; cursor: pointer"
                   @click="view(item.id, item.content)">{{ item.name }}
              </div>

              <div style="margin-top: 60px; font-size: 14px">
                <span><i class="el-icon-reading" style="margin-right: 5px"></i>{{ item.read1 }}</span>
                <span><i class="el-icon-time" style="margin-right: 5px; margin-left: 20px"></i>{{ item.time }}</span>
                <span v-if="item.userId === user.id">
                <el-button type="text" style="float: right; font-size: 16px; color: red; margin-left: 10px"
                           @click="del(item.id)">删除</el-button>
                <el-button type="text" style="float: right; font-size: 16px" @click="handleEdit(item)">编辑</el-button>
             </span>
              </div>
            </div>

            <div style="width: 200px; text-align: center">
              <el-image :src="item.img" style="width: 100px; height: 100px" :preview-src-list="[item.img]"></el-image>
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
            :total="total">
        </el-pagination>
      </div>
    </div>
    <el-dialog title="信息"
               :visible.sync="dialogFormVisible"
               width="60%"
               :close-on-click-modal="false"
               class="modern-dialog"
               top="5vh">
      <el-form label-width="80px"
               size="medium"
               class="dialog-form">
        <el-form-item label="标题" class="form-item__gradient">
          <el-input
              v-model="form.name"
              placeholder="请输入文章标题"
              class="modern-input"
              prefix-icon="el-icon-edit">
            <template slot="prepend">
              <i class="el-icon-edit-outline"></i>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item label="封面" class="form-item__gradient">
          <el-upload
              class="modern-uploader"
              :action="'http://localhost:9090/file/upload'"
              :show-file-list="false"
              :on-success="handleImgUploadSuccess">
            <transition v-if="form.img" name="el-zoom-in-center">
              <img   :src="form.img"  class="uploader-image">
            </transition>
            <div v-else class="uploader-slot">
              <i class="el-icon-plus uploader-icon"></i>
              <div class="uploader-text">点击上传封面</div>
            </div>
          </el-upload>
        </el-form-item>

        <el-form-item label="内容" class="form-item__gradient editor-item">
          <mavon-editor
              ref="md"
              v-model="form.content"
              :ishljs="true"
              @imgAdd="imgAdd"
              class="modern-editor"
              :toolbars="markdownOption"
              :codeStyle="codeStyle"/>
        </el-form-item>
      </el-form>

      <div slot="footer" class="dialog-footer__modern">
        <el-button
            @click="dialogFormVisible = false"
            class="btn-cancel">
          取 消
        </el-button>
        <el-button
            type="primary"
            @click="save"
            class="btn-confirm">
          确 定
        </el-button>
      </div>
    </el-dialog>

    <el-dialog title="预览"
               :visible.sync="vis"
               width="60%"
               :close-on-click-modal="false"
               class="modern-dialog  preview-dialog"
               top="5vh">
      <mavon-editor
          class="modern-preview"
          :value="content"
          :subfield="false"
          :defaultOpen="'preview'"
          :toolbarsFlag="false"
          :editable="false"
          :scrollStyle="true"
          :ishljs="true"
         />
    </el-dialog>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "ArticleKp",
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
      content: ''
    }
  },
  created() {
    this.load()
  },
  methods: {
    view(id, content) {
      this.request.get("/articleKp/" + id)
      this.content = content
      this.vis = true
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
      this.request.get("/articleKp/page", {
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
      this.request.post("/articleKp", this.form).then(res => {
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
        if (this.$refs.img) {
          this.$refs.img.clearFiles();
        }
        if (this.$refs.file) {
          this.$refs.file.clearFiles();
        }
      })
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row))
      this.dialogFormVisible = true
      this.$nextTick(() => {
        if (this.$refs.img) {
          this.$refs.img.clearFiles();
        }
        if (this.$refs.file) {
          this.$refs.file.clearFiles();
        }
      })
    },
    del(id) {
      this.request.delete("/articleKp/" + id).then(res => {
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
      this.request.post("/articleKp/del/batch", ids).then(res => {
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
      window.open("http://localhost:9090/articleKp/export")
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
    background: rgba(0, 0, 0, 0.03);
  }

  .main-content {
    position: relative;
    z-index: 2;
    padding: 30px;
    max-width: 1200px;
    margin: 0 auto;
  }

  .modern-table-item {
    background: rgba(255, 255, 255, 0.95);
    transition: all 0.3s ease;

    &:hover {
      transform: translateX(5px);
      box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
    }
  }

  .pagination-wrapper {
    background: rgba(255, 255, 255, 0.9);
    border-radius: 10px;
    padding: 15px;
    margin-top: 20px;

    ::v-deep .el-pagination {
      .btn-prev, .btn-next {
        border-radius: 20px;
        padding: 0 15px;
        border: 1px solid #eee;
        transition: all 0.3s ease;

        &:hover {
          background: #ff9f43;
          color: white;
        }
      }

      .el-pager {
        li {
          border-radius: 8px;
          margin: 0 5px;
          background: transparent;
          transition: all 0.3s ease;

          &.active {
            background: linear-gradient(135deg, #ff9f43, #ff6b6b);
            color: white;
          }

          &:hover {
            background: rgba(102, 126, 234, 0.1);
          }
        }
      }
    }
  }

  .modern-dialog {
    border-radius: 15px !important;
    background: rgba(255, 255, 255, 0.98) !important;

    .el-dialog__header {
      border-bottom: 1px solid #eee;
      padding: 15px 20px;

      .el-dialog__title {
        color: #ff9f43;
        font-weight: 500;
      }
    }

    .el-dialog__body {
      padding: 20px 30px;
    }
  }
  .avatar-uploader {
    padding-left: 20px;
    padding-bottom: 10px;
  }

  .headerBg {
    background: #eee !important;
  }

  .avatar-uploader {
    padding-left: 20px;
    padding-bottom: 10px;
  }

  .avatar-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }

  .avatar-uploader .el-upload:hover {
    border-color: #409EFF;
  }

  .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 138px;
    height: 138px;
    line-height: 138px;
    text-align: center;
  }

  .avatar {
    width: 138px;
    height: 138px;
    display: block;
  }

}
</style>
