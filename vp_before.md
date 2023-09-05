# BEFORE MIGRATION:

## registry's voting vaults

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_vaults": {}}' --output json | jq .
{
  "data": [
    {
      "address": "neutron1qeyjez6a9dwlghf9d6cy44fxmsajztw257586akk6xn6k88x0gus5djz4e",
      "name": "Neutron Vault",
      "description": "Vault to put NTRN tokens to get voting power"
    },
    {
      "address": "neutron1z3unpq9s5v2zp6djghwk359ya0upt6rzwpz8d48z38rxztazclfq08cww9",
      "name": "CREDITS VAULT",
      "description": "Credits Contract Vault"
    },
    {
      "address": "neutron1kax2cv9793hlfz69u3x0e5c75vxcum6qupv7rdz44fdu3yeeszus6y6dkr",
      "name": "Vesting lp vault",
      "description": "A vesting lp vault"
    },
    {
      "address": "neutron105ml67ymwlznz8twk2nyxu5xaqnsp2h24t50995ucp8ffu5wut7q2ewhj4",
      "name": "Lockdrop Vault",
      "description": "Lockdrop Contract Vault"
    }
  ]
}

## DAO's voting power

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"total_power_at_height": {}}' --output json | jq .
{
  "data": {
    "power": "19999999997701",
    "height": 119
  }
}

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_power_at_height": {"address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"}}' --output json | jq .
{
  "data": {
    "power": "6666666665900",
    "height": 119
  }
}

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_power_at_height": {"address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf"}}' --output json | jq .
{
  "data": {
    "power": "13333333331800",
    "height": 119
  }
}

## user info in Lockdrop

neutrond q wasm cs smart neutron1zt8m8ffpdrztjyqj0hmv8wgcz2cv3y4euk474znth4hnsn3vzaes32wtx2 '{"user_info": {"address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"}}' --output json | jq .
{
  "data": {
    "total_ntrn_rewards": "3333333525612",
    "ntrn_transferred": false,
    "lockup_infos": [
      {
        "pool_type": "ATOM",
        "lp_units_locked": "870388279000",
        "withdrawal_flag": false,
        "ntrn_rewards": "3030303222949",
        "duration": 259200,
        "generator_ntrn_debt": "0",
        "claimable_generator_astro_debt": "0",
        "generator_proxy_debt": [],
        "claimable_generator_proxy_debt": [],
        "unlock_timestamp": 1694079229,
        "astroport_lp_units": "870388279000",
        "astroport_lp_token": "neutron1p5sel5t4kyqk2mezjl35r88nl4hveyrm540yp7f6xwh6cuqc5l7shzwhmh",
        "astroport_lp_transferred": null
      },
      {
        "pool_type": "USDC",
        "lp_units_locked": "275240857000",
        "withdrawal_flag": false,
        "ntrn_rewards": "303030302663",
        "duration": 259200,
        "generator_ntrn_debt": "0",
        "claimable_generator_astro_debt": "0",
        "generator_proxy_debt": [],
        "claimable_generator_proxy_debt": [],
        "unlock_timestamp": 1694079229,
        "astroport_lp_units": "275240857000",
        "astroport_lp_token": "neutron1l3gtxnwjuy65rzk63k352d52ad0f2sh89kgrqwczgt56jc8nmc3qh5kag3",
        "astroport_lp_transferred": null
      }
    ],
    "claimable_generator_ntrn_debt": "0",
    "lockup_positions_index": 2
  }
}

neutrond q wasm cs smart neutron1zt8m8ffpdrztjyqj0hmv8wgcz2cv3y4euk474znth4hnsn3vzaes32wtx2 '{"user_info": {"address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf"}}' --output json | jq .
{
  "data": {
    "total_ntrn_rewards": "6666666474387",
    "ntrn_transferred": false,
    "lockup_infos": [
      {
        "pool_type": "ATOM",
        "lp_units_locked": "1740776392000",
        "withdrawal_flag": false,
        "ntrn_rewards": "6060605867960",
        "duration": 259200,
        "generator_ntrn_debt": "0",
        "claimable_generator_astro_debt": "0",
        "generator_proxy_debt": [],
        "claimable_generator_proxy_debt": [],
        "unlock_timestamp": 1694079229,
        "astroport_lp_units": "1740776392000",
        "astroport_lp_token": "neutron1p5sel5t4kyqk2mezjl35r88nl4hveyrm540yp7f6xwh6cuqc5l7shzwhmh",
        "astroport_lp_transferred": null
      },
      {
        "pool_type": "USDC",
        "lp_units_locked": "550481715000",
        "withdrawal_flag": false,
        "ntrn_rewards": "606060606427",
        "duration": 259200,
        "generator_ntrn_debt": "0",
        "claimable_generator_astro_debt": "0",
        "generator_proxy_debt": [],
        "claimable_generator_proxy_debt": [],
        "unlock_timestamp": 1694079229,
        "astroport_lp_units": "550481715000",
        "astroport_lp_token": "neutron1l3gtxnwjuy65rzk63k352d52ad0f2sh89kgrqwczgt56jc8nmc3qh5kag3",
        "astroport_lp_transferred": null
      }
    ],
    "claimable_generator_ntrn_debt": "0",
    "lockup_positions_index": 2
  }
}

## user lockup at height

neutrond q wasm cs smart neutron1zt8m8ffpdrztjyqj0hmv8wgcz2cv3y4euk474znth4hnsn3vzaes32wtx2 '{"query_user_lockup_total_at_height": {"user_address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2", "pool_type": "USDC", "height": 266}}' --output json | jq .
{
  "data": "275240857000"
}

neutrond q wasm cs smart neutron1zt8m8ffpdrztjyqj0hmv8wgcz2cv3y4euk474znth4hnsn3vzaes32wtx2 '{"query_user_lockup_total_at_height": {"user_address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf", "pool_type": "USDC", "height": 266}}' --output json | jq .
{
  "data": "550481715000"
}

## USDC's vesting lp unclaimed amount

neutrond q wasm cs smart neutron1mzr9spaqlxq0pp34r0cahntfp3htpy8dps399aflafqwx2f6235qdhwflr '{"historical_extension": {"msg": {"unclaimed_amount_at_height": {"address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2", "height": 266}}}}' --output json | jq .
{
  "data": "275241025396"
}

neutrond q wasm cs smart neutron1mzr9spaqlxq0pp34r0cahntfp3htpy8dps399aflafqwx2f6235qdhwflr '{"historical_extension": {"msg": {"unclaimed_amount_at_height": {"address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf", "height": 266}}}}' --output json | jq .
{
  "data": "550482049792"
}

## ATOM's vesting lp unclaimed amount

neutrond q wasm cs smart neutron16y75jj4ftlcjvfa0gscnklzaj20pfe97mczpg2e8a7znyjzzafaq67dj0v '{"historical_extension": {"msg": {"unclaimed_amount_at_height": {"address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2", "height": 266}}}}' --output json | jq .
{
  "data": "870388280390"
}

neutrond q wasm cs smart neutron16y75jj4ftlcjvfa0gscnklzaj20pfe97mczpg2e8a7znyjzzafaq67dj0v '{"historical_extension": {"msg": {"unclaimed_amount_at_height": {"address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf", "height": 266}}}}' --output json | jq .
{
  "data": "1740776726780"
}
