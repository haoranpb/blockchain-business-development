<template>
  <div class="w-full h-screen bg-gray-50">
    <div class="mt-48 flex items-center justify-center">
      <form
        class="w-full max-w-md bg-white shadow-lg rounded-md px-12 pt-6 pb-8"
      >
        <h2 class="text-gray-800 text-2xl flex justify-center py-2 mb-4">
          Mint House
        </h2>
        <div class="mb-4">
          <VfInput v-model="owner" autofocus placeholder="Owner: 0x123..." />
        </div>
        <div class="mb-6">
          <VfInput v-model="address" placeholder="Physical Address" />
        </div>
        <div class="flex items-center justify-between">
          <VfButton @click="submit">Mint</VfButton>
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
      owner: '',
      address: '',
    }
  },
  methods: {
    submit() {
      console.log(this.owner, this.address)
    },
  },
}
</script>
