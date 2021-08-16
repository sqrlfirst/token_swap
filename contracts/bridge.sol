//"SPDX-License-Identifier: MIT"
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract bridge is AccessControl {

    bytes32 public constant VALIDATOR_ROLE = keccak256("VALIDATOR_ROLE");
    enum STATE {UNDONE, WAIT, DONE} // states writen as an example 
                                    // not working one, change later

    struct SwapsInfo{
        STATE state;
        uint256 nonce; // not sure about type 
    };

    mapping (string => address) tokensBySymbol;
    mapping (bytes32 => SwapsInfo) swaps;       // CONTINUE

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

    function addToken(string _tokenSymbol, address _tokenAdress) external {
        // add tokens to contract for  swapping // 

    }

}