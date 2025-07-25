# NCP: Noble Cause Pledge Contract

![Built with Clarinet](https://img.shields.io/badge/built%20with-Clarinet-24222A.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

A simple, powerful smart contract on the Stacks blockchain that allows anyone in the world to make a public, on-chain pledge to do something positive.

---

## 🌟 About The Project

The Noble Cause Pledge (NCP) contract is a decentralized application designed to foster a global sense of community and shared responsibility. It provides a transparent and immutable platform for individuals to publicly commit to actions that contribute to solving world problems, big or small.

Whether it's "I pledge to plant a tree" or "I pledge to volunteer 10 hours this month," every pledge is recorded on the blockchain, creating a permanent testament to positive intentions.

### Key Features

*   **Make a Pledge:** Commit to a positive action with a message up to 280 characters.
*   **Immutable Record:** Your pledge is secured on the Stacks blockchain, resistant to censorship or modification.
*   **Update Your Commitment:** Easily update your pledge if your goals evolve.
*   **Global Transparency:** Anyone can view any pledge, fostering accountability and inspiration.
*   **Track Collective Impact:** A public counter shows the total number of unique individuals who have joined the movement.

## 🛠️ Built With

*   [**Clarity**](https://clarity-lang.org/): The decidable smart contract language for the Stacks blockchain.
*   [**Clarinet**](https://github.com/hirosystems/clarinet): The go-to tool for Clarity smart contract development, testing, and deployment.
*   [**Stacks**](https://www.stacks.co/): The blockchain that enables smart contracts and apps on Bitcoin.

## 🚀 Getting Started
To get a local copy up and running, follow these simple steps.

### Prerequisites

You must have [Clarinet](https://github.com/hirosystems/clarinet#installation) installed.

### Installation

1.  Clone the repository:
    ```sh
    git clone https://github.com/your-username/New-Project.git
    ```
2.  Navigate to the project directory:
    ```sh
    cd New-Project
    ```

## 💻 Usage

You can easily interact with and test the contract using Clarinet.

### 1. Check the Syntax

Run the Clarinet syntax checker to ensure all contracts are valid.

```sh
clarinet check
```

### 2. Run the Tests

Execute the comprehensive test suite to verify the contract's functionality.

```sh
clarinet test
```

### 3. Interact via the Console

Open the Clarinet console to interact with the contract functions directly.

```sh
clarinet console
```

Inside the console, you can call the contract's functions:

```clarity
;; Make a new pledge from your wallet (tx-sender)
::get_assets_maps
(contract-call? .NCP make-pledge "I pledge to reduce my carbon footprint.")

;; Check the total number of pledges
::get_assets_maps
(contract-call? .NCP get-total-pledges)

;; View your own pledge
::get_assets_maps
(contract-call? .NCP get-pledge tx-sender)

;; View the pledge of another wallet (e.g., wallet_1)
::get_assets_maps
(contract-call? .NCP get-pledge .wallet_1)
```

## 📜 Smart Contract API

### Public Functions

*   `make-pledge(pledge-text: (string-utf8 280))`
    *   Creates or updates a pledge for the `tx-sender`.
    *   Asserts that the pledge text is not empty.
    *   Increments the total pledge count if it's a new pledger.

### Read-Only Functions

*   `get-pledge(who: principal)` -> `(optional (string-utf8 280))`
    *   Returns the pledge message for a given principal, or `none` if no pledge exists.
*   `get-total-pledges()` -> `(ok uint)`
    *   Returns the total number of unique pledgers.

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.