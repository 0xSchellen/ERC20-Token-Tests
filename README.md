# ERC20_Token_Tests

This is a suite of ERC20 Token tests using Foundry.

It is an ongoing work, made in partnership with Guilherme Boaventura.
https://github.com/guilhermeboaventurarodrigues

Its based on the tests presentede in the excellent github repos below:

https://github.com/Rari-Capital/solmate
https://github.com/OpenZeppelin/openzeppelin-contracts

https://github.com/0xPhaze/ERC721M


Suggestions and collaborations are very welcome!

0xPhaze - https://github.com/0xPhaze/ERC721M
## :briefcase: Regras de negócio:
<p><b>O valor do ticket é 500 tokens, o sorteio acontece de forma manual, quando o sorteio é feito, o ganhador fica com o valor de todos os tickets comprados.</b></p>

## :toolbox: Tecnologias utilizadas:
-  Foundry
-  Solidity

## :heavy_check_mark: Testes positivos: 14
<p>:slot_machine: Lottery</p>

- testFuzzBuyTicket(uint256 amount)
- testGiftWinner()
- testGetValueGift()

<p>:dollar: Token</p>

- testTokenName()
- testTokenSymbols()
- testTokenDecimals()
- testTotalSupply()
- testFuzzBalanceOf(addres wallet)
- testFuzzTransfer(address recipient, uint256 amount)
- testFuzzTransferFrom(address from, address to, uint256 amount)
- testFuzzApprove(address spender, uint256 amount)
- testFuzzAllowance(address ownerToken, address spender)
- testFuzzIncreaseAllowance(address spender, uint256 amount)
- testFuzzDecreaseAllowance(address spender, uint256 amount)

## :bangbang: Testes negativos: 10
<p>:slot_machine: Lottery</p>
