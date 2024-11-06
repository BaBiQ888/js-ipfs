// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfae/IConstant.sol";
import "./Auth.sol";

contract Stake is Admin {
    using SafeERC20 for IERC20;

    IERC20 private token =
        IERC20(address(0x816AC81F0B32453153721a4ED8D223D6D560643b));

    IConstant private cons =
        IConstant(address(0x0582955206bFAA4ee8AbbeE39d2F6a7F4Dc6C365));

    event InitTokenEvent(address token, address cons);

    event WithdrawalEvent(uint amount, uint when);

    event StakeEvent(address from, address to, uint256 amount);

    event UnStakeEvent(address from, address to, uint256 amount);

    function _initToken(
        address tokenAddress,
        address consAddress
    ) external onlyAdmin {
        emit InitTokenEvent(tokenAddress, consAddress);
        token = IERC20(tokenAddress);
        cons = IConstant(consAddress);
    }

    // 质押
    function _stake(address acc, uint256 _amount) external onlyAdmin {
        token.safeTransferFrom(acc, address(this), _amount);
        emit StakeEvent(acc, address(this), _amount);
    }

    // 解除质押
    function _unStake(address acc, uint256 amount) external onlyAdmin {
        token.safeTransferFrom(address(this), acc, amount);
        emit UnStakeEvent(address(this), acc, amount);
    }

    // 提现奖励
    function _withdraw(address acc, uint256 _amount) external onlyAdmin {
        token.safeTransferFrom(address(this), acc, _amount);
        emit WithdrawalEvent(address(this).balance, block.timestamp);
    }

    function _balanceOf(address msgSender) external view returns (uint256) {
        return token.balanceOf(msgSender);
    }

    function _approve() external onlyAdmin {
        token.safeApprove(address(this), cons.getTotalTokenIssuance());
    }

    function _increaseAllowance() external onlyAdmin {
        token.safeIncreaseAllowance(
            address(this),
            cons.getTotalTokenIssuance()
        );
    }

    function getValue()public view returns(uint256){
       return cons.getTotalTokenIssuance();
    }
   
}
