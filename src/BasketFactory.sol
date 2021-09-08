//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Basket.sol";

contract BasketFactory {
    
    address[] public baskets;
    
    event NewBasket(address indexed _address, address indexed _creator);
    
    function createBasket() public {
        Basket basket = new Basket();
        basket.transferFrom(address(this), msg.sender, 0);
        baskets.push(address(basket));
        emit NewBasket(address(basket), msg.sender);
    }
    
}