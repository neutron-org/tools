#!/bin/bash

function json_to_base64() {
  MSG=$1
  check_json "$MSG"
  echo "$MSG" | base64 | tr -d "\n"
}

function check_json() {
  MSG=$1
  if ! jq -e . >/dev/null 2>&1 <<<"$MSG"; then
      echo "Failed to parse JSON for $MSG" >&2
      exit 1
  fi
}

RESERVE_CONTRACT_ADDRESS=neutron13we0myxwzlpx8l5ark8elw5gj5d59dl6cjkzmt80c5q5cv5rt54qvzkv2a
LOCKDROP_CONTRACT_ADDRESS=neutron1zt8m8ffpdrztjyqj0hmv8wgcz2cv3y4euk474znth4hnsn3vzaes32wtx2
VESTING_LP_USDC_CONTRACT_ADDRESS=neutron1mzr9spaqlxq0pp34r0cahntfp3htpy8dps399aflafqwx2f6235qdhwflr
VESTING_LP_ATOM_CONTRACT_ADDRESS=neutron16y75jj4ftlcjvfa0gscnklzaj20pfe97mczpg2e8a7znyjzzafaq67dj0v
VOTING_REGISTRY_ADDRESS=neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s

# insert new contract versions code IDs here (from the ./store_new_contracts.sh result):
NEW_LOCKDROP_CODE_ID=43
NEW_LOCKDROP_VAULT_CODE_ID=44
NEW_VESTING_LP_VAULT_CODE_ID=45
NEW_VESTING_LP_CODE_ID=46
NEW_RESERVE_CODE_ID=47
NEW_VOTING_REGISTRY_CODE_ID=48
NEW_VESTING_LP_VAULT_CL_CODE_ID=49
NEW_LOCKDROP_VAULT_CL_CODE_ID=50

# insert CL vault contract addresses here (from the ./init_cl_vaults.sh result):
LOCKDROP_VAULT_XYK_CONTRACT_ADDRESS=neutron105ml67ymwlznz8twk2nyxu5xaqnsp2h24t50995ucp8ffu5wut7q2ewhj4
LOCKDROP_VAULT_CL_CONTRACT_ADDRESS=neutron1hfvzfdd2lnlcwkg77e6w3jvefaesrkwh4jf6cw20e4e0g7c6asgsy7z57g
LP_VESTING_VAULT_XYK_CONTRACT_ADDRESS=neutron1kax2cv9793hlfz69u3x0e5c75vxcum6qupv7rdz44fdu3yeeszus6y6dkr
LP_VESTING_VAULT_CL_CONTRACT_ADDRESS=neutron18a60j9nfsdyscnzmylkvf7zprz9n2fuc7k83dx9c6p7jtzem6vzshan8ha

# migrate Reserve
RESERVE_MIGRATE_MSG='{
    "max_slippage": "0.5",
    "ntrn_denom": "untrn",
    "atom_denom": "uibcatom",
    "usdc_denom": "uibcusdc",
    "ntrn_atom_xyk_pair": "neutron1sr9zm2pq3xrru7l7gz632t2rqs9caet9xulwvapcqagq9pytkcgq6m3d6n",
    "ntrn_atom_cl_pair": "neutron1wawu0fe6jy2w9ngaf89xs3mwgfsm0fpdtumfls4wx3ltwcp7amqqwdvcm6",
    "ntrn_usdc_xyk_pair": "neutron1707ccwapsqtkceefqaxtm6hly7jxmytxx3dlejn8kedrqf2rjlnshw52gw",
    "ntrn_usdc_cl_pair": "neutron1w7qp3uppv9sl8xxnq7cdnn5xje5utz0a482rfafpu5zkf6vltnxslejmvm"
}'
RESERVE_MIGRATE_MSG_BASE64=$(json_to_base64 "$RESERVE_MIGRATE_MSG")

# migrate Lockdrop
LOCKDROP_MIGRATE_MSG='{
    "new_atom_token": "neutron1vs2jgdhesdhtzd07kzu9sdfwh39hs4qkn9q9m80dq35mguw2e6vsp62964",
    "new_usdc_token": "neutron19tq9qujlfmtwz808u4dkqgu2s0dajc907ve4gma4kgt4ymftuqvsqvzmze",
    "max_slippage": "0.5"
}'
LOCKDROP_MIGRATE_MSG_BASE64=$(json_to_base64 "$LOCKDROP_MIGRATE_MSG")

# Migrate Vesting lp atom
VESTING_LP_ATOM_MIGRATE_MSG='{
    "max_slippage": "0.5",
    "ntrn_denom": "untrn",
    "paired_denom": "uibcatom",
    "xyk_pair": "neutron1sr9zm2pq3xrru7l7gz632t2rqs9caet9xulwvapcqagq9pytkcgq6m3d6n",
    "cl_pair": "neutron1wawu0fe6jy2w9ngaf89xs3mwgfsm0fpdtumfls4wx3ltwcp7amqqwdvcm6",
    "new_lp_token": "neutron1vs2jgdhesdhtzd07kzu9sdfwh39hs4qkn9q9m80dq35mguw2e6vsp62964",
    "batch_size": 1
}'
VESTING_LP_ATOM_MIGRATE_MSG_BASE64=$(json_to_base64 "$VESTING_LP_ATOM_MIGRATE_MSG")

