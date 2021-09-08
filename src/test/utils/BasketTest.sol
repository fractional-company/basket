// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "ds-test/test.sol";
import "./Hevm.sol";

import "../../Basket.sol";

import "./TestERC721.sol";
import "./TestERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract BasketTest is DSTest, ERC721Holder, ERC1155Holder {
    Hevm internal constant hevm = Hevm(HEVM_ADDRESS);

    // contracts
    Basket public basket;
    TestERC721 public token1;
    TestERC721 public token2;
    TestERC1155 public token3;

    function setUp() public {
        basket = new Basket();
        token1 = new TestERC721();
        token2 = new TestERC721();
        token3 = new TestERC1155();

        token1.mint(address(this), 1);
        token1.mint(address(this), 2);
        token1.mint(address(this), 3);
        token1.mint(address(this), 4);

        token2.mint(address(this), 1);
        token2.mint(address(this), 2);
        token2.mint(address(this), 3);
        token2.mint(address(this), 4);

        token3.mint(address(this), 1, 5);
        token3.mint(address(this), 2, 2);
    }

    receive() external payable {}
}
