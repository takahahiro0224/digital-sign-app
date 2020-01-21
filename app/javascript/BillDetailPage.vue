<template>
  <dl>
    <dt>ID</dt>
    <dd>{{ bill.id }}</dd>
    <dt>タイトル</dt>
    <dd>{{ bill.title }}</dd>
    <dt>説明</dt>
    <dd>{{ bill.description }}</dd>
    <dt>金額</dt>
    <dd>{{ bill.price_cents }}</dd>
    <dt>支払われたか</dt>
    <dd>{{ bill.paid }}</dd>
    <div v-if="bill.paid == false">
      <md-button v-on:click="updatePaid" class="md-raised">支払い済みにする</md-button>
    </div>
  </dl>
  

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
      bill: {}
    }
  },
  mounted () {
    axios
      .get(`/api/users/${user.id}/bills/${this.$route.params.id}.json`)
      .then(response => (this.bill = response.data))
  },
  methods: {
    updatePaid: function() {
      this.bill.paid = true;
      axios
        .patch(`/api/users/${user.id}/bills/${this.bill.id}`, this.bill)
        .then(response => {
          this.$router.push({ name: 'BillDetailPage', params: { id: this.bill.id }});
        })
    }
  }
}
</script>

<style scoped>
</style>
