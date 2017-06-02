# 介入truffle
```bash
mkdir sc_learn_2 && cd sc_learn_2
npm install ethereumjs-testrpc web3
```

* 2.安装truffle模块：npm install truffle

* 3.启动testrpc：node_modules/.bin/testrpc

---

* 4.安装webpack（前段打包压缩监听。。）：npm install webpack 

* 5.实用默认初始框架：node_modules/.bin/truffle init webpack

* 6.先查看下该项目下大概的结构以及默认文件的内容。

* 7.contracts文件夹下面文件删除ConvertLib.sol和MetaCoin.sol示例，然后拷贝原来的voting.sol到该目录下。

* 8.更新migrations/2_deploy_contracts.js文件
```
var voting = artifacts.require("./voting.sol");
module.exports = function(deployer) {
  deployer.deploy(voting, ['Tom','Jack','Ann'], {gas: 300000});
};
```
* 9.更新app/javascript/app.js内容。
* 10.更新app/index.html内容。
* 11.实用truffle框架工具deploy合约：node_modules/.bin/truffle migrate
* 12.启动我们的truffle项目：npm run dev，然后根据提示访问：http://localhost:8080










---

Original version

```bash
mkdir sc_learn_2 && cd sc_learn_2
npm install ethereumjs-testrpc web3
```

* 2.安装truffle模块：npm install truffle
* 3安装webpack（前段打包压缩监听。。）：npm install webpack 
* 4.启动testrpc：node_modules/.bin/testrpc
* 5.使用默认初始框架：node_modules/.bin/truffle init webpack
* 6.实用truffle框架工具deploy合约：node_modules/.bin/truffle migrate
* 7.启动我们的truffle项目：npm run dev，然后根据提示访问：http://localhost:8080