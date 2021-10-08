//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Escrow {
    enum State {
        AWAITING_PAYMENT,
        AWAITING_DELIVERY,
        COMPLETE
    }

    State currentState;

    address public buyer;
    address payable public seller;

    modifier buyerOnly() {
        require(msg.sender == buyer);
        _;
    }

    constructor(address _buyer, address payable _seller) {
        buyer = _buyer;
        seller = _seller;
    }

    function comfirmPayment() payable buyerOnly public {
        require(currentState == State.AWAITING_PAYMENT);
        currentState = State.AWAITING_DELIVERY;
    }

    function confirmDelivery() payable buyerOnly public {
        require(currentState == State.AWAITING_DELIVERY);
        seller.transfer(address(this).balance);
        currentState = State.COMPLETE;
    }
}
