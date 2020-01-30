<template>
  <div>
    <md-card>
      <md-card-header>
        <md-card-header-text>
          <div>
            <div class="md-title title-content">{{ bill.category_i18n }}</div>&nbsp;&nbsp;
        
            <div class="title-content" v-if="bill.paid">
                <b>支払い済み</b>
            </div>
            <div v-else class="title-content">
              <b class=late>支払い未完了</b>
            </div>
            <div v-if="bill.paid==false" class="title-content">
              &nbsp;&nbsp;<b>自動メール{{ autoMailSelect[bill.auto_mail] }}</b>
            </div>
          </div>
        </md-card-header-text>

        <md-menu md-size="big" md-direction="bottom-end">
          <md-button class="md-icon-button" md-menu-trigger>
            <md-icon>more_vert</md-icon>
          </md-button>
          <md-menu-content>
            <md-menu-item @click="selectMailUser=true">
              <span>メール送信</span>
              <md-icon>mail</md-icon>
            </md-menu-item>

            <md-menu-item @click="setAutoMailView=true">
              <span>自動メール設定</span>
              <md-icon>settings</md-icon>
            </md-menu-item>
             
            <md-menu-item >
              <span>編集/Edit</span>
              <md-icon>create</md-icon>
            </md-menu-item>

          </md-menu-content>
        </md-menu>
      </md-card-header>

      <md-card-content style="white-space:pre-wrap; word-wrap:break-word;">
        {{ bill.description }}
      </md-card-content>
      
      <md-card-content>
        <div>
          <md-content class="statical">
            <div>
              <p class="category"> 金額 </p>
              <div>
                <span>{{ bill.price_format }}</span>
              </div>
            </div>
           </md-content>

           <md-content class="statical">
            <div>
              <p class="category">作成日</p>
              <span>{{ bill.created_at.slice(0,10) }}</span>
            </div>
          </md-content>

           <md-content class="statical"> 
            <div>
              <p class="category"> 支払い期限 </p>
              <div v-if="bill.payment_late && bill.paid == false">
                <md-icon>schedule</md-icon>
                <span class="late">{{ bill.payment_due_date }}</span>
              </div>
              <div v-else>
                <md-icon>schedule</md-icon>
                <span>{{ bill.payment_due_date }}</span>
              </div>
            </div>
          </md-content>

          <md-content class="statical">
            <div>
              <p class="category">請求先</p>
              <div>
                <md-chip md-clickable @click="selectedFriend=friend; managePaidView=true" class="md-accent" v-for="friend in bill.friends.filter(friend=> friend.paid==false)" :key="friend.charge_id">
         {{ friend.name }}
       </md-chip>
       <md-chip class="md-primary" v-for="friend in bill.friends.filter(friend=> friend.paid==true)" :key="friend.charge_id">
         {{ friend.name }}
        </md-chip>
              </div>
            </div>
          </md-content>
          
        </div>
      </md-card-content>
     
    </md-card>

    <md-dialog :md-active.sync="selectMailUser" :md-click-outside-to-close=false>
      <md-dialog-title>請求メールを送信するユーザーを選んでください</md-dialog-title>
      <form class="md-layout" @submit="sendMail">
        <md-field>
          <label>送信先の選択</label>
          <md-select v-model="sendMailParams.charges" multiple>
            <md-option v-for="friend in bill.friends.filter(friend=> friend.paid==false)" v-bind:key="friend.charge_id" v-bind:value="friend.charge_id">{{ friend.name }}</md-option>
          </md-select>
        </md-field>

        <md-dialog-actions>
          <md-button class="md-primary" type="submit" @click="selectMailUser=false">Send Mail</md-button>
          <md-button class="md-primary" @click="selectMailUser=false">Cancel</md-button>
        </md-dialog-actions>
      </form>
    </md-dialog>

    <md-dialog :md-active.sync="setAutoMailView" :md-click-outside-to-close=false>
      <md-dialog-title>自動メールの設定</md-dialog-title>

      <div class="dialog-message">
        <md-switch v-model="billEditParams.auto_mail">{{ autoMailSelect[bill.auto_mail] }}</md-switch>
      </div>
      <div class= "dialog-message">
        <p>ONにすると請求書に紐づけられた友人に返済のリマインドメール・アラートメールを自動で送信します。
        送信のタイミングはリマインドは返済日の１日前、アラートは返済期限が過ぎてから3日ごとに送られます。</p> 
      </div>

      <md-dialog-actions>
        <md-button class="md-primary" @click="updateBill">Save</md-button>
        <md-button class="md-primary" @click=" setAutoMailView= false">Cancel</md-button>
      </md-dialog-actions>

    </md-dialog>

    <md-dialog :md-active.sync="managePaidView" :md-click-outside-to-close=false>
      <md-dialog-title>{{ selectedFriend.name }}さんを支払い完了にしますか？</md-dialog-title>
        <md-dialog-actions>
          <md-button class="md-primary" @click="updatePaid">Yes</md-button>
          <md-button class="md-primary" @click="managePaidView=false">No</md-button>
        </md-dialog-actions>
    </md-dialog>



      <md-table>
      <md-table-toolbar>
        <h1 class="md-title">メール送信履歴</h1>
      </md-table-toolbar>

      <md-table v-if="sentMails.length > 0">
        <md-table-row  v-for="mail in sentMails" :key="mail.id">
          <md-table-cell>{{ mail.sent_at}}</md-table-cell>
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
        created_at: '',
        auto_mail: false,
        friends: []
      },
      billEditParams: {
        description: '',
        payment_due_date: '',
        auto_mail: '',
      },
      autoMailSelect: {
        true: 'ON',
        false: 'OFF'
      },
      sentMails: [],
      selectMailUser: false,
      setAutoMailView: false,
      managePaidView: false,
      selectedFriend: false,
      mailFriends: [],
      sendMailParams: {
        charges: []
      },
      updatePaidParams: {
        charge: ''
      },
      actionType: {
        'notice': "請求メール",
        'remind': "請求リマインド（自動）",
        'alert': '請求アラート（自動）'
      }
    }
  },
  mounted () {
    this.getBill();
    this.getSentMails();
  },
  methods: {
    getBill: function() {
      axios
        .get(`/api/users/${user.id}/bills/${this.$route.params.id}.json`)
        .then(response => {
          this.bill = response.data;
          this.billEditParams.description = response.data.description;
          this.billEditParams.payment_due_date = response.data.payment_due_date;
          this.billEditParams.auto_mail = response.data.auto_mail;
        })
    },
    getSentMails: function() {
      axios
        .get(`/api/users/${user.id}/bills/${this.$route.params.id}/sent_mails`)
        .then(response => (this.sentMails = response.data))
    },
    updateBill: function() {
      this.setAutoMailView = false
      axios
        .patch(`/api/users/${user.id}/bills/${this.$route.params.id}`, this.billEditParams)
        .then(response => {
          this.$router.go({path: this.$router.currentRoute.path, force: true})
        })
    },
    sendMail: function() {
      if (this.sendMailParams.charges.length ==0) {
        this.sendMailParams.charges.push(this.bill.friends[0].charge_id)
      }
      this.mailConfirmDialog=false;
    
      axios
        .post(`/api/users/${user.id}/bills/${this.bill.id}/send_mail`, this.sendMailParams)
        .then(response => {
          this.$router.go({path: this.$router.currentRoute.path, force: true})
        })
    },
    updatePaid: function() {
      this.managePaidView=false;
      this.updatePaidParams.charge = this.selectedFriend.charge_id
      axios
        .post(`/api/users/${user.id}/bills/${this.bill.id}/update_paid`, this.updatePaidParams)
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
  
  .title-content {
    display: inline-flex;
  }
 
  .statical {
    width: 150px;
    height: 100px;
    display: inline-flex;
    justify-content: center;
    align-items: center;
  }
  .category {
    text-align: center;
  }
  .dialog-message {
    margin: 10px;
  }
</style>
