#!/bin/bash
set -e

BINARY=${BINARY:-neutrond}
BASE_DIR=./data
CHAINID=${CHAINID:-test-1}
STAKEDENOM=${STAKEDENOM:-untrn}
CONTRACTS_BINARIES_DIR=${CONTRACTS_BINARIES_DIR:-./contracts}

CHAIN_DIR="$BASE_DIR/$CHAINID"

ADMIN_ADDRESS=$($BINARY keys show demowallet1 -a --home "$CHAIN_DIR" --keyring-backend test)
DAO_CONTRACT=$CONTRACTS_BINARIES_DIR/cwd_core.wasm
PRE_PROPOSAL_CONTRACT=$CONTRACTS_BINARIES_DIR/cwd_pre_propose_single.wasm
PROPOSAL_CONTRACT=$CONTRACTS_BINARIES_DIR/cwd_proposal_single.wasm
VOTING_REGISTRY_CONTRACT=$CONTRACTS_BINARIES_DIR/neutron_voting_registry.wasm
NEUTRON_VAULT_CONTRACT=$CONTRACTS_BINARIES_DIR/neutron_vault.wasm
LOCKDROP_VAULT_CONTRACT=$CONTRACTS_BINARIES_DIR/lockdrop_vault.wasm
PROPOSAL_MULTIPLE_CONTRACT=$CONTRACTS_BINARIES_DIR/cwd_proposal_multiple.wasm
PRE_PROPOSAL_MULTIPLE_CONTRACT=$CONTRACTS_BINARIES_DIR/cwd_pre_propose_multiple.wasm
RESERVE_CONTRACT=$CONTRACTS_BINARIES_DIR/neutron_reserve.wasm
DISTRIBUTION_CONTRACT=$CONTRACTS_BINARIES_DIR/neutron_distribution.wasm
PRE_PROPOSAL_OVERRULE_CONTRACT=$CONTRACTS_BINARIES_DIR/cwd_pre_propose_overrule.wasm


### PARAMETERS SECTION

##pre propose single parameters
# amount of tokens to be deposited on proposal creation [uint]
PRE_PROPOSAL_SINGLE_AMOUNT=1000
# refund policy: [always/never]
PRE_PROPOSAL_SINGLE_REFUND_POLICY=always
# open proposal submission [bool]
PRE_PROPOSAL_SINGLE_OPEN_PROPOSAL_SUBMISSION=false

## propose singe params
# contract lable
PROPOSAL_SINGLE_LABEL=neutron
# if only users w voting power can execute passed proposals
PROPOSAL_SINGLE_ONLY_MEMBERS_EXECUTE=false
# max voting period
PROPOSAL_SINGLE_ONLY_MAX_VOTING_PERIOD=33333
# if proposal will be closed on execution fail [bool]
PROPOSAL_SINGLE_CLOSE_PROPOSAL_ON_EXECUTION_FAILURE=false
# quorum to consider proposal's result viable [float]
PROPOSAL_SINGLE_THRESHHOLD_QUORUM=0.20
# if proposal will be closed on execution fail
PROPOSAL_SINGLE_CLOSE_PROPOSAL_ON_EXECUTION_FAILURE=false

## propose multiple params
# contract label
PROPOSAL_MULTIPLE_LABEL=neutron
# if only users w voting power can execute passed proposals
PROPOSAL_MULTIPLE_ONLY_MEMBERS_EXECUTE=false
# max voting period
PROPOSAL_MULTIPLE_ONLY_MAX_VOTING_PERIOD=33333
# if proposal will be closed on execution fail [bool]
PROPOSAL_MULTIPLE_CLOSE_PROPOSAL_ON_EXECUTION_FAILURE=false
# quorum to consider proposal's result viable [float]
PROPOSAL_MULTIPLE_THRESHHOLD_QUORUM=0.20
# if proposal will be closed on execution fail
PROPOSAL_MULTIPLE_CLOSE_PROPOSAL_ON_EXECUTION_FAILURE=false

