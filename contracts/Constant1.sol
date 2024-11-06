// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Admin is Ownable {
    mapping(address => bool) private _admins;

    modifier onlyAdmin() {
        require(_admins[msg.sender], "Only admin can call it");
        _;
    }

    function addAdmin(address _admin) public onlyOwner {
        _admins[_admin] = true;
    }

    function delAdmin(address _admin) public onlyOwner {
        _admins[_admin] = false;
    }

    function isAdmin(address _addr) public view returns (bool) {
        return _admins[_addr];
    }
}

contract AuthVerify is Admin {
    mapping(string => address) authVerify;

    function addCaller(
        string[] memory keys,
        address[] memory caller
    ) external onlyOwner{
        for (uint i = 0; i < keys.length; i++) {
            authVerify[keys[i]] = caller[i];
        }
    }

    function getCaller(string memory key) external view returns (address) {
        return authVerify[key];
    }

    function onlyCaller(
        string memory key,
        address caller
    ) external view returns (bool) {
        return caller == authVerify[key];
    }
}

contract VertexConstant is AuthVerify {
    // The total amount of pledged tokens
    uint256 public constant totalTokenIssuance = 100000000000 * 10 ** 18;
    // Virtual machine related constants
    uint16 public constant online = 1;
    uint16 public constant rendering = 2;
    uint16 public constant offline = 3;

    // Device data related constants
    string[] public deviceInfoKeys;
    mapping(string => uint16) public devicePartInfoCons; // 不允许修改  不允许删除

    // The proportion weight of the computing power value of the part
    string[] public devicePowerInfoKeys;
    mapping(string => uint16) public devicePowerInfoCons;

    // Pledge Quantity Limit
    uint256 public stakeAmountLimit = 10 * 10 ** 18;

    // Remaining minimum pledge amount
    uint256 public constant remainingMinStakeAmount = 1 * 10 ** 18;

    uint16 public deviceConsCount = 0;

    uint16 public devicePowerConsCount = 0;

    uint256 public reportVmDataDiffTimestamp = 604800;

    uint256 public GpuCpuMemNetWeight = 9000;

    uint256 public HddWeight = 1000;

    function getGpuCpuMemNetWeight() external view returns (uint256) {
        return GpuCpuMemNetWeight;
    }

    function getHddWeight() external view returns (uint256) {
        return HddWeight;
    }

    function addDeviceInfoCons(string memory typeParam) external {
        require(this.onlyCaller("Vertex", msg.sender), "verify auth error");
        if (devicePartInfoCons[typeParam] == 0) {
            deviceInfoKeys.push(typeParam);
            deviceConsCount++;
            devicePartInfoCons[typeParam] = deviceConsCount;
        }
    }

    function delDeviceInfoCons(string memory consName) external {
        for (uint i = 0; i < deviceInfoKeys.length; i++) {
            if (
                hashCompareWithLengthCheckInternal(deviceInfoKeys[i], consName)
            ) {
                if (i < deviceInfoKeys.length - 1) {
                    string memory tmp = deviceInfoKeys[
                        deviceInfoKeys.length - 1
                    ];
                    deviceInfoKeys[deviceInfoKeys.length - 1] = deviceInfoKeys[
                        i
                    ];
                    deviceInfoKeys[i] = tmp;
                }
                deviceInfoKeys.pop();
                break;
            }
        }
    }

    function hashCompareWithLengthCheckInternal(
        string memory a,
        string memory b
    ) internal pure returns (bool) {
        if (bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return
                keccak256(abi.encodePacked(a)) ==
                keccak256(abi.encodePacked(b));
        }
    }

    function getDeviceInfoCons(
        string memory deviceInfoTypeCons
    ) external view returns (uint16) {
        return devicePartInfoCons[deviceInfoTypeCons];
    }

    function addDevicePowerInfoCons(string memory powerPart) external {
        require(this.onlyCaller("Vertex", msg.sender), "verify auth error");
        if (devicePowerInfoCons[powerPart] == 0) {
            devicePowerInfoKeys.push(powerPart);
            devicePowerConsCount++;
            devicePowerInfoCons[powerPart] = devicePowerConsCount;
        }
    }

    function setStakeAmount(uint256 value) external returns (bool) {
        require(this.onlyCaller("Vertex", msg.sender), "verify auth error");
        stakeAmountLimit = value * 10 ** 18;
        return true;
    }

    function getDeviceConsCount() external view returns (uint16) {
        return deviceConsCount;
    }

    function getDevicePowerConsCount() external view returns (uint16) {
        return devicePowerConsCount;
    }

    function getDevicePowerInfoCons(
        string memory param
    ) external view returns (uint16) {
        return devicePowerInfoCons[param];
    }

    function getDeviceInfoKeys() external view returns (string[] memory) {
        return deviceInfoKeys;
    }

    function getDevicePowerInfoKeys() external view returns (string[] memory) {
        return devicePowerInfoKeys;
    }

    function getStakeAmountLimit() external view returns (uint256) {
        return stakeAmountLimit;
    }

    function getMinStakeAmount() external pure returns (uint256) {
        return remainingMinStakeAmount;
    }

    function getOnline() external pure returns (uint16) {
        return online;
    }

    function getRendering() external pure returns (uint16) {
        return rendering;
    }

    function getOffline() external pure returns (uint16) {
        return offline;
    }

    function getTotalTokenIssuance() external pure returns (uint256) {
        return totalTokenIssuance;
    }

    function getReportVmDataDiffTimestamp() external view returns (uint256) {
        return reportVmDataDiffTimestamp;
    }
}