// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import { EasyStart } from "./easystart.sol";


contract EasystartLevelManager  {

    uint public points;
    uint public timeBonus;

    constructor(uint _points,uint _timeBonus){
        points = _points;
        timeBonus = _timeBonus;
    }

    function createInstance() virtual public payable returns (address _instance,uint _points,uint _timeBonus){
        EasyStart _ins = new EasyStart();
        return (address(_ins),points,timeBonus);
    }
    function validateInstance(address payable _instance,address _player) virtual public returns (bool){
        EasyStart _ins = EasyStart(_instance);
        if(_ins.solved()){
            return true;
        }
        return false;
    }
  
}

