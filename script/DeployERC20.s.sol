// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {MyToken} from "../src/MyToken.sol";

contract DeployMyToken is Script {
    function run() external returns (MyToken) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        MyToken myToken = new MyToken(1_000_000_000_000000000000000000);
        vm.stopBroadcast();
        return myToken;
    }
}
