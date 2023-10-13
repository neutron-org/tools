# Omnibus 10 2023

1. (Optional) prepare contracts in some dir and upload with `omnibus_upload_code.sh` (optional)
2. fill `codes.env` manually or with help of p.1.
3. run `omnibus_build_proposal.sh` to build a proposal msg.

## codes required for proposal

```env
NEW_MAIN_DAO_CODE_ID=code_id
NEW_SUBDAO_CORE_ID=code_id
NEW_PROPOSAL_SINGLE_CODE_ID=code_id
NEW_SUBDAO_PROPOSAL_SINGLE_CODE_ID=code_id
NEW_PRE_PROPOSE_OVERRULE_CODE_ID=code_id
NEW_PROPOSAL_MULTIPLE_CODE_ID=code_id
NEW_SUBDAO_TIMELOCK_SINGLE_CODE_ID=code_id
NEW_VOTING_REGISTRY_CODE_ID=code_id
NEW_TGE_VESTING_GRANTS_SUBDAO_CODE_ID=code_id
NEW_SUBDAO_PREPROPOSE_SINGLE_NO_TIMELOCK_CODE_ID=code_id
```
