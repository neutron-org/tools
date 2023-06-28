#!/bin/bash
set -e

cp genesis.json ./home/config/genesis.json

CONTRACTS_TO_CODE_IDS=${CONTRACTS_TO_CODE_IDS:-"contracts_to_code_ids.txt"}

NEUTRON_DAO_ADDRESS="neutron1suhgf5svhu4usrurvxzlgn54ksxmn8gljarjtxqnapv8kjnp4nrstdxvff"
RESERVE_CONTRACT_ADDRESS="neutron13we0myxwzlpx8l5ark8elw5gj5d59dl6cjkzmt80c5q5cv5rt54qvzkv2a"
ASTROPORT_MULTISIG_ADDRESS="neutron1xle8l3h0wkcp6tsxmkc6n4vqyfkhwnukevwwsk"
TOKEN_INFO_MANAGER_MULTISIG_ADDRESS="neutron1zfw930csx0k5qzf35vndaulwada4wa3pwtg5hy8rmnnx35wdyhssd2rtlz"
TOKEN_ISSUER_MULTISIG_ADDRESS_2="neutron1d9m09dzfvjzep2jaypg9a80zslvr7jhcary57a"
FOUNDATION_MULTISIG_ADDRESS="neutron1cvsh2c2vasktkh7krt2w2dhyt0njs0adh5ewqv"
NEUTRON_VOTING_REGISTRY_CONTRACT_ADDRESS="neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s"

TGE_START_DATE_TS=1687979431  # Wed May 24 2023 10:00:00 GMT+0000
DAY=86400

# ACCOUNTS
# -------------------------------------------
LTI_START_TIMESTAMP=1683712800
LTI_END_TIMESTAMP=1809943200

LTI_ACCOUNT_1="neutron1h8vf3ueml7ah7m8z9e6vx09trq5lv2fw9e049f"
LTI_1_TOTAL=15195600000000
LTI_1_CLIFF=3798900000000

LTI_ACCOUNT_2="neutron1cpy2gpwc8lphzyczderwma2rt5nqdmvtyyl26f"
LTI_2_TOTAL=15000000000000
LTI_2_CLIFF=3750000000000

LTI_ACCOUNT_3="neutron106wvrvf69xvgv68uv9hwez79rqtwlkxpd3qq7z"
LTI_3_TOTAL=7500000000000
LTI_3_CLIFF=1875000000000

LTI_ACCOUNT_4="neutron1tkavhfqt8358vl74z7r5kdkdy05s98yka0gl0t"
LTI_4_TOTAL=7222222000000
LTI_4_CLIFF=1805555000000

LTI_ACCOUNT_5="neutron1f8yzjt9wnpm3499he5g2qya2kx9pdg3rgrc7le"
LTI_5_TOTAL=3444000000000
LTI_5_CLIFF=861000000000

LTI_ACCOUNT_6="neutron1hdga6p84cpc6gulk9ruxy5w0vpfx9dv84f4kly"
LTI_6_TOTAL=3666667000000
LTI_6_CLIFF=916666000000

LTI_ACCOUNT_7="neutron1sr3l95jynze2vamep28lw02ve2rv35x9jeltnx"
LTI_7_TOTAL=3092400000000
LTI_7_CLIFF=773100000000

LTI_ACCOUNT_8="neutron1ruup9zdgtpl5gtylxhffsjxwpgsnjn2e0vct6c"
LTI_8_TOTAL=3166667000000
LTI_8_CLIFF=791666000000

LTI_ACCOUNT_9="neutron1ua9rh0ag6s2syh6246zsxrj8hcysanlfkmgveh"
LTI_9_TOTAL=2205667000000
LTI_9_CLIFF=551416000000

LTI_ACCOUNT_10="neutron1jjglgxh7lq59qfgea8t8t3r394dgkn99jxj697"
LTI_10_TOTAL=1750000000000
LTI_10_CLIFF=437500000000

LTI_ACCOUNT_11="neutron1tkkry2wmcm0dzsh8j44ztjpcaguhwdnqu9u4np"
LTI_11_TOTAL=1696667000000
LTI_11_CLIFF=424166000000

LTI_ACCOUNT_12="neutron148slufu7wlhn9axz38xs0q6frgkm2rkky4qzcq"
LTI_12_TOTAL=1333333000000
LTI_12_CLIFF=333333000000

LTI_ACCOUNT_13="neutron1nl7p99kxxjlsls3ra5xj5yj2datakzr4vfl3dw"
LTI_13_TOTAL=816667000000
LTI_13_CLIFF=204166000000

LTI_ACCOUNT_14="neutron1vehmy5f9w3dt8xad4ct7lsymy6wpxj8gu0kd2s"
LTI_14_TOTAL=1111667000000
LTI_14_CLIFF=277916000000

