#!/bin/bash
set -e

# TODO: proper init msgs

# TODO!!!!!!!!
cp genesis.json home/config/genesis.json

# TODO!!!!!!!!!
ADMIN_ADDRESS="neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"
MAIN_DAO_ADDRESS="neutron1yyca08xqdgvjz0psg56z67ejh9xms6l436u8y58m82npdqqhmmtqxfjftn"
RESERVE_CONTRACT_ADDRESS="neutron1qyygux5t4s3a3l25k8psxjydhtudu5lnt0tk0szm8q4s27xa980s27p0kg"
ASTROPORT_MULTISIG_ADDRESS="neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"
MANAGER="neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"

BINARY=${BINARY:-neutrond}
CHAINID=${CHAINID:-test-1}
STAKEDENOM=${STAKEDENOM:-untrn}
TGE_CONTRACTS_BINARIES_DIR=${TGE_CONTRACTS_BINARIES_DIR:-./artifacts}
DAO_CONTRACTS_BINARIES_DIR=${DAO_CONTRACTS_BINARIES_DIR:-../neutron-dao/artifacts}
ASTROPORT_CONTRACTS_BINARIES_DIR=${ASTROPORT_CONTRACTS_BINARIES_DIR:-./artifacts} # TODO
GENESIS_PATH=${GENESIS_PATH:-./genesis.json}

INSTANCE_ID_COUNTER=25


LOCKDROP_BINARY=$TGE_CONTRACTS_BINARIES_DIR/neutron_lockdrop-aarch64.wasm
AUCTION_BINARY=$TGE_CONTRACTS_BINARIES_DIR/neutron_auction-aarch64.wasm
CREDITS_BINARY=$TGE_CONTRACTS_BINARIES_DIR/credits-aarch64.wasm
AIRDROP_BINARY=$TGE_CONTRACTS_BINARIES_DIR/cw20_merkle_airdrop-aarch64.wasm
PRICE_FEED_BINARY=$TGE_CONTRACTS_BINARIES_DIR/neutron_price_feed-aarch64.wasm
TWAP_ORACLE_BINARY=$TGE_CONTRACTS_BINARIES_DIR/astroport_oracle-aarch64.wasm
LP_VESTING_BINARY=$TGE_CONTRACTS_BINARIES_DIR/vesting_lp-aarch64.wasm

CREDITS_VAULT_BINARY=$DAO_CONTRACTS_BINARIES_DIR/credits_vault-aarch64.wasm
LOCKDROP_VAULT_BINARY=$DAO_CONTRACTS_BINARIES_DIR/lockdrop_vault-aarch64.wasm

ASTROPORT_SATELLITE_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astro_satellite.wasm
ASTROPORT_GENERATOR_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_generator-aarch64.wasm
ASTROPORT_FACTORY_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_factory-aarch64.wasm
ASTROPORT_PAIR_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_pair-aarch64.wasm
ASTROPORT_TOKEN_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_token-aarch64.wasm
ASTROPORT_NATIVE_COIN_REGISTRY_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_native_coin_registry-aarch64.wasm

function store_binary() {
  CONTRACT_BINARY_PATH=$1
  ADMIN=$2
  $BINARY add-wasm-message store "$CONTRACT_BINARY_PATH" --output json --run-as ${ADMIN} --home ./home
  BINARY_ID=$(jq -r "[.app_state.wasm.gen_msgs[] | select(.store_code != null)] | length" "./home/config/genesis.json")
  echo "$BINARY_ID"
}

function generate_contract_address() {
  CODE_ID=$1
  CONTRACT_ADDRESS=$($BINARY debug generate-contract-address $INSTANCE_ID_COUNTER $CODE_ID)
  echo $CONTRACT_ADDRESS
}

function instantiate_contract() {
  CODE_ID=$1
  INIT_MSG=$2
  LABEL=$3
  ADMIN=$4
  $BINARY add-wasm-message instantiate-contract $CODE_ID "$INIT_MSG" --label "$LABEL" --run-as "$ADMIN" --admin "$ADMIN" --home ./home
}

