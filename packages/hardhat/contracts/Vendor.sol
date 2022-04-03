pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  //event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
    function buyTokens()public payable{
        uint256 value = msg.value*tokensPerEth;
        yourToken.transfer(msg.sender, value);
        emit BuyTokens(msg.sender, msg.value, value);
    }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH

  function sellTokens(uint256 amount)public payable{
    yourToken.transferFrom(msg.sender, address(this), amount);
      uint256 ethAmount = uint(amount)/uint(tokensPerEth);
      address payable sender = payable(msg.sender);
      sender.transfer(ethAmount);
  }

}
