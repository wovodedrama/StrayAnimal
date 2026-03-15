<template>
  <div class="user-management-container">
    <div style="margin: 10px 0">
      <el-input style="width: 200px" placeholder="请输入名称" suffix-icon="el-icon-search" v-model="name"></el-input>
      <el-select clearable v-model="adopt" placeholder="请选择领养状态" class="ml-5">
        <el-option v-for="item in ['不可领养', '可领养']" :key="item" :label="item" :value="item"></el-option>
      </el-select>
      <el-button class="ml-5" type="primary" @click="load">搜索</el-button>
      <el-button type="warning" @click="reset">重置</el-button>
    </div>

    <div style="margin: 10px 0">
      <el-button type="primary" @click="handleAdd">新增 <i class="el-icon-circle-plus-outline"></i></el-button>
      <el-popconfirm class="ml-5" title="确定批量删除吗？" @confirm="delBatch">
        <el-button type="danger" slot="reference">批量删除 <i class="el-icon-remove-outline"></i></el-button>
      </el-popconfirm>
    </div>

    <el-table :data="tableData" border stripe :header-cell-class-name="'headerBg'" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column prop="id" label="ID" width="60" sortable></el-table-column>
      <el-table-column prop="nickname" label="动物名字"></el-table-column>
      <el-table-column prop="type" label="种类" width="80"></el-table-column>
      <el-table-column label="图片" width="120">
        <template slot-scope="scope">
          <el-image style="width: 80px; height: 80px" :src="scope.row.img" :preview-src-list="[scope.row.img]"></el-image>
        </template>
      </el-table-column>
      
      <el-table-column label="性格特征" width="200">
        <template slot-scope="scope">
          <el-tag size="mini" v-for="tag in (scope.row.information ? scope.row.information.split(',') : [])" :key="tag" style="margin-right: 5px">
            {{ tag }}
          </el-tag>
        </template>
      </el-table-column>

      <el-table-column prop="vaccine" label="疫苗"></el-table-column>
      <el-table-column prop="adopt" label="状态"></el-table-column>

      <el-table-column label="操作" width="180" align="center">
        <template slot-scope="scope">
          <el-button type="success" size="mini" @click="handleEdit(scope.row)">编辑 <i class="el-icon-edit"></i></el-button>
          <el-popconfirm class="ml-5" title="确定删除吗？" @confirm="del(scope.row.id)">
            <el-button type="danger" size="mini" slot="reference">删除 <i class="el-icon-remove-outline"></i></el-button>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>

    <div style="padding: 10px 0">
      <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange" :current-page="pageNum" :page-sizes="[5, 10, 20]" :page-size="pageSize" layout="total, sizes, prev, pager, next, jumper" :total="total"></el-pagination>
    </div>

    <el-dialog title="动物信息" :visible.sync="dialogFormVisible" width="40%" :close-on-click-modal="false">
      <el-form label-width="100px" size="small" style="width: 90%">
        <el-form-item label="动物名字">
          <el-input v-model="form.nickname"></el-input>
        </el-form-item>
        <el-form-item label="性格特征">
          <el-checkbox-group v-model="form.characterList">
            <el-checkbox label="温顺"></el-checkbox>
            <el-checkbox label="活泼"></el-checkbox>
            <el-checkbox label="独立"></el-checkbox>
            <el-checkbox label="粘人"></el-checkbox>
            <el-checkbox label="精力旺盛"></el-checkbox>
            <el-checkbox label="掉毛"></el-checkbox>
            <el-checkbox label="吵闹"></el-checkbox>
            <el-checkbox label="需要陪伴"></el-checkbox>
            <el-checkbox label="适合新手"></el-checkbox>
            <el-checkbox label="需要经验"></el-checkbox>
          </el-checkbox-group>
        </el-form-item>
        <el-form-item label="动物照片">
          <el-upload action="http://localhost:9090/file/upload" ref="img" :on-success="handleImgUploadSuccess">
            <el-button size="small" type="primary">点击上传</el-button>
          </el-upload>
        </el-form-item>
        <el-form-item label="是否绝育">
          <el-radio v-model="form.sterilization" label="是">是</el-radio>
          <el-radio v-model="form.sterilization" label="否">否</el-radio>
        </el-form-item>
        <el-form-item label="可领养状态">
          <el-radio v-model="form.adopt" label="不可领养">不可领养</el-radio>
          <el-radio v-model="form.adopt" label="可领养">可领养</el-radio>
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
  name: "Animal",
  data() {
    return {
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 10,
      name: "",
      form: {characterList: []},
      dialogFormVisible: false,
      multipleSelection: [],
      information: '',
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      adopt: ''
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.request.get("/animal/page", {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          name: this.name,
          adopt: this.adopt,
        }
      }).then(res => {
        this.tableData = res.data.records
        this.total = res.data.total
      })
    },
    save() {
      if (this.form.characterList && this.form.characterList.length > 0) {
        // 将性格拼接成字符串
        this.form.information = this.form.characterList.join(',')
      } else {
        this.form.information = ''
      }

      this.request.post("/animal", this.form).then(res => {
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
      this.form = { characterList: [] }
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
      // 使用 $set 确保 characterList 是响应式的
      if (this.form.information) {
        this.$set(this.form, 'characterList', this.form.information.split(','))
      } else {
        this.$set(this.form, 'characterList', [])
      }
      this.dialogFormVisible = true
    },
    del(id) {
      this.request.delete("/animal/" + id).then(res => {
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
      this.request.post("/animal/del/batch", ids).then(res => {
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
      this.adopt = ""
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
      window.open("http://localhost:9090/animal/export")
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
