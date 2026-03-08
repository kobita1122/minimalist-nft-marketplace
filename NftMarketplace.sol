// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract NftMarketplace is ReentrancyGuard {
    struct Listing {
        uint256 price;
        address seller;
    }

    event ItemListed(address indexed seller, address indexed nftAddress, uint256 indexed tokenId, uint256 price);
    event ItemCanceled(address indexed seller, address indexed nftAddress, uint256 indexed tokenId);
    event ItemBought(address indexed buyer, address indexed nftAddress, uint256 indexed tokenId, uint256 price);

    // nftAddress -> tokenId -> Listing
    mapping(address => mapping(uint256 => Listing)) private s_listings;

    modifier isOwner(address nftAddress, uint256 tokenId, address spender) {
        IERC721 nft = IERC721(nftAddress);
        require(nft.ownerOf(tokenId) == spender, "Not the owner");
        _;
    }

    function listItem(address nftAddress, uint256 tokenId, uint256 price) 
        external 
        isOwner(nftAddress, tokenId, msg.sender) 
    {
        require(price > 0, "Price must be above zero");
        require(IERC721(nftAddress).getApproved(tokenId) == address(this), "Not approved for marketplace");
        
        s_listings[nftAddress][tokenId] = Listing(price, msg.sender);
        emit ItemListed(msg.sender, nftAddress, tokenId, price);
    }

    function cancelListing(address nftAddress, uint256 tokenId) 
        external 
        isOwner(nftAddress, tokenId, msg.sender) 
    {
        delete s_listings[nftAddress][tokenId];
        emit ItemCanceled(msg.sender, nftAddress, tokenId);
    }

    function buyItem(address nftAddress, uint256 tokenId) 
        external 
        payable 
        nonReentrant 
    {
        Listing memory listedItem = s_listings[nftAddress][tokenId];
        require(listedItem.price > 0, "Item not listed");
        require(msg.value >= listedItem.price, "Price not met");

        delete s_listings[nftAddress][tokenId];
        IERC721(nftAddress).safeTransferFrom(listedItem.seller, msg.sender, tokenId);
        
        (bool success, ) = payable(listedItem.seller).call{value: msg.value}("");
        require(success, "Transfer failed");

        emit ItemBought(msg.sender, nftAddress, tokenId, listedItem.price);
    }

    function getListing(address nftAddress, uint256 tokenId) external view returns (Listing memory) {
        return s_listings[nftAddress][tokenId];
    }
}
