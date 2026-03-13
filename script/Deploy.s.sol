// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Script, console} from "forge-std/Script.sol";
import {GM} from "../src/GM.sol";
contract DeployGM is Script {
    function run() external {
        vm.startBroadcast();
        GM g = new GM();
        console.log("GM contract deployed:", address(g));
        console.log("Say gm: cast send", address(g), '"gm()" --rpc-url https://mainnet.base.org --private-key $PK');
        vm.stopBroadcast();
    }
}