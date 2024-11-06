// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IConstant {
    function getAllCons()
        external
        view
        returns (
            uint16,
            uint16,
            uint16,
            uint16,
            uint16,
            uint16,
            uint16,
            uint16,
            uint16,
            uint16,
            uint16,
            uint16
        );

    function getOnline() external view returns (uint16);

    function getRendering() external view returns (uint16);

    function getOffline() external view returns (uint16);

    function getCpu() external view returns (uint16);

    function getMemory() external view returns (uint16);

    function getGraphicsCard() external view returns (uint16);

    function getHardDisk() external view returns (uint16);

    function getIP() external view returns (uint16);

    function getCpuWeights() external view returns (uint16);

    function getMemWeights() external view returns (uint16);

    function getGraphicsCardWeights() external view returns (uint16);

    function getHardDiskWeights() external view returns (uint16);

    function getTotalTokenIssuance() external view returns (uint256);

    function getStakeAmountLimit() external view returns (uint256);

    function setStakeAmountLimit(uint256 value) external returns (bool);
}
