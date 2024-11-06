// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

library Uint256 {

    function Uint256ToBytes(uint256 x) internal pure returns (bytes memory b) {
        b = new bytes(32);
        assembly {mstore(add(b, 32), x)}
    }

    function BytesToUint256(bytes memory b) internal pure returns (uint256){
        uint256 number;
        for (uint i = 0; i < b.length; i++) {
            number = number + uint8(b[i]) * (2 ** (8 * (b.length - (i + 1))));
        }
        return number;
    }

}

library Bytes {
    function BytesToUint256(bytes memory b) internal pure returns (uint256){
        uint256 number;
        for (uint i = 0; i < b.length; i++) {
            number = number + uint8(b[i]) * (2 ** (8 * (b.length - (i + 1))));
        }
        return number;
    }

    function BytesToString(bytes memory source) internal pure returns (string memory result) {
        return string(source);
    }

    function BytesToAddress(bytes memory bys) internal pure returns (address addr){
        assembly {
            addr := mload(add(bys, 20))
        }
    }

    function Decode(bytes memory signedString, string memory d) public pure returns (address){
        bytes32 r = bytesToBytes32(slice(signedString, 0, 32));
        bytes32 s = bytesToBytes32(slice(signedString, 32, 32));
        uint8 v = uint8(signedString[64]);
        bytes32 dd = keccak256(abi.encodePacked(d));
        return ecrecoverDecode(r, s, v, dd);
    }

    function slice(bytes memory data, uint start, uint len) internal pure returns (bytes memory){
        bytes memory b = new bytes(len);
        for (uint i = 0; i < len; i++) {
            b[i] = data[i + start];
        }
        return b;
    }

    function ecrecoverDecode(bytes32 r, bytes32 s, uint8 v1, bytes32 d) internal pure returns (address addr){
        uint8 v = uint8(v1);
        if (v == 0 || v == 1) {
            v = v+27;
        }
        addr = ecrecover(d, v, r, s);
    }

    function bytesToBytes32(bytes memory source) internal pure returns (bytes32 result){
        assembly{
            result := mload(add(source, 32))
        }
    }
}

interface IERC721Token {

    /**
     * @dev Returns the number of NFTs in `owner`'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the NFT specified by `tokenId`.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     *
     *
     * Requirements:
     * - `from`, `to` cannot be zero.
     * - `tokenId` must be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this
     * NFT by either {approve} or {setApprovalForAll}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * Requirements:
     * - If the caller is not `from`, it must be approved to move this NFT by
     * either {approve} or {setApprovalForAll}.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    function approve(address to, uint256 tokenId) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(address owner, address operator) external view returns (bool);


    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    function safeMint(address to) external returns (uint256);

    function safeMint(address to, uint256 tokenId) external returns (uint256);

    function exists(uint256 tokenId) external returns (bool);

    function mint(address to) external returns (uint256);
    function mint(address to, bytes memory _data) external returns (uint256);
    function mint(uint256 len, address to) external returns (uint256[] memory);
    function mint(uint256 len, address to, bytes memory _data) external returns (uint256[] memory);
    function mint(uint256 len, address to, bytes[] memory _data) external returns (uint256[] memory);
    function mint(uint256 len, address[] memory to, bytes[] memory _data) external returns (uint256[] memory);
}

interface IERC721Attr {
    function setValues(address addr, uint256 tokenId, string calldata field, bytes calldata value) external returns (bool);

    function getValue(address addr, uint256 tokenId, string calldata field) external view returns (bytes memory result);

    function setFiled(address addr, string[] calldata field, uint256[] calldata types, uint256[] calldata auth) external returns (bool);

    function setUniques(address addr, string calldata field, bytes calldata value) external returns (bool);
    
    function clearUniques(address addr, string memory field, bytes memory value) external returns (bool);

    function delFiled(address addr, string calldata field) external returns (bool);

    function delValues(address addr, uint256 tokenId, string calldata field) external returns (bool);

    function getAuth(address addr, string calldata field) external view returns (uint256);

    function getType(address addr, string calldata field) external view returns (uint256);

    function getUniques(address addr, string calldata field, bytes calldata value) external view returns (bool);

    function setArrayValue(uint256 tokenId, string calldata field, bytes calldata value) external returns (bool);

    function checkArrayValue(uint256 tokenId, string calldata field, bytes calldata value) external view returns (bool);

    function delArrayValue(uint256 tokenId, string calldata field) external returns (bool);

    function removeArrayValue(uint256 tokenId, string calldata field, bytes calldata value) external returns (bool);

    function getArrayValue(uint256 tokenId, string calldata field) external view returns (uint256[] memory);

    function getArrayCount(uint256 tokenId, string calldata field) external view returns (uint256);
}


contract RacecourseAttrOperaContract   {

    using Uint256 for uint256;
    using Bytes for bytes;

    IERC721Attr private _attrAddress;

    string  public   _horseId = "horseId";//报名的马匹id

    function init(address attrAddress) public returns (bool) {
        _attrAddress = IERC721Attr(attrAddress);
        return true;
    }

    function setHorseId(uint256 tokenId, uint256 horseId) public  returns (bool) {
        bool result = _attrAddress.setArrayValue(tokenId, _horseId, horseId.Uint256ToBytes());
        return result;
    }

    // 取消比赛后，清除已经报名的马匹信息
    function delHorseId(uint256 tokenId) public  returns (bool) {
        bool result = _attrAddress.delArrayValue(tokenId, _horseId);
        return result;
    }

    // 取消报名后，清除对应的马匹信息
    function delHorseIdOne(uint256 tokenId, uint256 horseId) public  returns (bool) {
        bool result = _attrAddress.removeArrayValue(tokenId, _horseId, horseId.Uint256ToBytes());
        return result;
    }

    function delHorseIdBatch(uint256[] memory tokenIds) public  returns (bool) {
        require(tokenIds.length > 0 && tokenIds.length <= 256, "Cannot del 0 and must be less than 256");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _attrAddress.delArrayValue(tokenIds[i], _horseId);
        }
        return true;
    }

    function getHorseId(uint256 tokenId) public view returns (uint256[] memory) {
        return _attrAddress.getArrayValue(tokenId, _horseId);
    }

    function checkHorseId(uint256 tokenId, uint256 horseId) external view returns (bool){
        bool result = _attrAddress.checkArrayValue(tokenId, _horseId, horseId.Uint256ToBytes());
        return result;
    }
}