<template>
  <div class="page-container md-layout-column">
    <md-toolbar class="md-primary">
      <md-button class="md-icon-button" @click="showNavigation = true">
        <md-icon>menu</md-icon>
      </md-button>
      <span class="md-title">Money Collect ver.β</span>

      <div class="md-toolbar-section-end">
        <md-button @click="showSidepanel = true">Favorites</md-button>
      </div>
    </md-toolbar>

    <md-drawer :md-active.sync="showNavigation" md-swipeable>
      <md-toolbar class="md-transparent" md-elevation="0">
        <span class="md-title">Money Collect ver.β</span>
      </md-toolbar>

      <md-list>
        <md-list-item to="/">
          <md-icon>home</md-icon>
          <span class="md-list-item-text">一覧</span>
        </md-list-item>

        <md-list-item to="/bills/new">
          <md-icon>add</md-icon>
          <span class="md-list-item-text">新規作成</span>
        </md-list-item>

        <md-list-item to="/friends">
          <md-icon>account_box</md-icon>
          <span class="md-list-item-text">友人</span>
        </md-list-item>

        <md-list-item to="/contact">
          <md-icon>send</md-icon>
          <span class="md-list-item-text">Contact</span>
        </md-list-item>
       </md-list>

    </md-drawer>

    <md-drawer class="md-right" :md-active.sync="showSidepanel">
      <md-toolbar class="md-transparent" md-elevation="0">
        <span class="md-title">Favorites</span>
      </md-toolbar>

      <md-list>
        <md-list-item>
          <span class="md-list-item-text">Abbey Christansen</span>

          <md-button class="md-icon-button md-list-action">
            <md-icon class="md-primary">chat_bubble</md-icon>
          </md-button>
        </md-list-item>

        <md-list-item>
          <span class="md-list-item-text">Alex Nelson</span>

          <md-button class="md-icon-button md-list-action">
            <md-icon class="md-primary">chat_bubble</md-icon>
          </md-button>
        </md-list-item>

        <md-list-item>
          <span class="md-list-item-text">Mary Johnson</span>

          <md-button class="md-icon-button md-list-action">
            <md-icon>chat_bubble</md-icon>
          </md-button>
        </md-list-item>
      </md-list>
    </md-drawer>

    <md-content>
      <router-view></router-view>
    </md-content>
  </div>
</template>

<script>
import Vue from 'vue'
import VueRouter from 'vue-router'
import BillIndexPage from 'BillIndexPage.vue'
import BillDetailPage from 'BillDetailPage.vue'
import BillNewPage from 'BillNewPage.vue'
import BillEditPage from 'BillEditPage.vue'
import Contact from 'Contact.vue'
import Friends from 'FriendIndexPage.vue'

// vue-material
import 'vue-material/dist/vue-material.min.css'
import 'vue-material/dist/theme/default.css'
import VueMaterial from 'vue-material'

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
      component: BillEditPage },
    { path: '/contact',
      name: 'Contact',
      component: Contact },
    { path: '/friends',
      neme: 'Friends',
      component: Friends }
  ]
})

Vue.use(VueRouter)
Vue.use(VueMaterial)
export default {
   router,
   name: 'Temporary',
    data: () => ({
      showNavigation: false,
      showSidepanel: false
    })
}
</script>
<style lang="scss" scoped>
  .page-container {
    min-height: 800px;
    overflow: hidden;
    position: relative;
    border: 1px solid rgba(#000, .12);
  }

   // Demo purposes only
  .md-drawer {
    width: 230px;
    max-width: calc(100vw - 125px);
  }

  .md-content {
    padding: 16px;
  }
  .md-list-item-text {
    color: black;
  }
</style>
