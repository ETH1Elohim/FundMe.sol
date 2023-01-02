// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FallbackExample {
    uint256 public result;

    // receive triggered when ETH sent to contract
    receive() external payable{
        result = 1;
    }

    fallback() external payable {
        result = 2;
    }
}




// https://solidity-by-example.org/fallback/
// Ether is sent to contract
//      is msg.data empty?
//        /     \
//      yes     no
//      /        \
//  receive()?    fallback()
//  yes   no
//  /        \
// receive()  fallback()
