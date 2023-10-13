#!/bin/bash

. .env
DEPLOYER_ADDR=$(${BINARY} keys show ${DEPLOYER} --keyring-backend test -a --home ${KEYS_HOME})

# given the contract address on mainnet, gets contract from mainnet, stores it on testnet and returns contract code_id
function store_code() {
  CONTRACT_PATH=$1

  RES=$($BINARY tx wasm store "$CONTRACT_PATH" \
    --gas 5000000 \
    --gas-prices ${GAS_PRICES} \
    --chain-id ${TESTNET_CHAINID} \
    --broadcast-mode=block \
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
    CODE_ID=$(curl $REST/cosmos/tx/v1beta1/txs/$HASH | jq '.tx_response.logs[0].events[1].attributes[1].value')
    CODE_ID_NUM=${CODE_ID//\"/}

    echo $CODE_ID_NUM
}

NEW_MAIN_DAO_CODE_RES=$(store_code "${ARTIFACTS_DIR}/cwd_core.wasm")
NEW_MAIN_DAO_CODE_ID=$(extract_hash "$NEW_MAIN_DAO_CODE_RES")
echo NEW_MAIN_DAO_CODE_ID=$NEW_MAIN_DAO_CODE_ID

NEW_VOTING_REGISTRY_CODE_RES=$(store_code "${ARTIFACTS_DIR}/neutron_voting_registry.wasm")
NEW_VOTING_REGISTRY_CODE_ID=$(extract_hash "$NEW_VOTING_REGISTRY_CODE_RES")
echo NEW_VOTING_REGISTRY_CODE_ID=$NEW_VOTING_REGISTRY_CODE_ID

NEW_SUBDAO_CORE_RES=$(store_code "${ARTIFACTS_DIR}/cwd_subdao_core.wasm")
NEW_SUBDAO_CORE_ID=$(extract_hash "$NEW_SUBDAO_CORE_RES")
echo NEW_SUBDAO_CORE_ID=$NEW_SUBDAO_CORE_ID

NEW_PROPOSAL_SINGLE_CODE_RES=$(store_code "${ARTIFACTS_DIR}/cwd_proposal_single.wasm")
NEW_PROPOSAL_SINGLE_CODE_ID=$(extract_hash "$NEW_PROPOSAL_SINGLE_CODE_RES")
echo NEW_PROPOSAL_SINGLE_CODE_ID=$NEW_PROPOSAL_SINGLE_CODE_ID

NEW_SUBDAO_PROPOSAL_SINGLE_CODE_RES=$(store_code "${ARTIFACTS_DIR}/cwd_proposal_single.wasm")
NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID=$(extract_hash "$NEW_SUBDAO_PROPOSAL_SINGLE_CODE_RES")
echo NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID=$NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID

NEW_PRE_PROPOSE_OVERRULE_CODE_RES=$(store_code "${ARTIFACTS_DIR}/cwd_pre_propose_overrule.wasm")
NEW_PRE_PROPOSE_OVERRULE_CODE_ID=$(extract_hash "$NEW_PRE_PROPOSE_OVERRULE_CODE_RES")
echo NEW_PRE_PROPOSE_OVERRULE_CODE_ID=$NEW_PRE_PROPOSE_OVERRULE_CODE_ID

NEW_PROPOSAL_MULTIPLE_CODE_RES=$(store_code "${ARTIFACTS_DIR}/cwd_proposal_multiple.wasm")
NEW_PROPOSAL_MULTIPLE_CODE_ID=$(extract_hash "$NEW_PROPOSAL_MULTIPLE_CODE_RES")
echo NEW_PROPOSAL_MULTIPLE_CODE_ID=$NEW_PROPOSAL_MULTIPLE_CODE_ID

NEW_SUBDAO_TIMELOCK_SINGLE_CODE_RES=$(store_code "${ARTIFACTS_DIR}/cwd_subdao_timelock_single.wasm")
NEW_SUBDAO_TIMELOCK_SINGLE_CODE_ID=$(extract_hash "$NEW_SUBDAO_TIMELOCK_SINGLE_CODE_RES")
echo NEW_SUBDAO_TIMELOCK_SINGLE_CODE_ID=$NEW_SUBDAO_TIMELOCK_SINGLE_CODE_ID

NEW_SUBDAO_PREPROPOSE_SINGLE_NO_TIMELOCK_CODE_RES=$(store_code "${ARTIFACTS_DIR}/cwd_subdao_pre_propose_single_no_timelock.wasm")
NEW_SUBDAO_PREPROPOSE_SINGLE_NO_TIMELOCK_CODE_ID=$(extract_hash "$NEW_SUBDAO_PREPROPOSE_SINGLE_NO_TIMELOCK_CODE_RES")
echo NEW_SUBDAO_PREPROPOSE_SINGLE_NO_TIMELOCK_CODE_ID=$NEW_SUBDAO_PREPROPOSE_SINGLE_NO_TIMELOCK_CODE_ID


NEW_TGE_VESTING_GRANTS_SUBDAO_CODE_RES=$(store_code "${ARTIFACTS_DIR}/vesting_investors.wasm")
NEW_TGE_VESTING_GRANTS_SUBDAO_CODE_ID=$(extract_hash "$NEW_TGE_VESTING_GRANTS_SUBDAO_CODE_RES")
echo NEW_TGE_VESTING_GRANTS_SUBDAO_CODE_ID=$NEW_TGE_VESTING_GRANTS_SUBDAO_CODE_ID

