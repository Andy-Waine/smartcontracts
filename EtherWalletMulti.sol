// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

/*  
A wallet that can be used by multiple people. Keeps track of balances for 
each user using mapping. 
*/
contract EtherWalletMulti {

    // Keeps track of multiple users and their balances
    mapping(address => uint256) private wallets;

    // No constructor needed 

    // Update the deposit function to handle keeping track of multiple users and 
    // their balances
    function deposit() payable public {
        wallets[msg.sender] += msg.value;
    }

    // Add a new function to handle transferring the ETH between multiple users
    // within the smart contract wallet 
    function transfer(address payable receiver, uint amount) public {
        require(
            wallets[msg.sender] >= amount, "Not enough money in the wallet"
        );
        wallets[msg.sender] -= amount;
        wallets[receiver] += amount;
    }

    // Update the withdraw function to handle the withdrawal from the smart contract
    // to the user wallet
    function withdraw(uint amount) public {
        address payable receiver = payable(msg.sender);
        require(
            wallets[msg.sender] >= amount, "Not enough money in the wallet"
        );
        wallets[msg.sender] -= amount;
        receiver.transfer(amount);
    }

    // Add a function to view the current balance for your own wallet
    function myBalance() view public returns(uint) {
        return wallets[msg.sender];
    }
}
