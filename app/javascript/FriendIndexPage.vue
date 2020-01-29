<template>
<div>
    <md-list class="md-triple-line">
      <md-list-item v-for="f in friends" :key="f.id">
    
        <md-icon>account_circle</md-icon>

        <div class="md-list-item-text">
          <span>{{ f.name }}</span>
          <span>{{ f.email }}</span>
        </div>

        <md-button class="md-icon-button md-list-action">
          <md-icon class="md-primary">star</md-icon>
        </md-button>
      </md-list-item>

      <md-divider class="md-inset"></md-divider>

      
    </md-list>
  </div>
    
</template>

<script>
import Vue from 'vue'
import axios from 'axios';
import VueMaterial from 'vue-material';
import 'vue-material/dist/vue-material.min.css';
import 'vue-material/dist/theme/default.css';

Vue.use(VueMaterial)
export default {
  data: function () {
    return {
      friends: []
    }
  },
  mounted () {
    this.updateFriends();
  },
  methods: {
    updateFriends: function() {
      axios
        .get(`/api/users/${user.id}/friends.json`)
        .then(response => (this.friends = response.data))
    }
  }
}
</script>

<style lang="scss" scoped>
  .md-list {
    width: 400px;
    max-width: 100%;
    display: inline-block;
    vertical-align: top;
    border: 1px solid rgba(#000, .12);
  }
</style>
