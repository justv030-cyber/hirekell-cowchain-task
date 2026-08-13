import { task } from "hardhat/config";

task("balance", "Check USDC balance for an account")
  .addOptionalParam("token", "Token contract address")
  .addOptionalParam("account", "Account to check")
  .setAction(async ({ token, account }, hre) => {
    const [signer] = await hre.ethers.getSigners();
    const tokenAddress = token || process.env.USDC_ADDRESS;
    const accountAddress = account || signer.address;

    if (!tokenAddress) throw new Error("Provide --token or USDC_ADDRESS");

    const usdc = await hre.ethers.getContractAt("MockUSDC", tokenAddress);
    const bal = await usdc.balanceOf(accountAddress);
    console.log(`${accountAddress}: ${hre.ethers.formatUnits(bal, 6)} USDC`);
  });
