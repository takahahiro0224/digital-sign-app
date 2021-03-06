import Vue from 'vue/dist/vue.esm.js'
import VueRouter from 'vue-router'

import BillIndexPage from '../../BillIndexPage.vue'
import BillDetailPage from '../../BillDetailPage.vue'
import BillNewPage from '../../BillNewPage.vue'
import BillEditPage from '../../BillEditPage'



// ref. https://jp.vuejs.org/v2/guide/plugins.html#%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3%E3%81%AE%E4%BD%BF%E7%94%A8
Vue.use(VueRouter)

export default new VueRouter({
  mode: 'history',
  routes: [
    { path: '/',
      component: BillIndexPage  },
    { path: '/bills/:id(\\d+)',
      name: 'BillDetailPage',
      component: BillDetailPage },
    { path: '/bills/new',
      name: 'BillNewPage',
      component: BillNewPage },
    { path: '/bills/:id(\\d+)/edit',
      name: 'BillEditPage',
      component: BillEditPage }
  ],
})
