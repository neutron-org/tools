#!/bin/bash
set -e

NEUTRON_BRANCH=mainnet/genesis
TOOLS_BRANCH=mainnet/genesis

echo "############################################################################################################"
echo "################# Cloning Neutron and checking out $NEUTRON_BRANCH #########################################"
echo "############################################################################################################"

rm -rf ./neutron
rm -rf ./tools

git clone --depth 1 --branch $NEUTRON_BRANCH git@github.com:neutron-org/neutron.git
cd ./neutron
mkdir contracts
mkdir contracts_thirdparty

cd ..


echo "############################################################################################################"
echo "################# Cloning Tools and checking out $TOOLS_BRANCH #############################################"
echo "############################################################################################################"

git clone --depth 1  --branch $TOOLS_BRANCH git@github.com:neutron-org/tools.git
cd ./tools
mkdir artifacts

cd ..

echo "############################################################################################################"
echo "################# Building artifacts #######################################################################"
echo "############################################################################################################"


cd ./tools
./artifacts.sh

cd ..

echo "############################################################################################################"
echo "################# Starting Neutron  #########################################################################"
echo "############################################################################################################"


cd ./neutron/
pwd
make CHAIN_ID=neutron-1 start > /dev/null 2>&1

echo "Done."

cd ..

echo "############################################################################################################"
echo "################# Copying genesis.json and contracts_to_code_ids.txt from Neutron to Tools #################"
echo "############################################################################################################"

cp ./neutron/data/neutron-1/config/genesis.json ./tools/genesis.json
cat ./neutron/contracts_to_code_ids.txt >> ./tools/contracts_to_code_ids.txt
cp ./neutron/result.json ./tools/first_phase_result.json

echo "Done."

echo "############################################################################################################"
echo "################# Running tge_genesis.sh and Neutron once again ############################################"
echo "############################################################################################################"


pkill -f neutrond
cd ./tools
neutrond tendermint unsafe-reset-all --home home

echo "Running tge_genesis.sh..."
./tge_genesis.sh > /dev/null

echo "Starting neutrond..."
neutrond add-consumer-section --home home
neutrond start --home home > /dev/null 2>&1 &

echo "Waiting 30 seconds for Neutron to start..."
sleep 30

echo "############################################################################################################"
echo "################# Running checks ###########################################################################"
echo "############################################################################################################"

sh ./on_chain_checker.sh
python3 checksums_checker.py

cd ..

echo "############################################################################################################"
echo "################# Saving final genesis to ./genesis.json ###################################################"
echo "############################################################################################################"

cp ./tools/home/config/genesis.json ./

pkill -f neutrond

echo "############################################################################################################"
echo "################# Adjusting genesis start time #############################################################"
echo "############################################################################################################"

function set_genesis_param() {
  local param_name=$1
  local param_value=$2
  sed -i -e "s/\"$param_name\":.*/\"$param_name\": $param_value/g" genesis.json
}

function set_genesis_param_jq() {
  local param_name=$1
  local param_value=$2
  cat genesis.json | jq "$param_name = $param_value" > g.json
}

CHAIN_START_TIME="2023-05-10T15:00:00.000000Z"

set_genesis_param     genesis_time                                                            "\"$CHAIN_START_TIME\","
set_genesis_param     reward_denoms                                                           "[\"untrn\"],"
set_genesis_param     provider_reward_denoms                                                  "[\"uatom\"]"
set_genesis_param_jq  .app_state.feerefunder.params.min_fee.ack_fee[0].amount                 "\"100000\""
set_genesis_param_jq  .app_state.feerefunder.params.min_fee.timeout_fee[0].amount             "\"100000\""
set_genesis_param_jq  .app_state.interchainqueries.params.query_deposit[0].amount             "\"10000000\""
set_genesis_param_jq  .app_state.tokenfactory.params.denom_creation_fee[0].amount             "\"100000000\""

if ! jq -e . genesis.json >/dev/null 2>&1; then
    echo "genesis appears to become incorrect json" >&2
    exit 1
fi

echo "Done."