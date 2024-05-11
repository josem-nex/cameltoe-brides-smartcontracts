const { ethers, run, network } = require("hardhat");
require("dotenv").config();

async function main() {
    const MyToken = await ethers.getContractFactory("Collection");

    /* 
    constructor(
            string memory name,
            string memory symbol,
            uint256 _maxSupply,
            uint256 _maxMintPerAddress,
            string memory baseURI,
            string memory extension, //  usually ".json"
            uint256 _pricePublicMint,
            uint8 _priceIncrement, // 20 = 20%, 100 = 100%
            uint96 _royaltyFee // 10000 = 100%,  500 = 5%
    */
    const myTokenDeployed = await MyToken.deploy("MyToken", "MT", 5, 1, "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/", ".json", 100000000000, 20, 500);

    await myTokenDeployed.deployed();

    console.log("Collection was deployed to: ", myTokenDeployed.address);

    // verify if the network is not local: 
    /* await myTokenDeployed.deployTransaction.wait(10);
    await verify(myTokenDeployed.address, ["MyToken", "MT", 5, 1, "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/", ".json", 100000000000, 20, 500]);
    // if not working, try this command line: yarn hardhat verify --network networkName contractAddress args
    */


    //In this section you can interact with the methods of the deployed contract.
    // myTokenDeployed.methodName( args );
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