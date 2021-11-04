<template>
  <div
    class="w-48 h-64 bg-white px-4 py-2 rounded-md shadow-lg flex-none mb-10"
  >
    <h3 class="font-medium text-lg">{{ house.physicalAddr }}</h3>
    <p class="text-gray-400 text-xs">{{ house.ID }}</p>
    <div class="flex flex-col space-y-4 mt-6">
      <VfInput v-model="startDate" type="date" />
      <VfInput v-model="rentingPeriod" placeholder="3 Days" type="number" />
      <VfButton class="float-right" @click="submit">Make Offer</VfButton>
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
      startDate: null,
      rentingPeriod: null,
    }
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
                .makeOffer(
                  this.house.ID,
                  new Date(this.startDate).getTime(),
                  this.rentingPeriod * 24 * 60 * 60 * 1000
                )
                .encodeABI(),
            },
          ],
        })
        .then(() => {
          alert('Offer Sent!')
        })
        .catch((err) => {
          console.log(err)
        })
    },
  },
}
</script>
