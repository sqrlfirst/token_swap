//"SPDX-License-Identifier: MIT"
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./bulldogtoken.sol";


contract bridge is AccessControl {

    bytes32 public constant VALIDATOR_ROLE = keccak256("VALIDATOR_ROLE");
    enum STATE {UNDONE, WAIT, DONE} // states writen as an example 
                                    // not working one, change later

    struct SwapsInfo{
        STATE state;
        uint256 nonce; // not sure about type 
    }

    mapping (string => address) tokensBySymbol;
    mapping (bytes32 => SwapsInfo) swaps;       // CONTINUE

    event eventSwap(address sourceAddress, 
                    address destinationAddress,
                    address sender,
                    address recepient,
                    address amount,
                    address token,
                    bytes32 seed
                    ); 

    constructor (address addr_back) {
        _setupRole(VALIDATOR_ROLE, addr_back);      // _??_: it's correct way to set up validator role?// I think its correct 
    }


    function swap(bytes memory signature, address recepient, uint amount, string memory symbol, bytes32 txHash) external {
        require(tokensBySymbol[symbol] != address(0), "Token not registered.");
        
        // todo verify

        //ERC20(tokensBySymbol[symbol]).burn(msg.sender, amount);
        /*  - burn tokens from user                 *
         *  - write to swap MAP hash of transaction *
         *  - change status of swap                 *
         *  - emit swapHappend event                */ 


        //emit eventSwap();
    }

    function addToken(string memory _tokenSymbol, address _tokenAdress) external {
        // add tokens to contract for  swapping // 
        tokensBySymbol[_tokenSymbol] = _tokenAdress;
    }

}