LTI_ACCOUNT_15="neutron1sv3vaahqjqq0xqunjz476vjgpe0fv2v3xsgpem"
LTI_15_TOTAL=530000000000
LTI_15_CLIFF=132500000000

LTI_ACCOUNT_16="neutron1rs6mnzel03t9rz5rf7hpqkrnz3yw4vlpvtn6gq"
LTI_16_TOTAL=400000000000
LTI_16_CLIFF=100000000000

let LTI_ALLOCATION_TOTAL_AMOUNT="68131557000000"
LTI_ALLOCATION_TOTAL_AMOUNT_U_NTRN=${LTI_ALLOCATION_TOTAL_AMOUNT}untrn

# ------------------------------------------------CONTRACT INIT PARAMS-------------------------------------------------
LOCKDROP_LOCK_WINDOW_SECONDS=3600  # 86400 * 3
LOCKDROP_WITHDRAWAL_WINDOW_SECONDS=3600  # 86400 * 2
LOCKDROP_MIN_LOCK_DURATION_SECONDS=3600  # 86400 * 30 * 3
LOCKDROP_MAX_LOCK_DURATION_SECONDS=7200  # 86400 * 30 * 12
LOCKDROP_MAX_POSITIONS_PER_USER=1000
LOCKDROP_NTRN_INCENTIVES_U_NTRN=10000000000000untrn

AUCTION_DEPOSIT_WINDOW_SECONDS=3600  
AUCTION_WITHDRAWAL_WINDOW_SECONDS=3600  

let AUCTION_LP_TOKENS_LOCK_WINDOW="$LOCKDROP_LOCK_WINDOW_SECONDS + $LOCKDROP_WITHDRAWAL_WINDOW_SECONDS"
let AUCTION_INIT_TIMESTAMP="$TGE_START_DATE_TS"
let LOCKDROP_INIT_TIMESTAMP="$AUCTION_INIT_TIMESTAMP + $AUCTION_DEPOSIT_WINDOW_SECONDS + $AUCTION_WITHDRAWAL_WINDOW_SECONDS"
let LOCKDROP_END="$LOCKDROP_INIT_TIMESTAMP + $LOCKDROP_LOCK_WINDOW_SECONDS + $LOCKDROP_WITHDRAWAL_WINDOW_SECONDS"

AUCTION_MAX_EXCHANGE_RATE_AGE=360 
AUCTION_NTRN_AMOUNT_TO_SELL_U_NTRN="40000000000000"
AUCTION_VESTING_MIGRATION_PACK_SIZE=100
AUCTION_VESTING_LP_DURATION=7200
AUCTION_AMOUNT=40000000000000untrn

let CREDITS_WITHDRAW_START_TS="$LOCKDROP_END"

AIRDROP_MERKLE_ROOT="227ed8cb0d5d20efcaf02b1997725e837b27dc6aa26e86f811298def576ebdaa" # all addresses from initial genesis
let AIRDROP_START="${TGE_START_DATE_TS}"
let AIRDROP_VESTING_START="$LOCKDROP_END"
AIRDROP_DURATION_SECONDS=$((86400 * 30 * 3))
AIRDROP_AMOUNT_U_NTRN=70000000000000

AIRDROP_AMOUNT_U_NTRN=${AIRDROP_AMOUNT_U_NTRN}untrn

PRICE_FEED_CLIENT_ID="cw-band-price-feed"
PRICE_FEED_ORACLE_SCRIPT_ID="3"
PRICE_FEED_ASK_COUNT="16"
PRICE_FEED_MIN_COUNT="10"
PRICE_FEED_FEE_LIMIT='[{"amount":"1000000","denom":"uband"}]'
PRICE_FEED_PREPARE_GAS="1000000"
PRICE_FEED_EXECUTE_GAS="5000000"
PRICE_FEED_MULTIPLIER="1000000"
PRICE_FEED_SYMBOLS='["ATOM", "USDC"]'

TWAP_UPDATE_PERIOD=604800 # seconds, 3600 * 24 * 7


#----------------------------------------------------------------------------------------------------------------------


BINARY=${BINARY:-neutrond}
CHAINID=${CHAINID:-neutron-1}
STAKEDENOM=${STAKEDENOM:-untrn}
TGE_CONTRACTS_BINARIES_DIR=${TGE_CONTRACTS_BINARIES_DIR:-./artifacts}
DAO_CONTRACTS_BINARIES_DIR=${DAO_CONTRACTS_BINARIES_DIR:-./artifacts}
ASTROPORT_CONTRACTS_BINARIES_DIR=${ASTROPORT_CONTRACTS_BINARIES_DIR:-./artifacts} # TODO
GENESIS_PATH=${GENESIS_PATH:-./genesis.json}

INSTANCE_ID_COUNTER=23


