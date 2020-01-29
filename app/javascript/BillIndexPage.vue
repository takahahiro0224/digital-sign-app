<template>
   <div class="card-expansion">
    <md-card v-for="b in bills" :key="b.id">
       <md-card-header>
         <div class="md-title">{{ categories[b.category ]}}</div>
         <div v-if="b.paid">
          <div class= "md-subhead">支払い済み</div>
         </div>
       </md-card-header>
       <md-card-content>
         <div>
           <md-chip class="md-primary" v-for="friend in b.friends" :key="friend">{{ friend }}</md-chip>
         </div>
       </md-card-content>
       <md-card-content>
         <div>
           <md-icon>money</md-icon>
           <span>{{ b.price_format }}</span>
         </div>
         <div>
          <div v-if="b.payment_late">
            <md-icon>schedule</md-icon>
            <span class="late">{{ b.payment_due_date }}</span>
          </div>
          <div v-else>
            <md-icon>schedule</md-icon>
            <span>{{ b.payment_due_date }}</span>
          </div>
         </div>
       </md-card-content>
       <md-card-actions>
         <md-button class="md-icon-button" @click="deleteTarget = b.id; showModal = true">
           <router-link :to="{ name: 'BillDetailPage', params: { id: b.id } }">
           <md-icon>launch</md-icon>
           </router-link>
         </md-button>
         <md-button class="md-icon-button" @click="deleteTarget = b.id; showModal = true">
           <md-icon>delete</md-icon>
         </md-button>
       </md-card-actions>
    </md-card>

    <md-dialog-confirm
      :md-active.sync="showModal"
      md-title="この請求メモを削除しますか？"
      md-confirm-text="OK"
      md-cancel-text="Cancel"
      @md-cancel="showModal = false"
      @md-confirm="deleteBill(); showModal = false;" />    
    
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
.late {
  color: red;
}

</style>
