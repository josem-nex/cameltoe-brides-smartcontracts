
const { ethers, run, network } = require("hardhat");
require("dotenv").config();

async function main() {
    const SimpleStorage = await ethers.getContractFactory("SimpleStorage");
    console.log("Deploying SimpleStorage...");
    const simpleStorage = await SimpleStorage.deploy();
    await simpleStorage.deployed();
    const address = simpleStorage.address;
    console.log("SimpleStorage deployed to:", address);

    // verify if the network is not local
    console.log("Network:", network.name);
    // console.log("Network:", network.config);

    /* if (network.config.chainId !== 31337 && process.env.ETHERSCAN_API_KEY) {
        await simpleStorage.deployTransaction.wait(6);
        await verify(address, []);
    } */
    // TESTING
    const myfavoriteNumber = await simpleStorage.retrieveFavoriteNumber("Miguel");
    console.log("My favorite number is:", myfavoriteNumber.toString());

    const transactionResponse = await simpleStorage.addPerson('Miguel', 7, '0x5FbDB2315678afecb367f032d93F642f64180aa3');
    await transactionResponse.wait(1);

    const myAddress = await simpleStorage.retrieveAddress('Miguel');
    console.log("My address is:", myAddress);
    const myfavoriteNumber2 = await simpleStorage.retrieveFavoriteNumber("Miguel");
    console.log("My favorite number now is:", myfavoriteNumber2.toString());

}

async function verify(contractAddress, args) {
    console.log("Verifying contract...");
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args,
        });
    } catch (error) {
        if (error.message.toLowerCase().includes("already verified")) {
            console.log("Contract already verified");
        } else {
            console.error("Error verifying contract:", error);
        }
    }
}

main()
    .then(() => {
        process.exit(0);
    })
    .catch(error => {
        console.error(error);
        process.exit(1);
    });