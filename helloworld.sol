// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

// THIS CONTRACT HAS NOT BEEN AUDITED, THEREFORE,
// IT IS NOT SUITABLE TO BE USED IN A PRODUCTION ENVIRONMENT

contract HelloWorld {
    string public message;
    
    constructor (string memory initialMessage) {
        message = initialMessage;
    }

    function (string memory newMessage) {
        message = newMessage;
    }
}
