
async function main() {
    const BloodToken = await ethers.getContractFactory("BloodToken");
    const bloodToken = await BloodToken.deploy();
    console.log("Bloodtoken address:", await bloodToken.getAddress());

    const BloodSupplyChain = await ethers.getContractFactory("BloodSupplyChain");
    const bloodSupplyChain = await BloodSupplyChain.deploy(await bloodToken.getAddress());
    console.log("Bloodsupplychain address:", await bloodSupplyChain.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });