<template>
  <bill-form-pane :errors="errors" :bill="bill" @submit="createBill"></bill-form-pane>
</template>

<script>
import axios from 'axios';

import BillFormPane from 'BillFormPane.vue';

export default {
  components: {
    BillFormPane
  },
  data () {
    return {
      bill: {
        title: '',
        description: '',
        price_cents: '',
      },
      errors: ''
    }
  },
  methods: {
    createBill: function() {
      axios
        .post(`/api/users/${user.id}/bills`, this.bill)
        .then(response => {
          let b = response.data;
          this.$router.push({ name: 'BillDetailPage', params: { id: b.id } });
        })
        .catch(error => {
          console.error(error);
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        });
    }
  }
}
</script>

<style scoped>
</style>
