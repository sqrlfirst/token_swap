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
        uint256 nonce; // not sure about type 
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
        uint256 _amount,
        uint256 _nonce, 
        address _recepient,
        uint256 _chainTo, 
        string memory _tokenSymbol
    ) external nonReeternal returns (bool)
    {
        require(
            _chainTo != _chainId,
            "bridge_swap:: chains are same"    
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

        BullDogToken(tokensBySymbol[symbol]).burn(msg.sender, amount);
        swaps[hashedMsg] = SwapsInfo({
            state: STATE.initialized,
            nonce: _nonce
        });
        
        // todo 
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