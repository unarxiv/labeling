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
    { path: 'index', title: i18n.t('topmenu.console'), name: 'home', component: () => import('@/views/page/home') },
    { path: 'item/:type/:id', title: i18n.t('router.project'), name: 'item-info', component: () => import('@/views/page/items') },
    {
      path: '/tools/:type/:id',
      title: i18n.t('router.label_tool'),
      name: 'tools',
      parent: 'tagging',
      component: () => import('@/views/tools/index')
    },
    {
      path: '/train/:id',
      title: i18n.t('router.submit_training'),
      name: 'train',
      component: () => import('@/views/page/train-send')
    },
    {
      path: '/trainTest/:id',
      title: i18n.t('router.submit_training'),
      name: 'trainTest',
      component: () => import('@/views/page/train-test')
    },
    {
      path: '/trainlog/:id',
      title: i18n.t('router.train_log'),
      name: 'trainlog',
      component: () => import('@/views/page/train-log')
    },
    {
      path: '/trainlist/:id',
      title: i18n.t('router.train_record'),
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
      { path: 'index', title: i18n.t('router.label'), name: 'page-tagging', component: () => import('@/views/page/tagging') }
    ]
  },
  {
    path: '/auditing',
    icon: 'ios-eye',
    name: 'auditing',
    title: i18n.t('router.data_audit'),
    component: Main,
    children: [
      { path: 'index', title: i18n.t('router.data_audit'), name: 'page-auditing', component: () => import('@/views/page/auditing') }
    ]
  },
  {
    path: '/training',
    icon: 'nuclear',
    name: 'training',
    title: i18n.t('router.train'),
    component: Main,
    children: [
      { path: 'index', title: i18n.t('router.train'), name: 'page-training', component: () => import('@/views/page/training') }
    ]
  },
  {
    path: '/data',
    icon: 'cube',
    name: 'data',
    title: i18n.t('router.group_manage'),
    component: Main,
    children: [
      { path: 'index', title: i18n.t('router.group_manage'), name: 'page-data', component: () => import('@/views/page/data') }
    ]
  },
  {
    path: '/accounts',
    icon: 'ios-person',
    name: 'accounts',
    title: i18n.t('router.account_manage'),
    component: Main,
    children: [
      { path: 'index', title: i18n.t('router.account_manage'), name: 'page-accounts', component: () => import('@/views/page/own.vue') }
    ]
  }
]

export const routers = [
  loginRouter,
  otherRouter,
  ...appRouter
]
