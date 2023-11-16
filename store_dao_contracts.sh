#!/bin/bash

NODE=${NODE:-"http://37.27.55.151:26657"}
# store core
RES=$(neutrond tx wasm store new_artifacts/cwd_core.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
DAO_CORE_CODE_ID=$(echo $RES)
echo $DAO_CORE_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

#store pre-propose multiple
RES=$(neutrond tx wasm store new_artifacts/cwd_pre_propose_multiple.wasm  --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
echo $PRE_PROPOSE_MULTIPLE_CODE_ID=$(echo $RES )
echo $PRE_PROPOSE_MULTIPLE_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

#store pre-propose single
RES=$(neutrond tx wasm store new_artifacts/cwd_pre_propose_single.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
PRE_PROPOSE_SINGLE_CODE_ID=$(echo $RES )
echo $PRE_PROPOSE_SINGLE_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

#store pre-propose single overrule
RES=$(neutrond tx wasm store new_artifacts/cwd_pre_propose_overrule.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id test-1 --broadcast-mode async --node $NODE -y)
PRE_PROPOSE_OVERRULE_SINGLE_CODE_ID=$(echo $RES)
echo $PRE_PROPOSE_OVERRULE_SINGLE_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

#store propose multiple
RES=$(neutrond tx wasm store new_artifacts/cwd_proposal_multiple.wasm  --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE  -y)
PROPOSE_MULTIPLE_CODE_ID=$(echo $RES)
echo $PROPOSE_MULTIPLE_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

#store propose single
RES=$(neutrond tx wasm store new_artifacts/cwd_proposal_single.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
PROPOSE_SINGLE_CODE_ID=$(echo $RES)
echo $PROPOSE_SINGLE_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

#store credits vault
RES=$(neutrond tx wasm store new_artifacts/credits_vault.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
CREDITS_VAULT_CODE_ID=$(echo $RES)
echo $CREDITS_VAULT_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

#store investors vault
RES=$(neutrond tx wasm store new_artifacts/investors_vesting_vault.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
INVESTORS_VAULT_CODE_ID=$(echo $RES)
echo $INVESTORS_VAULT_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

#store lockdrop vault
RES=$(neutrond tx wasm store new_artifacts/lockdrop_vault.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
LOCKDROP_VAULT_CODE_ID=$(echo $RES)
echo $LOCKDROP_VAULT_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

#store neutron vault
RES=$(neutrond tx wasm store new_artifacts/neutron_vault.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
NEUTRON_VAULT_CODE_ID=$(echo $RES)
echo $NEUTRON_VAULT_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

#store vesting lp vault
RES=$(neutrond tx wasm store new_artifacts/vesting_lp_vault.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
VESTING_LP_CODE_ID=$(echo $RES)
echo $VESTING_LP_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3

# store distribution
RES=$(neutrond tx wasm store new_artifacts/neutron_distribution.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
DISTIBUTION_CODE_ID=$(echo $RES)
echo $DISTIBUTION_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3
echo ""

# store reserve
RES=$(neutrond tx wasm store new_artifacts/neutron_reserve.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
RESERVE_CODE_ID=$(echo $RES)
echo $RESERVE_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3
echo ""

# store voting registry
RES=$(neutrond tx wasm store new_artifacts/neutron_voting_registry.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
VOTING_REGISTRY_CODE_ID=$(echo $RES)
echo $VOTING_REGISTRY_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3
echo ""

# store subdao core
RES=$(neutrond tx wasm store new_artifacts/cwd_subdao_core.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
SUBDAO_SECURITY_CORE_CODE_ID=$(echo $RES)
echo $SUBDAO_SECURITY_CORE_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3
echo ""

# store pre propose subdao
RES=$(neutrond tx wasm store new_artifacts/cwd_subdao_pre_propose_single.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
SUBDAO_SECURITY_PRE_PROPOSE_CODE_ID=$(echo $RES)
echo $SUBDAO_SECURITY_PRE_PROPOSE_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3
echo ""

# store  propose subdao
RES=$(neutrond tx wasm store new_artifacts/cwd_subdao_proposal_single.wasm --keyring-backend=test --from demowallet1 --gas 5000000 --gas-prices 5untrn --chain-id neutron-1 --broadcast-mode async --node $NODE -y)
SUBDAO_SECURITY_PROPOSE_SINGLE_CODE_ID=$(echo $RES)
echo $SUBDAO_SECURITY_PROPOSE_SINGLE_CODE_ID
echo "^^^^ make sure the code ID is a valid number, otherwise interrupt and investigate"
sleep 3
echo ""


echo DAO_CORE_CODE_ID=512
echo PRE_PROPOSE_MULTIPLE_CODE_ID=513
echo PRE_PROPOSE_SINGLE_CODE_ID=514
echo PRE_PROPOSE_OVERRULE_SINGLE_CODE_ID=515
echo PROPOSE_MULTIPLE_CODE_ID=516
echo PROPOSE_SINGLE_CODE_ID=517
echo CREDITS_VAULT_CODE_ID=518
echo INVESTORS_VAULT_CODE_ID=519
echo LOCKDROP_VAULT_CODE_ID=520
echo NEUTRON_VAULT_CODE_ID=521
echo VESTING_LP_CODE_ID=522
echo DISTIBUTION_CODE_ID=523
echo RESERVE_CODE_ID=524
echo VOTING_REGISTRY_CODE_ID=525


echo SUBDAO_SECURITY_CORE_CODE_ID=526
echo SUBDAO_SECURITY_PRE_PROPOSE_CODE_ID=527
echo SUBDAO_SECURITY_PROPOSE_SINGLE_CODE_ID=528

