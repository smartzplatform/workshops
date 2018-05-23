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

    enum OpType {BUY, SELL}

    struct Order {
        address initiator;

        uint currencyCount;
        uint priceInWei;

        OpType opType;
        bool isFilled;
    }

    /*****************************************************************/

    AtomicSwapRegistry public swapRegistry;

    mapping (address => uint) public deposits;

    mapping(uint8 => Order[]) public orders;


    /*****************************************************************/

    /**
     * want to get some currency, give back ether
     */
    function buy(uint8 _secondBlockchain, uint _currencyCount, uint _priceInWeiForOneUnit) public {
        //todo hardcoded only ether like decimals (18), const 1 ether = 10^18
        uint totalEther = _priceInWeiForOneUnit.mul(_currencyCount).div(1 ether);

        require(totalEther <= deposits[msg.sender]);
        deposits[msg.sender] = deposits[msg.sender].sub(totalEther);

        // todo optimization :(
        for(uint i=0; i<orders[_secondBlockchain].length; i++) {
            Order storage order = orders[_secondBlockchain][i];
            if (order.opType==OpType.BUY) {
                continue;
            }

        }
    }

    /**
     * want to get ether, give back some currency
     */
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

