#!/bin/bash
set -e

# TODO!!!!!!!!
cp genesis.json ./home/config/genesis.json

# TODO!!!!!!!!!
ADMIN_ADDRESS="neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"
MAIN_DAO_ADDRESS="neutron1yyca08xqdgvjz0psg56z67ejh9xms6l436u8y58m82npdqqhmmtqxfjftn"
RESERVE_CONTRACT_ADDRESS="neutron1qyygux5t4s3a3l25k8psxjydhtudu5lnt0tk0szm8q4s27xa980s27p0kg"
ASTROPORT_MULTISIG_ADDRESS="neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"
MANAGER="neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"

NEUTRON_VOTING_REGISTRY_CONTRACT_ADDRESS="neutron1aaf9r6s7nxhysuegqrxv0wpm27ypyv4886medd3mrkrw6t4yfcnsu2zdzj"

#UTC+3
#CHAIN START = 14:00
#CALL = 15:00

CHAIN_START=1681127592

# ------------------------------------------------CONTRACT INIT PARAMS-------------------------------------------------
let LOCKDROP_INIT_TIMESTAMP="$CHAIN_START + 2 * 60 * 60"
LOCKDROP_LOCK_WINDOW=1800 # 0.5 hours
LOCKDROP_WITHDRAWAL_WINDOW=1800 # 0.5 hours
LOCKDROP_MIN_LOCK_DURATION=600  # 10 minutes
LOCKDROP_MAX_LOCK_DURATION=3600 # 1 hour
LOCKDROP_MAX_POSITIONS_PER_USER=1000
LOCKDROP_NTRN_INCENTIVES=20000000000000untrn

AUCTION_LP_TOKENS_LOCK_WINDOW=3600 #1 hour: LOCKDROP_LOCK_WINDOW + LOCKDROP_WITHDRAWAL_WINDOW
let AUCTION_INIT_TIMESTAMP="$CHAIN_START + 60 * 60"
AUCTION_DEPOSIT_WINDOW=1800 #0.5 hour
AUCTION_WITHDRAWAL_WINDOW=1800 #0.5 hour
AUCTION_MAX_EXCHANGE_RATE_AGE=3600 #1 hour
AUCTION_MIN_NTRN_AMOUNT="1"
AUCTION_VESTING_MIGRATION_PACK_SIZE=100
AUCTION_VESTING_LP_DURATION=1800 #0.5 hours
AUCTION_AMOUNT=50000000000000untrn

let CREDITS_WHEN_WITHDRAWABLE="$CHAIN_START + 2 * 60 * 60"
let ASTROPORT_VESTING_START="$CHAIN_START + 2 * 60 * 60"
GENERATOR_NTRN_INCENTIVES=100000000untrn

AIRDROP_MERKLE_ROOT="57f823441a91c4e1e0ee9c1dadaa8cc146688496175ef886b81e76415beab77a" # all addresses from initial genesis
AIRDROP_START="${CHAIN_START}"
let AIRDROP_VESTING_START="$CHAIN_START + 60 * 60"
AIRDROP_DURATION_SECONDS=10800 #1 hour
AIRDROP_AMOUNT=70000000000000untrn

PRICE_FEED_CLIENT_ID="cw-band-price-feed"
PRICE_FEED_ORACLE_SCRIPT_ID="3"
PRICE_FEED_ASK_COUNT="1"
PRICE_FEED_MIN_COUNT="1"
PRICE_FEED_FEE_LIMIT='[{"amount":"100000","denom":"uband"}]'
PRICE_FEED_PREPARE_GAS="100000"
PRICE_FEED_EXECUTE_GAS="500000"
PRICE_FEED_MULTIPLIER="1000000"
PRICE_FEED_SYMBOLS='["ATOM", "USDC"]'

TWAP_UPDATE_PERIOD=60 #seconds
#----------------------------------------------------------------------------------------------------------------------


BINARY=${BINARY:-neutrond}
CHAINID=${CHAINID:-neutron-test-1}
STAKEDENOM=${STAKEDENOM:-untrn}
TGE_CONTRACTS_BINARIES_DIR=${TGE_CONTRACTS_BINARIES_DIR:-./artifacts}
DAO_CONTRACTS_BINARIES_DIR=${DAO_CONTRACTS_BINARIES_DIR:-./artifacts}
ASTROPORT_CONTRACTS_BINARIES_DIR=${ASTROPORT_CONTRACTS_BINARIES_DIR:-./artifacts} # TODO
GENESIS_PATH=${GENESIS_PATH:-./genesis.json}

