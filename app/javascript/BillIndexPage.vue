<template>
  <div id="app">
    <table>
      <tbody>
        <tr>
          <th>ID</th>
          <th>title</th>
          <th>description</th>
          <th>price_cents</th>
        </tr>
        <tr v-for="b in bills" :key="b.id">
          <td>{{ b.id }}</td>
          <td>{{ b.title }}</td>
          <td>{{ b.description }}</td>
          <td>{{ b.price_cents }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data: function () {
    return {
      bills: []
    }
  },
  mounted () {
    axios
      .get('/api/users/1/bills.json')
      .then(response => (this.bills = response.data))
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
