pragma solidity ^0.8.11;

contract RegisterPlayer {
    address public owner;
    uint256 playerIDs;
    mapping(uint256 => Player) public registeredPlayers;
    mapping(address => bool) public isRegistered;

    struct Player {
        uint256 id;
        string nickName;
        address playerAddress;
        uint256 elo;
    }

    function registerPlayer(string calldata _nickName) public {
        require(isRegistered[msg.sender] != false, "already registered");
        Player memory player;
        player.nickName = _nickName;
        player.playerAddress = msg.sender;
        player.id = playerIDs;
        registeredPlayers[playerIDs] = player;
        playerIDs++;
        isRegistered[msg.sender] = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
