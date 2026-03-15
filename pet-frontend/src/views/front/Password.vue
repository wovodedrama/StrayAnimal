<template>
  <!-- 修改外层容器为 flex 布局 -->
  <div class="home-container">
    <el-card class="centered-card">
    <el-form
        label-width="80px"
        size="small"
        :model="form"
        :rules="rules"
        ref="pass"
        style="width: 400px; margin: 0 auto"
    >
      <el-form-item label="原密码" prop="password">
        <el-input
            v-model="form.password"
            autocomplete="off"
            show-password
            style="width: 80%"
        ></el-input>
      </el-form-item>

      <el-form-item label="新密码" prop="newPassword">
        <el-input
            v-model="form.newPassword"
            autocomplete="off"
            show-password
            style="width: 80%"
        ></el-input>
      </el-form-item>

      <el-form-item label="确认密码" prop="confirmPassword">
        <el-input
            v-model="form.confirmPassword"
            autocomplete="off"
            show-password
            style="width: 80%"
        ></el-input>
      </el-form-item>

      <el-form-item style="margin-top: 30px">
        <el-button
            type="primary"
            class="confirm-btn"
            @click="save"
            style="width: 50%"
        >确认修改</el-button>
      </el-form-item>
    </el-form>
  </el-card>
  </div>
</template>

<script>
export default {
  name: "Password",
  data() {
    return {
      form: {},
      user: localStorage.getItem("user")  ? JSON.parse(localStorage.getItem("user"))  : {},
      rules: {
        password: [
          { required: true, message: '请输入原密码', trigger: 'blur' },
          { min: 6, message: '密码长度不少于6位', trigger: 'blur' }
        ],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, message: '密码长度不少于6位', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请确认新密码', trigger: 'blur' },
          { validator: this.validatePassword,  trigger: 'blur' }
        ],
      }
    }
  },
  created() {
    this.form.username  = this.user.username
  },
  methods: {
    validatePassword(rule, value, callback) {
      if (value !== this.form.newPassword)  {
        callback(new Error('两次输入的密码不一致'));
      } else {
        callback();
      }
    },
    save() {
      this.$refs.pass.validate(valid  => {
        if (valid) {
          this.request.post("/user/password",  this.form).then(res  => {
            if (res.code  === '200') {
              this.$message.success(" 密码修改成功")
              this.$store.commit("logout")
            } else {
              this.$message.error(res.msg)
            }
          })
        }
      })
    },
  }
}
</script>

<style scoped>
.home-container {
  display: flex;
  justify-content: center; /* 水平居中 */
  align-items: center;     /* 垂直居中 */
  min-height: calc(100vh - 60px);
  background: #FFFBF0;
}

.centered-card {
  width: 50%;
  min-height: calc(100vh - 80px);
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1) !important;
}

</style>
