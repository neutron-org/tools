#!/bin/bash
set -e

NEUTRON_BRANCH=mainnet/genesis
TOOLS_BRANCH=mainnet/genesis

echo "############################################################################################################"
echo "################# Cloning Neutron and checking out $NEUTRON_BRANCH #########################################"
echo "############################################################################################################"

rm -f ./neutron
rm -f ./tools

git clone git@github.com:neutron-org/neutron.git
cd ./neutron
git checkout $NEUTRON_BRANCH
mkdir contracts
mkdir contracts_thirdparty

cd ..


echo "############################################################################################################"
echo "################# Cloning Tools and checking out $TOOLS_BRANCH #############################################"
echo "############################################################################################################"

git clone git@github.com:neutron-org/tools.git
cd ./tools
git checkout $TOOLS_BRANCH
mkdir artifacts

cd ..

echo "############################################################################################################"
echo "################# Building artifacts #######################################################################"
echo "############################################################################################################"


cd ./tools
./artifacts.sh

cd ..

echo "############################################################################################################"
echo "################# Sarting Neutron  #########################################################################"
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

echo "Waiting 60 seconds for Neutron to start..."
sleep 30

echo "############################################################################################################"
echo "################# Running checks ###########################################################################"
echo "############################################################################################################"

sh ./on_chain_checker.sh
python checksums_checker.py

cd ..

echo "############################################################################################################"
echo "################# Saving final genesis to ./genesis.json ###################################################"
echo "############################################################################################################"

cp ./tools/home/config/genesis.json ./

pkill -f neutrond
echo "Done."