function execute_contract() {
  CONTRACT=$1
  MESSAGE=$2
  SENDER=$3
  $BINARY add-wasm-message execute $CONTRACT "$MESSAGE" --run-as "$SENDER" --home ./home
}

echo "Initializing dao contract in genesis..."

# Uploading contracts
LOCKDROP_CONTRACT_BINARY_ID=$(store_binary "$LOCKDROP_BINARY" "$MAIN_DAO_ADDRESS")
AUCTION_CONTRACT_BINARY_ID=$(store_binary "$AUCTION_BINARY" "$MAIN_DAO_ADDRESS")
CREDITS_CONTRACT_BINARY_ID=$(store_binary "$CREDITS_BINARY" "$MAIN_DAO_ADDRESS")
AIDROP_CONTRACT_BINARY_ID=$(store_binary "$AIRDROP_BINARY" "$MAIN_DAO_ADDRESS")
PRICE_FEED_CONTRACT_BINARY_ID=$(store_binary "$PRICE_FEED_BINARY" "$MAIN_DAO_ADDRESS")
TWAP_ORACLE_CONTRACT_BINARY_ID=$(store_binary "$TWAP_ORACLE_BINARY" "$MAIN_DAO_ADDRESS")
LP_VESTING_CONTRACT_BINARY_ID=$(store_binary "$LP_VESTING_BINARY" "$MAIN_DAO_ADDRESS")
CREDITS_VAULT_CONTRACT_BINARY_ID=$(store_binary "$CREDITS_VAULT_BINARY" "$MAIN_DAO_ADDRESS")
LOCKDROP_VAULT_CONTRACT_BINARY_ID=$(store_binary "$LOCKDROP_VAULT_BINARY" "$MAIN_DAO_ADDRESS")

ASTROPORT_SATELLITE_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_SATELLITE_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_GENERATOR_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_GENERATOR_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_FACTORY_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_FACTORY_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_NATIVE_COIN_REGISTRY_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_PAIR_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_PAIR_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_TOKEN_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_TOKEN_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")

