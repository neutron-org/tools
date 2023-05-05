#######################################################################################################################
#######################################################################################################################
#######################################################################################################################
###########################################  CHECK BALANCES ###########################################################
#######################################################################################################################
#######################################################################################################################
#######################################################################################################################
#######################################################################################################################

VESTING_LTI_CONTRACT_ADDRESS="neutron1a5xz4zm0gkpcf92ddm7fw8pghg2mf4wm6cyu6cgcruq35upf7auslnnfye"
FOUNDATION_MULTISIG_ADDRESS="neutron1xumd0qd3pceu875vazn3w5m9n78cns7q5fhgj3"
NEUTRON_DAO_ADDRESS="neutron1suhgf5svhu4usrurvxzlgn54ksxmn8gljarjtxqnapv8kjnp4nrstdxvff"
RESERVE_CONTRACT_ADDRESS="neutron13we0myxwzlpx8l5ark8elw5gj5d59dl6cjkzmt80c5q5cv5rt54qvzkv2a"
TOKEN_ISSUER_MULTISIG_ADDRESS="neutron18g42rexsmmnkt32nf4qxv04glp0u8w7rwvfxzr"
LOCKDROP_CONTRACT_ADDRESS="neutron1ryhxe5fzczelcfmrhmcw9x2jsqy677fw59fsctr09srk24lt93eszwlvyj"
AUCTION_CONTRACT_ADDRESS="neutron1qj296vdrjfhuvrm96el3yhx8rcpz4k0huqcp9vwtqzhxwrduhs8s49y3p4"
CREDITS_CONTRACT_ADDRESS="neutron1h6828as2z5av0xqtlh4w9m75wxewapk8z9l2flvzc29zeyzhx6fqgp648z"

# ---------------------------------------------------------------------------------------------------------------------

VESTING_LTI_CONTRACT_BALANCE=$(neutrond q bank balances $VESTING_LTI_CONTRACT_ADDRESS --output --json | jq --raw-output ".balances[0].amount")
VESTING_LTI_CONTRACT_BALANCE_EXPECTED="68131557000000"

SUM_OF_VESTING_LTI_ACCOUNTS_ALLOCATIONS=$(neutrond query wasm contract-state smart neutron1a5xz4zm0gkpcf92ddm7fw8pghg2mf4wm6cyu6cgcruq35upf7auslnnfye '{"vesting_accounts": {"limit": 100}}' --output json | jq "[.data.vesting_accounts[].info.schedules[0].end_point.amount | tonumber] | add")

if [[ "$VESTING_LTI_CONTRACT_BALANCE" == "$VESTING_LTI_CONTRACT_BALANCE_EXPECTED" ]]
  then
       echo "VESTING_LTI_CONTRACT_BALANCE is O.K."
  else
       echo "VESTING_LTI_CONTRACT_BALANCE is $VESTING_LTI_CONTRACT_BALANCE, expected $VESTING_LTI_CONTRACT_BALANCE_EXPECTED"
fi

if [[ "$SUM_OF_VESTING_LTI_ACCOUNTS_ALLOCATIONS" == "$VESTING_LTI_CONTRACT_BALANCE_EXPECTED" ]]
  then
       echo "SUM_OF_VESTING_LTI_ACCOUNTS_ALLOCATIONS is O.K."
  else
       echo "SUM_OF_VESTING_LTI_ACCOUNTS_ALLOCATIONS is $SUM_OF_VESTING_LTI_ACCOUNTS_ALLOCATIONS, expected $VESTING_LTI_CONTRACT_BALANCE_EXPECTED"
fi

# ---------------------------------------------------------------------------------------------------------------------

FOUNDATION_MULTISIG_BALANCE=$(neutrond q bank balances $FOUNDATION_MULTISIG_ADDRESS --output --json | jq --raw-output ".balances[0].amount")
FOUNDATION_MULTISIG_BALANCE_EXPECTED="11868443000000"


if [[ "$FOUNDATION_MULTISIG_BALANCE" == "$FOUNDATION_MULTISIG_BALANCE_EXPECTED" ]]
  then
       echo "FOUNDATION_MULTISIG_BALANCE is O.K."
  else
       echo "FOUNDATION_MULTISIG_BALANCE is $FOUNDATION_MULTISIG_BALANCE, expected $FOUNDATION_MULTISIG_BALANCE_EXPECTED"
fi

# ---------------------------------------------------------------------------------------------------------------------

NEUTRON_DAO_BALANCE=$(neutrond q bank balances $NEUTRON_DAO_ADDRESS --output --json | jq --raw-output ".balances[0].amount")
NEUTRON_DAO_BALANCE_EXPECTED="300000000000000"


