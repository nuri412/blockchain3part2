# ERC20 Token Contracts: 
## aITuSe(Assignment 3, part 1) and aITuSeModified(Assignment 3, part 2)

## Overview
This project implements two ERC20 token contracts using the OpenZeppelin library:
1. **aITuSe**: A fixed-supply ERC20 token with 2000 tokens minted at deployment.
2. **aITuSeModified**: An ERC20 token that allows dynamic initialization of the token supply via a constructor parameter.

Both contracts include additional features such as:
- Transaction logging (sender, receiver, amount, timestamp).
- Retrieval of transaction details.
- Conversion of block timestamps into a human-readable format.

The contracts are tested using Hardhat and Chai, ensuring functionality and reliability.

## - Usage

### 1. Install Dependencies
```powershell
npm install
```
### 2. Compile Contracts
```powershell
npx hardhat compile 
```
Or just save Solidity contracts (Ctrl + S)
### 3. Run Tests
```powershell
npx hardhat test
```

## - Screenshots

![Result of aITuSe.sol](https://github.com/user-attachments/assets/2a350c2a-2005-4ecd-b067-3bbc5c7cf25c)

*Result of aITuSe.sol: Screenshot of successful test results after running `npx hardhat test`.*

![Result of aITuSeModified.sol](https://github.com/user-attachments/assets/c07e2202-a4f1-48fc-a514-bde164a9bc39)

*Result of aITuSeModified.sol: Screenshot of successful test results after running `npx hardhat test`.*

## - Examples
### aITuSe
This contract has a fixed initial supply of 2000 tokens.
```javascript
const Token = await ethers.getContractFactory("aITuSe");
const token = await Token.deploy();
```
*Deploys the aITuSe contract with a fixed supply of 2000 tokens.*

```javascript
await token.transfer(addr1.address, 100);
```
*Transfers 100 tokens from the owner to addr1. Use this to test token transfers between accounts.*
### aITuSeModified
This contract allows dynamic initialization of the token supply via a constructor parameter.
```javascript
const Token = await ethers.getContractFactory("aITuSeModified");
const token = await Token.deploy(2000); // Pass initial supply as parameter
```
*Deploys the aITuSeModified contract with a custom initial supply (e.g., 2000 tokens).*

```javascript
const [sender, receiver, amount, timestamp] = await token.getTransaction(0);
console.log(sender, receiver, amount, timestamp);
```
*Retrieves details of the first transaction (index 0), including sender, receiver, amount, and timestamp. Use this to verify transaction logging functionality.*
