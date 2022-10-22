// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Level } from './levels/Level.sol';
import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';
import { Pausable} from '@openzeppelin/contracts/security/Pausable.sol';

/******************************************************************************\
* HackLans ctf Medellin 
*
* good luck, and happy hacking.
/******************************************************************************/

struct EmittedInstanceData {
    address player;
    address level;
    bool completed;
}

struct EmittedLevel {
    bool registered;
    uint points;
    uint timeBonus;
}

error levelNotRegistered(address _attempt);
error alreadyCompleted();
error notplayer(address _attempt);
error levelAlreadyConquered(address _level);


contract HackLabManager is Ownable, Pausable {

    event LevelInstanceCreatedLog(address indexed player, address instance);
    event LevelCompletedLog(address indexed player,address level);

    mapping(address => EmittedLevel) public registeredLevels;
    mapping(address => EmittedInstanceData) public emittedInstances;
    mapping(address => uint) public totalPointsPerPlayer;
    mapping(address => mapping(address => bool)) public conqueredLevels;

    address public winner;

    function createLevelInstance(address _levelAddress) external payable returns (address) {
        Level _level = Level(_levelAddress);
        if(!registeredLevels[_levelAddress].registered){
            revert levelNotRegistered(_levelAddress);
        }
        (address _instance,uint _points,uint _timeBonus) = _level.createInstance{value: msg.value}();
        if(registeredLevels[_levelAddress].points == 0){
                EmittedLevel storage _dataLevel = registeredLevels[_levelAddress];
            _dataLevel.points = _points;
            _dataLevel.timeBonus = _timeBonus;
        }
        emittedInstances[_instance] = EmittedInstanceData(msg.sender,_levelAddress,false);

        emit LevelInstanceCreatedLog(msg.sender, _instance);
        return _instance;
    }

    function submitLevelInstance(address _instance) external whenNotPaused {
        EmittedInstanceData storage _dataInstance = emittedInstances[_instance];
        if(_dataInstance.player != msg.sender){
            revert notplayer(msg.sender);
        }
        if(_dataInstance.completed){
            revert alreadyCompleted();
        }
        if(conqueredLevels[_dataInstance.player][_dataInstance.level]){
            revert levelAlreadyConquered(_dataInstance.level);
        }
        EmittedLevel storage _dataLevel = registeredLevels[_dataInstance.level];
        Level _level = Level(_dataInstance.level);
        if(_level.validateInstance(_instance,msg.sender)){
            uint _timeBonus;
            if(_dataLevel.timeBonus > 0){
                _timeBonus = _dataLevel.timeBonus; 
                _dataLevel.timeBonus--;
            }
            _dataInstance.completed = true;
            conqueredLevels[_dataInstance.player][_dataInstance.level] = true;
            totalPointsPerPlayer[_dataInstance.player] += (_dataLevel.points + _timeBonus);
            emit LevelCompletedLog(msg.sender,_dataInstance.level);
        }
    }

    function applyForFirstPlace() external whenNotPaused {
        if(totalPointsPerPlayer[msg.sender] > totalPointsPerPlayer[winner]){
            winner = msg.sender;
        }
    }

    function registerLevel(address _level) external onlyOwner {
        registeredLevels[_level].registered = true;
    }

    function pauseHackLabs() external onlyOwner {
        _pause();
    }

}

