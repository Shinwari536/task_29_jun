//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./charity.sol";

contract CharitySplitter{

    function donate(Charity charity) external payable{
        (bool success, ) = address(charity).call{value: msg.value}(abi.encodeWithSignature("processDonation()"));
        require(success, "1- Transaction Failed.");
    }

     function donateCharity(Charity charity) external payable{
        (bool success,) = address(charity).call{value: msg.value}(abi.encodeWithSignature("donation()"));
        require(success, "2- Transaction Failed.");
    }

    function addNeedy(Charity charity, uint256 need) external {
        (bool success,) = address(charity).call(abi.encodeWithSignature("needRequest(address,uint256)", msg.sender, need));
        require(success, "3- Adding needy failed.");
    }

     function getRaisedCharity(Charity charity) external view returns(uint256 a){
        (bool success, bytes memory data) = address(charity).staticcall(abi.encodeWithSignature("getEtherRaised()"));
        require(success, "3- Adding needy failed.");

        (a) = abi.decode(data,(uint256)); 

    }

}