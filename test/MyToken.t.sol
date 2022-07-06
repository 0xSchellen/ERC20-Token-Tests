// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.15;

import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {StakeContract} from "../src/StakeContract.sol";
import {MyToken} from  "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken private token; 
    address private alice = address(0x1);
    address private bob = address(0x2);

    function setUp() public {
        // name, symbol, initialSupply
        token = new MyToken("Token", "TKN", 1_000_000e18);
        //console.log("Sender", address(msg.sender));
        //console.log("Token ", address(token));


        token.transfer(address(alice), 1000e18);
    }

    function test_invariant_metadata() public {
        assertEq(token.name(),     "Token");
        assertEq(token.symbol(),   "TKN");
        assertEq(token.decimals(), 18);
    }

    function testFuzz_metadata(string memory name_, string memory symbol_) public {
        MyToken mockToken = new MyToken(name_, symbol_, 1_000_000e18);
        assertEq(mockToken.name(),     name_);
        assertEq(mockToken.symbol(),   symbol_);
        assertEq(mockToken.decimals(), 18);
    }

    function test_initial_supply() public {
        assertEq(token.totalSupply(), 1_000_000e18);
    }

    function test_transfer() public {

        
        assertEq(token.totalSupply(), 1_000_000e18);
    }

    // function test_stakingtokens_fuzz(uint256 amount) public {
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