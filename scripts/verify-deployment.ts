import { loadDeployment } from "./utils/saveDeployment";

async function main() {
  const deployment = loadDeployment();
  const required = ["usdc", "treasury", "factory", "oracle", "registry"] as const;

  for (const key of required) {
    if (!deployment[key]) {
      console.error(`Missing deployment address: ${key}`);
      process.exit(1);
    }
    console.log(`✔ ${key}: ${deployment[key]}`);
  }

  console.log("\nDeployment file is valid.");
}

main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});
