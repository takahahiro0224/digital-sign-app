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
          <form class="md-layout">
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

         <md-content>
           <div>
           <p class="num">{{ friend.charge_cnt }}</p>
           <p>貸したかず</p>
           </div>
         </md-content>
  
         <md-content>
           <div>
              <p class="num">{{ friend.charge_paid_cnt }}</p>
              <p>払われたかず</p>
            </div>
          
         </md-content>
         <md-content>
          　<div>
              <p class="num" v-if="friend.paid_in_time_rate">{{ friend.paid_in_time_rate }}%</p>
              <p class="num" v-else>-</p>
              <p>期限内支払い率</p>
            </div>
         </md-content>
         <md-content>
           <div>
              <p class="num">{{ friend.credit_score }}</p>
              <p>信用スコア</p>
            </div>
          
         </md-content>
         </div>
       </md-card-content>
    

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
      friend: {},
      friendEditView: false,
      friendEditParams: {
        name: '',
        email: '',
        description: ''
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
    }
  }
}
</script>

<style lang="scss" scoped>
  .md-card {
    max-width: 1000px;
    margin: 4px;
  }
  .md-content {
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

