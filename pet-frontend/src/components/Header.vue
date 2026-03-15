<template>
  <div class="header-container">
    <!-- 共享粒子背景 -->
    <div id="particles" class="particles-bg"></div>

    <div class="header-content">
      <div class="left-section">
        <i :class="collapseBtnClass"
           class="collapse-btn"
           @click="collapse"></i>

        <el-breadcrumb separator="/" class="modern-breadcrumb">
          <el-breadcrumb-item :to="'/'">
            <i class="el-icon-s-home"></i> 首页
          </el-breadcrumb-item>
          <el-breadcrumb-item>/{{ currentPathName }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>

      <el-dropdown class="user-menu">
        <div class="user-panel">
          <img :src="user.avatarUrl"
               class="user-avatar"
               alt="用户头像">
          <div class="user-info">
            <span class="user-name">{{ user.nickname  }}</span>
            <span class="user-role">{{ user.role  }}</span>
          </div>
          <i class="el-icon-arrow-down arrow-icon"></i>
        </div>

        <el-dropdown-menu
            slot="dropdown"
            class="glassmorphism-menu"
            popper-class="header-dropdown">
          <el-dropdown-item
              v-for="(item, index) in menuItems"
              :key="index"
              class="menu-item">
            <router-link
                :to="item.path"
                class="menu-link">
              <i :class="item.icon"></i>
              <span>{{ item.label  }}</span>
            </router-link>
          </el-dropdown-item>
          <el-dropdown-item
              divided
              class="logout-item">
            <span
                @click="logout"
                class="logout-btn">
              <i class="el-icon-switch-button"></i>
              <span>退出系统</span>
            </span>
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>
  </div>
</template>

<script>
export default {
  name: "Header",
  props: {
    collapseBtnClass: String,
    user: Object
  },
  computed: {
    currentPathName() {
      return this.$store.state.currentPathName;
    }
  },
  data() {
    return {
      menuItems: [
        { path: "/front/home", icon: "el-icon-s-promotion", label: "前台主页" },
        { path: "/password", icon: "el-icon-key", label: "修改密码" },
        { path: "/person", icon: "el-icon-user", label: "个人信息" }
      ]
    };
  },
  methods: {
    collapse() {
      this.$emit("asideCollapse");
    },
    logout() {
      this.$store.commit("logout");
      this.$message.success(" 退出成功");
      setTimeout(() => {
        window.location.reload();  // 确保样式完全重置
      }, 500);
    }
  }
};
</script>

<style lang="scss" scoped>
.header-container {
  position: relative;
  background: linear-gradient(135deg, #ff9f43 0%, #ff6b6b 100%);
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);

  .particles-bg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
  }

  .header-content {
    position: relative;
    z-index: 2;
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 60px;
    padding: 0 25px;
    backdrop-filter: blur(5px);

    .left-section {
      display: flex;
      align-items: center;
      gap: 15px;

      .collapse-btn {
        color: rgba(255, 255, 255, 0.9);
        font-size: 20px;
        cursor: pointer;
        transition: all 0.3s;

        &:hover {
          color: #fff;
          transform: scale(1.1);
        }
      }
    }
  }

  .modern-breadcrumb {
    ::v-deep .el-breadcrumb__item {
      .el-breadcrumb__inner {
        color: rgba(255, 255, 255, 0.8);
        transition: all 0.3s;
        display: flex;
        align-items: center;
        gap: 5px;

        &:hover {
          color: #fff;
          transform: translateY(-1px);
        }

        &.is-link {
          font-weight: 400;
        }
      }

      &:last-child .el-breadcrumb__inner {
        color: rgba(255, 255, 255, 0.9);
        font-weight: 500;
      }
    }
  }

  .user-panel {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 6px 15px;
    border-radius: 30px;
    background: rgba(255, 255, 255, 0.1);
    transition: all 0.3s;
    cursor: pointer;

    &:hover {
      background: rgba(255, 255, 255, 0.2);
      transform: translateY(-1px);

      .arrow-icon {
        transform: translateY(1px);
      }
    }
  }

  .user-avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    border: 2px solid rgba(255, 255, 255, 0.3);
    object-fit: cover;
  }

  .user-info {
    display: flex;
    flex-direction: column;
    line-height: 1.3;

    .user-name {
      color: #fff;
      font-size: 14px;
      font-weight: 500;
    }

    .user-role {
      color: rgba(255, 255, 255, 0.7);
      font-size: 12px;
    }
  }

  .arrow-icon {
    color: rgba(255, 255, 255, 0.8);
    transition: transform 0.3s;
    margin-left: 5px;
  }

  .glassmorphism-menu {
    background: rgba(255, 255, 255, 0.1) !important;
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border: 1px solid rgba(255, 255, 255, 0.2) !important;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1) !important;
    border-radius: 12px !important;
    overflow: hidden;

    .menu-item {
      margin: 4px 0;

      &:hover {
        background: rgba(255, 255, 255, 0.05) !important;
      }
    }

    .menu-link {
      color: rgba(255, 255, 255, 0.9) !important;
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 8px 20px;
      font-size: 14px;
      transition: all 0.3s;

      i {
        font-size: 16px;
        width: 20px;
      }

      &:hover {
        color: #fff !important;
        transform: translateX(5px);
      }
    }

    .logout-item {
      margin-top: 8px;
      border-top: 1px solid rgba(255, 255, 255, 0.1) !important;

      &:hover {
        background: rgba(255, 107, 107, 0.1) !important;
      }
    }

    .logout-btn {
      color: #ff6b6b;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 8px 20px;
      font-size: 14px;
      transition: all 0.3s;

      &:hover {
        color: #ff4d4d !important;
        transform: translateX(5px);
      }

      i {
        font-size: 16px;
      }
    }
  }
}

// 覆盖element-ui默认样式
:deep(.header-dropdown) {
  .el-popper__arrow {
    display: none !important;
  }

  .el-dropdown-menu__item {
    padding: 0 !important;
  }
}
</style>
