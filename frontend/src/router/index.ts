import { createRouter, createWebHistory } from 'vue-router'
import PluginView from '../views/PluginView.vue'

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            name: 'home',
            component: PluginView,
        },
        {
            path: '/browse',
            name: 'browse',
            // route level code-splitting
            // this generates a separate chunk (Browser.[hash].js) for this route
            // which is lazy-loaded when the route is visited.
            component: () => import('../views/BrowserView.vue'),
        },
    ],
})

export default router
