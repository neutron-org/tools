#!/bin/bash
set -e

NODE=${NODE:-"http://localhost:26657"}
KEY_NAME=${KEY_NAME:-"demowallet1"}
KEYRING=${KEYRING:-"test"}
CHAIN_ID=${CHAIN_ID:-"test-1"}
BINARY=${BINARY:-neutrond}
CHAINID=${CHAINID:-neutron-1}
STAKEDENOM=${STAKEDENOM:-untrn}
TGE_CONTRACTS_BINARIES_DIR=${TGE_CONTRACTS_BINARIES_DIR:-./artifacts}
DAO_CONTRACTS_BINARIES_DIR=${DAO_CONTRACTS_BINARIES_DIR:-./artifacts}
ASTROPORT_CONTRACTS_BINARIES_DIR=${ASTROPORT_CONTRACTS_BINARIES_DIR:-./artifacts} # TODO
GENESIS_PATH=${GENESIS_PATH:-./genesis.json}
TOKEN_INFO_MANAGER_MULTISIG_ADDRESS="neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"


#load config
. ./contracts.txt

echo "deposit to auction"

neutrond tx wasm execute neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"deposit": {}}' --amount "1000000000000uibcatom" --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y 
neutrond tx wasm execute neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"deposit": {}}' --amount "1000000000000uibcusdc" --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y
neutrond tx wasm execute neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"deposit": {}}' --amount "2000000000000uibcatom" --keyring-backend=test --from=demowallet2 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y
neutrond tx wasm execute neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"deposit": {}}' --amount "2000000000000uibcusdc" --keyring-backend=test --from=demowallet2 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y

neutrond q wasm contract-state smart neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"state":{}}' --chain-id=test-1  --node tcp://23.109.159.28:26657
sleep 61


echo "set pricefeed mock"
neutrond tx wasm execute neutron1qhh6n5q2n7xvanmvqdjac4welmm3lev273dkk5e3flxhrclrk9jqaz8g23 '{"set_rate":{"symbol":"ATOM","rate":{"rate":"10000000","resolve_time":"'$(date +%s)'","request_id":"1"}}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y
neutrond tx wasm execute neutron1qhh6n5q2n7xvanmvqdjac4welmm3lev273dkk5e3flxhrclrk9jqaz8g23 '{"set_rate":{"symbol":"USDC","rate":{"rate":"1000000","resolve_time":"'$(date +%s)'","request_id":"1"}}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y

echo "set_pool_size"
neutrond tx wasm execute neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"set_pool_size": {}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y

echo "get user info"
neutrond q wasm contract-state smart neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"user_info":{"address":"neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"}}' --chain-id=test-1  --node tcp://23.109.159.28:26657
neutrond q wasm contract-state smart neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"user_info":{"address":"neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf"}}' --chain-id=test-1  --node tcp://23.109.159.28:26657
echo "check user info ^^^^^"
sleep 10


echo "lock lp"
neutrond tx wasm execute neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"lock_lp":{"asset":"ATOM", "amount":"870388279000", "duration":259200}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y 
neutrond tx wasm execute neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"lock_lp":{"asset":"USDC", "amount":"275240857000", "duration":259200}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y 
neutrond tx wasm execute neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"lock_lp":{"asset":"ATOM", "amount":"1740776392000", "duration":259200}}' --keyring-backend=test --from=demowallet2 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y
neutrond tx wasm execute neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"lock_lp":{"asset":"USDC", "amount":"550481715000", "duration":259200}}' --keyring-backend=test --from=demowallet2 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y
echo "user info"
neutrond q wasm contract-state smart neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"user_info":{"address":"neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"}}' --chain-id=test-1  --node tcp://23.109.159.28:26657
neutrond q wasm contract-state smart neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"user_info":{"address":"neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf"}}' --chain-id=test-1  --node tcp://23.109.159.28:26657
echo "check user info ^^^^^"

sleep 51

neutrond tx wasm execute neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"init_pool": {}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y
neutrond tx wasm execute neutron17uh2wj875vt64x7pzzy08slsl5pqupfln0vw2k79knfshygy6ausrgtf8x '{"migrate_to_vesting": {}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y

echo "update twap"
neutrond tx wasm execute neutron1ntq7vz509nt4fx3yngltgt4svrggsgaept7tzpsmzeh8mek5utwstsj7eg '{"update": {}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y
neutrond tx wasm execute neutron1t3j72wyv83hddv54psva3q7gqzarh5jhsqu64n8u5594u8ul4sxsxrjc0m '{"update": {}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y

neutrond q wasm contract-state smart neutron1707ccwapsqtkceefqaxtm6hly7jxmytxx3dlejn8kedrqf2rjlnshw52gw '{ "simulation":
    {"offer_asset": {"info": {"native_token":{"denom":"untrn"}}, "amount":"1000000"}}
}' --chain-id=test-1  --node tcp://23.109.159.28:26657
echo "check simulation ^^^^^"
sleep 10