# migrate Vesting lp usdc
VESTING_LP_USDC_MIGRATE_MSG='{
    "max_slippage": "0.5",
    "ntrn_denom": "untrn",
    "paired_denom": "uibcusdc",
    "xyk_pair": "neutron1707ccwapsqtkceefqaxtm6hly7jxmytxx3dlejn8kedrqf2rjlnshw52gw",
    "cl_pair": "neutron1w7qp3uppv9sl8xxnq7cdnn5xje5utz0a482rfafpu5zkf6vltnxslejmvm",
    "new_lp_token": "neutron19tq9qujlfmtwz808u4dkqgu2s0dajc907ve4gma4kgt4ymftuqvsqvzmze",
    "batch_size": 50
}'
VESTING_LP_USDC_MIGRATE_MSG_BASE64=$(json_to_base64 "$VESTING_LP_USDC_MIGRATE_MSG")

# migrate Voting registry
VOTING_REGISTRY_MIGRATE_MSG='{}'
VOTING_REGISTRY_MIGRATE_MSG_BASE64=$(json_to_base64 "$VOTING_REGISTRY_MIGRATE_MSG")

# deactivate xyk vaults
DEACTIVATE_LOCKDROP_XYK_VAULT_MSG='{
    "deactivate_voting_vault": {
        "voting_vault_contract": "'"${LOCKDROP_VAULT_XYK_CONTRACT_ADDRESS}"'"
    }
}'
DEACTIVATE_LOCKDROP_XYK_VAULT_MSG_BASE64=$(json_to_base64 "$DEACTIVATE_LOCKDROP_XYK_VAULT_MSG")

DEACTIVATE_VESTING_LP_XYK_VAULT_MSG='{
    "deactivate_voting_vault": {
        "voting_vault_contract": "'"${LP_VESTING_VAULT_XYK_CONTRACT_ADDRESS}"'"
    }
}'
DEACTIVATE_VESTING_LP_XYK_VAULT_MSG_BASE64=$(json_to_base64 "$DEACTIVATE_VESTING_LP_XYK_VAULT_MSG")

# add CL vaults
ADD_LOCKDROP_CL_VAULT_MSG='{
    "add_voting_vault": {
        "new_voting_vault_contract": "'"${LOCKDROP_VAULT_CL_CONTRACT_ADDRESS}"'"
    }
}'
ADD_LOCKDROP_CL_VAULT_MSG_BASE64=$(json_to_base64 "$ADD_LOCKDROP_CL_VAULT_MSG")

ADD_VESTING_LP_CL_VAULT_MSG='{
    "add_voting_vault": {
        "new_voting_vault_contract": "'"${LP_VESTING_VAULT_CL_CONTRACT_ADDRESS}"'"
    }
}'
ADD_VESTING_LP_CL_VAULT_MSG_BASE64=$(json_to_base64 "$ADD_VESTING_LP_CL_VAULT_MSG")

MIGRATE_MSGS='[
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${RESERVE_CONTRACT_ADDRESS}"'",
                "new_code_id": '"${NEW_RESERVE_CODE_ID}"',
                "msg": "'"${RESERVE_MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${LOCKDROP_CONTRACT_ADDRESS}"'",
                "new_code_id": '"${NEW_LOCKDROP_CODE_ID}"',
                "msg": "'"${LOCKDROP_MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${VESTING_LP_USDC_CONTRACT_ADDRESS}"'",
                "new_code_id": '"${NEW_VESTING_LP_CODE_ID}"',
                "msg": "'"${VESTING_LP_USDC_MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${VESTING_LP_ATOM_CONTRACT_ADDRESS}"'",
                "new_code_id": '"${NEW_VESTING_LP_CODE_ID}"',
                "msg": "'"${VESTING_LP_ATOM_MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${VOTING_REGISTRY_ADDRESS}"'",
                "new_code_id": '"${NEW_VOTING_REGISTRY_CODE_ID}"',
                "msg": "'"${VOTING_REGISTRY_MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "execute": {
                "contract_addr": "'"${VOTING_REGISTRY_ADDRESS}"'",
                "msg": "'"${DEACTIVATE_LOCKDROP_XYK_VAULT_MSG_BASE64}"'",
                "funds": []
            }
        }
    },
    {
        "wasm": {
            "execute": {
                "contract_addr": "'"${VOTING_REGISTRY_ADDRESS}"'",
                "msg": "'"${DEACTIVATE_VESTING_LP_XYK_VAULT_MSG_BASE64}"'",
                "funds": []
            }
        }
    },
    {
        "wasm": {
            "execute": {
                "contract_addr": "'"${VOTING_REGISTRY_ADDRESS}"'",
                "msg": "'"${ADD_LOCKDROP_CL_VAULT_MSG_BASE64}"'",
                "funds": []
            }
        }
    },
    {
        "wasm": {
            "execute": {
                "contract_addr": "'"${VOTING_REGISTRY_ADDRESS}"'",
                "msg": "'"${ADD_VESTING_LP_CL_VAULT_MSG_BASE64}"'",
                "funds": []
            }
        }
    }
]'

echo $MIGRATE_MSGS | jq . > migrate_proposal.json
