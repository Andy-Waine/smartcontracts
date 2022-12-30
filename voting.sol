// SPDX-License-Identifier: GPL-3.0
/*
    WARNING: Please note that this contract has not been audited and as such may not be feasible 
    to deploy to the mainnet as is. The contract acts only as an example to showcase how to develop
    smart contracts in Solidity. It may contain vulnerabilities that are unaccounted for and as such,
    should not be used in real environment. Do your own diligence before deploying any smart contracts
    to the blockchain because once deployed, you cannot modify the contract.
*/
pragma solidity >=0.7.0 <0.9.0

contract Voting {

    struct Voter {
        uint weight; //an integer that reflects the share of one's vote relative to the group's
        bool voted; //a boolean that reflects true if the Voter has voted
        address delegate; //Is this the proposal that the vote is going to? Or the address of the voter?
        uint vote; //index of vote within its parent array
    }

    struct Proposal {
        bytes32 name; //name of the proposal (up to 32 bytes/characters)
        uint voteCount; //number of accumulated votes
    }

    address public chairperson; //the wallet address of the chairperson

    //this declares a new variable 'voters'
    //mapping assigns a key(address)-value(Voter) pair
    //this key-value pair is what the new var 'voters' represents
    mapping(address => Voter) public voters;

    //this declares a new array 'proposals' of Proposal structs
    Proposal[] public proposals;

    //constructor: a function that invokes only once upon contract deployment, initializes contract state
    //declares proposalNames as a param
    constructor(bytes32[] memory proposalNames) {
        //msg.sender is the account calling for execution of the 'Voter' contract
        //msg.sender can either be a human user (as it is in this case) or another contract on-chain
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    function giveRightToVote(address voter) external {
       //BEGIN REQUIRES (stops execution if failed)
            require(
                msg.sender == chairperson,
                //Else statement produced if the argument fails
                "Only the chairperson can give another the right to vote."
            );

            //translation: verify this indexed 'voter' within the 'voters' kvp var has NOT voted
            //ELSE, return an error string (and stop execution)
            require(!voters[voter].voted, "The voter has already voted.")

            //translation: verify this indexed 'voter' within the 'voters' kvp var has NOT been assigned a weight
            require(voters[voter].weight == 0);
       //END REQUIRES

       //BEGIN LOGIC
            voters[voter].weight = 1;
       //END LOGIC
    }
}