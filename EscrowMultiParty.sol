// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

contract EscrowMultiParty {
    address public buyer; // 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    //Keep track of the multiple sellers rather than a single seller  
    // 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db, 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
    address payable[] public sellers;
    address public escrowParty; // 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    // Can use https://eth-converter.com/ to convert ether to wei
    uint public amount; // 1000000000000000000 WEI = 1 ETH
    
    // The escrow party deploys the contract with the buyer and seller info 
    // along with the amount of Ether needed to purchase the item
    constructor(address _buyer, address payable[] memory _sellers, uint _amount) {
        buyer = _buyer;
        sellers = _sellers;
        escrowParty = msg.sender; 
        amount = _amount;
    }

    function deposit() public payable {}

    
    //escrow party calls this function to send the money to the sellers
    function release() public onlyEscrowParty() {
         require(address(this).balance >= amount, "Cannot release funds until at least the full amount is sent.");
         for (uint i = 0; i <= sellers.length - 1; i++) {
            //If multiple sellers, this splits the funds into an equal ratio
            sellers[i].transfer(amount / sellers.length);
         }
    }
    
    function balanceOf() view public returns(uint) {
        return address(this).balance;
    }

    //Establishes new escrow party (inserted as a param) when called
    function changeEscrow(address _newEscrowParty) public onlyEscrowParty {
        escrowParty = _newEscrowParty;
    }

    modifier onlyEscrowParty() {
        require(msg.sender == escrowParty, 'Only escrow party can perform this operation');
        _;
    }
}