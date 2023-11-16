# AFTER MIGRATION:

## registry's voting vaults

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_vaults": {}}' --output json | jq .
d{
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
"state": "Inactive"
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
"state": "Inactive"
},
{
"address": "neutron1j044yawg9g25p7mup6e3d86fz97wlqjdvkrujyhpv9cqv5rr6hlsh3u29r",
"name": "Vesting LP CL voting vault",
"description": "Vesting LP voting vault for CL pairs",
"state": "Active"
},
{
"address": "neutron1jvp0fvh2dna48cmv6zsah2uylm336kjqp7tc7d59gp7yklrp5sns2z0e79",
"name": "Lockdrop CL voting vault",
"description": "Lockdrop vault for CL pairs",
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
{"height": 4470215}}' --output json | jq .
{
"data": {
"power": "37646599082577",
"height": 4470215
}
}

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_power_at_height": {"address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"}}' --output json | jq .
{
"data": {
"power": "51910",
"height": 4320625
}
}

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_power_at_height":
{"address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf"}}' --output json | jq .
{
"data": {
"power": "0",
"height": 119
}
}

## historical DAO's voting power (at the same height as in the vp_before.md file)

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"total_power_at_height":
{}}' --output json | jq .
{
"data": {
"power": "38564747690178",
"height": 4321504
}
}

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_power_at_height":
{"address": "neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"}}' --output json | jq .
{
"data": {
"power": "51910",
"height": 4321348
}
}

neutrond q wasm cs smart neutron1f6jlx7d9y408tlzue7r2qcf79plp549n30yzqjajjud8vm7m4vdspg933s '{"voting_power_at_height":
{"address": "neutron10h9stc5v6ntgeygf5xf945njqq5h32r54rf7kf"}}' --output json | jq .
{
"data": {
"power": "0",
"height": 119
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
"lp_units_locked": "470167694",
"withdrawal_flag": true,
"ntrn_rewards": "2214382769",
"duration": 31104000,
"generator_ntrn_debt": "366023891",
"claimable_generator_astro_debt": "430433477",
"generator_proxy_debt": [],
"claimable_generator_proxy_debt": [],
"unlock_timestamp": 1717063200,
"astroport_lp_units": "470167694",
"astroport_lp_token": "neutron18g53drwvady7kwknjauxke0za9dscv0yjyvwska2d7wsgw2gemlsl9unw8",
"astroport_lp_transferred": null
},
{
"pool_type": "USDC",
"lp_units_locked": "30554957",
"withdrawal_flag": false,
"ntrn_rewards": "121651373",
"duration": 31104000,
"generator_ntrn_debt": "35103502",
"claimable_generator_astro_debt": "46308684",
"generator_proxy_debt": [],
"claimable_generator_proxy_debt": [],
"unlock_timestamp": 1717063200,
"astroport_lp_units": "30554957",
"astroport_lp_token": "neutron1uywpz5esk0r3z7p7vl2h3vnqlrchra5phkex76z0rh2pckun0x9q3lj7va",
"astroport_lp_transferred": null
}
],
"claimable_generator_ntrn_debt": "476742161",
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