# https://github.com/neutron-org/neutron-tge-contracts
LOCKDROP_BINARY=$TGE_CONTRACTS_BINARIES_DIR/neutron_lockdrop.wasm
AUCTION_BINARY=$TGE_CONTRACTS_BINARIES_DIR/neutron_auction.wasm
CREDITS_BINARY=$TGE_CONTRACTS_BINARIES_DIR/credits.wasm
AIRDROP_BINARY=$TGE_CONTRACTS_BINARIES_DIR/cw20_merkle_airdrop.wasm
PRICE_FEED_BINARY=$TGE_CONTRACTS_BINARIES_DIR/neutron_price_feed.wasm
TWAP_ORACLE_BINARY=$TGE_CONTRACTS_BINARIES_DIR/astroport_oracle.wasm
LP_VESTING_BINARY=$TGE_CONTRACTS_BINARIES_DIR/vesting_lp.wasm
VESTING_INVESTORS_BINARY=$TGE_CONTRACTS_BINARIES_DIR/vesting_investors.wasm
VESTING_LTI_BINARY=$TGE_CONTRACTS_BINARIES_DIR/vesting_lti.wasm
INVESTORS_VESTING_VAULT_BINARY=$TGE_CONTRACTS_BINARIES_DIR/investors_vesting_vault.wasm

#https://github.com/neutron-org/neutron-dao
CREDITS_VAULT_BINARY=$DAO_CONTRACTS_BINARIES_DIR/credits_vault.wasm
LOCKDROP_VAULT_BINARY=$DAO_CONTRACTS_BINARIES_DIR/lockdrop_vault.wasm

# https://github.com/astroport-fi/astroport_ibc/releases/tag/v1.1.0
ASTROPORT_SATELLITE_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astro_satellite.wasm
# https://github.com/astroport-fi/astroport-core/releases/tag/v2.8.0
ASTROPORT_GENERATOR_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_generator.wasm
ASTROPORT_FACTORY_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_factory.wasm
ASTROPORT_PAIR_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_pair.wasm
ASTROPORT_PAIR_STABLE_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_pair_stable.wasm
ASTROPORT_TOKEN_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_xastro_token.wasm
ASTROPORT_NATIVE_COIN_REGISTRY_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_native_coin_registry.wasm
ASTROPORT_VESTING_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_vesting.wasm
ASTROPORT_MAKER_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_maker.wasm
ASTROPORT_ROUTER_BINARY=$ASTROPORT_CONTRACTS_BINARIES_DIR/astroport_router.wasm

