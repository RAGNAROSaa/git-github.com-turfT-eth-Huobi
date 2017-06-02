# 智能合约开发+ solidity

## 工具

我们2014年 的工具



![img](http://upyun-assets.ethfans.org/uploads/photo/image/d113b303b7f7445599cc66aec4ea71ef.png)



我们在2017 年的工具

![img](http://upyun-assets.ethfans.org/uploads/photo/image/01056472e01543ad830638089b5ac78c.png)



所以，我们学习的东西随时会过时。



## Solidity 的生态



|       | APP            | DAPP           |
| ----- | -------------- | -------------- |
| 语言    | java           | solidity       |
| 框架    | java 的 spring  | truffle／Embark |
| 通讯协议  | SMTP,POP3,HTTP | whipser        |
| 存储    | AWS& sql       | swarm／IPFS     |
| id 地址 | DNS            | ENS            |



mist&parity& geth  ： 笨重，需要打包。

web3.js+ test rpc ：快速的编程

truffle： 套路的编程。（隐藏一些技术细节。）

## 目标 

几个例子（ 语法特征）=》一个简单的demo（开发流程）=》一个作业

#### 存储一个整数，后读取。

```javascript
contract SimpleStorage {
    uint storedData;

    function set(uint x) {
        storedData = x;
    }

    function get() constant returns (uint retVal) {
        return storedData;
    }
}
```

要点： 

* 没有this，OOP
* Unit 256bits无符号整数
* 状态变量
* setter和getter


#### 代币

Minter: 铸币局局长。

只有minter 可以选择分配每个人多少钱

其他人可以根据余额提款。

余额是公开信息。

>```javascript
>pragma solidity ^0.4.0;
>
>contract Coin {
>    // The keyword "public" makes those variables
>    // readable from outside.
>    address public minter;
>    mapping (address => uint) public balances;
>
>    // Events allow light clients to react on
>    // changes efficiently.
>    event Sent(address from, address to, uint amount);
>    // This is the constructor whose code is
>    // run only when the contract is created.
>    function Coin() {
>        minter = msg.sender;
>    }
>
>    function mint(address receiver, uint amount) {
>        if (msg.sender != minter) return;
>        balances[receiver] += amount;
>    }
>
>    function send(address receiver, uint amount) {
>        if (balances[msg.sender] < amount) return;
>        balances[msg.sender] -= amount;
>        balances[receiver] += amount;
>        Sent(msg.sender, receiver, amount);
>    }
>  // balance getter
>  function balances(address _account) returns (uint balance) {
>    return balances[_account];
>	}
>}
>```



* Public 关键字

* address 类型

  1. 禁止运算符操作
  2. 160Bit

* map 字典类型

* 同名构造函数

* 事件

  这行代码声明了一个“事件”。由send函数的最后一行代码触发。客户端（服务端应用也适用）可以以很低的开销来监听这些由区块链触发的事件。事件触发时，监听者会同时接收到from，to，value这些参数值，可以方便的用于跟踪交易。

* 隐藏的全局变量
   msg,tx,block  ：  “msg.sender”




#### 内部调用

给定金字塔高度，计算体积。

>```javascript
>pragma solidity ^0.4.5;
>
>library ArrayUtils {
>  // internal functions can be used in internal library functions because
>  // they will be part of the same code context
>  function map(uint[] memory self, function (uint) returns (uint) f)
>    internal
>    returns (uint[] memory r)
>  {
>    r = new uint[](self.length);
>    for (uint i = 0; i < self.length; i++) {
>      r[i] = f(self[i]);
>    }
>  }
>  function reduce(
>    uint[] memory self,
>    function (uint x, uint y) returns (uint) f
>  )
>    internal
>    returns (uint r)
>  {
>    r = self[0];
>    for (uint i = 1; i < self.length; i++) {
>      r = f(r, self[i]);
>    }
>  }
>  function range(uint length) internal returns (uint[] memory r) {
>    r = new uint[](length);
>    for (uint i = 0; i < r.length; i++) {
>      r[i] = i;
>    }
>  }
>}
>
>contract Pyramid {
>  using ArrayUtils for *;
>  function pyramid(uint l) returns (uint) {
>    return ArrayUtils.range(l).map(square).reduce(sum);
>  }
>  function square(uint x) internal returns (uint) {
>    return x * x;
>  }
>  function sum(uint x, uint y) internal returns (uint) {
>    return x + y;
>  }
>}
>```



* for 循环
* 内部调用libary=》 using
* 函数调用
* 函数式编程

#### 分布式众筹

```javascript

pragma solidity ^0.4.11;

contract CrowdFunding {
    // Defines a new type with two fields.
    struct Funder {
        address addr;
        uint amount;
    }
    struct Campaign {
        address beneficiary;
        uint fundingGoal;
        uint numFunders;
        uint amount;
        mapping (uint => Funder) funders;
    }
    uint numCampaigns;
    mapping (uint => Campaign) campaigns;

    function newCampaign(address beneficiary, uint goal) returns (uint campaignID) {
        campaignID = numCampaigns++; // campaignID is return variable
        // Creates new struct and saves in storage. We leave out the mapping type.
        campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0);
    }
    function contribute(uint campaignID) payable {
        Campaign c = campaigns[campaignID];
        // Creates a new temporary memory struct, initialised with the given values
        // and copies it over to storage.
        // Note that you can also use Funder(msg.sender, msg.value) to initialise.
        c.funders[c.numFunders++] = Funder({addr: msg.sender, amount: msg.value});
        c.amount += msg.value;
    }
    function checkGoalReached(uint campaignID) returns (bool reached) {
        Campaign c = campaigns[campaignID];
        if (c.amount < c.fundingGoal)
            return false;
        uint amount = c.amount;
        c.amount = 0;
        c.beneficiary.transfer(amount);
        return true;
    }
}
```



* 数据类型： 结构体
* 要手动check
* if 判断
* address 内置 transfer 属性。
* payable： Allows them to receive Ether together with a call.



| 数据结构   | 控制流    | 修饰             | 全局变量    | 密码学       |
| ------ | ------ | -------------- | ------- | --------- |
| struct | for    | public／private | block   | sha3      |
| uint   | if     | extrenal       | msg     | sha256    |
| map    | while  | payable        | tx      | ripemd160 |
|        | return |                | address |           |
|        | using  |                |         |           |
|        | else   |                |         |           |





## 其他需要注意的细节和建议

即使`private`  修饰过的，也是公开的。

随机数是个大bug，因为你的敌人可能是矿工，谨慎小心。

参见ppt。









### 一个健壮的例子

公开拍卖

需要什么数据结构

参与者应该都有谁

需要哪些工具函数



数据结构

1.受益人

2.投标开始

3.投标结束时间

4.需要保存所有投标人嘛？需要。

5.需要保存所有投标价格嘛？需要。

 工具函数

开始

投标

结算



```javascript
pragma solidity ^0.4.11;

contract SimpleAuction {
    address public beneficiary;// 钱打给谁
    uint public auctionStart;
    uint public biddingTime;

    //  当前状态
    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) pendingReturns;

    bool ended;
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

  // 初始化
    function SimpleAuction(
        uint _biddingTime,
        address _beneficiary
    ) {
        beneficiary = _beneficiary;
        auctionStart = now;
        biddingTime = _biddingTime;
    }

    function bid() payable {// 投标
        require(now <= (auctionStart + biddingTime));
        require(msg.value > highestBid);

        if (highestBidder != 0) {
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        HighestBidIncreased(msg.sender, msg.value);
    }
  
      function withdraw() returns (bool) {
        var amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            if (!msg.sender.send(amount)) {
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    /// 投标结束
    /// 转账给 beneficiary
    function auctionEnd() {
        require(now >= (auctionStart + biddingTime)); 
        require(!ended); 
        ended = true;
        AuctionEnded(highestBidder, highestBid);
        beneficiary.transfer(highestBid);
    }
}
```

