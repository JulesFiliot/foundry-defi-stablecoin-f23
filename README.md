# Foundry Defi Stable Coin

The Foundry Defi Stable Coin project is a blockchain-based system designed to create a decentralized stable coin, named Decentralized Stable Coin (DSC). The DSC has a 1:1 peg with the U.S. dollar and is exogenously collateralized using Wrapped Ethereum (WETH) and Wrapped Bitcoin (WBTC). The project aims to ensure stability through a collateralization mechanism and a decentralized minting algorithm.

## Technologies Used

The project utilizes several technologies:

- **Solidity**: The smart contracts of this project are written in Solidity. Solidity is chosen for its robustness and wide adoption in the blockchain community.

- **Foundry**: This project is built using Foundry, a development environment, testing framework, and asset pipeline for Ethereum. Foundry helps streamline the development process, making it easier to test and deploy the smart contracts.

## Libraries Used 

The project makes use of the following notable libraries:

- **Chainlink**: Chainlink is used to retrieve the price feeds of tokens. Chainlink is a decentralized oracle network that enables smart contracts on Ethereum to securely connect to external data sources, APIs, and payment systems.

- **OpenZeppelin**: OpenZeppelin library is used to access different token interfaces such as ERC20. OpenZeppelin is a library for secure smart contract development. It provides implementations of standards like ERC20 and ERC721 which you can deploy as-is or extend to suit your needs, as well as Solidity components to build custom contracts and more complex decentralized systems.

## Testing

The project includes an extensive suite of tests to ensure the reliability and security of the system. This includes unit tests that verify individual parts of the code, as well as fuzz (invariants) tests to check for unexpected behavior in the system.

## Mechanism

The minting mechanism of DSC is decentralized and is done with an algorithm. The collateralization mechanism is designed such that the pegged value is maintained by allowing people to buy other people's debt when their health factor becomes too low. The health factor is a measure of the risk associated with the collateralized debt position (CDP). If the health factor drops too low, it indicates that the CDP is at risk of becoming under-collateralized, and thus, others are allowed to buy the debt as a means of maintaining stability in the system. 
