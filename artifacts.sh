#!/bin/bash
set -e

NEUTRON_DAO_BRANCH=fix/credits-vault-description
NEUTRON_TGE_BRANCH=main
ASTROPORT_CORE_VERSION=v2.8.0
ASTROPORT_IBC_VERSION=v1.1.0
CW_PLUS_VERSION=v1.0.1
DAODAO_VERSION=9e496379a1c1e89e00133865c9a1041dfdb20612

echo "############################################################################################################"
echo "################# Downloading Neutron DAO contracts to Neutron main repo ###################################"
echo "############################################################################################################"

rm -f ../neutron/contracts/*
rm -f ../neutron/contracts_thirdparty/*
cd ../neutron/contracts/
npx @neutron-org/get-artifacts neutron-dao -b $NEUTRON_DAO_BRANCH

echo "Writing neutron_dao_checksums.txt..."
rm -f ../../tools/neutron_dao_checksums.txt
for f in *.wasm
do
  shasum -a256 "$f" >> ../../tools/neutron_dao_checksums.txt
done

cd ../../tools

echo "############################################################################################################"
echo "################## Downloading Neutron DAO & TGE contracts to the tools repo ###############################"
echo "############################################################################################################"

rm -f ./artifacts/*
cd ./artifacts/

npx @neutron-org/get-artifacts neutron-tge-contracts -b $NEUTRON_TGE_BRANCH

echo "Writing neutron_tge_checksums.txt..."
rm -f ../../tools/neutron_tge_checksums.txt
for f in *.wasm
do
  shasum -a256 "$f" >> ../../tools/neutron_tge_checksums.txt
done

npx @neutron-org/get-artifacts neutron-dao -b $NEUTRON_DAO_BRANCH
cd ..

rm -rf .tmp
mkdir .tmp
cd .tmp

echo "############################################################################################################"
echo "################## Building Astroport core contracts for the TOOLS repo ####################################"
echo "############################################################################################################"

git clone --depth 1 --branch $ASTROPORT_CORE_VERSION git@github.com:astroport-fi/astroport-core.git
cd astroport-core
cp ../../fake-cargo-tomls/Cargo-astroport-core.toml ./Cargo.toml
cargo update

echo "Building binaries..."
docker run --rm -v "$(pwd)":/code \
  --mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target \
  --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
  cosmwasm/workspace-optimizer:0.12.9 > /dev/null 2>&1

echo "Adding astroport_core_checksums.txt..."
cp artifacts/checksums.txt ../../astroport_core_checksums.txt

echo "Adding astroport_generator.wasm..."
cp artifacts/astroport_generator.wasm ../../artifacts/
echo "Adding astroport_factory.wasm..."
cp artifacts/astroport_factory.wasm ../../artifacts/
echo "Adding astroport_pair.wasm..."
cp artifacts/astroport_pair.wasm ../../artifacts/
echo "Adding astroport_pair_stable.wasm..."
cp artifacts/astroport_pair_stable.wasm ../../artifacts/
echo "Adding astroport_xastro_token.wasm..."
cp artifacts/astroport_xastro_token.wasm ../../artifacts/
echo "Adding astroport_native_coin_registry.wasm..."
cp artifacts/astroport_native_coin_registry.wasm ../../artifacts/
echo "Adding astroport_vesting.wasm..."
cp artifacts/astroport_vesting.wasm ../../artifacts/
echo "Adding astroport_maker.wasm..."
cp artifacts/astroport_maker.wasm ../../artifacts/
echo "Adding astroport_router.wasm..."
cp artifacts/astroport_router.wasm ../../artifacts/

cd ..

echo "############################################################################################################"
echo "################## Building Astroport IBC contracts for the TOOLS repo #####################################"
echo "############################################################################################################"

git clone --depth 1 --branch $ASTROPORT_IBC_VERSION git@github.com:astroport-fi/astroport_ibc.git
cd astroport_ibc
cp ../../fake-cargo-tomls/Cargo-astroport-ibc.toml ./Cargo.toml
cargo update

echo "Building binaries..."
docker run --rm -v "$(pwd)":/code \
  --mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target \
  --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
  cosmwasm/workspace-optimizer:0.12.9 > /dev/null 2>&1

echo "Adding astroport_ibc_checksums.txt..."
cp artifacts/checksums.txt ../../astroport_ibc_checksums.txt

echo "Adding astro_satellite.wasm..."
cp artifacts/astro_satellite.wasm ../../artifacts/

cd ..

echo "############################################################################################################"
echo "################## Building CosmWasm Plus contracts for the Neutron repo ###################################"
echo "############################################################################################################"

git clone --depth 1 --branch $CW_PLUS_VERSION git@github.com:CosmWasm/cw-plus.git
cd cw-plus
cp ../../fake-cargo-tomls/Cargo-cw-plus.toml ./Cargo.toml
cargo update

echo "Building binaries..."
docker run --rm -v "$(pwd)":/code \
  --mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target \
  --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
  cosmwasm/workspace-optimizer:0.12.13 > /dev/null 2>&1

echo "Adding cw_plus_checksums.txt..."
cp artifacts/checksums.txt ../../cw_plus_checksums.txt

echo "Adding cw4_group.wasm..."
cp artifacts/cw4_group.wasm ../../../neutron/contracts_thirdparty/
echo "Adding cw3_fixed_multisig.wasm..."
cp artifacts/cw3_fixed_multisig.wasm ../../../neutron/contracts_thirdparty/

cd ..

echo "############################################################################################################"
echo "################## Building DA0DA0 contracts for the Neutron repo ##########################################"
echo "############################################################################################################"

git clone --depth 1 git@github.com:DA0-DA0/dao-contracts.git
cd dao-contracts
git fetch origin $DAODAO_VERSION
git checkout -q $DAODAO_VERSION
cp ../../fake-cargo-tomls/Cargo-dao-dao.toml ./Cargo.toml
cargo update

echo "Building binaries..."
docker run --rm -v "$(pwd)":/code \
		--mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target \
		--mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
		--platform linux/amd64 \
		cosmwasm/workspace-optimizer:0.12.11 > /dev/null 2>&1

echo "Adding daodao_checksums.txt (only cwd_voting_cw4.wasm)..."
cat artifacts/checksums.txt | grep cwd_voting_cw4.wasm >> ../../daodao_checksums.txt

echo "Adding cw4_voting.wasm..."
cp artifacts/cwd_voting_cw4.wasm ../../../neutron/contracts_thirdparty/cw4_voting.wasm

echo "############################################################################################################"
echo "################## Done ####################################################################################"
echo "############################################################################################################"
