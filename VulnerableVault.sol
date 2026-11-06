// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title VulnerableVault
/// @notice DELIBERATELY VULNERABLE demo fixture for the Zro x Tangle redteam demo.
///         One planted, known high/critical bug: classic reentrancy in `withdraw`
///         (external call before the balance is zeroed). Do not deploy.
/// @dev    The audit must (1) find the reentrancy, (2) write a working PoC that
///         drains the vault, (3) survive adversarial validation without downgrade.
contract VulnerableVault {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    /// @notice VULNERABLE: sends ETH before updating state, so a malicious
    ///         receiver can re-enter `withdraw` and drain every deposit.
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "insufficient balance");
        (bool ok, ) = msg.sender.call{value: amount}("");   // external call first
        require(ok, "transfer failed");
        balances[msg.sender] -= amount;                      // state update AFTER (bug)
    }

    function totalDeposits() external view returns (uint256) {
        return address(this).balance;
    }
}
