// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title Investment Agreement Contract
 * @dev Manages investment agreements between a lender and a borrower, ensuring that specified conditions are met.
 */
contract InvestmentAgreement {
    struct Agreement {
        uint256 amount;
        uint256 interestRate;  // in percentage points
        uint256 maturityTime;  // timestamp when funds can be released
        bool fundsReleased;
        address payable borrower;
    }

    address public lender;
    mapping(uint256 => Agreement) public agreements;
    uint256 public nextAgreementId;

    event AgreementCreated(uint256 indexed agreementId, uint256 amount, uint256 interestRate, uint256 maturityTime, address borrower);
    event FundsDeposited(uint256 indexed agreementId, uint256 amount);
    event FundsReleased(uint256 indexed agreementId, uint256 amount);

    modifier onlyLender() {
        require(msg.sender == lender, "Only the lender can perform this action.");
        _;
    }

    constructor() {
        lender = msg.sender;
    }

    /**
     * @dev Creates a new investment agreement.
     * @param amount The principal amount of the loan.
     * @param interestRate The interest rate per annum.
     * @param maturityPeriod The time in seconds until the funds can be released.
     * @param borrower The address of the borrower.
     */
    function createAgreement(uint256 amount, uint256 interestRate, uint256 maturityPeriod, address payable borrower) external onlyLender {
        uint256 maturityTime = block.timestamp + maturityPeriod;
        agreements[nextAgreementId] = Agreement(amount, interestRate, maturityTime, false, borrower);
        emit AgreementCreated(nextAgreementId, amount, interestRate, maturityTime, borrower);
        nextAgreementId++;
    }

    /**
     * @dev Allows the lender to deposit funds into a specific agreement.
     * @param agreementId The ID of the agreement to deposit funds into.
     */
    function depositFunds(uint256 agreementId) external payable onlyLender {
        Agreement storage agreement = agreements[agreementId];
        require(msg.value == agreement.amount, "Deposit must match the agreement amount.");
        emit FundsDeposited(agreementId, msg.value);
    }

    /**
     * @dev Allows funds to be released to the borrower if the maturity time has passed.
     * @param agreementId The ID of the agreement from which funds are to be released.
     */
    function releaseFunds(uint256 agreementId) external {
        Agreement storage agreement = agreements[agreementId];
        require(block.timestamp >= agreement.maturityTime, "The maturity period has not yet passed.");
        require(!agreement.fundsReleased, "Funds have already been released.");
        require(msg.sender == lender || msg.sender == agreement.borrower, "Only the lender or the borrower can release funds.");

        agreement.fundsReleased = true;
        agreement.borrower.transfer(agreement.amount);

        emit FundsReleased(agreementId, agreement.amount);
    }
}
