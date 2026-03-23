import axios from 'axios'
import { ElMessage } from 'element-plus'

import router from '@/router'
import { useTokenStore } from '@/stores/token'
import useUserInfoStore from '@/stores/userInfo'

const instance = axios.create({
  baseURL: '/api',
})

instance.interceptors.request.use(
  (config) => {
    const tokenStore = useTokenStore()

    if (tokenStore.token) {
      config.headers.Authorization = tokenStore.token
    }

    return config
  },
  (error) => Promise.reject(error)
)

instance.interceptors.response.use(
  (response) => {
    const payload = response.data

    if (payload.code === 0) {
      return payload
    }

    ElMessage.error(payload.msg || payload.message || '服务异常')
    return Promise.reject(payload)
  },
  (error) => {
    const tokenStore = useTokenStore()
    const userInfoStore = useUserInfoStore()
    const status = error.response?.status

    if (status === 401) {
      tokenStore.removeToken()
      userInfoStore.removeInfo()

      if (router.currentRoute.value.path !== '/login') {
        ElMessage.error('请先登录')
        router.replace('/login')
      }
    } else {
      ElMessage.error(error.response?.data?.msg || error.response?.data?.message || '服务异常')
    }

    return Promise.reject(error)
  }
)

export default instance
