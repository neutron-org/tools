#!/bin/bash

. codes.env

SUBDAO_PRE_PROPOSE_SINGLE=13

function json_to_base64() {
  MSG=$1
  check_json "$MSG"
  echo "$MSG" | base64 | tr -d "\n"
}

function check_json() {
  MSG=$1
  if ! jq -e . >/dev/null 2>&1 <<<"$MSG"; then
      echo "Failed to parse JSON for $MSG" >&2
      exit 1
  fi
}

OVERRULE_PREPROPOSE='{ "overrule_pre_propose": "neutron1w798gp0zqv3s9hjl3jlnwxtwhykga6rn93p46q2crsdqhaj3y4gsum0096"}'

TIMELOCK_RELATED_PREPROPOSE='{
   "open_proposal_submission":false,
   "timelock_module_instantiate_info":{
      "admin":{
         "address":{
            "addr":"neutron1suhgf5svhu4usrurvxzlgn54ksxmn8gljarjtxqnapv8kjnp4nrstdxvff"
         }
      },
      "code_id":'"$NEW_SUBDAO_TIMELOCK_SINGLE_CODE_ID"',
      "label":"neutron.subdaos.security.proposals.single.pre_propose.timelock",
      "msg":"'$(json_to_base64 "${OVERRULE_PREPROPOSE}")'"
   }
}'


SECURITY_SUBDAO_PREPROPOSAL='{ "open_proposal_submission": false }'

TIMELOCK_PROPOSAL_MSG='{
   "allow_revoting":false,
   "pre_propose_info":{
      "module_may_propose":{
         "info":{
            "admin":{
               "address":{
                  "addr":"neutron1suhgf5svhu4usrurvxzlgn54ksxmn8gljarjtxqnapv8kjnp4nrstdxvff"
               }
            },
            "code_id":'"$SUBDAO_PRE_PROPOSE_SINGLE"',
            "msg":"'$(json_to_base64 "${TIMELOCK_RELATED_PREPROPOSE}")'",
            "label":"neutron.subdaos.security.pre_propose.timelock"
         }
      }
   },
   "only_members_execute":false,
   "max_voting_period":{
      "height":1000000000000
   },
   "close_proposal_on_execution_failure":false,
   "threshold":{
      "absolute_count":{
         "threshold":"1"
      }
   }
}'

SECURITY_SUBDAO_PREPROPOSAL_NO_TIMELOCK='{
   "allow_revoting":false,
   "pre_propose_info":{
      "module_may_propose":{
         "info":{
            "admin":{
               "address":{
                  "addr":"neutron1suhgf5svhu4usrurvxzlgn54ksxmn8gljarjtxqnapv8kjnp4nrstdxvff"
               }
            },
            "code_id":'"${NEW_SECURITY_SUBDAO_PREPROPOSE_CODE_ID}"',
            "msg":"'$(json_to_base64 "${SECURITY_SUBDAO_PREPROPOSAL}")'",
            "label":"neutron.subdaos.security.pre_propose.no_timelock"
         }
      }
   },
   "only_members_execute":false,
   "max_voting_period":{
      "height":1000000000000
   },
   "close_proposal_on_execution_failure":false,
   "threshold":{
      "absolute_count":{
         "threshold":"1"
      }
   }
}'

UPDATE_PROPOSAL_MODULES='{
   "update_proposal_modules":{
      "to_add":[
         {
            "admin":{
               "address":{
                  "addr":"neutron1suhgf5svhu4usrurvxzlgn54ksxmn8gljarjtxqnapv8kjnp4nrstdxvff"
               }
            },
            "code_id":'"$NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID"',
            "label":"neutron.subdaos.security.proposals.single_timelock",
						"msg":"'$(json_to_base64 "${TIMELOCK_PROPOSAL_MSG}")'"
         },
         {
            "admin":{
               "address":{
                  "addr":"neutron1suhgf5svhu4usrurvxzlgn54ksxmn8gljarjtxqnapv8kjnp4nrstdxvff"
               }
            },
            "code_id":'"$NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID"',
            "label":"neutron.subdaos.security.proposals.single",
            "msg":"'$(json_to_base64 "${SECURITY_SUBDAO_PREPROPOSAL_NO_TIMELOCK}")'"
         }
      ],
      "to_disable":[
         "neutron15m728qxvtat337jdu2f0uk6pu905kktrxclgy36c0wd822tpxcmqvnrurt"
      ]
   }
}'

#neutron1fuyxwxlsgjkfjmxfthq8427dm2am3ya3cwcdr8gls29l7jadtazsuyzwcc - security subdao address
WASM_MSG='{
          "wasm": {
            "execute": {
              "contract_addr": "neutron1fuyxwxlsgjkfjmxfthq8427dm2am3ya3cwcdr8gls29l7jadtazsuyzwcc",
              "funds": [],
              "msg": "'$(json_to_base64 "${UPDATE_PROPOSAL_MODULES}")'"
            }
          }
        }'

echo $WASM_MSG