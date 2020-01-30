<template>
   <div>
    <div v-if="bills.length > 0">
    <md-card v-for="b in bills" :key="b.id">
       <md-card-header>
         <div class="md-title">{{ categories[b.category]}}</div>
         <div v-if="b.paid">
              <b>支払い済み</b>
          </div>
          <div v-else>
            <b class=late>支払い未完了</b>
          </div>
       </md-card-header>
       <md-card-content> 
        <md-chip class="md-accent" v-for="friend in b.friends.filter(friend=> friend.paid==false)" :key="friend.charge_id">
          {{ friend.name }}
        </md-chip>
        <md-chip class="md-primary" v-for="friend in b.friends.filter(friend=> friend.paid==true)" :key="friend.charge_id">
          {{ friend.name }}
         </md-chip>
      </md-card-content>
       <md-card-content>
         <div>
           <md-icon>money</md-icon>
           <span>{{ b.price_format }}</span>
         </div>
         <div>
          <div v-if="b.payment_late && b.paid == false">
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
         <md-button>
           <router-link :to="{ name: 'BillDetailPage', params: { id: b.id } }">
           <md-icon>launch</md-icon>
           </router-link>
         </md-button>
         <md-button class="md-icon-button" @click="deleteTarget = b.id; showModal = true">
           <md-icon>delete</md-icon>
         </md-button>
       </md-card-actions>
    </md-card>
    </div>
    <div v-else>
    <md-empty-state id="no-show"
      md-icon="devices_other"
      md-label="最初の請求書を作りましょう"
      md-description="By creating your bill, you will be able to manage your  money and remind your friends by sending an e-mail">
      <md-button class="md-primary md-raised" to="/bills/new">Create first Bill</md-button>
    </md-empty-state>
    </div>
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
      emptyState: false,
      bills: [
      ],
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
      this.isEmptyState();
    },
    isEmptyState: function() {
      if (this.bills == "") {
        const sleep = msec => new Promise(resolve => setTimeout(resolve, msec));
        const no_show = document.getElementById("no-show");
        (async () => {
      
          await sleep(500);
          no_show.style.display ="block";

        })();
      }
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
[v-cloak] {
      display: none;
    }
#no-show {
  display: none;
}


</style>
