<template>
  <div
    class="w-48 h-64 bg-white px-4 py-2 rounded-md shadow-lg flex-none mb-10"
  >
    <h3 class="font-medium text-lg">{{ house.physicalAddr }}</h3>
    <p class="text-gray-400 text-xs">{{ house.ID }}</p>
    <div v-if="!house.active" class="flex flex-col space-y-4 mt-6">
      <VfInput v-model="price" placeholder="Price per day" />
      <VfInput v-model="colateral" placeholder="Colateral" />
      <VfButton @click="submit">Active</VfButton>
    </div>
    <div v-else-if="house.offer" class="flex flex-col space-y-2 mt-4">
      <p>Price per day: {{ house.price }}</p>
      <p>Colateral: {{ house.colateral }}</p>
      <p>Start Date: {{ startDate }}</p>
      <p>Renting Period: {{ rentingPeriod }}</p>
      <VfButton @click="accept">Accept Offer</VfButton>
    </div>
    <div v-else class="flex flex-col space-y-4 mt-8">
      <p>No offer yet</p>
      <p>Price per day: {{ house.price }}</p>
      <p>Colateral: {{ house.colateral }}</p>
    </div>
  </div>
</template>

<script>
import VfInput from '@/components/VfInput.vue'
import VfButton from '@/components/VfButton.vue'

export default {
  components: {
    VfInput,
    VfButton,
  },
  props: {
    house: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      price: null,
      colateral: null,
    }
  },
  computed: {
    startDate() {
      return new Date(parseInt(this.house.startDate)).toLocaleDateString(
        'en-US'
      )
    },
    rentingPeriod() {
      return Math.floor(this.house.rentingPeriod / 1000 / 60 / 60 / 24)
    },
  },
  methods: {
    submit() {
      window.ethereum
        .request({
          method: 'eth_sendTransaction',
          params: [
            {
              from: this.$store.state.user.address,
              to: process.env.VUE_APP_CONTRACT_ADDRESS,
              data: this.$contract.methods
                .activeHouse(this.house.ID, this.price, this.colateral)
                .encodeABI(),
            },
          ],
        })
        .then(() => {
          alert('Successfully Activated!')
        })
        .catch((err) => {
          console.log(err)
        })
    },
  },
}
</script>
