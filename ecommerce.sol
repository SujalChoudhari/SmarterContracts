// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "template.sol";

/// @title Store
/// @dev De-centralised E-commerce store to list products and facilitate purchases.
/// Use the `Store` contract to set up individual shops.
contract Store is Template {
    string public shopName;

    struct Item {
        uint256 id;
        string name;
        string category;
        string desc;
        uint256 price;
        uint256 stock;
        uint256 salePrice;
        uint256 rating;
    }

    struct Order {
        Item item;
        address buyer;
        bool atSale;
        uint256 quantity;
    }

    mapping(uint256 => Item) public listedItems;
    mapping(uint256 => Order) public allOrders;
    uint256 public orderCount = 0;

    // STORE SETUP
    constructor(string memory _shopName) Template() {
        shopName = _shopName;
    }

    function setShopName(string memory newName)
        public
        onlyOwner
        returns (string memory)
    {
        shopName = newName;
        return shopName;
    }

    // LIST PRODUCT
    function listProduct(
        uint256 _id,
        string memory _name,
        string memory _category,
        string memory _desc,
        uint256 _price,
        uint256 _salePrice,
        uint256 _stock,
        uint256 _rating
    ) public onlyOwner {
        Item memory item = Item(
            _id,
            _name,
            _category,
            _desc,
            _price,
            _stock,
            _salePrice,
            _rating
        );
        listedItems[_id] = item;
    }

    // BUY PRODUCT
    function buyProduct(
        uint256 _id,
        uint256 _quantity,
        bool onSale
    ) public payable onlyCustomer {
        Item storage item = listedItems[_id];

        // Ensure the product is in stock
        require(item.stock >= _quantity, "Insufficient stock");

        uint256 totalPrice = onSale
            ? item.salePrice * _quantity
            : item.price * _quantity;

        // Ensure the correct amount is paid
        require(msg.value / 1 ether == totalPrice, "Incorrect Amount Paid");

        // Update stock after purchase
        item.stock -= _quantity;

        // Create an order
        Order memory order = Order(item, msg.sender, onSale, _quantity);
        orderCount++;
        allOrders[orderCount] = order;

        // Send the funds to the store owner
        payable(owner).transfer(msg.value);
    }
}
