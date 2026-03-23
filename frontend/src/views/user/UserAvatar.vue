<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { Plus, Upload } from '@element-plus/icons-vue'

import defaultAvatar from '@/assets/default.png'
import { userAvatarUpdateService } from '@/api/user'
import { useTokenStore } from '@/stores/token'
import useUserInfoStore from '@/stores/userInfo'

const uploadRef = ref()
const tokenStore = useTokenStore()
const userInfoStore = useUserInfoStore()
const imgUrl = ref(userInfoStore.info.userPic || '')

const uploadSuccess = (result) => {
  imgUrl.value = result.data
}

const updateAvatar = async () => {
  try {
    const result = await userAvatarUpdateService(imgUrl.value)
    userInfoStore.info.userPic = imgUrl.value
    ElMessage.success(result.msg || '修改成功')
  } catch (_) {
  }
}
</script>

<template>
  <el-card class="page-container">
    <template #header>
      <div class="header">
        <span>更换头像</span>
      </div>
    </template>

    <el-row>
      <el-col :span="12">
        <el-upload
          ref="uploadRef"
          class="avatar-uploader"
          :show-file-list="false"
          :auto-upload="true"
          action="/api/upload"
          name="file"
          :headers="{ Authorization: tokenStore.token }"
          :on-success="uploadSuccess"
        >
          <img v-if="imgUrl" :src="imgUrl" class="avatar" />
          <img v-else :src="defaultAvatar" class="avatar" />
        </el-upload>

        <br />

        <el-button
          type="primary"
          :icon="Plus"
          size="large"
          @click="uploadRef.$el.querySelector('input').click()"
        >
          选择图片
        </el-button>
        <el-button type="success" :icon="Upload" size="large" @click="updateAvatar">
          上传头像
        </el-button>
      </el-col>
    </el-row>
  </el-card>
</template>

<style lang="scss" scoped>
.avatar-uploader {
  :deep() {
    .avatar {
      width: 278px;
      height: 278px;
      display: block;
      object-fit: cover;
    }

    .el-upload {
      border: 1px dashed var(--el-border-color);
      border-radius: 6px;
      cursor: pointer;
      position: relative;
      overflow: hidden;
      transition: var(--el-transition-duration-fast);
    }

    .el-upload:hover {
      border-color: var(--el-color-primary);
    }

    .el-icon.avatar-uploader-icon {
      font-size: 28px;
      color: #8c939d;
      width: 278px;
      height: 278px;
      text-align: center;
    }
  }
}
</style>
