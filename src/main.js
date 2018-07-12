// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import 'iview/dist/styles/iview.css' // 导入iview样式
import iView from 'iview'
import App from './App'
import {router} from './router'
import 'babel-polyfill'
import ElementDataset from 'element-dataset'

window.Promise = Promise
ElementDataset()
Vue.config.productionTip = false

Vue.use(iView)

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})
