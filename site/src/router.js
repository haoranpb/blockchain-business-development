import { createRouter, createWebHistory } from 'vue-router'
import TheHome from '@/views/TheHome.vue'
import TheLanding from '@/views/TheLanding.vue'
import TheGov from '@/views/TheGov.vue'
import TheAuth from '@/views/TheAuth.vue'
import TheProfile from '@/views/TheProfile.vue'
import TheMarket from '@/views/TheMarket.vue'
import TheVoting from '@/views/TheVoting.vue'

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
      {
        path: '/auth',
        name: 'auth',
        component: TheAuth,
      },
      {
        path: '/profile',
        name: 'profile',
        component: TheProfile,
      },
      {
        path: '/market',
        name: 'market',
        component: TheMarket,
      },
      {
        path: '/vote',
        name: 'vote',
        component: TheVoting,
      },
    ],
  },
  { path: '/gov', component: TheGov },
]

export default createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})
