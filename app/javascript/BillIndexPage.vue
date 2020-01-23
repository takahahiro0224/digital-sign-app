<template>
  <div>
    <md-table md-card>
      <md-table-toolbar>
        <h1 class="md-title">請求一覧</h1>
      </md-table-toolbar>
      <md-table-row>
        <md-table-head>カテゴリ</md-table-head>
        <md-table-head>金額</md-table-head>
        <md-table-head>貸した人・請求する人</md-table-head>
        <md-table-head>支払い期限日</md-table-head>
      </md-table-row>
      <md-table-row v-for="b in bills" :key="b.id">
        <md-table-cell><router-link :to="{ name: 'BillDetailPage', params: { id: b.id } }">{{ categories[b.category] }}</router-link></md-table-cell>
        <md-table-cell>{{ b.price_cents }}</md-table-cell>
        <md-table-cell>{{ b.debtor }}</md-table-cell>
        <md-table-cell>{{ b.payment_due_date }}</md-table-cell>
        <md-table-cell>
          <button @click="deleteTarget = b.id; showModal = true">削除</button>
        </md-table-cell>
      </md-table-row>
    </md-table>    
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
      errors: '',
      categories: {
        'foods': '食事',
        'shopping': '買い物',
        'entertainment': 'エンタメ',
        'debt': '借金',
        'charge': '請求',
        'others': 'その他'
      }
      
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
