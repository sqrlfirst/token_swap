//"SPDX-License-Identifier: MIT"
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";


contract bridge is AccessControl {

    bytes32 public constant VALIDATOR_ROLE = keccak256("VALIDATOR_ROLE");

    mapping (string => address) tokensBySymbol;
    mapping () swaps;       // CONTINUE

    event swapHappend();

    constructor (
        address addr_back
    ) public {
        _setupRole(VALIDATOR_ROLE, addr_back);      // _??_: it's correct way to set up validator role?//  

    }


    function swap {
        /*  - burn tokens from user                 *
         *  - write to swap MAP hash of transaction *
         *  - change status of swap                 *
         *  - emit swapHappend event                */ 


        emit swapHappend();
    }

    function addToken {
        // add tokens to contract for  swapping // 
        
    }

}