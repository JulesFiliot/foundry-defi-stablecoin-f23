// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";
import {MockV3Aggregator} from "../mocks/MockV3Aggregator.sol";

contract Handler is Test {
    DSCEngine dscEngine;
    DecentralizedStableCoin dsc;
    ERC20Mock weth;
    ERC20Mock wbtc;
    uint256 MAX_DEPOSIT_SIZE = type(uint96).max;
    address[] usersWithCollateralDeposited;
    MockV3Aggregator wethUsdPriceFeed;
    MockV3Aggregator wbtcUsdPriceFeed;

    constructor(DSCEngine _dscEngine, DecentralizedStableCoin _dsc) {
        dscEngine = _dscEngine;
        dsc = _dsc;
        address[] memory collateralTokens = dscEngine.getCollateralTokens();
        weth = ERC20Mock(collateralTokens[0]);
        wbtc = ERC20Mock(collateralTokens[1]);
        wethUsdPriceFeed = MockV3Aggregator(dscEngine.getCollateralTokenPriceFeed(address(weth)));
        wbtcUsdPriceFeed = MockV3Aggregator(dscEngine.getCollateralTokenPriceFeed(address(wbtc)));
    }

    function depositCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);
        amountCollateral = bound(amountCollateral, 1, MAX_DEPOSIT_SIZE);

        vm.startPrank(msg.sender);
        collateral.mint(msg.sender, amountCollateral);
        collateral.approve(address(dscEngine), amountCollateral);
        dscEngine.depositCollateral(address(collateral), amountCollateral);
        usersWithCollateralDeposited.push(msg.sender);
        vm.stopPrank();
    }

    function redeemCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);
        uint256 maxCollateralToRedeem = dscEngine.getCollateralBalanceOfUser(address(collateral), msg.sender);
        amountCollateral = bound(amountCollateral, 0, maxCollateralToRedeem);

        if (amountCollateral == 0) return;
        dscEngine.redeemCollateral(address(collateral), amountCollateral);
    }

    function mintDsc(uint256 amountToMint, uint256 addressSeed) public {
        if (usersWithCollateralDeposited.length == 0) return;
        address sender = usersWithCollateralDeposited[addressSeed % usersWithCollateralDeposited.length];
        (uint256 totalDscMinted, uint256 collateralInUsd) = dscEngine.getAccountInformation(sender);
        int256 maxDscToMint = (int256(collateralInUsd) / 2) - int256(totalDscMinted);

        if (maxDscToMint < 0) return;
        amountToMint = bound(amountToMint, 0, uint256(maxDscToMint));
        if (amountToMint == 0) return;
        vm.startPrank(sender);
        dscEngine.mintDsc(amountToMint);
        vm.stopPrank();
    }

    // ! This breaks the invariant => If the price drops too quickly, the protocol will be undercollateralized
    // function updateCollateralPrice(uint96 newPrice, uint256 collateralSeed) public {
    //     ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);
    //     int256 newPriceInt = int256(uint256(newPrice));
    //     if (address(collateral) == address(weth)) {
    //         wethUsdPriceFeed.updateAnswer(newPriceInt);
    //     } else {
    //         wbtcUsdPriceFeed.updateAnswer(newPriceInt);
    //     }
    // }

    // ------------------------
    // --- Helper functions ---
    // ------------------------

    function _getCollateralFromSeed(uint256 collateralSeed) private view returns (ERC20Mock) {
        if (collateralSeed % 2 == 0) {
            return weth;
        } else {
            return wbtc;
        }
    }
}