function store_binary() {
  CONTRACT_BINARY_PATH=$1
  ADMIN=$2
  if [ ! -f $CONTRACT_BINARY_PATH ]; then
    >&2 echo "File $CONTRACT_BINARY_PATH does not exist."
    exit 1
  fi
  $BINARY add-wasm-message store "$CONTRACT_BINARY_PATH" --output json --run-as ${ADMIN} --home ./home
  BINARY_ID=$(jq -r "[.app_state.wasm.gen_msgs[] | select(.store_code != null)] | length" "./home/config/genesis.json")
  CONTRACT_NAME=${CONTRACT_BINARY_PATH##*/}
  echo "$CONTRACT_NAME, $BINARY_ID" >> $CONTRACTS_TO_CODE_IDS
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

function execute_contract_w_funds() {
  CONTRACT=$1
  MESSAGE=$2
  SENDER=$3
  FUNDS=$4
  $BINARY add-wasm-message execute $CONTRACT "$MESSAGE" --amount $FUNDS --run-as "$SENDER" --home ./home
}

echo "Initializing TGE contract in genesis..."

# Uploading contracts
LOCKDROP_CONTRACT_BINARY_ID=$(store_binary "$LOCKDROP_BINARY" "$NEUTRON_DAO_ADDRESS")
AUCTION_CONTRACT_BINARY_ID=$(store_binary "$AUCTION_BINARY" "$NEUTRON_DAO_ADDRESS")
CREDITS_CONTRACT_BINARY_ID=$(store_binary "$CREDITS_BINARY" "$NEUTRON_DAO_ADDRESS")
AIRDROP_CONTRACT_BINARY_ID=$(store_binary "$AIRDROP_BINARY" "$NEUTRON_DAO_ADDRESS")
PRICE_FEED_CONTRACT_BINARY_ID=$(store_binary "$PRICE_FEED_BINARY" "$NEUTRON_DAO_ADDRESS")
TWAP_ORACLE_CONTRACT_BINARY_ID=$(store_binary "$TWAP_ORACLE_BINARY" "$NEUTRON_DAO_ADDRESS")
LP_VESTING_CONTRACT_BINARY_ID=$(store_binary "$LP_VESTING_BINARY" "$NEUTRON_DAO_ADDRESS")
CREDITS_VAULT_CONTRACT_BINARY_ID=$(store_binary "$CREDITS_VAULT_BINARY" "$NEUTRON_DAO_ADDRESS")
LOCKDROP_VAULT_CONTRACT_BINARY_ID=$(store_binary "$LOCKDROP_VAULT_BINARY" "$NEUTRON_DAO_ADDRESS")
VESTING_INVESTORS_CONTRACT_BINARY_ID=$(store_binary "$VESTING_INVESTORS_BINARY" "$TOKEN_ISSUER_MULTISIG_ADDRESS_2")
VESTING_LTI_CONTRACT_BINARY_ID=$(store_binary "$VESTING_LTI_BINARY" "$FOUNDATION_MULTISIG_ADDRESS")
INVESTORS_VESTING_VAULT_BINARY_ID=$(store_binary "$INVESTORS_VESTING_VAULT_BINARY" "$NEUTRON_DAO_ADDRESS")

ASTROPORT_SATELLITE_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_SATELLITE_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_GENERATOR_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_GENERATOR_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_FACTORY_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_FACTORY_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_NATIVE_COIN_REGISTRY_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_PAIR_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_PAIR_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_TOKEN_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_TOKEN_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_VESTING_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_VESTING_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_MAKER_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_MAKER_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_ROUTER_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_ROUTER_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")
ASTROPORT_PAIR_STABLE_CONTRACT_BINARY_ID=$(store_binary "$ASTROPORT_PAIR_STABLE_BINARY" "$ASTROPORT_MULTISIG_ADDRESS")

# Contracts addresses pregeneration
# ORDER IS IMPORTANT HERE
ASTROPORT_SATELLITE_CONTRACT_ADDRESS=$(generate_contract_address $ASTROPORT_SATELLITE_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_ADDRESS=$(generate_contract_address $ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
ASTROPORT_FACTORY_CONTRACT_ADDRESS=$(generate_contract_address $ASTROPORT_FACTORY_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))

LOCKDROP_CONTRACT_ADDRESS=$(generate_contract_address $LOCKDROP_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
AUCTION_CONTRACT_ADDRESS=$(generate_contract_address $AUCTION_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
CREDITS_CONTRACT_ADDRESS=$(generate_contract_address $CREDITS_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
AIRDROP_CONTRACT_ADDRESS=$(generate_contract_address $AIRDROP_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
PRICE_FEED_CONTRACT_ADDRESS=$(generate_contract_address $PRICE_FEED_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
USDC_TWAP_CONTRACT_ADDRESS=$(generate_contract_address $TWAP_ORACLE_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
ATOM_TWAP_CONTRACT_ADDRESS=$(generate_contract_address $TWAP_ORACLE_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
USDC_LP_VESTING_CONTRACT_ADDRESS=$(generate_contract_address $LP_VESTING_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
ATOM_LP_VESTING_CONTRACT_ADDRESS=$(generate_contract_address $LP_VESTING_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
CREDITS_VAULT_CONTRACT_ADDRESS=$(generate_contract_address $CREDITS_VAULT_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
LOCKDROP_VAULT_CONTRACT_ADDRESS=$(generate_contract_address $LOCKDROP_VAULT_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
VESTING_INVESTORS_CONTRACT_ADDRESS=$(generate_contract_address $VESTING_INVESTORS_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
VESTING_INVESTORS_WITHOUT_VOTING_POWER_CONTRACT_ADDRESS=$(generate_contract_address $VESTING_INVESTORS_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
VESTING_LTI_CONTRACT_ADDRESS=$(generate_contract_address $VESTING_LTI_CONTRACT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))
INVESTORS_VESTING_VAULT_CONTRACT_ADDRESS=$(generate_contract_address $INVESTORS_VESTING_VAULT_BINARY_ID) && ((INSTANCE_ID_COUNTER++))

ASTROPORT_SATELLITE_INIT_MSG='{
  "owner": "'"$ASTROPORT_MULTISIG_ADDRESS"'",
  "astro_denom": "TODO",
  "transfer_channel": "TODO",
  "main_controller": "terra1fkuhmq52pj08qqffp0elrvmzel8zz857x0pjjuuaar54mgcpe35s9km660",
  "main_maker": "terra1ygcvxp9s054q8u2q4hvl52ke393zvgj0sllahlycm4mj8dm96zjsa45rzk",
  "timeout": 300
}'

ASTROPORT_NATIVE_COIN_REGISTRY_INIT_MSG='{
  "owner": "'"${ASTROPORT_MULTISIG_ADDRESS}"'"
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
      "total_fee_bps": 30,
      "maker_fee_bps": 3333,
      "is_disabled": false,
      "is_generator_disabled": false
    },
    {
      "code_id": '"${ASTROPORT_PAIR_STABLE_CONTRACT_BINARY_ID}"',
      "pair_type": {
        "stable": {}
      },
      "total_fee_bps": 5,
      "maker_fee_bps": 5000,
      "is_disabled": false,
      "is_generator_disabled": false
    }
  ],
  "token_code_id": '"${ASTROPORT_TOKEN_CONTRACT_BINARY_ID}"',
  "owner": "'"${ASTROPORT_SATELLITE_CONTRACT_ADDRESS}"'",
  "whitelist_code_id": 0,
  "coin_registry_address": "'"${ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_ADDRESS}"'"
}'

$BINARY add-genesis-account $NEUTRON_DAO_ADDRESS "1000000000000000untrn" --home ./home
# Instantiate Astroport contracts
instantiate_contract $ASTROPORT_SATELLITE_CONTRACT_BINARY_ID "$ASTROPORT_SATELLITE_INIT_MSG" "ASTROPORT_SATELLITE" "$ASTROPORT_MULTISIG_ADDRESS"
instantiate_contract $ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_BINARY_ID "$ASTROPORT_NATIVE_COIN_REGISTRY_INIT_MSG" "ASTROPORT_NATIVE_COIN_REGISTRY" "$ASTROPORT_SATELLITE_CONTRACT_ADDRESS"
execute_contract $ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_ADDRESS "$SET_UNTRN_PRECISION_MSG" "$ASTROPORT_MULTISIG_ADDRESS"
instantiate_contract $ASTROPORT_FACTORY_CONTRACT_BINARY_ID "$ASTROPORT_FACTORY_INIT_MSG" "ASTROPORT_FACTORY" "$ASTROPORT_SATELLITE_CONTRACT_ADDRESS"

LOCKDROP_LOCKUP_REWARDS_INFO='[
  {"duration": '$LOCKDROP_MIN_LOCK_DURATION_SECONDS', "coefficient": "0"},
  {"duration": 11664000, "coefficient": "0.25"},
  {"duration": 15552000, "coefficient": "0.5"},
  {"duration": 19440000, "coefficient": "1"},
  {"duration": 23328000, "coefficient": "2"},
  {"duration": 27216000, "coefficient": "4"},
  {"duration": '$LOCKDROP_MAX_LOCK_DURATION_SECONDS', "coefficient": "8"}
]'

LOCKDROP_INIT_MSG='{
  "owner": "'"$NEUTRON_DAO_ADDRESS"'",
  "token_info_manager": "'"$TOKEN_INFO_MANAGER_MULTISIG_ADDRESS"'",
  "credits_contract": "'"$CREDITS_CONTRACT_ADDRESS"'",
  "auction_contract": "'"$AUCTION_CONTRACT_ADDRESS"'",
  "init_timestamp": '$LOCKDROP_INIT_TIMESTAMP',
  "lock_window": '$LOCKDROP_LOCK_WINDOW_SECONDS',
  "withdrawal_window": '$LOCKDROP_WITHDRAWAL_WINDOW_SECONDS',
  "min_lock_duration": '$LOCKDROP_MIN_LOCK_DURATION_SECONDS',
  "max_lock_duration": '$LOCKDROP_MAX_LOCK_DURATION_SECONDS',
  "max_positions_per_user": '$LOCKDROP_MAX_POSITIONS_PER_USER',
  "lockup_rewards_info": '$LOCKDROP_LOCKUP_REWARDS_INFO'
}'

AUCTION_INIT_MSG='{
  "owner": "'"$NEUTRON_DAO_ADDRESS"'",
  "token_info_manager": "'"$TOKEN_INFO_MANAGER_MULTISIG_ADDRESS"'",
  "lockdrop_contract_address": "'"$LOCKDROP_CONTRACT_ADDRESS"'",
  "reserve_contract_address": "'"$RESERVE_CONTRACT_ADDRESS"'",
  "vesting_usdc_contract_address": "'"$USDC_LP_VESTING_CONTRACT_ADDRESS"'",
  "vesting_atom_contract_address": "'"$ATOM_LP_VESTING_CONTRACT_ADDRESS"'",
  "price_feed_contract": "'"$PRICE_FEED_CONTRACT_ADDRESS"'",
  "lp_tokens_lock_window": '$AUCTION_LP_TOKENS_LOCK_WINDOW',
  "init_timestamp": '$AUCTION_INIT_TIMESTAMP',
  "deposit_window": '$AUCTION_DEPOSIT_WINDOW_SECONDS',
  "withdrawal_window": '$AUCTION_WITHDRAWAL_WINDOW_SECONDS',
  "max_exchange_rate_age": '$AUCTION_MAX_EXCHANGE_RATE_AGE',
  "min_ntrn_amount": "'"$AUCTION_NTRN_AMOUNT_TO_SELL_U_NTRN"'",
  "vesting_migration_pack_size": '$AUCTION_VESTING_MIGRATION_PACK_SIZE',
  "vesting_lp_duration": '$AUCTION_VESTING_LP_DURATION'
}'

CREDITS_INIT_MSG='{
  "dao_address": "'"$NEUTRON_DAO_ADDRESS"'"
}'

CREDITS_UPDATE_CONFIG_MSG='{
  "update_config": {
    "config": {
      "airdrop_address": "'"$AIRDROP_CONTRACT_ADDRESS"'",
      "lockdrop_address": "'"$LOCKDROP_CONTRACT_ADDRESS"'",
      "when_withdrawable": '$CREDITS_WITHDRAW_START_TS'
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

PRICE_FEED_INIT_MSG='{}'

USDC_TWAP_INIT_MSG='{
  "factory_contract": "'"$ASTROPORT_FACTORY_CONTRACT_ADDRESS"'",
  "period": '$TWAP_UPDATE_PERIOD',
  "manager": "'"$TOKEN_INFO_MANAGER_MULTISIG_ADDRESS"'"
}'
ATOM_TWAP_INIT_MSG='{
  "factory_contract": "'"$ASTROPORT_FACTORY_CONTRACT_ADDRESS"'",
  "period": '$TWAP_UPDATE_PERIOD',
  "manager": "'"$TOKEN_INFO_MANAGER_MULTISIG_ADDRESS"'"
}'

USDC_LP_VESTING_INIT_MSG='{
  "owner": "'"$NEUTRON_DAO_ADDRESS"'",
  "token_info_manager": "'"$TOKEN_INFO_MANAGER_MULTISIG_ADDRESS"'",
  "vesting_managers": ["'"$TOKEN_INFO_MANAGER_MULTISIG_ADDRESS"'", "'"$AUCTION_CONTRACT_ADDRESS"'"]
}'
ATOM_LP_VESTING_INIT_MSG='{
  "owner": "'"$NEUTRON_DAO_ADDRESS"'",
  "token_info_manager": "'"$TOKEN_INFO_MANAGER_MULTISIG_ADDRESS"'",
  "vesting_managers": ["'"$TOKEN_INFO_MANAGER_MULTISIG_ADDRESS"'", "'"$AUCTION_CONTRACT_ADDRESS"'"]
}'

CREDITS_VAULT_INIT_MSG='{
  "credits_contract_address": "'"$CREDITS_CONTRACT_ADDRESS"'",
  "description": "Credits Contract Vault",
  "owner": "'"$NEUTRON_DAO_ADDRESS"'",
  "name": "CREDITS VAULT",
  "airdrop_contract_address": "'"$AIRDROP_CONTRACT_ADDRESS"'"
}'

CREDITS_MINT_MSG='{
  "mint": {}
}'

LOCKDROP_VAULT_INIT_MSG='{
  "lockdrop_contract": "'"$LOCKDROP_CONTRACT_ADDRESS"'",
  "description": "Lockdrop Contract Vault",
  "owner": "'"$NEUTRON_DAO_ADDRESS"'",
  "name": "Lockdrop Vault",
  "oracle_usdc_contract": "'"$USDC_TWAP_CONTRACT_ADDRESS"'",
  "oracle_atom_contract": "'"$ATOM_TWAP_CONTRACT_ADDRESS"'"
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
VESTING_INVESTORS_INIT_MSG='{
  "owner": "'"$TOKEN_ISSUER_MULTISIG_ADDRESS_2"'",
  "token_info_manager": "'"$TOKEN_ISSUER_MULTISIG_ADDRESS_2"'"
}'
VESTING_LTI_INIT_MSG='{
  "owner": "'"$FOUNDATION_MULTISIG_ADDRESS"'",
  "token_info_manager": "'"$FOUNDATION_MULTISIG_ADDRESS"'"
}'
INVESTORS_VESTING_VAULT_MSG='{
  "vesting_contract_address":"'"$VESTING_INVESTORS_CONTRACT_ADDRESS"'",
  "owner":"'"$NEUTRON_DAO_ADDRESS"'",
  "description":"Investors Vesting Vault",
  "name": "Investors Vault"
}'

