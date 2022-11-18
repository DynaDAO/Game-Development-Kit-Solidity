pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract CertificationSystem721 {
    IERC721 public nftContract;
    address public nftAddress = 0x0759D776a4FF0c7cE7983E2f570e428C8bcBd0de;

    modifier hasCertificate(uint256 nftID) {
        require(
            msg.sender == nftContract(nftAddress).ownerOf(nftID),
            "You can not join this game.. you should buy NFT"
        );
        _;
    }
}
