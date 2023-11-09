// migrate reserve
neutrond tx wasm execute neutron13we0myxwzlpx8l5ark8elw5gj5d59dl6cjkzmt80c5q5cv5rt54qvzkv2a '{"migrate_from_xyk_to_cl": {}}' --keyring-backend=test --from=demowallet1 --chain-id=neutron-1 --gas auto --gas-adjustment 1.5 --gas-prices 0.025untrn  --broadcast-mode=block


// migrate usdc pool (execute 3 times: 2 succes & migration iscomplete err)
neutrond tx wasm execute neutron1kkwp7pd4ts6gukm3e820kyftz4vv5jqtmal8pwqezrnq2ddycqasr87x9pneutron1kkwp7pd4ts6gukm3e820kyftz4vv5jqtmal8pwqezrnq2ddycqasr87x9p '{"migrate_liquidity": {}}' --keyring-backend=test --from=demowallet1 --chain-id=neutron-1 --gas auto --gas-adjustment 1.5 --gas-prices 0.025untrn  --broadcast-mode=block


// migrate atom pool (execute 3 times: 2 succes & migration iscomplete err)
neutrond tx wasm execute neutron13we0myxwzlpx8l5ark8elw5gj5d59dl6cjkzmt80c5q5cv5rt54qvzkv2a '{"migrate_liquidity": {}}' --keyring-backend=test --from=demowallet1 --chain-id=neutron-1 --gas auto --gas-adjustment 1.5 --gas-prices 0.025untrn  --broadcast-mode=block


// migrate lockdrop liquidity
neutrond tx wasm execute neutron1ryhxe5fzczelcfmrhmcw9x2jsqy677fw59fsctr09srk24lt93eszwlvyj '{"migrate_from_xyk_to_cl": {"migrate_liquidity": {}}}' --keyring-backend=test --from=demowallet1 --chain-id=neutron-1 --gas auto --gas-adjustment 1.5 --gas-prices 0.025untrn  --broadcast-mode=block


// migrate lockdrop users (execute 3 times: till you get an error)
neutrond tx wasm execute neutron1ryhxe5fzczelcfmrhmcw9x2jsqy677fw59fsctr09srk24lt93eszwlvyj '{"migrate_from_xyk_to_cl": {"migrate_users": {"limit":1}}}' --keyring-backend=test --from=demowallet1 --chain-id=neutron-1 --gas auto --gas-adjustment 1.5 --gas-prices 0.025untrn  --broadcast-mode=block
