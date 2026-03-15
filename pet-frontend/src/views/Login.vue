<template>
  <div class="login-container">
    <!-- 动态粒子背景 -->
    <div id="particles" class="particles-bg"></div>

    <!-- 主登录卡片 -->
    <div class="login-card">
      <!-- 品牌区 -->
      <div class="brand-section">
        <i class="fas fa-paw brand-icon"></i>
        <h1 class="brand-title">PetAdopt</h1>
        <p class="brand-subtitle">流浪动物领养平台</p>
      </div>

      <!-- 登录表单 -->
      <el-form
          :model="user"
          :rules="rules"
          ref="userForm"
          class="login-form"
          @submit.native.prevent="login"
      >
        <!-- 用户名输入 -->
        <el-form-item prop="username">
          <div class="input-container">
            <i class="input-icon fas fa-user-astronaut"></i>
            <el-input
                class="modern-input"
                placeholder="请输入用户名"
                v-model="user.username"
                clearable
            ></el-input>
          </div>
        </el-form-item>

        <!-- 密码输入 -->
        <el-form-item prop="password">
          <div class="input-container">
            <i class="input-icon fas fa-lock-open"></i>
            <el-input
                class="modern-input"
                placeholder="请输入密码"
                type="password"
                v-model="user.password"
                show-password
            ></el-input>
          </div>
        </el-form-item>

        <!-- 操作按钮 -->
        <div class="action-buttons">
          <el-button
              class="register-btn"
              round
              @click="$router.push('/register')"
          >
            <i class="fas fa-user-plus"></i>
            立即注册
          </el-button>
          <el-button
              class="login-btn"
              type="primary"
              round
              native-type="submit"
          >
            <i class="fas fa-sign-in-alt"></i>
            登录系统
          </el-button>
        </div>

        <!-- 找回密码 -->
        <div class="forgot-password" @click="handlePass">
          <i class="fas fa-question-circle"></i>
          忘记密码？
        </div>
      </el-form>
    </div>

    <!-- 找回密码弹窗 -->
    <el-dialog
        class="modern-dialog"
        title="密码重置"
        :visible.sync="dialogFormVisible"
        width="30%"
        center
    >
      <div class="dialog-header">
        <i class="fas fa-unlock-alt dialog-icon"></i>
        <h3>身份验证</h3>
      </div>
      <el-form label-position="top" size="medium">
        <el-form-item label="用户名" class="dialog-item">
          <el-input
              v-model="pass.username"
              placeholder="请输入注册用户名"
              prefix-icon="el-icon-user"
          ></el-input>
        </el-form-item>
        <el-form-item label="手机号" class="dialog-item">
          <el-input
              v-model="pass.phone"
              placeholder="请输入绑定手机号"
              prefix-icon="el-icon-mobile-phone"
          ></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false" class="dialog-cancel-btn">
          取消
        </el-button>
        <el-button
            type="success"
            @click="passwordBack"
            class="dialog-confirm-btn"
        >
          <i class="fas fa-redo-alt"></i>
          重置密码
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { resetRouter, setRoutes } from "@/router";

