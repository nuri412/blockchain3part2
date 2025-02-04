const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("aITuSe (Casual)", function () {
  let Token;
  let token;
  let owner, addr1, addr2;

  beforeEach(async function () {
    Token = await ethers.getContractFactory("aITuSe");
    [owner, addr1, addr2] = await ethers.getSigners();
    token = await Token.deploy();
  });

  describe("Deployment", function () {
    it("Should assign the total supply of tokens to the owner", async function () {
      const ownerBalance = await token.balanceOf(owner.address);
      expect(await token.totalSupply()).to.equal(ownerBalance);
    });

    it("Should initialize with the hardcoded initial value", async function () {
      const initialValue = await token.initialValue();
      expect(initialValue).to.equal(2000); // Ensure the initial value is stored correctly
    });
  });

  describe("Transactions", function () {
    it("Should transfer tokens between accounts", async function () {
      await token.transfer(addr1.address, 100);
      const addr1Balance = await token.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(100);

      await token.connect(addr1).transfer(addr2.address, 50);
      const addr2Balance = await token.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(50);
    });

    it("Should fail if sender doesn’t have enough tokens", async function () {
      await expect(
        token.connect(addr1).transfer(owner.address, 1)
      ).to.be.revertedWithCustomError(token, "ERC20InsufficientBalance")
        .withArgs(addr1.address, 0, 1);
    });
  });

  describe("Transaction Logging", function () {
    it("Should log transaction details correctly", async function () {
      await token.transfer(addr1.address, 100);
      const [sender, receiver, amount, timestamp] = await token.getTransaction(0);
      expect(sender).to.equal(owner.address);
      expect(receiver).to.equal(addr1.address);
      expect(amount).to.equal(100);
      expect(timestamp).to.be.gt(0);
    });

    it("Should return the latest transaction timestamp", async function () {
      await token.transfer(addr1.address, 100);
      const timestamp = await token.getLatestTransactionTimestamp();
      expect(timestamp).to.not.be.empty;
    });

    it("Should retrieve sender and receiver addresses", async function () {
      await token.transfer(addr1.address, 100);
      const sender = await token.getTransactionSender(0);
      const receiver = await token.getTransactionReceiver(0);
      expect(sender).to.equal(owner.address);
      expect(receiver).to.equal(addr1.address);
    });
  });
});