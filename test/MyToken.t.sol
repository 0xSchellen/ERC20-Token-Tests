// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.15;

import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {StakeContract} from "../src/StakeContract.sol";
import {MyToken} from  "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken private token; 
    address private sender;
    address private wallet;

    address private alice = address(0x1);
    address private bob = address(0x2);

    function setUp() public {
        // name, symbol, initialSupply
        token = new MyToken("Token", "TKN");

        wallet =  address(this);
        sender =  address(msg.sender);

        token.mint(wallet,  1_000_000e18);

        console.log("Token  ", address(token), token.balanceOf(address(token)));
        console.log("Wallet ", address(wallet), token.balanceOf(address(wallet)));
        console.log("Sender ", address(sender), token.balanceOf(address(sender)));
    }

    function test_invariant_metadata() public {
        assertEq(token.name(),     "Token");
        assertEq(token.symbol(),   "TKN");
        assertEq(token.decimals(), 18);
    }

    function test_fuzz_metadata(string memory name, string memory symbol) public {
        MyToken mockToken = new MyToken(name, symbol);
        assertEq(mockToken.name(),     name);
        assertEq(mockToken.symbol(),   symbol);
        assertEq(mockToken.decimals(), 18);
    }

    function test_initial_supply() public {
        assertEq(token.totalSupply(), 1_000_000e18);
    }

    function testFuzz_mint(address account, uint256 amount) public {

        vm.assume(account != address(0x0));
        // Assume totalSupply() máx = 1_000_000e18
        vm.assume(amount <= (1_000_000e18 - token.totalSupply()));

        uint256 initialBalance = token.balanceOf(account);
        uint256 initialTotalSupply = token.totalSupply();

        vm.prank(wallet);
        //vm.prank(alice);
        token.mint(account, amount);

        assertEq(token.totalSupply(), (initialTotalSupply + amount));
        assertEq(token.balanceOf(account), (initialBalance + amount));
    }

    function test_transfer() public {
        vm.prank(wallet);
        token.transfer(address(alice), 1_000e18);
        token.transfer(address(bob), 1_000e18);

        vm.prank(alice);
        token.transfer(address(bob),500e18);
        token.balanceOf(alice);
        assertEq(token.balanceOf(alice), 500e18);
        assertEq(token.balanceOf(bob), 1_500e18);
    }

    function test_fuzz_transfer(uint amountToAlice, uint amountToBob) public {
        vm.prank(wallet);
        vm.assume(amountToAlice < token.totalSupply());
        vm.assume(amountToBob < (token.totalSupply() - amountToAlice));

        // Make Initial transfer from owner to alice and bob accounts
        token.transfer(address(alice), amountToAlice);
        token.transfer(address(bob), amountToBob);
        assertEq(token.balanceOf(alice), (amountToAlice));
        assertEq(token.balanceOf(bob), (amountToBob));

        // Record balances
        uint256 aliceBalance = token.balanceOf(alice);
        uint256 bobBalance = token.balanceOf(bob);

        // Alice make a token value transfer to Bob (10% of alice´s balance)
        vm.prank(alice);
        uint256 newTransferToBob = (aliceBalance / 10);
        token.transfer(address(bob), newTransferToBob);

        // Resulting balances are checked
        assertEq(token.balanceOf(alice), (aliceBalance - newTransferToBob));
        assertEq(token.balanceOf(bob), (bobBalance + newTransferToBob ));
    }
}