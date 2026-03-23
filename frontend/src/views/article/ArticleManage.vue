<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { Delete, Edit, Plus } from '@element-plus/icons-vue'
import { QuillEditor } from '@vueup/vue-quill'
import '@vueup/vue-quill/dist/vue-quill.snow.css'

import {
  articleAddService,
  articleCategoryListService,
  articleListService,
} from '@/api/article'
import { useTokenStore } from '@/stores/token'

const tokenStore = useTokenStore()

const categorys = ref([])
const categoryId = ref('')
const state = ref('')
const articles = ref([])
const pageNum = ref(1)
const total = ref(0)
const pageSize = ref(3)
const visibleDrawer = ref(false)

const articleModel = ref({
  title: '',
  categoryId: '',
  coverImg: '',
  content: '',
  state: '',
})

const resetArticleModel = () => {
  articleModel.value = {
    title: '',
    categoryId: '',
    coverImg: '',
    content: '',
    state: '',
  }
}

const articleCategoryList = async () => {
  try {
    const result = await articleCategoryListService()
    categorys.value = result.data || []
  } catch (_) {
  }
}

const articleList = async () => {
  try {
    const params = {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      categoryId: categoryId.value || null,
      state: state.value || null,
    }

    const result = await articleListService(params)
    total.value = result.data?.total || 0
    articles.value = result.data?.items || []

    for (const article of articles.value) {
      const currentCategory = categorys.value.find((item) => item.id === article.categoryId)
      article.categoryName = currentCategory?.categoryName || ''
    }
  } catch (_) {
  }
}

const initPage = async () => {
  await articleCategoryList()
  await articleList()
}

initPage()

const onSizeChange = (size) => {
  pageSize.value = size
  articleList()
}

const onCurrentChange = (num) => {
  pageNum.value = num
  articleList()
}

const resetFilters = () => {
  categoryId.value = ''
  state.value = ''
  articleList()
}

const uploadSuccess = (result) => {
  articleModel.value.coverImg = result.data
  ElMessage.success(result.msg || '封面上传成功')
}

const uploadError = (error) => {
  const message =
    error?.response?.data?.msg ||
    error?.response?.data?.message ||
    '封面上传失败，请检查 OSS 配置'
  ElMessage.error(message)
}

const openDrawer = () => {
  resetArticleModel()
  visibleDrawer.value = true
}

const addArticle = async (clickState) => {
  if (!articleModel.value.title.trim()) {
    ElMessage.error('请输入文章标题')
    return
  }

  if (!articleModel.value.categoryId) {
    ElMessage.error('请选择文章分类')
    return
  }

  if (!articleModel.value.coverImg) {
    ElMessage.error('请先上传文章封面')
    return
  }

  if (!articleModel.value.content || !articleModel.value.content.trim()) {
    ElMessage.error('请输入文章内容')
    return
  }

  articleModel.value.state = clickState

  try {
    const result = await articleAddService(articleModel.value)
    ElMessage.success(result.msg || '添加成功')
    visibleDrawer.value = false
    resetArticleModel()
    articleList()
  } catch (_) {
  }
}
</script>

<template>
  <el-card class="page-container">
    <template #header>
      <div class="header">
        <span>文章管理</span>
        <div class="extra">
          <el-button type="primary" @click="openDrawer">添加文章</el-button>
        </div>
      </div>
    </template>

    <el-form inline>
      <el-form-item label="文章分类">
        <el-select v-model="categoryId" placeholder="请选择">
          <el-option
            v-for="category in categorys"
            :key="category.id"
            :label="category.categoryName"
            :value="category.id"
          />
        </el-select>
      </el-form-item>

      <el-form-item label="发布状态">
        <el-select v-model="state" placeholder="请选择">
          <el-option label="已发布" value="已发布" />
          <el-option label="草稿" value="草稿" />
        </el-select>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="articleList">搜索</el-button>
        <el-button @click="resetFilters">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table :data="articles" style="width: 100%">
      <el-table-column label="文章标题" width="400" prop="title" />
      <el-table-column label="分类" prop="categoryName" />
      <el-table-column label="发表时间" prop="createTime" />
      <el-table-column label="状态" prop="state" />
      <el-table-column label="操作" width="100">
        <template #default>
          <el-button :icon="Edit" circle plain type="primary" />
          <el-button :icon="Delete" circle plain type="danger" />
        </template>
      </el-table-column>
      <template #empty>
        <el-empty description="没有数据" />
      </template>
    </el-table>

    <el-pagination
      v-model:current-page="pageNum"
      v-model:page-size="pageSize"
      :page-sizes="[3, 5, 10, 15]"
      layout="jumper, total, sizes, prev, pager, next"
      background
      :total="total"
      style="margin-top: 20px; justify-content: flex-end"
      @size-change="onSizeChange"
      @current-change="onCurrentChange"
    />

    <el-drawer v-model="visibleDrawer" title="添加文章" direction="rtl" size="50%">
      <el-form :model="articleModel" label-width="100px">
        <el-form-item label="文章标题">
          <el-input v-model="articleModel.title" placeholder="请输入标题" />
        </el-form-item>

        <el-form-item label="文章分类">
          <el-select v-model="articleModel.categoryId" placeholder="请选择">
            <el-option
              v-for="category in categorys"
              :key="category.id"
              :label="category.categoryName"
              :value="category.id"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="文章封面">
          <el-upload
            class="avatar-uploader"
            :auto-upload="true"
            :show-file-list="false"
            action="/api/upload"
            name="file"
            :headers="{ Authorization: tokenStore.token }"
            :on-success="uploadSuccess"
            :on-error="uploadError"
          >
            <img v-if="articleModel.coverImg" :src="articleModel.coverImg" class="avatar" />
            <el-icon v-else class="avatar-uploader-icon">
              <Plus />
            </el-icon>
          </el-upload>
        </el-form-item>

        <el-form-item label="文章内容">
          <div class="editor">
            <QuillEditor v-model:content="articleModel.content" content-type="html" theme="snow" />
          </div>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="addArticle('已发布')">发布</el-button>
          <el-button type="info" @click="addArticle('草稿')">草稿</el-button>
        </el-form-item>
      </el-form>
    </el-drawer>
  </el-card>
</template>

<style lang="scss" scoped>
.page-container {
  min-height: 100%;
  box-sizing: border-box;

  .header {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
}

.avatar-uploader {
  :deep() {
    .avatar {
      width: 178px;
      height: 178px;
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
      width: 178px;
      height: 178px;
      text-align: center;
    }
  }
}

.editor {
  width: 100%;

  :deep(.ql-editor) {
    min-height: 200px;
  }
}
</style>
