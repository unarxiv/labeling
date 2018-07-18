import Vue from 'vue'
import iView from 'iview'
import topmenu from '@/views/main/topmenu.vue'
Vue.use(iView)

describe('topmenu.vue', () => {
  it('should render correct contents', () => {
    const Constructor = Vue.extend(topmenu)
    const vm = new Constructor().$mount()
    expect(vm.$el.querySelector('.top-menu-title').textContent)
      .toEqual('产品服务')
  })
})
