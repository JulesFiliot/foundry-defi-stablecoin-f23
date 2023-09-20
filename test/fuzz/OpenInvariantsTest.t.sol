// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.18;

// import {Test} from "forge-std/Test.sol";
// import {StdInvariant} from "forge-std/StdInvariant.sol";
// import {DeployDSC} from "../../script/DeployDSC.s.sol";
// import {DSCEngine} from "../../src/DSCEngine.sol";
// import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
// import {HelperConfig} from "../../script/HelperConfig.s.sol";
// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// contract OpenInvariantTest is StdInvariant, Test {
//     DeployDSC deployer;
//     DSCEngine dscEngine;
//     DecentralizedStableCoin dsc;
//     HelperConfig config;
//     address weth;
//     address wbtc;

//     function setUp() external {
//         deployer = new DeployDSC();
//         (dsc, dscEngine, config) = deployer.run();
//         (,, weth, wbtc,) = config.activeNetworkConfig();
//         targetContract(address(dscEngine));
//     }

//     function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {
//         uint256 totalSupply = dsc.totalSupply();
//         uint256 totalWETHDeposited = IERC20(weth).balanceOf(address(dscEngine));
//         uint256 totalWBTCDeposited = IERC20(wbtc).balanceOf(address(dscEngine));

//         uint256 totalWETHDepositedUsd = dscEngine.getUsdValue(weth, totalWETHDeposited);
//         uint256 totalWBTCDepositedUsd = dscEngine.getUsdValue(wbtc, totalWBTCDeposited);

//         assert(totalWETHDepositedUsd + totalWBTCDepositedUsd >= totalSupply);
//     }
// }
