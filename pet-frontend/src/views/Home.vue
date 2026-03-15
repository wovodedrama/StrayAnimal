<template>
  <div class="home-container">
    <div class="particles-bg"></div>

    <div class="main-content">
      <div style="padding-bottom: 10px">
        <b style="color: #5d4037;">您好！{{ user.nickname  }}</b>
      </div>

      <div class="notice-board">
        <el-card class="modern-table">
          <div class="board-header">
            <i class="el-icon-s-home"></i>
            <span>欢迎使用本系统</span>
          </div>
          <el-divider />
          <div class="info-item">
            <i class="el-icon-star-off"></i>
            <span>以爱之名，宠你一生！</span>
          </div>
        </el-card>
      </div>

      <el-row :gutter="20">
        <el-col :span="12">
          <div id="main" class="chart-box"></div>
        </el-col>
        <el-col :span="12">
          <div id="pie" class="chart-box"></div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>
<script>

import * as echarts from 'echarts';

export default {
  name: "Home",
  data() {
    return {
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      myChart: null, // 折线图实例
      pieChart: null // 饼图实例
    }
  },
  // 页面销毁前，销毁图表实例，防止内存泄漏和渲染问题
  beforeDestroy() {
    if (this.myChart) {
      this.myChart.dispose();
    }
    if (this.pieChart) {
      this.pieChart.dispose();
    }
  },
  mounted() {  
    // 页面元素渲染后再触发
    this.$nextTick(() =>{
      this.initCharts();
    });
  },
  methods: {
    initCharts() {
      const chartDom = document.getElementById('main');
      this.myChart = echarts.init(chartDom);

      const option = {
        title: { text: '各季度系统注册人数统计', subtext: '趋势图', left: 'center' },
        xAxis: { type: 'category', data: ["第一季度", "第二季度", "第三季度", "第四季度"] },
        yAxis: { type: 'value' },
        series: [{ data: [], type: 'line' }, { data: [], type: 'bar' }]
      };

      // --- 2. 饼图初始化 ---
      const pieDom = document.getElementById('pie');
      this.pieChart = echarts.init(pieDom);
      
      const pieOption = {
        title: { text: '各季度系统注册人数统计', subtext: '比例图', left: 'center' },
        tooltip: { trigger: 'item' },
        legend: { orient: 'vertical', left: 'left' },
        series: [{
          type: 'pie',
          radius: '60%',
          label: { normal: { show: true, position: 'inner', formatter: '{d}%' } },
          data: []
        }]
      };

      // --- 3. 统一请求数据 ---
      // 建议只发一次请求，减少服务器压力
      this.request.get("/echarts/members").then(res => {
        if (res.code === '200' || res.data) {
          // 更新折线图
          option.series[0].data = res.data;
          option.series[1].data = res.data;
          this.myChart.setOption(option);

          // 更新饼图
          pieOption.series[0].data = [
            { name: "第一季度", value: res.data[0] },
            { name: "第二季度", value: res.data[1] },
            { name: "第三季度", value: res.data[2] },
            { name: "第四季度", value: res.data[3] },
          ];
          this.pieChart.setOption(pieOption);
          
          // 额外技巧：防止窗口缩放导致图表变形
          window.addEventListener('resize', () => {
            this.myChart.resize();
            this.pieChart.resize();
          });
        }
      });
    }
  }
}
</script>
<style lang="scss" scoped>
.home-container {
  margin-top: 1px;
  min-height: 93vh;
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
    color: #fff;

    b {
      font-size: 24px;
      color: rgba(255,255,255,0.9);
    }
  }

  .chart-box {
    width: 100%;
    height: 400px;
    background: rgba(255,255,255,0.95);
    border-radius: 15px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    margin-top: 20px;
  }

  .modern-table {
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    background: rgba(255,255,255,0.95);

    ::v-deep .el-card__body {
      padding: 20px;
    }

    .board-header {
      padding: 20px;
      display: flex;
      align-items: center;
      gap: 15px;
      font-size: 16px;
      color: #4a5568;

      i {
        color: #ff9f43;
        font-size: 24px;
      }
    }

    .info-item {
      display: flex;
      align-items: center;
      gap: 10px;
      color: #4a5568;
      padding: 10px 0;

      i {
        color: #ff9f43;
        font-size: 18px;
      }
    }
  }

  .notice-board {
    margin: 25px 0;
    border-radius: 15px;
    overflow: hidden;
  }
}

::v-deep .el-divider--horizontal {
  margin: 16px 0;
  background: rgba(102, 126, 234, 0.2);
}
</style>
