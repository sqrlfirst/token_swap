//"SPDX-License-Identifier: MIT"
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./bulldogtoken.sol";


contract bridge is AccessControl {

    bytes32 public constant VALIDATOR_ROLE = keccak256("VALIDATOR_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    enum STATE {
        empty,            
        initialized,      
        redeemed         
    } 

    struct SwapsInfo{
        STATE state;
        uint256 nonce;  
    }

    mapping (string => address) tokensBySymbol;
    mapping (bytes32 => SwapsInfo) swaps;       
    mapping (uint256 => bool) chains;

    uint256 public ChainId;

    event eventSwap ( 
        uint256 chainFrom, 
        uint256 chainTo, 
        address sender,
        address recepient,
        uint256 amount,
        string  tokenSymbol,
        uint256 nonce
    ); 

    constructor (address addr_back, uint256 _chainFrom) {
        _setupRole(VALIDATOR_ROLE, addr_back);       
        _setupRole(ADMIN_ROLE,msg.sender);
        _setRoleAdmin(ADMIN_ROLE, DEFAULT_ADMIN_ROLE);

        ChainId = _chainFrom;
        chains[ChainId] = true;

        /* ADD Some info about others blochains*/

    }

    function swap(
        uint256 _amount,            // 
        uint256 _nonce,             // ID of transaction
        address _recepient,         //  
        uint256 _chainTo,           // 
        string memory _tokenSymbol  // Symbol of token
    ) external nonReeternal returns (bool)
    {
        /*
         *
         *
         */

        require(
            _chainTo != _chainId,
            "bridge_swap:: chains are same"    
        );
        require(
            chains[ChainTo] == true,
            "bridge_swap:: chain is not enabled"
        );
        require(
            tokensBySymbol[symbol] != address(0),
            "bridge_swap:: there is no such token in contract"
        );
        
        bytes32 hashedMsg = keccak256(
            abi.encodePacked(
                _amount,
                _nonce,
                msg.sender, // sender 
                _recepient,
                _chainId, // chainFrom
                _chainTo,
                tokenSymbol
            )
        );

        require(
            swaps[hashedMsg].state == empty,  
            "bridge_swap:: swap already exists."
        );

        BullDogToken(tokensBySymbol[symbol]).burn(msg.sender, amount);
        
        swaps[hashedMsg] = SwapsInfo({
            state: STATE.initialized,
            nonce: _nonce
        });
        
        emit eventSwap(
            _chainId,
            _chainTo,
            _sender,
            _recepient,
            _amount,
            tokenSymbol,
            nonce
        );
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