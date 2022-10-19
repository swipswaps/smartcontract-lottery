# Hardhat Smart Contract Lottery (Raffle)

<div align = "center">
    <img src="/images/card.png">
</div>

# Overview

This contract allows players to enter the Raffle, after a period of time a random winner will be selected and the prize will be sent to the address of the winner.

# Getting Started

To run this repo you need to install the following packages:

-   [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
    -   After installing the package run in the terminal the command `git --version` and if the installation was successful the output should look like this: `git version x.xx.x`
-   [Nodejs](https://nodejs.org/en/)
    -   In the terminal run the command `node --version`, if the output looks like `vxx.xx.x` that means the package was installed.
-   [Yarn](https://nodejs.org/en/)
    -   Instead of `npm` install `yarn`. In the terminal run the command `yarn --version`, if the output looks like `x.xx.xx` that means the package was installed.

# Quickstart

Clone this repo, cd into the folder and and run `yarn` to install the dependencies.

```
git clone https://github.com/PacelliV/hardhat-fund-me.git
cd hardhat-fund-me
yarn
```

# Usage

-   Compile

```
yarn hardhat compile
```

-   Deployment

```
yarn hardhat deploy
```

-   Testing

```
yarn hardhat test
```

-   Coverage

```
yarn hardhat coverage
```

# Deployment to a testnet

1. Set up environment variables:

You'll need to set your `RPC_URL_GOERLI` and `PRIVATE_KEY` as enviroment variables. Yo can add them to an `.env` file.

-   `PRIVATE_KEY`: The private key of your account (like from [Metamask](https://metamask.io/)). <b>NOTE: IT IS RECOMMENDED TO CREATE A NEW ACCOUNT FOR TESTING PURPOSES AND NEVER USE AN ACCOUNT WITH REAL FUNDS.</b>
    -   You can learn how to export a private key [here](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key).
-   `RPC_URL_GOERLI`: This is the url of the goerli node you are working with. You can set up one for free in [Alchemy](https://www.alchemy.com/).

2. Get test ETH and LINK

Go to https://goerlifaucet.com/ or [faucets.chain.link](https://faucets.chain.link/) to get test ETH and LINK in your Metamask. [Read more about how to set up your wallet with LINK]().

3. Setup a Chainlink VRF Subscription ID

Head over to [vrf.chain.link](https://vrf.chain.link/) and create a new subscription to get a subscriptionId. You can reuse an old subscription if you already have one.

You can [read more](Chainlink VRF Subscription ID) in case that you need more information on how to create the Chainlink VRF Subscription ID. After this step you should have:

1.  Subscription ID
2.  Your subscription should be funded with LINK
3.  Deploy your contract with you subscription ID imported

In your `helper-hardhat-config.js` add your `subscriptionId` under the section of the chainId you're using. If you're deploying to goerli, add your `subscriptionId` in the `subscriptionId` field under the `5` section.

Run:

```
yarn hardhat deploy --network goerli
```

Advice: store your contract address for a quick access in case it's needed.

4. Add your contract address as a Chainlink VRF Consumer

Go back to [vrf.chain.link](https://vrf.chain.link/), under your subscription click on Add consumer and insert your contract address. You should also fund the contract with a minimum of 1 LINK.

5. Register a Chainlink Keepers Upkeep

[Read more to find extra information](https://docs.chain.link/docs/chainlink-automation/compatible-contracts/)

Go to [keepers.chain.link](https://automation.chain.link/) and register a new upkeep. Choose `Custom logic` as your trigger mechanism for automation and insert your `contract address`. Your UI will look something like this once completed:

<div align = "center">
    <img src="/images/CapturaKeepers.JPG">
    <p>Screenshot. The optional fields can be left blank.</p>
</div>

6. Enter your Raffle

Your contract is now setup to be a tamper proof autonomous verifiably random lottery. Create a new terminal and run:

```
yarn hardhat node
```

Enter the lottery by running:

```
yarn hardhat run scripts/enter.js --network localhost
```

To test your contract in a testnet replace `localhost` for `goerli` in the previous command and run it.

# Estimate gas cost in USD

To get a USD estimation of gas cost, you'll need a `COINMARKETCAP_API_KEY` environment variable. You can get one for free from [CoinMarketCap](https://pro.coinmarketcap.com/account).

Then, uncomment the line coinmarketcap: `COINMARKETCAP_API_KEY`, in `hardhat.config.js` to get the USD estimation. Just note, everytime you run your tests it will use an API call, so it might make sense to have using coinmarketcap disabled until you need it. You can disable it by just commenting the line back out.

# Verify on etherscan

If you deploy to a testnet or mainnet, you can verify it if you get an [API Key](https://etherscan.io/login?cmd=last) from Etherscan and set it as an environemnt variable named `ETHERSCAN_API_KEY`. You can pop it into your `.env` file as seen in the `.env.example`.

However, you can manual verify with:

```
yarn hardhat verify --constructor-args arguments.js DEPLOYED_CONTRACT_ADDRESS
```

In it's current state, if you have your api key set, it will auto verify goerli contracts.

# Typescript

There no typescript version of this repo, but PRs are welcome!

# Linting

To check linting / code formatting:

```
yarn lint
```

or, to fix:

```
yarn lint:fix
```

# Acknowledgements

I want to thanks [PatrickAlphaC](https://github.com/PatrickAlphaC) for teaching me the necessary tools to complete this project in my journey to become a full stack developer.

# Thank you 🎉 🎉

I hope you like this project and it ends up being useful to you 👨‍💻