export default {
  name: "Login",
  data() {
    return {
      user: {},
      pass: {},
      dialogFormVisible: false,
      rules: {
        username: [
          { required: true, message: "请输入用户名", trigger: "blur" },
          { min: 3, max: 10, message: "长度在 3 到 10 个字符", trigger: "blur" }
        ],
        password: [
          { required: true, message: "请输入密码", trigger: "blur" },
          { min: 1, max: 20, message: "长度在 1 到 20 个字符", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    resetRouter();
  },
  mounted() {
    this.initParticles();
  },
  methods: {
    login() {
      this.$refs["userForm"].validate(valid => {
        if (valid) {
          this.request.post("/user/login",  this.user).then(res  => {
            if (res.code  === "200") {
              localStorage.setItem("user",  JSON.stringify(res.data));
              localStorage.setItem("menus",  JSON.stringify(res.data.menus));
              setRoutes();
              this.$router.push("/front/home");
              this.$message.success(" 登录成功");
            } else {
              this.$message.error(res.msg);
            }
          });
        }
      });
    },
    handlePass() {
      this.dialogFormVisible  = true;
      this.pass  = {};
    },
    passwordBack() {
      this.request.put("/user/reset",  this.pass).then(res  => {
        if (res.code  === "200") {
          this.$message.success(" 重置密码成功，新密码为：123，请尽快修改密码");
          this.dialogFormVisible  = false;
        } else {
          this.$message.error(res.msg);
        }
      });
    },
    initParticles() {
      particlesJS("particles", {
        particles: {
          number: { value: 60, density: { enable: true, value_area: 800 } }, // 密度调小一点更优雅
          color: { value: "#FFD4A1" }, 
          shape: { type: "circle" },
          opacity: { value: 0.3, random: false },
          size: { value: 3, random: true },
          line_linked: {
            enable: true,
            distance: 150,
            color: "#FFD4A1",
            opacity: 0.6, // 连线半透明
            width: 1
          },
          move: {
            enable: true,
            speed: 2, // 速度调慢到2，让它缓缓流动，更有治愈感
            direction: "none",
            out_mode: "out"
          }
        },
        interactivity: {
          detect_on: "canvas",
          events: {
            onhover: { enable: true, mode: "repulse" },
            onclick: { enable: true, mode: "push" },
            resize: true
          }
        },
        retina_detect: true
      });
    }
  }
};
</script>

<style lang="scss">
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css');

.login-container {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: #FFFBF0;
  position: relative;
  overflow: hidden;

  .particles-bg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
  }

  .login-card {
    width: 420px;
    background: rgba(255, 255, 255, 0.95);
    border-radius: 20px;
    padding: 40px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
    backdrop-filter: blur(10px);
    z-index: 2;
    transform: translateY(0);
    transition: transform 0.3s ease;

    &:hover {
      transform: translateY(-5px);
    }

    .brand-section {
      text-align: center;
      margin-bottom: 40px;

      .brand-icon {
        font-size: 3.5rem;
        color: #ff9f43;
        margin-bottom: 15px;
        filter: drop-shadow(0 2px 4px rgba(102, 126, 234, 0.3));
      }

      .brand-title {
        font-size: 2.2rem;
        color: #2d3748;
        margin: 0;
        font-family: 'Pacifico', cursive;
      }

      .brand-subtitle {
        color: #718096;
        margin: 8px 0 0;
        font-size: 0.9rem;
      }
    }

    .login-form {
      .input-container {
        position: relative;
        margin: 20px 0;

        .input-icon {
          position: absolute;
          left: 15px;
          top: 50%;
          transform: translateY(-50%);
          color: #a0aec0;
          z-index: 2;
        }

        .modern-input {
          .el-input__inner {
            height: 48px;
            border-radius: 24px;
            padding-left: 45px;
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;

            &:focus {
              border-color: #ff9f43;
              box-shadow: 0 2px 12px rgba(102, 126, 234, 0.2);
            }
          }
        }
      }

      .action-buttons {
        display: flex;
        justify-content: space-between;
        margin: 30px 0;

        .login-btn,
        .register-btn {
          flex: 1;
          padding: 12px;
          font-size: 1rem;
          transition: all 0.3s ease;

          i {
            margin-right: 8px;
          }
        }

        .login-btn {
          margin-left: 15px;
          background: linear-gradient(135deg, #ff9f43, #ff6b6b);
          border: none;

          &:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
          }
        }

        .register-btn {
          background: #edf2f7;
          color: #2d3748;

          &:hover {
            background: #e2e8f0;
            transform: translateY(-2px);
          }
        }
      }

      .forgot-password {
        text-align: center;
        color: #718096;
        font-size: 0.9rem;
        cursor: pointer;
        transition: color 0.3s ease;

        &:hover {
          color: #ff9f43;
        }

        i {
          margin-right: 6px;
        }
      }
    }
  }

  .modern-dialog {
    border-radius: 15px;
    overflow: hidden;

    .dialog-header {
      text-align: center;
      padding: 20px 0;

      .dialog-icon {
        font-size: 2.5rem;
        color: #ff9f43;
        margin-bottom: 15px;
      }

      h3 {
        margin: 0;
        color: #2d3748;
      }
    }

    .dialog-item {
      .el-form-item__label {
        color: #718096;
        font-weight: 500;
      }

      .el-input__inner {
        border-radius: 8px;
        padding-left: 40px;
      }
    }

    .dialog-footer {
      .dialog-cancel-btn {
        background: #f8f9fa;
        color: #718096;

        &:hover {
          background: #edf2f7;
        }
      }

      .dialog-confirm-btn {
        background: linear-gradient(135deg, #ff9f43, #ff6b6b);
        border: none;

        &:hover {
          opacity: 0.9;
        }
      }
    }
  }
}
</style>
