<template>
  <div class="pl-24 pt-6 bg-gray-50 h-full">
    <div>
      <h2 class="text-xl font-medium">Your transactions</h2>
      <div v-if="$store.state.user" class="mt-3 flex flex-row space-x-12 h-72">
        <vote-card
          v-for="vote in myTransactions"
          :key="vote.ID"
          :vote="vote"
          :yours="true"
        />
      </div>
      <h2 class="text-xl font-medium">
        <span class="text-primary-700 font-semibold">Vote</span>
        and Help the
        <span class="text-primary-700 font-semibold">Community</span> 💪
      </h2>
      <div v-if="$store.state.user" class="mt-3 flex flex-row space-x-12 h-72">
        <vote-card
          v-for="vote in otherTransactions"
          :key="vote.ID"
          :vote="vote"
          :yours="false"
        />
      </div>
    </div>
  </div>
</template>

<script>
import VoteCard from '@/components/VoteCard.vue'

export default {
  components: {
    VoteCard,
  },
  data() {
    return {
      transactions: null,
    }
  },
  computed: {
    myTransactions() {
      return this.transactions
        ? this.transactions.filter(
            (t) =>
              t.tenant.toLowerCase() == this.$store.state.user.address ||
              this.$store.state.user.properties.includes(t.houseID)
          )
        : []
    },
    otherTransactions() {
      return this.transactions
        ? this.transactions.filter(
            (t) =>
              t.tenant != this.$store.state.user.address &&
              !this.$store.state.user.properties.includes(t.houseID)
          )
        : []
    },
  },
  mounted() {
    this.$contract.methods
      .getToVoted()
      .call()
      .then((transactions) => {
        this.transactions = transactions.filter((t) => Number(t.houseID))
      })
      .catch((err) => {
        console.log(err)
      })
  },
}
</script>