SET_VESTING_TOKEN_MSG='{
  "set_vesting_token": {
    "vesting_token": {
      "native_token": {
        "denom": "untrn"
      }
    }
  }
}'

ADD_VESTING_ACCOUNT_MESSAGE='
{
  "register_vesting_accounts": {
    "vesting_accounts": [
      {
        "address": "'"$LTI_ACCOUNT_1"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_1_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_1_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_2"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_2_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_2_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_3"'",
        "schedules": [
          {
            "start_point": {
              "time":'$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_3_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_3_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_4"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_4_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_4_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_5"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_5_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_5_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_6"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_6_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_6_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_7"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_7_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_7_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_8"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_8_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_8_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_9"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_9_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_9_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_10"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_10_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_10_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_11"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_11_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_11_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_12"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_12_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_12_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_13"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_13_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_13_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_14"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_14_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_14_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_15"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_15_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_15_TOTAL"'"
            }
          }
        ]
      },
      {
        "address": "'"$LTI_ACCOUNT_16"'",
        "schedules": [
          {
            "start_point": {
              "time": '$LTI_START_TIMESTAMP',
              "amount": "'"$LTI_16_CLIFF"'"
            },
            "end_point": {
              "time": '$LTI_END_TIMESTAMP',
              "amount": "'"$LTI_16_TOTAL"'"
            }
          }
        ]
      }
    ]
  }
}
'

