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
TESTNET_RPC=https://rpc-palvus.pion-1.ntrn.tech:443
DEPLOYER=deployer
KEYS_HOME=~/.neutrond
DEPLOYER_ADDR=$(${BINARY} keys show ${DEPLOYER} --keyring-backend test -a --home ${KEYS_HOME})
TESTNET_CHAINID=pion-1
GAS_PRICES=0.025untrn
REST=https://rest-palvus.pion-1.ntrn.tech:443

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
MAIN_DAO=neutron1kvxlf27r0h7mzjqgdydqdf76dtlyvwz6u9q8tysfae53ajv8urtq4fdkvy
SINGLE_PROPOSAL=neutron19sf2y4dvgt02kczemvhktrwvt4aunrahw8qkjq6u3pehdujwssgqrs5e4h
SINGLE_PRE_PROPOSAL=neutron1fyhj2gq9k4dduahlyy46ffy22ad7lagglcec2acacyzjsd6w5n7qdx5hn4
MULTIPLE_PROPOSAL=neutron14yu369rhq9pz6clxrvpeyxcuj66ay9k98p2dfh3sc9tlwtcqaxcqpk8rky
MULTIPLE_PRE_PROPOSAL=neutron1a73cny2tvr0wggxkfgw72pmr03jwz6vkg0m3q8dzu4qpd983yfcsmxcurx
OVERRULE_PROPOSAL=neutron164w6crv7u0ya0aqqr74ghzt8k4ycwfjrzekxms00vzh07wekj4sq6lk8w7
OVERRULE_PRE_PROPOSAL=neutron16qcmkxjma2c9f07lsewjcnnx436s0x67flwfhx98xaq2ncss4p0s296q2w
VOTING_REGISTRY=neutron1nusmqy8tmx5y2y5qrxprlm64fzwvjl9fhhn0qk5wy6mjkdrudsgqpmyywl
NTRN_VAULT=neutron1hjjqfvpwpkl5ssc6hk76es2lznd4tws75jcvkql9xncmgasemjuqhzyzvg

SECURITY_SUBDAO=neutron1zv35zgj7d6khqxfl3tx95scjljz0rvmkxcsxmggqxrltkm8ystsqvt0qc7
SECURITY_SUBDAO_SINGLE_PROPOSAL=neutron1wyvwhmnvc43reeptqllqmu3a55cz5lj4remvv7gwwt79kdxvchws7npv9u
SECURITY_SUBDAO_SINGLE_PRE_PROPOSAL=neutron1kr23ya5ahn6dksmtyhxhhfn9t62384nk78mjlhgcetmk7q0vr9nqmvdm9y
# SECURITY_SUBDAO_VOTING=NOT_MIGRATED neutron1wastjc07zuuy46mzzl3egz4uzy6fs59752grxqvz8zlsqccpv2wqhjw0cl
# SECURITY_CW4=NOT_MIGRATED neutron1hyja4uyjktpeh0fxzuw2fmjudr85rk2qu98fa6nuh6d4qru9l0ssh3kgnu

GRANTS_SUBDAO=neutron1ag5kllud4k2lwazqj25q8szn9ny56lzxzs03tpscl2c4q8pk242s4vec0j
GRANTS_SUBDAO_SINGLE_PROPOSAL=neutron19cgyfmqewnc29455ah354yps0flef8za22cjs0ff3acjz7vffy0srxhraj
GRANTS_SUBDAO_SINGLE_PRE_PROPOSAL=neutron1cdxqtjdazj9wn32ayec0s2uz35hhjz778htdcxqvvly77w7fdxcqjqa2dh
#TODO: find correct codeid crates.io:cwd-subdao-timelock-single
GRANDS_SUBDAO_PREPROPOSAL_TIMELOCK=neutron17jdvyq87a6plrtnsvwhdxcudswcpgyqequk9tk6n0w6l4ystm44qwyvkkr
# GRANTS_SUBDAO_VOTING=NOT_MIGRATED

DISTRIBUTION=neutron16rsefcle4p2ykpv73hh2xtkmrldh4yr8zn2fvp00zda5e0rqqa4svkg2sv
RESERVE=neutron1clrzatxcga6pzwrdre8nck5swt7y3rvecypn9ryvzhvry0pq378s7g3rpj


# ===== STORE
NEW_MAIN_DAO_CODE_RES=$(store_code "new_artifacts_dao/cwd_core.wasm")
sleep 10
NEW_MAIN_DAO_CODE_ID=$(extract_hash "$NEW_MAIN_DAO_CODE_RES")
echo $NEW_MAIN_DAO_CODE_ID
# 246

NEW_PROPOSAL_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_proposal_single.wasm")
sleep 10
NEW_PROPOSAL_SINGLE_CODE_ID=$(extract_hash "$NEW_PROPOSAL_SINGLE_CODE_RES")
echo $NEW_PROPOSAL_SINGLE_CODE_ID
# 247

