# Minimalist NFT Marketplace

A streamlined, gas-optimized smart contract for decentralized NFT trading. This repository provides the core logic for a peer-to-peer marketplace where users can trade ERC-721 assets without a middleman.

## Architecture
The marketplace uses a "Listing" struct to track active sales. When an NFT is listed, the contract does not hold the NFT (Escrow-less) but requires the user to give the contract operator permissions to transfer the asset upon a successful purchase.



## Key Features
* **Escrow-less Listings**: Users keep NFTs in their wallets until the moment of sale.
* **Gas Optimized**: Minimal storage writes to reduce transaction costs.
* **Security**: Reentrancy guards and owner-only administrative functions.

## Interaction
1. **List**: Call `listItem(nftAddress, tokenId, price)`.
2. **Buy**: Call `buyItem(nftAddress, tokenId)` with the required ETH.
3. **Cancel**: Call `cancelListing(nftAddress, tokenId)`.

## License
MIT
