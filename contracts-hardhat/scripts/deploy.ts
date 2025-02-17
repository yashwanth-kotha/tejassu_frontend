import { ethers } from "hardhat";

async function main() {
  console.log("Deploying DailyJournal contract...");

  const [deployer] = await ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const DailyJournal = await ethers.getContractFactory("DailyJournal");
  const journal = await DailyJournal.deploy();
  await journal.waitForDeployment();

  const address = await journal.getAddress();
  console.log("DailyJournal deployed to:", address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });