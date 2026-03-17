const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    proxy: {
      '/consumer/api': {
        target: 'http://localhost:8088',
        changeOrigin: true,
        pathRewrite: {}
      },
      '/consumer': {
        target: 'http://localhost:8088',
        changeOrigin: true,
        pathRewrite: {}
      },
      '/customer/api': {
        target: 'http://localhost:8088',
        changeOrigin: true,
        pathRewrite: {}
      }
    }
  }
})
