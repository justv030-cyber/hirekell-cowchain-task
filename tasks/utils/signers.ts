import { HardhatRuntimeEnvironment } from "hardhat/types";

export async function getNamedSigners(hre: HardhatRuntimeEnvironment) {
  const signers = await hre.ethers.getSigners();
  return {
    deployer: signers[0],
    resolver: signers[1],
    bettor1: signers[2],
    bettor2: signers[3],
    bettor3: signers[4],
  };
}
