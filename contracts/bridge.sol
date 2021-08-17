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
        uint256 initChain, 
        uint256 destChain, 
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
        uint256 _initChain, 
        uint256 _destChain, 
        address _sender,
        address _recepient,
        uint256 _amount,
        string memory _tokenSymbol,
        uint256 _nonce 
    ) external nonReeternal returns (bool)
    {
        require(tokensBySymbol[symbol] != address(0), "Token not registered.");
        

        BullDogToken(tokensBySymbol[symbol]).burn(msg.sender, amount);
        swaps[txHash] = SwapsInfo(STATE.WAIT, nonce);
        
        /*  - emit swapHappend event   */ 

        // todo 
        emit eventSwap();
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