if [[ "$NEUTRON_DAO_BALANCE" == "$NEUTRON_DAO_BALANCE_EXPECTED" ]]
  then
       echo "NEUTRON_DAO_BALANCE is O.K."
  else
       echo "NEUTRON_DAO_BALANCE is $NEUTRON_DAO_BALANCE, expected $NEUTRON_DAO_BALANCE_EXPECTED"
fi

# ---------------------------------------------------------------------------------------------------------------------

RESERVE_CONTRACT_BALANCE=$(neutrond q bank balances $RESERVE_CONTRACT_ADDRESS --output --json | jq --raw-output ".balances[0].amount")
RESERVE_CONTRACT_BALANCE_EXPECTED="240000000000000"


if [[ "$RESERVE_CONTRACT_BALANCE" == "$RESERVE_CONTRACT_BALANCE_EXPECTED" ]]
  then
       echo "RESERVE_CONTRACT_BALANCE is O.K."
  else
       echo "RESERVE_CONTRACT_BALANCE is $RESERVE_CONTRACT_BALANCE, expected $RESERVE_CONTRACT_BALANCE_EXPECTED"
fi

# ---------------------------------------------------------------------------------------------------------------------

TOKEN_ISSUER_MULTISIG_BALANCE=$(neutrond q bank balances $TOKEN_ISSUER_MULTISIG_ADDRESS --output --json | jq --raw-output ".balances[0].amount")
TOKEN_ISSUER_MULTISIG_BALANCE_EXPECTED="260000000000000"


if [[ "$TOKEN_ISSUER_MULTISIG_BALANCE" == "$TOKEN_ISSUER_MULTISIG_BALANCE_EXPECTED" ]]
  then
       echo "TOKEN_ISSUER_MULTISIG_BALANCE is O.K."
  else
       echo "TOKEN_ISSUER_MULTISIG_BALANCE is $TOKEN_ISSUER_MULTISIG_BALANCE, expected $TOKEN_ISSUER_MULTISIG_BALANCE_EXPECTED"
fi

# ---------------------------------------------------------------------------------------------------------------------

LOCKDROP_CONTRACT_BALANCE=$(neutrond q bank balances $LOCKDROP_CONTRACT_ADDRESS --output --json | jq --raw-output ".balances[0].amount")
LOCKDROP_CONTRACT_BALANCE_EXPECTED="10000000000000"


if [[ "$LOCKDROP_CONTRACT_BALANCE" == "$LOCKDROP_CONTRACT_BALANCE_EXPECTED" ]]
  then
       echo "LOCKDROP_CONTRACT_BALANCE is O.K."
  else
       echo "LOCKDROP_CONTRACT_BALANCE is $LOCKDROP_CONTRACT_BALANCE, expected $LOCKDROP_CONTRACT_BALANCE_EXPECTED"
fi

# ---------------------------------------------------------------------------------------------------------------------

AUCTION_CONTRACT_BALANCE=$(neutrond q bank balances $AUCTION_CONTRACT_ADDRESS --output --json | jq --raw-output ".balances[0].amount")
AUCTION_CONTRACT_BALANCE_EXPECTED="40000000000000"


if [[ "$AUCTION_CONTRACT_BALANCE" == "$AUCTION_CONTRACT_BALANCE_EXPECTED" ]]
  then
       echo "AUCTION_CONTRACT_BALANCE is O.K."
  else
       echo "AUCTION_CONTRACT_BALANCE is $AUCTION_CONTRACT_BALANCE, expected $AUCTION_CONTRACT_BALANCE_EXPECTED"
fi

# ---------------------------------------------------------------------------------------------------------------------

CREDITS_CONTRACT_BALANCE=$(neutrond q bank balances $CREDITS_CONTRACT_ADDRESS --output --json | jq --raw-output ".balances[0].amount")
CREDITS_CONTRACT_BALANCE_EXPECTED="70000000000000"


if [[ "$CREDITS_CONTRACT_BALANCE" == "$CREDITS_CONTRACT_BALANCE_EXPECTED" ]]
  then
       echo "CREDITS_CONTRACT_BALANCE is O.K."
  else
       echo "CREDITS_CONTRACT_BALANCE is $CREDITS_CONTRACT_BALANCE, expected $CREDITS_CONTRACT_BALANCE_EXPECTED"
fi

# ---------------------------------------------------------------------------------------------------------------------
TOTAL_SUPPLY_EXPECTED="1000000000000000"
TOTAL_SUPPLY=$(neutrond q bank total --output json | jq ".supply[0].amount" --raw-output)

