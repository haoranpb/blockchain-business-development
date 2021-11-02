import { createRouter, createWebHistory } from 'vue-router'
import Home from '@/views/HomePage.vue'

const routes = [{ path: '/', component: Home }]

export default createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
})
