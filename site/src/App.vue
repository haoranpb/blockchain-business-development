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
            this.setUser(accounts[0])
            console.log('Init Address: ' + accounts[0])
          })
      }

      window.ethereum.on('accountsChanged', (accounts) => {
        this.setUser(accounts[0])
        console.log('MetaMask Address: ' + accounts[0])
      })
    } else {
      alert('You must install Metamask in your brower.')
    }
  },
  methods: {
    setUser(address) {
      this.$contract.methods
        .getUser(address)
        .call()
        .then((result) => {
          this.$store.commit('setUser', {
            address: address,
            name: result.name,
            properties: result.properties,
            rToken: result.reputationToken,
            vToken: result.votingToken,
          })
        })
    },
  },
}
</script>
