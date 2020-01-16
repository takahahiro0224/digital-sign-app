<template>
  <form @submit.prevent="$emit('submit')">
    <div v-if="errors.length != 0">
      <ul v-for="e in errors" :key="e">
        <li><font color="red">{{ e }}</font></li>
      </ul>
    </div>
    <div>
      <label>タイトル</label>
      <input v-model="bill.title" type="text">
    </div>
    <div>
      <label>説明</label>
      <input v-model="bill.description" type="text">
    </div>
    <div>
      <label>金額</label>
      <input v-model="bill.price_cents" type="number" min="0">
    </div>
    <button type="submit">Commit</button>
  </form>
</template>

<script>
export default {
  props: {
    bill: {},
    errors: ''
  }
}
</script>

<style>
</style>
