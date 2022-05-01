// lesson 1 主要是solidity基本语法，以及 类似合约这样的基本概念

// 所有的 Solidity 源码都必须冠以 "version pragma" — 标明 Solidity 编译器的版本. 以避免将来新的编译器可能破坏你的代码。
pragma solidity >=0.5.0 <0.6.0;

// contract 即合约
// Solidity 的代码都包裹在合约里面. 一份合约就是以太应币应用的基本模块， 所有的变量和函数都属于一份合约, 它是你所有应用的起点.
contract ZombieFactory {

    // 事件 是合约和区块链通讯的一种机制。你的前端应用“监听”某些事件，并做出反应。
    event NewZombie(uint zombieId, string name, uint dna);

    // 变量
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // 结构体
    struct Zombie {
        string name;
        uint dna;
    }

    // 数组
    Zombie[] public zombies;

    // 方法，最后的private代表只能合约内使用
    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        emit NewZombie(id, _name, _dna);
    }

    // 函数定义为 view, 意味着它只能读取数据不能更改数据:
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // Solidity 还支持 pure 函数, 表明这个函数甚至都不访问应用里的数据：
    //    function _multiply(uint a, uint b) private pure returns (uint) {
//        return a * b;
//    }

    // public代表其他合约可以使用
    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}


// 下面是调用合约的方式， 使用的以太坊有一个 JavaScript 库, web3.js:
// 下面是调用合约的方式:
//var abi = /* abi是由编译器生成的 */
//var ZombieFactoryContract = web3.eth.contract(abi)
//var contractAddress = /* 发布之后在以太坊上生成的合约地址 */
//var ZombieFactory = ZombieFactoryContract.at(contractAddress)
//// `ZombieFactory` 能访问公共的函数以及事件
//
//// 某个监听文本输入的监听器:
//$("#ourButton").click(function(e) {
//var name = $("#nameInput").val()
////调用合约的 `createRandomZombie` 函数:
//ZombieFactory.createRandomZombie(name)
//})
//
//// 监听 `NewZombie` 事件, 并且更新UI
//var event = ZombieFactory.NewZombie(function(error, result) {
//if (error) return
//generateZombie(result.zombieId, result.name, result.dna)
//})
//
//// 获取 Zombie 的 dna, 更新图像
//function generateZombie(id, name, dna) {
//let dnaStr = String(dna)
//// 如果dna少于16位,在它前面用0补上
//while (dnaStr.length < 16)
//dnaStr = "0" + dnaStr
//
//let zombieDetails = {
//// 前两位数构成头部.我们可能有7种头部, 所以 % 7
//// 得到的数在0-6,再加上1,数的范围变成1-7
//// 通过这样计算：
//headChoice: dnaStr.substring(0, 2) % 7 + 1，
//// 我们得到的图片名称从head1.png 到 head7.png
//
//// 接下来的两位数构成眼睛, 眼睛变化就对11取模:
//eyeChoice: dnaStr.substring(2, 4) % 11 + 1,
//// 再接下来的两位数构成衣服，衣服变化就对6取模:
//shirtChoice: dnaStr.substring(4, 6) % 6 + 1,
////最后6位控制颜色. 用css选择器: hue-rotate来更新
//// 360度:
//skinColorChoice: parseInt(dnaStr.substring(6, 8) / 100 * 360),
//eyeColorChoice: parseInt(dnaStr.substring(8, 10) / 100 * 360),
//clothesColorChoice: parseInt(dnaStr.substring(10, 12) / 100 * 360),
//zombieName: name,
//zombieDescription: "A Level 1 CryptoZombie",
//}
//return zombieDetails
//}