# Contracts addresses pregeneration
# ORDER IS IMPORTANT HERE
ASTROPORT_SATELLITE_CONTRACT_ADDRESS=$(generate_contract_address $ASTROPORT_SATELLITE_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_ADDRESS=$(generate_contract_address $ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
ASTROPORT_FACTORY_CONTRACT_ADDRESS=$(generate_contract_address $ASTROPORT_FACTORY_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))

LOCKDROP_CONTRACT_ADDRESS=$(generate_contract_address $LOCKDROP_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
AUCTION_CONTRACT_ADDRESS=$(generate_contract_address $AUCTION_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
CREDITS_CONTRACT_ADDRESS=$(generate_contract_address $CREDITS_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
AIDROP_CONTRACT_ADDRESS=$(generate_contract_address $AIDROP_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
PRICE_FEED_CONTRACT_ADDRESS=$(generate_contract_address $PRICE_FEED_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
USDC_TWAP_CONTRACT_ADDRESS=$(generate_contract_address $TWAP_ORACLE_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
ATOM_TWAP_CONTRACT_ADDRESS=$(generate_contract_address $TWAP_ORACLE_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
USDC_LP_VESTING_CONTRACT_ADDRESS=$(generate_contract_address $LP_VESTING_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
ATOM_LP_VESTING_CONTRACT_ADDRESS=$(generate_contract_address $LP_VESTING_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
CREDITS_VAULT_CONTRACT_ADDRESS=$(generate_contract_address $CREDITS_VAULT_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
LOCKDROP_VAULT_CONTRACT_ADDRESS=$(generate_contract_address $LOCKDROP_VAULT_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))

ASTROPORT_SATELLITE_INIT_MSG='{
  "owner": "'"$ASTROPORT_MULTISIG_ADDRESS"'",
  "astro_denom": "TODO",
  "transfer_channel": "TODO",
  "main_controller": "TODO",
  "main_maker": "TODO",
  "timeout": 100
}'

ASTROPORT_NATIVE_COIN_REGISTRY_INIT_MSG='{
  "owner": "'"${ASTROPORT_SATELLITE_CONTRACT_ADDRESS}"'"
}'
SET_UNTRN_PRECISION_MSG='{
  "add": {
    "native_coins": [
      [
        "untrn",
        6
      ]
    ]
  }
}'


ASTROPORT_FACTORY_INIT_MSG='{
  "pair_configs": [
    {
      "code_id": '"${ASTROPORT_PAIR_CONTRACT_BINARY_ID}"',
      "pair_type": {
        "xyk": {}
      },
      "total_fee_bps": 0,
      "maker_fee_bps": 0,
      "is_disabled": false,
      "is_generator_disabled": true
    }
  ],
  "token_code_id": '"${ASTROPORT_TOKEN_CONTRACT_BINARY_ID}"',
  "owner": "'"${ASTROPORT_SATELLITE_CONTRACT_ADDRESS}"'",
  "whitelist_code_id": 0,
  "coin_registry_address": "'"${ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_ADDRESS}"'"
}'

# Instantiate Astroport contracts
instantiate_contract $ASTROPORT_SATELLITE_CONTRACT_BINARY_ID "$ASTROPORT_SATELLITE_INIT_MSG" "ASTROPORT_SATELLITE" "$ASTROPORT_MULTISIG_ADDRESS"
instantiate_contract $ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_BINARY_ID "$ASTROPORT_NATIVE_COIN_REGISTRY_INIT_MSG" "ASTROPORT_NATIVE_COIN_REGISTRY" "$ASTROPORT_SATELLITE_CONTRACT_ADDRESS"
execute_contract $ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_ADDRESS "$SET_UNTRN_PRECISION_MSG" "$ASTROPORT_SATELLITE_CONTRACT_ADDRESS"
instantiate_contract $ASTROPORT_FACTORY_CONTRACT_BINARY_ID "$ASTROPORT_FACTORY_INIT_MSG" "ASTROPORT_FACTORY" "$ASTROPORT_SATELLITE_CONTRACT_ADDRESS"

LOCKDROP_INIT_TIMESTAMP=16806933370
LOCKDROP_LOCK_WINDOW=123
LOCKDROP_WITHDRAWAL_WINDOW=100
LOCKDROP_MIN_LOCK_DURATION=7889400
LOCKDROP_MAX_LOCK_DURATION=31557600
LOCKDROP_MAX_POSITIONS_PER_USER=1000
LOCKDROP_LOCKUP_REWARDS_INFO='[
  {"duration": '$LOCKDROP_MIN_LOCK_DURATION', "coefficient": "0"},
  {"duration": 11834100, "coefficient": "0.25"},
  {"duration": 15778800, "coefficient": "0.5"},
  {"duration": 19723500, "coefficient": "1"},
  {"duration": 23668200, "coefficient": "2"},
  {"duration": 27612900, "coefficient": "4"},
  {"duration": '$LOCKDROP_MAX_LOCK_DURATION', "coefficient": "8"}
]'

LOCKDROP_INIT_MSG='{
  "owner": "'"$MAIN_DAO_ADDRESS"'",
  "token_info_manager": "'"$MANAGER"'",
  "credits_contract": "'"$CREDITS_CONTRACT_ADDRESS"'",
  "auction_contract": "'"$AUCTION_CONTRACT_ADDRESS"'",
  "init_timestamp": '$LOCKDROP_INIT_TIMESTAMP',
  "lock_window": '$LOCKDROP_LOCK_WINDOW',
  "withdrawal_window": '$LOCKDROP_WITHDRAWAL_WINDOW',
  "min_lock_duration": '$LOCKDROP_MIN_LOCK_DURATION',
  "max_lock_duration": '$LOCKDROP_MAX_LOCK_DURATION',
  "max_positions_per_user": '$LOCKDROP_MAX_POSITIONS_PER_USER',
  "lockup_rewards_info": '$LOCKDROP_LOCKUP_REWARDS_INFO'
}'

#TODO
AUCTION_INIT_MSG='{
  "owner": "'"$MAIN_DAO_ADDRESS"'",
  "denom_manager": "'"$MANAGER"'",
  "lockdrop_contract_address": "'"$LOCKDROP_CONTRACT_ADDRESS"'",
  "reserve_contract_address": "'"$RESERVE_CONTRACT_ADDRESS"'",
  "vesting_usdc_contract_address": "'"$USDC_LP_VESTING_CONTRACT_ADDRESS"'",
  "vesting_atom_contract_address": "'"$ATOM_LP_VESTING_CONTRACT_ADDRESS"'",
  "price_feed_contract": "'"$PRICE_FEED_CONTRACT_ADDRESS"'",
  "lp_tokens_lock_window": 100,
  "init_timestamp": 16806933370,
  "deposit_window": 100,
  "withdrawal_window": 100,
  "max_exchange_rate_age": 111,
  "min_ntrn_amount": "1000",
  "vesting_migration_pack_size": 100,
  "vesting_lp_duration": 1000
}'

CREDITS_INIT_MSG='{
  "dao_address": "'"$MAIN_DAO_ADDRESS"'"
}'
WHEN_WITHDRAWABLE=1000 #TODO
CREDITS_UPDATE_CONFIG_MSG='{
  "update_config": {
    "config": {
      "airdrop_address": "'"$AIDROP_CONTRACT_ADDRESS"'",
      "lockdrop_address": "'"$LOCKDROP_CONTRACT_ADDRESS"'",
      "when_withdrawable": "'"$WHEN_WITHDRAWABLE"'"
    }
  }
}'

#TODO
AIRDROP_INIT_MSG='{
  "credits_address": "'"$CREDITS_CONTRACT_ADDRESS"'",
  "reserve_address": "'"$RESERVE_CONTRACT_ADDRESS"'",
  "merkle_root": "634de21cde1044f41d90373733b0f0fb1c1c71f9652b905cdf159e73c4cf0d37",
  "airdrop_start": "9749243947",
  "vesting_start": "24242342422",
  "vesting_duration_seconds": 131
}'

