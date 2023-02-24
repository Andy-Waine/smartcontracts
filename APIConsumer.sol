//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//allows for the use of Chainlink oracles to access external data
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";


/**
 * THIS IS AN EXAMPLE CONTRACT WHICH USES HARDCODED VALUES FOR CLARITY.
 * THIS EXAMPLE USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

contract APIConsumer is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    uint256 public volume;
    bytes32 public jobId;
    uint256 fee;

    event RequestVolume(bytes32 indexed requestId, uint256 volume);

        /**
     * @notice Initialize the link token and target oracle
     *
     * Sepolia Testnet details:
     * Link Token: 0x779877A7B0D9E8603169DdbD7836e478b4624789
     * Oracle: 0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD (Chainlink DevRel)
     * jobId: ca98366cc7314957b8c012c72f05aeeb
     *
     */

    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b462478);
        setChainlinkOracle(0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD);
        jobId = "ca98366cc7314957b8c012c72f05aeeb";
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }

        /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */


     function requestVolumeData() public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        //Set the URL to perform the GET request on
        req.add(
            "get", //used by HTTP Oracle Task
            "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD"
        );

        req.add(
            "path", //used by JSON Parser Oracle Task
            "RAW,ETH,USD,VOLUME24HOUR" // Sets path to find desired data nesting in API response
        );

        int256 timesAmount = 10 ** 18;
        req.addInt(
            "times", //used by Multiply Oracle Task
            timesAmount // Multiply the result by 1000000000000000000 to remove decimals
        );

        //Send the request, return result
        return sendChainlinkRequest(req, fee);
     }
}