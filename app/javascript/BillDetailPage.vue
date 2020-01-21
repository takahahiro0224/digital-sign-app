<template>
  <div>
    <md-card>
      <md-card-header>
        <md-card-header-text>
          <div class="md-title">{{ bill.title }}</div>
          <div class="md-subhead">{{ bill.description }}</div>
        </md-card-header-text>

        <md-menu md-size="big" md-direction="bottom-end">
          <md-button class="md-icon-button" md-menu-trigger>
            <md-icon>more_vert</md-icon>
          </md-button>

          <md-menu-content>
            <md-menu-item >
              <span>Call</span>
              <md-icon>phone</md-icon>
            </md-menu-item>

            <md-menu-item>
              <span>Send a message</span>
              <md-icon>message</md-icon>
            </md-menu-item>
          </md-menu-content>
        </md-menu>
      </md-card-header>

      <md-card-content>
        <div>
          <md-icon>money</md-icon>
          <span>{{ bill.price_cents }}円</span>
        </div>
        <div>
          <md-icon>schedule</md-icon>
          <span>{{ bill.payment_due_date }}</span>
        </div>
      </md-card-content>

    
      <md-card-actions md-alignment="left">
  
        <md-button class="md-accent" v-on:click="updatePaid" v-if="bill.paid == false">支払い済みにする</md-button>
        <md-button class="md-primary" v-else>支払い済み</md-button>
        <md-button>メール送信</md-button>
      </md-card-actions>
    </md-card>
  </div>
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
