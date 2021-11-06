<template>
  <div class="pl-24 pt-6 bg-gray-50 h-full">
    <h2 class="text-2xl font-medium">{{ name }}</h2>
    <h3 class="text-gray-500 text-sm mb-2">{{ address }}</h3>
    <p>Reputation: {{ rToken }}</p>
    <p>Voting Token: {{ vToken }}</p>
    <div class="mt-10 flex flex-row flex-wrap space-x-12">
      <house-card v-for="house in properties" :key="house.id" :house="house" />
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
      properties: [],
    }
  },
  computed: {
    address() {
      return this.$store.state.user ? this.$store.state.user['address'] : ''
    },
    name() {
      return this.$store.state.user ? this.$store.state.user['name'] : ''
    },
    rToken() {
      return this.$store.state.user ? this.$store.state.user['rToken'] : ''
    },
    vToken() {
      return this.$store.state.user ? this.$store.state.user['vToken'] : ''
    },
  },
  watch: {
    '$store.state.user'() {
      if (this.$store.state.user) {
        this.getHouses()
      }
    },
  },
  mounted() {
    if (this.$store.state.user) {
      this.getHouses()
    }
  },
  methods: {
    getHouses() {
      this.properties = []

      this.$store.state.user['properties'].filter(Number).forEach((houseID) => {
        this.$contract.methods
          .houses(houseID)
          .call()
          .then((house) => {
            this.properties.push(house)
          })
      })
    },
  },
}
</script>
