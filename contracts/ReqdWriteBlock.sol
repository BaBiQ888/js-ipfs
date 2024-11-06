// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract ReadWriteBlock {

    uint256 public A;

    function getBlockTimestamp() external view returns (uint256) {
        return block.timestamp;
    }

    function getBlockNumber() external view returns (uint256) {
        return block.number;
    }

    function getBlockHash() external view returns (bytes32) {
        return blockhash(block.number);
    }

    function setA(uint256 value) external {
        A = value;
    }
}