#Top up auction contract with some NTRNs
$BINARY add-genesis-account $AUCTION_CONTRACT_ADDRESS $AUCTION_AMOUNT --home ./home

# Instantiate TGE contracts
instantiate_contract $LOCKDROP_CONTRACT_BINARY_ID "$LOCKDROP_INIT_MSG" "TGE_NEUTRON_LOCKDROP" "$NEUTRON_DAO_ADDRESS"

# Lockdrop allocation
$BINARY add-wasm-message execute "$LOCKDROP_CONTRACT_ADDRESS" '{"increase_ntrn_incentives": {}}' --run-as "$NEUTRON_DAO_ADDRESS" --amount $LOCKDROP_NTRN_INCENTIVES_U_NTRN --home ./home

instantiate_contract $AUCTION_CONTRACT_BINARY_ID "$AUCTION_INIT_MSG" "TGE_NEUTRON_AUCTION" "$NEUTRON_DAO_ADDRESS"
instantiate_contract $CREDITS_CONTRACT_BINARY_ID "$CREDITS_INIT_MSG" "TGE_NEUTRON_CREDITS" "$NEUTRON_DAO_ADDRESS"
execute_contract $CREDITS_CONTRACT_ADDRESS "$CREDITS_UPDATE_CONFIG_MSG" "$NEUTRON_DAO_ADDRESS"