#TODO
PRICE_FEED_INIT_MSG='{
      "client_id": "client-01",
      "oracle_script_id": "100",
      "ask_count": "123",
      "min_count": "31432",
      "fee_limit": [],
      "prepare_gas": "31",
      "execute_gas": "122",
      "multiplier": "12312",
      "symbols": []
}'

USDC_TWAP_INIT_MSG='{
  "factory_contract": "'"$ASTROPORT_FACTORY_CONTRACT_ADDRESS"'",
  "period": 86400,
  "manager": "'"$MANAGER"'"
}'
ATOM_TWAP_INIT_MSG='{
  "factory_contract": "'"$ASTROPORT_FACTORY_CONTRACT_ADDRESS"'",
  "period": 86400,
  "manager": "'"$MANAGER"'"
}'

USDC_LP_VESTING_INIT_MSG='{
  "owner": "'"$MAIN_DAO_ADDRESS"'",
  "token_info_manager": "'"$MANAGER"'",
  "vesting_managers": ["'"$MANAGER"'"]
}'
ATOM_LP_VESTING_INIT_MSG='{
  "owner": "'"$MAIN_DAO_ADDRESS"'",
  "token_info_manager": "'"$MANAGER"'",
  "vesting_managers": ["'"$MANAGER"'"]
}'

CREDITS_VAULT_INIT_MSG='{
  "credits_contract_address": "'"$CREDITS_CONTRACT_ADDRESS"'",
  "description": "Credits Contract Vault",
  "owner": {"address": {"addr": "'"$MAIN_DAO_ADDRESS"'"}},
  "manager": "'"$MANAGER"'"
}'

LOCKDROP_VAULT_INIT_MSG='{
  "lockdrop_contract": "'"$LOCKDROP_CONTRACT_ADDRESS"'",
  "description": "Lockdrop Contract Vault",
  "owner": {"address": {"addr": "'"$MAIN_DAO_ADDRESS"'"}},
  "manager": "'"$MANAGER"'",
  "name": "Lockdrop Vault"
}'

# TODO
# Top up lockdrop with NTRN rewards
# top up auction with NTRN rewards

