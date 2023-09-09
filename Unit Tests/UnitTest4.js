const Auction = artifacts.require("Auction");
const truffleAssert = require('truffle-assertions');

contract("Auction unit test 4", async accounts => {
  it("withdraw() should not fail if msg.sender is not the highestBidder", async () => {
    const instance = await Auction.deployed();
    const Balance1 = await web3.eth.getBalance(instance.address);
    assert.equal(Balance1, 0);
    await instance.bid({value:5000000000000000000, from:accounts[3]});
    const Balance2 = await web3.eth.getBalance(instance.address);
    assert.equal(Balance2, 5000000000000000000);
    await instance.bid({value:10000000000000000000, from:accounts[4]});
    const Balance3 = await web3.eth.getBalance(instance.address);
    assert.equal(Balance3, 15000000000000000000);
    await instance.withdraw({from:accounts[3]});
    const Balance4 = await web3.eth.getBalance(instance.address);
    assert.equal(Balance4, 10000000000000000000);
  });
})

