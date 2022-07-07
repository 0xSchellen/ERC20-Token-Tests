// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.15;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public onlyOwner {
        require((to != address(0x0)), "Error: Minting to the zero address");
        _mint(to, amount);
    }
}
