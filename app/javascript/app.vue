<template>
  <div>
    <div>
      <ul id="dropdown" class="dropdown-content">
        <li><a href="#">Top</a></li>
        <li><a href="#">About</a></li>
        <li><a href="#">Contact</a></li>
      </ul>
      <nav>
        <div class="nav-wrapper container">
          <a href="/" class="brand-logo left">Todo Application</a>
          <ul class="right hide-on-med-and-down">
            <li><a href="#">Top</a></li>
            <li><a href="#">About</a></li>
            <li><a href="#">Contact</a></li>
          </ul>
          <ul class="right hide-on-large-only">
            <li>
              <a class="dropdown-button" href="#!" data-activates="dropdown">
                Menu<i class="material-icons right">arrow_drop_down</i>
              </a>
            </li>
          </ul>
        </div>
      </nav>
    </div>
    <router-view></router-view>
  </div>
</template>

<script>
import Vue from 'vue'
import VueRouter from 'vue-router'
import BillIndexPage from 'BillIndexPage.vue'
import BillDetailPage from 'BillDetailPage.vue'
import BillNewPage from 'BillNewPage.vue'
import BillEditPage from 'BillEditPage'

const router = new VueRouter({
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
  ]
})


// ref. https://jp.vuejs.org/v2/guide/plugins.html#%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3%E3%81%AE%E4%BD%BF%E7%94%A8
Vue.use(VueRouter)

export default {
  router
}
</script>

<style scoped>
</style>
