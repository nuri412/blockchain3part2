// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract aITuSeModified is ERC20 {
    uint256 public initialValue; 

    struct Transaction {
        address sender;
        address receiver;
        uint256 amount;
        uint256 timestamp;
    }

    Transaction[] public transactions;

    event TransferEvent(address indexed sender, address indexed receiver, uint256 amount, uint256 timestamp);

    // Constructor now accepts an input parameter
    constructor(uint256 _initialValue) ERC20("aITuSeModified", "ITSM") {
        initialValue = _initialValue;
        _mint(msg.sender, _initialValue * 10**decimals()); // Mint tokens based on the initial value
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

    function getLatestTransactionTimestamp() public view returns (string memory) {
        require(transactions.length > 0, "No transactions available");
        uint256 latestTimestamp = transactions[transactions.length - 1].timestamp;
        return timestampToHumanReadable(latestTimestamp);
    }

    function timestampToHumanReadable(uint256 timestamp) internal pure returns (string memory) {
    // Constants for time calculations
    uint256 constant SECONDS_PER_DAY = 86400;
    uint256 constant SECONDS_PER_YEAR = 31536000; // 365 days
    uint256 constant SECONDS_PER_LEAP_YEAR = 31622400; // 366 days

    // Start from the Unix epoch (1970-01-01)
    uint256 year = 1970;
    uint256 remainingSeconds = timestamp;

    // Calculate the year
    while (remainingSeconds >= SECONDS_PER_YEAR) {
        bool isLeapYear = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
        uint256 secondsInYear = isLeapYear ? SECONDS_PER_LEAP_YEAR : SECONDS_PER_YEAR;

        if (remainingSeconds < secondsInYear) {
            break;
        }

        remainingSeconds -= secondsInYear;
        year++;
    }

    // Days in each month
    uint256[12] memory monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if ((year % 4 == 0 && (year % 100 != 0 || year % 400 == 0))) {
        monthDays[1] = 29; // February in a leap year
    }

    // Calculate the month and day
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

    // Return the formatted string
    return string(abi.encodePacked(
        "Y:", uintToString(year),
        " M:", uintToString(month + 1), // Months are 1-indexed
        " D:", uintToString(day)
    ));
}

    function getTransactionSender(uint256 index) public view returns (address) {
        require(index < transactions.length, "Invalid transaction index");
        return transactions[index].sender;
    }

    function getTransactionReceiver(uint256 index) public view returns (address) {
        require(index < transactions.length, "Invalid transaction index");
        return transactions[index].receiver;
    }
}
