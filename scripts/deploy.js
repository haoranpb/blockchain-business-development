async function main() {
  /* eslint-disable-next-line */
  const Nesters = await ethers.getContractFactory('Nesters')

  // Start deployment, returning a promise that resolves to a contract object
  const result = await Nesters.deploy()
  console.log('Contract deployed to address:', result.address)
  console.log('Search for it on: https://ropsten.etherscan.io')
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
