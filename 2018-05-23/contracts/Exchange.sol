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
        bytes32 hash;
    }

    /*****************************************************************/

    AtomicSwapRegistry public swapRegistry;


    mapping (address => uint) public deposits;

    mapping(uint8 => Order[]) public orders;

    mapping(address => bytes32[]) hashes;


    /*****************************************************************/

    /**
     * want to get some currency, give back ether
     */
    function buy(uint8 _secondBlockchain, uint _currencyCount, uint _priceInWeiForOneUnit) public {
        //todo hardcoded only ether like decimals (18), const 1 ether = 10^18
        uint totalEther = _priceInWeiForOneUnit.mul(_currencyCount).div(1 ether);

        require(totalEther <= deposits[msg.sender]);
        deposits[msg.sender] = deposits[msg.sender].sub(totalEther);


        bool isMatched = false;
        // todo optimization :(
        for(uint i=0; i<orders[_secondBlockchain].length; i++) {
            Order storage order = orders[_secondBlockchain][i];
            if (order.opType==OpType.BUY) {
                continue;
            }

            //todo minimum price, since not we get first suitable price
            if (order.priceInWei > _priceInWeiForOneUnit) {
                continue;
            }

            if (order.isFilled) {
                continue;
            }

            if (order.currencyCount == _currencyCount) {

                bytes32 currentHash = getNextHash(msg.sender);
                swapRegistry.initiate.value(totalEther)(msg.sender, 7200, currentHash, order.initiator);
                order.isFilled = true;
                order.hash = currentHash;

                isMatched = true;
                break;
            }

        }

        if (!isMatched) {
            orders[_secondBlockchain].push(
                Order(
                    msg.sender,
                    _currencyCount,
                    _priceInWeiForOneUnit,
                    OpType.BUY,
                    false,
                    0
                )
            );
        }

    }

    /**
     * want to get ether, give back some currency
     */
    function sell(uint8 _secondBlockchain, uint _currencyCount, uint _priceInWeiForOneUnit) public {
        require(_currencyCount > 0);
        require(_priceInWeiForOneUnit > 0);

        bool isMatched = false;
        for(uint i=0; i<orders[_secondBlockchain].length; i++) {

            Order storage order = orders[_secondBlockchain][i];
            if (order.opType==OpType.SELL) {
                continue;
            }

            //todo minimum price, since not we get first suitable price
            if (order.priceInWei < _priceInWeiForOneUnit) {
                continue;
            }

            if (order.isFilled) {
                continue;
            }

            if (order.currencyCount == _currencyCount) {

                uint totalEther = order.priceInWei.mul(_currencyCount).div(1 ether);

                bytes32 currentHash = getNextHash(order.initiator);
                swapRegistry.initiate.value(totalEther)(order.initiator, 7200, currentHash, msg.sender);
                order.isFilled = true;
                order.hash = currentHash;

                isMatched = true;
                break;
            }

        }

        if (!isMatched) {
            orders[_secondBlockchain].push(
                Order(
                    msg.sender,
                    _currencyCount,
                    _priceInWeiForOneUnit,
                    OpType.SELL,
                    false,
                    0
                )
            );
        }
    }

    /*****************************************************************/

    function myHashesCount() view public returns (uint) {
        return hashes[msg.sender].length;
    }

    function addHash(bytes32 _hash) public {
        if (_hash != 0) {
            //todo check that hash has been never used
            hashes[msg.sender].push(_hash);
        }
    }

    function getNextHash(address _addr) internal returns (bytes32 result) {
        assert(hashes[_addr].length > 0);

        result = hashes[_addr][ hashes[_addr].length-1 ];
        hashes[_addr].length -= 1;
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

