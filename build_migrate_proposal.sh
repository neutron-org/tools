#!/bin/bash

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

DAO_CORE_CODE_ID=512
PRE_PROPOSE_MULTIPLE_CODE_ID=513
PRE_PROPOSE_SINGLE_CODE_ID=514
PRE_PROPOSE_OVERRULE_SINGLE_CODE_ID=515
PROPOSE_MULTIPLE_CODE_ID=516
PROPOSE_SINGLE_CODE_ID=517
CREDITS_VAULT_CODE_ID=518
INVESTORS_VAULT_CODE_ID=519
LOCKDROP_VAULT_CODE_ID=520
NEUTRON_VAULT_CODE_ID=521
VESTING_LP_CODE_ID=522
DISTIBUTION_CODE_ID=523
RESERVE_CODE_ID=524
VOTING_REGISTRY_CODE_ID=525


SUBDAO_SECURITY_CORE_CODE_ID=526
SUBDAO_SECURITY_PRE_PROPOSE_CODE_ID=527
SUBDAO_SECURITY_PROPOSE_SINGLE_CODE_ID=528


DAO_CORE_CODE_ADDRESS=neutron1suhgf5svhu4usrurvxzlgn54ksxmn8gljarjtxqnapv8kjnp4nrstdxvff
PRE_PROPOSE_MULTIPLE_ADDRESS=neutron1up07dctjqud4fns75cnpejr4frmjtddzsmwgcktlyxd4zekhwecqt2h8u6
PRE_PROPOSE_SINGLE_ADDRESS=neutron1hulx7cgvpfcvg83wk5h96sedqgn72n026w6nl47uht554xhvj9nsgs8v0z
PRE_PROPOSE_OVERRULE_ADDRESS=neutron1w798gp0zqv3s9hjl3jlnwxtwhykga6rn93p46q2crsdqhaj3y4gsum0096
PROPOSE_OVERRULE_ADDRESS=neutron12pwnhtv7yat2s30xuf4gdk9qm85v4j3e6p44let47pdffpklcxlq56v0te
PROPOSE_MULTIPLE_ADDRESS=neutron1pvrwmjuusn9wh34j7y520g8gumuy9xtl3gvprlljfdpwju3x7ucsj3fj40
PROPOSE_SINGLE_CODE_ADDRESS=neutron1436kxs0w2es6xlqpp9rd35e3d0cjnw4sv8j3a7483sgks29jqwgshlt6zh
CREDITS_VAULT_CODE_ADDRESS=neutron1rxwzsw37ulveefk20575mlxl3hzhzv9k46c8gklfkt4g2vk4w3tse8usrs
INVESTORS_VAULT_ADDRESS=neutron1dmd56h7hlevuwssp203fgc2uh0qdtwep2m735fzksuavgq3naslqp0ehvx
LOCKDROP_VAULT_ADDRESS=neutron1f8gs4rp232ngyta3g2efwfkznymvv85du7qm9y0mhvjxpp3cq68qgquudm
VESTING_LP_VAULT_ADDRESS=neutron1adavpfxyp5kgs3zp0n0vkc37qakeh5eqwxqxzysgg0ahlx82rmsqp4rnz8
NEUTRON_VAULT_ADDRESS=neutron1qeyjez6a9dwlghf9d6cy44fxmsajztw257586akk6xn6k88x0gus5djz4e
DISTIBUTION_ADDRESS=neutron1dk9c86h7gmvuaq89cv72cjhq4c97r2wgl5gyfruv6shquwspalgq5u7sy5
RESERVE_ADDRESS=neutron13we0myxwzlpx8l5ark8elw5gj5d59dl6cjkzmt80c5q5cv5rt54qvzkv2a
VOTING_REGISTRY_ADDRESS=neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s


SUBDAO_SECURITY_CORE_ADDRESS=neutron1fuyxwxlsgjkfjmxfthq8427dm2am3ya3cwcdr8gls29l7jadtazsuyzwcc
SUBDAO_SECURITY_PRE_PROPOSE_ADDRESS=neutron1zjd5lwhch4ndnmayqxurja4x5y5mavy9ktrk6fzsyzan4wcgawnqjk5g26
SUBDAO_SECURITY_PROPOSE_ADDRESS=neutron15m728qxvtat337jdu2f0uk6pu905kktrxclgy36c0wd822tpxcmqvnrurt

# migrate Reserve
MIGRATE_MSG='{}'
MIGRATE_MSG_BASE64=$(json_to_base64 "$MIGRATE_MSG")


