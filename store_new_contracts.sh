#!/bin/bash

RES=$(neutrond tx wasm store new_artifacts/neutron_lockdrop.wasm --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id neutron-1 --broadcast-mode block -y)
NEW_LOCKDROP_CODE_ID=$(echo $RES | jq -r '.logs[0].events[1].attributes[1].value')
echo NEW_LOCKDROP_CODE_ID=$NEW_LOCKDROP_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

RES=$(neutrond tx wasm store new_artifacts/lockdrop_vault.wasm --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id neutron-1 --broadcast-mode block -y)
NEW_LOCKDROP_VAULT_CODE_ID=$(echo $RES | jq -r '.logs[0].events[1].attributes[1].value')
echo NEW_LOCKDROP_VAULT_CODE_ID=$NEW_LOCKDROP_VAULT_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

RES=$(neutrond tx wasm store new_artifacts/vesting_lp_vault.wasm --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id neutron-1 --broadcast-mode block -y)
NEW_VESTING_LP_VAULT_CODE_ID=$(echo $RES | jq -r '.logs[0].events[1].attributes[1].value')
echo NEW_VESTING_LP_VAULT_CODE_ID=$NEW_VESTING_LP_VAULT_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

RES=$(neutrond tx wasm store new_artifacts/vesting_lp.wasm --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id neutron-1 --broadcast-mode block -y)
NEW_VESTING_LP_CODE_ID=$(echo $RES | jq -r '.logs[0].events[1].attributes[1].value')
echo NEW_VESTING_LP_CODE_ID=$NEW_VESTING_LP_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

RES=$(neutrond tx wasm store new_artifacts/neutron_reserve.wasm --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id neutron-1 --broadcast-mode block -y)
NEW_RESERVE_CODE_ID=$(echo $RES | jq -r '.logs[0].events[1].attributes[1].value')
echo NEW_RESERVE_CODE_ID=$NEW_RESERVE_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3


RES=$(neutrond tx wasm store new_artifacts/vesting_lp_vault_for_cl_pools.wasm --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id neutron-1 --broadcast-mode block -y)
NEW_VESTING_LP_VAULT_CL_CODE_ID=$(echo $RES | jq -r '.logs[0].events[1].attributes[1].value')
echo NEW_VESTING_LP_VAULT_CL_CODE_ID=$NEW_VESTING_LP_VAULT_CL_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

RES=$(neutrond tx wasm store new_artifacts/lockdrop_vault_for_cl_pools.wasm --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id neutron-1 --broadcast-mode block -y)
NEW_LOCKDROP_VAULT_CL_CODE_ID=$(echo $RES | jq -r '.logs[0].events[1].attributes[1].value')
echo NEW_LOCKDROP_VAULT_CL_CODE_ID=$NEW_LOCKDROP_VAULT_CL_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

echo ""
echo NEW_LOCKDROP_CODE_ID=$NEW_LOCKDROP_CODE_ID
echo NEW_LOCKDROP_VAULT_CODE_ID=$NEW_LOCKDROP_VAULT_CODE_ID
echo NEW_VESTING_LP_VAULT_CODE_ID=$NEW_VESTING_LP_VAULT_CODE_ID
echo NEW_VESTING_LP_CODE_ID=$NEW_VESTING_LP_CODE_ID
echo NEW_RESERVE_CODE_ID=$NEW_RESERVE_CODE_ID
echo NEW_VESTING_LP_VAULT_CL_CODE_ID=$NEW_VESTING_LP_VAULT_CL_CODE_ID
echo NEW_LOCKDROP_VAULT_CL_CODE_ID=$NEW_LOCKDROP_VAULT_CL_CODE_ID
