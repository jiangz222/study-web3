pragma solidity ^0.4.19;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    // mapping 即其他语言的map，key->value 映射关系
    mapping (uint => address) public zombieToOwner;
    // 以太坊区块链由 _ account _ (账户)组成，你可以把它想象成银行账户。
    // 一个帐户的余额是 _以太_ （在以太坊区块链上使用的币种），
    // 你可以和其他帐户之间支付和接受以太币，就像你的银行帐户可以电汇资金到其他银行帐户一样。
    // 每个帐户都有一个“地址”，你可以把它想象成银行账号。这是账户唯一的标识符，而address即这个"地址"
    mapping (address => uint) ownerZombieCount;

    // internal 和 private 类似
    // 不过， 如果某个合约继承自其父合约，这个合约即可以访问父合约中定义的“内部”函数。
    // external 与public 类似，只不过这些函数只能在合约之外调用
    // 它们不能被合约内的其他函数调用。
    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // msg.sender 即调用者的区块链上的地址
        // 在 Solidity 中，有一些全局变量可以被所有函数调用。 其中一个就是 msg.sender，它指的是当前调用者（或智能合约）的 address。
        // 注意：在 Solidity 中，功能执行始终需要从外部调用者开始。
        // 一个合约只会在区块链上什么也不做，除非有人调用其中的函数。所以 msg.sender总是存在的。
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        //  require使得函数在执行过程中，当不满足某些条件时抛出错误，并停止执行
        // 类似assert
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
