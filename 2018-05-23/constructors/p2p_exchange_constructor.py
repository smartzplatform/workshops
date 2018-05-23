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
            'source': "",
            'contract_name': ""
        }

    def post_construct(self, fields, abi_array):

        function_specs = {

        }

        return {
            "result": "success",
            'function_specs': function_specs,
            'dashboard_functions': []
        }

