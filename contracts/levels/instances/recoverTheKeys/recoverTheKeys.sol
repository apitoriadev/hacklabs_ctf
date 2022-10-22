// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// recover the keys
contract RecoverTheKeys {

    mapping(uint => uint) dataBase;
    bool public foundTheSecret;
    bool initialized;
    
    function setData(uint _val) external  {
        assembly{
            let freeMP := mload(0x40)
            mstore(0x00,_val)
            mstore(freeMP,keccak256(0x00,0x20))
            mstore(add(freeMP,0x20),0x00)
            sstore(keccak256(freeMP,0x40),_val)
        }
        initialized = true;
    }

    function win(uint _location) external {
        require(initialized);
        require(dataBase[_location] == 88);
        foundTheSecret = true;
    }

}


