set -e
source .env

# -------------------- create usdc/untrn pair --------------------

CREATE_PAIR_MSG='{
  "create_pair": {
    "pair_type": {
      "xyk": {}
    },
    "asset_infos": [
      {
        "native_token": {
          "denom": "'"$NTRN_DENOM"'"
        }
      },
      {
        "native_token": {
          "denom": "'"$USDC_DENOM"'"
        }
      }
    ]
  }
}'

RES=$(${BIN} tx wasm execute $FACTORY_CONTRACT_ADDR "$CREATE_PAIR_MSG" --from ${OPERATOR} -y \
  --chain-id ${CHAIN_ID} --output json --broadcast-mode=block --gas ${GAS} --node $NODE \
  --keyring-backend test)

CODE="$(echo "$RES" | jq '.code')"
if [[ "$CODE" -ne 0 ]]; then
  echo "Failed create NTRN/USDC pair: $(echo "$RES" | jq '.raw_log')" && exit 1
fi

# -------------------- create atom/untrn pair --------------------

CREATE_PAIR_MSG='{
  "create_pair": {
    "pair_type": {
      "xyk": {}
    },
    "asset_infos": [
      {
        "native_token": {
          "denom": "'"$NTRN_DENOM"'"
        }
      },
      {
        "native_token": {
          "denom": "'"$ATOM_DENOM"'"
        }
      }
    ]
  }
}'

RES=$(${BIN} tx wasm execute $FACTORY_CONTRACT_ADDR "$CREATE_PAIR_MSG" --from ${OPERATOR} -y \
  --chain-id ${CHAIN_ID} --output json --broadcast-mode=block --gas ${GAS} --node $NODE \
  --keyring-backend test)

CODE="$(echo "$RES" | jq '.code')"
if [[ "$CODE" -ne 0 ]]; then
  echo "Failed create NTRN/ATOM pair: $(echo "$RES" | jq '.raw_log')" && exit 1
fi

# -------------------- query pools --------------------

RES=$(${BIN} query wasm contract-state smart $FACTORY_CONTRACT_ADDR '{"pairs": {}}' \
  --chain-id ${CHAIN_ID} --output json --node $NODE)
echo $RES | jq .
echo "Created pools are listed above. Take the NTRN/ibcUSDC and NTRN/ibcATOM contract addresses and LP tokens from the list"
