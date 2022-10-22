// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;



contract RetirementSavings {

    uint startBalance;
    uint expiration;
    address owner;

    constructor() payable {
        require(msg.value == .001 ether);
        expiration = block.timestamp + 100 days;
        startBalance = .001 ether;
        owner = 0xE7351d0B85f4D88dED9c39C71D1685820680ca8A;
    }

    function withdraw() external {
        require(msg.sender == owner);

        if (block.timestamp < expiration) {
            payable(msg.sender).transfer(address(this).balance * 9 / 10);
        } else {
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    function collectPenalty() external {
        uint256 withdrawn = address(this).balance - startBalance;
        require(withdrawn > 0);
        payable(msg.sender).transfer(address(this).balance);
    }
}
