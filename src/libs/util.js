import axios from 'axios'
import Cookies from 'js-cookie'

let util = {

}
const ajaxUrl = 'http://120.79.213.19:8080/sign_web'

util.ajaxUrl = ajaxUrl
util.imgUrl = 'http://120.79.213.19:8080'
util.ajax = axios.create({
  baseURL: ajaxUrl,
  timeout: 30000,
  withCredentials: true
})

/* 请求拦截器 */
util.ajax.interceptors.request.use(function (config) {
  if (localStorage.getItem('token') !== null) {
    config.headers['AccessToken'] = localStorage.getItem('token')
  }

  return config
}, function (error) {
  return Promise.reject(error)
})

/* 响应拦截器 */
util.ajax.interceptors.response.use(function (response) {
  if (response.data.code === 20000) {
    Cookies.remove('user')
    location.hash = '/'
  }
  return response
}, function (error) {
  return Promise.reject(error)
})

util.getRouterObjByName = function (routers, name) {
  if (!name || !routers || !routers.length) {
    return null
  }
  // debugger;
  let routerObj = null
  for (let item of routers) {
    if (item.name === name) {
      return item
    }
    routerObj = util.getRouterObjByName(item.children, name)
    if (routerObj) {
      return routerObj
    }
  }
  return null
}

util.toDefaultPage = function (routers, name, route, next) {
  let len = routers.length
  let i = 0
  let notHandle = true
  while (i < len) {
    if (routers[i].name === name && routers[i].children && routers[i].redirect === undefined) {
      route.replace({
        name: routers[i].children[0].name
      })
      notHandle = false
      next()
      break
    }
    i++
  }
  if (notHandle) {
    next()
  }
}

export default util
