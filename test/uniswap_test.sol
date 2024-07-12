// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {TestUniswap} from "../src/TestUniswap.sol"; // Adjust the import path as needed
import {IERC20} from "../src/IERC20.sol"; // Adjust the import path as needed

contract SwapTest is Test {
    TestUniswap private testUniswap;
    IERC20 private dai;
    IERC20 private wbtc;

    address private constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant DAI_WHALE = 0x517F9dD285e75b599234F7221227339478d0FcC8;

    function setUp() public {
        // Fork mainnet and set block number for consistency
        vm.createSelectFork("https://mainnet.infura.io/v3/a9a593ef70764d6481834348695ce8ca", 16100000);

        testUniswap = new TestUniswap();
        dai = IERC20(DAI);
        wbtc = IERC20(WBTC);

        // Prank as DAI whale to transfer DAI to the test contract
        vm.startPrank(DAI_WHALE);
        uint256 amountIn = 1e18; // 1 DAI (assuming 18 decimals)
        uint256 daiBalance = dai.balanceOf(DAI_WHALE);
        require(daiBalance >= amountIn, "Insufficient DAI balance in whale account");
        dai.transfer(address(this), amountIn);
        vm.stopPrank();
    }

    function testSwap() public {
        uint256 amountIn = 1e18; // 1 DAI (assuming 18 decimals)
        uint256 amountOutMin = 1; // Minimum acceptable output amount
        address to = address(this); // Send the output tokens to the test contract

        vm.startPrank(DAI_WHALE);

        dai.approve(address(testUniswap), amountIn);
        testUniswap.swap(DAI, WBTC, amountIn, amountOutMin, to);

        vm.stopPrank();

        uint256 wbtcBalance = wbtc.balanceOf(to);
        emit log_named_uint("WETH Balance after swap", wbtcBalance);
        assertGe(wbtcBalance, amountOutMin, "WETH amount received is less than minimum expected");
    }
}
