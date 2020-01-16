<template>
  <div id="app">
    <table>
      <tbody>
        <tr>
          <th>ID</th>
          <th>タイトル</th>
          <th>金額</th>
        </tr>
        <tr v-for="b in bills" :key="b.id">
          <td><router-link :to="{ name: 'BillDetailPage', params: { id: b.id } }">{{ b.id }}</router-link></td>
          <td>{{ b.title }}</td>
          <td>{{ b.price_cents }}</td>
          <td>
            <button @click="deleteTarget = b.id; showModal = true">削除</button>
          </td>
        </tr>
      </tbody>
    </table>
    <modal v-if="showModal" @cancel="showModal = false" @ok="deleteBill(); showModal = false;">
      <div slot="body">削除しますか?</div>
    </modal>
  </div>
</template>

<script>
import axios from 'axios';

import Modal from 'Modal.vue';

export default {
  components: {
    Modal
  },
  data: function () {
    return {
      bills: [],
      showModal: false,
      deleteTarget: -1,
      errors: ''
    }
  },
  mounted () {
    this.updateBills();
  },
  methods: {
    deleteBill: function() {
      if (this.deleteTarget <= 0) {
        console.warn('deleteTarget should be grater than zero.');
        return;
      }

      axios
        .delete(`/api/users/${user.id}/bills/${this.deleteTarget}`)
        .then(response => {
          this.deleteTarget = -1;
          this.updateBills();
        })
        .catch(error => {
          console.error(error);
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        });
    },
    updateBills: function() {
      axios
        .get(`/api/users/${user.id}/bills.json`)
        .then(response => (this.bills = response.data))
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
