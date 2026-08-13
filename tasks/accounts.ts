import { task } from "hardhat/config";

task("accounts", "Prints accounts and balances").setAction(async (_, hre) => {
  const signers = await hre.ethers.getSigners();
  for (let i = 0; i < Math.min(signers.length, 5); i++) {
    const bal = await hre.ethers.provider.getBalance(signers[i].address);
    console.log(`${i}: ${signers[i].address} (${hre.ethers.formatEther(bal)} ETH)`);
  }
});
