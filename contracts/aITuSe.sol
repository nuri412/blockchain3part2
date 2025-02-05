// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract aITuSe is ERC20 {
    uint256 public initialValue = 2000; 

    // Struct to store transaction details
    struct Transaction {
        address sender;
        address receiver;
        uint256 amount;
        uint256 timestamp;
    }

    // Array to store all transactions
    Transaction[] public transactions;

    // Event to log transactions
    event TransferEvent(address indexed sender, address indexed receiver, uint256 amount, uint256 timestamp);

    // Constructor initializes the token with a fixed initial supply
    constructor() ERC20("aITuSe", "ITS") {
        _mint(msg.sender, initialValue * 10**decimals()); 
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "ERC20: transfer amount must be greater than zero");

        bool success = super.transfer(recipient, amount);

        transactions.push(
            Transaction({
                sender: msg.sender,
                receiver: recipient,
                amount: amount,
                timestamp: block.timestamp
            })
        );

        emit TransferEvent(msg.sender, recipient, amount, block.timestamp);
        return success;
    }

    // Function to retrieve and display transaction information
    function getTransaction(uint256 index)
        public
        view
        returns (
            address sender,
            address receiver,
            uint256 amount,
            uint256 timestamp
        )
    {
        require(index < transactions.length, "Invalid transaction index");
        Transaction memory txn = transactions[index];
        return (txn.sender, txn.receiver, txn.amount, txn.timestamp);
    }

    // Function to return the block timestamp of the latest transaction in human-readable format
    function getLatestTransactionTimestamp() public view returns (string memory) {
        require(transactions.length > 0, "No transactions available");
        uint256 latestTimestamp = transactions[transactions.length - 1].timestamp;
        return timestampToHumanReadable(latestTimestamp);
    }

        function timestampToHumanReadable(uint256 timestamp) internal pure returns (string memory) {
        uint256 constant SECONDS_PER_DAY = 86400;
        uint256 constant SECONDS_PER_YEAR = 31536000; // 365 days
        uint256 constant SECONDS_PER_LEAP_YEAR = 31622400; // 366 days
        uint256 year = 1970;
        uint256 remainingSeconds = timestamp;

        while (remainingSeconds >= SECONDS_PER_YEAR) {
            bool isLeapYear = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
            uint256 secondsInYear = isLeapYear ? SECONDS_PER_LEAP_YEAR : SECONDS_PER_YEAR;
    
            if (remainingSeconds < secondsInYear) {
                break;
            }
    
            remainingSeconds -= secondsInYear;
            year++;
        }

        uint256[12] memory monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        if ((year % 4 == 0 && (year % 100 != 0 || year % 400 == 0))) {
            monthDays[1] = 29; // February in a leap year
        }

        uint256 month = 0;
        uint256 day = 0;
        for (month = 0; month < 12; month++) {
            uint256 daysInMonth = monthDays[month];
            uint256 secondsInMonth = daysInMonth * SECONDS_PER_DAY;
    
            if (remainingSeconds < secondsInMonth) {
                day = (remainingSeconds / SECONDS_PER_DAY) + 1; // Day starts at 1
                break;
            }
    
            remainingSeconds -= secondsInMonth;
        }
    
        return string(abi.encodePacked(
            "Y:", uintToString(year),
            " M:", uintToString(month + 1), // Months are 1-indexed
            " D:", uintToString(day)
        ));
    }

    function uintToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + (value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    // Function to retrieve the address of the transaction sender
    function getTransactionSender(uint256 index) public view returns (address) {
        require(index < transactions.length, "Invalid transaction index");
        return transactions[index].sender;
    }

    // Function to retrieve the address of the transaction receiver
    function getTransactionReceiver(uint256 index) public view returns (address) {
        require(index < transactions.length, "Invalid transaction index");
        return transactions[index].receiver;
    }
}
