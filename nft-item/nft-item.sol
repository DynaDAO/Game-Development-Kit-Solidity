
pragma solidity ^0.8.10;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


contract NFTGame is ERC721{

    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint hp;
        string demodata;
    }

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
    CharacterAttributes[] defaultCharacters;
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;
    mapping(address => uint256) public nftHolders;

  event CharacterNFTMinted(address sender, uint256 tokenId, uint256 characterIndex);



  constructor(
    string[] memory characterNames,
    string[] memory characterImageURIs,
    uint[] memory characterHp,
    string[] memory demoData,
  ) ERC721("Collection_Name", "Collecton_Symbol") {
    for(uint i = 0; i < characterNames.length; i += 1) {
        defaultCharacters.push(CharacterAttributes(
            {
            characterIndex: i,
            name: characterNames[i],
            imageURI: characterImageURIs[i],
            hp: characterHp[i],
            demodata: demoData[i],
            }
        ));

      CharacterAttributes memory c = defaultCharacters[i];
    }
    _tokenIds.increment();
  }


    function mintCharacterNFT(uint _characterIndex) external {
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        nftHolderAttributes[newItemId] = CharacterAttributes({
        characterIndex: _characterIndex,
        name: defaultCharacters[_characterIndex].name,
        imageURI: defaultCharacters[_characterIndex].imageURI,
        hp: defaultCharacters[_characterIndex].hp,
        demodata: defaultCharacters[_characterIndex].demodata,
        });        
        nftHolders[msg.sender] = newItemId;

        _tokenIds.increment();
        emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];
        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strData = Strings.toString(charAttributes.demodata);
        string memory json = Base64.encode(
            abi.encodePacked(
            '{"name": "',
            charAttributes.name,
            ' -- NFT #: ',
            Strings.toString(_tokenId),
            '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image": "',
            charAttributes.imageURI,
            '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,'},{ "trait_type": "DemoData", "value": ',strData,'}]}'
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        
        return output;
    }

  
    function getAllDefaultCharacters() public view returns (CharacterAttributes[] memory) {
      return defaultCharacters;
    }

    function checkIfUserHasNFT() public view returns (CharacterAttributes memory) {
      uint256 userNftTokenId = nftHolders[msg.sender];
      if (userNftTokenId > 0) {
        return nftHolderAttributes[userNftTokenId];
      }
      else {
        CharacterAttributes memory emptyStruct;
        return emptyStruct;
      }
    }


}