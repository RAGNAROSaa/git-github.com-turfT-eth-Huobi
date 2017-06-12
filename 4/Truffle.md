[TOC]



## Truffle

#### 安装

> npm install -g truffle

#### 初始化

>```shell
>mkdir myproject
> cd myproject
> truffle init
>```

或者高级设置

>```
>truffle init webpack
>```

#### 文件详解
truffle.js =>端口映射，configuration

Test => 测试

contract=>合约代码

migrations=>迁移，用来部署

#### 编译合约

```
truffle compile
```
编译abi 的json 到 build 文件夹，不要手工修改。会覆盖。


>Compiling ./contracts/ConvertLib.sol...
>Compiling ./contracts/MetaCoin.sol...
>Compiling ./contracts/Migrations.sol...
>Writing artifacts to ./build/contracts



#### 迁移（部署）合约 migrations

* *truffle* 2.0以上的deploy变成migrate了.

需要test_rpc 或者真实区块链。部署前的一步。

所以先赞装test rpc 并且开启

原因是会产生交易。

rpc： 远程接口调用。

>```
>truffle migrate
>```

### 测试

我们的模版目录下面有两个文件 一个js， 一个 sol。 Js 测试合约之外， Sol 测试合约，假装执行。。

.sol:

```javascript
pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MetaCoin.sol";

contract TestMetacoin {

  function testInitialBalanceUsingDeployedContract() {
    MetaCoin meta = MetaCoin(DeployedAddresses.MetaCoin());

    uint expected = 10000;

    Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 MetaCoin initially");
  }

  function testInitialBalanceWithNewMetaCoin() {
    MetaCoin meta = new MetaCoin();

    uint expected = 10000;

    Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 MetaCoin initially");
  }

}
```



