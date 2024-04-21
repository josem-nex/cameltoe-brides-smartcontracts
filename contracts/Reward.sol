// SPDX-License-Identifier: MIT

// This is a smart contract written in Solidity programming language.
// The contract defines a reward system where certain users are rewarded with Ether for their spending.

pragma solidity ^0.8.0;

// We import the AccessControl contract from OpenZeppelin library to use it for access control functionality.
import "@openzeppelin/contracts/access/AccessControl.sol";

// Contract definition starts here.
contract Reward is AccessControl {

    // Define two constants for roles: OWNER_ROLE and FUND_MANAGER_ROLE.
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 public constant FUND_MANAGER_ROLE = keccak256("FUND_MANAGER_ROLE");

    // Define some state variables.
    uint256 public index; // Used to keep track of the month.
    uint256 public numberOfRewardReceiver ; // Number of users who will receive rewards in a month.
    mapping(uint256 => spending [] ) public spendingList; // List of spending by reward collectors.
    mapping(uint256 => reward  ) public rewardList; // List of rewards distributed in a month.
    mapping(uint256 => uint256) public totalSpendingOfTheMonth; // Total spending in a month.
    uint256 public lastRewardTime; // Timestamp of the last reward distribution.

    // Define two structs for spending and reward.
    struct spending{
        address add; // Address of the reward collector.
        uint256 spendAmount; // Amount spent by the reward collector.
    }

    struct reward{
        uint256 timestamp; // Timestamp of the reward distribution.
        uint256 fundBalance; // Balance of the fund.
        uint256 rewardPerEth; // Reward per Ether.
        uint256 spendingOfTheMonth; // Total spending of the month.
    }
    // event 
    event RewardsSent(uint256 indexed rewardIndex, uint256 fundOfTheMonth, uint256 amountPerEth, uint256 totalSpending);
    event EtherSent(address indexed recipient, uint256 spendAmount, uint256 amountPerEth, uint256 etherAmount);

    // Define a constructor that sets up roles and initializes some state variables.
    /**
    @dev Constructor function to initialize the contract and set the owner and fund manager roles.
    @param _fundManagerAddress The address of the fund manager.
    */
    constructor(address _fundManagerAddress, uint256 _numberOfRewardCollector) {
        _setupRole(OWNER_ROLE, msg.sender); // Set up the owner role.
        _setupRole(FUND_MANAGER_ROLE, _fundManagerAddress); // Set up the fund manager role.
        index = 0; // Initialize index to 0.
        numberOfRewardReceiver = _numberOfRewardCollector; // Set the number of reward receivers to 10.
        lastRewardTime = 0; // Initialize last reward time to 0.
    }

    // Define a modifier for owner role.
    modifier onlyOwner() {
        require(hasRole(OWNER_ROLE, msg.sender), "Only the owner can call this function"); // Check if the caller has owner role.
        _; // Continue execution.
    }

    // Define a modifier for fund manager role.
    modifier onlyManager() {
        require(hasRole(FUND_MANAGER_ROLE, msg.sender), "Only the owner can call this function"); // Check if the caller has fund manager role.
        _; // Continue execution.
    }

    /**
    @dev Add reward collectors to the contract for the current month
    @param adds Array of addresses of the reward collectors
    @param prices Array of corresponding amounts spent by each collector
    Requirements:
    adds and prices arrays must have the same length
    Length of the arrays must be equal to numberOfRewardReceiver
    */
    function addRewardCollectors(address [] memory adds, uint256 [] memory prices) external {
        require(adds.length == prices.length,"Length is not equal ");
        require(adds.length == numberOfRewardReceiver,"Not enough data passed");

        uint256 len = adds.length;
        uint256 bal = 0;
        // Loop through the reward collectors and add their spending to the spending list
        for(uint256 i=0; i < len ; i++){
            spendingList[index].push(spending(adds[i],prices[i]));
            bal += prices[i];
        }
        totalSpendingOfTheMonth[index] = bal;// Set the total spending for the month
    }

    /**
    @dev Calculates the reward amount per ether based on the amount of funds and total spending of the month.
    @param _funds The amount of funds in the contract
    @param _amountSpend The total amount spent by the reward collectors in the month
    @return The calculated reward amount per ether
    */
    function calculateRewardPerEther(uint256 _funds, uint256 _amountSpend) private view  returns (uint256) {
        require(_amountSpend > 0, "Amount spent must be greater than zero");
        uint256 pricePerEth = _funds / (_amountSpend / 1 ether);
        return pricePerEth;
    }
    /**
    @dev Sends ether to the specified address based on the spend amount and reward amount per ether
    @param _to The address to which the ether is sent
    @param _spendAmount The amount spent by the reward collector
    @param _amountPerEth The reward amount per ether
    */
    function sendEther(address _to, uint256 _spendAmount, uint256 _amountPerEth) private  {
        uint256 amountToSend = ( _spendAmount * _amountPerEth ) / 1 ether;
        payable(_to).transfer(amountToSend);
        emit EtherSent(_to, _spendAmount, _amountPerEth, amountToSend);
    }

    /**
    @dev Sends rewards to reward collectors.
    @dev Only the manager can call this function.
    @dev This function can be called once every 28 days.
    @dev Calculates the amount of rewards per Ether spent by the reward collectors.
    @dev Sends rewards to the reward collectors based on their spending amount and the amount of rewards per Ether spent.
    */
    function sendRewards() onlyManager external payable {
        require(lastRewardTime + 28 days > block.timestamp, "You cannot call this function earlier!");
        uint256 fundOfTheMonth = address(this).balance;
        uint256 amountPerEth = calculateRewardPerEther(fundOfTheMonth,totalSpendingOfTheMonth[index]);
        for ( uint256 i = 0; i < numberOfRewardReceiver; i++){
            sendEther(spendingList[index][i].add,spendingList[index][i].spendAmount,amountPerEth);
        }
        lastRewardTime = block.timestamp;
        rewardList[index] = reward(lastRewardTime, fundOfTheMonth,amountPerEth,totalSpendingOfTheMonth[index] );
        index +=1;
        emit RewardsSent(index, fundOfTheMonth, amountPerEth, totalSpendingOfTheMonth[index]);
    }

    function receive() payable external{}
}