if [[ "$TOTAL_SUPPLY_EXPECTED" == "$TOTAL_SUPPLY" ]]
then
       echo "TOTAL SUPPLY is O.K."
  else
       echo "TOTAL SUPPLY is $TOTAL_SUPPLY, expected $TOTAL_SUPPLY_EXPECTED"
fi

#######################################################################################################################
#######################################################################################################################
#######################################################################################################################
########################################### CHECK SECURITY SUBDAO #####################################################
#######################################################################################################################
#######################################################################################################################
#######################################################################################################################
#######################################################################################################################

SECURITY_SUBDAO_CORE_CONTRACT_ADDRESS="neutron1fuyxwxlsgjkfjmxfthq8427dm2am3ya3cwcdr8gls29l7jadtazsuyzwcc"

# ---------------------------------------------------------------------------------------------------------------------
# Check members

SECURITY_SUBDAO_VOTING_MODULE_ADDRESS=$(neutrond q wasm contract-state smart $SECURITY_SUBDAO_CORE_CONTRACT_ADDRESS '{"voting_module": {}}' --output json | jq --raw-output ".data")
SECURITY_SUBDAO_CW4_GROUP_ADDRESS=$(neutrond q wasm contract-state smart $SECURITY_SUBDAO_VOTING_MODULE_ADDRESS '{"group_contract": {}}' --output json | jq --raw-output ".data")

SECURITY_SUBDAO_MEMBERS=$(neutrond q wasm contract-state smart $SECURITY_SUBDAO_CW4_GROUP_ADDRESS '{"list_members": {}}' --output json | jq --raw-output ".data.members")
SECURITY_SUBDAO_MEMBERS=$(echo $SECURITY_SUBDAO_MEMBERS | jq 'sort_by(.addr)' | jq)

EXPECTED_SECURITY_SUBDAO_MEMBERS='[
  {
    "addr": "neutron1083svrca4t350mphfv9x45wq9asrs60cvs77fx",
    "weight": 1
  },
  {
    "addr": "neutron10ng7hj4ucz2pzgmw6l22cpkhaxvhyh4pvu0dzk",
    "weight": 1
  },
  {
    "addr": "neutron14xgp8mgs4tg6dj47ud5408cs5s53sf9ydxs3kp",
    "weight": 1
  },
  {
    "addr": "neutron1h8vf3ueml7ah7m8z9e6vx09trq5lv2fw9e049f",
    "weight": 1
  },
  {
    "addr": "neutron1tkavhfqt8358vl74z7r5kdkdy05s98yka0gl0t",
    "weight": 1
  }
]'

if [[ "$EXPECTED_SECURITY_SUBDAO_MEMBERS" == "$SECURITY_SUBDAO_MEMBERS" ]]
then
       echo "SECURITY_SUBDAO_MEMBERS is O.K."
  else
       echo "SECURITY_SUBDAO_MEMBERS is $SECURITY_SUBDAO_MEMBERS, expected $SECURITY_SUBDAO_MEMBERS"
fi

# ---------------------------------------------------------------------------------------------------------------------
# Check threshold

SECURITY_SUBDAO_PROPOSAL_MODULE_ADDRESS=$(neutrond q wasm contract-state smart $SECURITY_SUBDAO_CORE_CONTRACT_ADDRESS '{"proposal_modules":{}}' --output json | jq --raw-output ".data[0].address")
SECURITY_SUBDAO_PROPOSAL_MODULE_CONFIG_THRESHOLD=$(neutrond q wasm contract-state smart $SECURITY_SUBDAO_PROPOSAL_MODULE_ADDRESS '{"config":{}}' --output json | jq --raw-output ".data.threshold.absolute_count.threshold")
EXPECTED_SECURITY_SUBDAO_PROPOSAL_MODULE_CONFIG_THRESHOLD="3"

if [[ "$EXPECTED_SECURITY_SUBDAO_PROPOSAL_MODULE_CONFIG_THRESHOLD" == "$SECURITY_SUBDAO_PROPOSAL_MODULE_CONFIG_THRESHOLD" ]]
then
       echo "SECURITY_SUBDAO_PROPOSAL_MODULE_CONFIG_THRESHOLD is O.K."
  else
       echo "SECURITY_SUBDAO_PROPOSAL_MODULE_CONFIG_THRESHOLD is $SECURITY_SUBDAO_PROPOSAL_MODULE_CONFIG_THRESHOLD, expected $SECURITY_SUBDAO_PROPOSAL_MODULE_CONFIG_THRESHOLD"