- 不要extend， 这样可以保证测试简单，明确，可控
- 使用truffle 内置的assert， 这个藏在[Assert.sol](https://github.com/ConsenSys/truffle/blob/beta/lib/testing/Assert.sol)
- turffle 提供了DeployedAddresses.sol 实际是在做字符串拼接。
- 本身也是合约

```javascript
var Deployed = {
  makeSolidityDeployedAddressesLibrary: function(mapping) {
    var source = "";
    source += "pragma solidity ^0.4.6; \n\n library DeployedAddresses {" + "\n";
    Object.keys(mapping).forEach(function(name) {
      var address = mapping[name];
      var body = "throw;";

      if (address) {
        body = "return " + address + ";";
      }
      source += "  function " + name + "() returns (address) { " + body + " }"
      source += "\n";
    });
    source += "}";
    return source;
  }
};
module.exports = Deployed;
```

还有一些高级功能，比如测试异常是否能正确抛出。



#### 有关 js 的测试

1. 重新部署。
2. 使用配发账号
3. artifacts.require() 指明你要测试哪个合约


---

发送交易的测试

 >```javascript
 >var account_one = "0x1234..."; // an address
 >var account_two = "0xabcd..."; // another address
 >var meta;
 >MetaCoin.deployed().then(function(instance) {
 >  meta = instance;
 >  return meta.sendCoin(account_two, 10, {from: account_one});
 >}).then(function(result) {
 >  // If this callback is called, the transaction was successfully processed.
 >  alert("Transaction successful!")
 >}).catch(function(e) {
 >  // There was an error! Handle it.
 >})
 >```

捕获事件

>```javascript
>var account_one = "0x1234..."; // an address
>var account_two = "0xabcd..."; // another address
>
>var meta;
>MetaCoin.deployed().then(function(instance) {
>  meta = instance;  
>  return meta.sendCoin(account_two, 10, {from: account_one});
>}).then(function(result) {
>  // result is an object with the following values:
>  //
>  // result.tx      => transaction hash, string
>  // result.logs    => array of decoded events that were triggered within this transaction
>  // result.receipt => transaction receipt object, which includes gas used
>
>  // We can loop through result.logs to see if we triggered the Transfer event.
>  for (var i = 0; i < result.logs.length; i++) {
>    var log = result.logs[i];
>
>    if (log.event == "Transfer") {
>      // We found the event!
>      break;
>    }
>  }
>}).catch(function(err) {
>  // There was an error! Handle it.
>});
>```

更多高级内容涉及javascript 的语法。





执行测试：

```bash
truffle test
or
truffle test ./test/TestMetacoin.sol
```

这一步我们获得了什么好处：

1. 测试可以自动化
2. 测试可以分工







### Truffle的好处都有啥

1. 一键启动项目，compile，build，测试，部署
2. 包管理工具 （略， ETHPM， NPM） 包括发布自己的package。
3. 独立的console 等效testrpc 的geth
4. 提供可扩展的高级功能（实际上就是一些好用的包）。









*如果要在一个可信节点的私有链条写智能合约，推荐下面的教程。

*http://truffleframework.com/tutorials/building-dapps-for-quorum-private-enterprise-blockchains









###ERC 20 标准

#### 动机

代币有统一接口。

交易所友好。

#### 部分要求

* 总量
* 地址余额
* 转账查询
* 交易所对应使用的 transfer。
* 授权 B给A ： “B 账户的部分资金控制权 ”



标准代币=》 交易所可以方便处理



#### ConsenSys Tokens

https://github.com/ConsenSys/Tokens

#### 符合ERC20 的标准合约

![WX20170609-114033](/Users/houliang/Desktop/eth-Huobi/git-github.com-turfT-eth-Huobi.git/WX20170609-114033.png)



```javascript
pragma solidity ^0.4.2;
contract owned {
    address public owner;

  //所有权
    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }

contract token {
    /* Public variables of the token */
    string public standard = 'Token 0.1';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function token(
        uint256 initialSupply,
        string tokenName,
        uint8 decimalUnits,
        string tokenSymbol
        ) {
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        totalSupply = initialSupply;                        // Update total supply
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
        decimals = decimalUnits;                            // Amount of decimals for display purposes
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
    }

    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value)
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    /* Approve and then communicate the approved contract in a single tx */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        returns (bool success) {    
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
        if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
        balanceOf[_from] -= _value;                          // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    /* This unnamed function is called whenever someone tries to send ether to it */
    function () {
        throw;     // Prevents accidental sending of ether
    }
}

contract MyAdvancedToken is owned, token {

    uint256 public sellPrice;
    uint256 public buyPrice;

    mapping (address => bool) public frozenAccount;

    /* This generates a public event on the blockchain that will notify clients */
    event FrozenFunds(address target, bool frozen);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function MyAdvancedToken(
        uint256 initialSupply,
        string tokenName,
        uint8 decimalUnits,
        string tokenSymbol
    ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        if (frozenAccount[msg.sender]) throw;                // Check if frozen
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
    }


    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (frozenAccount[_from]) throw;                        // Check if frozen            
        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
        if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
        balanceOf[_from] -= _value;                          // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function mintToken(address target, uint256 mintedAmount) onlyOwner {
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0, this, mintedAmount);
        Transfer(this, target, mintedAmount);
    }

    function freezeAccount(address target, bool freeze) onlyOwner {
        frozenAccount[target] = freeze;
        FrozenFunds(target, freeze);
    }

    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }

    function buy() payable {
        uint amount = msg.value / buyPrice;                // calculates the amount
        if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
        balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
        balanceOf[this] -= amount;                         // subtracts amount from seller's balance
        Transfer(this, msg.sender, amount);                // execute an event reflecting the change
    }

    function sell(uint256 amount) {
        if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
        balanceOf[this] += amount;                         // adds the amount to owner's balance
        balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
        if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
            throw;                                         // to do this last to avoid recursion attacks
        } else {
            Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
        }               
    }
}
```











----

## 央财链-区块链校园应用项目具体规划

央财链-校园应用项目范围：中央财经大学宿舍、班级、学院、校级投票管理，包括限时投票、匿名投票、单选投票、多选投票、实时结果查询、结果保存、投票终端建设等。

1. 建立区块链投票的规则。包括每一种区块链投票的发起规则、邀请规则、投票规则、可见规则、修改规则、关闭规则、退出规则。
2. 建立完整的数据产生、转发、存储、备份、和处理规则。
3. 为了系统安全有效的运营，必须建立一整套的安全密钥、投票规则数据、交易数据的定义和产生规则，数据在终端和MIS之间的传输以及数据的存储备份规则，对不同的投票应用要有相应的数据处理规则等。
4. 建立数据统计中心。
5. 建立系统安全控管与保障体系。安全和防止虚假投票是投票系统重要目标之一，建立健全的系统安全控管与保障体系是保证整个系统正常安全运行的必要手段。它主要包括密钥的产生、分发、保存和管理、数据的安全传输等。





























我们能给什么：

培训

一起做完demo

要求作业。 houliang@huobi.com