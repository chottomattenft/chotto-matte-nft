// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PerkManager is Ownable {

//VARIABLES, ETC.
  address public nftAddress;
  uint public nftID;
  IERC721 nft;
  uint public securityID;
  address public verifiedAddress;
  uint public deadline;
  bool public isVerified;

  enum Perk {
    tastingWithExecChef,
    mixologyMasterclass,
    openingPartyFounder,
    openingPartyGuests,
    producersVisit,
    newYearsEveDinner,
    sushiMasterclass,
    bitcoinConferenceVIP,
    majorSportingEvent,
    atHomeExperience
  }

  mapping (Perk => uint) public amountPerk;

//EVENTS
  event NewRedemption (
   address redeemer,
   Perk perk,
   uint date
 );

 event securityIDchanged (
  address ownerOfNFT,
  uint newSecurityID,
  uint date
);

//CONSTRUCTOR
  constructor(address _nftAddress, uint _nftID) {
    deadline = block.timestamp + 31556926;
    amountPerk[Perk.tastingWithExecChef] = 2;
    amountPerk[Perk.mixologyMasterclass] = 2;
    amountPerk[Perk.openingPartyFounder] = 1;
    amountPerk[Perk.openingPartyGuests] = 1;
    amountPerk[Perk.producersVisit] = 1;
    amountPerk[Perk.newYearsEveDinner] = 1;
    amountPerk[Perk.sushiMasterclass] = 1;
    amountPerk[Perk.bitcoinConferenceVIP] = 1;
    amountPerk[Perk.majorSportingEvent] = 1;
    amountPerk[Perk.atHomeExperience] = 1;
    nftAddress = _nftAddress;
    nftID = _nftID;
    nft = IERC721(nftAddress);
  }

//SET SECURITY ID
  function setSecurityID(uint _securityID) public {
    address nftHolder = nft.ownerOf(nftID);
    require(msg.sender == nftHolder, "You are not the NFT holder!");
    securityID = _securityID;
    isVerified = false;
    verifiedAddress = msg.sender;
    emit securityIDchanged(msg.sender, securityID, block.timestamp);
  }

//REDEEM REWARDS
  function redeemPerk(Perk _perk) public {
    address nftHolder = nft.ownerOf(nftID);
    require(msg.sender == nftHolder, "You are not the NFT holder!");
    require(msg.sender == verifiedAddress, "Address not verified yet!");
    require(isVerified == true, "Please verify your address first");
    require(deadline > block.timestamp, "Deadline reached");
    require(amountPerk[_perk]>0,  "No more to redeem");
    amountPerk[_perk] = amountPerk[_perk] - 1;
    emit NewRedemption(msg.sender, _perk, block.timestamp);
  }

//GET DATA FROM NFT CONTRACT
  function ownerOfNft() public view returns (address) {
    address nftHolder = nft.ownerOf(nftID);
    return nftHolder;
  }

//YEARLY UPDATE
  function yearlyUpdate() external onlyOwner {
    require(deadline<block.timestamp, "Too early...");
    deadline = block.timestamp + 31556926;
    amountPerk[Perk.tastingWithExecChef] = 2;
    amountPerk[Perk.mixologyMasterclass] = 2;
    amountPerk[Perk.openingPartyFounder] = 1;
    amountPerk[Perk.openingPartyGuests] = 1;
    amountPerk[Perk.producersVisit] = 1;
    amountPerk[Perk.newYearsEveDinner] = 1;
    amountPerk[Perk.sushiMasterclass] = 1;
    amountPerk[Perk.bitcoinConferenceVIP] = 1;
    amountPerk[Perk.majorSportingEvent] = 1;
    amountPerk[Perk.atHomeExperience] = 1;
  }

//VERIFY NEW ADDRESS
  function verifyAddress() external onlyOwner {
    address nftHolder = nft.ownerOf(nftID);
    require(verifiedAddress == nftHolder, "Must own NFT!");
    isVerified = true;
  }

}
