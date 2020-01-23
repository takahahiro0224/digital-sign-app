<template>
  <div>
    <md-card>
      <md-card-header>
        <md-card-header-text>
          <div class="md-title">{{ bill.category_i18n }}</div>
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
          <span>{{ bill.price_format }}</span>
        </div>
        <div>
          <md-icon>schedule</md-icon>
          <span>{{ bill.payment_due_date }}</span>
        </div>
      </md-card-content>

      <md-card-content>
        <div>
          <md-chip class="md-primary" v-for="d in bill.debtor" :key="d">{{ d }}</md-chip>
        </div>
      </md-card-content>
    
      <md-card-actions md-alignment="left">
  
        <md-button class="md-accent" v-on:click="updatePaid" v-if="bill.paid == false">支払い済みにする</md-button>
        <md-button class="md-primary" v-else>支払い済み</md-button>
        <md-button v-on:click="mailConfirmDialog=true">メール送信</md-button>
      </md-card-actions>
    </md-card>

    <md-dialog-confirm
      :md-active.sync="mailConfirmDialog"
      md-title="請求メールの送信"
      md-content="請求メールを請求先のユーザーに送信してよろしいでしょうか?"
      md-confirm-text="Agree"
      md-cancel-text="Disagree"
      @md-confirm="sendMail" />

    <md-dialog-alert
      :md-active.sync="alertAfterMail"
      md-content="請求メールを送信しました。"
      md-confirm-text="OK" />
  </div>
</template>

<script>
import Vue from 'vue'
import axios from 'axios';
import VueMaterial from 'vue-material';
// import {MdDialogAlert, MdDialogConfirm} from 'vue-material/dist/components'
import 'vue-material/dist/vue-material.min.css';
import 'vue-material/dist/theme/default.css';

Vue.use(VueMaterial)

export default {
  data: function () {
    return {
      bill: {},
      mailConfirmDialog: false,
      alertAfterMail: false,
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
    },
    sendMail: function() {
      axios
        .post(`/api/users/${user.id}/bills/${this.bill.id}/send_mail`)
        .then(response => {
          this.$router.push({ name: 'BillDetailPage', params: { id: this.bill.id }});
        })
        this.alertAfterMail = true;
    }
  }
}
</script>

<style scoped>
</style>
