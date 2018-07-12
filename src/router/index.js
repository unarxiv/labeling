import Vue from 'vue'
import VueRouter from 'vue-router'
import Cookies from 'js-cookie'
import iView from 'iview'
import Util from '../libs/util'
import {routers, otherRouter, appRouter} from './router'

Vue.use(VueRouter)

// 路由配置
const RouterConfig = {
  // mode: 'history',
  routes: routers
}

export const router = new VueRouter(RouterConfig)

router.beforeEach((to, from, next) => {
  iView.LoadingBar.start()
  const curRouterObj = Util.getRouterObjByName([otherRouter, ...appRouter], to.name)
  if (curRouterObj && Cookies.get('user')) { // 需要判断权限的路由
    Util.toDefaultPage([otherRouter, ...appRouter], to.name, router, next)
  } else { // 没有配置权限的路由, 直接通过
    Util.toDefaultPage([...routers], to.name, router, next)
  }
})

router.afterEach((to) => {
  iView.LoadingBar.finish()
  window.scrollTo(0, 0)
})
