#!/bin/bash

. codes.env

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

function empty_migration() {
    ADDRESS=$1
    CODE=$2

    MSG='{
    "wasm":{
        "migrate":{
            "contract_addr":"'"${ADDRESS}"'",
            "new_code_id": '"${CODE}"',
            "msg":"e30K"
        }
    }
    }'
    echo $MSG
}

function from_compatible_migration() {
    ADDRESS=$1
    CODE=$2
    FROM_COMPATIBLE='{
    "from_compatible": {}
    }'
    FROM_COMPATIBLE_BASE64=$(json_to_base64 "$FROM_COMPATIBLE")

    MSG='{
    "wasm":{
        "migrate":{
            "contract_addr":"'"${ADDRESS}"'",
            "new_code_id": '"${CODE}"',
            "msg":"'"${FROM_COMPATIBLE_BASE64}"'"
        }
    }
    }'
    echo $MSG
}



#NEW_MAIN_DAO_CODE_ID
MAIN_DAO=neutron1suhgf5svhu4usrurvxzlgn54ksxmn8gljarjtxqnapv8kjnp4nrstdxvff

#NEW_SUBDAO_CORE_ID
SECURITY_SUBDAO=neutron1fuyxwxlsgjkfjmxfthq8427dm2am3ya3cwcdr8gls29l7jadtazsuyzwcc
GRANTS_SUBDAO=neutron1zjdv3u6svlazlydmje2qcp44yqkt0059chz8gmyl5yrklmgv6fzq9chelu

#NEW_PROPOSAL_SINGLE_CODE_ID
PROPOSAL_OVERRULE=neutron12pwnhtv7yat2s30xuf4gdk9qm85v4j3e6p44let47pdffpklcxlq56v0te
PROPOSAL_SINGLE=neutron1436kxs0w2es6xlqpp9rd35e3d0cjnw4sv8j3a7483sgks29jqwgshlt6zh

#NEW_PRE_PROPOSE_SINGLE_CODE_ID
PRE_PROPOSE_SINGLE=neutron1hulx7cgvpfcvg83wk5h96sedqgn72n026w6nl47uht554xhvj9nsgs8v0z

#NEW_PRE_PROPOSE_MULTIPLE_CODE_ID
PRE_PROPOSE_MULTIPLE=neutron1up07dctjqud4fns75cnpejr4frmjtddzsmwgcktlyxd4zekhwecqt2h8u6

#NEW_PRE_PROPOSE_OVERRULE_CODE_ID
PRE_POPOSE_SINGLE_OVERRULE=neutron1w798gp0zqv3s9hjl3jlnwxtwhykga6rn93p46q2crsdqhaj3y4gsum0096

#NEW_PROPOSAL_MULTIPLE_CODE_ID
PROPOSAL_MULTIPLE=neutron1pvrwmjuusn9wh34j7y520g8gumuy9xtl3gvprlljfdpwju3x7ucsj3fj40

#NEW_SUBDAO_TIMELOCK_SINGLE_CODE_ID
SUBDAO_TIMELOCK_SINGLE=neutron1lvl674duw26psvzux5050du5kfg40kmy5z70t6am8pw6yje2wfjq66lmj2

#NEW_VOTING_REGISTRY_CODE_ID
VOTING_REGISTRY=neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s

#NEW_TGE_VESTING_GRANTS_SUBDAO_CODE_ID
VESTING_GRANTS_SUBDAO=neutron1atjemf7fjkkstae45q6dhuskvxlmnt9ndm05srd7jwhpxq9fhdgqgz28es

#NEW_SECURITY_SUBDAO_PREPROPOSE_CODE_ID
SECURITY_SUBDAO_PREPROPOSE=neutron1zjd5lwhch4ndnmayqxurja4x5y5mavy9ktrk6fzsyzan4wcgawnqjk5g26



MSG='{
  "propose": {
    "msg": {
      "propose": {
        "title": "migrate subdao",
        "description": "to make it actual",
        "msgs": [
        '$(empty_migration $MAIN_DAO $NEW_MAIN_DAO_CODE_ID)',
        '$(from_compatible_migration $SECURITY_SUBDAO $NEW_SUBDAO_CORE_ID)',
        '$(from_compatible_migration $GRANTS_SUBDAO $NEW_SUBDAO_CORE_ID)',
        '$(empty_migration $PROPOSAL_OVERRULE $NEW_PROPOSAL_SINGLE_CODE_ID)',
        '$(empty_migration $PROPOSAL_SINGLE $NEW_PROPOSAL_SINGLE_CODE_ID)',
        '$(empty_migration $PRE_PROPOSE_SINGLE $NEW_PRE_PROPOSE_SINGLE_CODE_ID)',
        '$(empty_migration $PRE_PROPOSE_MULTIPLE $NEW_PRE_PROPOSE_MULTIPLE_CODE_ID)',
        '$(empty_migration $PRE_POPOSE_SINGLE_OVERRULE $NEW_PRE_PROPOSE_OVERRULE_CODE_ID)',
        '$(from_compatible_migration $PROPOSAL_MULTIPLE $NEW_PROPOSAL_MULTIPLE_CODE_ID)',
        '$(empty_migration $SUBDAO_TIMELOCK_SINGLE $NEW_SUBDAO_TIMELOCK_SINGLE_CODE_ID)',
        '$(empty_migration $SECURITY_SUBDAO_PREPROPOSE $SECURITY_SUBDAO_PREPROPOSE_CODE_ID)',
        '$(empty_migration $VOTING_REGISTRY $NEW_VOTING_REGISTRY_CODE_ID)',
        '$(empty_migration $VESTING_GRANTS_SUBDAO $NEW_TGE_VESTING_GRANTS_SUBDAO_CODE_ID)',
        '$(bash ./build_subdao_update_msg.sh)'
    ]
          }
    }
  }
}
'
echo $MSG

