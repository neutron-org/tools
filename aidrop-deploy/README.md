# Airdrop test deployment

The aim of this toolset is to deploy the test airdrop.

1. Install merkle-airdrop-cli
    ```
    git clone git@github.com:ratik/merkle-airdrop-cli.git
    yarn install
    yarn link
    ```
    > Maybe you'll have to do the command to make things work: `export PATH="$PATH:$(yarn global bin)"`
2. Modify `distribution.json` the way you want
3. Create wallet with `airdrop_admin` name in your neutrond
    ```
    neutrond keys add airdrop_admin --keyring-backend test
    ```
4. Transfer some tokens to the `airdrop_admin` account (it should be more than the total amount of tokens in the distribution + gas fees)
```
neutrond tx bank send demo12 neutron1sunry9gvy2yl6nvlm42xvrw5unugsjgwde7vvf 100000000untrn \
--node https://rpc-palvus.pion-1.ntrn.tech:443 --chain-id pion-1 --gas 5000000 --fees 12500untrn -y \
--b block --keyring-backend test
```
5. Run `./deploy.sh` script
6. check cNTRTN balance of the airdrop contract
```
neutrond q wasm contract-state smart neutron1dv49y7afpq573yyk6zj2z4rn7gqh689plhtrf6223kqs8ee3tq9spqpuf2 \
   '{"balance":{"address":"neutron1465d8udjudl6cd8kgdlh2s37p7q0cf9x7yveumqwqk6ng94qwnmq7n79qn"}}' \
   --node https://rpc-palvus.pion-1.ntrn.tech:443 --chain-id pion-1
```
7. Check NTRN balance of the credits contract
```
   neutrond q bank balances neutron1dv49y7afpq573yyk6zj2z4rn7gqh689plhtrf6223kqs8ee3tq9spqpuf2 \
   --node https://rpc-palvus.pion-1.ntrn.tech:443 --chain-id pion-1
```
8. Add one of the airdrop accounts
```
   neutrond keys add tw1 --recover --keyring-backend test
```
9. Run `python3 gen.py` script to generate database with proofs
10. Install [datasette](https://docs.datasette.io/en/stable/installation.html)
11. Run `datasette ./results.db`
13. Claim airdrop
```
ADDR=$(neutrond keys show tw1 -a --keyring-backend test)
PROOF=$(curl -s "http://localhost:8001/results/results.json?address=${ADDR}&_shape=object" | jq -r .$ADDR.proof)
AMOUNT=$(curl -s "http://localhost:8001/results/results.json?address=${ADDR}&_shape=object" | jq -r .$ADDR.amount)
neutrond tx wasm execute neutron1465d8udjudl6cd8kgdlh2s37p7q0cf9x7yveumqwqk6ng94qwnmq7n79qn \
   "{\"claim\":{\"address\":\"$ADDR\", \"proof\":$PROOF, \"amount\":\"$AMOUNT\"}}" \
   --from tw1 --node https://rpc-palvus.pion-1.ntrn.tech:443 --chain-id pion-1 --gas 5000000 --fees 12500untrn -y \
   -b block --keyring-backend test
```
14. Check if claimed
```
ADDR=$(neutrond keys show tw1 -a --keyring-backend test)
neutrond query wasm contract-state smart neutron1465d8udjudl6cd8kgdlh2s37p7q0cf9x7yveumqwqk6ng94qwnmq7n79qn \
   "{\"is_claimed\": {\"address\": \"$ADDR\"}}" \
   --node https://rpc-palvus.pion-1.ntrn.tech:443 --chain-id pion-1
```
15. Check cNTRN balance
```
ADDR=$(neutrond keys show tw1 -a --keyring-backend test)
neutrond q wasm contract-state smart neutron1dv49y7afpq573yyk6zj2z4rn7gqh689plhtrf6223kqs8ee3tq9spqpuf2 \
   "{\"balance\":{\"address\":\"$ADDR\"}}" \
   --node https://rpc-palvus.pion-1.ntrn.tech:443 --chain-id pion-1
```
15. Check how much can withdraw
```
ADDR=$(neutrond keys show tw1 -a --keyring-backend test)
neutrond q wasm contract-state smart neutron1dv49y7afpq573yyk6zj2z4rn7gqh689plhtrf6223kqs8ee3tq9spqpuf2 \
"{\"withdrawable_amount\":{\"address\":\"$ADDR\"}}" \
--node https://rpc-palvus.pion-1.ntrn.tech:443 --chain-id pion-1
```
15. Check NTRN balance
```
ADDR=$(neutrond keys show tw1 -a --keyring-backend test)
neutrond q bank balances "$ADDR" --node https://rpc-palvus.pion-1.ntrn.tech:443 --chain-id pion-1
```
16. Withdraw
```
ADDR=$(neutrond keys show tw1 -a --keyring-backend test)
AMOUNT=$(neutrond q wasm contract-state smart neutron1dv49y7afpq573yyk6zj2z4rn7gqh689plhtrf6223kqs8ee3tq9spqpuf2 \
"{\"withdrawable_amount\":{\"address\":\"$ADDR\"}}" \
--node https://rpc-palvus.pion-1.ntrn.tech:443 --chain-id pion-1 -o json | jq -r .data.amount)
neutrond tx wasm execute neutron1dv49y7afpq573yyk6zj2z4rn7gqh689plhtrf6223kqs8ee3tq9spqpuf2 \
"{\"withdraw\":{\"amount\":\"$AMOUNT\"}}" \
--from tw1 --node https://rpc-palvus.pion-1.ntrn.tech:443 --chain-id pion-1 --gas 5000000 --fees 12500untrn -y \
-b block --keyring-backend test
```