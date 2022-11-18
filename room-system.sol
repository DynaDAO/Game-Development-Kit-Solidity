pragma solidity ^0.8.13;

contract RoomSystem {
    address public owner;

    uint256 gameId;
    //mapping(uint256 => address[]) public gamePlayers;
    mapping(uint256 => uint256) public gameHistory;
    mapping(address => uint256) public inGame;

    //address[] public playersArray;
    mapping(uint256 => Room) public rooms;

    struct Room {
        address creator;
        uint256 roomId;
        address[] currentPlayers;
        uint256 maxPlayer;
        bool isStarted;
    }

    function createRoom(uint256 _maxPlayer) public {
        require(inGame[msg.sender] == 0, "you are already in a game");
        roomIds++;
        Room memory room;
        room.creator = msg.sender;
        room.currentPlayers.push(msg.sender);
        room.maxPlayer = _maxPlayer;
        Player[] memory playerArray = new Player[](playerCount);
        inGame[msg.sender] = roomIds;
    }

    function deleteRoom(uint256 _roomId) public {
        require(
            rooms[_roomId].isStarted == false,
            "this game is already started"
        );
        require(
            rooms[_roomId].creator == msg.sender,
            "you are not the owner of this game"
        );
        for (uint256 i = 0; i < rooms[_roomId].currentPlayers.length; i++) {
            inGame[rooms[_roomId].currentPlayers[i]] = 0;
        }
        delete rooms[_roomId];
    }

    function joinRoom(uint256 _roomId) public {
        require(inGame[msg.sender] == 0, "already in a game");
        rooms[_roomId].currentPlayers.push(msg.sender);
        inGame[msg.sender] = _roomId;
    }

    function startGame(uint256 _roomId) public {
        require(
            rooms[_roomId].creator == msg.sender,
            "you are not the creator of this game"
        );
        require(rooms[_roomId].isStarted == false, "already started");
        require(
            rooms[_roomId].currentPlayers.length == rooms[_roomId].maxPlayer,
            "room is not full"
        );
        rooms[_roomId].isStarted = true;
    }

    function leaveRoom(uint256 _roomId) public {
        require(inGame[msg.sender] == _roomId, "you are not in this game");
        require(
            rooms[_roomIds].creator != msg.sender,
            "you are the owner of this room"
        );
        for (
            uint256 i = index;
            i < rooms[_roomId].currentPlayers.length - 1;
            i++
        ) {
            rooms[_roomId].currentPlayers[i] = rooms[_roomId].currentPlayers[
                i + 1
            ];
        }
        rooms[_roomId].currentPlayers.pop();
    }

    //view fonksiyonlar eklenecek

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
