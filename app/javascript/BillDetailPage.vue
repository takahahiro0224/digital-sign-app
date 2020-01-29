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
          <div v-if="bill.payment_late">
            <md-icon>schedule</md-icon>
            <span class="late">{{ bill.payment_due_date }}</span>
          </div>
          <div v-else>
            <md-icon>schedule</md-icon>
            <span>{{ bill.payment_due_date }}</span>
          </div>
        </div>
      </md-card-content>

      <md-card-content>
        <div>
          <md-chip class="md-primary" v-for="friend in bill.friends" :key="friend.id">{{ friend.name }}</md-chip>
        </div>
      </md-card-content>
    
      <md-card-actions md-alignment="left">
          
  
        <md-button class="md-accent" v-on:click="updatePaid" v-if="bill.paid == false">支払い済みにする</md-button>
        
        
        <md-button class="md-primary" v-else>支払い済み</md-button>
        <div v-if="bill.friends.length > 1">
          <md-button v-on:click="selectMailUser=true">メール送信</md-button>
        </div>
        <div v-else>
          <md-button v-on:click="mailConfirmDialog=true">メール送信</md-button>
        </div>
      </md-card-actions>
    </md-card>

   

    <md-dialog :md-active.sync="mailConfirmDialog">
      <md-dialog-title>請求メールを請求先のユーザーに送信してもよろしいですか？</md-dialog-title>
      <md-dialog-actions>
        <md-button class="md-primary" @click="sendMail">Send Mail</md-button>
        <md-button class="md-primary" @click="mailConfirmDialog=false">Cancel</md-button>
      </md-dialog-actions>
    </md-dialog>

    <md-dialog :md-active.sync="selectMailUser" :md-click-outside-to-close=false>
      <md-dialog-title>請求メールを送信するユーザーを選択してください</md-dialog-title>
      <form class="md-layout" @submit="sendMail">
        <md-field>
          <label>送信先の選択</label>
          <md-select v-model="sendMailParams.friends" multiple>
            <md-option v-for="friend in bill.friends" v-bind:key="friend.id" v-bind:value="friend.name">{{ friend.name }}</md-option>
          </md-select>
        </md-field>

        <md-dialog-actions>
          <md-button class="md-primary" type="submit" @click="selectMailUser=false">Send Mail</md-button>
          <md-button class="md-primary" @click="selectMailUser=false">Cancel</md-button>
        </md-dialog-actions>
      </form>
    </md-dialog>



      <md-table>
      <md-table-toolbar>
        <h1 class="md-title">メール送信履歴</h1>
      </md-table-toolbar>

      <md-table v-if="sentMails.length > 0">
        <md-table-row  v-for="mail in sentMails" :key="mail.id">
          <md-table-cell>{{ mail.created_at.slice(0,16) }}</md-table-cell>
          <md-table-cell>{{ mail.friend_name }}さんに {{ actionType[mail.action_type] }}を送信しました。 </md-table-cell>
        </md-table-row>
      </md-table>
      <md-table v-else>
        <md-table-row>
          <md-table-cell></md-table-cell>
          <md-table-cell>メール送信履歴はまだありません。</md-table-cell>
        </md-table-row>
      </md-table>

    </md-table>
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
      bill: {
        friends: []
      },
      sentMails: [],
      mailConfirmDialog: false,
      selectMailUser: false,
      mailFriends: [],
      sendMailParams: {
        friends: []
      },
      actionType: {
        'notice': "請求メール",
        'remind': "請求リマインド（自動）",
        'alert': '請求アラート（自動）'
      }
    }
  },
  mounted () {
    axios
      .get(`/api/users/${user.id}/bills/${this.$route.params.id}.json`)
      .then(response => (this.bill = response.data))

    axios
        .get(`/api/users/${user.id}/bills/${this.$route.params.id}/sent_mails`)
        .then(response => (this.sentMails = response.data))
  },
  methods: {
    updatePaid: function() {
      this.bill.paid = true;
      axios
        .patch(`/api/users/${user.id}/bills/${this.bill.id}`, this.bill)
        .then(response => {
          this.$router.go({path: this.$router.currentRoute.path, force: true})
        })
    },
    sendMail: function() {
      if (this.sendMailParams.friends.length ==0) {
        this.sendMailParams.friends.push(this.bill.friends[0].id)
      }
      this.mailConfirmDialog=false;
    
      axios
        .post(`/api/users/${user.id}/bills/${this.bill.id}/send_mail`, this.sendMailParams)
        .then(response => {
          this.$router.go({path: this.$router.currentRoute.path, force: true})
        })
    }
  }
}
</script>

<style scoped>
  .late {
    color: red;
  }
</style>
