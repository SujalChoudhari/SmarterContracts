// SPDX-License-Identifier: MIT
pragma solidity >0.6.0 <0.9.0;

contract Template {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Require Owner Permissions");
        _;
    }

    modifier onlyCustomer() {
        require(msg.sender != owner, "Require Customer Permissions");
        _;
    }

    modifier onlyFixedAmount(uint256 requiredValue) {
        require(
            msg.value == requiredValue * 1 wei,
            "Required amount differs the Sent amount"
        );
        _;
    }

    modifier onlyEnoughBalance(uint256 requiredBalance) {
        require(
            msg.sender.balance / 1 wei >= requiredBalance / 1 wei,
            "Not enough balance in account"
        );
        _;
    }
}