NEW_PRE_PROPOSE_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_pre_propose_single.wasm")
sleep 10
NEW_PRE_PROPOSE_SINGLE_CODE_ID=$(extract_hash "$NEW_PRE_PROPOSE_SINGLE_CODE_RES")
echo $NEW_PRE_PROPOSE_SINGLE_CODE_ID
# 248

NEW_PROPOSAL_MULTIPLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_proposal_multiple.wasm")
sleep 10
NEW_PROPOSAL_MULTIPLE_CODE_ID=$(extract_hash "$NEW_PROPOSAL_MULTIPLE_CODE_RES")
echo $NEW_PROPOSAL_MULTIPLE_CODE_ID
# 249

NEW_PRE_PROPOSE_MULTIPLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_pre_propose_multiple.wasm")
sleep 10
NEW_PRE_PROPOSE_MULTIPLE_CODE_ID=$(extract_hash "$NEW_PRE_PROPOSE_MULTIPLE_CODE_RES")
echo $NEW_PRE_PROPOSE_MULTIPLE_CODE_ID
# 250

NEW_PRE_PROPOSE_OVERRULE_CODE_RES=$(store_code "new_artifacts_dao/cwd_pre_propose_overrule.wasm")
sleep 10
NEW_PRE_PROPOSE_OVERRULE_CODE_ID=$(extract_hash "$NEW_PRE_PROPOSE_OVERRULE_CODE_RES")
echo $NEW_PRE_PROPOSE_OVERRULE_CODE_ID
# 251

NEW_VOTING_REGISTRY_CODE_RES=$(store_code "new_artifacts_dao/neutron_voting_registry.wasm")
sleep 10
NEW_VOTING_REGISTRY_CODE_ID=$(extract_hash "$NEW_VOTING_REGISTRY_CODE_RES")
echo $NEW_VOTING_REGISTRY_CODE_ID
# 252

NEW_NEUTRON_VAULT_CODE_RES=$(store_code "new_artifacts_dao/neutron_vault.wasm")
sleep 10
NEW_NEUTRON_VAULT_CODE_ID=$(extract_hash "$NEW_NEUTRON_VAULT_CODE_RES")
echo $NEW_NEUTRON_VAULT_CODE_ID
# 253

NEW_SUBDAO_CORE_CODE_RES=$(store_code "new_artifacts_dao/cwd_subdao_core.wasm")
sleep 10
NEW_SUBDAO_CORE_CODE_ID=$(extract_hash "$NEW_SUBDAO_CORE_CODE_RES")
echo $NEW_SUBDAO_CORE_CODE_ID
# 258

NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_subdao_pre_propose_single.wasm")
sleep 10
NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_ID=$(extract_hash "$NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_RES")
echo $NEW_SUBDAO_PRE_PROPOSE_SINGLE_CODE_ID
# 259

NEW_SUBDAO_PROPOSAL_SINGLE_CODE_RES=$(store_code "new_artifacts_dao/cwd_subdao_proposal_single.wasm")
sleep 10
NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID=$(extract_hash "$NEW_SUBDAO_PROPOSAL_SINGLE_CODE_RES")
echo $NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID
# 260

NEW_DISTRIBUTION_CODE_RES=$(store_code "new_artifacts_dao/neutron_distribution.wasm")
sleep 10
NEW_DISTRIBUTION_CODE_ID=$(extract_hash "$NEW_DISTRIBUTION_CODE_RES")
echo $NEW_DISTRIBUTION_CODE_ID
# 262

NEW_RESERVE_CODE_RES=$(store_code "new_artifacts_dao/neutron_reserve.wasm")
sleep 10
NEW_RESERVE_CODE_ID=$(extract_hash "$NEW_RESERVE_CODE_RES")
echo $NEW_RESERVE_CODE_ID
# 263

GRANDS_SUBDAO_PREPROPOSAL_TIMELOCK_RES=$(store_code "new_artifacts_dao/cwd_subdao_timelock_single.wasm")
sleep 10
GRANDS_SUBDAO_PREPROPOSAL_TIMELOCK_ID=$(extract_hash "$GRANDS_SUBDAO_PREPROPOSAL_TIMELOCK_RES")
echo $GRANDS_SUBDAO_PREPROPOSAL_TIMELOCK_ID


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
    },
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${GRANDS_SUBDAO_PREPROPOSAL_TIMELOCK}"'",
                "new_code_id": '"${GRANDS_SUBDAO_PREPROPOSAL_TIMELOCK_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    }
]'

echo $MIGRATE_MSGS | jq . > migrate_proposal_for_dao.json

# Questions:
# - do we need to upgrade lido bridge?
# - do we use subdao_proposal_timelock code id for grants subdao proposal or not?
