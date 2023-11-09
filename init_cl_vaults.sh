#!/bin/bash

NEUTRON_DAO_ADDRESS=neutron1suhgf5svhu4usrurvxzlgn54ksxmn8gljarjtxqnapv8kjnp4nrstdxvff
LOCKDROP_CONTRACT_ADDRESS=neutron1ryhxe5fzczelcfmrhmcw9x2jsqy677fw59fsctr09srk24lt93eszwlvyj
USDC_LP_VESTING_CONTRACT_ADDRESS=neutron1wgzzn83hhcc5asrtslqvaw2wuqqkfulgac7ze94dmqkrxu8nsensmy9dkv
ATOM_LP_VESTING_CONTRACT_ADDRESS=neutron1kkwp7pd4ts6gukm3e820kyftz4vv5jqtmal8pwqezrnq2ddycqasr87x9p
ATOM_CL_POOL_ADDRESS=neutron1awv05macyxcf2flhaggmjxnyyz76qfaa3jeueheqd0c5ltzmty7s74yjn0
USDC_CL_POOL_ADDRESS=neutron1fqxx5ef3u9ekfd5z8rrut0chsr035ska596htzsgn7lmshwly89sk9vwxc


# LOCKDROP

NEW_LOCKDROP_VAULT_CL_CODE_ID=460
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
    --admin $NEUTRON_DAO_ADDRESS --keyring-backend=test --from=demowallet1 --chain-id=neutron-1 \
    --gas 2000000 --gas-prices 0.025untrn --label "lockdrop_vault_cl" --output json --broadcast-mode block -y)

LOCKDROP_VAULT_CL_CONTRACT_ADDRESS=$(echo $RES | jq -r '.logs[0].events[0].attributes[0].value')
echo LOCKDROP_VAULT_CL_CONTRACT_ADDRESS=$LOCKDROP_VAULT_CL_CONTRACT_ADDRESS

# VESTING LP

NEW_VESTING_LP_VAULT_CL_CODE_ID=459
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
    --admin $NEUTRON_DAO_ADDRESS --keyring-backend=test --from=demowallet1 --chain-id=neutron-1 \
    --gas 2000000 --gas-prices 0.025untrn --label "vesting_lp_vault_cl" --output json --broadcast-mode block -y)

LP_VESTING_VAULT_CL_CONTRACT_ADDRESS=$(echo $RES | jq -r '.logs[0].events[0].attributes[0].value')
echo LP_VESTING_VAULT_CL_CONTRACT_ADDRESS=$LP_VESTING_VAULT_CL_CONTRACT_ADDRESS
