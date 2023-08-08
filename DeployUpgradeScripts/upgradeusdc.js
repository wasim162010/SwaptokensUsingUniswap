const {ethers,upgrades} = require("hardhat");

const PROXY_CONTRACT_ADDRESS='0xbcD0Ad5476a46704EDB6aE69733E61bB0FCEAde9';

async function main() { 

    if(PROXY_CONTRACT_ADDRESS  == '') {
        console.log("Assign proxy contract address of deployed SwapUSDCToken to PROXY_CONTRACT_ADDRESS variable in upgradeusdc.js");
        return;
    }
    const v2SwapUSDC = await ethers.getContractFactory("SwapUSDCTokenv2");
    console.log("upgrading to SwapUSDCTokenv2");
    const upgradeAddress = await upgrades.upgradeProxy(PROXY_CONTRACT_ADDRESS, v2SwapUSDC ,{ unsafeAllow: ['delegatecall']})   
    console.log("upgraded SWAPUSDv2 ", upgradeAddress.address);
}

main();