fi

#######################################################################################################################
#######################################################################################################################
#######################################################################################################################
############################################### CHECK RESCUEEER #######################################################
#######################################################################################################################
#######################################################################################################################
#######################################################################################################################
#######################################################################################################################

RESCUEER_MULTISIG_CONTRACT_ADDRESS="neutron1zfw930csx0k5qzf35vndaulwada4wa3pwtg5hy8rmnnx35wdyhssd2rtlz"

# ---------------------------------------------------------------------------------------------------------------------
# Check members

RESCUEER_MULTISIG_MEMBERS=$(neutrond q wasm contract-state smart $RESCUEER_MULTISIG_CONTRACT_ADDRESS '{"list_voters": {}}' --output json | jq --raw-output ".data.voters")

EXPECTED_RESCUEER_MULTISIG_MEMBERS='[
  {
    "addr": "neutron1083svrca4t350mphfv9x45wq9asrs60cvs77fx",
    "weight": 1
  },
  {
    "addr": "neutron1705swa2kgn9pvancafzl254f63a3jda9hhy3ze",
    "weight": 1
  },
  {
    "addr": "neutron1h8vf3ueml7ah7m8z9e6vx09trq5lv2fw9e049f",
    "weight": 1
  },
  {
    "addr": "neutron1tkavhfqt8358vl74z7r5kdkdy05s98yka0gl0t",
    "weight": 1
  }
]'

if [[ "$EXPECTED_RESCUEER_MULTISIG_MEMBERS" == "$RESCUEER_MULTISIG_MEMBERS" ]]
then
       echo "RESCUEER_MULTISIG_MEMBERS is O.K."
  else
       echo "RESCUEER_MULTISIG_MEMBERS is $RESCUEER_MULTISIG_MEMBERS, expected $EXPECTED_RESCUEER_MULTISIG_MEMBERS"
fi

# ---------------------------------------------------------------------------------------------------------------------
# Check threshold

RESCUEER_MULTISIG_THRESHOLD=$(neutrond q wasm contract-state smart $RESCUEER_MULTISIG_CONTRACT_ADDRESS '{"threshold":{}}' --output json | jq --raw-output ".data.absolute_count.weight")

EXPECTED_RESCUEER_MULTISIG_THRESHOLD="3"

if [[ "$EXPECTED_RESCUEER_MULTISIG_THRESHOLD" == "$RESCUEER_MULTISIG_THRESHOLD" ]]
then
       echo "EXPECTED_RESCUEER_MULTISIG_THRESHOLD is O.K."
  else
       echo "EXPECTED_RESCUEER_MULTISIG_THRESHOLD is $RESCUEER_MULTISIG_THRESHOLD, expected $EXPECTED_RESCUEER_MULTISIG_THRESHOLD"
fi

# ---------------------------------------------------------------------------------------------------------------------
# Check Rescueeer owner

RESCUEER_CONTRACT_ADDRESS="neutron14n26cr7dj79smrgg44hfylhph9y45h4yy5emshwymd395g38kdpq9nj46s"

RESCUEER_OWNER=$(neutrond q wasm contract-state raw $RESCUEER_CONTRACT_ADDRESS "config" --ascii -o json | jq --raw-output ".data" | base64 -d | jq --raw-output ".owner")

if [[ "$RESCUEER_MULTISIG_CONTRACT_ADDRESS" == "$RESCUEER_OWNER" ]]
then
       echo "RESCUEER_OWNER is O.K."
  else
       echo "RESCUEER_OWNER is $RESCUEER_MULTISIG_THRESHOLD, expected $EXPECTED_RESCUEER_MULTISIG_THRESHOLD"
fi

# ---------------------------------------------------------------------------------------------------------------------
# Check Rescueeer EOL

RESCUEER_EOL=$(neutrond q wasm contract-state raw $RESCUEER_CONTRACT_ADDRESS "config" --ascii -o json | jq --raw-output ".data" | base64 -d | jq --raw-output ".eol")

echo $RESCUEER_EOL

# ---------------------------------------------------------------------------------------------------------------------
# Check if Rescueeer is DAO admin

DAO_ADMIN=$(neutrond q wasm contract $NEUTRON_DAO_ADDRESS -o json | jq -r ".contract_info.admin")

if [[ "$RESCUEER_CONTRACT_ADDRESS" == "$DAO_ADMIN" ]]
then
       echo "DAO_ADMIN is O.K."
  else
       echo "DAO_ADMIN is $DAO_ADMIN, expected $RESCUEER_CONTRACT_ADDRESS"
fi