INSTANCE_ID_COUNTER=25


# https://github.com/neutron-org/neutron-tge-contracts
LOCKDROP_BINARY=$TGE_CONTRACTS_BINARIES_DIR/neutron_lockdrop.wasm
AUCTION_BINARY=$TGE_CONTRACTS_BINARIES_DIR/neutron_auction.wasm
CREDITS_BINARY=$TGE_CONTRACTS_BINARIES_DIR/credits.wasm
AIRDROP_BINARY=$TGE_CONTRACTS_BINARIES_DIR/cw20_merkle_airdrop.wasm
PRICE_FEED_BINARY=$TGE_CONTRACTS_BINARIES_DIR/neutron_price_feed.wasm
TWAP_ORACLE_BINARY=$TGE_CONTRACTS_BINARIES_DIR/astroport_oracle.wasm
LP_VESTING_BINARY=$TGE_CONTRACTS_BINARIES_DIR/vesting_lp.wasm

#https://github.com/neutron-org/neutron-dao
CREDITS_VAULT_BINARY=$DAO_CONTRACTS_BINARIES_DIR/credits_vault.wasm
LOCKDROP_VAULT_BINARY=$DAO_CONTRACTS_BINARIES_DIR/lockdrop_vault.wasm

# https://github.com/astroport-fi/astroport_ibc v1.1.0
ASTROPORT_SATELLITE_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astro_satellite.wasm
#https://github.com/astroport-fi/astroport-core v2.5.0
ASTROPORT_VESTING_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_vesting.wasm
ASTROPORT_WHITELIST_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_whitelist.wasm
ASTROPORT_GENERATOR_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_generator.wasm
ASTROPORT_FACTORY_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_factory.wasm
ASTROPORT_PAIR_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_pair.wasm
ASTROPORT_TOKEN_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_token.wasm
ASTROPORT_NATIVE_COIN_REGISTRY_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_native_coin_registry.wasm

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
ASTROPORT_VESTING_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_VESTING_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_WHITELIST_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_WHITELIST_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_GENERATOR_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_GENERATOR_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_FACTORY_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_FACTORY_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_NATIVE_COIN_REGISTRY_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_PAIR_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_PAIR_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_TOKEN_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_TOKEN_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")

# Contracts addresses pregeneration
# ORDER IS IMPORTANT HERE
ASTROPORT_SATELLITE_CONTRACT_ADDRESS=$(generate_contract_address $ASTROPORT_SATELLITE_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
ASTROPORT_VESTING_CONTRACT_ADDRESS=$(generate_contract_address $ASTROPORT_VESTING_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
ASTROPORT_GENERATOR_CONTRACT_ADDRESS=$(generate_contract_address $ASTROPORT_GENERATOR_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
ASTROPORT_WHITELIST_CONTRACT_ADDRESS=$(generate_contract_address $ASTROPORT_WHITELIST_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
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
  "timeout": 1000
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

ASTROPORT_VESTING_INIT_MSG='{
  "owner": "'"${ASTROPORT_MULTISIG_ADDRESS}"'",
  "vesting_token": {
    "native_token": {
      "denom": "untrn"
    }
  }
}'

ASTROPORT_ADD_VESTING_ACCOUNTS_MSG='{
  "register_vesting_accounts": {
    "vesting_accounts": [
      {
        "address": "'"$ASTROPORT_MULTISIG_ADDRESS"'",
        "schedules": [
          {
            "start_point": {
              "time": '"$ASTROPORT_VESTING_START"',
              "amount": "100000000"
            }
          }
        ]
      }
    ]
  }
}'

ASTROPORT_GENERATOR_INIT_MSG='{
  "astro_token": {
    "native_token": {
      "denom": "untrn"
    }
  },
  "factory": "'"$ASTROPORT_FACTORY_CONTRACT_ADDRESS"'",
  "owner": "'"${ASTROPORT_SATELLITE_CONTRACT_ADDRESS}"'",
  "start_block": "1",
  "tokens_per_block": "100",
  "vesting_contract": "'"$ASTROPORT_VESTING_CONTRACT_ADDRESS"'",
  "whitelist_code_id": '"$ASTROPORT_WHITELIST_CONTRACT_BINARY_ID"'
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
      "is_generator_disabled": false
    }
  ],
  "token_code_id": '"${ASTROPORT_TOKEN_CONTRACT_BINARY_ID}"',
  "generator_address": "'"$ASTROPORT_GENERATOR_CONTRACT_ADDRESS"'",
  "owner": "'"${ASTROPORT_SATELLITE_CONTRACT_ADDRESS}"'",
  "whitelist_code_id": '"$ASTROPORT_WHITELIST_CONTRACT_BINARY_ID"',
  "coin_registry_address": "'"${ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_ADDRESS}"'"
}'

