//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

/**
 * Mint a single ERC721 which can hold NFTs
 */
contract Basket is ERC721, IERC721Receiver, IERC1155Receiver {

    event DepositERC721(address indexed token, uint256 tokenId, address indexed from);
    event WithdrawERC721(address indexed token, uint256 tokenId, address indexed to);
    event DepositERC1155(address indexed token, uint256 tokenId, uint256 amount, address indexed from);
    event DepositERC1155Bulk(address indexed token, uint256[] tokenId, uint256[] amount, address indexed from);
    event WithdrawERC1155(address indexed token, uint256 tokenId, uint256 amount, address indexed from);
    event WithdrawETH(address indexed who);
    event WithdrawERC20(address indexed token, address indexed who);

    constructor() ERC721("NFT Basket", "NFTB") {
        _mint(msg.sender, 0);
    }

    /// @notice withdraw an ERC721 token from this contract into your wallet
    /// @param _token the address of the NFT you are withdrawing
    /// @param _tokenId the ID of the NFT you are withdrawing
    function withdrawERC721(address _token, uint256 _tokenId) external {
        require(_isApprovedOrOwner(msg.sender, 0), "withdraw:not allowed");
        IERC721(_token).safeTransferFrom(address(this), msg.sender, _tokenId);
        emit WithdrawERC721(_token, _tokenId, msg.sender);
    }
    /// @notice withdraw an ERC721 token from this contract into your wallet
    /// @param _token the address of the NFT you are withdrawing
    /// @param _tokenId the ID of the NFT you are withdrawing
    function withdrawERC721Unsafe(address _token, uint256 _tokenId) external {
        require(_isApprovedOrOwner(msg.sender, 0), "withdraw:not allowed");
        IERC721(_token).transferFrom(address(this), msg.sender, _tokenId);
        emit WithdrawERC721(_token, _tokenId, msg.sender);
    }
    /// @notice withdraw an ERC721 token from this contract into your wallet
    /// @param _token the address of the NFT you are withdrawing
    /// @param _tokenId the ID of the NFT you are withdrawing
    /// @param _amount the amount of the NFT you are withdrawing
    function withdrawERC1155(address _token, uint256 _tokenId, uint256 _amount) external {
        require(_isApprovedOrOwner(msg.sender, 0), "withdraw:not allowed");
        IERC1155(_token).safeTransferFrom(address(this), msg.sender, _tokenId, _amount, "0");
        emit WithdrawERC1155(_token, _tokenId, _amount, msg.sender);
    }

    /// @notice withdraw ETH in the case a held NFT earned ETH (ie. euler beats)
    function withdrawETH() external {
        require(_isApprovedOrOwner(msg.sender, 0), "withdraw:not allowed");
        payable(msg.sender).transfer(address(this).balance);
        emit WithdrawETH(msg.sender);
    }

    /// @notice withdraw ERC20 in the case a held NFT earned ERC20
    function withdrawERC20(address _token) external {
        require(_isApprovedOrOwner(msg.sender, 0), "withdraw:not allowed");
        IERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
        emit WithdrawERC20(_token, msg.sender);
    }

    function onERC721Received(address, address from, uint256 id, bytes memory) public virtual override returns(bytes4) {
        emit DepositERC721(msg.sender, id, from);
        return this.onERC721Received.selector;
    }

    function onERC1155Received(address, address from, uint256 id, uint256 amount, bytes memory) public virtual override returns (bytes4) {
        emit DepositERC1155(msg.sender, id, amount, from);
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(address, address from, uint256[] memory ids, uint256[] memory amounts, bytes memory) public virtual override returns (bytes4) {
        emit DepositERC1155Bulk(msg.sender, ids, amounts, from);
        return this.onERC1155BatchReceived.selector;
    }
    
    receive() external payable {}
}