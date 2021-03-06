<template>
  <div
    v-if="house"
    class="w-96 h-72 bg-white px-6 py-4 rounded-md shadow-lg flex-none mb-10"
  >
    <h3 class="font-medium text-lg">{{ house.physicalAddr }}</h3>
    <p class="text-gray-400 text-xs">
      {{ house.ID }}; Txn ID: {{ transaction.ID }}
    </p>
    <div class="flex flex-col space-y-2 mt-4">
      <p>
        Price: {{ transaction.price }}, Collateral: {{ transaction.colateral }}
      </p>
      <p v-if="yours">
        Fine suggested by the other party: {{ suggestedFine() }}
      </p>
      <p v-else>
        Fine suggested by both parties:
        {{ transaction.tenantColateral }},
        {{ transaction.landlordColateral }}
      </p>
      <p>
        <OutboundLink
          class="text-xs text-primary-600"
          href="https://ibb.co/hfQ0b30"
        >
          Landlord Picture </OutboundLink
        >,
        <OutboundLink
          class="text-xs text-primary-600"
          href="https://ibb.co/hfQ0b30"
        >
          Tenant MoveIn </OutboundLink
        >,
        <OutboundLink
          class="text-xs text-primary-600"
          href="https://ibb.co/hBWyc8P"
        >
          Tenant MoveOut
        </OutboundLink>
      </p>
      <div v-if="yours" class="flex flex-col space-y-4">
        <VfInput
          v-model="fine"
          type="number"
          placeholder="Price for the fine"
        />
        <VfButton @click="submit">Submit</VfButton>
      </div>
      <div v-else class="flex flex-col space-y-4">
        <VfInput
          v-model="fine"
          type="number"
          placeholder="Price for the fine"
        />
        <VfButton @click="vote">Vote</VfButton>
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
    transaction: {
      type: Object,
      required: true,
    },
    yours: {
      type: Boolean,
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
      .houses(this.transaction.houseID)
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
        this.transaction.tenant.toLowerCase() == this.$store.state.user.address
          ? 0
          : 1

      window.ethereum
        .request({
          method: 'eth_sendTransaction',
          params: [
            {
              from: this.$store.state.user.address,
              to: process.env.VUE_APP_CONTRACT_ADDRESS,
              data: this.$contract.methods
                .setColateral(this.transaction.ID, this.fine, role)
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
    vote() {
      window.ethereum
        .request({
          method: 'eth_sendTransaction',
          params: [
            {
              from: this.$store.state.user.address,
              to: process.env.VUE_APP_CONTRACT_ADDRESS,
              data: this.$contract.methods
                .vote(this.transaction.voteID, this.fine)
                .encodeABI(),
            },
          ],
        })
        .then(() => {
          alert('Successfully Voted!')
        })
        .catch((err) => {
          console.log(err)
        })
    },
    suggestedFine() {
      if (
        this.transaction.tenant.toLowerCase() == this.$store.state.user.address
      ) {
        return this.transaction.landlordColateral == -1
          ? 'undefined'
          : this.transaction.landlordColateral
      } else {
        return this.transaction.tenantColateral == -1
          ? 'undefined'
          : this.transaction.tenantColateral
      }
    },
  },
}
</script>
