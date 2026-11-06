# vuln-vault-demo

A deliberately vulnerable Solidity vault, used as the target for a Tangle redteam
audit demo. It contains one planted high/critical bug: a classic reentrancy in
`VulnerableVault.withdraw` (external call before the balance update). Not for deployment.

The audit (Tangle Sandbox + redteam + Zro `abliterated/abyss1` through Tangle Router) must
find the reentrancy, write a working proof-of-concept that drains the vault, and pass an
adversarial validator.
