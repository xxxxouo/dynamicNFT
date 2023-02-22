const hre = require("hardhat");

const main = async () => {
  try {
    const [owner] = await hre.ethers.getSigners();
    const nftContractFactory = await hre.ethers.getContractFactory(
      "ChainBattles"
    );
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("Contract deployed to:", nftContract.address);

    console.log("start");
    await nftContract.connect(owner).mint()
    console.log("minting");
    await nftContract.connect(owner).train(1)
    const res = await nftContract.connect(owner).getLevels(1)
    const res1 = await nftContract.connect(owner).getHp(1)
    const res2 = await nftContract.connect(owner).getSpeed(1)
    const res3 = await nftContract.connect(owner).getStrength(1)
    console.log(res,res1,res2,res3);
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};
  
main();