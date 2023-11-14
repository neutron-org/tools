#!/bin/bash

RES=$(neutrond tx wasm store new_artifacts/neutron_lockdrop.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id neutron-1 --broadcast-mode block -y)
NEW_LOCKDROP_CODE_ID=$(echo $RES)
echo NEW_LOCKDROP_CODE_ID=$NEW_LOCKDROP_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

RES=$(neutrond tx wasm store new_artifacts/lockdrop_vault.wasm  --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id neutron-1 --broadcast-mode block -y)
NEW_LOCKDROP_VAULT_CODE_ID=$(echo $RES )
echo $NEW_LOCKDROP_VAULT_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3
#
RES=$(neutrond tx wasm store new_artifacts/vesting_lp_vault.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id neutron-1 --broadcast-mode block -y)
NEW_VESTING_LP_VAULT_CODE_ID=$(echo $RES )
echo $NEW_VESTING_LP_VAULT_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3
#
RES=$(neutrond tx wasm store new_artifacts/vesting_lp.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id test-1 --broadcast-mode block -y)
NEW_VESTING_LP_CODE_ID=$(echo $RES)
echo NEW_VESTING_LP_CODE_ID=$NEW_VESTING_LP_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3
#
RES=$(neutrond tx wasm store new_artifacts/neutron_reserve.wasm  --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id neutron-1 --broadcast-mode block -y)
NEW_RESERVE_CODE_ID=$(echo $RES)
echo $NEW_RESERVE_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3
#
#
RES=$(neutrond tx wasm store new_artifacts/vesting_lp_vault_for_cl_pools.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id neutron-1 --broadcast-mode block -y)
NEW_VESTING_LP_VAULT_CL_CODE_ID=$(echo $RES)
echo $NEW_VESTING_LP_VAULT_CL_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

echo run this
RES=$(neutrond tx wasm store new_artifacts/lockdrop_vault_for_cl_pools.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 0.0025untrn --chain-id neutron-1 --broadcast-mode block -y)
NEW_LOCKDROP_VAULT_CL_CODE_ID=$(echo $RES)
echo $NEW_LOCKDROP_VAULT_CL_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

echo ""
echo NEW_LOCKDROP_CODE_ID=466
echo NEW_LOCKDROP_VAULT_CODE_ID=467
echo NEW_VESTING_LP_VAULT_CODE_ID=468
echo NEW_VESTING_LP_CODE_ID=469
echo NEW_RESERVE_CODE_ID=470
echo NEW_VESTING_LP_VAULT_CL_CODE_ID=471
echo NEW_LOCKDROP_VAULT_CL_CODE_ID=472
