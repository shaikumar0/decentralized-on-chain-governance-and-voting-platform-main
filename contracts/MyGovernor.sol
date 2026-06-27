// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";

contract MyGovernor is Governor, GovernorCountingSimple, GovernorVotes, GovernorVotesQuorumFraction {
    
    // Enum to represent voting mechanism
    enum VotingType { Standard, Quadratic }
    
    // Mapping from proposalId to VotingType
    mapping(uint256 => VotingType) public proposalVotingTypes;

    constructor(IVotes _token)
        Governor("MyGovernor")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4) // 4% quorum
    {}

    // Override the core propose function to accept an extra parameter (VotingType)
    // To maintain compatibility, we use the custom propose function and wrap the original.
    
    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description,
        VotingType votingType
    ) public returns (uint256) {
        uint256 proposalId = super.propose(targets, values, calldatas, description);
        proposalVotingTypes[proposalId] = votingType;
        return proposalId;
    }

    // Standard voting delay (e.g., 1 block for fast testing)
    function votingDelay() public pure override returns (uint256) {
        return 1; // 1 block
    }

    // Standard voting period (e.g., 50400 blocks ~ 1 week)
    function votingPeriod() public pure override returns (uint256) {
        return 50400; // 1 week in blocks if 1 block = 12s
    }

    // Minimum voting power required to create a proposal
    function proposalThreshold() public pure override returns (uint256) {
        return 100e18; // requires 100 GT to propose
    }

    // Custom vote counting logic for Standard vs Quadratic
    // Note: OpenZeppelin Governor expects _countVote to be overridden if custom counting is needed.
    function _countVote(
        uint256 proposalId,
        address account,
        uint8 support,
        uint256 weight,
        bytes memory params
    ) internal override(Governor, GovernorCountingSimple) returns (uint256) {
        VotingType vType = proposalVotingTypes[proposalId];
        uint256 effectiveWeight;

        if (vType == VotingType.Standard) {
            effectiveWeight = weight;
        } else if (vType == VotingType.Quadratic) {
            effectiveWeight = sqrt(weight);
        } else {
            revert("Invalid VotingType");
        }

        return super._countVote(proposalId, account, support, effectiveWeight, params);
    }

    // Helper to calculate square root
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }


}
