# Hardhat Smart Contract Lottery (Raffle)

# Overview

This contract allows players to enter the Raffle, after an period of time a random winner will be selected and the prize will be sent to the address of the winner.

# Getting Started

To run this repo you need to install the following packages:

-   git
    -   After installing the package run in the terminal the command `git --version` and if the installation was successful the output should look like this: `git version x.xx.x`
-   Nodejs
    -   In the terminal run the command `node --version`, if the output looks like `vxx.xx.x` that means the package was installed.
-   Yarn
    -   In the terminal run the command `yarn --version`, if the output looks like `x.xx.xx` that means the package was installed.

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

# Deployment to a testnet or mainnet

1. Set up environment variables:

You'll need to set your `RPC_URL_GOERLI` and `PRIVATE_KEY` as enviroment variables. Yo can add them to an `.env` file.

-   `PRIVATE_KEY`: The private key of your account (like from [Metamask](https://metamask.io/)). <b>NOTE: IT IS RECOMMENDED TO CREATE A NEW ACCOUNT FOR TESTING PURPOSES AND NEVER USE AN ACCOUNT WITH REAL FUNDS.</b>
    -   You can learn how to export a private key [here](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key).
-   `RPC_URL_GOERLI`: This is the url of the goerli node you are working with. You can set up one for free in [Alchemy](https://www.alchemy.com/).

2. Get test ETH

Go to https://goerlifaucet.com/ or faucets.chain.link to get test ETH and LINK in your Metamask.
