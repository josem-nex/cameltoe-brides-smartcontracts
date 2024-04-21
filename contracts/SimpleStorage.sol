// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
contract SimpleStorage {
    mapping(string => uint256) private nametofavoriteNumber;
    mapping(string => address) private nameToAddress;

    function addPerson(
        string memory _name,
        uint256 _favoriteNumber,
        address _address
    ) public {
        nametofavoriteNumber[_name] = _favoriteNumber;
        nameToAddress[_name] = _address;
    }
    function retrieveFavoriteNumber(
        string memory _name
    ) public view returns (uint256) {
        return nametofavoriteNumber[_name];
    }
    function retrieveAddress(
        string memory _name
    ) public view returns (address) {
        return nameToAddress[_name];
    }
    function changeFavoriteNumber(
        string memory _name,
        uint256 _favoriteNumber
    ) public {
        nametofavoriteNumber[_name] = _favoriteNumber;
    }
    function changeAddress(string memory _name, address _address) public {
        nameToAddress[_name] = _address;
    }
}
