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
LOCKDROP_CONTRACT_ADDRESS=neutron1ryhxe5fzczelcfmrhmcw9x2jsqy677fw59fsctr09srk24lt93eszwlvyj
VESTING_LP_USDC_CONTRACT_ADDRESS=neutron1wgzzn83hhcc5asrtslqvaw2wuqqkfulgac7ze94dmqkrxu8nsensmy9dkv
VESTING_LP_ATOM_CONTRACT_ADDRESS=neutron1kkwp7pd4ts6gukm3e820kyftz4vv5jqtmal8pwqezrnq2ddycqasr87x9p
VOTING_REGISTRY_ADDRESS=neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s

# insert new contract versions code IDs here (from the ./store_new_contracts.sh result):
NEW_LOCKDROP_CODE_ID=462
NEW_LOCKDROP_VAULT_CODE_ID=463
NEW_VESTING_LP_VAULT_CODE_ID=464
NEW_VESTING_LP_CODE_ID=465
NEW_RESERVE_CODE_ID=466
NEW_VESTING_LP_VAULT_CL_CODE_ID=467
NEW_LOCKDROP_VAULT_CL_CODE_ID=468

# insert CL vault contract addresses here (from the ./init_cl_vaults.sh result):
echo FILL
LOCKDROP_VAULT_XYK_CONTRACT_ADDRESS=neutron105ml67ymwlznz8twk2nyxu5xaqnsp2h24t50995ucp8ffu5wut7q2ewhj4
LOCKDROP_VAULT_CL_CONTRACT_ADDRESS=neutron1hfvzfdd2lnlcwkg77e6w3jvefaesrkwh4jf6cw20e4e0g7c6asgsy7z57g
LP_VESTING_VAULT_XYK_CONTRACT_ADDRESS=neutron1kax2cv9793hlfz69u3x0e5c75vxcum6qupv7rdz44fdu3yeeszus6y6dkr
LP_VESTING_VAULT_CL_CONTRACT_ADDRESS=neutron18a60j9nfsdyscnzmylkvf7zprz9n2fuc7k83dx9c6p7jtzem6vzshan8ha

# migrate Reserve
RESERVE_MIGRATE_MSG='{
    "max_slippage": "0.5",
    "ntrn_denom": "untrn",
    "atom_denom": "ibc/C4CFF46FD6DE35CA4CF4CE031E643C8FDC9BA4B99AE598E9B0ED98FE3A2319F9",
    "usdc_denom": "ibc/F082B65C88E4B6D5EF1DB243CDA1D331D002759E938A0F5CD3FFDC5D53B3E349",
    "ntrn_atom_xyk_pair": "neutron1e22zh5p8meddxjclevuhjmfj69jxfsa8uu3jvht72rv9d8lkhves6t8veq",
    "ntrn_atom_cl_pair": "FILL",
    "ntrn_usdc_xyk_pair": "neutron1l3gtxnwjuy65rzk63k352d52ad0f2sh89kgrqwczgt56jc8nmc3qh5kag3",
    "ntrn_usdc_cl_pair": "FILL"
}'
RESERVE_MIGRATE_MSG_BASE64=$(json_to_base64 "$RESERVE_MIGRATE_MSG")

# migrate Lockdrop
LOCKDROP_MIGRATE_MSG='{
    "new_atom_token": "FILL",
    "new_usdc_token": "FILL",
    "max_slippage": "0.5"
}'
LOCKDROP_MIGRATE_MSG_BASE64=$(json_to_base64 "$LOCKDROP_MIGRATE_MSG")

# Migrate Vesting lp atom
VESTING_LP_ATOM_MIGRATE_MSG='{
    "max_slippage": "0.5",
    "ntrn_denom": "untrn",
    "paired_denom": "ibc/C4CFF46FD6DE35CA4CF4CE031E643C8FDC9BA4B99AE598E9B0ED98FE3A2319F9",
    "xyk_pair": "neutron1e22zh5p8meddxjclevuhjmfj69jxfsa8uu3jvht72rv9d8lkhves6t8veq",
    "cl_pair": "FILL",
    "new_lp_token": "FILL",
    "batch_size": 50
}'
VESTING_LP_ATOM_MIGRATE_MSG_BASE64=$(json_to_base64 "$VESTING_LP_ATOM_MIGRATE_MSG")

# migrate Vesting lp usdc
VESTING_LP_USDC_MIGRATE_MSG='{
    "max_slippage": "0.5",
    "ntrn_denom": "untrn",
    "paired_denom": "ibc/F082B65C88E4B6D5EF1DB243CDA1D331D002759E938A0F5CD3FFDC5D53B3E349",
    "xyk_pair": "neutron1l3gtxnwjuy65rzk63k352d52ad0f2sh89kgrqwczgt56jc8nmc3qh5kag3",
    "cl_pair": "FILL",
    "new_lp_token": "FILL",
    "batch_size": 50
}'
VESTING_LP_USDC_MIGRATE_MSG_BASE64=$(json_to_base64 "$VESTING_LP_USDC_MIGRATE_MSG")

## migrate Voting registry
#VOTING_REGISTRY_MIGRATE_MSG='{}'
#VOTING_REGISTRY_MIGRATE_MSG_BASE64=$(json_to_base64 "$VOTING_REGISTRY_MIGRATE_MSG")

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
