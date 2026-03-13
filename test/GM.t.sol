// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {GM} from "../src/GM.sol";

contract GMTest is Test {
    GM public gmContract;
    address alice = address(0xA);
    address bob = address(0xB);
    address carol = address(0xC);

    function setUp() public { gmContract = new GM(); }

    function test_GM() public {
        vm.prank(alice);
        gmContract.gm();
        assertEq(gmContract.totalGMsEver(), 1);
    }

    function test_CannotGmTwiceToday() public {
        vm.prank(alice); gmContract.gm();
        vm.prank(alice); vm.expectRevert(GM.AlreadyGmdToday.selector); gmContract.gm();
    }

    function test_StreakBuilds() public {
        vm.prank(alice); gmContract.gm();
        vm.warp(block.timestamp + 1 days); vm.prank(alice); gmContract.gm();
        vm.warp(block.timestamp + 1 days); vm.prank(alice); gmContract.gm();
        assertEq(gmContract.records(alice).streak, 3);
        assertEq(gmContract.records(alice).longestStreak, 3);
    }

    function test_StreakBreaks() public {
        vm.prank(alice); gmContract.gm();
        vm.warp(block.timestamp + 3 days);
        vm.prank(alice); gmContract.gm();
        assertEq(gmContract.records(alice).streak, 1);
    }

    function test_Leaderboard() public {
        vm.prank(alice); gmContract.gm();
        vm.warp(block.timestamp + 1 days);
        vm.prank(alice); gmContract.gm();
        vm.prank(bob); gmContract.gm();
        (address[] memory top, uint256[] memory counts) = gmContract.getLeaderboard(2);
        assertEq(top[0], alice); assertEq(counts[0], 2);
        assertEq(top[1], bob); assertEq(counts[1], 1);
    }

    function test_GmmdToday() public {
        assertFalse(gmContract.gmddToday(alice));
        vm.prank(alice); gmContract.gm();
        assertTrue(gmContract.gmddToday(alice));
    }

    function test_UniqueGmers() public {
        vm.prank(alice); gmContract.gm();
        vm.prank(bob); gmContract.gm();
        assertEq(gmContract.totalGmers(), 2);
    }
}