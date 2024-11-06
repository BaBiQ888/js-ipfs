// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;


import "./library/BokkyPooBahsDateTimeLibrary.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract test  {
    using SafeMath for uint256;
    using Math for uint256;
    uint256 one = 0;
    uint256 public two = 27000;
    uint256 three = 3;
    uint256 res = 0;

     mapping(uint16 => uint256) public deviceComputePowerData;


    function condition() external view {
        require(three-res > 0, "sssss");
    }

     function testSub()external {
       two = two.sub(27001);
     }


     function addDeviceComputePowerData(
        uint16 componentsType,
        uint256 data
    ) external {
        deviceComputePowerData[componentsType] = data;
    }

     function computePowerValue() public view returns (uint256) {
        uint16 count = 6;
        uint256 gpuCpuMemNetValue = 1;
        uint256 hddValue = 1;
        for (uint16 i = 1; i <= count; i++) {
            if (i < count) {
                gpuCpuMemNetValue = gpuCpuMemNetValue.mul(
                    deviceComputePowerData[i]
                );
            } else {
                hddValue = deviceComputePowerData[i];
            }
        }
        gpuCpuMemNetValue = gpuCpuMemNetValue.mul(
            9000
        );
        hddValue = hddValue.mul(1000).mul(10000000000000000);
        uint256 totalPowerValue = gpuCpuMemNetValue.add(hddValue).div(
            100000000000000000000
        );
        return totalPowerValue;
    }

    // event Log(address dd);

    function _checkSign(address validator_, uint256 duration_, address winner_, 
        string memory max_hash_, bytes memory sign_) external returns (bool) {
        bytes32 dd = keccak256(abi.encodePacked(duration_, winner_, max_hash_));
        // emit Log(ECDSA.recover(dd, sign_));
        return ECDSA.recover(dd, sign_) == validator_;
    }
}