//SPDX License-Identifier: MIT
pragma solidity ^0.8.16;

contract Lottery {
    //keeps track of state of current betting round
    enum State {
        IDLE,
        BETTING
    }

    //keeps track of all players in lottery
    address payable[] public players;

    //keeps track of the current state (default: IDLE)
    State public currentState = State.IDLE;

    //max number of players in each betting round
    uint public MaxNumPlayers;

    //players can only bet this amount
    uint public moneyRequiredToBet;

    //rake
    uint public houseFee;

    address public admin;

    constructor(uint fee) {
        require(fee > 1, "Fee should be greater than 1");
        admin = msg.sender;
        houseFee = fee;
    }

    //create a new betting round which will change the state to State.BETTING
    function createBet(uint numPlayers, uint betMoney) external inState(State.IDLE) onlyAdmin() {
        MaxNumPlayers = numPlayers;
        moneyRequiredToBet = betMoney;

        //indicates betting round is live
        currentState = State.BETTING;
    }

    //allow players to bet in the current round
    //if the max number of players is reached, the round is ended and we decide the winner
    function bet() external payable inState(State.BETTING) {
        require(msg.value == moneyRequiredToBet, "You may only bet the exact amount of Ether set as the limit");
        players.push(payable(msg.sender));
        if(players.length == MaxNumPlayers) {
            //picks a winner (In the future, we can add Verifiable Randomness from Chainlink)
            uint winner = _randomModulo(MaxNumPlayers);
            //sends money to winner
            players[winner].transfer((moneyRequiredToBet * MaxNumPlayers) * (100 - houseFee) / 100);
            //updates state to IDLE
            currentState = State.IDLE;
            //clears data, removes players from betting round
            delete players;
        }
    }

    //cancels the current betting rounder
    function cancel() external inState(State.BETTING) onlyAdmin() {
        for(uint i = 0; i < players.length; i++) {
            players[i].transfer(moneyRequiredToBet);
        }
        //clears data, removes players from betting round
        delete players;

        //updates state to IDLE
        currentState = State.IDLE;
    }

    //combines timestamp and difficulty to produce random number less than param entered
    function _randomModulo(uint modulo) view internal returns(uint) {
        uint randomNumber;

        //abi.encodePacked combines the values, keccak256 hashes the value
        randomNumber = uint(keccak256((abi.encodePacked((block.difficulty, block.timestamp)))));
        randomNumber = randomNumber % modulo;

        return randomNumber;
    }

    modifier inState(State state) {
        require(state == currentState, "The current state does not allow this");
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only an admin can perform this action");
    }

}