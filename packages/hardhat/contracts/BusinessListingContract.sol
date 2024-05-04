//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

contract BusinessListingContract {
    // Define the business listing structure
    struct Business {
        string abnOrACn;
        uint256 tokensAvailable;
        uint256 pricePerToken;
		address ownerAddress;
        string symbol;
    }

    // Event declarations
    event BusinessCreated(
        address indexed creator,
        string abnOrACn,
        uint256 tokensAvailable,
        uint256 pricePerToken,
        string symbol
    );

    event BusinessUpdated(
        address indexed updater,
        string abnOrACn,
        uint256 tokensAvailable,
        uint256 pricePerToken,
        string symbol
    );

    event BusinessDeleted(address indexed deletedBy, address indexed businessAddress);

    // Mapping to store business listings
    mapping (address => Business) public businessListings;
	address public owner;

    constructor() {
        owner = msg.sender; 
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Create a new business listing
    function createBusinessListing(
        string memory _abnOrACn,
        uint256 _tokensAvailable,
        uint256 _pricePerToken,
		address _ownerAddress,
        string memory _symbol
    ) public {
        require(bytes(_symbol).length >= 2 && bytes(_symbol).length <= 5, "Symbol must be between 2 and 5 characters");

        // Create a new business listing
        Business memory newBusiness = Business(
            _abnOrACn,
            _tokensAvailable,
            _pricePerToken,
			_ownerAddress,
            _symbol
        );

        // Store the business listing in the mapping
        businessListings[msg.sender] = newBusiness;

        // Emit the creation event
        emit BusinessCreated(
            msg.sender, 
            _abnOrACn, 
            _tokensAvailable, 
            _pricePerToken,
            _symbol
        );
    }

    // Retrieve a business listing by address
    function getBusinessListing(address _businessAddress) public view returns (
        string memory,
        uint256,
        uint256,
		address,
        string memory
    ) {
        // Retrieve the business listing from the mapping
        Business storage business = businessListings[_businessAddress];

        // Return the business listing details
        return (
            business.abnOrACn,
            business.tokensAvailable,
            business.pricePerToken,
            business.ownerAddress,
            business.symbol
        );
    }

    // Update a business listing
    function updateBusinessListing(
        string memory _abnOrACn,
        uint256 _tokensAvailable,
        uint256 _pricePerToken,
		address _ownerAddress,
        string memory _symbol
    ) public {
        require(bytes(_symbol).length >= 2 && bytes(_symbol).length <= 5, "Symbol must be between 2 and 5 characters");
        require(msg.sender == businessListings[msg.sender].ownerAddress, "Only the business owner can update the listing");

        // Update the business listing
        Business storage business = businessListings[msg.sender];
        business.abnOrACn = _abnOrACn;
        business.tokensAvailable = _tokensAvailable;
        business.pricePerToken = _pricePerToken;
        business.ownerAddress = _ownerAddress;
        business.symbol = _symbol;

        // Emit the update event
        emit BusinessUpdated(
            msg.sender, 
            _abnOrACn, 
            _tokensAvailable, 
            _pricePerToken,
            _symbol
        );
    }

	// Contract owner only able to delete listing
	function deleteBusinessListing(
		address _businessAddress
	) public onlyOwner {
        delete businessListings[_businessAddress];
        emit BusinessDeleted(msg.sender, _businessAddress);
    }
}