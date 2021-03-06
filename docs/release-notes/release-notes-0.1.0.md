# About this release
This release is intended to be compatible with the [aeternity epoch 0.16.0](https://github.com/aeternity/epoch/releases/tag/v0.16.0) release. It implements the aeternity protocol for that version, on-chain actions made by an epoch node can be validated and processed by an elixir node and vice versa (this includes adding spend/oracle/naming system/smart contract/state channel transactions to the mempool, propagating those transactions and added blocks to other nodes). One protocol mismatch is that smart contracts don't support operations native to the Sophia language (Solidity smart contracts are still supported).

Other documents:
[aeternity Erlang implementation compatibility](https://github.com/aeternity/elixir-node/blob/master/docs/aeternity-erlang-compatibility.md)
[detailed node usage](https://github.com/aeternity/elixir-node/blob/master/docs/detailed-usage.md)
[developer documentation](https://github.com/aeternity/elixir-node/blob/master/docs/developer-docs.md)

Please let us know if you have any problems by [opening an issue](https://github.com/aeternity/elixir-node/issues).

## Install dependencies

### Ubuntu package

The package requires a libsodium v1.0.16 as `libsodium.so.23` shared object/library.

#### Ubuntu 18.04

Ubuntu 18.04 ships with libsodium 1.0.16, thus it can be installed with `apt` package manager:

```bash
sudo apt-get install libsodium23
```

The Ubuntu release binaries are built with `libssl1.0.0` (default Ubuntu 18.04 version is 1.1) requirement that can be installed with:

```bash
sudo apt-get install libssl1.0.0
```

#### Ubuntu 16.04

As Ubuntu 16.04 ships with older libsodium version than required, it must be installed from source.
A C compiler and related tools must be installed beforehand by running:

```bash
sudo apt-get install build-essential
```

then the library:

```bash
wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz
tar -xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16
./configure && make && sudo make install && sudo ldconfig
```

## Retrieve the software for running a node
A prebuilt release is available at https://github.com/aeternity/elixir-node/releases/tag/v0.1.0
## Running your node
After unpacking the contents of `elixir-node-0.1.0-ubuntu-x86_64.tar.gz`, the node can then be started with the following commands:

* Start the node in interactive mode - `./bin/elixir_node console`
* Start the node in the background - `./bin/elixir_node start`
* Connect to the console of the node running in the background - `./bin/elixir_node attach`
* Stop the node running in the background - `./bin/elixir_node stop`
## Configuring your node
Environment variables can be set at compile time by specifying the variable and it's value, for example:
`PORT=4000 ./bin/elixir_node console`

The following environment variables can be configured:
* PORT - the port on which the Phoenix server will listen for any HTTP requests, default is `4000`
* SYNC_PORT - the port that will be used for any sync related P2P message receiving, default is `3015`
* ACCOUNTS_PATH - path to the JSON file containing any preset account balances, default is `apps/aecore/priv/genesis`
* SIGN_KEYS_PASS - the password that will be used for private key encryption/decryption, default is `secret`
* PEER_KEYS_PASS - the password that will be used for peer private key encryption/decryption, default is `secret`
* PEER_KEYS_PATH - path to the peer key files, default is `apps/aecore/priv/peerkeys`
* SIGN_KEYS_PATH - path to the sign key files, default is `apps/aecore/priv/signkeys`
* PERSISTENCE_PATH - path to Rox database, default is `apps/aecore/priv/rox_db`
