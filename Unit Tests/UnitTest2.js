const Auction = artifacts.require("Auction");
const truffleAssert = require('truffle-assertions');

contract("Auction unit test 2", async accounts => {
  it("HighestBid should get updated after a new bid", async () => {
    const instance = await Auction.deployed();
    await instance.bid({value:60000, from:accounts[1]});
    highestBid = await instance.highestBid();
    assert.equal(highestBid, 60000);
  });
})
