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


// front.js是调用合约的方式， 使用的以太坊有一个 JavaScript 库, web3.js:
