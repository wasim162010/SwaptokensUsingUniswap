

const {ethers,upgrades} = require("hardhat");

async function main() {
  
  //initialized params variable with goerli testnet values. Please refer initVars() in 'SwapUSDCToken'.
  const params =['0xE592427A0AEce92De3Edee1F18E0157C05861564','0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844','0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6',
                  '0x07865c6E87B9F70255377e024ace6630C1Eaa37F','0x326C977E6efc84E512bB9C30f76E30c160eD06FB',40,20,20]
  const SwapUSDCToken = await ethers.getContractFactory("SwapUSDCToken");
  console.log("Deploying");
  const swap1= await upgrades.deployProxy(SwapUSDCToken, params, {initializer: "initVars", unsafeAllow: ['delegatecall']});
  await swap1.deployed()
  console.log("deployed SwapUSDC ", swap1.address);
  
}

main();

// wasim@wasims-MacBook-Pro my-upgradeable-contract % npx hardhat run --network localhost scripts/deploy.js
// Compiled 3 Solidity files successfully
// Deploying
// deployed  0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0