<template>
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
      friend: {}
    }
  },
  mounted () {
    this.getFriend();
  },
  methods: {
    getFriend: function() {
      axios
        .get(`/api/users/${user.id}/friends/${this.$route.params.id}.json`)
        .then(response => (this.friend = response.data))
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
