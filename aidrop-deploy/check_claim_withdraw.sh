



ADDR=$(neutrond keys show tw1 -a --keyring-backend test)
PROOF=$(curl -s "http://localhost:8001/results/results.json?address=${ADDR}&_shape=object" | jq -r .$ADDR.proof)
AMOUNT=$(curl -s "http://localhost:8001/results/results.json?address=${ADDR}&_shape=object" | jq -r .$ADDR.amount)
neutrond tx wasm execute neutron1465d8udjudl6cd8kgdlh2s37p7q0cf9x7yveumqwqk6ng94qwnmq7n79qn \
   "{\"claim\":{\"address\":\"$ADDR\", \"proof\":$PROOF, \"amount\":\"$AMOUNT\"}}" \
   --from tw1 --node https://rpc-palvus.pion-1.ntrn.tech:443 --chain-id pion-1 --gas 5000000 --fees 12500untrn -y \
   -b block --keyring-backend test