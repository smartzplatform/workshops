pragma solidity ^0.4.17;

import 'openzeppelin-solidity/contracts/math/SafeMath.sol';
import './AtomicSwapRegistry.sol';


contract Exchange {
    using SafeMath for uint256;

    function Exchange(address _swapRegistry) public {
        swapRegistry = AtomicSwapRegistry(_swapRegistry);
    }

    /*****************************************************************/

    AtomicSwapRegistry public swapRegistry;


    mapping (address => uint) public deposits;


    /*****************************************************************/

    function myDeposit() view public returns (uint) {
        return deposits[msg.sender];
    }

    function deposit() public payable {
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(deposits[msg.sender] >= _amount);

        deposits[msg.sender] -= _amount;

        msg.sender.transfer(_amount);
    }


}

