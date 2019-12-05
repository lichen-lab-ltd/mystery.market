pragma solidity 0.5.9;

import "./openzeppelin/token/ERC721/ERC721Token.sol";

contract Item is ERC721Token {

    uint256 lastTokenId;

    mapping (uint256 => address) tokenIdToCreator;

    uint256 contractId;
    constructor(string memory _name, string memory _symbol, uint8 _id, address[] memory recipients, uint8 num) public
        ERC721Token(_name, _symbol)
    {
        contractId = _id * 10000;
        uint256 _tokenId = lastTokenId;
        for(uint256 i = 0; i < recipients.length; i++) {
            for(uint8 j = 0; j < num; j++){
                _tokenId++;
                tokenIdToCreator[_tokenId] = recipients[i];
                _mint(recipients[i], _tokenId);
            }
        }
        lastTokenId = _tokenId;
    }

    function mintMultiple(uint256 num)
        external
    {
        mintMultipleTo(num, msg.sender);
    }

     function mintMultipleTo(uint256 num, address recipient)
        public
    {
        uint256 _tokenId = lastTokenId;
        for(uint256 i = 0; i < num; i++) {
            _tokenId++;
            tokenIdToCreator[_tokenId] = recipient;
            _mint(recipient, _tokenId);
        }
        lastTokenId = _tokenId;
    }

    function mint()
        external
        returns(uint256 _tokenId)
    {
        return mint(msg.sender);
    }

    function mint(address receiver)
        public
        returns(uint256 _tokenId)
    {
        _tokenId = ++lastTokenId;
        // we could use uint256(keccak256(_uri)) as tokenId
        // on the other hand lastTokenId combine with numTokemId can replace the nee for the array mechanism of openzeppelin
        tokenIdToCreator[_tokenId] = receiver;
        _mint(receiver, _tokenId);
    }

    /// @dev Returns the creator of a token
    /// @param _tokenId The token id to find it's creator
    function creatorOf(uint256 _tokenId)
        external
        view
        returns(address)
    {
        return tokenIdToCreator[_tokenId];
    }

    function tokenDataOfOwnerByIndex(
        address _owner,
        uint256 _index
        )
        public
        view
        returns (uint256 tokenId, string memory uri)
    {
        require(_index < balanceOf(_owner));
        tokenId = ownedTokens[_owner][_index];
        uri = tokenURI(tokenId);
    }

    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        require(exists(_tokenId), "Token doesn't exist");
        string memory tokenUri = "http://api.mystery.market/v1/dummy/metadata/0/000000";
        uint256 id = contractId + _tokenId;
        bytes memory _uriBytes = bytes(tokenUri);
        _uriBytes[46] = byte(uint8(48+(id / 100000) % 10));
        _uriBytes[47] = byte(uint8(48+(id / 10000) % 10));
        _uriBytes[48] = byte(uint8(48+(id / 1000) % 10));
        _uriBytes[49] = byte(uint8(48+(id / 100) % 10));
        _uriBytes[50] = byte(uint8(48+(id / 10) % 10));
        _uriBytes[51] = byte(uint8(48+(id / 1) % 10));

        return tokenUri;
    }
}


contract TestItem is ERC721Token {

    uint256 lastTokenId;

    mapping (uint256 => address) tokenIdToCreator;

    uint256 contractId;
    constructor(string memory _name, string memory _symbol, uint8 _id) public
        ERC721Token(_name, _symbol)
    {
        contractId = _id * 10000;
    }


    function mint(address receiver) 
        public 
        payable
        returns(uint256 _tokenId)
    {
        _tokenId = ++lastTokenId;
        // we could use uint256(keccak256(_uri)) as tokenId 
        // on the other hand lastTokenId combine with numTokemId can replace the nee for the array mechanism of openzeppelin
        tokenIdToCreator[_tokenId] = receiver;
        _mint(receiver, _tokenId); 
    }

}
