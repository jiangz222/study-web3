/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
    function Ownable() public {
        owner = msg.sender;
    }


    /**
     * @dev Throws if called by any account other than the owner.
   */
    // 关键字modifier 告诉编译器，这是个modifier(修饰符)，而不是个function(函数)
    modifier onlyOwner() {
        require(msg.sender == owner);
        _; // 其他contract继承了Ownable合约后，在方法里使用onlyOwner关键字就可以实现对onlyOwner的调用，然后onlyOwner通过"_;"回调到原来的方法
    }


    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}
