<template>
<div>
  <md-card>
    <md-card-header>
      <md-card-header-text>
         <div class="md-title">{{ friend.name }}</div>
         <div class="md-subhead">{{ friend.email }}</div>
      </md-card-header-text>

      <md-menu md-size="big" md-direction="bottom-end">
        <md-button class="md-icon-button" md-menu-trigger>
          <md-icon>more_vert</md-icon>
        </md-button>

        <md-menu-content>
          <md-menu-item @click="friendEditView=true">
            <span>編集/Edit</span>
            <md-icon>create</md-icon>
          </md-menu-item>
        </md-menu-content>
      </md-menu>

      <md-dialog :md-active.sync="friendEditView" :md-click-outside-to-close=false>
        <md-dialog-title>友達情報の編集</md-dialog-title>
        <md-card>
          <form class="md-layout" @submit="updateFriend">
            <md-field>
              <label>名前</label>
              <md-input v-model="friendEditParams.name" type="text"></md-input>

            </md-field>

            <md-field>
              <label>メールアドレス</label>
              <md-input v-model="friendEditParams.email" type="email" autocomplete="email"></md-input>
            </md-field>

            <md-field>
              <label>メモ</label>
              <md-textarea v-model="friendEditParams.description" ></md-textarea>
            </md-field>
            <md-dialog-actions>
            <md-button class="md-primary" type="submit">Save</md-button>
            <md-button class="md-primary" @click="friendEditView=false">Cancel</md-button>
         </md-dialog-actions>
          </form>
        </md-card>

      </md-dialog>



    </md-card-header>
       <md-card-content>
         {{ friend.description }}
       </md-card-content>
       <md-card-content>
         <div>

         <md-content class="statical">
           <div>
           <p class="num">{{ friend.charge_cnt }}</p>
           <p>貸したかず</p>
           </div>
         </md-content>
  
         <md-content class="statical">
           <div>
              <p class="num">{{ friend.charge_paid_cnt }}</p>
              <p>払われたかず</p>
            </div>
          
         </md-content>
         <md-content class="statical">
          　<div>
              <p class="num" v-if="friend.paid_in_time_rate">{{ friend.paid_in_time_rate }}%</p>
              <p class="num" v-else>-</p>
              <p>期限内支払い率</p>
            </div>
         </md-content>
         <md-content class="statical">
           <div>
              <p class="num">{{ friend.credit_score }}</p>
              <p>信用スコア</p>
            </div>
          
         </md-content>
         </div>
       </md-card-content>
    

  </md-card>
  <md-table>
    <md-table-toolbar>
        <h4 class="md-title">メール送信に対するリアクション</h4>
    </md-table-toolbar>

    <md-table v-if="friend.actions.length > 0">
      <md-table-row>
        <md-table-cell>請求</md-table-cell>
        <md-table-cell>Time</md-table-cell>
        <md-table-cell>Status</md-table-cell>
        <md-table-cell>Comment</md-table-cell>
        <md-table-cell>Negative or Positive</md-table-cell>
        <md-table-cell>Comment Emotion</md-table-cell>
      </md-table-row>
      <md-table-row v-for="action in friend.actions" :key="action.id">
        <md-table-cell>
          <md-button>
           <router-link :to="{ name: 'BillDetailPage', params: { id: action.bill_id } }">
            <md-icon>launch</md-icon>
           </router-link>
         </md-button>  
        </md-table-cell>
        <md-table-cell>{{ action.created_at.slice(0,16) }}</md-table-cell>
        <md-table-cell>{{ paymentAbility[action.payment_ability] }}</md-table-cell>
        <md-table-cell>{{ action.comment }}</md-table-cell>
        <md-table-cell>{{ action.comment_score }}</md-table-cell>
        <md-table-cell>{{ action.comment_magnitude }}</md-table-cell>
      </md-table-row>
    </md-table>

    <md-table v-else>
      <md-table-row>
        <md-table-cell></md-table-cell>
        <md-table-cell>リアクションはまだありません。</md-table-cell>
      </md-table-row>    
    </md-table>
  </md-table>
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
      friend: {
        actions: []
      },
      friendEditView: false,
      friendEditParams: {
        name: '',
        email: '',
        description: ''
      },
      paymentAbility: {
        'fine': '大丈夫',
        'late': '遅れそう',
        'unknown': 'わからない'
      }
    }
  },
  mounted () {
    this.getFriend();
  },
  methods: {
    getFriend: function() {
      axios
        .get(`/api/users/${user.id}/friends/${this.$route.params.id}.json`)
        .then(response => {
          this.friend = response.data;
          this.friendEditParams.name = response.data.name;
          this.friendEditParams.email = response.data.email;
          this.friendEditParams.description = response.data.description;

        })
    },
    updateFriend: function() {
      this.friendEditView = false;
      axios
        .patch(`/api/users/${user.id}/friends/${this.friend.id}`, this.friendEditParams)
        .then(response => {
          this.$router.go({path: this.$router.currentRoute.path, force: true})
        })

    }
  }
}
</script>

<style lang="scss" scoped>
  .md-card {
    //max-width: 1000px;
    margin: 4px;
  }
  .statical {
    width: 150px;
    height: 100px;
    display: inline-flex;
    justify-content: center;
    align-items: center;
  }
  .num {
    text-align: center;
    font-weight: bold;
  }
  
  
</style>

