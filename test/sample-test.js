const { expect } = require("chai");
const { BigNumber } = require("ethers");
const { ethers } = require("hardhat");

describe("Charity Work", function () {
  let charityContract;
  let charity;

  let charitySplitterContract;
  let charitySplitter;

  let owner;
  let addr1;
  let addr2;
  let addr3;
  let addr4;

  before(async function(){
    charityContract = await ethers.getContractFactory("Charity");
    [owner, addr1, addr2, addr3, addr4] = await ethers.getSigners();
    charity = await charityContract.deploy();

    charitySplitterContract = await ethers.getContractFactory("CharitySplitter");
    charitySplitter = await charitySplitterContract.deploy();
  })

  describe("Cheking .call method", function(){
    it("Should add donation in charity", async function(){
      const preBal = await charity.getEtherRaised();
      await charitySplitter.donate(charity.address, {value: 6});
      const newBal = await charity.getEtherRaised();
      console.log(newBal.toNumber());
      expect(await charity.getEtherRaised()).to.equal(ethers.BigNumber.from("6").add(preBal));
    })

    it("Should add donation in charity, through fallback() method", async function(){
      const preBal = await charity.getEtherRaised();
      await charitySplitter.connect(addr1).donateCharity(charity.address, {value: 9});
      const newBal = await charity.getEtherRaised();
      console.log(newBal.toNumber());
      expect(await charity.getEtherRaised()).to.equal(ethers.BigNumber.from("9").add(preBal));
    })

    it("Should add needy in charity, success for staticcall", async function(){
      const etherVal = await charitySplitter.callStatic.getRaisedCharity(charity.address);
      console.log(etherVal);
      // expect(await charity.getEtherRaised()).to.equal(etherVal);
    })
  })
});
