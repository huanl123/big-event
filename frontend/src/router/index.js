import { createRouter, createWebHistory } from 'vue-router'

import LoginView from '@/views/Login.vue'
import LayoutView from '@/views/Layout.vue'
import ArticleCategoryView from '@/views/article/ArticleCategory.vue'
import ArticleManageView from '@/views/article/ArticleManage.vue'
import UserAvatarView from '@/views/user/UserAvatar.vue'
import UserInfoView from '@/views/user/UserInfo.vue'
import UserResetPasswordView from '@/views/user/UserResetPassword.vue'
import { useTokenStore } from '@/stores/token'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/login', component: LoginView },
    {
      path: '/',
      component: LayoutView,
      redirect: '/article/manage',
      children: [
        { path: '/article/category', component: ArticleCategoryView },
        { path: '/article/manage', component: ArticleManageView },
        { path: '/user/info', component: UserInfoView },
        { path: '/user/avatar', component: UserAvatarView },
        { path: '/user/resetPassword', component: UserResetPasswordView },
      ],
    },
  ],
})

router.beforeEach((to) => {
  const tokenStore = useTokenStore()
  const hasToken = !!tokenStore.token

  if (to.path === '/login') {
    return hasToken ? '/' : true
  }

  return hasToken ? true : '/login'
})

export default router
