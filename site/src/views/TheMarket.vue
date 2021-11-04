<template>
  <div class="w-full h-full pl-24 bg-gray-50">
    <div class="mt-10 flex flex-row flex-wrap space-x-12">
      <market-card v-for="house in houses" :key="house.id" :house="house" />
    </div>
  </div>
</template>

<script>
import MarketCard from '@/components/MarketCard.vue'

export default {
  components: {
    MarketCard,
  },
  data() {
    return {
      houses: [],
    }
  },
  created() {
    this.houses = []

    this.$contract.methods
      .getActiveHouses(new Date().getTime())
      .call()
      .then((houses) => {
        houses.filter(Number).forEach((houseID) => {
          this.$contract.methods
            .houses(houseID)
            .call()
            .then((house) => {
              this.houses.push(house)
            })
        })
      })
      .catch((err) => {
        console.log(err)
      })
  },
}
</script>
