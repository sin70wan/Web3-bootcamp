// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenRegistry {
    struct Token {
        string name;      
        string symbol;   
        address owner;    
        bool isActive;    
    }
    
    
    // mapping
    mapping(uint256 => Token) public tokens;
    
    // List of all token IDs
    uint256[] public tokenIds;
    
    // Counter for next available ID (starts at 1)
    uint256 private nextTokenId = 1;
    
    
    // when a new token is registered
    event TokenRegistered(
        uint256 indexed tokenId,
        string name,
        string symbol,
        address indexed owner
    );
    
    
    function registerToken(string memory _name, string memory _symbol) public {
        // Validation: Name cannot be empty
        require(bytes(_name).length > 0, "Token name cannot be empty");
        
        // Validation: Symbol cannot be empty
        require(bytes(_symbol).length > 0, "Token symbol cannot be empty");
        
        // Create the token form
        Token memory newToken = Token({
            name: _name,
            symbol: _symbol,
            owner: msg.sender,      // Caller becomes owner
            isActive: true          // New tokens start active
        });
        
        // Store in filing cabinet
        tokens[nextTokenId] = newToken;
        
        // Add ID to our list
        tokenIds.push(nextTokenId);
        
        // Ring the bell!
        emit TokenRegistered(nextTokenId, _name, _symbol, msg.sender);
        
        // Prepare for next token
        nextTokenId++;
    }
    
    
    function deactivateToken(uint256 _id) public {
        // Check 1: Does token exist?
        require(_id < nextTokenId, "Token does not exist");
        
        // Check 2: Are you the owner?
        require(tokens[_id].owner == msg.sender, "Only owner can deactivate");
        
        // Check 3: Is it already inactive?
        require(tokens[_id].isActive == true, "Token already inactive");
        
        // Deactivate
        tokens[_id].isActive = false;
    }
    
    
    function getToken(uint256 _id) public view returns (
        string memory name,
        string memory symbol,
        address owner,
        bool isActive
    ) {
        // Check if token exists
        require(_id < nextTokenId, "Token does not exist");
        
        // Get from filing cabinet
        Token storage token = tokens[_id];
        
        // Return all info
        return (token.name, token.symbol, token.owner, token.isActive);
    }
    
    
    function getAllTokenIds() public view returns (uint256[] memory) {
        return tokenIds;
    }
    
    
    function getTokenCount() public view returns (uint256) {
        return tokenIds.length;
    }
}