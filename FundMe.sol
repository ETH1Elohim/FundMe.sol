//Get funds from users
//Withdraw funds
//Set a minimum funding value in USD

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;
    // constant saves gas
    // 21,415 gas - constant vs. 23,515 gas - non constant

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;
    //

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable{
        // msg.value.getConversionRate();
        // set minimum fund amount in USD
        // send ETH to contract
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough!"); 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value; 
    }

    // anyone can fund but we don't want anyone to be able to withdraw
    
    // how to know about funders:
    function withdraw() public onlyOwner {
        // for loop: (starting index; ending index (boolean in this example); step amount)
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex = funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        // 3 WAYS TO SEND ETHER - link: https://solidity-by-example.org/sending-ether/ 
        // virtually call any function within Ethereum 
        // Using call is currently the recommended way to send or receive blockchain native tokens
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
        revert();
    }

    // can use modifiers to improve functionality
    modifier onlyOwner {
      //  require(msg.sender == i_owner, "Sender is not owner!");
      // v more gas efficient
      if(msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    receive() external payable{
        fund();
    }

    fallback() external payable {
        fund();
    }

}
