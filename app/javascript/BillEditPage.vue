<template>
  <bill-form-pane :errors="errors" :bill="bill" @submit="updateBill"></bill-form-pane>
</template>

<script>
import axios from 'axios';

import BillFormPane from 'BillFormPane.vue';

export default {
  components: {
    BillFormPane
  },
  data() {
    return {
      bill: {},
      errors: ''
    }
  },
  mounted () {
    axios
      .get(`/api/users/1/bills/${this.$route.params.id}.json`)
      .then(response => (this.bill = response.data))
  },
  methods: {
    updateBill: function() {
      axios
        .patch(`/api/users/1/bills/${this.bill.id}.json`, this.bill)
        .then(response => {
          this.$router.push({ name: 'BillDetailPage', params: { id: this.bill.id } });
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
