//SPDX License-Identifier: MIT
pragma solidity ^0.8.16;

contract Escrow {
    address public buyer;
    address payable public seller;
    address public escrowParty;
    uint public amount;

    constructor(address _buyer, address payable _seller, uint _amount) {
        buyer = _buyer;
        seller = _seller;
        escrowParty = msg.sender;
        amount = _amount;
    }

    function deposit() payable public {
        require(msg.sender == buyer, "Funds may not be sent from anyone but the buyer.");
        require(address(this).balance <= amount, "cannot send more than the amount required.");
    }

    //'release()' is the function, 'onlyEscrowParty()' is the modifier
    function release() public onlyEscrowParty(){
        require(address(this).balance == amount, "Cannot release funds until full amount is sent.");
        seller.transfer(amount);
    }

    modifier onlyEscrowParty() {
        require(msg.sender == escrowParty, "Only the escrow party may perform this operation.");
    }

}