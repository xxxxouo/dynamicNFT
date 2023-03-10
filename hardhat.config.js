require("dotenv").config()
require("@nomiclabs/hardhat-etherscan")
require("@nomiclabs/hardhat-waffle")

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.10",
  networks:{
    mumbai:{
      url: process.env.TESTNET_RPC,
      accounts:[process.env.PRIVATE_KEY]
    }
  },
  etherscan:{
    apiKey: process.env.POLOGONSCAN_API_KEY  // https://polygonscan.com/myapikey
  }
};
