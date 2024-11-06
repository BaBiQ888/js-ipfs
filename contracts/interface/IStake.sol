// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IStake {
    function _initToken(address tokenAddress, address consAddress) external;

    function _stake(address acc, uint256 _amount) external;

    function _unStake(address acc, uint256 amount) external;

    function _withdraw(address acc, uint256 _amount) external;

    function _approve() external;

    function _increaseAllowance(address owner) external;

    function _balanceOf(address msgSender) external view returns (uint256);

    function _allowance(address msgSender) external view returns (uint256);
}
