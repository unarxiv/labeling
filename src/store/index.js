import Cookies from 'js-cookie'

const store = {
  state: {
    login: !!Cookies.get('user'),
    right: ''
  },
  mutations: {
    setLogin (state) {
      state.login = !!Cookies.get('user')
    },
    loginOut (state) {
      Cookies.remove('user')
      localStorage.removeItem('token')
      state.login = false
    }
  },
  actions: {

  },
  modules: {

  }
}

export default store
