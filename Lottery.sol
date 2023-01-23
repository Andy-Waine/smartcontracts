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
        
    }

}