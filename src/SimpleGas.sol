// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleGasEstimation {
    address public owner;
    uint256 public nonce;

    event Executed(address target, uint256 value, bytes data);
    event ValidationResult(bool success, uint256 gasUsed);

    constructor() {
        owner = msg.sender;
    }

    function execute(
        address target,
        uint256 value,
        bytes calldata data,
        uint256 _nonce
    ) external {
        require(msg.sender == owner, "Not authorized");
        require(_nonce == nonce, "Invalid nonce");
        nonce++;

        (bool success, ) = target.call{value: value}(data);
        require(success, "Execution failed");

        emit Executed(target, value, data);
    }

    function validateAndEstimateGas(
        address target,
        uint256 value,
        bytes calldata data,
        uint256 _nonce
    ) external returns (bool, uint256) {
        uint256 startGas = gasleft();

        // Simulate validation
        require(_nonce == nonce, "Invalid nonce");
        // Here you would typically verify the signature
        // For simplicity, we're skipping actual signature verification

        // Simulate execution (without actually executing)
        (bool success, ) = target.call{gas: gasleft(), value: value}(data);

        uint256 gasUsed = startGas - gasleft();

        emit ValidationResult(success, gasUsed);
        return (success, gasUsed);
    }
}
