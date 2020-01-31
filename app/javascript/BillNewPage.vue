<template>
  <div>
    <form novalidate class="md-layout" @submit.prevent="createBill">
      <md-card class="md-layout-item md-size-50 md-small-size-100">
        <md-card-header>
          <div class="md-title">請求メモ作成（Create a bill）</div>
        </md-card-header>

        <md-card-content>
          <md-field v-if="optionFriends.length > 0">
            <label>貸した人（登録済みの友達）Debtor</label>
            <md-select v-model="params.friends" multiple>
              <md-option v-for="friend in optionFriends" v-bind:key="friend.id" v-bind:value="friend.id">{{ friend.name }}</md-option>
            </md-select>
          </md-field>

          <md-dialog :md-active.sync="showDialog">
            <md-dialog-title>友達の登録</md-dialog-title>
              <form novalidate class="md-layout" @submit="createFriend">
                <md-field>
                  <label>名前 (Name)</label>
                  <md-input v-model="newFriend.name" type="text"></md-input>
                </md-field>
                <md-field>
                  <label>メールアドレス (email)</label>
                  <md-input v-model="newFriend.email" type="email" autocomplete="email"></md-input>
                </md-field>
                <md-dialog-actions>
                  <md-button class="md-primary" type="submit" @click="showDialog = false">Save</md-button>
                  <md-button class="md-primary" @click="showDialog = false">Cancel</md-button>
                </md-dialog-actions>
              </form>
            </md-dialog>

          <md-button class="md-primary" @click="showDialog = true">ともだちを登録する (Add New Friend)</md-button>
          
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

          <md-button class="md-primary" @click="textDetectView=true">
            <md-icon>add_a_photo</md-icon>&nbsp;&nbsp;画像からテキストを読み込む (Image Recognition)
          </md-button>
      

          <md-dialog :md-active.sync="textDetectView" :md-click-outside-to-close=false>
            <md-dialog-title>画像からテキストを読み込む</md-dialog-title>
              <form novalidate class="md-layout" @submit="textDetect">
                <md-field>
                  <label>画像を選択 select Image</label>
                  <md-file accept="image/*" @change="attachImg" />
                </md-field>

                <md-dialog-actions>
                  <md-button v-show="uploadedImage" class="md-primary" type="submit" @click="textDetectView=false; spinner=true;">To TEXT</md-button>
                  <md-button class="md-primary" @click="textDetectView = false; removeImage;">Cancel</md-button>
                </md-dialog-actions>

                 <md-card v-show="uploadedImage">
                  <md-card-header>
                  </md-card-header>
                  
                  <md-card-content>
                  <md-card-media>
                    <img
                      :src="uploadedImage"
                      alt=""
                     />
                  </md-card-media>
                  </md-card-content>
                </md-card>
               
              </form>
            </md-dialog>

            <md-dialog :md-active.sync="imageRecognitionError">
              <md-dialog-title>問題が発生しました。再度お試しください。</md-dialog-title>
              <md-dialog-actions>
                <md-button @click="imageRecognitionError=false;">OK</md-button>
              </md-dialog-actions>
            </md-dialog>

            <md-progress-spinner v-show="spinner" :md-diameter="100" :md-stroke="10" md-mode="indeterminate"></md-progress-spinner>

            <md-dialog :md-active.sync="textDetectResultView" :md-click-outside-to-close=false>
              <md-dialog-title>テキスト結果 (Result)</md-dialog-title>
    
                <md-content class="md-scrollbar" style="white-space:pre-wrap; word-wrap:break-word;">
                  {{ textDetectResult.text }}
                </md-content>

                <md-dialog-actions>
                <md-button @click="textCopy">COPY!</md-button>
                <md-button @click="textDetectResultView=false; uploadedImage=false;">Close</md-button>
              </md-dialog-actions>
            </md-dialog>

          <md-field>
            <label>通貨　(Currency)</label>
              <md-select v-model="params.bill.currency">
              <md-option v-for="c in currency" v-bind:key="c" v-bind:value="c">{{ c }}</md-option>
            </md-select>
          </md-field>

          <md-field>
            <label>一人当たりの金額 (Price per person)</label>
            <md-input v-model="params.bill.price_cents" type="number"></md-input>
          </md-field>
          

          <md-datepicker v-model="params.bill.payment_due_date">
            <label>支払い期限日 (Payment due Date)</label>
          </md-datepicker>
        </md-card-content>


        <md-card-actions>
          <md-button type="submit" class="md-primary md-raised">Create!</md-button>
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
import clipboard from 'clipboard-copy';
import loadImage from 'blueimp-load-image';

Vue.use(VueMaterial)
let now = new Date()
export default {
  data () {
    return {
      params: {
        bill: {
          price_cents: '',
          currency: 'JPY',
          payment_due_date: now
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
      textDetectView: false,
      image_params: {
        image_base64: ""
      },
      uploadedImage: '',
      textDetectResultView: false,
      textDetectResult: '',
      imageRecognitionError: false,
      spinner: false,
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
        .then(response => {
          this.optionFriends.push(response.data);
          this.newFriend.name = '';
          this.newFriend.email = '';
        })
    },
    textDetect: function() {
      axios
        .post(`/api/analyze/text_detect`, this.image_params)
        .then(response => {
          if (response.data.message == "error") {
            this.spinner = false;
            this.imageRecognitionError = true;
          } else {
          this.textDetectResult = response.data;
          this.spinner = false;
          this.textDetectResultView = true;
          }
        })
    },
    attachImg(e) {
      const file = e.target.files[0];

      loadImage.parseMetaData(file, (data) => {
        const options = {
          maxHeight: 300,
          maxHeight: 300,
          canvas: true
        };
        if (data.exif) {
          options.orientation = data.exif.get('Orientation');
        }
        this.displayImage(file, options);
      });
    },
    displayImage(file, options) {
      loadImage(
        file,
        async (canvas) => {
          const data = canvas.toDataURL(file.type);
          this.image_params.image_base64 = data;
          // data_url形式をblob objectに変換
          const blob = this.base64ToBlob(data, file.type);
          // objectのURLを生成
          const url = window.URL.createObjectURL(blob);

          this.uploadedImage = url; // resizedImgはdataで定義
        },
        options
      );
    },
    base64ToBlob(base64, fileType) {
      const bin = atob(base64.replace(/^.*,/, ''));
      const buffer = new Uint8Array(bin.length);
      for (let i = 0; i < bin.length; i++) {
        buffer[i] = bin.charCodeAt(i);
      }
      return new Blob([buffer.buffer], {
        type: fileType ? fileType : 'image/png'
      });
    },
    removeImage() {
      this.uploadedImage = false
    },
    textCopy() {
      clipboard(this.textDetectResult.text);
    }
  }
}
</script>

<style lang="scss" scoped>
  .md-scrollbar {
    overflow: auto;
  }
</style>
