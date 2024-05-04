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
        uint256 feesDeducted;  // stores the total fees deducted upon fund release
        address potentialBuyer;
        uint256 salePrice;
        bool isForSale;
    }

    address public lender;
    mapping(uint256 => Agreement) public agreements;
    uint256 public nextAgreementId;

    event AgreementOfferedForSale(uint256 indexed agreementId, uint256 salePrice, address indexed potentialBuyer);
    event AgreementSold(uint256 indexed agreementId, address indexed newOwner);
    event AgreementCreated(uint256 indexed agreementId, uint256 amount, uint256 interestRate, uint256 maturityTime, address borrower);
    event FundsDeposited(uint256 indexed agreementId, uint256 amount);
    event FundsReleased(uint256 indexed agreementId, uint256 amount, uint256 feesDeducted);


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
        agreements[nextAgreementId] = Agreement({
            amount: amount,
            interestRate: interestRate,
            maturityTime: maturityTime,
            fundsReleased: false,
            borrower: borrower,
            feesDeducted: 0,
            potentialBuyer: address(0),
            salePrice: 0,
            isForSale: false
        });
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
     * @dev Allows the borrower to offer the agreement for sale, invoking the ROFR.
     * @param agreementId The ID of the agreement they wish to sell.
     * @param salePrice The price at which they wish to sell the agreement.
     * @param potentialBuyer The address of the potential buyer who has made an offer.
     */



    function offerForSale(uint256 agreementId, uint256 salePrice, address potentialBuyer) public {
        Agreement storage agreement = agreements[agreementId];
        require(msg.sender == agreement.borrower, "Only the borrower can offer the agreement for sale.");
        require(!agreement.isForSale, "The agreement is already offered for sale.");

        agreement.potentialBuyer = potentialBuyer;
        agreement.salePrice = salePrice;
        agreement.isForSale = true;

        emit AgreementOfferedForSale(agreementId, salePrice, potentialBuyer);
    }



    /**
     * @dev Allows the lender to accept the offer to buy the agreement, exercising their right of first refusal.
     * @param agreementId The ID of the agreement the lender wishes to buy.
     */



    function buyAgreement(uint256 agreementId) public payable onlyLender {
        Agreement storage agreement = agreements[agreementId];
        require(agreement.isForSale, "This agreement is not for sale.");
        require(msg.value == agreement.salePrice, "Incorrect amount transferred.");

        agreement.borrower.transfer(msg.value); // Transfer funds to the current owner
        agreement.borrower = payable(lender);   // Transfer ownership to the lender
        agreement.isForSale = false;

        emit AgreementSold(agreementId, lender);
    }



    /**
     * @dev Allows the potential buyer to buy the agreement if the lender does not exercise their ROFR.
     * @param agreementId The ID of the agreement they wish to purchase.
     */



    function purchaseAgreement(uint256 agreementId) public payable {
        Agreement storage agreement = agreements[agreementId];
        require(agreement.isForSale, "This agreement is not for sale.");
        require(msg.sender == agreement.potentialBuyer, "You are not the designated buyer.");
        require(msg.value == agreement.salePrice, "Incorrect amount transferred.");

        agreement.borrower.transfer(msg.value); // Transfer funds to the current owner
        agreement.borrower = payable(msg.sender);  // Transfer ownership to the new buyer
        agreement.isForSale = false;

        emit AgreementSold(agreementId, msg.sender);
    }



    /**
     * @dev Allows funds to be released to the borrower if the maturity time has passed, deducting performance and management fees.
     * @param agreementId The ID of the agreement from which funds are to be released.
     */


    function releaseFunds(uint256 agreementId) external {
        Agreement storage agreement = agreements[agreementId];
        require(block.timestamp >= agreement.maturityTime, "The maturity period has not yet passed.");
        require(!agreement.fundsReleased, "Funds have already been released.");
        require(msg.sender == lender || msg.sender == agreement.borrower, "Only the lender or the borrower can release funds.");

        uint256 performanceFee = agreement.amount * 15 / 100; // 15% performance fee
        uint256 managementFee = agreement.amount * 15 / 1000; // 1.5% management fee
        uint256 totalFees = performanceFee + managementFee;
        uint256 releaseAmount = agreement.amount - totalFees;

        agreement.feesDeducted = totalFees;
        agreement.fundsReleased = true;
        agreement.borrower.transfer(releaseAmount);

        emit FundsReleased(agreementId, releaseAmount, totalFees);
    }

    
}
