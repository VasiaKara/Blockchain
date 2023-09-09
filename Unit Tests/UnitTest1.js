const Auction = artifacts.require("Auction");
const truffleAssert = require('truffle-assertions');

contract("Auction unit test 1", async accounts => {
  it("withdraw() should fail if msg.sender is the highestBidder", async () => {
    const instance = await Auction.deployed();
    await instance.bid({value:50000, from:accounts[1]});
    await truffleAssert.reverts(
        instance.withdraw({from:accounts[1]}),
       "You can not be the highestBidder in order to proceed!"
    );
  });

})
