// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


error notcalledDirectly();
error alreadyFoundNum();


contract Guess {

    bool public foundTheSecret;

    function find(uint _guess) external {
        if(msg.sender == tx.origin){
            revert notcalledDirectly();
        }
        if(foundTheSecret){
            revert alreadyFoundNum();
        }
        uint _answer = uint(keccak256(abi.encodePacked(block.timestamp,block.number-1,msg.sender))) % 100;
        if(_guess == _answer){
            foundTheSecret = true;
        }
    }

}
