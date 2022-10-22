// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


abstract contract Level {
  function createInstance() virtual public payable returns (address _instance,uint _points,uint _timeBonus);
  function validateInstance(address _instance,address _player) virtual public returns (bool);
}

