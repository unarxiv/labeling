<template>
  <Layout class="layout">
        <Layout>
            <Header>
                <top-menu></top-menu>
            </Header>
            <Layout class="layout-content page-content" ref="page-content">
                <Sider collapsible :collapsed-width="78" v-model="isCollapsed">
                    <left-menu :isCollapsed="isCollapsed"></left-menu>
                </Sider>
                <Layout :style="{padding: '30px'}">
                    <div>
                        <span @click="$router.go(-1)" style="position: absolute;z-index: 1;margin-top: 13px;margin-left: 8px;"><Icon type="android-arrow-back" style="font-size:2em"></Icon></span>
                    </div>
                    <router-view></router-view>
                </Layout>
            </Layout>
        </Layout>
    </Layout>
</template>

<script>
import LeftMenu from './leftmenu'
import TopMenu from './topmenu'

export default {
  name: 'Main',
  components: {
    LeftMenu,
    TopMenu
  },
  data () {
    return {
      isCollapsed: false

    }
  },
  mounted () {
    this.$refs['page-content'].$el.style.height = (document.documentElement.offsetHeight - 64) + 'px'
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="less" scoped>
.layout{
    background: #f5f7f9;
    overflow: hidden;
    position: absolute;
    width: 100%;
    height: 100vh;
    .ivu-layout-header{
        padding: 0;

        .layout-nav{
            .ivu-menu-dark {
                background: #0A0E17;
            }
        }

    }

}

.ie9{
    .layout{
        .layout-content{
            height: 100%;
            width: 100%;
            position: absolute;

            &>.ivu-layout-sider{
                max-height: 100%;
                min-height: 100%;
                float: left;
            }
            &>.ivu-layout{
                max-height: 100%;
                min-height: 100%;
            }
        }
    }
}
</style>
<style lang="less">
.layout{
    .ivu-layout-header{
        background: #0A0E17;

        .layout-nav{
            .ivu-menu-dark {
                background: #0A0E17;
            }
        }

    }
    .ivu-layout-sider{
        background: #1B1D2F;

        .ivu-menu-dark{
            background: #1B1D2F;

            .ivu-menu-item-active,.ivu-menu-item:hover{
                background: #1798A4;
                color: #fff;
            }
        }
        .ivu-layout-sider-trigger{
            background: #1B1D2F;
        }
    }
}
</style>
