<template>
  <div class="bg-gray-50 w-full h-full">
    <div class="mt-48 flex items-center justify-center">
      <form
        class="w-full max-w-md bg-white shadow-lg rounded-md px-12 pt-6 pb-8"
      >
        <h2 class="text-gray-800 text-2xl flex justify-center py-2 mb-4">
          Register User for Nesters
        </h2>
        <div class="mb-4">
          <VfInput
            v-model="address"
            autofocus
            placeholder="Public Key: 0x123..."
          />
        </div>
        <div class="mb-6">
          <VfInput v-model="username" placeholder="Username" />
        </div>
        <div class="flex items-center justify-between">
          <VfButton @click="submit">Register</VfButton>
        </div>
      </form>
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
  data() {
    return {
      username: '',
      address: '',
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
                .registerUser(this.address, this.username)
                .encodeABI(),
            },
          ],
        })
        .then(() => {
          alert('Successfully Registered!')
        })
        .catch((err) => {
          console.log(err)
        })
    },
  },
}
</script>
