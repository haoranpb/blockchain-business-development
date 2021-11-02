import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/tailwind.css'

import { createAlchemyWeb3 } from '@alch/alchemy-web3'
import contractABI from '../../artifacts/contracts/Nesters.sol/Nesters.json'

const app = createApp(App).use(router)
const web3 = createAlchemyWeb3(process.env.VUE_APP_ALCHEMY_KEY)

const contract = new web3.eth.Contract(
  contractABI.abi,
  process.env.VUE_APP_CONTRACT_ADDRESS
)

contract.methods.contractOwner.call().call((err, result) => {
  console.log(result)
})

app.mount('#app')
