
# infrastructure for  IBC:
# - start gaia (docker image)
# - start hermes with config between gaia/neutron-fork
# - create connection
# - create channel

GAIA_MNEMONIC="TODO"
NEUTRON_MNEMONIC="TODO"

hermes keys add --chain gaia-1 --mnemonic-file <(echo "$GAIA_MNEMONIC")
hermes keys add --chain neutron-1 --mnemonic-file <(echo "$NEUTRON_MNEMONIC")
hermes create connection --a-chain gaia-1 --b-chain neutron-1
hermes create channel --a-chain gaia-1 --a-connection connection-0 --a-port transfer --b-port transfer
