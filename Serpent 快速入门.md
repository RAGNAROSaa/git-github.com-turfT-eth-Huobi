# Serpent 快速入门

## 一些学习资料





## 安装事宜

1. pyethereum

   相当于一个测试环境。可以测试我们的合约运行情况。接受serpent语言的脚本

2. Serpent

   主要功能编译serpent（语言）的脚本成为EVM 的字节码


pyethereum 和。Serpent 的安装目前不能使用 pip。大部分有关pyethereum的文档已经过时。

根据官网需要安装

>git clone https://github.com/ethereum/pyethereum/
>
>cd pyethereum
>
>sudo python setup.py install

实际上需要一些其他dev 组件。如果不使用我们提供的虚拟机，则需要先进行下面的安装后在进行pyethereum 的安装。

>sudo apt-get install libssl-dev
>
>sudo apt-get install python-dev
>
>sudo apt-get install python-setuptools
>
>sudo apt-get install libevent-dev
>
>sudo apt-get install openssl-dev
>
>sudo apt-get install libxml2-dev
>
>sudo apt-get install zlib1g-dev
>
>sudo apt-get install libevent-dev
>
>sudo apt-get install gcc
>
>sudo apt-get install libssl-dev
>
>sudo apt-get install python-pkgconfig
>
>sudo apt-get install libffi-dev
>
>sudo apt-get install dh-autoreconf 



Serpent 的安装

```
git clone https://github.com/ethereum/serpent.git
mkdir serpent
cd serpent
git checkout develop
make && sudo make install
sudo python setup.py install
```





## Serpent 语言简述

Serpent 是一个类python的语言。

数字溢出3^(2^254)=1

没有高级类型，比如 Decimal

没有列表推导式

和python一样。适合教学。

## code it

用pyethereum去测试！

注意：pyethereum 在import时，更改为

> from ethereum import ...

一些过时的文档 会使用 from pyethereum，现在已经是错误的啦。

语法是和python高度相似的。

## 例子1：X*2

 >```python
 >import ethereum.tester as t
 >
 >
 >serpent_code =\
 >"""
 >def multiply(a):
 >    return(a*2)
 >"""
 >
 >s= t.state()
 >c = s.abi_contract(serpent_code)
 >o = c.multiply(5)
 >print(str(o))
 >```

 翻译：

红色部分是serpent 语言。

s 是wordstate 的概念，可以理解为一个智能合约网络

在s 上部署一个c 的合约。

（结果）保存了， 使用5 调用合约的结果。

部署

> serpent compile mult.se

* 能在测试链上调用嘛
* 不能
* 过期啦。还有一些其他方法，我们跳过https://devhub.io/repos/AugurProject-augur-abi
* 我们是教学任务。教学任务思考如何写合约。
* 但是我们能能测试。

## 例子2：登记数量

>```python
>def register(key, value):
>	#If not already registered, register it!
>	if not self.storage[key]:
>		self.storage[key] = value
>		return(1)
>	else:
>		return(-1)
>
>def get(key):
>	#Returns -1 if not registered, returns value if registered
>	if not self.storage[key]:
>		return(-1)
>	else:
>		return(self.storage[key])
>```

数据结构： 字典，数据存储

数据的调用：两个函数

 >```python
 >import serpent
 >from ethereum import tester, utils, abi
 >
 >serpent_code = '''
 >def register(key, value):
 >	#If not already registered, register it!
 >	if not self.storage[key]:
 >		self.storage[key] = value
 >		return(1)
 >	else:
 >		return(-1)
 >
 >def get(key):
 >	#Returns -1 if not registered, returns value if registered
 >	if not self.storage[key]:
 >		return(-1)
 >	else:
 >		return(self.storage[key])
 >'''
 >#Create public key
 >public_k1 = utils.privtoaddr(tester.k1)
 >
 >#Generate state and add contract to block chain
 >s = tester.state()
 >print("Tester state created")
 >c = s.abi_contract(serpent_code)
 >print("Code added to block chain")
 >
 >#Test contract
 >o = c.get("Bob")
 >if o == -1:
 >	print("No value has been stored at key \"Bob\"")
 >else:
 >	print("The value stored with key \"Bob\" is " + str(o))
 >
 >o = c.register("Bob", 10)
 >if(o == 1):
 >	print("Key \"Bob\" and value 10 was stored!")
 >else:
 >	print("Key \"Bob\" has already been assigned")
 >
 >o = c.register("Bob", 15)
 >if(o == 1):
 >	print("Key \"Bob\" and value 10 was stored!")
 >else:
 >	print("Key \"Bob\" has already been assigned")
 >
 >o = c.get("Bob")
 >if o == -1:
 >	print("No value has been stored at key \"Bob\"")
 >else:
 >	print("The value stored with key \"Bob\" is " + str(o))
 >
 >```



## 例子3 假装有个银行

>```python
>def init():
>	#Initialiaze the contract creator with 10000 fake dollars
>	self.storage[msg.sender] = 10000
>
>def send_currency_to(value, destination):
>	#If the sender has enough money to fund the transaction, complete it
>	if self.storage[msg.sender] >= value:
>		self.storage[msg.sender] = self.storage[msg.sender]  - value
>		self.storage[destination] = self.storage[destination] + value
>		return(1)
>	return(-1)
>
>def balance_check(addr):
>	#Balance Check
>	return(self.storage[addr])
>```

