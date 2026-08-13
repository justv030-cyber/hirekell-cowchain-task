import fs from "fs";
import path from "path";

export interface DeploymentAddresses {
  usdc: string;
  treasury: string;
  factory: string;
  oracle: string;
  registry: string;
  protocolConfig?: string;
  resolverRegistry?: string;
  marketViews?: string;
  deployedAt: string;
  network: string;
}

export function saveDeployment(addresses: DeploymentAddresses, filename = "latest.json") {
  const dir = path.join(__dirname, "..", "deployments");
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(path.join(dir, filename), JSON.stringify(addresses, null, 2));
  console.log(`Saved deployment to scripts/deployments/${filename}`);
}

export function loadDeployment(filename = "latest.json"): DeploymentAddresses {
  const file = path.join(__dirname, "..", "deployments", filename);
  return JSON.parse(fs.readFileSync(file, "utf-8"));
}
