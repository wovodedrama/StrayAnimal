<template>
  <div class="login-container">
    <!-- 动态粒子背景 -->
    <div id="particles" class="particles-bg"></div>

    <!-- 主注册卡片 -->
    <div class="login-card">
      <!-- 品牌区 -->
      <div class="brand-section">
        <i class="fas fa-paw brand-icon"></i>
        <h1 class="brand-title">PetAdopt</h1>
        <p class="brand-subtitle">流浪动物领养平台</p>
      </div>

      <!-- 注册表单 -->
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

        <!-- 确认密码 -->
        <el-form-item prop="confirmPassword">
          <div class="input-container">
            <i class="input-icon fas fa-lock"></i>
            <el-input
                class="modern-input"
                placeholder="请确认密码"
                type="password"
                v-model="user.confirmPassword"
                show-password
            ></el-input>
          </div>
        </el-form-item>

        <!-- 操作按钮 -->
        <div class="action-buttons">
          <el-button
              class="login-btn"
              type="primary"
              round
              native-type="submit"
          >
            <i class="fas fa-user-plus"></i> 立即注册
          </el-button>
          <el-button
              class="register-btn"
              round
              @click="$router.push('/login')"
          >
            <i class="fas fa-sign-in-alt"></i> 返回登录
          </el-button>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script>
import particlesJS from "particles.js";

export default {
  name: "Register",
  data() {
    const validatePass = (rule, value, callback) => {
      if (value !== this.user.password)  {
        callback(new Error('两次输入密码不一致!'));
      } else {
        callback();
      }
    };

    return {
      user: {},
      rules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 3, max: 10, message: '长度在 3 到 10 个字符', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请再次输入密码', trigger: 'blur' },
          { validator: validatePass, trigger: 'blur' }
        ]
      }
    };
  },
  mounted() {
    this.initParticles();
  },
  methods: {
    login() {
      this.$refs.userForm.validate(valid  => {
        if (valid) {
          this.request.post("/user/register",  this.user).then(res  => {
            if (res.code  === '200') {
              this.$message.success(" 注册成功");
              this.$router.push('/login');
            } else {
              this.$message.error(res.msg);
            }
          });
        }
      });
    },
    initParticles() {
      particlesJS("particles", {
        particles: {
          number: { value: 80, density: { enable: true, value_area: 800 } },
          color: { value: "#ffffff" },
          shape: { type: "circle" },
          opacity: { value: 0.5, random: false },
          size: { value: 3, random: true },
          line_linked: {
            enable: true,
            distance: 150,
            color: "#ffffff",
            opacity: 0.4,
            width: 1
          },
          move: {
            enable: true,
            speed: 6,
            direction: "none",
            random: false,
            straight: false,
            out_mode: "out",
            bounce: false
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

<style lang="scss" scoped>
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

        .login-btn, .register-btn {
          flex: 1;
          padding: 12px;
          font-size: 1rem;
          transition: all 0.3s ease;

          i {
            margin-right: 8px;
          }
        }

        .login-btn {
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
          margin-left: 15px;

          &:hover {
            background: #e2e8f0;
            transform: translateY(-2px);
          }
        }
      }
    }
  }
}
</style>
