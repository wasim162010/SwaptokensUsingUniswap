

const {ethers,upgrades} = require("hardhat");

async function main() {

  const TokenERC20 = await ethers.getContractFactory("TokenERC20");
  console.log("Deploying");
  const erc20= await upgrades.deployProxy(TokenERC20,  {initializer: "initVars"});
  await erc20.deployed()
  console.log("deployed TokenERC20 ", erc20.address);
}

main();
