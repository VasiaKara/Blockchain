// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <= 0.8.3;

contract Auction {
    address payable owner; // contractor
    address public highestBidder; // The highest bidder's address
    uint public highestBid; // The amount of the highest bid
    uint end;
    uint backup = 0;
    uint backupBid;
    address backupBidder;
    
    mapping(address => uint) public userBalances; // mapping for the amount to return

    
    modifier notOwner(){
        require(payable(msg.sender) !=owner ,"You can not be the owner in order to proceed!");
        _;
    }
    
    modifier nothighestBidder(){
        require(msg.sender != highestBidder,"You can not be the highestBidder in order to proceed!");
        _;
    }
    
    
    constructor() {
        // contractor
        owner =payable(msg.sender);
        end = 0;
        // Initialize highest bid and the bidder's address
        highestBid = 0;
        highestBidder = owner;
    }
    
    function bid() public payable notOwner{
        // Function to process bid
        // Check if the bid is greater than the current highest bid
        require(msg.value > highestBid, "There is already a same or higher bid!");
        // Update status variable and the amount to return
        backupBid = highestBid;
        backupBidder = highestBidder;
        highestBid = msg.value;
        highestBidder = msg.sender;
        
        if(msg.value > userBalances[msg.sender]){
            if(userBalances[msg.sender] != 0){
                if (!payable(msg.sender).send(userBalances[msg.sender])){//if we have an unsuccessful call of send, don't count him as the highestBidder
                    highestBid = backupBid;
                    highestBidder = backupBidder;
                    require(true, "You had an unsuccessful call of bit, try again!");
                }
            }
        }
        
        userBalances[msg.sender] = msg.value;
    }
    
    function getContractBalance() public view returns(uint){
        //Function to contract's balance
        return(address(this).balance);
    }
    
    function withdraw() public nothighestBidder{
        // Function to withdraw the amount of bid to return
        // Check if the amount to return is greater than zero
        require((userBalances[msg.sender] > 0 || msg.sender == owner), "The amount to return must be greater than zero!");
        
        // Update status variable and return bid
        if (msg.sender == owner){
            backup = highestBid;
        }
        else{
            backup = userBalances[msg.sender];
            userBalances[msg.sender] = 0;
        }
        if (!payable(msg.sender).send(backup)) {//if we have an unsuccessful call of send, don't lose the money
            userBalances[msg.sender] = backup;
            require(true, "You had an unsuccessful call of send, try again!");
        }
    }
}
