const { ethers } = require("hardhat");

async function main() {
  const NftMarketplace = await ethers.getContractFactory("NftMarketplace");
  const marketplace = await NftMarketplace.deploy();

  await marketplace.waitForDeployment();

  console.log(`NFT Marketplace deployed to: ${await marketplace.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
