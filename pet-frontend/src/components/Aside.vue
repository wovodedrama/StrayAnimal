<template>
  <el-menu :default-openeds="opens" style="min-height: 100vh;" text-color="#d1d1d1" active-text-color="#f0f0f0"
    :collapse-transition="false" :collapse="isCollapse" router class="modern-menu">
    <!-- 菜单头部 -->
    <div class="menu-header">
      <img src="../assets/logo1.png" alt="Logo">
      <transition name="fade">
        <b v-show="logoTextShow" style="color: #fff;margin-left: 6px;">管理系统</b> <!-- 标题颜色调整 -->
      </transition>
    </div>

    <!-- 菜单内容 -->
    <template v-for="item in menus">
      <el-menu-item v-if="item.path" :index="item.path" class="menu-item">
        <i :class="item.icon" style="color: #fff;"></i> <!-- 保持图标颜色同步 -->
        <span style="color: #fff;" slot="title">{{ item.name }}</span>
      </el-menu-item>

      <el-submenu class="menu-item" v-else :index="item.id + ''" popper-class="submenu-popper">
        <template slot="title">
          <i :class="item.icon" style="color: #fff;"></i>
          <span style="color: #fff;">{{ item.name }}</span>
        </template>
        <el-menu-item v-for="subItem in item.children" :key="subItem.id" :index="subItem.path"
           class="menu-chidren">
          <i :class="subItem.icon" style="color: #a0a0a0;"></i>
          <span slot="title">{{ subItem.name }}</span>
        </el-menu-item>
      </el-submenu>
    </template>
  </el-menu>
</template>

<script>
// 脚本部分保持不变
export default {
  name: "ModernAside",
  props: {
    isCollapse: Boolean,
    logoTextShow: Boolean
  },
  data() {
    return {
      menus: JSON.parse(localStorage.getItem("menus") || '[]'),
      opens: JSON.parse(localStorage.getItem("menus") || '[]').map(v => v.id + '')
    }
  },
  // 关键：监听路由或 store 变化，确保菜单实时更新
  watch: {
    '$route'() {
       this.menus = JSON.parse(localStorage.getItem("menus") || '[]');
    }
  }
}
</script>

<style scoped lang="scss">
.modern-menu {
  overflow-x: hidden;
  box-shadow: 0 5px 25px rgba(0, 0, 0, 0.3);
  background: #a68d7b;

  .menu-header {
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 15px;
    background: rgba(0, 0, 0, 0.2);
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);

    img {
      width: 24px;
      transition: transform 0.3s;
      filter: brightness(0.8);
    }
  }

  .el-menu-item {
    background: transparent;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  }

  .el-menu-item:hover {
    background: rgba(255, 255, 255, 0.08);
  }

  .el-menu-item.is-active {
    background: #6b705c;
    box-shadow: 0 4px 14px rgba(0, 0, 0, 0.2);
    border-left: 2px solid #ffffff;
  }
}

.menu-chidren {
  background: #937d6d !important;
}

.menu-chidren:hover {
  background: transparent !important;
}

.menu-chidren.is-active {
  background-color:  #5a5e4d !important;
}


/* 新增子菜单弹出层样式 */
::v-deep .submenu-popper {
  .el-menu {
    background: rgba(40, 40, 40, 0.95) !important;
    border-radius: 4px;

    .el-menu-item {
      &:hover {
        background: rgba(255, 255, 255, 0.08) !important;
      }

      &.is-active {
        background: rgba(52, 152, 219, 0.15) !important;
      }
    }
  }

  .el-menu--popup {
    min-width: 180px !important;
  }
}
</style>
