pragma solidity ^0.4.17;

import 'openzeppelin-solidity/contracts/math/SafeMath.sol';
import './AtomicSwapRegistry.sol';


contract Exchange {
    using SafeMath for uint256;

    function Exchange(address _swapRegistry) public {
        swapRegistry = AtomicSwapRegistry(_swapRegistry);
    }

    /*****************************************************************/

    /**
     * Blockchains to swap with (one of them with be useless, since exchange contract will be deployed to it)
     */
    uint8 constant ETH = 1;
    uint8 constant ETH_KOVAN = 2;
    uint8 constant ETH_RINKEBY = 3;
    uint8 constant EOS = 4;
    uint8 constant BITCOIN = 5;

    /*****************************************************************/

    AtomicSwapRegistry public swapRegistry;

    mapping (address => uint) public deposits;


    /*****************************************************************/

    function buy(uint8 _secondBlockchain, uint _currencyCount, uint _priceInWeiForOneUnit) public {

    }

    function sell(uint8 _secondBlockchain, uint _currencyCount, uint _priceInWeiForOneUnit) public {

    }

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

