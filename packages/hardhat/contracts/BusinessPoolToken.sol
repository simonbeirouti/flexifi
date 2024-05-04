// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BusinessPoolToken is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Struct to hold token sale information
    struct TokenSale {
        bool isForSale;
        uint256 price;
    }

    // Mapping from token ID to sale information
    mapping(uint256 => TokenSale) public tokenSales;

    // Event declarations for sale activities
    event TokenListedForSale(uint256 indexed tokenId, uint256 price);
    event TokenSold(uint256 indexed tokenId, address from, address to, uint256 price);

    constructor() ERC721("FlexiFi", "FFI") {
        _tokenIdCounter.increment();  // Start token IDs at 1
    }

    // Mintable only by the owner of the contract
    function mintTo(address recipient) public onlyOwner {
        uint256 newTokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mint(recipient, newTokenId);
        _setTokenURI(newTokenId, generateTokenURI(newTokenId));
    }

    function generateTokenURI(uint256 tokenId) private pure returns (string memory) {
        return string(abi.encodePacked("https://api.example.com/metadata/", Strings.toString(tokenId), ".json"));
    }

    // List an NFT for sale
    function listForSale(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "You must own the token to list it for sale");
        require(price > 0, "Price must be greater than zero");

        tokenSales[tokenId] = TokenSale(true, price);
        emit TokenListedForSale(tokenId, price);
    }

    // Function to buy a listed NFT
    function buyNFT(uint256 tokenId) public payable {
        TokenSale memory sale = tokenSales[tokenId];
        require(sale.isForSale, "This token is not for sale");
        require(msg.value >= sale.price, "Ether sent is not correct");

        address seller = ownerOf(tokenId);
        _transfer(seller, msg.sender, tokenId);
        payable(seller).transfer(msg.value);

        tokenSales[tokenId] = TokenSale(false, 0);
        emit TokenSold(tokenId, seller, msg.sender, msg.value);
    }
}
