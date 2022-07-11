// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.15;

import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {StakeContract} from "../src/StakeContract.sol";
import {MockERC20} from  "../src/MockERC20.sol";

contract MockERC20Test is Test {
    MockERC20 private token; 

    address private alice = address(0x01);
    address private bob = address(0x02);
    address private charlie = address(0x03);
    address private wallet = address(this);

    function setUp() public {
        token = new MockERC20("Token", "TKN");

        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
        vm.label(charlie, "Charlie");
        vm.label(wallet, "Wallet");
        vm.label(address(token), "ERC20Token");

        // Initial minting
        token.mint(wallet,  1_000_000e18);

        // console.log("Initial Status: ");
        // console.log("ERC20Token ", address(token), token.balanceOf(address(token)));
        // console.log("Alice      ", address(alice), token.balanceOf(address(alice)));
        // console.log("Bob        ", address(bob), token.balanceOf(address(bob)));
        // console.log("Wallet     ", address(wallet), token.balanceOf(address(wallet)));
    }

    /* ----------- metadata() ----------- */

    function test_invariant_metadata() public {
        assertEq(token.name(),     "Token");
        assertEq(token.symbol(),   "TKN");
        assertEq(token.decimals(), 18);
    }

    function testFuzz_metadata(string memory name, string memory symbol) public {
        MockERC20 mockToken = new MockERC20(name, symbol);
        assertEq(mockToken.name(),     name);
        assertEq(mockToken.symbol(),   symbol);
        assertEq(mockToken.decimals(), 18);
    }

    /* ------------- mint() ------------- */

    function test_total_supply() public {
        // function setup already minted 1_000_000e18
        // mint additional 1_000_000e18
        token.mint(wallet,  1_000_000e18);

        assertEq(token.balanceOf(address(wallet)), 2_000_000e18);
        assertEq(token.totalSupply(), 2_000_000e18);
    }

    function testFail_mint_to_zero_address() public {
        token.mint(address(0), 1);
    }

    function test_mint_zero_value() public {
        token.mint(address(0x111), 0);
    }

    function testFuzz_mint(address account, uint256 amount) public {
        vm.assume(account != address(0x0));
        // Assume totalSupply() máx = 1_000_000e18
        vm.assume(amount <= (1_000_000e18 - token.totalSupply()));

        uint256 initialBalance = token.balanceOf(account);
        uint256 initialTotalSupply = token.totalSupply();

        token.mint(account, amount);

        assertEq(token.totalSupply(), (initialTotalSupply + amount));
        assertEq(token.balanceOf(account), (initialBalance + amount));
    }

    /* ------------- burn() ------------- */

    function testFail_burn_to_zero_address() public {
        token.burn(address(0), 1);
    }

    function testFuzz_burn(address account, uint256 amount) public {
        vm.assume(account != address(0x0));
        // Assume totalSupply() máx = 1_000_000e18
        vm.assume(amount <= (1_000_000e18 - token.totalSupply()));

        // mint initial account balance
        token.mint(account, amount);
        uint256 initialBalance = token.balanceOf(account);
        uint256 initialTotalSupply = token.totalSupply();

        // burn half of the minted tokens
        token.burn(account, amount/2);
        assertEq(token.balanceOf(account), (initialBalance - amount/2));
        assertEq(token.totalSupply(), (initialTotalSupply - amount/2));
    }

    /* ------------- transfer() ------------- */

    function test_transfer() public {
        token.transfer(address(alice), 1_000e18);
        token.transfer(address(bob), 1_000e18);

        vm.prank(alice);
        token.transfer(address(bob),500e18);
        //token.balanceOf(alice);
        assertEq(token.balanceOf(alice), 500e18);
        assertEq(token.balanceOf(bob), 1_500e18);
    }

    function testFuzz_transfer(uint amountToAlice, uint amountToBob) public {
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

    /* ------------- approve() ------------- */

    function testFuzz_approve(uint256 amount) public {
        vm.assume(amount <= 1_000_000e18);

        token.approve(alice, amount);
        assertEq(token.allowance(wallet, alice), amount);
    }

    function testFail_approve_to_address_zero() public {
        token.approve(address(0), 600e18);
    }

    function testFail_approve_from_address_zero() public {
        vm.prank(address(0x0));
        token.approve(address(alice), 600e18);
    }

    function test_approved_amount_exceeds_balance() public {
        token.transfer(address(alice), 1_000e18);
        vm.prank(alice);
        token.approve(address(bob), 1_600e18);
    }

    /* ----------- transferFrom() --------- */

        // address spender = _msgSender();
        // _spendAllowance(from, spender, amount);
        // _transfer(from, to, amount);
        // return true;

    function test_transferFrom() public {
        token.transfer(address(alice), 1_000e18);

        vm.prank(alice);
        token.approve(address(bob), 600e18);

        vm.prank(bob);
        token.transferFrom(alice, charlie, 600e18);
        assertEq(token.balanceOf(alice), 400e18);
        assertEq(token.balanceOf(charlie), 600e18);
    }


    function testFail_transferFrom_insufficient_balance() public {
        token.transfer(address(alice), 1_000e18);

        vm.prank(alice);
        token.approve(address(bob), 1_600e18);

        vm.prank(bob);
        token.transferFrom(alice, charlie, 1_600e18);
        assertEq(token.balanceOf(charlie), 1_600e18);
    }

    function testFuzz_transferFrom(address from, address to, uint256 amount) public {
        vm.assume(address(from) != address(0x0));
        vm.assume(address(to) != address(0x0));
        vm.assume(address(from) != address(to));
        vm.assume(amount < token.totalSupply());

        vm.prank(wallet);
        token.transfer(address(from), amount);

        vm.prank(from);
        token.approve(address(charlie), amount);

        vm.prank(charlie);
        token.transferFrom(from, to, amount);
        assertEq(token.balanceOf(from), 0);
        assertEq(token.balanceOf(to), amount);
    }

}