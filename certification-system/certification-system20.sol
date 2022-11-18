pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CertificationSystem20 {
    IERC20 public tokenContract;
    address public tokenAddress = 0x0759D776a4FF0c7cE7983E2f570e428C8bcBd0de;

    modifier hasCertificate(uint256 amount) {
        require(
            tokenContract(tokenAddress).balanceOf(msg.sender) >= amount,
            "You can not join this game.. you should buy NFT"
        );
        _;
    }
}
