// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Storage {
    uint256 private c;
    uint256 private b;
    uint256 private a;

    function storageLocation() external pure returns (uint256) {
        uint256 slotLocation;

        assembly {
            slotLocation := a.slot
        }

        return slotLocation;
    }
}
