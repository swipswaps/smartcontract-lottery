require("@nomiclabs/hardhat-waffle")
require("@nomiclabs/hardhat-etherscan")
require("hardhat-deploy")
require("solidity-coverage")
require("hardhat-gas-reporter")
require("hardhat-contract-sizer")
require("dotenv").config()

const RPC_URL_GOERLI = process.env.RPC_URL_GOERLI || "https://goerli.net/"
PRIVATE_KEY = process.env.PRIVATE_KEY || "0x"
ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "Your etherscan API key"
COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || "Your CoinmarketCap API Key"

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.17",
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 31337,
            blockConfirmations: 1,
        },
        localhost: {
            chainId: 31337,
        },
        goerli: {
            chainId: 5,
            blockConfirmations: 6,
            url: RPC_URL_GOERLI,
            accounts: [PRIVATE_KEY],
        },
    },

    //this might be redundant but it helped me verify my contract in goerli
    etherscan: {
        apiKey: {
            goerli: ETHERSCAN_API_KEY,
            //polygon: POLYGONSCAN_API_KEY,
        },
        customChains: [
            {
                network: "goerli",
                chainId: 5,
                urls: {
                    apiURL: "https://api-goerli.etherscan.io/api",
                    browserURL: "https://goerli.etherscan.io/",
                },
            },
        ],
    },
    gasReporter: {
        enabled: false,
        currency: "USD",
        outputFile: "gas-report.txt",
        noColors: true,
        // coinmarketcap: COINMARKETCAP_API_KEY,
        // token: "MATIC",
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
        player: {
            default: 1,
        },
    },
    mocha: {
        timeout: 500000,
    },
}
