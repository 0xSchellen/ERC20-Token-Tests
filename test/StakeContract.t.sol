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
    }

    function test_staking_tokens_fuzz(uint256 amount) public {
        vm.assume(amount <= myToken.totalSupply());
        myToken.approve(address(stakeContract), amount);
        bool stakePassed = stakeContract.stake(amount, address(myToken));
        assertTrue(stakePassed);
    }
}