<template>
  <div
    class="w-90 h-64 bg-white px-4 py-2 rounded-md shadow-lg flex-none mb-10"
  >
    <h3 class="font-medium text-lg">{{ house.physicalAddr }}</h3>
    <p class="text-gray-400 text-xs">{{ house.ID }}</p>
    <div class="flex flex-row">
      <div
        class="
          flex flex-col
          space-y-2
          mt-8
          flex-none
          border-r border-gray-200
          pr-6
          mr-6
        "
      >
        <p>
          Owner:
          <OutboundLink class="text-sm text-primary-600" :href="ownerLink">
            {{ house.owner.slice(0, 6) }}...
          </OutboundLink>
        </p>
        <p>Price: {{ house.price }}</p>
        <p>Colateral: {{ house.colateral }}</p>
      </div>
      <div class="flex flex-col space-y-4 mt-6 w-40">
        <VfInput v-model="startDate" type="date" />
        <VfInput v-model="rentingPeriod" placeholder="3 Days" type="number" />
        <VfButton class="float-right" @click="submit">Make Offer</VfButton>
      </div>
    </div>
  </div>
</template>

<script>
import VfInput from '@/components/VfInput.vue'
import VfButton from '@/components/VfButton.vue'
import OutboundLink from '@/components/OutboundLink.vue'

export default {
  components: {
    VfInput,
    VfButton,
    OutboundLink,
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
  computed: {
    ownerLink() {
      return `https://ropsten.etherscan.io/address/${this.house.owner}`
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
