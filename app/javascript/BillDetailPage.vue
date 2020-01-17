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
  </dl>
</template>

<script>
import axios from 'axios';

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
  }
}
</script>

<style scoped>
</style>
