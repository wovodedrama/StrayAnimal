<template>
  <div class="person-container">
    <!-- 动态粒子背景 -->
    <div id="particles" class="particles-bg"></div>

    <div class="main-content">
      <div class="profile-card">
        <!-- 头像上传区域 -->
        <div class="avatar-section">
          <el-upload
              class="avatar-uploader"
              action="http://localhost:9090/file/upload"
              :show-file-list="false"
              :on-success="handleAvatarSuccess"
          >
            <div class="avatar-wrapper">
              <img v-if="form.avatarUrl"  :src="form.avatarUrl"  class="user-avatar">
              <i v-else class="el-icon-plus upload-icon"></i>
            </div>
          </el-upload>
        </div>

        <!-- 个人信息表单 -->
        <el-form class="modern-form" label-width="100px" size="medium">
          <div class="form-row">
            <el-form-item label="用户名">
              <el-input
                  v-model="form.username"
                  disabled
                  class="custom-input"
                  suffix-icon="el-icon-user"
              ></el-input>
            </el-form-item>
          </div>

          <div class="form-row">
            <el-form-item label="昵称">
              <el-input
                  v-model="form.nickname"
                  class="custom-input"
                  suffix-icon="el-icon-edit"
              ></el-input>
            </el-form-item>
          </div>

          <div class="form-row">
            <el-form-item label="性别">
              <el-radio-group v-model="form.sex"  class="radio-group">
                <el-radio label="male" class="custom-radio">
                  <i class="fas fa-mars"></i> 男
                </el-radio>
                <el-radio label="female" class="custom-radio">
                  <i class="fas fa-venus"></i> 女
                </el-radio>
              </el-radio-group>
            </el-form-item>
          </div>

          <div class="form-row">
            <el-form-item label="生日">
              <el-date-picker
                  v-model="form.birth"
                  type="date"
                  value-format="yyyy-MM-dd"
                  class="custom-datepicker"
                  prefix-icon="el-icon-date"
              ></el-date-picker>
            </el-form-item>
          </div>

          <div class="form-row">
            <el-form-item label="邮箱">
              <el-input
                  v-model="form.email"
                  class="custom-input"
                  suffix-icon="el-icon-message"
              ></el-input>
            </el-form-item>
          </div>

          <div class="form-row">
            <el-form-item label="手机号">
              <el-input
                  v-model="form.phone"
                  class="custom-input"
                  suffix-icon="el-icon-mobile-phone"
              ></el-input>
            </el-form-item>
          </div>

          <div class="form-row">
            <el-form-item label="地址">
              <el-input
                  v-model="form.address"
                  class="custom-input"
                  suffix-icon="el-icon-location"
              ></el-input>
            </el-form-item>
          </div>

          <div class="action-buttons">
            <el-button
                type="primary"
                class="save-btn"
                @click="save"
            >
              <i class="fas fa-save"></i> 保存信息
            </el-button>
          </div>
        </el-form>
      </div>
    </div>
  </div>
</template>


<script>
export default {
  name: "Person",
  data() {
    return {
      form: {
        username: '',
        nickname: '',
        sex: '',
        birth: '',
        email: '',
        phone: '',
        address: '',
      },
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {}
    }
  },
  created() {
    this.loadUserInfo()
  },
  methods: {
    loadUserInfo() {
      const userId = this.user.id;
      this.request.get(`/user/${userId}`).then(res => {
        if (res.code === '200') {
          // 设置表单数据，包含新增字段
          this.form = {
            id: res.data.id,
            username: res.data.username,
            nickname: res.data.nickname,
            email: res.data.email,
            phone: res.data.phone,
            address: res.data.address,
            sex: res.data.sex,
            birth: res.data.birth
          };
        }
      });
    },
    save() {
      this.request.post("/user/update", this.form).then(res => {
        if (res.code === '200') {
          this.$message.success("保存成功");
          // 更新本地存储的用户信息
          let user = localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {};
          // 更新其他字段
          user.nickname = this.form.nickname;
          user.email = this.form.email;
          user.phone = this.form.phone;
          user.address = this.form.address;
          user.sex = this.form.sex;
          user.birth = this.form.birth;
          localStorage.setItem("user", JSON.stringify(user));
        } else {
          this.$message.error(res.msg);
        }
      });
    },
    handleAvatarSuccess(res) {
      this.form.avatarUrl = res
    }
  }
}
</script>

<style>
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css');

.person-container {
  min-height: 100vh;
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

  .main-content {
    position: relative;
    z-index: 2;
    padding: 30px;
    max-width: 800px;
    margin: 0 auto;

    .profile-card {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 20px;
      padding: 40px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
      transition: transform 0.3s ease;

      &:hover {
        transform: translateY(-5px);
      }

      .avatar-section {
        text-align: center;
        margin-bottom: 30px;

        .avatar-wrapper {
          display: inline-block;
          border: 2px dashed #ff9f43;
          border-radius: 50%;
          padding: 5px;
          transition: all 0.3s ease;

          &:hover {
            border-color: #ff6b6b;
            box-shadow: 0 0 15px rgba(118, 75, 162, 0.3);
          }

          .user-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
          }

          .upload-icon {
            font-size: 32px;
            color: #ff9f43;
            width: 120px;
            height: 120px;
            line-height: 120px;
          }
        }
      }

      .modern-form {
        .form-row {
          margin-bottom: 25px;

          .el-form-item__label {
            color: #4a5568;
            font-weight: 500;
          }
        }

        .custom-input {
          ::v-deep .el-input__inner {
            border-radius: 25px;
            border: 1px solid #e2e8f0;
            padding: 0 20px;
            height: 45px;
            transition: all 0.3s ease;

            &:hover {
              border-color: #ff9f43;
              box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
            }

            &:focus {
              border-color: #ff6b6b;
            }
          }
        }

        .radio-group {
          .custom-radio {
            margin-right: 30px;
            .el-radio__label {
              display: flex;
              align-items: center;
              gap: 8px;
              color: #4a5568;
            }
          }
        }

        .custom-datepicker {
          ::v-deep .el-input__inner {
            border-radius: 25px;
            padding: 0 20px;
            height: 45px;
          }
        }

        .action-buttons {
          margin-top: 35px;
          text-align: center;

          .save-btn {
            background: linear-gradient(135deg, #ff9f43, #ff6b6b);
            border: none;
            border-radius: 25px;
            padding: 12px 35px;
            font-size: 16px;
            letter-spacing: 1px;
            transition: transform 0.3s ease;

            &:hover {
              transform: translateY(-2px);
              box-shadow: 0 5px 15px rgba(118, 75, 162, 0.3);
            }
          }
        }
      }
    }
  }
}
.avatar-uploader {
  text-align: center;
  padding-bottom: 10px;
}
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader .el-upload:hover {
  border-color: #409EFF;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 138px;
  height: 138px;
  line-height: 138px;
  text-align: center;
}
.avatar {
  width: 138px;
  height: 138px;
  display: block;
}
</style>
