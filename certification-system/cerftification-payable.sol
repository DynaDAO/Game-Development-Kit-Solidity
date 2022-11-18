pragma solidity ^0.8.13;

contract CertificationPayable {
    modifier hasCertificate(uint256 amount) payable{
        require(
            msg.value >= amount,
            "You should buy ticket"
        );
        _;
    }
}
