var voting = artifacts.require("./voting.sol");
module.exports = function(deployer) {
  deployer.deploy(voting, ['Tom','Jack','Ann'], {gas: 300000});
};
