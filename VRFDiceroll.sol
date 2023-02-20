//This contract is a dice roller with a Game of Thrones theme,
  //that uses Chainlink VRF to generate random numbers
//Deployable on the Ethereum Sepolia testnet

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

//This contract (VRFDiceroll) will inherit from VRFConsumerBaseV2
contract VRFDiceroll is VRFConsumerBaseV2 {
  //VARIABLES
    uint256 private constant ROLL_IN_PROGRESS = 42;

    VRFCoordinatorV2Interface COORDINATOR;

    //the subscription ID that this contract uses for funding requests
    uint64 s_subscriptionId = 56;

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
    address s_owner;

    //map rollers to requestIds
    mapping(uint256 => address) private s_rollers;

    //map requestIds to rollers
    mapping(address => uint256) private s_results;


  //EVENTS
    //event (state management) that signals that the dice is being rolled
    //indexed refers to the fact that the value of this parameter will be stored on the blockchain and can be retrieved
    event DiceRolled(uint256 indexed requestId, address indexed roller);

    //event (state management) that signals that the dice has landed
    event DiceLanded(uint256 indexed requestId, uint256 indexed result);

  //CONSTRUCTOR
    //also calls upon constructor from VRFConsumerBaseV2 (parent contract)
    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
      COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
      s_owner = msg.sender; //set owner to the address that deployed the contract
      s_subscriptionId = subscriptionId; //set subscription ID to the ID that was passed in
    }

  //FUNCTIONS
    function rollDice(address roller) public onlyOwner returns (uint256 requestId) {
      require(s_results[roller] == 0 , "Already rolled"); //require that the roller has not already rolled
      requestId = COORDINATOR.requestRandomWords(
        s_keyHash,
        s_subscriptionId,
        requestConfirmations,
        callbackGasLimit,
        numWords
      );

      s_rollers[requestId] = roller;
      s_results[roller] = ROLL_IN_PROGRESS;

      emit DiceRolled(requestId, roller);
    }


    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
      //transform the result to a number between 1 and 20, inclusively
      uint256 d20value = (randomWords[0] % 20) + 1;

      //assign the transformed value to the address in the s_results mapping variable
      s_results[s_rollers[requestId]] = d20value;

      //emit event to signal that the dice has landed
      emit DiceLanded(requestId, d20value);
    }

    //obtains the house assigned to the player once the address has rolled the dice
    function house(address player) public view returns (string memory) {
      //check if dice has not yet been rolled
      require(s_results[player] != 0, "Dice not rolled yet");

      //check if dice is still rolling
      require(s_results[player] != ROLL_IN_PROGRESS, "Roll in progreess");

      return getHouseName(s_results[player]);
    }

    function getHouseName(uint256 id) private pure returns (string memory) {
      //array sorting the list of house's names
      string[20] memory houseNames = [
        "Stark",
        "Lannister",
        "Targaryen",
        "Baratheon",
        "Greyjoy",
        "Tyrell",
        "Martell",
        "Arryn",
        "Tully",
        "Frey",
        "Bolton",
        "Clegane",
        "Mormont",
        "Karstark",
        "Manderly",
        "Umber",
        "Tarly",
        "Royce",
        "Reed",
        "Baelish"
      ];

      //returns houseName at given index
      //reduces id by 1 to adjust the index to be zero-based
      return houseNames[id - 1];
    }

    //only the owner of the contract can call this function
    modifier onlyOwner() {
      require(msg.sender == s_owner);
      _;
    }
}