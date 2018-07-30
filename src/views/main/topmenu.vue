<template>
    <div class="layout-nav">
        <div class="layout-logo" @click="go('/')">
            <img class="layout-logo-img" src="@/assets/images/logo.png"/>
        </div>
        <Menu mode="horizontal" theme="dark" active-name="1">
            <menu-item name="1-1">
                <span class="top-menu-title">{{$t("topmenu.product_service")}}</span>
            </menu-item>
            <menu-item name="1-2">
                <span class="top-menu-title">{{$t("topmenu.solutions")}}</span>
            </menu-item>
            <menu-item name="1-3">
                <span class="top-menu-title">{{$t("topmenu.use_cases")}}</span>
            </menu-item>
            <menu-item name="1-4">
                <span class="top-menu-title">{{$t("topmenu.development")}}</span>
            </menu-item>
            <menu-item name="1-5">
                <span class="top-menu-title">{{$t("topmenu.cooperations")}}</span>
            </menu-item>
        </Menu>
        <div class="layout-console" v-if="isLogin">
            <Avatar icon="person" size="small" style="background-color: #495060; color:rgba(255,255,255,.5)"/><span> {{userName}},</span>
            <Button type="text" @click="go('/index')" size="small">
                <span>控制台</span>
            </Button>
            <Button type="text" @click="loginout" size="small">
                <span>退出</span>
            </Button>
        </div>

    </div>
</template>
<script>
import Cookies from 'js-cookie'
// import util from '../../libs/util'

export default {
  name: 'topMenu',
  data () {
    return {
      isLogin: !!Cookies.get('user'),
      userName: Cookies.get('user')
    }
  },
  methods: {
    go (url) {
      this.$router.push(url)
    },
    loginout () {
      this.$router.push({path: '/', query: {out: true}})
    //   util.ajax.post('/user/logout.do')
    //     .then((res) => {
    //       if (res.data.status) {
    //         this.$Message.success(res.data.data)
    //         // 退出登录
    //         Cookies.remove('user')
    //         localStorage.removeItem('token')
    //         this.$router.push({path: '/', query: {out: true}})
    //       } else {
    //         this.$Message.error(res.data.errormsg)
    //       }
    //     })
    //     .catch((e) => {
    //       console.log(e)
    //     })
    }
  },
  watch: {
    '$route': function () {
      this.isLogin = !!Cookies.get('user')
    }
  }
}
</script>
<style lang="less">
.top-menu-title{
    font-size:16px;
}
.layout-logo{
    width: 100px;
    height: 45px;
    border-radius: 3px;
    float: left;
    position: relative;
    top: 10px;
    left: 20px;
    margin-right: 90px;
}
.layout-nav{
    &>ul{
        float: left;
    }
    .layout-console{
        position: absolute;
        right: 60px;
        font-size: 14px;
        line-height: 60px;
    }
}
.layout-logo-img {
    width: 45px;
    margin-top:auto;
    margin-bottom:auto;
}
</style>
