import Main from '../views/main'
import i18n from '@/i18n'
export const loginRouter = {
  path: '/',
  name: 'login',
  component: () => import('@/views/login')
}

export const otherRouter = {
  path: '/',
  name: 'otherRouter',
  component: Main,
  children: [
    { path: 'index', title: '控制台', name: 'home', component: () => import('@/views/page/home') },
    { path: 'item/:type/:id', title: '项目', name: 'item-info', component: () => import('@/views/page/items') },
    {
      path: '/tools/:type/:id',
      title: i18n.t('router.label_tool'),
      name: 'tools',
      parent: 'tagging',
      component: () => import('@/views/tools/index')
    },
    {
      path: '/train/:id',
      title: '提交训练',
      name: 'train',
      component: () => import('@/views/page/train-send')
    },
    {
      path: '/trainTest/:id',
      title: '提交训练',
      name: 'trainTest',
      component: () => import('@/views/page/train-test')
    },
    {
      path: '/trainlog/:id',
      title: '训练日志',
      name: 'trainlog',
      component: () => import('@/views/page/train-log')
    },
    {
      path: '/trainlist/:id',
      title: '训练记录',
      name: 'trainlist',
      component: () => import('@/views/page/train-list')
    }
  ]
}

export const appRouter = [
  {
    path: '/tagging',
    icon: 'pricetags',
    name: 'tagging',
    title: i18n.t('router.label'),
    component: Main,
    children: [
      { path: 'index', title: '数据标注', name: 'page-tagging', component: () => import('@/views/page/tagging') }
    ]
  },
  {
    path: '/auditing',
    icon: 'ios-eye',
    name: 'auditing',
    title: i18n.t('router.data_audit'),
    component: Main,
    children: [
      { path: 'index', title: '数据审核', name: 'page-auditing', component: () => import('@/views/page/auditing') }
    ]
  },
  {
    path: '/training',
    icon: 'nuclear',
    name: 'training',
    title: i18n.t('router.train'),
    component: Main,
    children: [
      { path: 'index', title: '模型训练', name: 'page-training', component: () => import('@/views/page/training') }
    ]
  },
  {
    path: '/data',
    icon: 'cube',
    name: 'data',
    title: i18n.t('router.group_manage'),
    component: Main,
    children: [
      { path: 'index', title: '分组管理', name: 'page-data', component: () => import('@/views/page/data') }
    ]
  },
  {
    path: '/accounts',
    icon: 'ios-person',
    name: 'accounts',
    title: i18n.t('router.account_manage'),
    component: Main,
    children: [
      { path: 'index', title: '账户管理', name: 'page-accounts', component: () => import('@/views/page/own.vue') }
    ]
  }
]

export const routers = [
  loginRouter,
  otherRouter,
  ...appRouter
]
