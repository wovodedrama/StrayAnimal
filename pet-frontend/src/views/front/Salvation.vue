<template>
  <div class="home-container">
    <div class="particles-bg"></div>

    <div class="main-content">
      <div class="notice-board">
        <div class="board-header">
          <el-button  class="confirm-btn" type="primary" @click="handleAdd" size="mid">新增报告</el-button>
        </div>
      </div>

      <div class="animal-cards">
        <div class="animal-card" v-for="(item, index) in tableData" :key="index">
          <div class="card-image">
            <el-image
                style="width: 100%; height: 200px"
                :src="item.img"
                :preview-src-list="[item.img]"
                fit="cover">
            </el-image>
          </div>
          <div class="card-content">
            <div class="card-header">
              <h3 class="animal-name">{{ item.information  }}</h3>
              <div class="meta-info">
                <span>{{ item.address  }}</span>
                <span>{{ item.time  }}</span>
              </div>
            </div>
            <div class="info-group">
              <div class="info-item">
                <b>联系人:</b>
                <span>{{ item.person  }}</span>
              </div>
              <div class="info-item">
                <b>联系方式:</b>
                <span>{{ item.phone  }}</span>
              </div>
              <div class="info-item status">
                <el-tag :type="item.state  === '已解决' ? 'success' : 'warning'">
                  {{ item.state  }}
                </el-tag>
              </div>
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
        :visible.sync="dialogFormVisible"
        width="35%"
        :close-on-click-modal="false"
        custom-class="modern-dialog">
      <!-- 对话框标题 -->
      <div slot="title" class="dialog-header">
        <span class="title-text">{{ form.id  ? '编辑' : '新增' }}救助报告</span>
        <div class="title-gradient"></div>
      </div>

      <!-- 表单内容 -->
      <el-form label-width="100px" size="mid" class="dialog-form">
        <el-form-item label="情况描述">
          <el-input
              v-model="form.information"
              placeholder="请输入详细情况描述"
              class="modern-input"
              clearable>
          </el-input>
        </el-form-item>

        <el-form-item label="现场照片">
          <el-upload
              action="http://localhost:9090/file/upload"
              ref="img"
              :on-success="handleImgUploadSuccess"
              class="modern-upload">
            <el-button size="mid" class="upload-btn">
              <i class="el-icon-upload"></i>
              点击上传
            </el-button>
            <div slot="tip" class="upload-tip">支持JPG/PNG格式，大小不超过5MB</div>
          </el-upload>
        </el-form-item>

        <el-form-item label="发现地点">
          <el-input
              v-model="form.address"
              placeholder="请输入详细地址"
              class="modern-input"
              clearable>
            <i slot="prefix" class="el-icon-location-outline"></i>
          </el-input>
        </el-form-item>

        <el-form-item label="发现时间">
          <el-date-picker
              v-model="form.time"
              type="datetime"
              value-format="yyyy-MM-dd HH:mm:ss"
              placeholder="选择日期时间"
              class="modern-datepicker"
              :picker-options="pickerOptions">
          </el-date-picker>
        </el-form-item>

        <el-form-item label="联系人">
          <el-input
              v-model="form.person"
              placeholder="请输入联系人姓名"
              class="modern-input"
              clearable>
            <i slot="prefix" class="el-icon-user"></i>
          </el-input>
        </el-form-item>

        <el-form-item label="联系方式">
          <el-input
              v-model="form.phone"
              placeholder="请输入联系电话"
              class="modern-input"
              clearable>
            <i slot="prefix" class="el-icon-phone-outline"></i>
          </el-input>
        </el-form-item>
      </el-form>

      <!-- 对话框底部 -->
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false" class="cancel-btn">取消</el-button>
        <el-button type="primary" @click="save" class="confirm-btn">提交报告</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "Salvation",
  data() {
    return {
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 5,
      name: "",
      form: {},
      dialogFormVisible: false,
      multipleSelection: [],
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {}
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.request.get("/salvation/page", {
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
      this.request.post("/salvation", this.form).then(res => {
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
      this.request.delete("/salvation/" + id).then(res => {
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
      this.request.post("/salvation/del/batch", ids).then(res => {
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
      window.open("http://localhost:9090/salvation/export")
    },
    handleExcelImportSuccess() {
      this.$message.success("导入成功")
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
        border-radius: 10px;
        overflow: hidden;
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
            font-size: 14px;
          }
        }

        .info-item {
          display: flex;
          align-items: center;
          gap: 10px;
          margin-bottom: 12px;
          color: #4a5568;
          font-size: 15px;

          b {
            color: #2d3748;
            min-width: 80px;
            font-weight: 500;
          }

          &.status {
            margin-top: 20px;
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
</style>
