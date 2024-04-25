# SCRIPT

## Source ENV

```bash
source .env
```

## DeployScript

```bash
forge script script/DeployERC20.s.sol:DeployMyToken --rpc-url $RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --verifier-url $VERIFIER_URL --broadcast --optimize --verify
```

## TransferScript

```bash
forge script script/transferMyToken.s.sol:TransferScript --rpc-url --private-key $PRIVATE_KEY --broadcast --optimize
```
