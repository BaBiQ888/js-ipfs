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

contract Server is Admin {
    mapping(address => bool) private _servers;

    modifier onlyServer() {
        require(_servers[msg.sender], "Only server can call it");
        _;
    }

    function addServer(address _server) public onlyOwner {
        _servers[_server] = true;
    }

    function delServer(address _server) public onlyOwner {
        _servers[_server] = false;
    }

    function isServer(address _server) public view returns (bool) {
        return _servers[_server];
    }
}
