<template>
  <div style="background: #F0F8FF">
    <!-- 头部 -->
    <div class="header-container">
      <div class="logo-container">
        <div class="logo-wrapper">
          <img src="../../assets/logo1.png"  alt="logo" class="logo-img">
        </div>
        <div class="system-title">StrayAnimal</div>
      </div>

      <div class="menu-container">
        <!-- default-active mode 选中菜单时标色 -->
        <el-menu
            :default-active="activeIndex"
            mode="horizontal"
            style="font-family: 'Microsoft YaHei';"
            router
            class="modern-menu"
            background-color="transparent"
            text-color="#5d4037"
            active-text-color="#FF9F43">
            <!-- index本身是用于activeIndex的，router使其同时可以指向路径 -->
          <el-menu-item index="/front/home">首页</el-menu-item>
          <el-menu-item index="/front/adopt">宠物领养</el-menu-item>
          <el-menu-item index="/front/salvation">流浪宠物救助</el-menu-item>
          <el-menu-item index="/front/feed">宠物喂养点</el-menu-item>
          <el-menu-item index="/front/lost">丢失宠物</el-menu-item>
          <el-menu-item index="/front/rescue">流浪宠物救助站</el-menu-item>
          <el-menu-item index="/front/article">宠物论坛</el-menu-item>
          <!-- <el-menu-item index="/front/donate">宠物捐赠</el-menu-item> -->
          <el-menu-item index="/front/petShop">宠物商城</el-menu-item>
          <el-menu-item index="/front/articleKp">科普文章</el-menu-item>
          <el-menu-item index="/front/activity">热门活动</el-menu-item>
          
          <el-menu-item v-if="user.username" index="/front/recommend">为你推荐</el-menu-item>
        </el-menu>
      </div>

      <div class="user-container">
        <div v-if="!user.username"  class="auth-buttons">
          <el-button
              type="primary"
              plain
              @click="$router.push('/login')"
              class="login-btn">
            登录
          </el-button>
          <el-button
              type="success"
              plain
              @click="$router.push('/register')"
              class="register-btn">
            注册
          </el-button>
        </div>

        <div v-else class="user-info">
          <el-dropdown class="user-dropdown">
            <div class="dropdown-trigger">
              <img :src="user.avatarUrl"  class="user-avatar">
              <span class="user-name">{{ user.nickname  }}</span>
              <i class="el-icon-arrow-down"></i>
            </div>
            <el-dropdown-menu slot="dropdown" class="dropdown-menu">
              <el-dropdown-item v-if="user.role  === 'ROLE_ADMIN'">
                <router-link to="/" class="menu-link">后台管理</router-link>
              </el-dropdown-item>
              <el-dropdown-item>
                <router-link to="/front/password" class="menu-link">修改密码</router-link>
              </el-dropdown-item>
              <el-dropdown-item>
                <router-link to="/front/person" class="menu-link">个人信息</router-link>
              </el-dropdown-item>
              <el-dropdown-item>
                <router-link to="/front/myOrders" class="menu-link">我的订单</router-link>
              </el-dropdown-item>
              <el-dropdown-item divided>
                <span class="logout-btn" @click="logout">退出登录</span>
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </div>
      </div>
    </div>

    <!-- 页面内容 -->
    <div class="bg1">
      <div style="width: 100%; margin: 0 auto;">
        <router-view/>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Front",
  data() {
    return {
      user: localStorage.getItem("user")  ? JSON.parse(localStorage.getItem("user"))  : {},
      isLogin: localStorage.getItem("user") ? true : false,
      activeIndex: ''
    }
  },
  computed: {
    // 计算当前激活的菜单项
    currentPath() {
      return this.$route.path;
    }
  },
  watch: {
    // 监听路由变化，更新激活的菜单项
    '$route': {
      handler(to) {
        this.updateActiveIndex(to.path);
      },
      immediate: true
    }
  },
  methods: {
    logout() {
      this.$store.commit("logout")
      this.$message.success(" 退出成功")
    },
    // 更新激活的菜单项
    updateActiveIndex(path) {
      // 如果是详情页，则激活对应的列表页
      if (path.includes('/front/homeDetail')) {
        this.activeIndex = '/front/home';
      } else if (path.includes('/front/adoptDetail')) {
        this.activeIndex = '/front/adopt';
      } else if (path.includes('/front/articleDetail')) {
        this.activeIndex = '/front/article'; 
      } else if (path.includes('/front/shopDetail')) {
        this.activeIndex = '/front/petShop';
      } else if (path.startsWith('/front/myOrders')) {
        this.activeIndex =  '';       
      } else {
        // 对于其他页面，直接使用当前路径
        this.activeIndex = path;
      }
    }
  },
  mounted() {
    // 初始化激活菜单项
    this.updateActiveIndex(this.$route.path);
  }
}
</script>

