<template>
  <div class="user-management-container">
    <div style="margin: 10px 0">
      <el-input style="width: 200px" placeholder="请输入领养人姓名" suffix-icon="el-icon-search" v-model="name"></el-input>
<!--      <el-input style="width: 200px" placeholder="请输入" suffix-icon="el-icon-message" class="ml-5" v-model="email"></el-input>-->
<!--      <el-input style="width: 200px" placeholder="请输入" suffix-icon="el-icon-position" class="ml-5" v-model="address"></el-input>-->
      <el-button class="ml-5" type="primary" @click="load">搜索</el-button>
      <el-button type="warning" @click="reset">重置</el-button>
    </div>

    <div style="margin: 10px 0">
<!--      <el-button type="primary" @click="handleAdd">新增 <i class="el-icon-circle-plus-outline"></i></el-button>-->
      <el-popconfirm
          class="ml-5"
          confirm-button-text='确定'
          cancel-button-text='我再想想'
          icon="el-icon-info"
          icon-color="red"
          title="您确定批量删除这些数据吗？"
          @confirm="delBatch"
      >
        <el-button type="danger" slot="reference">批量删除 <i class="el-icon-remove-outline"></i></el-button>
      </el-popconfirm>
      <!-- <el-upload action="http://localhost:9090/applcation/import" :show-file-list="false" accept="xlsx" :on-success="handleExcelImportSuccess" style="display: inline-block">
        <el-button type="primary" class="ml-5">导入 <i class="el-icon-bottom"></i></el-button>
      </el-upload>
      <el-button type="primary" @click="exp" class="ml-5">导出 <i class="el-icon-top"></i></el-button> -->
    </div>

    <el-table :data="tableData" border stripe :header-cell-class-name="'headerBg'"  @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="40"></el-table-column>
      <el-table-column prop="id" label="ID" width="80" sortable></el-table-column>
      <el-table-column prop="animal.nickname" label="领养动物" width="100" align="center"></el-table-column>
      <el-table-column prop="name" label="姓名" width="100" align="center"></el-table-column>
      <el-table-column prop="sex" label="性别" width="60" align="center"></el-table-column>
      <el-table-column prop="age" label="年龄" width="60" align="center"></el-table-column>
      <el-table-column prop="experience" label="养宠经验" width="70" align="center"></el-table-column>
<!--      <el-table-column prop="pet" label="宠物"></el-table-column>-->
      <el-table-column prop="phone" label="联系方式" width="100" align="center"></el-table-column>
      <el-table-column prop="address" label="大致住址" width="120"></el-table-column>
      <el-table-column prop="housing" label="住房性质" width="70" align="center"></el-table-column>
      <el-table-column prop="reason" label="领养理由"></el-table-column>
      <el-table-column label="AI 顾问" width="120" align="center">
        <template v-slot="scope">
          <el-popover
            placement="left"
            title="AI 深度评估报告"
            width="400"
            trigger="hover"
            v-if="scope.row.analysis"
          >
            <div style="line-height: 1.6; font-size: 14px; color: #606266;">
              {{ scope.row.analysis }}
            </div>
            
            <el-tag 
              slot="reference" 
              :type="getAiTagType(scope.row.analysis)"
              style="cursor: pointer"
            >
              <i class="el-icon-cpu"></i> 查看评估
            </el-tag>
          </el-popover>
          
          <span v-else style="color: #999; font-size: 12px">评估中...</span>
        </template>
      </el-table-column>
      <el-table-column prop="state" label="状态" width="90" align="center">
        <template v-slot="scope">
          <span style="color: green" v-if="scope.row.state === '审核通过'">审核通过</span>
          <span style="color: red" v-if="scope.row.state === '审核不通过'">审核不通过</span>
          <span style="color: #5d4037" v-if="scope.row.state === '待审核'">待审核</span>
        </template>
      </el-table-column>


      <el-table-column label="操作"  width="220" align="center">
        <template slot-scope="scope">
          <el-button type="success" @click="changeState(scope.row, '审核通过')" :disabled="scope.row.state !== '待审核'">通过 <i class="el-icon-check"></i></el-button>
          <el-button type="danger" @click="changeState(scope.row,'审核不通过')"  :disabled="scope.row.state !== '待审核'">不通过 <i class="el-icon-edit"></i></el-button>
          <!-- <el-popconfirm
              class="ml-5"
              confirm-button-text='确定'
              cancel-button-text='我再想想'
              icon="el-icon-info"
              icon-color="red"
              title="您确定删除吗？"
              @confirm="del(scope.row.id)"
          >
            <el-button type="danger" slot="reference">删除 <i class="el-icon-remove-outline"></i></el-button>
          </el-popconfirm> -->
        </template>
      </el-table-column>
    </el-table>
    <div style="padding: 10px 0">
      <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="pageNum"
          :page-sizes="[2, 5, 10, 20]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total">
      </el-pagination>
    </div>

    <el-dialog title="信息" :visible.sync="dialogFormVisible" width="30%" :close-on-click-modal="false">
      <el-form label-width="100px" size="small" style="width: 90%">
        <el-form-item label="姓名">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="性别">
          <el-input v-model="form.sex" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="年龄">
          <el-input v-model="form.age" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="养宠经验">
          <el-input v-model="form.experience" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="宠物">
          <el-input v-model="form.pet" autocomplete="off"></el-input>
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
          <el-input v-model="form.reason" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="状态">
          <el-input v-model="form.state" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="动物id">
          <el-input v-model="form.animalId" autocomplete="off"></el-input>
        </el-form-item>

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
  name: "Applcation",
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
      getAiTagType(opinion) {
      if (!opinion) return 'info';
      
      // 正则匹配 [风险指数:X] 里的数字
      const match = opinion.match(/风险指数:(\d+)/);
      if (match) {
        const score = parseInt(match[1]);
        if (score >= 7) return 'danger';  // 高风险红色
        if (score >= 4) return 'warning'; // 中风险黄色
        return 'success';                 // 低风险绿色
      }
      return 'primary';
    },
    changeState(row, state) {
      this.request.post("/application/state/" + row.id + "/" + state).then(res => {
        this.$message.success("操作成功")
        this.load()
      })
    },
    load() {
      this.request.get("/application/page", {
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
      this.request.post("/application", this.form).then(res => {
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
      this.request.delete("/application/" + id).then(res => {
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
      this.request.post("/application/del/batch", ids).then(res => {
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
      window.open("http://localhost:9090/application/export")
    },
    handleExcelImportSuccess() {
      this.$message.success("导入成功")
      this.load()
    }
  }
}
</script>


<style>
.headerBg {
  background: #eee!important;
}
</style>
