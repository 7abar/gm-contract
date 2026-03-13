// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GM
/// @notice Say gm onchain. Track streaks. Top GMs win eternal respect.
/// @dev Fully onchain. No owner. No admin. Immutable vibes.
contract GM {
    struct GmRecord {
        uint256 totalGMs;
        uint256 streak;
        uint256 lastGmDay;
        uint256 longestStreak;
        uint256 firstGmAt;
    }

    mapping(address => GmRecord) public records;
    address[] public gmers;
    mapping(address => bool) public hasGmd;
    uint256 public totalGMsEver;
    uint256 public dailyGMs;
    uint256 public lastResetDay;

    event GM(address indexed who, uint256 streak, uint256 totalGMs, uint256 globalTotal);
    error AlreadyGmdToday();

    function gm() external {
        uint256 today = block.timestamp / 1 days;
        GmRecord storage r = records[msg.sender];
        if (r.lastGmDay == today) revert AlreadyGmdToday();
        if (!hasGmd[msg.sender]) {
            hasGmd[msg.sender] = true;
            gmers.push(msg.sender);
            r.firstGmAt = block.timestamp;
        }
        if (r.lastGmDay == today - 1) { r.streak++; }
        else if (r.lastGmDay < today - 1 && r.lastGmDay != 0) { r.streak = 1; }
        else { r.streak = 1; }
        if (r.streak > r.longestStreak) r.longestStreak = r.streak;
        r.totalGMs++;
        r.lastGmDay = today;
        totalGMsEver++;
        if (today > lastResetDay) { dailyGMs = 0; lastResetDay = today; }
        dailyGMs++;
        emit GM(msg.sender, r.streak, r.totalGMs, totalGMsEver);
    }

    function gmddToday(address who) external view returns (bool) {
        return records[who].lastGmDay == block.timestamp / 1 days;
    }

    function getLeaderboard(uint256 n) external view returns (address[] memory top, uint256[] memory counts) {
        uint256 len = gmers.length < n ? gmers.length : n;
        top = new address[](len);
        counts = new uint256[](len);
        address[] memory candidates = new address[](gmers.length);
        for (uint256 i = 0; i < gmers.length; i++) candidates[i] = gmers[i];
        for (uint256 i = 0; i < len; i++) {
            uint256 maxIdx = i;
            for (uint256 j = i + 1; j < candidates.length; j++) {
                if (records[candidates[j]].totalGMs > records[candidates[maxIdx]].totalGMs) maxIdx = j;
            }
            address tmp = candidates[i];
            candidates[i] = candidates[maxIdx];
            candidates[maxIdx] = tmp;
            top[i] = candidates[i];
            counts[i] = records[candidates[i]].totalGMs;
        }
    }

    function totalGmers() external view returns (uint256) { return gmers.length; }
}