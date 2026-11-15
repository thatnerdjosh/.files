// SPDX-FileCopyrightText: 2026 thatnerdjosh
// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.20;

/// @notice Minimal contract used by tests/verify.sh to confirm that the
///         Solidity language server attaches to a Foundry project.
contract Smoke {
    function ping() external pure returns (uint256) {
        return 1;
    }
}
