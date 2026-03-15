<template>
  <div class="home-container">

    <!-- 主内容区 -->
    <div class="main-content">
      <!-- 轮播图 -->
      <el-carousel
          class="modern-carousel"
          indicator-position="outside"
          height="300px"
      >
        <el-carousel-item v-for="(item, index) in imgItem" :key="index">
          <img :src="item.url"  class="carousel-img">
        </el-carousel-item>
      </el-carousel>

      <div class="notice-board">
        <div class="board-header">
          <i class="fas"></i>
          <h2>活动公告</h2>
        </div>
        <el-collapse
            v-model="active"
            class="modern-collapse"
            accordion
        >
          <el-collapse-item
              v-for="(item, index) in notices"
              :key="index"
              :name="index + ''"
          >
            <template slot="title">
              <div class="notice-title">
                {{ item.name  }}
              </div>
            </template>
            <div class="notice-content">
              {{ item.content  }}
            </div>
          </el-collapse-item>
        </el-collapse>
      </div>

      <!-- 动物卡片 -->
      <div class="animal-cards">
        <div
            v-for="(item, index) in tableData"
            :key="index"
            class="animal-card"
        >
          <div class="card-image">
            <img
                :src="item.img"
                class="brand-icon"
                style="width: 100%; height: 180px; border-radius: 15px"
            >
          </div>
          <div class="card-content">
            <div class="card-header">
              <h3 class="animal-name">{{ item.nickname  }}</h3>
              <div class="meta-info">
                <span><i class="fas fa-venus-mars"></i> {{ item.sex  }}</span>
                <span><i class="fas fa-birthday-cake"></i> {{ item.age  }}</span>
              </div>
            </div>

            <div class="info-section">
              <div class="info-item">
                <i class="fas fa-delicious"></i>
                <b>所属种类:</b> {{ item.type  }}
              </div>
              <div class="info-item">
                <i class="fas fa-map-marker-alt"></i>
                <b>活动范围:</b> {{ item.address  }}
              </div>
              <div class="info-item">
                <i class="fas fa-heartbeat"></i>
                <b>身体状态:</b> {{ item.status  }}
              </div>
              <div class="info-item">
                <i class="fas fa-info-circle"></i>
                <b>其他描述:</b> {{ item.information  }}
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <el-pagination
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            :current-page="pageNum"
            :page-sizes="[2, 5, 10, 20]"
            :page-size="pageSize"
            layout="total, prev, pager, next"
            :total="total"
            class="modern-pagination"
        >
        </el-pagination>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "FrontHome",
  data() {
    return {
      imgItem: [
        {url: require('../../assets/carousel/img1.jpeg')},
        {url: require('../../assets/carousel/img2.jpeg')},
        {url: require('../../assets/carousel/img3.jpeg')},
        {url: require('../../assets/carousel/img4.jpeg')},
      ],
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 10,
      name: "",
      notices: [],
      active: '0'
    }
  },
  created() {
    this.load()
  },
  mounted() {
    //this.initParticles()
  },
  methods: {
    load() {
      this.request.get("/animal/page", {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          name: this.name,
        }
      }).then(res => {
        this.tableData = res.data.records
        this.total = res.data.total
      })

      this.request.get("/activity/front").then(res => {
        this.notices = res.data
      })
    },
    handleSizeChange(pageSize) {
      this.pageSize = pageSize
      this.load()
    },
    handleCurrentChange(pageNum) {
      this.pageNum = pageNum
      this.load()
    },
    initParticles() {
      particlesJS("particles", {
        particles: {
          number: {value: 80, density: {enable: true, value_area: 800}},
          color: {value: "#ffffff"},
          shape: {type: "circle"},
          opacity: {value: 0.5, random: false},
          size: {value: 3, random: true},
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
            onhover: {enable: true, mode: "repulse"},
            onclick: {enable: true, mode: "push"},
            resize: true
          }
        },
        retina_detect: true
      })
    }
  }
}
</script>

<style lang="scss">
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css');

.home-container {
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

  .notice-board {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 15px;
    margin: 25px 0;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);

    .board-header {
      padding: 20px;
      border-bottom: 1px solid #eee;
      display: flex;
      align-items: center;
      gap: 12px;

      i {
        color: #ff9f43;
        font-size: 24px;
      }

      h2 {
        margin: 0;
        color: #2d3748;
      }
    }
  }

  .modern-collapse {
    border: none;

    ::v-deep .el-collapse-item__header {
      padding: 20px 20px;
      font-size: 16px;
      background: rgba(102, 126, 234, 0.1);
      border-bottom: 1px solid #eee;
    }

    .notice-title {
      display: flex;
      align-items: center;
      margin-left: 15px;
      font-size: 16px;
      font-family: '黑体';
      gap: 10px;
      color: #4a5568;
    }

    .notice-content {
      padding: 20px;
      line-height: 1.8;
      color: #718096;
      background: rgba(245, 245, 245, 0.5);
    }
  }

  .main-content {
    position: relative;
    z-index: 2;
    padding: 30px;
    max-width: 1200px;
    margin: 0 auto;

    .modern-carousel {
      border-radius: 15px;
      overflow: hidden;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);

      .carousel-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }
    }

    .animal-cards {
      margin-top: 30px;

      .animal-card {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 15px;
        padding: 20px;
        margin-bottom: 20px;
        display: flex;
        gap: 25px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease;

        &:hover {
          transform: translateY(-5px);
        }

        .card-image {
          flex: 0 0 250px;

          img {
            object-fit: cover;
          }
        }

        .card-content {
          flex: 1;

          .card-header {
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 15px;

            .animal-name {
              font-size: 24px;
              color: #2d3748;
              margin: 0 0 10px;
            }

            .meta-info {
              display: flex;
              gap: 20px;
              color: #718096;

              span {
                display: flex;
                align-items: center;
                gap: 5px;
              }
            }
          }

          .info-section {
            .info-item {
              display: flex;
              align-items: center;
              gap: 10px;
              margin-bottom: 12px;
              color: #4a5568;

              i {
                color: #ff9f43;
                width: 20px;
                text-align: center;
                font-family: '黑体';
              }

              b {
                margin-right: 8px;
                color: #2d3748;
              }
            }
          }
        }
      }
    }

    .pagination-wrapper {
      background: rgba(255, 255, 255, 0.9);
      border-radius: 10px;
      padding: 15px;
      margin-top: 20px;

      .modern-pagination {
        .btn-prev, .btn-next {
          border-radius: 20px;
          padding: 0 15px;
        }

        .el-pager {
          li {
            border-radius: 50%;
            margin: 0 5px;

            &.active {
              background: linear-gradient(135deg, #ff9f43, #ff6b6b);
            }
          }
        }
      }
    }
  }
}
</style>
