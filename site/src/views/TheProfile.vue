<template>
  <div class="pl-24 pt-6 bg-gray-50 h-full">
    <h2 class="text-2xl font-medium">{{ name }}</h2>
    <h3 class="text-gray-500 text-sm mb-2">{{ address }}</h3>
    <p>Reputation: {{ rToken }}</p>
    <p>Voting Token: {{ vToken }}</p>
    <div class="mt-10 flex flex-row flex-wrap space-x-12">
      <house-card v-for="house in houses" :key="house.id" :house="house" />
    </div>
  </div>
</template>

<script>
import HouseCard from '@/components/HouseCard.vue'

export default {
  components: {
    HouseCard,
  },
  data() {
    return {
      houses: [],
    }
  },
  computed: {
    address() {
      return this.$store.state.user['address']
    },
    name() {
      return this.$store.state.user['name']
    },
    rToken() {
      return this.$store.state.user['rToken']
    },
    vToken() {
      return this.$store.state.user['vToken']
    },
  },
  mounted() {
    this.getHouses()
  },
  methods: {
    getHouses() {
      this.houses = []

      this.$store.state.user['properties'].forEach((houseID) => {
        this.$contract.methods
          .houses(houseID)
          .call()
          .then((house) => {
            this.houses.push(house)
          })
      })
    },
  },
}
</script>
