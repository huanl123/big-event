<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Lock, User } from '@element-plus/icons-vue'

import { userLoginService, userRegisterService } from '@/api/user'
import { useTokenStore } from '@/stores/token'

const router = useRouter()
const tokenStore = useTokenStore()

const isRegister = ref(false)
const formModel = ref({
  username: '',
  password: '',
  rePassword: '',
})

const validateRePassword = (_, value, callback) => {
  if (!isRegister.value) {
    callback()
    return
  }

  if (!value) {
    callback(new Error('请再次确认密码'))
    return
  }

  if (value !== formModel.value.password) {
    callback(new Error('两次输入的密码不一致'))
    return
  }

  callback()
}

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 5, max: 16, message: '用户名长度需为 5-16 位', trigger: 'blur' },
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 5, max: 16, message: '密码长度需为 5-16 位', trigger: 'blur' },
  ],
  rePassword: [{ validator: validateRePassword, trigger: 'blur' }],
}

const resetForm = () => {
  formModel.value = {
    username: '',
    password: '',
    rePassword: '',
  }
}

const switchMode = (registerMode) => {
  isRegister.value = registerMode
  resetForm()
}

const register = async () => {
  try {
    const result = await userRegisterService(formModel.value)
    ElMessage.success(result.msg || '注册成功')
    switchMode(false)
  } catch (_) {
  }
}

const login = async () => {
  try {
    const result = await userLoginService(formModel.value)
    tokenStore.setToken(result.data)
    ElMessage.success(result.msg || '登录成功')
    router.push('/')
  } catch (_) {
  }
}
</script>

<template>
  <el-row class="login-page">
    <el-col :span="12" class="bg" />
    <el-col :span="6" :offset="3" class="form">
      <el-form
        v-if="isRegister"
        size="large"
        autocomplete="off"
        :model="formModel"
        :rules="rules"
      >
        <el-form-item>
          <h1>注册</h1>
        </el-form-item>
        <el-form-item prop="username">
          <el-input v-model="formModel.username" :prefix-icon="User" placeholder="请输入用户名" />
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            v-model="formModel.password"
            :prefix-icon="Lock"
            type="password"
            placeholder="请输入密码"
          />
        </el-form-item>
        <el-form-item prop="rePassword">
          <el-input
            v-model="formModel.rePassword"
            :prefix-icon="Lock"
            type="password"
            placeholder="请再次输入密码"
          />
        </el-form-item>
        <el-form-item>
          <el-button class="button" type="primary" auto-insert-space @click="register">
            注册
          </el-button>
        </el-form-item>
        <el-form-item class="flex">
          <el-link type="info" :underline="false" @click="switchMode(false)">返回登录</el-link>
        </el-form-item>
      </el-form>

      <el-form v-else size="large" autocomplete="off" :model="formModel" :rules="rules">
        <el-form-item>
          <h1>登录</h1>
        </el-form-item>
        <el-form-item prop="username">
          <el-input v-model="formModel.username" :prefix-icon="User" placeholder="请输入用户名" />
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            v-model="formModel.password"
            :prefix-icon="Lock"
            type="password"
            placeholder="请输入密码"
          />
        </el-form-item>
        <el-form-item class="flex">
          <div class="flex">
            <el-checkbox>记住我</el-checkbox>
            <el-link type="primary" :underline="false">忘记密码？</el-link>
          </div>
        </el-form-item>
        <el-form-item>
          <el-button class="button" type="primary" auto-insert-space @click="login">登录</el-button>
        </el-form-item>
        <el-form-item class="flex">
          <el-link type="info" :underline="false" @click="switchMode(true)">注册</el-link>
        </el-form-item>
      </el-form>
    </el-col>
  </el-row>
</template>

<style lang="scss" scoped>
.login-page {
  height: 100vh;
  background-color: #fff;

  .bg {
    background:
      url('@/assets/logo2.png') no-repeat 60% center / 240px auto,
      url('@/assets/login_bg.jpg') no-repeat center / cover;
    border-radius: 0 20px 20px 0;
  }

  .form {
    display: flex;
    flex-direction: column;
    justify-content: center;
    user-select: none;

    .button {
      width: 100%;
    }

    .flex {
      width: 100%;
      display: flex;
      justify-content: space-between;
    }
  }
}
</style>
