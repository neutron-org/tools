# AFTER MIGRATION:

## registry's voting vaults

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_vaults": {}}' --output json | jq .
{
  "data": [
    {
      "address": "neutron105ml67ymwlznz8twk2nyxu5xaqnsp2h24t50995ucp8ffu5wut7q2ewhj4",
      "name": "Lockdrop Vault",
      "description": "Lockdrop Contract Vault",
      "state": "Inactive"
    },
    {
      "address": "neutron18a60j9nfsdyscnzmylkvf7zprz9n2fuc7k83dx9c6p7jtzem6vzshan8ha",
      "name": "Vesting LP CL voting vault",
      "description": "Vesting LP voting vault for CL pairs",
      "state": "Active"
    },
    {
      "address": "neutron1hfvzfdd2lnlcwkg77e6w3jvefaesrkwh4jf6cw20e4e0g7c6asgsy7z57g",
      "name": "Lockdrop CL voting vault",
      "description": "Lockdrop vault for CL pairs",
      "state": "Active"
    },
    {
      "address": "neutron1kax2cv9793hlfz69u3x0e5c75vxcum6qupv7rdz44fdu3yeeszus6y6dkr",
      "name": "Vesting lp vault",
      "description": "A vesting lp vault",
      "state": "Inactive"
    },
    {
      "address": "neutron1qeyjez6a9dwlghf9d6cy44fxmsajztw257586akk6xn6k88x0gus5djz4e",
      "name": "Neutron Vault",
      "description": "Vault to put NTRN tokens to get voting power",
      "state": "Active"
    },
    {
      "address": "neutron1z3unpq9s5v2zp6djghwk359ya0upt6rzwpz8d48z38rxztazclfq08cww9",
      "name": "CREDITS VAULT",
      "description": "Credits Contract Vault",
      "state": "Active"
    }
  ]
}

## DAO's voting power

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"total_power_at_height": {}}' --output json | jq .
{
  "data": {
    "power": "19978417316948",
    "height": 209
  }
}

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_power_at_height": {"address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"}}' --output json | jq .
{
  "data": {
    "power": "6660028569572",
    "height": 209
  }
}

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_power_at_height": {"address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf"}}' --output json | jq .
{
  "data": {
    "power": "13318388747368",
    "height": 209
  }
}

## historical DAO's voting power (at the same height as in the vp_before.md file)

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"total_power_at_height": {"height": 119}}' --output json | jq .
{
  "data": {
    "power": "19999999997701",
    "height": 119
  }
}

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_power_at_height": {"address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2", "height": 119}}' --output json | jq .
{
  "data": {
    "power": "6666666665900",
    "height": 119
  }
}

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_power_at_height": {"address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf", "height": 119}}' --output json | jq .
{
  "data": {
    "power": "13333333331800",
    "height": 119
  }
}

## user info in Lockdrop

neutrond q wasm cs smart neutron1ryhxe5fzczelcfmrhmcw9x2jsqy677fw59fsctr09srk24lt93eszwlvyj '{"user_info": {"address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"}}' --output json | jq .
{
  "data": {
    "total_ntrn_rewards": "3347298317607",
    "ntrn_transferred": false,
    "lockup_infos": [
      {
        "pool_type": "ATOM",
        "lp_units_locked": "874329533024",
        "withdrawal_flag": false,
        "ntrn_rewards": "3044024909074",
        "duration": 259200,
        "generator_ntrn_debt": "0",
        "claimable_generator_astro_debt": "3057808532009",
        "generator_proxy_debt": [],
        "claimable_generator_proxy_debt": [],
        "unlock_timestamp": 1694079229,
        "astroport_lp_units": "874329533024",
        "astroport_lp_token": "neutron1vs2jgdhesdhtzd07kzu9sdfwh39hs4qkn9q9m80dq35mguw2e6vsp62964",
        "astroport_lp_transferred": null
      },
      {
        "pool_type": "USDC",
        "lp_units_locked": "275461668805",
        "withdrawal_flag": false,
        "ntrn_rewards": "303273408533",
        "duration": 259200,
        "generator_ntrn_debt": "0",
        "claimable_generator_astro_debt": "303516618063",
        "generator_proxy_debt": [],
        "claimable_generator_proxy_debt": [],
        "unlock_timestamp": 1694079229,
        "astroport_lp_units": "275461668805",
        "astroport_lp_token": "neutron19tq9qujlfmtwz808u4dkqgu2s0dajc907ve4gma4kgt4ymftuqvsqvzmze",
        "astroport_lp_transferred": null
      }
    ],
    "claimable_generator_ntrn_debt": "3361325150072",
    "lockup_positions_index": 2
  }
}

