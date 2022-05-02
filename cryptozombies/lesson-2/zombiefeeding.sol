pragma solidity ^0.4.19;

import "./zombiefactory.sol";

// interface，定义外部使用的contract和其在以太坊上被访问的方法
// 我们不用大括号（{ 和 }）定义函数体，我们单单用分号（;）结束了函数声明。这使它看起来像一个合约框架。
// 编译器就是靠这些特征认出它是一个接口的。
contract KittyInterface {
    // 类似golang，solidity也是可以返回多返回值的
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

// contract xxx is yyy, 继承
// 可以访问父的internal方法，不能访问private方法
contract ZombieFeeding is ZombieFactory {

    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // 使用其他contract的接口，注意ckAddress即这个合约在以太坊上的地址
    KittyInterface kittyContract = KittyInterface(ckAddress);

    // 这里修改函数定义
    function feedAndMultiply(uint _zombieId, uint _targetDna) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        // Storage 变量是指永久存储在区块链中的变量。
        // Memory 变量则是临时的，当外部函数对某合约调用完成时，内存型变量即被移除。
        // 你可以把它想象成存储在你电脑的硬盘或是RAM中数据的关系。
        // 状态变量（在函数之外声明的变量）默认为“存储”形式，并永久写入区块链；
        // 而在函数内部声明的变量是“内存”型的，它们函数调用结束后消失。
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        // 这里增加一个 if 语句
        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        // 并修改函数调用
        feedAndMultiply(_zombieId, kittyDna);
    }

}
