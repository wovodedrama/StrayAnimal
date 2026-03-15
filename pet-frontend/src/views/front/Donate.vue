<template>
  <div class="home-container">
    <el-card class="main-content">
      <div>详情请联系负责人: 张三</div>
      <div>联系电话: 010-65998877</div>
      <div>微信: xxxx-ss</div>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "Donate"
}
</script>

<style scoped>
.home-container {
  min-height: 100vh;
  background: #FFFBF0;
  position: relative;
  overflow-x: hidden;

  .particles-bg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
    background: rgba(0,0,0,0.03);
  }

  .main-content {
    position: relative;
    z-index: 2;
    padding: 30px;
    max-width: 1200px;
    margin: 0 auto;

    .operation-bar {
      background: rgba(255,255,255,0.95);
      padding: 20px;
      border-radius: 15px;
      margin-bottom: 25px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);

      .search-input {
        width: 400px;
        margin-right: 15px;
      }
    }
  }

  .modern-table {
    ::v-deep .el-table__header {
      th {
        background: linear-gradient(135deg, #ff9f43, #ff6b6b) !important;
        color: white;
        font-size: 16px;
        font-weight: 500;
      }
    }

    .post-title {
      cursor: pointer;
      color: #5d4037;
      font-weight: bold;
      &:hover {
        text-decoration: underline;
      }
    }

    .info-item {
      display: flex;
      align-items: center;
      gap: 10px;
      color: #4a5568;

      i {
        color: #ff9f43;
        font-size: 18px;
      }
    }
  }

  .pagination-wrapper {
    background: rgba(255, 255, 255, 0.9);
    border-radius: 10px;
    padding: 15px;
    margin-top: 20px;

    ::v-deep .modern-pagination {
      .btn-prev, .btn-next {
        border-radius: 20px;
        padding: 0 15px;
        border: 1px solid #eee;
      }

      .el-pager {
        li {
          border-radius: 8px;
          margin: 0 5px;
          background: transparent;

          &.active {
            background: linear-gradient(135deg, #ff9f43, #ff6b6b);
            color: white;
          }
        }
      }
    }
  }
}
</style>
