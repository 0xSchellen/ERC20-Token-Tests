// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.15;

import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {StakeContract} from "../src/StakeContract.sol";
import {MockERC20} from  "../src/MockERC20.sol";

contract StakeContractTest is Test {
    StakeContract public stakeContract;
    MockERC20 public myToken; 

    function setUp() public {
        stakeContract = new StakeContract();
        myToken = new MockERC20("Token", "TKN");
        myToken.mint(address(this),  1_000_000e18);
    }

    function test_staking_tokens_fuzz(uint256 amount) public {
        vm.assume(amount <= myToken.totalSupply());
        vm.assume(amount != 0);
        myToken.approve(address(stakeContract), amount);
        bool stakePassed = stakeContract.stake(amount, address(myToken));
        assertTrue(stakePassed);
    }
}