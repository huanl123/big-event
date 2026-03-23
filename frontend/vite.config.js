import { fileURLToPath, URL } from 'node:url'
import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => {
  // Load repo-root .env files (../.env.local) so backend/frontend share the same config.
  const repoRoot = fileURLToPath(new URL('..', import.meta.url))
  const env = loadEnv(mode, repoRoot, '')

  const serverPort = process.env.SERVER_PORT || env.SERVER_PORT || 8081
  const backendTarget =
    process.env.BACKEND_URL || env.BACKEND_URL || `http://localhost:${serverPort}`

  return {
    plugins: [vue()],
    resolve: {
      alias: {
        '@': fileURLToPath(new URL('./src', import.meta.url)),
      },
    },
    server: {
      proxy: {
        '/api': {
          target: backendTarget,
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/api/, ''),
        },
      },
    },
  }
})
