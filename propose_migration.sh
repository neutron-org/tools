#!/bin/bash

PRE_PROPOSE_CONTRACT_ADDRESS=neutron1hulx7cgvpfcvg83wk5h96sedqgn72n026w6nl47uht554xhvj9nsgs8v0z
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

neutrond tx wasm execute $PRE_PROPOSE_CONTRACT_ADDRESS "$PROPOSAL_MSG" --from neutrond_mainnet_rehearsal \
    --gas 5000000 --gas-prices 0.9untrn --amount 1000000000untrn --chain-id=neutron-1 --broadcast-mode sync --keyring-backend test --node http://37.27.55.219:26657
