#!/bin/bash

NEUTRON_DAO_ADDRESS=neutron1suhgf5svhu4usrurvxzlgn54ksxmn8gljarjtxqnapv8kjnp4nrstdxvff
LOCKDROP_CONTRACT_ADDRESS=neutron1zt8m8ffpdrztjyqj0hmv8wgcz2cv3y4euk474znth4hnsn3vzaes32wtx2
USDC_LP_VESTING_CONTRACT_ADDRESS=neutron1mzr9spaqlxq0pp34r0cahntfp3htpy8dps399aflafqwx2f6235qdhwflr
ATOM_LP_VESTING_CONTRACT_ADDRESS=neutron16y75jj4ftlcjvfa0gscnklzaj20pfe97mczpg2e8a7znyjzzafaq67dj0v
ATOM_CL_POOL_ADDRESS=neutron1wawu0fe6jy2w9ngaf89xs3mwgfsm0fpdtumfls4wx3ltwcp7amqqwdvcm6
USDC_CL_POOL_ADDRESS=neutron1w7qp3uppv9sl8xxnq7cdnn5xje5utz0a482rfafpu5zkf6vltnxslejmvm

# LOCKDROP

NEW_LOCKDROP_VAULT_CL_CODE_ID=50
NEW_LOCKDROP_VAULT_CL_INST_MSG='{
    "name": "Lockdrop CL voting vault",
    "description": "Lockdrop vault for CL pairs",
    "lockdrop_contract": "'"${LOCKDROP_CONTRACT_ADDRESS}"'",
    "usdc_cl_pool_contract": "'"${USDC_CL_POOL_ADDRESS}"'",
    "atom_cl_pool_contract": "'"${ATOM_CL_POOL_ADDRESS}"'",
    "owner": "'"${NEUTRON_DAO_ADDRESS}"'"
}'

echo "Instantiate lockdrop vault"
RES=$(neutrond tx wasm instantiate $NEW_LOCKDROP_VAULT_CL_CODE_ID "$NEW_LOCKDROP_VAULT_CL_INST_MSG" \
    --admin $NEUTRON_DAO_ADDRESS --keyring-backend=test --from=demowallet1 --chain-id=test-1 \
    --gas 2000000 --gas-prices 0.025untrn --label "lockdrop_vault_cl" --output json --broadcast-mode block -y)

LOCKDROP_VAULT_CL_CONTRACT_ADDRESS=$(echo $RES | jq -r '.logs[0].events[0].attributes[0].value')
echo LOCKDROP_VAULT_CL_CONTRACT_ADDRESS=$LOCKDROP_VAULT_CL_CONTRACT_ADDRESS

# VESTING LP

NEW_VESTING_LP_VAULT_CL_CODE_ID=49
NEW_VESTING_LP_VAULT_CL_INST_MSG='{
    "name": "Vesting LP CL voting vault",
    "description": "Vesting LP voting vault for CL pairs",
    "atom_vesting_lp_contract": "'"${ATOM_LP_VESTING_CONTRACT_ADDRESS}"'",
    "atom_cl_pool_contract": "'"${ATOM_CL_POOL_ADDRESS}"'",
    "usdc_vesting_lp_contract": "'"${USDC_LP_VESTING_CONTRACT_ADDRESS}"'",
    "usdc_cl_pool_contract": "'"${USDC_CL_POOL_ADDRESS}"'",
    "owner": "'"${NEUTRON_DAO_ADDRESS}"'"
}'

echo "Instantiate vesting lp vault"
RES=$(neutrond tx wasm instantiate $NEW_VESTING_LP_VAULT_CL_CODE_ID "$NEW_VESTING_LP_VAULT_CL_INST_MSG" \
    --admin $NEUTRON_DAO_ADDRESS --keyring-backend=test --from=demowallet1 --chain-id=test-1 \
    --gas 2000000 --gas-prices 0.025untrn --label "vesting_lp_vault_cl" --output json --broadcast-mode block -y)

LP_VESTING_VAULT_CL_CONTRACT_ADDRESS=$(echo $RES | jq -r '.logs[0].events[0].attributes[0].value')
echo LP_VESTING_VAULT_CL_CONTRACT_ADDRESS=$LP_VESTING_VAULT_CL_CONTRACT_ADDRESS
