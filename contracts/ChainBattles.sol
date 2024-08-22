//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

//Using NFT standard from openzeppelin ERC721
contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.counter private _tokenIDs; 
    mapping(uint256 => uint256) public tokenIDtoLevels;

    constructor() ERC721("ChainBattles", "CBTLS"){

    }
    // generate the metadata
    function generateCharacter(uint256 tokenId) public returns(string memory){

        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
            '</svg>'
    );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
        );    
    );
    //get  the  level  of   the    nft
    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevels[tokenId];
        return levels.toString();
    }
    //get   the   URI    address  of   the   metadata 
    function getTokenURI(uint256 tokenID) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            '{'
                '"name": "Chain Battles #', tokenId.toString(), '",
                '"description": "Battles on chain", ',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        )

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            );
        )
    }
    //adding minting capacity
    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdtoLevels[newItemId] = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }
    //adding train to level up
    function train() public {
        require(_exists(tokenId), "Please use an existing token");
        require(ownerOf(tokenId) == msg.sender, "you must own this token to train it");
        uint256 currentLevel = tokenIdToLevels[tokenId];
        uint256 tokenIdToLevels[tokenId] = currentLevel + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }


}