# Credits/airdrop allocation
execute_contract_w_funds $CREDITS_CONTRACT_ADDRESS "$CREDITS_MINT_MSG" "$NEUTRON_DAO_ADDRESS" "$AIRDROP_AMOUNT_U_NTRN"

instantiate_contract $AIRDROP_CONTRACT_BINARY_ID "$AIRDROP_INIT_MSG" "TGE_NEUTRON_AIRDROP" "$NEUTRON_DAO_ADDRESS"
instantiate_contract $PRICE_FEED_CONTRACT_BINARY_ID "$PRICE_FEED_INIT_MSG" "TGE_NEUTRON_PRICE_FEED" "$NEUTRON_DAO_ADDRESS"
instantiate_contract $TWAP_ORACLE_CONTRACT_BINARY_ID "$USDC_TWAP_INIT_MSG" "TGE_USDC_TWAP_ORACLE" "$NEUTRON_DAO_ADDRESS"
instantiate_contract $TWAP_ORACLE_CONTRACT_BINARY_ID "$ATOM_TWAP_INIT_MSG" "TGE_ATOM_TWAP_ORACLE" "$NEUTRON_DAO_ADDRESS"
instantiate_contract $LP_VESTING_CONTRACT_BINARY_ID "$USDC_LP_VESTING_INIT_MSG" "TGE_USDC_LP_VESTING" "$NEUTRON_DAO_ADDRESS"
instantiate_contract $LP_VESTING_CONTRACT_BINARY_ID "$ATOM_LP_VESTING_INIT_MSG" "TGE_ATOM_LP_VESTING" "$NEUTRON_DAO_ADDRESS"
instantiate_contract $CREDITS_VAULT_CONTRACT_BINARY_ID "$CREDITS_VAULT_INIT_MSG" "neutron.voting.vaults.credits" "$NEUTRON_DAO_ADDRESS"
instantiate_contract $LOCKDROP_VAULT_CONTRACT_BINARY_ID "$LOCKDROP_VAULT_INIT_MSG" "neutron.voting.vaults.lockdrop" "$NEUTRON_DAO_ADDRESS"
instantiate_contract $VESTING_INVESTORS_CONTRACT_BINARY_ID "$VESTING_INVESTORS_INIT_MSG" "VESTING_INVESTORS" "$TOKEN_ISSUER_MULTISIG_ADDRESS_2"
instantiate_contract $VESTING_INVESTORS_CONTRACT_BINARY_ID "$VESTING_INVESTORS_INIT_MSG" "VESTING_INVESTORS_WITHOUT_VOTING_POWER" "$TOKEN_ISSUER_MULTISIG_ADDRESS_2"
instantiate_contract $VESTING_LTI_CONTRACT_BINARY_ID "$VESTING_LTI_INIT_MSG" "VESTING_LTI" "$FOUNDATION_MULTISIG_ADDRESS"
instantiate_contract $INVESTORS_VESTING_VAULT_BINARY_ID "$INVESTORS_VESTING_VAULT_MSG" "neutron.voting.vaults.investors" "$NEUTRON_DAO_ADDRESS"

execute_contract $VESTING_LTI_CONTRACT_ADDRESS "$SET_VESTING_TOKEN_MSG" "$FOUNDATION_MULTISIG_ADDRESS"