echo "deregister pairs"
neutrond tx wasm execute neutron1x85d7sktyv3ke4re90cj4nf6205a94tm4kly2dhyn3dwyhq4t56q9semue '{"deregister": {"asset_infos": [{"native_token":{"denom":"untrn"}},{"native_token":{"denom":"uibcatom"}}]}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y 
neutrond tx wasm execute neutron1x85d7sktyv3ke4re90cj4nf6205a94tm4kly2dhyn3dwyhq4t56q9semue '{"deregister": {"asset_infos": [{"native_token":{"denom":"untrn"}},{"native_token":{"denom":"uibcusdc"}}]}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y

echo "register new ones"
neutrond tx wasm execute neutron1x85d7sktyv3ke4re90cj4nf6205a94tm4kly2dhyn3dwyhq4t56q9semue '{"create_pair": {"pair_type":{"custom":"concentrated"},"asset_infos":[{"native_token":{"denom":"untrn"}},{"native_token":{"denom":"uibcatom"}}],"init_params":"eyJhbXAiOiI0MCIsImdhbW1hIjoiMC4wMDAxNDUiLCJtaWRfZmVlIjoiMC4wMDI2Iiwib3V0X2ZlZSI6IjAuMDA0NSIsImZlZV9nYW1tYSI6IjAuMDAwMjMiLCJyZXBlZ19wcm9maXRfdGhyZXNob2xkIjoiMC4wMDAwMDIiLCJtaW5fcHJpY2Vfc2NhbGVfZGVsdGEiOiIwLjAwMDE0NiIsInByaWNlX3NjYWxlIjoiMSIsIm1hX2hhbGZfdGltZSI6NjAwLCJ0cmFja19hc3NldF9iYWxhbmNlcyI6bnVsbH0="}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y
neutrond tx wasm execute neutron1x85d7sktyv3ke4re90cj4nf6205a94tm4kly2dhyn3dwyhq4t56q9semue '{"create_pair": {"pair_type":{"custom":"concentrated"},"asset_infos":[{"native_token":{"denom":"untrn"}},{"native_token":{"denom":"uibcusdc"}}],"init_params":"eyJhbXAiOiI0MCIsImdhbW1hIjoiMC4wMDAxNDUiLCJtaWRfZmVlIjoiMC4wMDI2Iiwib3V0X2ZlZSI6IjAuMDA0NSIsImZlZV9nYW1tYSI6IjAuMDAwMjMiLCJyZXBlZ19wcm9maXRfdGhyZXNob2xkIjoiMC4wMDAwMDIiLCJtaW5fcHJpY2Vfc2NhbGVfZGVsdGEiOiIwLjAwMDE0NiIsInByaWNlX3NjYWxlIjoiMSIsIm1hX2hhbGZfdGltZSI6NjAwLCJ0cmFja19hc3NldF9iYWxhbmNlcyI6bnVsbH0="}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y

echo "update generator"
neutrond tx wasm execute neutron1u4npx7xvprwanpru7utv8haq99rtfmdzzw6p3hpfc38n7zmzm42q8mtymn '{"setup_pools":{"pools":[["neutron1p5sel5t4kyqk2mezjl35r88nl4hveyrm540yp7f6xwh6cuqc5l7shzwhmh", "0"]]}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y 
neutrond tx wasm execute neutron1u4npx7xvprwanpru7utv8haq99rtfmdzzw6p3hpfc38n7zmzm42q8mtymn '{"setup_pools":{"pools":[["neutron1l3gtxnwjuy65rzk63k352d52ad0f2sh89kgrqwczgt56jc8nmc3qh5kag3", "0"]]}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y

echo "get new pairs"
neutrond q wasm contract-state smart neutron1x85d7sktyv3ke4re90cj4nf6205a94tm4kly2dhyn3dwyhq4t56q9semue '{"pairs":{}}' --chain-id=test-1  --node tcp://23.109.159.28:26657

echo "new pools generator"
neutrond tx wasm execute neutron1u4npx7xvprwanpru7utv8haq99rtfmdzzw6p3hpfc38n7zmzm42q8mtymn '{"setup_pools":{"pools":[["neutron1vs2jgdhesdhtzd07kzu9sdfwh39hs4qkn9q9m80dq35mguw2e6vsp62964", "1"]]}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y 
neutrond tx wasm execute neutron1u4npx7xvprwanpru7utv8haq99rtfmdzzw6p3hpfc38n7zmzm42q8mtymn '{"setup_pools":{"pools":[["neutron19tq9qujlfmtwz808u4dkqgu2s0dajc907ve4gma4kgt4ymftuqvsqvzmze", "1"]]}}' --keyring-backend=test --from=demowallet1 --chain-id=test-1 --gas auto --broadcast-mode block --gas-adjustment 1.5 --gas-prices 0.025untrn --node tcp://23.109.159.28:26657 -y
