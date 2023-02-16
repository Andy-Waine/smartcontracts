// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

//This contract (VRFDiceroll) will inherit from VRFConsumerBaseV2
contract VRFDiceroll is VRFConsumerBaseV2 {
  //VARIABLES
    //the subscription ID that this contract uses for funding requests
    uint64 s_subscriptionId;

    //Deployed VRF Coordinator Contract address from Chainlink
    address vrfCoordinator = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;


    bytes32 s_keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;


    uint32 callbackGasLimit = 40000;


    uint16 requestConfirmations = 3;


    uint32 numWords =  1;

  //CONSTRUCTOR
    //also calls upon constructor from VRFConsumerBaseV2 (parent contract)
    constructor(uint s_subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
          COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);

    }

}