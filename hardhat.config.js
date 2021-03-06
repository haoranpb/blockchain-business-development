/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require('dotenv').config()
require('@nomiclabs/hardhat-ethers')
require('@nomiclabs/hardhat-etherscan')
const { VUE_APP_ALCHEMY_KEY, VUE_APP_PRIVATE_KEY, VUE_APP_ETHERSCAN_KEY } =
  process.env

module.exports = {
  solidity: '0.8.0',
  defaultNetwork: 'ropsten',
  networks: {
    hardhat: {},
    ropsten: {
      url: VUE_APP_ALCHEMY_KEY,
      accounts: [`0x${VUE_APP_PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: VUE_APP_ETHERSCAN_KEY,
  },
}
