// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract ReadWriteVar {
    mapping(uint256 => uint256) public varMap;

    mapping(uint256 => uint256[]) public varMapArray;

    uint256[] public varUintArray;

    string[] public varStringArray;

    uint256 public varUint256;

    string public varString;

    function setVarMap(uint256 key, uint256 value) external {
        varMap[key] = value;
    }

    function getVarMap(uint256 key) external view returns (uint256) {
        return varMap[key];
    }

    function pushVarMapArray(uint256 key, uint256 value) external {
        varMapArray[key].push(value);
    }

    function getVarMapArray(
        uint256 key
    ) external view returns (uint256[] memory) {
        return varMapArray[key];
    }

    function setVarMapArray(uint256 key, uint256[] memory valueArr) external {
        varMapArray[key] = valueArr;
    }

    function pushVarUintArray(uint256 value) external {
        varUintArray.push(value);
    }

    function setVarUintArray(uint256[] memory value) external {
        varUintArray = value;
    }

    function getVarUintArray() external view returns (uint256[] memory) {
        return varUintArray;
    }

    function pushVarStringArray(string memory value) external {
        varStringArray.push(value);
    }

    function setVarStringArray(string[] memory value) external {
        varStringArray = value;
    }

    function getVarStringArray() external view returns (string[] memory) {
        return varStringArray;
    }

    function setVarUint256(uint256 value) external {
        varUint256 = value;
    }

    function getVarUint256() external view returns (uint256) {
        return varUint256;
    }

    function setVarString(string memory value) external {
        varString = value;
    }

    function getVarString() external view returns (string memory) {
        return varString;
    }
}
