const { ethers, getNamedAccounts } = require("hardhat")
let deployer

async function enterRaffle() {
    deployer = (await getNamedAccounts()).deployer
    const raffle = await ethers.getContract("Raffle", deployer)
    console.log(`Got Raffle contract at ${raffle.address}`)
    const entranceFee = await raffle.getEntranceFee()
    await raffle.enterRaffle({ value: entranceFee + 1 })
    console.log("You have entered the raffle, Good luck!")
}

enterRaffle()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