## propose multiple params
# contract label
PROPOSAL_OVERRULE_LABEL=neutron
# if only users w voting power can execute passed proposals
PROPOSAL_OVERRULE_ONLY_MEMBERS_EXECUTE=false
# max voting period
PROPOSAL_OVERRULE_ONLY_MAX_VOTING_PERIOD=33333
# if proposal will be closed on execution fail [bool]
PROPOSAL_OVERRULE_CLOSE_PROPOSAL_ON_EXECUTION_FAILURE=false
# quorum to consider proposal's result viable [float]
PROPOSAL_OVERRULE_THRESHHOLD_QUORUM=0.20
# if proposal will be closed on execution fail
PROPOSAL_OVERRULE_CLOSE_PROPOSAL_ON_EXECUTION_FAILURE=false
## TODO quorum


echo "Initializing dao contract in genesis..."

function store_binary() {
  CONTRACT_BINARY_PATH=$1
  $BINARY add-wasm-message store "$CONTRACT_BINARY_PATH" --output json --run-as ${ADMIN_ADDRESS} --keyring-backend=test --home "$CHAIN_DIR"
  BINARY_ID=$(jq -r "[.app_state.wasm.gen_msgs[] | select(.store_code != null)] | length" "$CHAIN_DIR/config/genesis.json")
  echo "$BINARY_ID"
}

# Upload the dao contracts

NEUTRON_VAULT_CONTRACT_BINARY_ID=$(store_binary         "$NEUTRON_VAULT_CONTRACT")
DAO_CONTRACT_BINARY_ID=$(store_binary                   "$DAO_CONTRACT")
PROPOSAL_CONTRACT_BINARY_ID=$(store_binary              "$PROPOSAL_CONTRACT")
VOTING_REGISTRY_CONTRACT_BINARY_ID=$(store_binary       "$VOTING_REGISTRY_CONTRACT")
PRE_PROPOSAL_CONTRACT_BINARY_ID=$(store_binary          "$PRE_PROPOSAL_CONTRACT")
PROPOSAL_MULTIPLE_CONTRACT_BINARY_ID=$(store_binary     "$PROPOSAL_MULTIPLE_CONTRACT")
PRE_PROPOSAL_MULTIPLE_CONTRACT_BINARY_ID=$(store_binary "$PRE_PROPOSAL_MULTIPLE_CONTRACT")
RESERVE_CONTRACT_BINARY_ID=$(store_binary              "$RESERVE_CONTRACT")
DISTRIBUTION_CONTRACT_BINARY_ID=$(store_binary          "$DISTRIBUTION_CONTRACT")
LOCKDROP_VAULT_CONTRACT_BINARY_ID=$(store_binary        "$LOCKDROP_VAULT_CONTRACT")
PRE_PROPOSAL_OVERRULE_CONTRACT_BINARY_ID=$(store_binary "$PRE_PROPOSAL_OVERRULE_CONTRACT")

