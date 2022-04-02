// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  constructor(address exampleExternalContractAddress) public {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }


    mapping(address=>uint256) public balances;
    uint256 public constant threshhold = 1 ether;
    uint256 public deadline = block.timestamp + 90 seconds;
    bool executed = false;
    bool openForWithdraw = false;
    event Stake(address staker, uint256 value);


  function stake() public payable{
        balances[msg.sender] = msg.value;
      emit Stake(msg.sender, msg.value);
  }

    function execute()public returns(bool){
        uint256 time = timeLeft();
        if (time>0){
            return false;
            }

        if (executed){
            return false;
        }
        if (address(this).balance >=threshhold){
            exampleExternalContract.complete{value: address(this).balance}();
            executed = true;
            return true;
            }
        openForWithdraw = true;
        executed = true;
        return true;
    }

    function withdraw()public returns(bool){
        if(openForWithdraw) return true;
        return false;
    }

  function timeLeft()public view returns(uint256) {
      if (block.timestamp >= deadline) return 0;
      uint256 left = deadline - block.timestamp;
      return left;
  }
    receive() external payable{
    stake();
    }


  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )


  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value


  // if the `threshold` was not met, allow everyone to call a `withdraw()` function


  // Add a `withdraw()` function to let users withdraw their balance


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend


  // Add the `receive()` special function that receives eth and calls stake()


}
