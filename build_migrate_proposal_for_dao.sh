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

BINARY=neutrond
#TESTNET_RPC=https://rpc-falcron.pion-1.ntrn.tech:443
TESTNET_RPC=http://65.109.239.170:26657
DEPLOYER=neutrond_demowallet_2
KEYS_HOME=~/.neutrond
DEPLOYER_ADDR=$(${BINARY} keys show ${DEPLOYER} --keyring-backend test -a --home ${KEYS_HOME})
TESTNET_CHAINID=neutron-1
GAS_PRICES=0.9untrn
# GAS=45000000untrn
REST=http://65.109.239.170:1317

# given the contract address on mainnet, gets contract from mainnet, stores it on testnet and returns contract code_id
function store_code() {
  CONTRACT_PATH=$1

  RES=$($BINARY tx wasm store "$CONTRACT_PATH" \
    --gas 5000000 \
    --gas-prices ${GAS_PRICES} \
    --chain-id ${TESTNET_CHAINID} \
    --broadcast-mode=sync \
    --from "$DEPLOYER" \
    --keyring-backend test \
    --output json \
    --home ${KEYS_HOME} \
    --node ${TESTNET_RPC} \
    -y)
   
   echo $RES
}

function extract_hash() {
    RES=$1
    HASH=$(echo $RES | jq -r '.txhash')
    CODE_ID=$(curl $REST/txs/$HASH | jq '.logs[0].events[1].attributes[1].value')
    CODE_ID_NUM=${CODE_ID//\"/}

    echo $CODE_ID_NUM
}

# Production contract addresses
MAIN_DAO=neutron1suhgf5svhu4usrurvxzlgn54ksxmn8gljarjtxqnapv8kjnp4nrstdxvff
SINGLE_PROPOSAL=neutron1436kxs0w2es6xlqpp9rd35e3d0cjnw4sv8j3a7483sgks29jqwgshlt6zh
SINGLE_PRE_PROPOSAL=neutron1hulx7cgvpfcvg83wk5h96sedqgn72n026w6nl47uht554xhvj9nsgs8v0z
MULTIPLE_PROPOSAL=neutron1pvrwmjuusn9wh34j7y520g8gumuy9xtl3gvprlljfdpwju3x7ucsj3fj40
MULTIPLE_PRE_PROPOSAL=neutron1up07dctjqud4fns75cnpejr4frmjtddzsmwgcktlyxd4zekhwecqt2h8u6
OVERRULE_PROPOSAL=neutron12pwnhtv7yat2s30xuf4gdk9qm85v4j3e6p44let47pdffpklcxlq56v0te
OVERRULE_PRE_PROPOSAL=neutron1w798gp0zqv3s9hjl3jlnwxtwhykga6rn93p46q2crsdqhaj3y4gsum0096
VOTING_REGISTRY=neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s
NTRN_VAULT=neutron1qeyjez6a9dwlghf9d6cy44fxmsajztw257586akk6xn6k88x0gus5djz4e
CREDITS_VAULT=neutron13we0myxwzlpx8l5ark8elw5gj5d59dl6cjkzmt80c5q5cv5rt54qvzkv2a
LOCKDROP_VAULT=neutron1f8gs4rp232ngyta3g2efwfkznymvv85du7qm9y0mhvjxpp3cq68qgquudm
LP_VESTING_VAULT=neutron1adavpfxyp5kgs3zp0n0vkc37qakeh5eqwxqxzysgg0ahlx82rmsqp4rnz8
SECURITY_SUBDAO=neutron1fuyxwxlsgjkfjmxfthq8427dm2am3ya3cwcdr8gls29l7jadtazsuyzwcc
SECURITY_SINGLE_PROPOSAL=neutron15m728qxvtat337jdu2f0uk6pu905kktrxclgy36c0wd822tpxcmqvnrurt
SECURITY_SINGLE_PRE_PROPOSAL=neutron1zjd5lwhch4ndnmayqxurja4x5y5mavy9ktrk6fzsyzan4wcgawnqjk5g26
SECURITY_SUBDAO_VOTING=neutron1wastjc07zuuy46mzzl3egz4uzy6fs59752grxqvz8zlsqccpv2wqhjw0cl
SECURITY_CW4=neutron1hyja4uyjktpeh0fxzuw2fmjudr85rk2qu98fa6nuh6d4qru9l0ssh3kgnu

# OTHER contracts?

# ===== STORE
NEW_MAIN_DAO_CODE_RES=$(store_code "new_artifacts_dao/cwd_core.wasm")
NEW_PROPOSAL_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_proposal_single.wasm")
NEW_PRE_PROPOSE_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_pre_propose_single.wasm")
NEW_PROPOSAL_MULTIPLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_proposal_multiple.wasm")
NEW_PRE_PROPOSE_MULTIPLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_pre_propose_multiple.wasm")
NEW_PRE_PROPOSE_OVERRULE_CODE_RES=$(store_code "new_artifacts_dao/cwd_pre_propose_overrule.wasm")
NEW_VOTING_REGISTRY_CODE_RES=$(store_code "new_artifacts_dao/neutron_voting_registry.wasm")
NEW_NEUTRON_VAULT_CODE_RES=$(store_code "new_artifacts_dao/neutron_vault.wasm")
NEW_CREDITS_VAULT_CODE_RES=$(store_code "new_artifacts_dao/credits_vault.wasm")
NEW_LOCKDROP_VAULT_CODE_RES=$(store_code "new_artifacts_dao/lockdrop_vault.wasm")
NEW_LP_VESTING_VAULT_CODE_RES=$(store_code "new_artifacts_dao/vesting_lp_vault.wasm")
NEW_SUBDAO_CORE_CODE_RES=$(store_code "new_artifacts_dao/cwd_subdao_core.wasm")
NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_subdao_pre_propose_single.wasm")
NEW_SUBDAO_TIMELOCK_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_subdao_timelock_single.wasm")
NEW_SUBDAO_PROPOSAL_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_subdao_proposal_single.wasm")
NEW_INVESTORS_VESTING_VAULT_CODE_RES=$(store_code "new_artifacts_dao/investors_vesting_vault.wasm")
NEW_DISTRIBUTION_CODE_RES=$(store_code "new_artifacts_dao/neutron_distribution.wasm")
NEW_RESERVE_CODE_RES=$(store_code "new_artifacts_dao/neutron_reserve.wasm")

echo "sleeping..."
sleep 30

NEW_MAIN_DAO_CODE_ID=$(extract_hash "$NEW_MAIN_DAO_CODE_RES")
NEW_PROPOSAL_SINGLE_CODE_ID=$(extract_hash "$NEW_PROPOSAL_SINGLE_CODE_RES")
NEW_PRE_PROPOSE_SINGLE_CODE_ID=$(extract_hash "$NEW_PRE_PROPOSE_SINGLE_CODE_RES")
NEW_PROPOSAL_MULTIPLE_CODE_ID=$(extract_hash "$NEW_PROPOSAL_MULTIPLE_CODE_RES")
NEW_PRE_PROPOSE_MULTIPLE_CODE_ID=$(extract_hash "$NEW_PRE_PROPOSE_MULTIPLE_CODE_RES")
NEW_PRE_PROPOSE_OVERRULE_CODE_ID=$(extract_hash "$NEW_PRE_PROPOSE_OVERRULE_CODE_RES")
NEW_VOTING_REGISTRY_CODE_ID=$(extract_hash "$NEW_VOTING_REGISTRY_CODE_RES")
NEW_NEUTRON_VAULT_CODE_ID=$(extract_hash "$NEW_NEUTRON_VAULT_CODE_RES")
NEW_CREDITS_VAULT_CODE_ID=$(extract_hash "$NEW_CREDITS_VAULT_CODE_RES")
NEW_LOCKDROP_VAULT_CODE_ID=$(extract_hash "$NEW_LOCKDROP_VAULT_CODE_RES")
NEW_LP_VESTING_VAULT_CODE_ID=$(extract_hash "$NEW_LP_VESTING_VAULT_CODE_RES")
NEW_SUBDAO_CORE_CODE_ID=$(extract_hash "$NEW_SUBDAO_CORE_CODE_RES")
NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_ID=$(extract_hash "$NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_RES")
NEW_SUBDAO_TIMELOCK_SINGLE_CODE_ID=$(extract_hash "$NEW_SUBDAO_TIMELOCK_SINGLE_CODE_RES")
NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID=$(extract_hash "$NEW_SUBDAO_PROPOSAL_SINGLE_CODE_RES")
NEW_INVESTORS_VESTING_VAULT_CODE_ID=$(extract_hash "$NEW_INVESTORS_VESTING_VAULT_CODE_RES")
NEW_DISTRIBUTION_CODE_ID=$(extract_hash "$NEW_DISTRIBUTION_CODE_RES")
NEW_RESERVE_CODE_ID=$(extract_hash "$NEW_RESERVE_CODE_RES")

# ===== MIGRATE
EMPTY_MIGRATE_MSG='{}'
MIGRATE_MSG_BASE64=$(json_to_base64 "$EMPTY_MIGRATE_MSG")

MIGRATE_MSGS='[
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${MAIN_DAO}"'",
                "new_code_id": '"${NEW_MAIN_DAO_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${SINGLE_PROPOSAL}"'",
                "new_code_id": '"${NEW_PROPOSAL_SINGLE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${SINGLE_PRE_PROPOSAL}"'",
                "new_code_id": '"${NEW_PRE_PROPOSE_SINGLE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${MULTIPLE_PROPOSAL}"'",
                "new_code_id": '"${NEW_PROPOSAL_MULTIPLE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${MULTIPLE_PRE_PROPOSAL}"'",
                "new_code_id": '"${NEW_PRE_PROPOSE_MULTIPLE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${OVERRULE_PROPOSAL}"'",
                "new_code_id": '"${NEW_PROPOSAL_SINGLE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${OVERRULE_PRE_PROPOSAL}"'",
                "new_code_id": '"${NEW_PRE_PROPOSE_OVERRULE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${VOTING_REGISTRY}"'",
                "new_code_id": '"${NEW_VOTING_REGISTRY_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${NTRN_VAULT}"'",
                "new_code_id": '"${NEW_NEUTRON_VAULT_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${CREDITS_VAULT}"'",
                "new_code_id": '"${NEW_CREDITS_VAULT_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${LOCKDROP_VAULT}"'",
                "new_code_id": '"${NEW_LOCKDROP_VAULT_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${LP_VESTING_VAULT}"'",
                "new_code_id": '"${NEW_LP_VESTING_VAULT_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${SECURITY_SUBDAO}"'",
                "new_code_id": '"${NEW_SUBDAO_CORE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${SECURITY_SINGLE_PROPOSAL}"'",
                "new_code_id": '"${NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${SECURITY_SINGLE_PRE_PROPOSAL}"'",
                "new_code_id": '"${NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    }
]'

# TODO: no investors vault upgrade here

echo $MIGRATE_MSGS | jq . > migrate_proposal_for_dao.json

# !!! Q: DON't NEED TO UPDATE CW4 contracts?
  #  {
  #       "wasm": {
  #           "migrate": {
  #               "contract_addr": "'"${SECURITY_SUBDAO_VOTING}"'",
  #               "new_code_id": '"${CW4_VOTING_CONTRACT_BINARY_ID}"',
  #               "msg": "'"${MIGRATE_MSG_BASE64}"'"
  #           }
  #       }
  #   },
  #  {
  #       "wasm": {
  #           "migrate": {
  #               "contract_addr": "'"${SECURITY_CW4}"'",
  #               "new_code_id": '"${}"',
  #               "msg": "'"${MIGRATE_MSG_BASE64}"'"
  #           }
  #       }
  #   },
