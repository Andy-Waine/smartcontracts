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

    //hashed value of max gas price willing to pay (in wei), serves as an ID for the off-chain VRF job
    bytes32 s_keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;

    //limit  of gas to use for the callback request to the fulfillRandomWords function
    uint32 callbackGasLimit = 40000;

    //number of confirmations required the Chainlink node should wait for before responding
    uint16 requestConfirmations = 3; //must be greater than the minimumRequestBlockConfirmations limit on the coordinator contract

    //number of random values requested per transaction 
    uint32 numWords =  1;

    uint256 private constant ROLL_IN_PROGRESS = 42;

    mapping(uint256 => address) private s_rollers;
    mapping(address => uint256) private s_results;


  //EVENTS
    //event (state management) that signals that the dice is being rolled
     //indexed refers to the fact that the value of this parameter will be stored on the blockchain and can be retrieved
    event DiceRolled(uint256 indexed requestId, address indexed roller);

  //CONSTRUCTOR
    //also calls upon constructor from VRFConsumerBaseV2 (parent contract)
    constructor(uint subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
      COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
      s_owner = msg.sender; //set owner to the address that deployed the contract
      s_subscriptionId = subscriptionId; //set subscription ID to the ID that was passed in
    }

  //FUNCTIONS
    function rollDice(address roller) public onlyOwnwer returns (uint256 requestId) {
      require(s_results[roller] == 0 , "Already rolled"); //require that the roller has not already rolled
      requestId = COORDINATOR.requestRandomWords(
        s_keyHash,
        callbackGasLimit, 
        s_subscriptionId,
        roller,
        requestConfirmations,
        numWords
      );

      s_rollers[requestId] = roller;
      s_results[roller] = ROLL_IN_PROGRESS;

      emit DiceRolled(requestId, roller);
    }

}