MIGRATE_MSGS='[
    {
        "wasm": {
            "migrate": {
                "contract_addr": "'"${DAO_CORE_CODE_ADDRESS}"'",
                "new_code_id": '"${DAO_CORE_CODE_ID}"',
                "msg": "'"${MIGRATE_MSG_BASE64}"'"
            }
        }
    },
    {
         "wasm": {
              "migrate": {
                 "contract_addr": "'"${PRE_PROPOSE_MULTIPLE_ADDRESS}"'",
                 "new_code_id": '"${PRE_PROPOSE_MULTIPLE_CODE_ID}"',
                 "msg": "'"${MIGRATE_MSG_BASE64}"'"
              }
         }
    },
    {
             "wasm": {
                  "migrate": {
                     "contract_addr": "'"${PRE_PROPOSE_SINGLE_ADDRESS}"'",
                     "new_code_id": '"${PRE_PROPOSE_SINGLE_CODE_ID}"',
                     "msg": "'"${MIGRATE_MSG_BASE64}"'"
                  }
           }
   },
   {
         "wasm": {
                "migrate": {
                     "contract_addr": "'"${PRE_PROPOSE_OVERRULE_ADDRESS}"'",
                        "new_code_id": '"${PRE_PROPOSE_OVERRULE_SINGLE_CODE_ID}"',
                        "msg": "'"${MIGRATE_MSG_BASE64}"'"
                    }
         }
   },
   {
           "wasm": {
               "migrate": {
                   "contract_addr": "'"${PROPOSE_OVERRULE_ADDRESS}"'",
                   "new_code_id": '"${PROPOSE_SINGLE_CODE_ID}"',
                   "msg": "'"${MIGRATE_MSG_BASE64}"'"
               }
           }
   },
   {
              "wasm": {
                  "migrate": {
                      "contract_addr": "'"${PROPOSE_MULTIPLE_ADDRESS}"'",
                      "new_code_id": '"${PROPOSE_MULTIPLE_CODE_ID}"',
                      "msg": "'"${MIGRATE_MSG_BASE64}"'"
                  }
              }
   },
   {
              "wasm": {
                  "migrate": {
                      "contract_addr": "'"${PROPOSE_SINGLE_CODE_ADDRESS}"'",
                      "new_code_id": '"${PROPOSE_SINGLE_CODE_ID}"',
                      "msg": "'"${MIGRATE_MSG_BASE64}"'"
                  }
              }
      },
      {
                   "wasm": {
                       "migrate": {
                           "contract_addr": "'"${CREDITS_VAULT_CODE_ADDRESS}"'",
                           "new_code_id": '"${CREDITS_VAULT_CODE_ID}"',
                           "msg": "'"${MIGRATE_MSG_BASE64}"'"
                       }
                   }
      },
      {
                 "wasm": {
                     "migrate": {
                         "contract_addr": "'"${INVESTORS_VAULT_ADDRESS}"'",
                         "new_code_id": '"${INVESTORS_VAULT_CODE_ID}"',
                         "msg": "'"${MIGRATE_MSG_BASE64}"'"
                     }
                 }
      },
      {
                       "wasm": {
                           "migrate": {
                               "contract_addr": "'"${LOCKDROP_VAULT_ADDRESS}"'",
                               "new_code_id": '"${LOCKDROP_VAULT_CODE_ID}"',
                               "msg": "'"${MIGRATE_MSG_BASE64}"'"
                           }
                       }
      },
      {
                             "wasm": {
                                 "migrate": {
                                     "contract_addr": "'"${VESTING_LP_VAULT_ADDRESS}"'",
                                     "new_code_id": '"${VESTING_LP_CODE_ID}"',
                                     "msg": "'"${MIGRATE_MSG_BASE64}"'"
                                 }
                             }
      },
      {
                             "wasm": {
                                 "migrate": {
                                     "contract_addr": "'"${NEUTRON_VAULT_ADDRESS}"'",
                                     "new_code_id": '"${NEUTRON_VAULT_CODE_ID}"',
                                     "msg": "'"${MIGRATE_MSG_BASE64}"'"
                                 }
                             }
      },
      {
                                   "wasm": {
                                       "migrate": {
                                           "contract_addr": "'"${DISTIBUTION_ADDRESS}"'",
                                           "new_code_id": '"${DISTIBUTION_CODE_ID}"',
                                           "msg": "'"${MIGRATE_MSG_BASE64}"'"
                                       }
                                   }
      },
      {
                                    "wasm": {
                                        "migrate": {
                                            "contract_addr": "'"${RESERVE_ADDRESS}"'",
                                            "new_code_id": '"${RESERVE_CODE_ID}"',
                                            "msg": "'"${MIGRATE_MSG_BASE64}"'"
                                        }
                                    }
      },
      {
                                          "wasm": {
                                              "migrate": {
                                                  "contract_addr": "'"${VOTING_REGISTRY_ADDRESS}"'",
                                                  "new_code_id": '"${VOTING_REGISTRY_CODE_ID}"',
                                                  "msg": "'"${MIGRATE_MSG_BASE64}"'"
                                              }
                                          }
      },
      {
                                                "wasm": {
                                                    "migrate": {
                                                        "contract_addr": "'"${SUBDAO_SECURITY_CORE_ADDRESS}"'",
                                                        "new_code_id": '"${SUBDAO_SECURITY_CORE_CODE_ID}"',
                                                        "msg": "'"${MIGRATE_MSG_BASE64}"'"
                                                    }
                                                }
      },
      {
                                                "wasm": {
                                                    "migrate": {
                                                        "contract_addr": "'"${SUBDAO_SECURITY_PRE_PROPOSE_ADDRESS}"'",
                                                        "new_code_id": '"${SUBDAO_SECURITY_PRE_PROPOSE_CODE_ID}"',
                                                        "msg": "'"${MIGRATE_MSG_BASE64}"'"
                                                    }
                                                }
      },
      {
                                                "wasm": {
                                                    "migrate": {
                                                        "contract_addr": "'"${SUBDAO_SECURITY_PROPOSE_ADDRESS}"'",
                                                        "new_code_id": '"${SUBDAO_SECURITY_PROPOSE_SINGLE_CODE_ID}"',
                                                        "msg": "'"${MIGRATE_MSG_BASE64}"'"
                                                    }
                                                }
       }

]'

echo $MIGRATE_MSGS | jq . > migrate_proposal.json

