Crowdfunding System on Blockchain Network - Requirements Document
1. Introduction
This document outlines the requirements for developing a Crowdfunding System based on Smart Contracts on the Cardano  blockchain, as showcase application for the Emurgo Academy Aiken BuidlNOW Program. The system aims to show a step by step process of designing and developing a descentralized application (dApp) for the Crowdfunding System.

2. Overview
Learning smart contract development in the Cardano blockchain has different angles of complexity, on one axis we have the Cardano eUTxO model, on another the functional Lamda Calculus derived smart contract scripts execution environment, and, until the arrise of Aiken, a set of too complex domain specific subsets of Haskell general pourpose language. This project aims to show a guided tour on making a small but pragmatically functional showcase dApp from the pov of creating the smart contracts scripts with Aiken.

3. Objectives
- To provide a decentralized platform for crowdfunding as showcase application.
- To guarantee security for both *campaign* creators and backers.
- To facilitate the tamper-proof management of funds.
- To beware of Bad Bob (#BewareOfBadBob)

3. Functional Requirements

3.1. User Management
  -Users will identify thru their blockchain addresses.  
  -Users can be either *creators* of campaigns or *backers* of other users campaigns. 

3.2. Campaign Management
  - Campaign creators can *create*  new Campaigns, detailing objectives, funding goal, timelines.
  - Campaing creators can *cancel* created Campaings, as long as they has no backers.
<!-- (or any other condition is required, like a deadline) -->
<!-- multiple goals and milestones. -->
<!-- Campaign Dashboard: A dashboard for creators to manage and monitor their Campaigns, including fund status, backer interactions, and updates. -->
<!-- Use this as Optional HandsOn -> Milestone Management: Define and track Campaign milestones. Funds can be released based on milestone achievements. -->
3.3. Fund Management
- Escrow System: Funds are held in escrow until specific Campaign funding goal is met.
- Refund Mechanism: Allow refunds if the Campaign fails to meet its funding goal or milestones.
<!-- Optional HandsOn -> Payment Integration: Support multiple native tokens for funding Campaigns. -->

3.4 Backer Features
- Creators can not be backers.
- Backers can support a campaing in several instances.

<!-- Optional HandsOn -> Retirining Funds: Backers can take out funds according to conditinions (which?). -->
3.5. Front End App
- FE feature -> Campaign Search and Discovery: A  search and filter system to help backers find Campaigns of interest.
- FE feature -> Backer Dashboard: A personal dashboard to track pledged Campaigns, fund status, and receive updates.

1. Non-Functional Requirements

4.1 Security
Encryption: Benefits from the strong encryption and self-verification features of the Cardano blockchain.
Access Control: Control by asimetric key encription mechanism of Cardano address and their corresponding keys, managed by address/wallet.
Audit Trails: The blockchain allows to  have a detailed logs of all transactions and changes.

4.2 Reliability
Uptime: The blockchain network asures the high availability of the system.

4.4 Usability
User Interface: Design a user-friendly interface for user.

5. Technical Requirements

5.1 Blockchain Network
Platform: Cardano blockchain is the selected network, as the execution environment for Aiken created smart contracts.
Smart Contract Language: Aiken is the selected smart contract language.

5.2 Integration
Front End framework: Lucid Evolution as first choice for transaction construction on the web application.
Indexer: Blockfrost (Thru Lucid Evolution) as the service to query the blockchain.
Wallet Integration: Support integration with cardano wallets using dApp conector CiP-30 standard.

5.3 Development and Testing
Development Environment: Set up a development environment with necessary tools and frameworks.
Testing: Implement unit testing.

6. System Architechture
-- Diagram Here -- 