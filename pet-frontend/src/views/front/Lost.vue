<template>
  <div class="home-container">
    <div class="particles-bg"></div>

    <div class="main-content">
      <div class="notice-board">
        <div class="board-header">
          <i class="el-icon-info" style="color: #ff9f43; font-size: 24px"></i>
          <span>当前共有 {{ total }} 条宠物走失记录</span>
        </div>
      </div>

      <el-table
          class="modern-table"
          :data="tableData"
          stripe
          size="mid"
          @selection-change="handleSelectionChange">

        <el-table-column prop="nickname" label="走失宠物名字">
          <template slot-scope="scope">
            <div class="info-item">
              <i class="el-icon-user-solid"></i>
              <span>{{ scope.row.nickname  }}</span>
            </div>
          </template>
        </el-table-column>

        <!-- 其他列类似添加图标样式 -->
        <el-table-column prop="type" label="种类">
          <template slot-scope="scope">
            <div class="info-item">
              <i class="el-icon-star-off"></i>
              <span>{{ scope.row.type  }}</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column prop="sex" label="性别">
          <template slot-scope="scope">
            <el-tag :type="scope.row.sex  === '公' ? 'primary' : 'danger'">
              {{ scope.row.sex  }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="phone" label="联系方式">
          <template slot-scope="scope">
            <div class="info-item">
              <span>{{ scope.row.phone }}</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column prop="status2" label="状态" width="120">
          <template slot-scope="scope">
            <el-tag
                :type="scope.row.status2  === '已找到' ? 'success' : 'warning'"
                effect="dark">
              {{ scope.row.status2  }}
            </el-tag>
          </template>
        </el-table-column>

      </el-table>

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


      <el-dialog title="信息" :visible.sync="dialogFormVisible" width="30%" :close-on-click-modal="false">
      <el-form label-width="110px" size="small" style="width: 90%">
        <el-form-item label="走失宠物名字">
          <el-input v-model="form.nickname" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="种类">
          <el-input v-model="form.type" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="性别">
          <el-radio v-model="form.sex" label="公">公</el-radio>
          <el-radio v-model="form.sex" label="母">母</el-radio>
        </el-form-item>
        <el-form-item label="联系人">
          <el-input v-model="form.person" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="联系方式">
          <el-input v-model="form.phone" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="已丢失/待领回">
          <el-radio v-model="form.status1" label="已丢失">已丢失</el-radio>
          <el-radio v-model="form.status1" label="待领回">待领回</el-radio>
        </el-form-item>
        <el-form-item label="找回状态">
          <el-radio v-model="form.status2" label="未找到">未找到</el-radio>
          <el-radio v-model="form.status2" label="已找到">已找到</el-radio>
        </el-form-item>

      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>
  </div>
  </div>
</template>

<script>
export default {
  name: "Lost",
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
      this.request.get("/lost/page", {
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
      this.request.post("/lost", this.form).then(res => {
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
      this.request.delete("/lost/" + id).then(res => {
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
      window.open("http://localhost:9090/lost/export")
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

  .main-content {
    position: relative;
    z-index: 2;
    padding: 30px;
    max-width: 1200px;
    margin: 0 auto;
  }

  .modern-table {
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);

    ::v-deep .el-table__header {
      th {
        background: linear-gradient(135deg, #ff9f43, #ff6b6b) !important;
        color: white;
        font-size: 16px;
        font-weight: 500;
      }
    }

    ::v-deep .el-table__row {
      transition: all 0.3s ease;
      background: rgba(255,255,255,0.95);

      &:hover {
        transform: translateX(5px);
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
      }

      td {
        padding: 12px 0;
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
      font-size: 16px;
      color: #4a5568;
    }
  }
}

.modern-dialog {
  border-radius: 15px !important;
  background: rgba(255,255,255,0.98) !important;

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
</style>
