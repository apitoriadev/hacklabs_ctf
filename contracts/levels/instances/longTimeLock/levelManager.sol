// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import { LongTimeLockProxy } from "./longTimeLock.sol";
import { Facet } from "./facet.sol";


contract LongTimeLockLevelManager  {

    uint public points;
    uint public timeBonus;
    Facet facet;

    constructor(uint _points,uint _timeBonus){
        points = _points;
        timeBonus = _timeBonus;
        facet = new Facet();
    }

    function createInstance() virtual public payable returns (address _instance,uint _points,uint _timeBonus){
        LongTimeLockProxy _ins = new LongTimeLockProxy();
        return (address(_ins),points,timeBonus);
    }
    function validateInstance(address payable _instance,address _player) virtual public returns (bool){
       LongTimeLockProxy _ins = LongTimeLockProxy(_instance);
       return _ins.unlocked();
    }
  
}