# WARNING!
# The following code is needed to pre-generate the contract addresses
# Those addresses depend on the ORDER OF CONTRACTS INITIALIZATION
# Thus, this code section depends a lot on the order and content of the instantiate-contract commands at the end script
# It also depends on the implicitly initialized contracts (e.g. DAO core instantiation also instantiate proposals and stuff)
# If you're to do any changes, please do it consistently in both sections
# If you're to do add any implicitly initialized contracts in init messages, please reflect changes here
INSTANCE_ID_COUNTER=1
NEUTRON_VAULT_CONTRACT_ADDRESS=$($BINARY debug generate-contract-address "$INSTANCE_ID_COUNTER"          "$NEUTRON_VAULT_CONTRACT_BINARY_ID") && (( INSTANCE_ID_COUNTER++ ))
DAO_CONTRACT_ADDRESS=$($BINARY debug generate-contract-address "$INSTANCE_ID_COUNTER"                    "$DAO_CONTRACT_BINARY_ID") && (( INSTANCE_ID_COUNTER++ ))
PROPOSAL_SINGLE_CONTRACT_ADDRESS=$($BINARY debug generate-contract-address "$INSTANCE_ID_COUNTER"        "$PROPOSAL_CONTRACT_BINARY_ID") && (( INSTANCE_ID_COUNTER++ ))
PRE_PROPOSAL_CONTRACT_ADDRESS=$($BINARY debug generate-contract-address "$INSTANCE_ID_COUNTER"           "$PRE_PROPOSAL_CONTRACT_BINARY_ID") && (( INSTANCE_ID_COUNTER++ ))
PROPOSAL_MULTIPLE_CONTRACT_ADDRESS=$($BINARY debug generate-contract-address "$INSTANCE_ID_COUNTER"      "$PROPOSAL_MULTIPLE_CONTRACT_BINARY_ID") && (( INSTANCE_ID_COUNTER++ ))
PRE_PROPOSAL_MULTIPLE_CONTRACT_ADDRESS=$($BINARY debug generate-contract-address "$INSTANCE_ID_COUNTER"  "$PRE_PROPOSAL_MULTIPLE_CONTRACT_BINARY_ID") && (( INSTANCE_ID_COUNTER++ ))
PROPOSAL_OVERRULE_CONTRACT_ADDRESS=$($BINARY debug generate-contract-address "$INSTANCE_ID_COUNTER"      "$PROPOSAL_CONTRACT_BINARY_ID") && (( INSTANCE_ID_COUNTER++ ))
PRE_PROPOSAL_OVERRULE_CONTRACT_ADDRESS=$($BINARY debug generate-contract-address "$INSTANCE_ID_COUNTER"  "$PRE_PROPOSAL_OVERRULE_CONTRACT_BINARY_ID") && (( INSTANCE_ID_COUNTER++ ))
VOTING_REGISTRY_CONTRACT_ADDRESS=$($BINARY debug generate-contract-address "$INSTANCE_ID_COUNTER"        "$VOTING_REGISTRY_CONTRACT_BINARY_ID") && (( INSTANCE_ID_COUNTER++ ))
RESERVE_CONTRACT_ADDRESS=$($BINARY debug generate-contract-address "$INSTANCE_ID_COUNTER"                "$RESERVE_CONTRACT_BINARY_ID") && (( INSTANCE_ID_COUNTER++ ))
DISTRIBUTION_CONTRACT_ADDRESS=$($BINARY debug generate-contract-address "$INSTANCE_ID_COUNTER"           "$DISTRIBUTION_CONTRACT_BINARY_ID") && (( INSTANCE_ID_COUNTER++ ))
LOCKDROP_VAULT_CONTRACT_ADDRESS=$($BINARY debug generate-contract-address "$INSTANCE_ID_COUNTER"         "$LOCKDROP_VAULT_CONTRACT_BINARY_ID") && (( INSTANCE_ID_COUNTER++ ))

# PRE_PROPOSE_INIT_MSG will be put into the PROPOSAL_SINGLE_INIT_MSG and PROPOSAL_MULTIPLE_INIT_MSG
PRE_PROPOSE_INIT_MSG='{
   "deposit_info":{
      "denom":{
         "token":{
            "denom":{
               "native":"'"$STAKEDENOM"'"
            }
         }
      },
     "amount": "'"$PRE_PROPOSAL_SINGLE_AMOUNT"'",
     "refund_policy":"'"$PRE_PROPOSAL_SINGLE_REFUND_POLICY"'"
   },
   "open_proposal_submission": '"$PRE_PROPOSAL_SINGLE_REFUND_POLICY"'
}'
PRE_PROPOSE_INIT_MSG_BASE64=$(echo "$PRE_PROPOSE_INIT_MSG" | base64 | tr -d "\n")

# -------------------- PROPOSE-SINGLE { PRE-PROPOSE } --------------------

PROPOSAL_SINGLE_INIT_MSG='{
   "allow_revoting":false,
   "pre_propose_info":{
      "module_may_propose":{
         "info":{
            "admin": {
              "core_module": {}
            },
            "code_id": '"$PRE_PROPOSAL_CONTRACT_BINARY_ID"',
            "msg": "'"$PRE_PROPOSE_INIT_MSG_BASE64"'",
            "label":"'"$PROPOSE_PROPOSAL_SINGLE_LABEL"'"
         }
      }
   },
   "only_members_execute":'"$PROPOSAL_SINGLE_ONLY_MEMBERS_EXECUTE"',
   "max_voting_period":{
      "time":'"$PROPOSAL_SINGLE_ONLY_MAX_VOTING_PERIOD"'
   },
   "close_proposal_on_execution_failure":'"$PROPOSAL_SINGLE_CLOSE_PROPOSAL_ON_EXECUTION_FAILURE"',
   "threshold":{
      "threshold_quorum":{
         "quorum":{
          "percent":"'"$PROPOSAL_SINGLE_THRESHHOLD_QUORUM"'"
         },
         "threshold":{
            "majority":{

            }
         }
      }
   }
}'
PROPOSAL_SINGLE_INIT_MSG_BASE64=$(echo "$PROPOSAL_SINGLE_INIT_MSG" | base64 | tr -d "\n")

