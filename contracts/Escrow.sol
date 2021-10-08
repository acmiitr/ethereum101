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

    address buyer;
    address seller;

    modifier buyerOnly(address _buyer) {
        require(msg.sender == buyer);
        _;
    }

    constructor(address _buyer, address _seller) {
        buyer = _buyer;
        seller = _seller;
    }

    function comfirmPayment() payable buyerOnly {
        require(currentState == State.AWAITING_PAYMENT);
        currentState = State.AWAITING_DELIVERY;
    }

    function confirmDelivery() buyerOnly {
        require(currentState == State.AWAITING_DELIVERY);
        seller.send(address(this).balance);
        currentState = State.COMPLETE;
    }
}
