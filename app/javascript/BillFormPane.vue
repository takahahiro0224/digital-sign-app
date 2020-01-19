<template>
  <form @submit.prevent="$emit('submit')">
    <div v-if="errors.length != 0">
      <ul v-for="e in errors" :key="e">
        <li><font color="red">{{ e }}</font></li>
      </ul>
    </div>
    <div>
      <label>タイトル</label>
      <input v-model="params.bill.title" type="text">
    </div>
    <div>
      <label>説明</label>
      <input v-model="params.bill.description" type="text">
    </div>
    <div>
      <label>金額</label>
      <input v-model="params.bill.price_cents" type="number" min="0">
    </div>
    <div>
      <label>支払い期限日</label>
      <input v-model="params.bill.payment_due_date" type="date">
    </div>
    <div>
      <label>貸した人の名前</label>
      <input v-model="params.friend.name" type="text">
    </div>
    <div>
      <label>貸した人のメールアドレス</label>
      <input v-model="params.friend.email" type="text">
    </div>
    <button type="submit">Commit</button>
  </form>
</template>

<script>
export default {
  props: {
    params: {
      bill: {},
      friend: {}
    },
    errors: ''
  }
}
</script>

<style>
</style>
