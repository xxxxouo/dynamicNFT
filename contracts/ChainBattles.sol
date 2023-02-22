// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// deploy : 0x0cB75962170925B344E63E418037690E7eAb114C

contract ChainBattles is ERC721URIStorage {
  using Strings for uint256;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  uint256 constant HpMultiple = 100;
  uint256 constant OtherMultiple = 10;

  struct NFTInfo {
    uint256 level;
    uint256 speed;
    uint256 strength;
    uint256 hp;
  }

  // NFTInfo[] nftInfo;

  mapping( uint256 => NFTInfo) public tokenIdtoLevels;

  constructor() ERC721("Chain Battles", "XJ") {}
 
  //生成和更新我们 NFT 的 SVG 图片
  function generateCharacter (uint256 tokenId) public view returns( string memory ) {
    bytes memory svg = abi.encodePacked(
      '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
       '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
       '<rect width="100%" height="100%" fill="pink" />',
       '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"vx:Xxxx-ouo",'</text>',
       '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',"Levels: ", getLevels(tokenId),'</text>',
       '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',"HP: ", getHp(tokenId),'</text>',
       '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',"Speed: ", getSpeed(tokenId),'</text>',
       '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">',"strength: ", getStrength(tokenId),'</text>',
      '</svg>'
    );
    return string(
      abi.encodePacked(
        "data:image/svg+xml;base64,",
        Base64.encode(svg)
      )
    );
  }

  // 获取NFT等级
  function getLevels(uint256 tokenId) public view returns(string memory){
     uint256 levels = tokenIdtoLevels[tokenId].level;
     return levels.toString();
  }

  function getHp(uint256 tokenId) public view returns(string memory){
     uint256 hps = tokenIdtoLevels[tokenId].hp;
     return string(hps.toString());
  }

  function getSpeed(uint256 tokenId) public view returns(string memory){
     uint256 speeds = tokenIdtoLevels[tokenId].speed;
     return string(speeds.toString());
  }
   function getStrength(uint256 tokenId) public view returns(string memory){
     uint256 strong = tokenIdtoLevels[tokenId].strength;
     return string(strong.toString());
  }

  // 获取 json格式的metadata
  function getTokenURI(uint256 tokenId) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
  }
  
  function mint () public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    // openzeppelin 合约库的方法铸造
    _safeMint(msg.sender, newItemId);
    // 初始
    tokenIdtoLevels[newItemId].level = 0;
    tokenIdtoLevels[newItemId].hp = 50;
    tokenIdtoLevels[newItemId].strength = 7;
    tokenIdtoLevels[newItemId].speed = 8;
    // 设置令牌uri
    _setTokenURI(newItemId,getTokenURI(newItemId) );
  }

  function train(uint256 tokenId) public {
    // 通过ERC721合约库的_exists 方法,校验token是否存在 && 通过_ownerOf校验是否是所有者的令牌
    require(_exists(tokenId),"this token unexist, pls use an existing token");
    require(ownerOf(tokenId) == msg.sender,"You must own this token to train it");
    uint256 currentLevel = tokenIdtoLevels[tokenId].level;
    // tokenIdtoLevels[tokenId].level = currentLevel + 1;
    uint256 currentSpeed = tokenIdtoLevels[tokenId].speed;
    tokenIdtoLevels[tokenId].speed = currentSpeed + random(10);

    uint256 currentHp = tokenIdtoLevels[tokenId].hp;
    tokenIdtoLevels[tokenId].hp = currentHp + random(100);

    uint256 currentStrength = tokenIdtoLevels[tokenId].strength;
    tokenIdtoLevels[tokenId].strength = currentStrength + random(5);

    uint256 hpres =  currentHp / HpMultiple;
    uint256 speedres =  currentSpeed / OtherMultiple;
    uint256 strongres =  currentStrength / OtherMultiple;

    // if( hpres < speedres && hpres < strongres) {
    //   tokenIdtoLevels[tokenId].level = hpres;
    // } else if (speedres < hpres && speedres< strongres) {
    //   tokenIdtoLevels[tokenId].level = speedres;
    // } else if(strongres < hpres && strongres< speedres) {
    //   tokenIdtoLevels[tokenId].level = strongres;
    // } else if(hpres==speedres && hpres == strongres && speedres==strongres) {
    //   tokenIdtoLevels[tokenId].level = hpres;
    // } else if(hpres==speedres && hpres < strongres){
    //   tokenIdtoLevels[tokenId].level = hpres;
    // } else if(hpres == strongres && hpres < speedres){
    //   tokenIdtoLevels[tokenId].level = hpres;
    // } else if(speedres == strongres && speedres < hpres){
    //   tokenIdtoLevels[tokenId].level = speedres;
    // } else if(speedres == strongres && speedres > hpres){
    //   tokenIdtoLevels[tokenId].level = hpres;
    // }
    // if(hpres != speedres && hpres != strongres && speedres != strongres) {
      tokenIdtoLevels[tokenId].level = currentLevel + 1;
    // }
     _setTokenURI(tokenId,getTokenURI(tokenId) );
  }


  // 随机数
  function random(uint number) public view returns(uint){
      return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
      msg.sender))) % number;
  }
}