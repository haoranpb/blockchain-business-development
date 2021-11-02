import { createRouter, createWebHistory } from 'vue-router'
import TheHome from '@/views/TheHome.vue'
import TheLanding from '@/components/TheLanding.vue'
import TheGov from '@/views/TheGov.vue'

const routes = [
  {
    path: '/',
    component: TheHome,
    children: [
      {
        path: '/',
        name: 'landing',
        component: TheLanding,
      },
    ],
  },
  { path: '/gov', component: TheGov },
]

export default createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})
