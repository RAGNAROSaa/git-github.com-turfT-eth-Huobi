# 简单开发流程

投票合约怎么写



1.投票合约的中心化版本

* 实现基本功能
* 可测试

2.测试

3.去中心化版本

* 思考什么部分应该放到区块链上


* 考虑安全性
* 分布式后的需求变动（eg 匿名性）

4.测试，发布，长期维护。

5.经历过诸多不方便，我们采用turffle



























基础功能组件：

需要的数据结构：

1 一个字典  记录 投票结果 votesReceived

2.一个候选人名单 canList



需要的函数

1.初始化候选名单 voting

2.任意时间查询投票结果 totalVotersFor

3.投票给指定候选人 voteForCandidate

















怎么改进

非法投票验证（实践）

匿名投票

初始化绑定（参见 mint 例子）



etc ..作业！



















































Requirements: 系统mac，已经安装homebrew

ubuntu 系统使用 apt-get 代替brew

1.termial安装nvm,并根据提示配置好nvm环境变量，确保nvm命令可使用。

`brew install nvm`

2.安装最新stable版本node，顺带同时安装npm了。

`nvm install stable`

3.记得查看下当前状态：
```
node -v
npm -v
```
4.然后在合适位置创建工程文件夹：sc_learn

`mkdir sc_learn && cd sc_learn`

5.然后在工程目录安装所需的module：(这里下课。)

`npm install ethereumjs-testrpc web3`

https://github.com/ethereum/web3.js/

https://github.com/ethereumjs/testrpc

主要功能是假装有测试链，我们设定的是自动打包交易。



6.打开新terminal的tab并cd到工程目录执行命令：

`node_modules/.bin/testrpc`

这里会给我们创建10个账户，以及每个账户有一定的以太坊。

7.编写我们的投票合约voting.sol

8.打开新terminal的tab并执行node:
```
node
> Web3 = require('web3')
> web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
> web3.eth.accounts
> vote = fs.readFileSync('voting.sol').toString()
> contract = web3.eth.compile.solidity(vote)
> votingContract = web3.eth.contract(contract.info.abiDefinition)
> deployedContract = votingContract.new(['Tom','Jack','Ann'],{data: contract.code, from: web3.eth.accounts[0], gas: 3600000})
> contractInstance = votingContract.at(deployedContract.address)
> contractInstance.totalVotesFor.call('Tom')
> contractInstance.voteForCandidate('Tom', {from: web3.eth.accounts[0]})
> contractInstance.voteForCandidate('Tom', {from: web3.eth.accounts[0]})
> contractInstance.totalVotesFor.call('Tom').toLocaleString()
```







## 作业

完成度：

1. 开发文档。
2. 代码实现。
3. 测试部署（要自己写单元测试）。
4. +UI端





1. 投标 荷兰式拍卖

>减价式拍卖通常从非常高的价格开始，高的程度有时没有人竞价，这时，价格就以事先确定的数量下降，直到有竞买人愿意接受为止。荷兰式拍卖在减价式拍卖中，第一个实际的竞价常常是最后的竞价。那么，从何谈起这里有竞买人之间激烈的竞争呢？这里确实有竞争是毋庸置疑的，虽然仅仅只有一个竞价，但是这个仅有的竞价是对预期的一种直接反应，如果自己不出价，那么别人就会出价从而失去物品。

参考：

http://solidity.readthedocs.io/en/develop/solidity-by-example.html

中提供了两种拍卖案例。

2. 投票合约的隐私性增强

   参考：

   1. 今天的简陋版的投票
   2.  官方样例 http://solidity.readthedocs.io/en/develop/solidity-by-example.html 中的投票系统
   3. 论文 https://eprint.iacr.org/2017/110.pdf

   ​

3. ​

   ​

   ​

