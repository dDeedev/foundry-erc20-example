// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract TransferScript is Script {
    address ownerAddress;
    address nftContractAddress;
    address receiver;
    uint64 currentNonce;

    function setUp() public {
        ownerAddress = vm.envAddress("OWNER");
        receiver = vm.envAddress("RECIPIENT_ADDRESS");
        nftContractAddress = vm.envAddress("TOKEN_ADDRESS");
        currentNonce = vm.getNonce(ownerAddress);
    }

    function run() external {
        vm.startBroadcast();
        ERC20 myToken = ERC20(payable(nftContractAddress));

        myToken.transfer(receiver, 100000_000000000000000000);
        nonceUp();

        myToken.transfer(receiver, 100000_000000000000000000);
        nonceUp();

        myToken.transfer(receiver, 100000_000000000000000000);
        vm.stopBroadcast();
    }

    function nonceUp() public {
        vm.setNonce(ownerAddress, currentNonce + uint64(1));
        currentNonce++;
    }
}
