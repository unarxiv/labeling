import Vue from 'vue'
import Vuex from 'vuex'
import 'iview/dist/styles/iview.css'
import iView from 'iview'
import App from './App'
import i18n from '@/i18n'
import {router} from './router'
import 'babel-polyfill'
import ElementDataset from 'element-dataset'
import store from './store'

window.Promise = Promise
ElementDataset()
Vue.config.productionTip = false
Vue.use(Vuex)
Vue.use(iView)

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  i18n,
  store: new Vuex.Store(store),
  components: { App },
  template: '<App/>'
})
