const { developmentChains } = require("../helper-hardhat-config")
const BASE_FEE = ethers.utils.parseEther("0.25") // 0.25 is the premium. It costs 0.25 LINK per request. Check CHAINLINK documentation.
const GAS_PRICE_LINK = 1000000000 // calculated value based on the gas of the chain

// Chainlink Nodes pay the gas fee to give us randomness & to do external execution

module.exports = async function ({ deployments, getNamedAccounts }) {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId
    const args = [BASE_FEE, GAS_PRICE_LINK]

    if (developmentChains.includes(network.name)) {
        await deploy("VRFCoordinatorV2Mock", {
            from: deployer,
            args: args,
            log: true,
        })
        log("Mocks deployed!")
        log("--------------------------------------------------------------------")
    }
}

module.exports.tags = ["all", "mocks"]
