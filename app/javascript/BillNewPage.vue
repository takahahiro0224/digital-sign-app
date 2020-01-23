<template>
  <div>
    <form novalidate class="md-layout" @submit.prevent="createBill">
      <md-card class="md-layout-item md-size-50 md-small-size-100">
        <md-card-header>
          <div class="md-title">請求メモ作成</div>
        </md-card-header>

        <md-card-content>
          <md-field v-if="optionFriends.length > 0">
            <label>貸した人（登録済みの友達）</label>
            <md-select v-model="params.friends" multiple>
              <md-option v-for="friend in optionFriends" v-bind:key="friend.id" v-bind:value="friend.id">{{ friend.name }}</md-option>
            </md-select>
          </md-field>

          <md-dialog :md-active.sync="showDialog">
            <md-dialog-title>友達の登録</md-dialog-title>
              <form novalidate class="md-layout" @submit="createFriend">
                <md-field>
                  <label>名前</label>
                  <md-input v-model="newFriend.name" type="text"></md-input>
                </md-field>
                <md-field>
                  <label>メールアドレス</label>
                  <md-input v-model="newFriend.email" type="email" autocomplete="email"></md-input>
                </md-field>
                <md-dialog-actions>
                  <md-button class="md-primary" type="submit" @click="showDialog = false">Save</md-button>
                  <md-button class="md-primary" @click="showDialog = false">Cancel</md-button>
                </md-dialog-actions>
              </form>
            </md-dialog>

          <md-button class="md-primary" @click="showDialog = true">ともだちを登録する</md-button>
          
          <md-field>
            <label>Category</label>
            <md-select v-model="params.bill.category">
              <md-option v-for="category in categories" v-bind:key="category.id" v-bind:value="category.id">{{ category.name }}</md-option>
            </md-select>
          </md-field>

          <md-field>
            <label>Description</label>
            <md-textarea v-model="params.bill.description"></md-textarea>
          </md-field>

      
          <md-field>
            <label>currency</label>
              <md-select v-model="params.bill.currency">
              <md-option v-for="c in currency" v-bind:key="c" v-bind:value="c">{{ c }}</md-option>
            </md-select>
          </md-field>

          <md-field>
            <label>price</label>
            <md-input v-model="params.bill.price_cents" type="number"></md-input>
          </md-field>
          

          <md-datepicker v-model="params.bill.payment_due_date">
            <label>支払い期限日</label>
          </md-datepicker>
        </md-card-content>


        <md-card-actions>
          <md-button type="submit" class="md-primary md-raised">請求メモを作成</md-button>
        </md-card-actions>
      </md-card>

    </form>
  </div>

</template>

<script>
import Vue from 'vue'
import axios from 'axios';
import 'vue-material/dist/vue-material.min.css'
import 'vue-material/dist/theme/default.css'
import VueMaterial from 'vue-material'

Vue.use(VueMaterial)
export default {
  data () {
    return {
      params: {
        bill: {
          price_cents: '',
          currency: 'JPY'
        },
        friends: []
      },
      optionFriends: [],
      categories: [
        { id: 0, name: "食事" },
        { id: 1, name: "買い物" },
        { id: 2, name: "エンタメ" },
        { id: 3, name: "借金" },
        { id: 4, name: "請求" },
        { id: 5, name: "その他" }
      ],
      currency: [
        'JPY',
        'USD',
        'EUR',
        'GBP',
        'CAD',
        'AUD',
        'NZD',
        'CNY',
        'KRW'
      ],
      showDialog: false,
      newFriend: {
        name: '',
        email: ''
      },
      errors: ''
    }
  },
  mounted () {
    this.updateFriends();
  },
  methods: {
    createBill: function() {
      axios
        .post(`/api/users/${user.id}/bills`, this.params)
        .then(response => {
          let b = response.data;
          this.$router.push({ name: 'BillDetailPage', params: { id: b.id } });
        })
        .catch(error => {
          console.error(error);
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        });
    },
    updateFriends: function() {
      axios
        .get(`/api/users/${user.id}/friends.json`)
        .then(response => (this.optionFriends = response.data))
    },
    createFriend: function() {
      axios
        .post(`/api/users/${user.id}/friends`, this.newFriend)
      this.updateFriends();
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
