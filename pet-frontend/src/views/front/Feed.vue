<template>
  <div class="home-container">
    <div class="main-content">
      <div class="animal-cards">
        <el-table
            :data="tableData"
            stripe
            class="modern-table"
            :header-cell-class-name="() => 'headerBg'">
          <!-- 图片列 -->
          <el-table-column label="环境照片1">
            <template slot-scope="scope">
              <el-image
                  class="card-image"
                  :src="scope.row.img"
                  :preview-src-list="[scope.row.img]"
                  fit="cover">
              </el-image>
            </template>
          </el-table-column>
          <el-table-column label="环境照片2">
            <template slot-scope="scope">
              <el-image
                  class="card-image"
                  :src="scope.row.img2"
                  :preview-src-list="[scope.row.img2]"
                  fit="cover">
              </el-image>
            </template>
          </el-table-column>
          <el-table-column label="环境照片3">
            <template slot-scope="scope">
              <el-image
                  class="card-image"
                  :src="scope.row.img3"
                  :preview-src-list="[scope.row.img3]"
                  fit="cover">
              </el-image>
            </template>
          </el-table-column>
          <!-- 其他图片列同理 -->

          <!-- 信息列 -->
          <el-table-column prop="address" label="地址">
            <template slot-scope="scope">
              <div class="info-item">
                <i class="el-icon-location-outline"></i>
                {{ scope.row.address  }}
              </div>
            </template>
          </el-table-column>
        </el-table>

        <!-- 分页 -->
        <div class="pagination-wrapper">
          <el-pagination
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
              :current-page="pageNum"
              :page-sizes="[2, 5, 10, 20]"
              :page-size="pageSize"
              layout="total, sizes, prev, pager, next, jumper"
              :total="total"
              class="modern-pagination">
          </el-pagination>
        </div>

        <!-- 对话框 -->
        <el-dialog
            :visible.sync="dialogFormVisible"
            width="30%"
            class="modern-dialog"
            :close-on-click-modal="false">

          <div class="dialog-header">
            <h3 class="title-text">信息编辑</h3>
            <div class="title-gradient"></div>
          </div>

          <el-form
              label-width="100px"
              size="small"
              class="dialog-form">

            <el-form-item label="环境照片1">
              <el-upload
                  class="modern-upload"
                  action="http://localhost:9090/file/upload"
                  :on-success="handleImgUploadSuccess">
                <el-button
                    class="upload-btn"
                    size="small"
                    type="primary">
                  点击上传
                </el-button>
                <div slot="tip" class="upload-tip">建议尺寸 800x600</div>
              </el-upload>
            </el-form-item>

            <!-- 其他表单元素样式同理 -->

            <el-form-item label="地址">
              <el-input
                  v-model="form.address"
                  class="modern-input"
                  prefix-icon="el-icon-location"
                  placeholder="请输入详细地址">
              </el-input>
            </el-form-item>
          </el-form>

          <div class="dialog-footer">
            <el-button
                class="cancel-btn"
                @click="dialogFormVisible = false">
              取消
            </el-button>
            <el-button
                class="confirm-btn"
                type="primary"
                @click="save">
              确认提交
            </el-button>
          </div>
        </el-dialog>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Feed",
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
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {}
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.request.get("/feed/page", {
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
      this.request.post("/feed", this.form).then(res => {
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
        if(this.$refs.img3) {
          this.$refs.img3.clearFiles();
        }
        if(this.$refs.img2) {
          this.$refs.img2.clearFiles();
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
         if(this.$refs.img3) {
          this.$refs.img3.clearFiles();
         }
         if(this.$refs.img2) {
           this.$refs.img2.clearFiles();
         }
       })
    },

    del(id) {
      this.request.delete("/feed/" + id).then(res => {
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
      this.request.post("/feed/del/batch", ids).then(res => {
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
    handleImgUploadSuccess2(res) {
      this.form.img2 = res
    },
    handleImgUploadSuccess3(res) {
      this.form.img3 = res
    },
    download(url) {
      window.open(url)
    },
    exp() {
      window.open("http://localhost:9090/feed/export")
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

  .modern-table {
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);

    .el-table__header {
      th {
        background: linear-gradient(135deg, #ff9f43, #ff6b6b) !important;
        color: white;
        font-size: 16px;
      }
    }

    .el-table__row {
      transition: all 0.3s ease;

      &:hover {
        transform: translateX(5px);
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
      }
    }

    .card-image {
      border-radius: 8px;
      transition: transform 0.3s ease;

      &:hover {
        transform: scale(1.05);
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
</style>
