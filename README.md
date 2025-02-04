ERC20 Token Contracts: aITuSe and aITuSeModified
Usage
1. Install Dependencies
Make sure you have Node.js and npm installed. Then, install the required dependencies:

bash
Copy
1
npm install
2. Compile Contracts
Compile the Solidity contracts using Hardhat:

bash
Copy
1
npx hardhat compile
3. Run Tests
Run the test suite to verify the functionality of both contracts:

bash
Copy
1
npx hardhat test
Screenshots
Test Results
Here’s a demo of the test results after running npx hardhat test:

Test Results
(Replace test-results.png with an actual screenshot of your test output.)

Examples
Casual Contract (aITuSe)
Deployment :
javascript
Copy
1
2
const Token = await ethers.getContractFactory("aITuSe");
const token = await Token.deploy();
Transfer Tokens :
javascript
Copy
1
await token.transfer(addr1.address, 100);
Modified Contract (aITuSeModified)
Deployment :
javascript
Copy
1
2
const Token = await ethers.getContractFactory("aITuSeModified");
const token = await Token.deploy(2000); // Pass initial supply as parameter
Retrieve Transaction Details :
javascript
Copy
1
2
const [sender, receiver, amount, timestamp] = await token.getTransaction(0);
console.log(sender, receiver, amount, timestamp);
That’s it! Simple and to the point. Replace test-results.png with an actual screenshot or GIF of your test output for a more visual representation. Let me know if you need further adjustments!
