// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import { RecoverTheKeys } from "./recoverTheKeys.sol";


contract RecoverTheKeysLevelManager  {

    uint public points;
    uint public timeBonus;

    constructor(uint _points,uint _timeBonus){
        points = _points;
        timeBonus = _timeBonus;
    }

    function createInstance() virtual public payable returns (address _instance,uint _points,uint _timeBonus){
        RecoverTheKeys _ins = new RecoverTheKeys();
        return (address(_ins),points,timeBonus);
    }
    function validateInstance(address _instance,address _player) virtual public returns (bool){
        RecoverTheKeys _ins = RecoverTheKeys(_instance);
        return _ins.foundTheSecret();
    }
  
}