# -------------------- PROPOSE-MULTIPLE { PRE-PROPOSE } --------------------

PROPOSAL_MULTIPLE_INIT_MSG='{
   "allow_revoting":false,
   "pre_propose_info":{
      "module_may_propose":{
         "info":{
            "admin": {
              "core_module": {}
            },
            "code_id": '"$PRE_PROPOSAL_MULTIPLE_CONTRACT_BINARY_ID"',
            "msg": "'"$PRE_PROPOSE_INIT_MSG_BASE64"'",
            "label":"'"$PROPOSAL_MULTIPLE_LABEL"'"
         }
      }
   },
   "only_members_execute":'"$PROPOSAL_MULTIPLE_ONLY_MEMBERS_EXECUTE"',
   "max_voting_period":{
      "time":'"$PROPOSAL_SINGLE_ONLY_MAX_VOTING_PERIOD"'
   },
   "close_proposal_on_execution_failure":'"$PROPOSAL_MULTIPLE_CLOSE_PROPOSAL_ON_EXECUTION_FAILURE"',
   "voting_strategy":{
     "single_choice": {
        "quorum": {
          "majority": {
          }
        }
     }
   }
}'
PROPOSAL_MULTIPLE_INIT_MSG_BASE64=$(echo "$PROPOSAL_MULTIPLE_INIT_MSG" | base64 | tr -d "\n")

# PRE_PROPOSE_OVERRULE_INIT_MSG will be put into the PROPOSAL_OVERRULE_INIT_MSG
PRE_PROPOSE_OVERRULE_INIT_MSG='{}'
PRE_PROPOSE_OVERRULE_INIT_MSG_BASE64=$(echo "$PRE_PROPOSE_OVERRULE_INIT_MSG" | base64 | tr -d "\n")


# -------------------- PROPOSE-OVERRULE { PRE-PROPOSE-OVERRULE } --------------------

PROPOSAL_OVERRULE_INIT_MSG='{
   "allow_revoting":false,
   "pre_propose_info":{
      "module_may_propose":{
         "info":{
            "admin": {
              "core_module": {}
            },
            "code_id": '"$PRE_PROPOSAL_OVERRULE_CONTRACT_BINARY_ID"',
            "msg": "'"$PRE_PROPOSE_OVERRULE_INIT_MSG_BASE64"'",
            "label":"'"$PROPOSAL_OVERRULE_LABEL"'"
         }
      }
   },
   "only_members_execute":'"$PROPOSAL_OVERRULE_ONLY_MEMBERS_EXECUTE"',
   "max_voting_period":{
      "time":'"$PROPOSAL_OVERRULE_ONLY_MAX_VOTING_PERIOD"'
   },
   "close_proposal_on_execution_failure":'"$PROPOSAL_OVERRULE_CLOSE_PROPOSAL_ON_EXECUTION_FAILURE"',
   "threshold":{
     "absolute_percentage":{
        "percentage":{
           "percent":"0.10"
        }
     }
   }
}'
PROPOSAL_OVERRULE_INIT_MSG_BASE64=$(echo "$PROPOSAL_OVERRULE_INIT_MSG" | base64 | tr -d "\n")

VOTING_REGISTRY_INIT_MSG='{
  "manager": null,
  "owner": {
    "address": {
      "addr": "'"$ADMIN_ADDRESS"'"
    }
  },
  "voting_vaults": [
    "'"$NEUTRON_VAULT_CONTRACT_ADDRESS"'",
    "'"$LOCKDROP_VAULT_CONTRACT_ADDRESS"'"
  ]
}'
VOTING_REGISTRY_INIT_MSG_BASE64=$(echo "$VOTING_REGISTRY_INIT_MSG" | base64 | tr -d "\n")

