// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./BusinessPoolToken.sol";

/**
 * @title BusinessPooling
 * @dev A simple DeFi pool to deposit and withdraw ERC-20 tokens.
 */
contract BusinessPooling is ReentrancyGuard, Ownable {
    IERC20 public immutable asset; // The ERC-20 token used in the pool

    mapping(address => uint256) public balances; // Tracks each user's balance in the pool
    mapping(address => uint256) public lockTimes; // Track the lock times when deposit is made

    uint256 public constant MAX_CAP = 1e9 * 1e18; // 1 billion tokens, assuming 18 decimal places
    uint256 public constant MIN_DEPOSIT = 1 * 1e18; // Minimum deposit of 10,000 tokens, assuming 18 decimal places
    uint256 public totalDeposited; // Tracks the total amount deposited in the fund

    // Creating the BusinessPoolToken definition
    BusinessPoolToken public poolToken;

    /**
     * @dev Initializes the contract with the ERC-20 token to be used.
     * @param _asset The address of the ERC-20 token.
     */
    constructor(IERC20 _asset, BusinessPoolToken _poolToken) {
        require(address(_asset) != address(0), "Asset address cannot be zero");
        asset = _asset;
        poolToken = _poolToken;
    }

    /**
     * @notice Deposits tokens into the pool.
     * @param amount The amount of tokens to deposit.
     */
    function depositFor(address investor, uint256 amount) public {
        require(amount >= MIN_DEPOSIT, "Deposit amount is less than the minimum required");
        require(totalDeposited + amount <= MAX_CAP, "Deposit exceeds fund cap");

        asset.transferFrom(investor, address(this), amount);
        balances[investor] += amount;
        totalDeposited += amount; // Update the total deposited amount
        lockTimes[investor] = block.timestamp + 365 days; // Set lock time to one year from now
        
        // Mint an NFT for the deposit
        poolToken.mintTo(investor);
    }

    /**
     * @notice Withdraws tokens from the pool.
     * @param amount The amount of tokens to withdraw.
     */
    function withdraw(uint256 amount) external nonReentrant {
        require(amount > 0, "Cannot withdraw zero tokens");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(block.timestamp >= lockTimes[msg.sender], "Tokens are still locked");

        balances[msg.sender] -= amount;
        asset.transfer(msg.sender, amount);
    }

    /**
     * @notice Returns the total assets held by the pool.
     * @return Total assets in the pool.
     */
    function totalAssets() public view returns (uint256) {
        return asset.balanceOf(address(this));
    }
}

