import("@nomicfoundation/hardhat-toolbox");

const hardhat = hre;

const main = async () {
    try {
        const nftContractFactory = await hre.ethers.getContractFactory(
            "ChainBattles"
        );
        const nftContract = await nftContractFactory.deploy();
        await nftContract.waitForDeployment();

        console.log("Contract deployed to", nftContract.target);
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

main();