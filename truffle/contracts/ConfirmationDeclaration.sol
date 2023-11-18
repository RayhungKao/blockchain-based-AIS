pragma solidity ^0.8.18;

contract ConfirmationDeclaration {
    address public seller;
    address public buyer;
    uint public txId;
    string public hashedTxInformation;
    // string public homomophicEncryptedPriceForSeller;
    // string public homomophicEncryptedPriceForBuyer;

    enum DeliveryState {Ready, Sent, Accepted}
    enum PaymentState {Ready, Paid, Accepted}

    DeliveryState public deliveryState;
    PaymentState public paymentState;

    // modifier to check if sender is the pre-defined seller
    modifier isSeller() {
        require(msg.sender == seller, "MSG.SENDER is not the seller");
        _;
    }

    // modifier to check if sender is the pre-defined buyer
    modifier isBuyer() {
        require(msg.sender == buyer, "MSG.SENDER is not the buyer");
        _;
    }
    
    /**
     * @dev Initialize contract information
     */
    constructor(address sellerAddress, address buyerAddress, uint id, string memory hashedTx) {
        seller = sellerAddress;
        buyer = buyerAddress;
        txId = id;
        hashedTxInformation = hashedTx;
        deliveryState = DeliveryState.Ready;
        paymentState = PaymentState.Ready;
    }

    function send() public isSeller {
        require(msg.sender == seller, "msg.sender is not the seller");
        require(deliveryState == DeliveryState.Ready, "Cannot send yet.");

        deliveryState = DeliveryState.Sent;
    }

    function accept() public isBuyer {
        require(msg.sender == buyer, "msg.sender is not the buyer");
        require(deliveryState == DeliveryState.Sent, "Cannot accept yet.");

        deliveryState = DeliveryState.Accepted;
    }
    
    function pay() public isBuyer {
        require(msg.sender == buyer, "msg.sender is not the buyer");
        require(paymentState == PaymentState.Ready, "Cannot pay yet.");

        paymentState = PaymentState.Paid;
    }

    function withdraw() public isSeller {
        require(msg.sender == seller, "msg.sender is not the seller");
        require(paymentState == PaymentState.Paid, "Cannot withdraw yet.");

        paymentState = PaymentState.Accepted;
    }
}