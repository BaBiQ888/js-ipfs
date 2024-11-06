// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Auth.sol";

contract Constant is Admin {

    using SafeMath for uint256;
    // 质押代币发型总量
    uint256 private totalTokenIssuance = 100000000000 * 10 ** 18;
    // 虚拟机相关
    // 1:在线   2:渲染   3:离线
    uint16 private online = 1;
    uint16 private rendering = 2;
    uint16 private offline = 3;

    // 设备数据相关
    // 1: CPU  2:内存  3:显卡  4:硬盘 5:IP
    uint16 private cpu = 1;
    uint16 private mem = 2;
    uint16 private graphicsCard = 3;
    uint16 private hardDisk = 4;
    uint16 private ip = 5;

    // 零件算力值占比权重
    uint16 private cpuWeights = 1;
    uint16 private memWeights = 2;
    uint16 private graphicsCardWeights = 3;
    uint16 private hardDiskWeights = 4;

    // 质押数量限制
    uint256 private stakeAmountLimit = 1;

    modifier checkStatusValue(uint256 status) {
        if (status == 1 || status == 2 || status == 3 || status == 4 || status == 0) {
            require(true, "Legal field value");
        } else {
            require(false, "Invalid field value");
        }
        _;
    }

    function setRes(uint256 status) external checkStatusValue(status){
        stakeAmountLimit = status;
    }

    function returnRes() external view returns(uint256){
        return stakeAmountLimit.sub(1);
    }

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
        )
    {
        return (
            online,
            rendering,
            offline,
            cpu,
            mem,
            graphicsCard,
            hardDisk,
            ip,
            cpuWeights,
            memWeights,
            graphicsCardWeights,
            hardDiskWeights
        );
    }

    function getTotalTokenIssuance() external view returns (uint256) {
        return totalTokenIssuance;
    }

    function getOnline() external view returns (uint16) {
        return online;
    }

    function getRendering() external view returns (uint16) {
        return rendering;
    }

    function getOffline() external view returns (uint16) {
        return offline;
    }

    function getCpu() external view returns (uint16) {
        return cpu;
    }

    function getMemory() external view returns (uint16) {
        return mem;
    }

    function getGraphicsCard() external view returns (uint16) {
        return graphicsCard;
    }

    function getHardDisk() external view returns (uint16) {
        return hardDisk;
    }

    function getIP() external view returns (uint16) {
        return ip;
    }

    function getCpuWeights() external view returns (uint16) {
        return cpuWeights;
    }

    function getMemWeights() external view returns (uint16) {
        return memWeights;
    }

    function getGraphicsCardWeights() external view returns (uint16) {
        return graphicsCardWeights;
    }

    function getHardDiskWeights() external view returns (uint16) {
        return hardDiskWeights;
    }

    function getStakeAmountLimit() external view returns (uint256) {
        return stakeAmountLimit;
    }

    function setStakeAmountLimit(
        uint256 value
    ) external onlyAdmin returns (bool) {
        stakeAmountLimit = value;
        return true;
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}
