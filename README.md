# Decentralized On-Chain Governance and Voting Platform

This repository implements a fully functional decentralized autonomous organization (DAO) governance platform. It features an OpenZeppelin Governor integrated with an ERC20Votes token, supporting both Standard (1 Token = 1 Vote) and Quadratic (QV) voting mechanisms.

## Project Structure
- `contracts/`: Solidity smart contracts (`GovernanceToken.sol` and `MyGovernor.sol`).
- `scripts/`: Hardhat deployment scripts.
- `test/`: Comprehensive test suite for the proposal lifecycle and voting mechanisms.
- `frontend/`: Next.js web application for interacting with the governance system.
- `docker-compose.yml`: Fully orchestrates the Hardhat test node and the Next.js frontend.

## Features
- **ERC-20 Governance Token**: Supports snapshotting and delegation.
- **Governor Contract**: Manages proposals, voting periods, and quorum thresholds.
- **Dual Voting Mechanisms**: Execute standard or quadratic proposals seamlessly depending on the proposal creation type.
- **Frontend Dashboard**: Connect your wallet, create proposals, cast votes, and track your voting power.

## Smart Contract Details
- **Token Config**: Initially mints 1,000,000 GT to the deployer.
- **Quorum**: 4% of the total token supply at the snapshot block.
- **Voting Delay**: 1 Block.
- **Voting Period**: 50,400 Blocks (~1 week).
- **Proposal Threshold**: 100 GT required to sumbit a proposal.
- **Quadratic Logic**: The contract calculates `sqrt(weight)` where token balances represent raw vote "weight."

## Instructions to Run
1. Rename `.env.example` to `.env` and fill in any network variables if deploying to a live testnet. No changes are required for local testing.
2. Ensure Docker Desktop is running.
3. Start the entire stack with a single command:
   ```bash
   docker-compose up -d --build
   ```
4. Access the frontend dashboard at `http://localhost:3000`.

## Interacting Locally
1. The containerized Hardhat node will start with 20 pre-funded test accounts on `127.0.0.1:8545`.
2. Connect MetaMask and add a custom network pointing to the RPC URL above (Chain ID `1337`).
3. Import the private keys printed in the Hardhat terminal to interact using the pre-funded accounts.
4. Delegate your tokens to activate your voting power.
5. Create proposals and participate in standard or quadratic DAO voting!