neutrond q wasm cs smart neutron1ryhxe5fzczelcfmrhmcw9x2jsqy677fw59fsctr09srk24lt93eszwlvyj '{"user_info": {"address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf"}}' --output json | jq .
{
  "data": {
    "total_ntrn_rewards": "6694596055764",
    "ntrn_transferred": false,
    "lockup_infos": [
      {
        "pool_type": "ATOM",
        "lp_units_locked": "1748658899297",
        "withdrawal_flag": false,
        "ntrn_rewards": "6088049237595",
        "duration": 259200,
        "generator_ntrn_debt": "0",
        "claimable_generator_astro_debt": "6115616480836",
        "generator_proxy_debt": [],
        "claimable_generator_proxy_debt": [],
        "unlock_timestamp": 1694079229,
        "astroport_lp_units": "1748658899297",
        "astroport_lp_token": "neutron1vs2jgdhesdhtzd07kzu9sdfwh39hs4qkn9q9m80dq35mguw2e6vsp62964",
        "astroport_lp_transferred": null
      },
      {
        "pool_type": "USDC",
        "lp_units_locked": "550923338611",
        "withdrawal_flag": false,
        "ntrn_rewards": "606546818169",
        "duration": 259200,
        "generator_ntrn_debt": "0",
        "claimable_generator_astro_debt": "607033237429",
        "generator_proxy_debt": [],
        "claimable_generator_proxy_debt": [],
        "unlock_timestamp": 1694079229,
        "astroport_lp_units": "550923338611",
        "astroport_lp_token": "neutron19tq9qujlfmtwz808u4dkqgu2s0dajc907ve4gma4kgt4ymftuqvsqvzmze",
        "astroport_lp_transferred": null
      }
    ],
    "claimable_generator_ntrn_debt": "6722649718265",
    "lockup_positions_index": 2
  }
}

## user lockup at height

neutrond q wasm cs smart neutron1ryhxe5fzczelcfmrhmcw9x2jsqy677fw59fsctr09srk24lt93eszwlvyj '{"query_user_lockup_total_at_height": {"user_address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2", "pool_type": "USDC", "height": 266}}' --output json | jq .
{
  "data": "275461668805"
}

neutrond q wasm cs smart neutron1ryhxe5fzczelcfmrhmcw9x2jsqy677fw59fsctr09srk24lt93eszwlvyj '{"query_user_lockup_total_at_height": {"user_address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf", "pool_type": "USDC", "height": 266}}' --output json | jq .
{
  "data": "550923338611"
}

## USDC's vesting lp unclaimed amount

neutrond q wasm cs smart neutron1wgzzn83hhcc5asrtslqvaw2wuqqkfulgac7ze94dmqkrxu8nsensmy9dkv '{"historical_extension": {"msg": {"unclaimed_amount_at_height": {"address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2", "height": 266}}}}' --output json | jq .
{
  "data": "275483312392"
}

neutrond q wasm cs smart neutron1wgzzn83hhcc5asrtslqvaw2wuqqkfulgac7ze94dmqkrxu8nsensmy9dkv '{"historical_extension": {"msg": {"unclaimed_amount_at_height": {"address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf", "height": 266}}}}' --output json | jq .
{
  "data": "550949816905"
}

## ATOM's vesting lp unclaimed amount

neutrond q wasm cs smart neutron1kkwp7pd4ts6gukm3e820kyftz4vv5jqtmal8pwqezrnq2ddycqasr87x9p '{"historical_extension": {"msg": {"unclaimed_amount_at_height": {"address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2", "height": 266}}}}' --output json | jq .
{
  "data": "874938585246"
}

neutrond q wasm cs smart neutron1kkwp7pd4ts6gukm3e820kyftz4vv5jqtmal8pwqezrnq2ddycqasr87x9p '{"historical_extension": {"msg": {"unclaimed_amount_at_height": {"address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf", "height": 266}}}}' --output json | jq .
{
  "data": "1749400609809"
}
