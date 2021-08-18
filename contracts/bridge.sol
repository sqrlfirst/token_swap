//"SPDX-License-Identifier: MIT"
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./bulldogtoken.sol";


contract bridge is AccessControl {

    bytes32 public constant VALIDATOR_ROLE = keccak256("VALIDATOR_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    enum State {
        empty,            
        initialized,      
        redeemed         
    } 

    struct SwapsInfo{
        State state;
        uint256 nonce;  
    }

    mapping (string => address) tokensBySymbol;
    mapping (bytes32 => SwapsInfo) swaps;       
    mapping (uint256 => bool) chains;

    uint256 private chainId;

    event eventSwap ( 
        uint256 chainFrom, 
        uint256 chainTo, 
        address sender,
        address recepient,
        uint256 amount,
        string  tokenSymbol,
        uint256 nonce
    ); 

    constructor (address addr_back, uint256 _chainFrom, uint256 _chainTo) {
        _setupRole(VALIDATOR_ROLE, addr_back);       
        _setupRole(ADMIN_ROLE,msg.sender);
        _setRoleAdmin(ADMIN_ROLE, DEFAULT_ADMIN_ROLE);

        chainId = _chainFrom;
        chains[_chainTo] = true;
    }

    function swap(
        uint256 _amount,            // 
        uint256 _nonce,             // ID of transaction
        address _recepient,         //  
        uint256 _chainTo,           // 
        string memory _tokenSymbol  // Symbol of token
    ) external nonReeternal returns (bool)
    {
        require(
            _chainTo != chainId,
            "bridge_swap:: chains are same"    
        );
        require(
            chains[_chainTo] == true,
            "bridge_swap:: chain is not enabled"
        );
        require(
            tokensBySymbol[_tokenSymbol] != address(0),
            "bridge_swap:: there is no such token in contract"
        );
        
        bytes32 hashedMsg = keccak256(
            abi.encodePacked(
                _amount,
                _nonce,
                msg.sender, // sender 
                _recepient,
                chainId, // chainFrom
                _chainTo,
                _tokenSymbol
            )
        );

        require(
            swaps[hashedMsg].state == State.empty,  
            "bridge_swap:: swap already exists."
        );

        BullDogToken(tokensBySymbol[_tokenSymbol]).burn(msg.sender, _amount);
        
        swaps[hashedMsg] = SwapsInfo({
            state: State.initialized,
            nonce: _nonce
        });
        
        emit eventSwap(
            chainId,
            _chainTo,
            msg.sender,
            _recepient,
            _amount,
            _tokenSymbol,
            _nonce
        );

        return true;
    }

    function addToken (
        string memory _tokenSymbol,
        address _tokenAdress
    ) external returns (bool)
    {
        require(
            hasRole(ADMIN_ROLE, msg.sender),
            "bridge_addToken:: sender is not an admin"
        );

        tokensBySymbol[_tokenSymbol] = _tokenAdress;
        return true;
    }

}