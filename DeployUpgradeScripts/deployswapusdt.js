

const {ethers,upgrades} = require("hardhat");

async function main() {
  
  //initialized params variable with goerli testnet values. Please refer initVars() in 'SwapUSDT'.
  const params =['0xE592427A0AEce92De3Edee1F18E0157C05861564','0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844','0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6',
                 '0xC04B0d3107736C32e19F1c62b2aF67BE61d63a05','0x326C977E6efc84E512bB9C30f76E30c160eD06FB','0x509Ee0d083DdF8AC028f2a56731412edD63223B9',
                  30,30,20,20]
  
  const SwapUSDT = await ethers.getContractFactory("SwapUSDT");
  console.log("Deploying");
  const swap= await upgrades.deployProxy(SwapUSDT, params, {initializer: "initVars", unsafeAllow: ['delegatecall']});
  await swap.deployed()
  console.log("deployed SwapUSDT ", swap.address);
}

main();

// wasim@wasims-MacBook-Pro my-upgradeable-contract % npx hardhat run --network localhost scripts/deploy.js
// Compiled 3 Solidity files successfully
// Deploying
// deployed  0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0