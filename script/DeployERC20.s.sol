// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/WrappedSIX.sol";

contract DeployWrappedSIX is Script {
    function run() external returns (WrappedSIX){
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        WrappedSIX wrapsix = new WrappedSIX(1_000_000_000_000000000000000000);
        vm.stopBroadcast();
        return wrapsix;
    }
}
