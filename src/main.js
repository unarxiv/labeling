import Vue from 'vue'
import 'iview/dist/styles/iview.css' 
import iView from 'iview'
import App from './App'
import i18n from '@/i18n'
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
  i18n,
  components: { App },
  template: '<App/>'
})
