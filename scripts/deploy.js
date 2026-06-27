import hre from "hardhat";

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // Deploy GovernanceToken
    const Token = await hre.ethers.getContractFactory("GovernanceToken");
    const token = await Token.deploy();
    await token.waitForDeployment();
    const tokenAddress = await token.getAddress();
    console.log("GovernanceToken deployed to:", tokenAddress);

    // Deploy Governor
    const Governor = await hre.ethers.getContractFactory("MyGovernor");
    const governor = await Governor.deploy(tokenAddress);
    await governor.waitForDeployment();
    const governorAddress = await governor.getAddress();
    console.log("MyGovernor deployed to:", governorAddress);

    // For the frontend to work correctly, we generally need the contract addresses.
    // We can write them to a file or just console log them.
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
