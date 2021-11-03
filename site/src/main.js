import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import './assets/tailwind.css'

import { createAlchemyWeb3 } from '@alch/alchemy-web3'
import contractABI from './Nesters.json'

const app = createApp(App).use(router).use(store)
const web3 = createAlchemyWeb3(process.env.VUE_APP_ALCHEMY_KEY)

const contract = new web3.eth.Contract(
  contractABI.abi,
  process.env.VUE_APP_CONTRACT_ADDRESS
)

app.config.globalProperties.$web3 = web3
app.config.globalProperties.$contract = contract

app.mount('#app')