# Instantiate Astroport contracts
## Init satellite contract
instantiate_contract $ASTROPORT_SATELLITE_CONTRACT_BINARY_ID "$ASTROPORT_SATELLITE_INIT_MSG" "ASTROPORT_SATELLITE" "$ASTROPORT_MULTISIG_ADDRESS"
## Init vesting contract and add vesting schedule
instantiate_contract $ASTROPORT_VESTING_CONTRACT_BINARY_ID "$ASTROPORT_VESTING_INIT_MSG" "ASTROPORT_VESTING" "$ASTROPORT_MULTISIG_ADDRESS"
$BINARY add-wasm-message execute "$ASTROPORT_VESTING_CONTRACT_ADDRESS" "$ASTROPORT_ADD_VESTING_ACCOUNTS_MSG" --run-as "$ASTROPORT_MULTISIG_ADDRESS" --amount $GENERATOR_NTRN_INCENTIVES --home ./home
## Init generator contract
instantiate_contract $ASTROPORT_GENERATOR_CONTRACT_BINARY_ID "$ASTROPORT_GENERATOR_INIT_MSG" "ASTROPORT_GENERATOR" "$ASTROPORT_MULTISIG_ADDRESS"
## Init native coin registry contract and set untrn precision
instantiate_contract $ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_BINARY_ID "$ASTROPORT_NATIVE_COIN_REGISTRY_INIT_MSG" "ASTROPORT_NATIVE_COIN_REGISTRY" "$ASTROPORT_SATELLITE_CONTRACT_ADDRESS"
execute_contract $ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_ADDRESS "$SET_UNTRN_PRECISION_MSG" "$ASTROPORT_SATELLITE_CONTRACT_ADDRESS"
## Init factory contract
instantiate_contract $ASTROPORT_FACTORY_CONTRACT_BINARY_ID "$ASTROPORT_FACTORY_INIT_MSG" "ASTROPORT_FACTORY" "$ASTROPORT_SATELLITE_CONTRACT_ADDRESS"

LOCKDROP_LOCKUP_REWARDS_INFO='[
  {"duration": '$LOCKDROP_MIN_LOCK_DURATION', "coefficient": "0"},
  {"duration": 700, "coefficient": "0.25"},
  {"duration": 1000, "coefficient": "0.5"},
  {"duration": 1500, "coefficient": "1"},
  {"duration": 2000, "coefficient": "2"},
  {"duration": 2500, "coefficient": "4"},
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

AUCTION_INIT_MSG='{
  "owner": "'"$MAIN_DAO_ADDRESS"'",
  "token_info_manager": "'"$MANAGER"'",
  "lockdrop_contract_address": "'"$LOCKDROP_CONTRACT_ADDRESS"'",
  "reserve_contract_address": "'"$RESERVE_CONTRACT_ADDRESS"'",
  "vesting_usdc_contract_address": "'"$USDC_LP_VESTING_CONTRACT_ADDRESS"'",
  "vesting_atom_contract_address": "'"$ATOM_LP_VESTING_CONTRACT_ADDRESS"'",
  "price_feed_contract": "'"$PRICE_FEED_CONTRACT_ADDRESS"'",
  "lp_tokens_lock_window": '$AUCTION_LP_TOKENS_LOCK_WINDOW',
  "init_timestamp": '$AUCTION_INIT_TIMESTAMP',
  "deposit_window": '$AUCTION_DEPOSIT_WINDOW',
  "withdrawal_window": '$AUCTION_WITHDRAWAL_WINDOW',
  "max_exchange_rate_age": '$AUCTION_MAX_EXCHANGE_RATE_AGE',
  "min_ntrn_amount": "'"$AUCTION_MIN_NTRN_AMOUNT"'",
  "vesting_migration_pack_size": '$AUCTION_VESTING_MIGRATION_PACK_SIZE',
  "vesting_lp_duration": '$AUCTION_VESTING_LP_DURATION'
}'

CREDITS_INIT_MSG='{
  "dao_address": "'"$MAIN_DAO_ADDRESS"'"
}'

CREDITS_UPDATE_CONFIG_MSG='{
  "update_config": {
    "config": {
      "airdrop_address": "'"$AIDROP_CONTRACT_ADDRESS"'",
      "lockdrop_address": "'"$LOCKDROP_CONTRACT_ADDRESS"'",
      "when_withdrawable": '$CREDITS_WHEN_WITHDRAWABLE'
    }
  }
}'

