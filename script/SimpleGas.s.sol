// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {SimpleGasEstimation} from "../src/SimpleGas.sol";

contract DeployGasEstimator is Script {
    function run() external returns (SimpleGasEstimation) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        SimpleGasEstimation gasContract = new SimpleGasEstimation();
        vm.stopBroadcast();
        return gasContract;
    }
}

contract TokenGasEstimationScript is Script {
    SimpleGasEstimation public estimator;
    address estimatorContract;

    IERC20 public erc20Token;
    address public recipient;
    address public owner;

    error SetupFailed(string reason);
    error EstimationFailed(string reason);
    error ExecutionFailed(string reason);
    error InsufficientBalance(uint256 requested, uint256 available);

    event GasEstimated(uint256 estimatedGas);
    event TransferExecuted(
        address from,
        address to,
        uint256 amount,
        bool isNative
    );
    event TransferAmountAdjusted(
        uint256 originalAmount,
        uint256 adjustedAmount
    );

    function setUp() public {
        estimatorContract = vm.envAddress("ESTIMATOR_ADDRESS");
        estimator = SimpleGasEstimation(estimatorContract);
        erc20Token = IERC20(vm.envAddress("TOKEN_ADDRESS"));
        recipient = vm.envAddress("RECIPIENT_ADDRESS");
        owner = vm.envAddress("OWNER");

        require(address(estimator) != address(0), "Invalid estimator address");
        require(address(erc20Token) != address(0), "Invalid token address");
        require(recipient != address(0), "Invalid recipient address");
        require(owner != address(0), "Invalid owner address");
    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        estimateAndExecuteERC20Transfer();
        vm.stopBroadcast();
    }

    function estimateAndExecuteERC20Transfer() internal {
        uint256 intendedAmount = 100 * 1e18; // 100,000 tokens with 18 decimals
        uint256 ownerBalance = erc20Token.balanceOf(estimatorContract);

        console.log(ownerBalance);

        uint256 amount;
        if (intendedAmount > ownerBalance) {
            console.log(
                "Warning: Intended amount exceeds balance. Adjusting transfer amount."
            );
            emit TransferAmountAdjusted(intendedAmount, ownerBalance);
            amount = ownerBalance;
        } else {
            amount = intendedAmount;
        }

        if (amount == 0) {
            console.log("ERC20 transfer skipped: Insufficient balance");
            return;
        }

        bytes memory data = abi.encodeWithSelector(
            IERC20.transfer.selector,
            recipient,
            amount
        );
        uint256 nonce = estimator.nonce();

        (bool success, uint256 estimatedGas) = estimator.validateAndEstimateGas(
            address(erc20Token),
            0,
            data,
            nonce
        );

        if (!success) {
            revert EstimationFailed("ERC20 gas estimation failed");
        }

        emit GasEstimated(estimatedGas);
        console.log("ERC20 Estimated Gas:", estimatedGas);

        try estimator.execute(address(erc20Token), 0, data, nonce) {
            console.log("ERC20 Transfer Executed");
            emit TransferExecuted(owner, recipient, amount, false);

            uint256 newRecipientBalance = erc20Token.balanceOf(recipient);
            console.log("ERC20 Balance of Recipient:", newRecipientBalance);
        } catch Error(string memory reason) {
            revert ExecutionFailed(reason);
        }
    }
}
