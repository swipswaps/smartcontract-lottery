const { ethers, network, getNamedAccounts } = require("hardhat")
let deployer

async function mockKeepers() {
    deployer = (await getNamedAccounts()).deployer
    const raffle = await ethers.getContract("Raffle", deployer)
    console.log(`Got Raffle contract at ${raffle.address}`)
    const checkData = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(""))
    const { upkeepNeeded } = await raffle.callStatic.checkUpkeep(checkData)

    console.log(checkData)
    console.log(upkeepNeeded)
}

mockKeepers()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
