const hre = require("hardhat");

async function main() {
  // 获取合约并部署
  const nftContractFactory = await hre.ethers.getContractFactory("ChainBattles");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("nftContract deployed to ", nftContract.address);
  process.exitCode = 0
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

//  npx hardhat run scripts/deploy.js --network mumbai
