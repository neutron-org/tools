#!/bin/bash

PRE_PROPOSE_CONTRACT_ADDRESS=neutron1fyhj2gq9k4dduahlyy46ffy22ad7lagglcec2acacyzjsd6w5n7qdx5hn4
MIGRATION_MSGS=$(cat migrate_proposal_for_dao.json)

PROPOSAL_MSG='{
    "propose": {
        "msg": {
            "propose": {
                "title": "migrate proposal for dao",
                "description": "blah-blah",
                "msgs": '"${MIGRATION_MSGS}"'
            }
        }
    }
}'

neutrond tx wasm execute $PRE_PROPOSE_CONTRACT_ADDRESS "$PROPOSAL_MSG" --from deployer \
    --gas 5000000 --gas-prices 0.9untrn --amount 1000000000untrn --chain-id=neutron-1 --broadcast-mode sync --keyring-backend test --node http://37.27.55.219:26657
