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

    event eventSwap ( 
        uint256 chainFrom, 
        uint256 chainTo, 
        address sender,
        address recepient,
        uint256 amount,
        string  tokenSymbol,
        uint256 nonce
    ); 

    constructor (address addr_back) {
        _setupRole(VALIDATOR_ROLE, addr_back);       
        _setupRole(ADMIN_ROLE,msg.sender);


    }

    function swap(
        uint256 _amount,
        uint256 _nonce, 
        address _recepient,
        uint256 _chainTo, 
        string memory _tokenSymbol
    ) external nonReeternal returns (bool)
    {
        require(tokensBySymbol[symbol] != address(0), "Token not registered.");
        
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
        swaps[hashedMsg] = SwapsInfo(STATE.WAIT, nonce);
        
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
        // role of msg.sender is ADMIN?
        tokensBySymbol[_tokenSymbol] = _tokenAdress;
        return true;
    }

}