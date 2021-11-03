<template>
  <div class="flex flex-col h-screen bg-white">
    <router-view />
  </div>
</template>

<script>
export default {
  mounted() {
    if (window.ethereum) {
      if (!this.$store.state.user) {
        window.ethereum
          .request({ method: 'eth_requestAccounts' })
          .then((accounts) => {
            this.$store.commit('setUser', accounts[0])
          })
      } else {
        window.ethereum.on('accountsChanged', (accounts) => {
          this.$store.commit('setUser', accounts[0])
          console.log(this.$store.state.user)
        })
      }
    } else {
      alert('You must install Metamask in your brower.')
    }
  },
}
</script>
