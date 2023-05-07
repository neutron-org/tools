import os
from pprint import pprint

NODE = "tcp://localhost:26657"

CHECKSUM_FILES = [
    # IMPORTANT: "neutron_dao_checksums.txt" should always be after "astroport_core_checksums.txt".
    "astroport_core_checksums.txt",
    "neutron_dao_checksums.txt",
    "astroport_ibc_checksums.txt",
    "cw_plus_checksums.txt",
    "neutron_tge_checksums.txt",
    "daodao_checksums.txt"
]

CONTRACTS_TO_CODE_IDS_FILE = "contracts_to_code_ids.txt"


def get_contract_code_checksum(code_id):
    stream = os.popen(
        """neutrond q wasm code-info %d --node %s --output json | jq ".data_hash" --raw-output""" % (code_id, NODE))
    code_hash = stream.read()
    return code_hash.strip().lower()


def main():
    checksums = {}
    contracts_to_code_ids = {}

    with open(CONTRACTS_TO_CODE_IDS_FILE) as f:
        lines = f.readlines()
        for line in lines:
            parsed_line = line.split(', ')
            contracts_to_code_ids[parsed_line[0]] = int(parsed_line[1].strip('\n'))

    for checksum_file in CHECKSUM_FILES:
        with open(checksum_file, 'r') as f:
            lines = f.readlines()
            for line in lines:
                parsed_line = line.split("  ")
                checksums[parsed_line[1].strip("\n")] = parsed_line[0].strip().lower()

    contracts_to_code_ids["cwd_voting_cw4.wasm"] = contracts_to_code_ids.pop("cw4_voting.wasm")

    for contract in contracts_to_code_ids.keys():
        contract_code_hash = get_contract_code_checksum(contracts_to_code_ids[contract])

        if contract not in checksums:
            print("[X] Can't check %s contract: there is no checksum for it in provided checksum files!" % contract)
            continue

        if contract_code_hash != checksums[contract]:
            print("[X] Checksum for contract %s is not valid: expected %s, got %s" % (contract, contract_code_hash, checksums[contract]))
            continue

        print("Checksum for contract %s is O.K." % contract)


if __name__ == "__main__":
    main()
