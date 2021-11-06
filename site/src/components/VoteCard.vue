<template>
  <div
    v-if="house"
    class="w-96 h-80 bg-white px-6 py-4 rounded-md shadow-lg flex-none mb-10"
  >
    <h3 class="font-medium text-lg">{{ house.physicalAddr }}</h3>
    <p class="text-gray-400 text-xs">{{ house.ID }}</p>
    <div class="flex flex-col space-y-4 mt-4">
      <p>Price: {{ vote.price }}, Collateral: {{ vote.colateral }}</p>
      <p>Before: Link, After: Link</p>
      <VfInput v-model="fine" type="number" placeholder="Price for the fine" />
      <VfButton @click="submit">Submit</VfButton>
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
    vote: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      house: null,
      fine: null,
    }
  },
  mounted() {
    this.$contract.methods
      .houses(this.vote.houseID)
      .call()
      .then((house) => {
        this.house = house
      })
      .catch((err) => {
        console.log(err)
      })
  },
  methods: {
    submit() {
      const role =
        this.vote.tenant.toLowerCase() == this.$store.state.user.address ? 0 : 1

      window.ethereum
        .request({
          method: 'eth_sendTransaction',
          params: [
            {
              from: this.$store.state.user.address,
              to: process.env.VUE_APP_CONTRACT_ADDRESS,
              data: this.$contract.methods
                .setColateral(this.vote.ID, this.fine, role)
                .encodeABI(),
            },
          ],
        })
        .then(() => {
          alert('Successfully setted fine!')
        })
        .catch((err) => {
          console.log(err)
        })
    },
  },
}
</script>