# Instantiate TGE contracts
instantiate_contract $LOCKDROP_CONTRACT_BINARY_ID "$LOCKDROP_INIT_MSG" "TGE_NEUTRON_LOCKDROP" "$MAIN_DAO_ADDRESS"
instantiate_contract $AUCTION_CONTRACT_BINARY_ID "$AUCTION_INIT_MSG" "TGE_NEUTRON_AUCTION" "$MAIN_DAO_ADDRESS"
instantiate_contract $CREDITS_CONTRACT_BINARY_ID "$CREDITS_INIT_MSG" "TGE_NEUTRON_CREDITS" "$MAIN_DAO_ADDRESS"
execute_contract $CREDITS_CONTRACT_ADDRESS "$CREDITS_UPDATE_CONFIG_MSG" "$MAIN_DAO_ADDRESS"
instantiate_contract $AIDROP_CONTRACT_BINARY_ID "$AIRDROP_INIT_MSG" "TGE_NEUTRON_AIRDROP" "$MAIN_DAO_ADDRESS"
instantiate_contract $PRICE_FEED_CONTRACT_BINARY_ID "$PRICE_FEED_INIT_MSG" "TGE_NEUTRON_PRICE_FEED" "$MAIN_DAO_ADDRESS"
instantiate_contract $TWAP_ORACLE_CONTRACT_BINARY_ID "$USDC_TWAP_INIT_MSG" "TGE_USDC_TWAP_ORACLE" "$MAIN_DAO_ADDRESS"
instantiate_contract $TWAP_ORACLE_CONTRACT_BINARY_ID "$ATOM_TWAP_INIT_MSG" "TGE_ATOM_TWAP_ORACLE" "$MAIN_DAO_ADDRESS"
instantiate_contract $LP_VESTING_CONTRACT_BINARY_ID "$USDC_LP_VESTING_INIT_MSG" "TGE_USDC_LP_VESTING" "$MAIN_DAO_ADDRESS"
instantiate_contract $LP_VESTING_CONTRACT_BINARY_ID "$ATOM_LP_VESTING_INIT_MSG" "TGE_ATOM_LP_VESTING" "$MAIN_DAO_ADDRESS"
instantiate_contract $CREDITS_VAULT_CONTRACT_BINARY_ID "$CREDITS_VAULT_INIT_MSG" "TGE_CREDITS_VAULT" "$MAIN_DAO_ADDRESS"
instantiate_contract $LOCKDROP_VAULT_CONTRACT_BINARY_ID "$LOCKDROP_VAULT_INIT_MSG" "TGE_LOCKDROP_VAULT" "$MAIN_DAO_ADDRESS"

echo "LOCKDROP_CONTRACT_ADDRESS:" $LOCKDROP_CONTRACT_ADDRESS
echo "AUCTION_CONTRACT_ADDRESS:" $AUCTION_CONTRACT_ADDRESS
echo "CREDITS_CONTRACT_ADDRESS:" $CREDITS_CONTRACT_ADDRESS
echo "AIDROP_CONTRACT_ADDRESS:" $AIDROP_CONTRACT_ADDRESS
echo "PRICE_FEED_CONTRACT_ADDRESS:" $PRICE_FEED_CONTRACT_ADDRESS
echo "USDC_TWAP_CONTRACT_ADDRESS:" $USDC_TWAP_CONTRACT_ADDRESS
echo "ATOM_TWAP_CONTRACT_ADDRESS:" $ATOM_TWAP_CONTRACT_ADDRESS
echo "USDC_LP_VESTING_CONTRACT_ADDRESS:" $USDC_LP_VESTING_CONTRACT_ADDRESS
echo "ATOM_LP_VESTING_CONTRACT_ADDRESS:" $ATOM_LP_VESTING_CONTRACT_ADDRESS
echo "CREDITS_VAULT_CONTRACT_ADDRESS:" $CREDITS_VAULT_CONTRACT_ADDRESS
echo "LOCKDROP_VAULT_CONTRACT_ADDRESS:" $LOCKDROP_VAULT_CONTRACT_ADDRESS
echo "ASTROPORT_SATELLITE_CONTRACT_ADDRESS:" $ASTROPORT_SATELLITE_CONTRACT_ADDRESS
echo "ASTROPORT_FACTORY_CONTRACT_ADDRESS:" $ASTROPORT_FACTORY_CONTRACT_ADDRESS