DAO_INIT='{
  "description": "basic neutron dao",
  "name": "Neutron",
  "initial_items": null,
  "proposal_modules_instantiate_info": [
    {
      "admin": {
        "core_module": {}
      },
      "code_id": '"$PROPOSAL_CONTRACT_BINARY_ID"',
      "label": "DAO_Neutron_cw-proposal-single",
      "msg": "'"$PROPOSAL_SINGLE_INIT_MSG_BASE64"'"
    },
    {
      "admin": {
        "core_module": {}
      },
      "code_id": '"$PROPOSAL_MULTIPLE_CONTRACT_BINARY_ID"',
      "label": "DAO_Neutron_cw-proposal-multiple",
      "msg": "'"$PROPOSAL_MULTIPLE_INIT_MSG_BASE64"'"
    },
    {
      "admin": {
        "core_module": {}
      },
      "code_id": '"$PROPOSAL_CONTRACT_BINARY_ID"',
      "label": "DAO_Neutron_cw-proposal-overrule",
      "msg": "'"$PROPOSAL_OVERRULE_INIT_MSG_BASE64"'"
    }
  ],
  "voting_registry_module_instantiate_info": {
    "admin": {
      "core_module": {}
    },
    "code_id": '"$VOTING_REGISTRY_CONTRACT_BINARY_ID"',
    "label": "DAO_Neutron_voting_registry",
    "msg": "'"$VOTING_REGISTRY_INIT_MSG_BASE64"'"
  }
}'

# TREASURY

# TODO: properly initialize treasury
RESERVE_INIT='{
  "main_dao_address": "'"$ADMIN_ADDRESS"'",
  "security_dao_address": "'"$ADMIN_ADDRESS"'",
  "denom": "'"$STAKEDENOM"'",
  "distribution_rate": "0",
  "min_period": 10,
  "distribution_contract": "'"$DISTRIBUTION_CONTRACT_ADDRESS"'",
  "treasury_contract": "'"$ADMIN_ADDRESS"'",
  "vesting_denominator": "1"
}'

DISTRIBUTION_INIT='{
  "main_dao_address": "'"$ADMIN_ADDRESS"'",
  "security_dao_address": "'"$ADMIN_ADDRESS"'",
  "denom": "'"$STAKEDENOM"'"
}'

# VAULTS

NEUTRON_VAULT_INIT='{
  "owner": {
    "address": {
      "addr": "'"$ADMIN_ADDRESS"'"
    }
  },
  "name": "voting vault",
  "denom": "'"$STAKEDENOM"'",
  "description": "a simple voting vault for testing purposes"
}'
# since the lockdrop_contract is still a mock, the address is a random valid one just to pass instantiation
LOCKDROP_VAULT_INIT='{
  "owner": {
    "address": {
      "addr": "'"$ADMIN_ADDRESS"'"
    }
  },
  "name": "lockdrop vault",
  "description": "a lockdrop vault for testing purposes",
  "lockdrop_contract": "neutron17zayzl5d0daqa89csvv8kqayxzke6jd6zh00tq"
}'

# CW4 MODULES FOR SUBDAOS

CW4_VOTE_INIT_MSG='{
  "cw4_group_code_id": '"$CW4_GROUP_CONTRACT_BINARY_ID"',
  "initial_members": [
    {
      "addr": "'"$ADMIN_ADDRESS"'",
      "weight": 1
    }
  ]
}'
CW4_VOTE_INIT_MSG_BASE64=$(echo "$CW4_VOTE_INIT_MSG" | base64 | tr -d "\n")

# SECURITY_SUBDAO

# SECURITY_SUBDAO_PRE_PROPOSE_INIT_MSG will be put into the SECURITY_SUBDAO_PROPOSAL_INIT_MSG
SECURITY_SUBDAO_PRE_PROPOSE_INIT_MSG='{
   "open_proposal_submission":true
}'

SECURITY_SUBDAO_PRE_PROPOSE_INIT_MSG_BASE64=$(echo "$SECURITY_SUBDAO_PRE_PROPOSE_INIT_MSG" | base64 | tr -d "\n")

SECURITY_SUBDAO_PROPOSAL_INIT_MSG='{
   "allow_revoting": false,
   "pre_propose_info":{
         "module_may_propose":{
            "info":{
               "admin": {
                     "address": {
                       "addr": "'"$DAO_CONTRACT_ADDRESS"'"
                     }
               },
               "code_id": '"$PRE_PROPOSAL_CONTRACT_BINARY_ID"',
               "msg": "'"$SECURITY_SUBDAO_PRE_PROPOSE_INIT_MSG_BASE64"'",
               "label":"neutron"
            }
         }
      },
   "only_members_execute":false,
   "max_voting_period":{
      "height": 1000000000000
   },
   "close_proposal_on_execution_failure":false,
   "threshold":{
      "absolute_count":{
         "threshold": "1"
      }
   }
}'
SECURITY_SUBDAO_PROPOSAL_INIT_MSG_BASE64=$(echo "$SECURITY_SUBDAO_PROPOSAL_INIT_MSG" | base64 | tr -d "\n")

