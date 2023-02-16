// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// External aggregator interface
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// Obtains the latest BTC/USD price feed data
contract BTCPricefeed {
    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Sepolia
     * Aggregator: BTC/USD
     * Proxy Aggregator Contract Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
     */
    constructor() {
        // initializes an interface object that allows this contract to...
        // run functions on the deployed proxy aggregator contract.
        priceFeed = AggregatorV3Interface(
            0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        );
    }

    function getLatestPrice() public view returns (int) {
        (
            int price
        ) = priceFeed.latestRoundData();
        return price;
    }
}