// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    enum State { Manufactured, InTransit, Delivered }

    struct Product {
        uint id;
        string name;
        address manufacturer;
        address currentHolder;
        State state;
    }

    mapping(uint => Product) public products;
    uint public productCount;

    event ProductAdded(uint id, string name, address manufacturer);
    event ProductTransferred(uint id, address from, address to, State state);

    function addProduct(string memory _name) public {
        productCount++;
        products[productCount] = Product(productCount, _name, msg.sender, msg.sender, State.Manufactured);
        emit ProductAdded(productCount, _name, msg.sender);
    }

    function transferProduct(uint _id, address _to) public {
        require(products[_id].id != 0, "Product does not exist");
        require(products[_id].currentHolder == msg.sender, "Only current holder can transfer");
        require(products[_id].state != State.Delivered, "Product already delivered");
        
        products[_id].currentHolder = _to;
        
        if (_to == address(0)) {
            products[_id].state = State.Delivered;
        } else {
            products[_id].state = State.InTransit;
        }

        emit ProductTransferred(_id, msg.sender, _to, products[_id].state);
    }
}
