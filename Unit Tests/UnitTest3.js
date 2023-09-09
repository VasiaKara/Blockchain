const Auction = artifacts.require("Auction");
const truffleAssert = require('truffle-assertions');

contract("Auction unit test 3", async accounts => {
  it("Contract's balance should get updated after a new bid", async () => {
    const instance = await Auction.deployed();
    const oldBalance = await web3.eth.getBalance(instance.address);
    assert.equal(oldBalance, 0);
    await instance.bid({value:100000, from:accounts[2]});
    const newBalance = await web3.eth.getBalance(instance.address);
    assert.equal(newBalance, 100000);
  });
})
