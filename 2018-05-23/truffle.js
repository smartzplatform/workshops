require('babel-register');
require('babel-polyfill');

module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 9545,
            network_id: "*" // match any network
        },
        rinkeby: {
            host: "127.0.0.1",
            port: 8544,
            network_id: 4,
            gasPrice: 20*10**9,
            // from: ''
        }
    },
    solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    }
};
