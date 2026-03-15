<template>
  <div class="home-container">
      <div style="text-align: right; margin-top: 20px;margin-right: 50px; margin-bottom: -40px;" >
        <el-button style="font-size: 16px;" type="primary" @click="$router.push('/front/donate')" class="confirm-btn">点我捐赠</el-button>
      </div>
    <div class="main-content">

      <el-table
          class="modern-table"
          :data="tableData"
          stripe
          size="mid"
      >

        <!-- 表格列定义保持不变 -->
        <el-table-column label="图片">
          <template slot-scope="scope">
            <el-image
                style="width: 100px; height: 100px"
                :src="scope.row.img"
                :preview-src-list="[scope.row.img]"
            ></el-image>
          </template>
        </el-table-column>
        <el-table-column prop="name" label="名称"></el-table-column>
        <el-table-column prop="addres" label="地址"></el-table-column>
        <el-table-column prop="person" label="联系人"></el-table-column>
        <el-table-column prop="phone" label="联系方式"></el-table-column>
        <el-table-column prop="information" label="相关描述"></el-table-column>
      </el-table>

      <!-- 分页组件 -->
      <div class="pagination-wrapper">
        <el-pagination
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            :current-page="pageNum"
            :page-sizes="[2, 5, 10, 20]"
            :page-size="pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="total"
            class="modern-pagination"
        ></el-pagination>
      </div>


    <el-dialog title="信息" :visible.sync="dialogFormVisible" width="30%" :close-on-click-modal="false">
      <el-form label-width="100px" size="small" style="width: 90%">
        <el-form-item label="名称">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="地址">
          <el-input v-model="form.addres" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="照片">
          <el-upload action="http://localhost:9090/file/upload" ref="img" :on-success="handleImgUploadSuccess">
            <el-button size="small" type="primary">点击上传</el-button>
          </el-upload>
        </el-form-item>
        <el-form-item label="联系人">
          <el-input v-model="form.person" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="联系方式">
          <el-input v-model="form.phone" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="相关描述">
          <el-input v-model="form.information" autocomplete="off"></el-input>
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
  name: "Rescue",
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
      this.request.get("/rescue/page", {
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
      this.request.post("/rescue", this.form).then(res => {
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
      this.request.delete("/rescue/" + id).then(res => {
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
      this.request.post("/rescue/del/batch", ids).then(res => {
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
      window.open("http://localhost:9090/rescue/export")
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
}

::v-deep .modern-table .el-table__header th {
  background: linear-gradient(135deg, #ff9f43, #ff6b6b) !important;
  color: white;
  font-size: 16px;
  font-weight: 500;
}

::v-deep .modern-table .el-table__row {
  transition: all 0.3s ease;
  background: rgba(255,255,255,0.95);
}

::v-deep .modern-table .el-table__row:hover {
  transform: translateX(5px);
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
}

.pagination-wrapper {
  background: rgba(255, 255, 255, 0.9);
  border-radius: 10px;
  padding: 15px;
  margin-top: 20px;
}

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

  .el-pager li {
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
}
</style>
