import { createRouter, createWebHistory } from 'vue-router'
import AddonView from '../views/AddonView.vue'
import { useSearchbarStore } from '@/stores/searchbar.ts'

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            name: 'home',
            component: AddonView,
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

router.beforeEach(() => {
    const searchbarStore = useSearchbarStore()
    searchbarStore.reset()
})

export default router
