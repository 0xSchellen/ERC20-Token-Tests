// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.15;

import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {StakeContract} from "../src/StakeContract.sol";
import {MyToken} from  "../src/MyToken.sol";

contract StakeContractTest is Test {
    StakeContract public stakeContract;
    MyToken public myToken; 

    function setUp() public {
        stakeContract = new StakeContract();
        myToken = new MyToken("Token", "TKN");
    }

    function test_staking_tokens_fuzz(uint256 amount) public {
        vm.assume(amount <= myToken.totalSupply());
        myToken.approve(address(stakeContract), amount);
        bool stakePassed = stakeContract.stake(amount, address(myToken));
        assertTrue(stakePassed);
    }
}