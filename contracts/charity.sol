//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Charity {
    address private owner;
    // addr of giver => amount given
    mapping(address=> uint256) donations;
    address[] needyAddresses;
    mapping(address=> uint256)needs;

    event CharityRaised(address sender, uint256 ethValue, uint256 time);
    event NeedyAdded(address needy, uint256 need, uint256 index);
    event CharityGiven(address needy, uint256 need, uint256 index);


    modifier onlyOwner(){
        require(owner == msg.sender, "Only owner can perform.");
        _;
    }
    constructor(){
        needyAddresses.push();
        owner = msg.sender;
    }
    receive() external payable{
        donations[msg.sender] = msg.value;

        emit CharityRaised(msg.sender, msg.value, block.timestamp);
    }

    fallback() external payable{
         donations[msg.sender] = msg.value;

        emit CharityRaised(msg.sender, msg.value, block.timestamp);

    }

    function processDonation() external payable{
        donations[msg.sender] = msg.value;

        emit CharityRaised(msg.sender, msg.value, block.timestamp);
    }

    function getNeed(address _addr) external view returns(uint256){
        return needs[_addr];
    }

   
    function getEtherRaised() external view returns(uint256){
        return address(this).balance;
    }

    function needRequest(address _needy, uint256 _need) external{
        require(_need > 0, "Connot request 0 amount");
        require(_need <= 5 ether, "Cannot request this amount");

        needyAddresses.push(_needy);
        needs[_needy] = _need;
        emit NeedyAdded(_needy, _need, (needyAddresses.length -1));
    }

    function giveCharityToNeedy(uint256 index) external onlyOwner{
        uint256 need = needs[needyAddresses[index]];
        payable(needyAddresses[index]).transfer(need);
    }







}
