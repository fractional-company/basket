//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract TestERC1155 is ERC1155 {

  constructor() ERC1155("TestURI") {
  }

  function mint(address _to, uint256 _id, uint256 _amount) external {
    _mint(_to, _id, _amount, "0");
  }

}
