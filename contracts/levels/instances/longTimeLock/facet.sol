// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


error  tooEarly(uint timeLeft);


contract Facet {

    uint public timeZone;
    bool public unlocked;
    uint public constant waitTime = 100 days;
  
    function setTimeZone(uint _timeZone) external {
        timeZone = _timeZone;
    }

    function unlock() external {
        if(block.timestamp < block.timestamp + waitTime){
            revert tooEarly(waitTime);
        }
        unlocked = true;
    }

}