SECURITY_SUBDAO_CORE_INIT_MSG='{
  "name": "Security subdao",
  "description": "Makes the whole Neutron secure",
  "vote_module_instantiate_info": {
    "admin": {
      "address": {
        "addr": "'"$DAO_CONTRACT_ADDRESS"'"
      }
    },
    "code_id": '"$CW4_VOTING_CONTRACT_BINARY_ID"',
    "label": "Security subDAO vote module",
    "msg": "'"$CW4_VOTE_INIT_MSG_BASE64"'"
  },
  "proposal_modules_instantiate_info": [
    {
      "admin": {
        "address": {
          "addr": "'"$DAO_CONTRACT_ADDRESS"'"
        }
      },
      "code_id": '"$SUBDAO_PROPOSAL_BINARY_ID"',
      "label": "Security_subDAO_Neutron_proposal-single",
      "msg": "'"$SECURITY_SUBDAO_PROPOSAL_INIT_MSG_BASE64"'"
    }
  ],
  "dao_uri": "security.subdao.org",
  "main_dao": "'"$DAO_CONTRACT_ADDRESS"'",
  "security_dao": "'"$SECURITY_SUBDAO_CORE_CONTRACT_ADDRESS"'"
}'

# GRANTS_SUBDAO

GRANTS_SUBDAO_TIMELOCK_INIT_MSG='{
  "timelock_duration": 20
}'
GRANTS_SUBDAO_TIMELOCK_INIT_MSG_BASE64=$(echo "$GRANTS_SUBDAO_TIMELOCK_INIT_MSG" | base64 | tr -d "\n")

GRANTS_SUBDAO_PRE_PROPOSE_INIT_MSG='{
  "open_proposal_submission": true,
  "timelock_module_instantiate_info": {
    "admin": {
      "address": {
        "addr": "'"$DAO_CONTRACT_ADDRESS"'"
      }
    },
    "code_id": '"$SUBDAO_TIMELOCK_BINARY_ID"',
    "label": "subDAO timelock contract",
    "msg": "'"$GRANTS_SUBDAO_TIMELOCK_INIT_MSG_BASE64"'"
  }
}'
GRANTS_SUBDAO_PRE_PROPOSE_INIT_MSG_BASE64=$(echo "$GRANTS_SUBDAO_PRE_PROPOSE_INIT_MSG" | base64 | tr -d "\n")

GRANTS_SUBDAO_PROPOSAL_INIT_MSG='{
   "allow_revoting": false,
   "pre_propose_info":{
      "module_may_propose":{
         "info":{
            "admin": {
              "address": {
                "addr": "'"$DAO_CONTRACT_ADDRESS"'"
              }
            },
            "code_id": '"$SUBDAO_PRE_PROPOSE_BINARY_ID"',
            "msg": "'"$GRANTS_SUBDAO_PRE_PROPOSE_INIT_MSG_BASE64"'",
            "label":"neutron"
         }
      }
   },
   "only_members_execute":false,
   "max_voting_period":{
      "height": 1000000000000
   },
   "close_proposal_on_execution_failure":false,
   "threshold":{
      "absolute_count":{
         "threshold": "1"
      }
   }
}'
GRANTS_SUBDAO_PROPOSAL_INIT_MSG_BASE64=$(echo "$GRANTS_SUBDAO_PROPOSAL_INIT_MSG" | base64 | tr -d "\n")

GRANTS_SUBDAO_CORE_INIT_MSG='{
  "name": "Grants subdao",
  "description": "Bootstraps the Neutron ecosystem",
  "vote_module_instantiate_info": {
    "admin": {
      "address": {
        "addr": "'"$DAO_CONTRACT_ADDRESS"'"
      }
    },
    "code_id": '"$CW4_VOTING_CONTRACT_BINARY_ID"',
    "label": "Security subDAO vote module",
    "msg": "'"$CW4_VOTE_INIT_MSG_BASE64"'"
  },
  "proposal_modules_instantiate_info": [
    {
      "admin": {
        "address": {
          "addr": "'"$DAO_CONTRACT_ADDRESS"'"
        }
      },
      "code_id": '"$SUBDAO_PROPOSAL_BINARY_ID"',
      "label": "Grants_subDAO_Neutron_proposal-single",
      "msg": "'"$GRANTS_SUBDAO_PROPOSAL_INIT_MSG_BASE64"'"
    }
  ],
  "dao_uri": "grants.subdao.org",
  "main_dao": "'"$DAO_CONTRACT_ADDRESS"'",
  "security_dao": "'"$SECURITY_SUBDAO_CORE_CONTRACT_ADDRESS"'"
}'

