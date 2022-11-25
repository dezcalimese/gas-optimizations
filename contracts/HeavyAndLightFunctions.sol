// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

contract HeavyAndLightFunctions {
    uint256 private x = 10;

    // Takes variable out of storage, adds one and returns it
    function light() external view returns (uint256) {
        return x + 1;
    }

    // Takes hash of value x, then takes the hash of it 50
    // (or however many times you put) times over and over again
    // then returns the uint256 value of the hash
    function heavy() external view returns (uint256) {
        bytes32 _x = keccak256(abi.encodePacked(x));
        for (uint256 i = 0; i < 50; i++) {
            _x = keccak256(abi.encodePacked(x));
        }
        return uint256(_x);
    }
}
