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
TESTNET_RPC=http://65.109.239.170:26657
DEPLOYER=neutrond_demowallet_2
KEYS_HOME=~/.neutrond
DEPLOYER_ADDR=$(${BINARY} keys show ${DEPLOYER} --keyring-backend test -a --home ${KEYS_HOME})
TESTNET_CHAINID=neutron-1
GAS_PRICES=0.9untrn
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

  sleep 5
   
  echo $RES
}

function extract_hash() {
    RES=$1
    HASH=$(echo $RES | jq -r '.txhash')
    CODE_ID=$(curl $REST/cosmos/tx/v1beta1/txs/$HASH | jq '.tx_response.logs[0].events[1].attributes[1].value')
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
CREDITS_VAULT=neutron1rxwzsw37ulveefk20575mlxl3hzhzv9k46c8gklfkt4g2vk4w3tse8usrs
LOCKDROP_VAULT=neutron1f8gs4rp232ngyta3g2efwfkznymvv85du7qm9y0mhvjxpp3cq68qgquudm
LP_VESTING_VAULT=neutron1adavpfxyp5kgs3zp0n0vkc37qakeh5eqwxqxzysgg0ahlx82rmsqp4rnz8
INVESTORS_VESTING_VAULT=neutron1dmd56h7hlevuwssp203fgc2uh0qdtwep2m735fzksuavgq3naslqp0ehvx

SECURITY_SUBDAO=neutron1fuyxwxlsgjkfjmxfthq8427dm2am3ya3cwcdr8gls29l7jadtazsuyzwcc
SECURITY_SUBDAO_SINGLE_PROPOSAL=neutron15m728qxvtat337jdu2f0uk6pu905kktrxclgy36c0wd822tpxcmqvnrurt
SECURITY_SUBDAO_SINGLE_PRE_PROPOSAL=neutron1zjd5lwhch4ndnmayqxurja4x5y5mavy9ktrk6fzsyzan4wcgawnqjk5g26
# SECURITY_SUBDAO_VOTING=NOT_MIGRATED neutron1wastjc07zuuy46mzzl3egz4uzy6fs59752grxqvz8zlsqccpv2wqhjw0cl
# SECURITY_CW4=NOT_MIGRATED neutron1hyja4uyjktpeh0fxzuw2fmjudr85rk2qu98fa6nuh6d4qru9l0ssh3kgnu

GRANTS_SUBDAO=neutron1zjdv3u6svlazlydmje2qcp44yqkt0059chz8gmyl5yrklmgv6fzq9chelu
GRANTS_SUBDAO_SINGLE_PROPOSAL=neutron14n7jt2qkngxtgr7dgdt50g4xn2a29llz79h9y25lrsqyxrwmngmsmt9kta
GRANTS_SUBDAO_SINGLE_PRE_PROPOSAL=neutron1s0fjev2pmgyaj0uthszzp3tpx59yp2p07vwhj0467sl9j343dk9qss6x9w
# GRANTS_SUBDAO_VOTING=NOT_MIGRATED

DISTRIBUTION=neutron1dk9c86h7gmvuaq89cv72cjhq4c97r2wgl5gyfruv6shquwspalgq5u7sy5
RESERVE=neutron13we0myxwzlpx8l5ark8elw5gj5d59dl6cjkzmt80c5q5cv5rt54qvzkv2a


# ===== STORE
NEW_MAIN_DAO_CODE_RES=$(store_code "new_artifacts_dao/cwd_core.wasm")
NEW_MAIN_DAO_CODE_ID=$(extract_hash "$NEW_MAIN_DAO_CODE_RES")
echo $NEW_MAIN_DAO_CODE_ID
# 246

NEW_PROPOSAL_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_proposal_single.wasm")
NEW_PROPOSAL_SINGLE_CODE_ID=$(extract_hash "$NEW_PROPOSAL_SINGLE_CODE_RES")
echo $NEW_PROPOSAL_SINGLE_CODE_ID
# 247

NEW_PRE_PROPOSE_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_pre_propose_single.wasm")
NEW_PRE_PROPOSE_SINGLE_CODE_ID=$(extract_hash "$NEW_PRE_PROPOSE_SINGLE_CODE_RES")
echo $NEW_PRE_PROPOSE_SINGLE_CODE_ID
# 248

NEW_PROPOSAL_MULTIPLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_proposal_multiple.wasm")
NEW_PROPOSAL_MULTIPLE_CODE_ID=$(extract_hash "$NEW_PROPOSAL_MULTIPLE_CODE_RES")
echo $NEW_PROPOSAL_MULTIPLE_CODE_ID
# 249

NEW_PRE_PROPOSE_MULTIPLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_pre_propose_multiple.wasm")
NEW_PRE_PROPOSE_MULTIPLE_CODE_ID=$(extract_hash "$NEW_PRE_PROPOSE_MULTIPLE_CODE_RES")
echo $NEW_PRE_PROPOSE_MULTIPLE_CODE_ID
# 250

NEW_PRE_PROPOSE_OVERRULE_CODE_RES=$(store_code "new_artifacts_dao/cwd_pre_propose_overrule.wasm")
NEW_PRE_PROPOSE_OVERRULE_CODE_ID=$(extract_hash "$NEW_PRE_PROPOSE_OVERRULE_CODE_RES")
echo $NEW_PRE_PROPOSE_OVERRULE_CODE_ID
# 251

NEW_VOTING_REGISTRY_CODE_RES=$(store_code "new_artifacts_dao/neutron_voting_registry.wasm")
NEW_VOTING_REGISTRY_CODE_ID=$(extract_hash "$NEW_VOTING_REGISTRY_CODE_RES")
echo $NEW_VOTING_REGISTRY_CODE_ID
# 252

NEW_NEUTRON_VAULT_CODE_RES=$(store_code "new_artifacts_dao/neutron_vault.wasm")
NEW_NEUTRON_VAULT_CODE_ID=$(extract_hash "$NEW_NEUTRON_VAULT_CODE_RES")
echo $NEW_NEUTRON_VAULT_CODE_ID
# 253

NEW_CREDITS_VAULT_CODE_RES=$(store_code "new_artifacts_dao/credits_vault.wasm")
NEW_CREDITS_VAULT_CODE_ID=$(extract_hash "$NEW_CREDITS_VAULT_CODE_RES")
echo $NEW_CREDITS_VAULT_CODE_ID
# 254

NEW_LOCKDROP_VAULT_CODE_RES=$(store_code "new_artifacts_dao/lockdrop_vault.wasm")
NEW_LOCKDROP_VAULT_CODE_ID=$(extract_hash "$NEW_LOCKDROP_VAULT_CODE_RES")
echo $NEW_LOCKDROP_VAULT_CODE_ID
# 255

NEW_LP_VESTING_VAULT_CODE_RES=$(store_code "new_artifacts_dao/vesting_lp_vault.wasm")
NEW_LP_VESTING_VAULT_CODE_ID=$(extract_hash "$NEW_LP_VESTING_VAULT_CODE_RES")
echo $NEW_LP_VESTING_VAULT_CODE_ID
# 256

NEW_INVESTORS_VESTING_VAULT_CODE_RES=$(store_code "new_artifacts_dao/investors_vesting_vault.wasm")
NEW_INVESTORS_VESTING_VAULT_CODE_ID=$(extract_hash "$NEW_INVESTORS_VESTING_VAULT_CODE_RES")
echo $NEW_INVESTORS_VESTING_VAULT_CODE_ID
# 257

NEW_SUBDAO_CORE_CODE_RES=$(store_code "new_artifacts_dao/cwd_subdao_core.wasm")
NEW_SUBDAO_CORE_CODE_ID=$(extract_hash "$NEW_SUBDAO_CORE_CODE_RES")
echo $NEW_SUBDAO_CORE_CODE_ID
# 258

NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_subdao_pre_propose_single.wasm")
NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_ID=$(extract_hash "$NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_RES")
echo $NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_ID
# 259

NEW_SUBDAO_PROPOSAL_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_subdao_proposal_single.wasm")
NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID=$(extract_hash "$NEW_SUBDAO_PROPOSAL_SINGLE_CODE_RES")
echo $NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID
# 260

# TODO: use for grants subdao
NEW_SUBDAO_TIMELOCK_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_subdao_timelock_single.wasm")
NEW_SUBDAO_TIMELOCK_SINGLE_CODE_ID=$(extract_hash "$NEW_SUBDAO_TIMELOCK_SINGLE_CODE_RES")
echo $NEW_SUBDAO_TIMELOCK_SINGLE_CODE_ID
# 261

NEW_DISTRIBUTION_CODE_RES=$(store_code "new_artifacts_dao/neutron_distribution.wasm")
NEW_DISTRIBUTION_CODE_ID=$(extract_hash "$NEW_DISTRIBUTION_CODE_RES")
echo $NEW_DISTRIBUTION_CODE_ID
# 262

NEW_RESERVE_CODE_RES=$(store_code "new_artifacts_dao/neutron_reserve.wasm")
NEW_RESERVE_CODE_ID=$(extract_hash "$NEW_RESERVE_CODE_RES")
echo $NEW_RESERVE_CODE_ID
# 263

# unused now
NEW_SUBDAO_SINGLE_NO_TIMELOCK_RES=$(store_code "new_artifacts_dao/neutron_reserve.wasm")
NEW_SUBDAO_SINGLE_NO_TIMELOCK_ID=$(extract_hash "$NEW_SUBDAO_SINGLE_NO_TIMELOCK_RES")
echo $NEW_SUBDAO_SINGLE_NO_TIMELOCK_ID
# 264

# ===== MIGRATE
EMPTY_MIGRATE_MSG='{}'
MIGRATE_MSG_BASE64=$(json_to_base64 "$EMPTY_MIGRATE_MSG")

FROM_COMPATIBLE='{
    "from_compatible": {}
}'
FROM_COMPATIBLE_BASE64=$(json_to_base64 "$FROM_COMPATIBLE")

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
                "msg": "'"${FROM_COMPATIBLE_BASE64}"'"
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
                "contract_addr": "'"${INVESTORS_VESTING_VAULT}"'",
                "new_code_id": '"${NEW_INVESTORS_VESTING_VAULT_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${SECURITY_SUBDAO}"'",
                "new_code_id": '"${NEW_SUBDAO_CORE_CODE_ID}"',
                "msg": "'"${FROM_COMPATIBLE_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${SECURITY_SUBDAO_SINGLE_PROPOSAL}"'",
                "new_code_id": '"${NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${SECURITY_SUBDAO_SINGLE_PRE_PROPOSAL}"'",
                "new_code_id": '"${NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${GRANTS_SUBDAO}"'",
                "new_code_id": '"${NEW_SUBDAO_CORE_CODE_ID}"',
                "msg": "'"${FROM_COMPATIBLE_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${GRANTS_SUBDAO_SINGLE_PROPOSAL}"'",
                "new_code_id": '"${NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${GRANTS_SUBDAO_SINGLE_PRE_PROPOSAL}"'",
                "new_code_id": '"${NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${DISTRIBUTION}"'",
                "new_code_id": '"${NEW_DISTRIBUTION_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${RESERVE}"'",
                "new_code_id": '"${NEW_RESERVE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    }
]'

echo $MIGRATE_MSGS | jq . > migrate_proposal_for_dao.json

# Questions:
# - do we need to upgrade lido bridge?
# - do we use subdao_proposal_timelock code id for grants subdao proposal or not?