<style lang="scss">
.modern-menu {
  border-bottom: none;
  display: flex;
  flex-wrap: nowrap; /* 不允许菜单项换行 */
  justify-content: flex-start; /* 从左侧开始排列 */
  overflow-x: auto; /* 允许水平滚动 */
  white-space: nowrap; /* 防止菜单项本身换行 */
  
  
  /* 隐藏滚动条但保留滚动功能 */
  &::-webkit-scrollbar {
    display: none; /* 为Chrome, Safari和Opera隐藏滚动条 */
  }
  -ms-overflow-style: none; /* IE和Edge */
  scrollbar-width: none; /* Firefox */
  
  .el-menu-item {
    padding: 0 16px;
    height: 55px;
    line-height: 55px;
    font-size: 15px;
    flex-shrink: 0; /* 防止菜单项收缩 */
  }
}

/* 移除媒体查询中的flex-direction: column，保持水平排列 */
@media (max-width: 768px) {
  .modern-menu {
    /* 不再将flex-direction设置为column */
    justify-content: flex-start;
  }
}

/* 头部容器 */
.header-container {
  //background: rgba(86, 0, 103, 0.89);   /* 半透明底 */
  background: #FFF;
  height: 70px;
  display: flex;
  align-items: center;
  padding: 0 30px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  position: relative;
  z-index: 1000;
}

/* Logo区域 */
.logo-container {
  display: flex;
  align-items: center;
  width: 240px;
  .logo-img {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    margin-right: 15px;
  }
  .system-title {
    color: #f99848;
    font-size: 17px;
    font-weight: 300;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
    font-family: "Lucida Console", "Courier New", monospace;;
  }
}

/* 菜单区域 */
.menu-container {
  flex: 1;
}

/* 用户操作区域 */
.user-container {
  width: 300px;
  display: flex;
  justify-content: flex-end;
  .auth-buttons {
    .el-button {
      margin-left: 15px;
      border-radius: 20px;
      padding: 8px 20px;
    }
  }
  .user-info {
    .user-dropdown {
      color: #5d4037;
      font-family: '黑体';
      .dropdown-trigger {
        display: flex;
        align-items: center;
        .user-avatar {
          width: 35px;
          height: 35px;
          border-radius: 50%;
          margin-right: 8px;
        }
        .user-name {
          margin-right: 10px;
          max-width: 120px;
          overflow: hidden;
          text-overflow: ellipsis;
        }
      }
    }
  }
}

/* 下拉菜单样式 */
.dropdown-menu {
  margin-top: 5px !important;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  .menu-link {
    color: #606266;
    text-decoration: none;
    &:hover {
      color: #409EFF;
    }
  }
  .logout-btn {
    color: #f56c6c;
    cursor: pointer;
    &:hover {
      color: #ff0000;
    }
  }
}

/* 内容区域 */
.bg1 {
  width: 100%;
  min-height: calc(100vh - 60px);
  background: linear-gradient(to bottom right, #f0f8ff, #e6f7ff);
}
</style>