AIRDROP_INIT_MSG='{
  "credits_address": "'"$CREDITS_CONTRACT_ADDRESS"'",
  "reserve_address": "'"$RESERVE_CONTRACT_ADDRESS"'",
  "merkle_root": "'"$AIRDROP_MERKLE_ROOT"'",
  "airdrop_start": '$AIRDROP_START',
  "vesting_start": '$AIRDROP_VESTING_START',
  "vesting_duration_seconds": '$AIRDROP_DURATION_SECONDS'
}'

PRICE_FEED_INIT_MSG='{
      "client_id": "'"$PRICE_FEED_CLIENT_ID"'",
      "oracle_script_id": "'"$PRICE_FEED_ORACLE_SCRIPT_ID"'",
      "ask_count": "'"$PRICE_FEED_ASK_COUNT"'",
      "min_count": "'"$PRICE_FEED_MIN_COUNT"'",
      "fee_limit": '$PRICE_FEED_FEE_LIMIT',
      "prepare_gas": "'"$PRICE_FEED_PREPARE_GAS"'",
      "execute_gas": "'"$PRICE_FEED_EXECUTE_GAS"'",
      "multiplier": "'"$PRICE_FEED_MULTIPLIER"'",
      "symbols": '$PRICE_FEED_SYMBOLS'
}'

USDC_TWAP_INIT_MSG='{
  "factory_contract": "'"$ASTROPORT_FACTORY_CONTRACT_ADDRESS"'",
  "period": '$TWAP_UPDATE_PERIOD',
  "manager": "'"$MANAGER"'"
}'
ATOM_TWAP_INIT_MSG='{
  "factory_contract": "'"$ASTROPORT_FACTORY_CONTRACT_ADDRESS"'",
  "period": '$TWAP_UPDATE_PERIOD',
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

#TODO: TWO ORACLES
LOCKDROP_VAULT_INIT_MSG='{
  "lockdrop_contract": "'"$LOCKDROP_CONTRACT_ADDRESS"'",
  "oracle_contract": "'"$USDC_TWAP_CONTRACT_ADDRESS"'",
  "description": "Lockdrop Contract Vault",
  "owner": {"address": {"addr": "'"$MAIN_DAO_ADDRESS"'"}},
  "manager": "'"$MANAGER"'",
  "name": "Lockdrop Vault"
}'

ADD_CREDITS_VAULT_MSG='{
  "add_voting_vault": {
    "new_voting_vault_contract": "'"$CREDITS_VAULT_CONTRACT_ADDRESS"'"
  }
}'
ADD_LOCKDROP_VAULT_MSG='{
  "add_voting_vault": {
    "new_voting_vault_contract": "'"$LOCKDROP_VAULT_CONTRACT_ADDRESS"'"
  }
}'

#Top up aidrop contract with some NTRNs
$BINARY add-genesis-account $AIDROP_CONTRACT_ADDRESS $AIRDROP_AMOUNT --home home
#Top up auction contract with some NTRNs
$BINARY add-genesis-account $AUCTION_CONTRACT_ADDRESS $AUCTION_AMOUNT --home home
#Top up lockdrop contract with some NTRNs
$BINARY add-genesis-account $LOCKDROP_CONTRACT_ADDRESS $LOCKDROP_NTRN_INCENTIVES --home home

# Instantiate TGE contracts
instantiate_contract $LOCKDROP_CONTRACT_BINARY_ID "$LOCKDROP_INIT_MSG" "TGE_NEUTRON_LOCKDROP" "$MAIN_DAO_ADDRESS"
$BINARY add-wasm-message execute "$LOCKDROP_CONTRACT_ADDRESS" '{"increase_ntrn_incentives": {}}' --run-as "$LOCKDROP_CONTRACT_ADDRESS" --amount $LOCKDROP_NTRN_INCENTIVES --home ./home
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

# Add Lockdrop and Credits vault to Neutron DAO Voting Registry
#execute_contract "$NEUTRON_VOTING_REGISTRY_CONTRACT_ADDRESS" "$ADD_CREDITS_VAULT_MSG" "$MAIN_DAO_ADDRESS"
#execute_contract "$NEUTRON_VOTING_REGISTRY_CONTRACT_ADDRESS" "$ADD_LOCKDROP_VAULT_MSG" "$MAIN_DAO_ADDRESS"

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
echo "ASTROPORT_GENERATOR_CONTRACT_ADDRESS:" $ASTROPORT_GENERATOR_CONTRACT_ADDRESS