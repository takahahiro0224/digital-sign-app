<template>
<div>
     <h5>Friends</h5>
      <md-card v-for="f in friends" :key= "f.id"> 
      <md-card-header>
        <md-card-header-text>
          <div class="md-title">{{ f.name }}</div>
          <div class="md-subhead">{{ f.email }}</div>
        </md-card-header-text>

        <md-card-media>
          <h4>{{ f.credit_score }}</h4>
        </md-card-media>
      </md-card-header>

      <md-card-actions>
        <router-link :to="{ name: 'FriendDetailPage', params: {id: f.id} }">
        <md-button>詳細</md-button>
        </router-link>
      </md-card-actions>
    </md-card>
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
  .md-card {
    width: 320px;
    margin: 4px;
    display: inline-block;
    vertical-align: top;
  }
</style>