# Add Lockdrop and Credits vault to Neutron DAO Voting Registry
execute_contract "$NEUTRON_VOTING_REGISTRY_CONTRACT_ADDRESS" "$ADD_CREDITS_VAULT_MSG" "$NEUTRON_DAO_ADDRESS"
execute_contract "$NEUTRON_VOTING_REGISTRY_CONTRACT_ADDRESS" "$ADD_LOCKDROP_VAULT_MSG" "$NEUTRON_DAO_ADDRESS"

echo "LOCKDROP_CONTRACT_ADDRESS:" $LOCKDROP_CONTRACT_ADDRESS
echo "AUCTION_CONTRACT_ADDRESS:" $AUCTION_CONTRACT_ADDRESS
echo "CREDITS_CONTRACT_ADDRESS:" $CREDITS_CONTRACT_ADDRESS
echo "AIRDROP_CONTRACT_ADDRESS:" $AIRDROP_CONTRACT_ADDRESS
echo "PRICE_FEED_CONTRACT_ADDRESS:" $PRICE_FEED_CONTRACT_ADDRESS
echo "USDC_TWAP_CONTRACT_ADDRESS:" $USDC_TWAP_CONTRACT_ADDRESS
echo "ATOM_TWAP_CONTRACT_ADDRESS:" $ATOM_TWAP_CONTRACT_ADDRESS
echo "USDC_LP_VESTING_CONTRACT_ADDRESS:" $USDC_LP_VESTING_CONTRACT_ADDRESS
echo "ATOM_LP_VESTING_CONTRACT_ADDRESS:" $ATOM_LP_VESTING_CONTRACT_ADDRESS
echo "CREDITS_VAULT_CONTRACT_ADDRESS:" $CREDITS_VAULT_CONTRACT_ADDRESS
echo "LOCKDROP_VAULT_CONTRACT_ADDRESS:" $LOCKDROP_VAULT_CONTRACT_ADDRESS
echo "ASTROPORT_SATELLITE_CONTRACT_ADDRESS:" $ASTROPORT_SATELLITE_CONTRACT_ADDRESS
echo "ASTROPORT_FACTORY_CONTRACT_ADDRESS:" $ASTROPORT_FACTORY_CONTRACT_ADDRESS
echo "ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_ADDRESS: " $ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_ADDRESS

echo "ASTROPORT_SATELLITE_CONTRACT_BINARY_ID:" $ASTROPORT_SATELLITE_CONTRACT_BINARY_ID
echo "ASTROPORT_GENERATOR_CONTRACT_BINARY_ID:" $ASTROPORT_GENERATOR_CONTRACT_BINARY_ID
echo "ASTROPORT_FACTORY_CONTRACT_BINARY_ID:" $ASTROPORT_FACTORY_CONTRACT_BINARY_ID
echo "ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_BINARY_ID:" $ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_BINARY_ID
echo "ASTROPORT_PAIR_CONTRACT_BINARY_ID:" $ASTROPORT_PAIR_CONTRACT_BINARY_ID
echo "ASTROPORT_TOKEN_CONTRACT_BINARY_ID:" $ASTROPORT_TOKEN_CONTRACT_BINARY_ID
echo "ASTROPORT_VESTING_CONTRACT_BINARY_ID:" $ASTROPORT_VESTING_CONTRACT_BINARY_ID
echo "ASTROPORT_MAKER_CONTRACT_BINARY_ID:" $ASTROPORT_MAKER_CONTRACT_BINARY_ID
echo "ASTROPORT_ROUTER_CONTRACT_BINARY_ID:" $ASTROPORT_ROUTER_CONTRACT_BINARY_ID
echo "ASTROPORT_PAIR_STABLE_CONTRACT_BINARY_ID:" $ASTROPORT_PAIR_STABLE_CONTRACT_BINARY_ID
echo "ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_ADDRESS:" $ASTROPORT_NATIVE_COIN_REGISTRY_CONTRACT_ADDRESS
echo "ASTROPORT_SATELLITE_CONTRACT_ADDRESS:" $ASTROPORT_SATELLITE_CONTRACT_ADDRESS
echo "ASTROPORT_FACTORY_CONTRACT_ADDRESS:" $ASTROPORT_FACTORY_CONTRACT_ADDRESS
echo "VESTING_INVESTORS_CONTRACT_ADDRESS:" $VESTING_INVESTORS_CONTRACT_ADDRESS
echo "VESTING_INVESTORS_WITHOUT_VOTING_POWER_CONTRACT_ADDRESS:" $VESTING_INVESTORS_WITHOUT_VOTING_POWER_CONTRACT_ADDRESS
echo "VESTING_LTI_CONTRACT_ADDRESS:" $VESTING_LTI_CONTRACT_ADDRESS
echo "INVESTORS_VESTING_VAULT_CONTRACT_ADDRESS:" $INVESTORS_VESTING_VAULT_CONTRACT_ADDRESS
