# BEFORE MIGRATION:

## registry's voting vaults

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_vaults": {}}'
--output json | jq .
{
"data": [
{
"address": "neutron13v3f2npattz0dw2j5f7dlwsd8v2lmcgyuv358x8pv3jec4d60hrs4x4dp7",
"name": "Grants SubDAO Vault",
"description": "Grants SubDAO Vesting Vault",
"state": "Active"
},
{
"address": "neutron1adavpfxyp5kgs3zp0n0vkc37qakeh5eqwxqxzysgg0ahlx82rmsqp4rnz8",
"name": "LP Vault",
"description": "LP Vault",
"state": "Active"
},
{
"address": "neutron1dmd56h7hlevuwssp203fgc2uh0qdtwep2m735fzksuavgq3naslqp0ehvx",
"name": "Investors Vault",
"description": "Investors Vesting Vault",
"state": "Active"
},
{
"address": "neutron1f8gs4rp232ngyta3g2efwfkznymvv85du7qm9y0mhvjxpp3cq68qgquudm",
"name": "Lockdrop Vault",
"description": "Lockdrop Contract Vault",
"state": "Active"
},
{
"address": "neutron1qeyjez6a9dwlghf9d6cy44fxmsajztw257586akk6xn6k88x0gus5djz4e",
"name": "Neutron Vault",
"description": "Vault to put NTRN tokens to get voting power",
"state": "Active"
},
{
"address": "neutron1rxwzsw37ulveefk20575mlxl3hzhzv9k46c8gklfkt4g2vk4w3tse8usrs",
"name": "CREDITS VAULT",
"description": "Credits Contract Vault",
"state": "Active"
}
]
}

## DAO's voting power

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"total_power_at_height":
{}}' --output json | jq .
{
"data": {
"power": "37646599082577",
"height": 4470215
}
}

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_power_at_height":
{"address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"}}' --output json | jq .
{
"data": {
"power": "51910",
"height": 4470237
}
}

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_power_at_height":
{"address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf"}}' --output json | jq .
{
"data": {
"power": "0",
"height": 4470252
}
}

## user info in Lockdrop

neutrond q wasm cs smart neutron1ryhxe5fzczelcfmrhmcw9x2jsqy677fw59fsctr09srk24lt93eszwlvyj '{"user_info": {"address": "neutron1tf06ek932vr8snlxjt2zq260ptrcd7pctyy3j0"}}' --output json | jq .
{
"data": {
"total_ntrn_rewards": "2336034142",
"ntrn_transferred": true,
"lockup_infos": [
{
"pool_type": "ATOM",
"lp_units_locked": "463948500",
"withdrawal_flag": true,
"ntrn_rewards": "2214382769",
"duration": 31104000,
"generator_ntrn_debt": "366023891",
"claimable_generator_astro_debt": "409553327",
"generator_proxy_debt": [],
"claimable_generator_proxy_debt": [],
"unlock_timestamp": 1717063200,
"astroport_lp_units": "463948500",
"astroport_lp_token": "neutron1jkcf80nd4pfc2krce3xk9m9y994pllq58avx89sfzqlalej4frus27ms3a",
"astroport_lp_transferred": null
},
{
"pool_type": "USDC",
"lp_units_locked": "29879000",
"withdrawal_flag": false,
"ntrn_rewards": "121651373",
"duration": 31104000,
"generator_ntrn_debt": "35103502",
"claimable_generator_astro_debt": "39313060",
"generator_proxy_debt": [],
"claimable_generator_proxy_debt": [],
"unlock_timestamp": 1717063200,
"astroport_lp_units": "29879000",
"astroport_lp_token": "neutron1sx99fxy4lqx0nv3ys86tkdrch82qygxyec5c8dxsk9raz4at5zpq48m66c",
"astroport_lp_transferred": null
}
],
"claimable_generator_ntrn_debt": "448866387",
"lockup_positions_index": 2
}
}
## user lockup at height

neutrond q wasm cs smart neutron1ryhxe5fzczelcfmrhmcw9x2jsqy677fw59fsctr09srk24lt93eszwlvyj '{"query_user_lockup_total_at_height": {"user_address": "neutron1tf06ek932vr8snlxjt2zq260ptrcd7pctyy3j0", "pool_type": "USDC", "height": 2600006}}' --output json | jq .
{
"data": "29879000"
}

## USDC's vesting lp unclaimed amount

neutrond q wasm cs smart neutron1wgzzn83hhcc5asrtslqvaw2wuqqkfulgac7ze94dmqkrxu8nsensmy9dkv '{"historical_extension": {"msg": {"unclaimed_amount_at_height": {"address": "neutron1tf06ek932vr8snlxjt2zq260ptrcd7pctyy3j0", "height": 2606000}}}}'
--output json | jq .
data: "60"

## ATOM's vesting lp unclaimed amount

neutrond q wasm cs smart neutron1kkwp7pd4ts6gukm3e820kyftz4vv5jqtmal8pwqezrnq2ddycqasr87x9p '{"historical_extension": {"msg": {"unclaimed_amount_at_height": {"address": "neutron1tf06ek932vr8snlxjt2zq260ptrcd7pctyy3j0", "height": 2000066}}}}'
--output json | jq .
data: "618390318"
--output: command not found


