// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract TransferScript is Script {
    address ownerAddress;
    address nftContractAddress = 0x46A797C81379D77bbed8ea4BdBF1Ce62557e03Fb;

    function setUp() public {
        ownerAddress = vm.envAddress("OWNER");
    }

    function run() external {
        vm.startBroadcast();
        ERC20 myToken = ERC20(payable(nftContractAddress));
        myToken.transfer(0x40C8e86802624bBcC5C4feFE49145c5C9843ffDe, 100_000000000000000000);
        vm.stopBroadcast();
    }
}
