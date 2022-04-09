# Binance Smart Chain Private Cluster

Create a private [Binance Smart Chain](https://github.com/binance-chain/bsc) cluster and run [bep20 truffle test](https://github.com/binance-chain/canonical-upgradeable-bep20) in local docker.

## Prerequisites

- Install `make`, `docker` and `docker-compose` on your local machine. If you are using [Docker Destop](https://www.docker.com/products/docker-desktop), please make sure to set `Resources` at least `2 CPU cores` and `6GB memory`

- Edit `docker-compose.bsc.yml`:
    - set `GIT_SOURCE` point to bsc repository source (default: `https://github.com/binance-chain/bsc`).
    - set `GIT_CHECKOUT_REF` point to `(commit / branch / tag)` that you want to build (default: `master`).

- ***(Optional)***:
    - Edit `.env`, modify `BSC_CHAIN_ID` and other attributes
    - Edit `docker-compose.simple.bootstrap.yml`, modify `INIT_HOLDER_BALANCE`
    - Edit `docker-compose.cluster.bootstrap.yml`, modify `INIT_HOLDER_BALANCE`
    
## Account & Private Keys
```
Account 1: 0x434B5eB10c9796082d929D6e831B79B1F030E4fa, private key: 0xd78b5396c3b29ddd57935c98fe4c7c66436a92e2dd051f368dd009f87a45245b
Account 2: 0xC0855C5aaB9eEd3b126a50f9c7de2F804D50fcED, private key: 0x5c965a394cad7c185c01b16fe1895ebde5129847ff629d105e1e56eb3396d54b
Account 3: 0x10302962E0361c18EEaA949063a816A8f8E43a85, private key: 0x474426d694ce14163c83248054800a83e20ce517d359a9f5227d201ca6865253
Account 4: 0x7ddBf2b5c18be38E39d6347a5e0E1477348172C9, private key: 0xc9fd7fa71f8790cebc5280b6a96277532b0ce01fc30a5e11035e67adfe72623a
Account 5: 0x37E2553D4fd2bc6BCc31d44013f2E23539a4611D, private key: 0x5f55abaf1f565ca15523e993a3c51800a53e9a23acb448f302ca09423eee76b7
```
- ***(Optional)*** Below are commands to generate above account & keys from `init-holders` folder. 
    ```
    # install web3
    pip3 install web3

    # generate account & private keys from "init-holders" folder
    python3 private-key.py
    ```
    - You can add more key files (with empty decoded password) into `init-holders` folder and re-run above command.

## Simple Validator Node Cluster

- Execute below commands to build & start a simple cluster with only `1 validator` and `1 rpc` node (refer to `Makefile` for details):
    ```shell script
    # Build all docker images
    make build-simple

    # Generate genesis.json, validators & bootstrap cluster data
    # Once finished, all cluster bootstrap data are generated at ./storage
    make bootstrap-simple

    # Start cluster
    make start-simple
    ```

- Go to http://localhost:3000/ verify all nodes gradually connected to each other and block start counting.

- Run `make run-test-simple` to start bep20 truffle test.

## Three Validator Node Cluster

- Reset existing simple cluster data
    ```shell script
    make reset
    ```

- Execute below commands to build & start `3 validators` cluster with `1 rpc` node (refer to `Makefile` for details):
    ```shell script
    # Build all docker images
    make build-cluster

    # Generate genesis.json, validators & bootstrap cluster data
    # Once finished, all cluster bootstrap data are generated at ./storage
    make bootstrap-cluster

    # Start cluster
    make start-cluster
    ```

- Go to http://localhost:3000/ verify all nodes gradually connected to each other and block start counting.

- Run `make run-test-cluster` to start bep20 truffle test.

## Development Configuration
You may need to rebuild BSC docker image, reset data or start cluster with new configuration.

### [Optional] Rebuild BSC Docker Image:
- Edit `docker-compose.bsc.yml`:
- Modify `GIT_SOURCE` point to your own private repo.
- Modify `GIT_CHECKOUT_REF`  point to related (`branch` / `tags` / `commit`).
- Execute: `make build-simple` or `make build-cluster` to rebuild bsc docker

### [Optional] Reset Data:
- Execute `make reset` to remove all data
- Execute: `make bootstrap-simple` or `make bootstrap-cluster` to generate new bsc data

### [Optional] Start Cluster With New Configuration:
- Edit below config files to adjust rpc & validators options:
    - `config/config-bsc-rpc.toml`
    - `config/config-bsc-validator.toml`
- Edit below script files to adjust rpc & validators run command:
    - `scripts/bsc-rpc.sh`
    - `scripts/bsc-validator.sh`
- Finally, execute either `make start-simple` and `make start-cluster` to start

## Bootnode Configuration

The `bsc-rpc` act as a bootstrap endpoint with `config/bootstrap.key` and its corresponding `BOOTSTRAP_PUB_KEY` (as in `.env`).

If you want to generate a new `bootstrap.key` and `BOOTSTRAP_PUB_KEY`, just execute below commands:
```shell script
# this ./bootnode binary only applicable for MacOS
chmod +x ./bootnode 

# Generate bootstrap.key
./bootnode -genkey bootstrap.key

# Create a new BOOTSTRAP_PUB_KEY from bootstrap.key
./bootnode -nodekey bootstrap.key -writeaddress
```
- Then, copy `bootstrap.key` over `config` directory
- Finally, edit `.env` set `BOOTSTRAP_PUB_KEY` to new created value.
    - It will be used to construct bootnode endpoint `enode://${BOOTSTRAP_PUB_KEY}@${BOOTSTRAP_IP}:30311` for peer discovery mechanism.

# Rebuild and redeploy
```
make stop-all && make reset && git pull && make build-cluster && make bootstrap-cluster && make start-cluster
```