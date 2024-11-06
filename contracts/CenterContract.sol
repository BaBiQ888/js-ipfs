// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfae/IConstant.sol";
import "./interfae/IStake.sol";
import "./Auth.sol";
import "./library/BokkyPooBahsDateTimeLibrary.sol";

contract CenterContract is Server {

    IConstant private iCons;

    IStake private iStake;


    function initContract(address stake) external {
        iStake = IStake(stake);
    }

    // 初始化ERC20代币
    function initToken(
        address erc20Token,
        address consAddress
    ) public onlyAdmin returns (bool) {
        iStake._initToken(erc20Token, consAddress);
        return true;
    }

    function approveStake() public onlyAdmin {
        iStake._approve();
    }

     function getCurrentDayTimestamp() public view returns(uint256){
        return BokkyPooBahsDateTimeLibrary.timestampToDayTimeStamp(block.timestamp);
     }

    function mid(uint256 value) public pure returns(uint256){
        value = 10 * value;
        return value;
    }
}
