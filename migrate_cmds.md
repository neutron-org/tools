// migrate reserve
neutrond tx wasm execute neutron13we0myxwzlpx8l5ark8elw5gj5d59dl6cjkzmt80c5q5cv5rt54qvzkv2a '{"migrate_from_xyk_to_cl": {}}' --keyring-backend=test --from=demowallet1 --chain-id=neutron-1 --gas auto --gas-adjustment 1.5 --gas-prices 0.025untrn  --broadcast-mode=block


// migrate usdc pool (execute 3 times: 2 succes & migration iscomplete err)
neutrond tx wasm execute neutron1mzr9spaqlxq0pp34r0cahntfp3htpy8dps399aflafqwx2f6235qdhwflr '{"migrate_liquidity": {}}' --keyring-backend=test --from=demowallet1 --chain-id=neutron-1 --gas auto --gas-adjustment 1.5 --gas-prices 0.025untrn  --broadcast-mode=block


// migrate atom pool (execute 3 times: 2 succes & migration iscomplete err)
neutrond tx wasm execute neutron16y75jj4ftlcjvfa0gscnklzaj20pfe97mczpg2e8a7znyjzzafaq67dj0v '{"migrate_liquidity": {}}' --keyring-backend=test --from=demowallet1 --chain-id=neutron-1 --gas auto --gas-adjustment 1.5 --gas-prices 0.025untrn  --broadcast-mode=block


// migrate lockdrop liquidity
neutrond tx wasm execute neutron1zt8m8ffpdrztjyqj0hmv8wgcz2cv3y4euk474znth4hnsn3vzaes32wtx2 '{"migrate_from_xyk_to_cl": {"migrate_liquidity": {}}}' --keyring-backend=test --from=demowallet1 --chain-id=neutron-1 --gas auto --gas-adjustment 1.5 --gas-prices 0.025untrn  --broadcast-mode=block


// migrate lockdrop users (execute 3 times: till you get an error)
neutrond tx wasm execute neutron1zt8m8ffpdrztjyqj0hmv8wgcz2cv3y4euk474znth4hnsn3vzaes32wtx2 '{"migrate_from_xyk_to_cl": {"migrate_users": {"limit":1}}}' --keyring-backend=test --from=demowallet1 --chain-id=neutron-1 --gas auto --gas-adjustment 1.5 --gas-prices 0.025untrn  --broadcast-mode=block
