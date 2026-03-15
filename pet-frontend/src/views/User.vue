<template>
  <div class="user-management-container">
    <div style="margin: 10px 0">
      <el-input style="width: 200px" placeholder="请输入名称" suffix-icon="el-icon-search" v-model="name"></el-input>
      <el-button class="ml-5" type="primary"  @click="load">搜索</el-button>
      <el-button type="warning" @click="reset">重置</el-button>
    </div>
    <div class="operation-bar">
      <el-button type="primary" @click="handleAdd" class="action-button">
        新增 <i class="el-icon-circle-plus-outline"></i>
      </el-button>
      <el-button type="danger" @click="delBatch" class="action-button">
        批量删除 <i class="el-icon-delete"></i>
      </el-button>
    </div>

    <el-table
        :data="tableData"
        class="modern-table"
        stripe
        @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="45"></el-table-column>
      <el-table-column prop="username" label="用户名" min-width="120"></el-table-column>
      <el-table-column prop="role" label="角色" min-width="100"></el-table-column>
      <el-table-column prop="nickname" label="姓名" min-width="100"></el-table-column>
      <el-table-column prop="sex" label="性别" width="80"></el-table-column>
      <el-table-column prop="birth" label="生日" min-width="120"></el-table-column>
      <el-table-column prop="email" label="邮箱" min-width="150"></el-table-column>
      <el-table-column prop="phone" label="电话" min-width="120"></el-table-column>
      <el-table-column prop="address" label="地址" min-width="200"></el-table-column>
      <el-table-column label="操作" width="150" fixed="right">
        <template slot-scope="scope">
          <el-button
              type="text"
              @click="handleEdit(scope.row)"
              class="action-icon">
            <i class="el-icon-edit" style="color: #4dabf7;"></i>
          </el-button>
          <el-popconfirm
              title="确定要删除这条记录吗？"
              @confirm="del(scope.row.id)">
            <el-button
                slot="reference"
                type="text"
                class="action-icon">
              <i class="el-icon-delete" style="color: #ff6b6b;"></i>
            </el-button>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>

    <div class="pagination-wrapper">
      <el-pagination
          :current-page="pageNum"
          :page-sizes="[2, 5, 10, 20]"
          :page-size="pageSize"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange">
      </el-pagination>
    </div>

    <el-dialog
        :title="form && form.id ? '编辑用户' : '新增用户'"
        :visible.sync="dialogFormVisible"
        class="modern-dialog"
        width="40%">
      <el-form
          :model="form"
          label-width="100px"
          size="medium"
          class="dialog-form">
        <el-form-item label="用户名" class="modern-input">
          <el-input v-model="form.username" clearable></el-input>
        </el-form-item>
        <el-form-item label="角色" class="modern-input">
          <el-select
              v-model="form.role"
              placeholder="请选择角色"
              class="full-width">
            <el-option
                v-for="item in roles"
                :key="item.flag"
                :label="item.name"
                :value="item.flag">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="姓名" class="modern-input">
          <el-input v-model="form.nickname" clearable></el-input>
        </el-form-item>
        <el-form-item label="性别" class="modern-input">
          <el-radio-group v-model="form.sex">
            <el-radio label="男">男</el-radio>
            <el-radio label="女">女</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="生日" class="modern-input">
          <el-date-picker
              v-model="form.birth"
              type="date"
              value-format="yyyy-MM-dd"
              placeholder="选择日期"
              class="full-width">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="邮箱" class="modern-input">
          <el-input v-model="form.email" clearable></el-input>
        </el-form-item>
        <el-form-item label="电话" class="modern-input">
          <el-input v-model="form.phone" clearable></el-input>
        </el-form-item>
        <el-form-item label="地址" class="modern-input">
          <el-input v-model="form.address" clearable></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false" class="cancel-btn">取消</el-button>
        <el-button type="primary" @click="save" class="confirm-btn">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "User",
  data() {
    return {
      tableData: [],
      name: '', // 对应搜索框 v-model="name"
      total: 0,
      pageNum: 1,
      pageSize: 10,
      username: "",
      email: "",
      address: "",
      form: {}, // 必须初始化 form 对象
      dialogFormVisible: false,
      multipleSelection: [],
      roles: []
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.request.get("/user/page", {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          username: this.name, // 这里改成用 name，保持前后端搜索一致
          email: this.email,
          address: this.address,
        }
      }).then(res => {
        this.tableData = res.data.records || []
        this.total = res.data.total || 0
      })

      this.request.get("/role").then(res => {
        this.roles = res.data || []
      })
    },
    save() {
      this.request.post("/user", this.form).then(res => {
        if (res.code === '200') {
          this.$message.success("保存成功")
          this.dialogFormVisible = false
          this.load()
        } else {
          this.$message.error(res.msg || "保存失败")
        }
      })
    },
    handleAdd() {
      this.dialogFormVisible = true
      this.resetForm()
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row))
      this.dialogFormVisible = true
    },
    del(id) {
      this.request.delete("/user/" + id).then(res => {
        if (res.code === '200') {
          this.$message.success("删除成功")
          this.load()
        } else {
          this.$message.error("删除失败")
        }
      })
    },
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    delBatch() {
      if (!this.multipleSelection.length) {
        this.$message.error("请选择需要删除的数据")
        return
      }
      let ids = this.multipleSelection.map(v => v.id)
      this.request.post("/user/del/batch", ids).then(res => {
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
      this.email = ""
      this.address = ""
      this.load()
    },
    handleSizeChange(pageSize) {
      this.pageSize = pageSize
      this.load()
    },
    handleCurrentChange(pageNum) {
      this.pageNum = pageNum
      this.load()
    },
    resetForm() {
      this.form = {
        id: '',
        username: '',
        password: '',
        nickname: '',
        email: '',
        phone: '',
        address: '',
        avatarUrl: '',
        role: '',
        sex: '',
        birth: ''
      }
    }
  }
}
</script>

<style>
.operation-bar {
  margin-bottom: 20px;
  display: flex;
  gap: 12px;
}

.action-button {
  padding: 10px 20px;
  border-radius: 6px;
  font-weight: 500;
}

.action-icon {
  padding: 8px;
  font-size: 16px;
}

.dialog-form {
  padding: 0 20px;
}

.full-width {
  width: 100%;
}

.cancel-btn {
  padding: 10px 25px;
  border-radius: 6px;
}

.confirm-btn {
  padding: 10px 25px;
  border-radius: 6px;
  background-color: #4dabf7;
  border-color: #4dabf7;
}
</style>
