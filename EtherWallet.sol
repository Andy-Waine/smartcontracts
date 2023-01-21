// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract EtherWallet {
    //allow one peron (the deployer) to send to/withdraw from wallet
    //This will be a single-person Ether wallet
    //Implement the "deposit()" and "withdraw()" function
    //Implement the "balanceof()" function to retrieve current wallet balance

    address payable public owner;

    constructor(address payable _owner) {
        owner = _owner;
    }

    function deposit() payable public {

    }

    function withdraw(address payable receiver, uint amount) public {
        require(msg.sender == owner, "Only the owner can withdraw Ether from this wallet");

        //the transfer method stems from the 'payable' nature of withdraw()
        receiver.transfer(amount);
    }

    function balanceOf() view public returns(uint) {
        return address(this).balance;
    }
}