echo "Instantiate contracts"
# WARNING!
# The following code is to add contracts instantiations messages to genesis
# It affects the section of predicting contracts addresses at the beginning of the script
# If you're to do any changes, please do it consistently in both sections
$BINARY add-wasm-message instantiate-contract "$NEUTRON_VAULT_CONTRACT_BINARY_ID"   "$NEUTRON_VAULT_INIT"             --label "DAO_Neutron_voting_vault"    --run-as "$ADMIN_ADDRESS" --admin "$DAO_CONTRACT_ADDRESS" --home "$CHAIN_DIR"
$BINARY add-wasm-message instantiate-contract "$LOCKDROP_VAULT_CONTRACT_BINARY_ID"  "$LOCKDROP_VAULT_INIT"            --label "DAO_Neutron_lockdrop_vault"  --run-as "$ADMIN_ADDRESS" --admin "$DAO_CONTRACT_ADDRESS" --home "$CHAIN_DIR"
$BINARY add-wasm-message instantiate-contract "$DAO_CONTRACT_BINARY_ID"             "$DAO_INIT"                       --label "DAO"                         --run-as "$ADMIN_ADDRESS" --admin "$DAO_CONTRACT_ADDRESS" --home "$CHAIN_DIR"
$BINARY add-wasm-message instantiate-contract "$RESERVE_CONTRACT_BINARY_ID"        "$RESERVE_INIT"                  --label   "Reserve"                    --run-as "$ADMIN_ADDRESS" --admin "$DAO_CONTRACT_ADDRESS" --home "$CHAIN_DIR"
$BINARY add-wasm-message instantiate-contract "$DISTRIBUTION_CONTRACT_BINARY_ID"    "$DISTRIBUTION_INIT"              --label "Distribution"                --run-as "$ADMIN_ADDRESS" --admin "$DAO_CONTRACT_ADDRESS" --home "$CHAIN_DIR"
$BINARY add-wasm-message instantiate-contract "$SUBDAO_CORE_BINARY_ID"              "$SECURITY_SUBDAO_CORE_INIT_MSG"  --label "DAO_Neutron_security_subdao" --run-as "$ADMIN_ADDRESS" --admin "$DAO_CONTRACT_ADDRESS" --home "$CHAIN_DIR"
$BINARY add-wasm-message instantiate-contract "$SUBDAO_CORE_BINARY_ID"              "$GRANTS_SUBDAO_CORE_INIT_MSG"    --label "DAO_Neutron_grants_subdao"   --run-as "$ADMIN_ADDRESS" --admin "$DAO_CONTRACT_ADDRESS" --home "$CHAIN_DIR"

ADD_SUBDAOS_MSG='{
  "update_sub_daos": {
    "to_add": [
      {
        "addr": "'"$SECURITY_SUBDAO_CORE_CONTRACT_ADDRESS"'"
      },
      {
        "addr": "'"$GRANTS_SUBDAO_CORE_CONTRACT_ADDRESS"'"
      }
    ],
    "to_remove": []
  }
}'

echo "CORE_CONTRACT_ADDRESS:" $DAO_CONTRACT_ADDRESS

$BINARY add-wasm-message execute "$DAO_CONTRACT_ADDRESS" "$ADD_SUBDAOS_MSG" --run-as "$DAO_CONTRACT_ADDRESS" --home "$CHAIN_DIR"

sed -i -e 's/\"admins\":.*/\"admins\": [\"'"$DAO_CONTRACT_ADDRESS"'\"]/g' "$CHAIN_DIR/config/genesis.json"
sed -i -e 's/\"treasury_address\":.*/\"treasury_address\":\"'"$TREASURY_CONTRACT_ADDRESS"'\"/g' "$CHAIN_DIR/config/genesis.json"
