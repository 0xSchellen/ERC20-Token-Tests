// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.15;

import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {StakeContract} from "../src/StakeContract.sol";
import {MyToken} from  "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken private _token; 

    function setUp() public {
        _token = new MyToken();
        //_token.transfer(address(alice), 1000e18);
    }

    function test_invariant_metadata() public {
        assertEq(_token.name(),     "Token");
        assertEq(_token.symbol(),   "TKN");
        assertEq(_token.decimals(), 18);
    }

    // function test_staking_tokens_fuzz(uint256 amount) public {
    //     vm.assume(amount <= myToken.totalSupply());
    //     myToken.approve(address(stakeContract), amount);
    //     bool stakePassed = stakeContract.stake(amount, address(myToken));
    //     assertTrue(stakePassed);
    // }

    // function testApproveScam() public {
    //     vm.prank(alice);
    //     ERC20Contract.approve(address(eve), type(uint256).max);
    //     console.log(
    //         "Before exploiting, Balance of Eve:", ERC20Contract.balanceOf(eve)
    //     );
    //     console.log(
    //         "Due to Alice granted transfer permission to Eve, now Eve can move funds from Alice"
    //     );
    //     vm.prank(eve);
    //     ERC20Contract.transferFrom(address(alice), address(eve), 1000);
    //     console.log(
    //         "After exploiting, Balance of Eve:", ERC20Contract.balanceOf(eve)
    //     );
    //     console.log("Exploit completed");
    // }
  


}