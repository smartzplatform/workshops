#P2p multichain exchange

from smartz.api.constructor_engine import ConstructorInstance


class Constructor(ConstructorInstance):

    def get_version(self):
        return {
            "result": "success",
            "version": 1
        }

    def get_params(self):
        json_schema = {
            "type": "object",
            "required": ['address'],
            "additionalProperties": False,

            "properties": {
                'address': {
                    "title": "Address of Swap registry contract",
                    "$ref": "#/definitions/address"
                }
            }
        }

        ui_schema = {
        }

        return {
            "result": "success",
            'schema': json_schema,
            'ui_schema': ui_schema
        }

    def construct(self, fields):
        return {
            'result': "success",
            'source': self.__class__._TEMPLATE.replace('%address%', fields['address']),
            'contract_name': "ExchangeConstructed"
        }

    def post_construct(self, fields, abi_array):

        function_specs = {

        }

        return {
            "result": "success",
            'function_specs': function_specs,
            'dashboard_functions': []
        }

    # language=Solidity
    __TEMPLATE__ = """

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract AtomicSwapRegistry {
    function initiate(address _initiator, uint _refundTime, bytes32 _hashedSecret, address _participant) public payable;
}
    
    
contract ExchangeConstructed is Exchange {
    function ExchangeConstructed(address _swapRegistry) 
        public payable 
        Exchange(%address%)
    {
        %payment_code%
    }
}
    """