要点：

1.初始化

2.msg.sender

3.简单的面相对象 =》msg.sender= self...



>```python
>import serpent
>from ethereum import tester, utils, abi
>
>serpent_code = '''
>def init():
>	#Initialiaze the contract creator with 10000 fake dollars
>	self.storage[msg.sender] = 10000
>
>def send_currency_to(value, destination):
>	#If the sender has enough money to fund the transaction, complete it
>	if self.storage[msg.sender] >= value:
>		self.storage[msg.sender] = self.storage[msg.sender]  - value
>		self.storage[destination] = self.storage[destination] + value
>		return(1)
>	return(-1)
>
>def balance_check(addr):
>	#Balance Check
>	return(self.storage[addr])
>
>'''
>#Generate public keys
>public_k0 = utils.privtoaddr(tester.k0)
>public_k1 = utils.privtoaddr(tester.k1)
>
>#Generate state and add contract to block chain
>s = tester.state()
>print("Tester state created")
>c = s.abi_contract(serpent_code)
>print("Code added to block chain")
>
>#Test Contract
>o = c.send_currency_to(1000, public_k1)
>if o == 1:
>	print("$1000 sent to tester_k1 from tester_k0")
>else:
>	print("Failed to send $1000 to tester_k1 from tester_k0")
>
>o = c.send_currency_to(10000, public_k1)
>if o == 1:
>	print("$10000 sent to tester_k1 from tester_k0")
>else:
>	print("Failed to send $10000 to tester_k1 from tester_k0")
>
>o = c.balance_check(public_k0)
>print("tester_k0 has a balance of " + str(o))
>
>o = c.balance_check(public_k1)
>print("tester_k1 has a balance of " + str(o))
>```





## 例子4 一个用户使用 的银行

>```python
>def deposit():
>	self.storage[msg.sender] += msg.value
>	return(1)
>
>#Withdraw the given amount (in wei)
>def withdraw(amount):
>	#Check to ensure enough money in account
>	if self.storage[msg.sender] < amount:
>		return(-1)
>	else:
>		#If there is enough money, complete with withdraw
>		self.storage[msg.sender] -= amount
>		send(0, msg.sender, amount)
>		return(1)
>
>#Transfer the given amount (in wei) to the destination's public key
>def transfer(amount, destination):
>	#Check to ensure enough money in sender's account
>	if self.storage[msg.sender] < amount:
>		return(-1)
>	else:
>		#If there is enough money, complete the transfer
>		self.storage[msg.sender] -= amount
>		self.storage[destination] += amount
>		return(1)
>
>#Just return the sender's balance
>def balance():
>	return(self.storage[msg.sender])
>```



 用户如何正常使用。

转账（数量，账户）

可信的代码



>```python
>import serpent
>from pyethereum import tester, utils, abi
>
>serpent_code = '''
>#Deposit
>def deposit():
>	self.storage[msg.sender] += msg.value
>	return(1)
>
>#Withdraw the given amount (in wei)
>def withdraw(amount):
>	#Check to ensure enough money in account
>	if self.storage[msg.sender] < amount:
>		return(-1)
>	else:
>		#If there is enough money, complete with withdraw
>		self.storage[msg.sender] -= amount
>		send(0, msg.sender, amount)
>		return(1)
>
>#Transfer the given amount (in wei) to the destination's public key
>def transfer(amount, destination):
>	#Check to ensure enough money in sender's account
>	if self.storage[msg.sender] < amount:
>		return(-1)
>	else:
>		#If there is enough money, complete the transfer
>		self.storage[msg.sender] -= amount
>		self.storage[destination] += amount
>		return(1)
>
>#Just return the sender's balance
>def balance():
>	return(self.storage[msg.sender])
>'''
>
>public_k1 = utils.privtoaddr(tester.k1)
>
>s = tester.state()
>c = s.abi_contract(serpent_code)
>
>o = c.deposit(value=1000, sender=tester.k0)
>if o == 1:
>	print("1000 wei successfully desposited to tester.k0's account")
>else:
>	print("Failed to deposit 1000 wei into tester.k0's account")
>
>o = c.withdraw(1000, sender=tester.k0)
>if o == 1:
>	print("1000 wei successfully withdrawn from tester.k0's account")
>else:
>	print("Failed to witdraw 1000 wei into tester.k0's account")
>
>o = c.withdraw(1000, sender=tester.k1)
>if o == 1:
>	print("1000 wei successfully withdrawn from tester.k1's account")
>else:
>	print("Failed to witdraw 1000 wei into tester.k1's account")
>
>o = c.deposit(value=1000, sender=tester.k0)
>if o == 1:
>	print("1000 wei successfully desposited to tester.k0's account")
>else:
>	print("Failed to deposit 1000 wei into tester.k0's account")
>
>o = c.transfer(500, public_k1, sender=tester.k0)
>if o == 1:
>	print("500 wei successfully transfered from tester.k0's account to tester.k1's account")
>else:
>	print("Failed to transfer 500 wei from tester.k0's account to tester.k1's account")
>
>o = c.balance(sender=tester.k0)
>print("tester_k0 has a balance of " + str(o))
>
>o = c.balance(sender=tester.k1)
>print("tester_k1 has a balance of " + str(o))
>
>```
