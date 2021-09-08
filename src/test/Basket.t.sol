//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "ds-test/test.sol";
import "./utils/BasketTest.sol";

/// @author andy8052
/// @title Tests for the NFT basket
contract BasketIntegration is BasketTest {
    function test_integration() public {
        token1.transferFrom(address(this), address(basket), 1);
        token1.transferFrom(address(this), address(basket), 2);
        token2.transferFrom(address(this), address(basket), 1);
        token3.safeTransferFrom(address(this), address(basket), 1, 4, "0");

        // we now have 3 tokens deposited
        assertTrue(token1.ownerOf(1) == address(basket));
        assertEq(token3.balanceOf(address(basket), 1), 4);

        basket.withdrawERC721(address(token1), 1);
        basket.withdrawERC721(address(token1), 2);
        basket.withdrawERC721(address(token2), 1);
        basket.withdrawERC1155(address(token3), 1, 4);

        assertTrue(token1.ownerOf(1) == address(this));
        assertEq(token3.balanceOf(address(this), 1), 5);

        uint256 bal = address(this).balance;

        payable(address(basket)).transfer(10 ether);

        basket.withdrawETH();

        assertEq(address(this).balance, bal);
    }
    
}