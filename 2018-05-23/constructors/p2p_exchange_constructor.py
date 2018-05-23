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
    
    
contract ExchangeConstructed is Exchange {
    function ExchangeConstructed(address _swapRegistry) 
        public payable 
        Exchange(%address%)
    {
        %payment_code%
    }
}
    """