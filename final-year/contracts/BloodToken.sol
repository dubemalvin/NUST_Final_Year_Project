// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract BloodToken is ERC20, ERC20Burnable, ERC20Capped {
  address payable public   owner;

  modifier onlyOwner() {
    require(msg.sender == owner, "Not the owner");
    _;
  }

  constructor() ERC20("BloodToken", "BT") ERC20Capped(100000000 * 10**decimals()) {
        owner = payable(msg.sender);
        _mint(owner, 70000000 * 10**decimals()); 
    }

  function _update(address from, address to, uint256 value) internal virtual override(ERC20Capped, ERC20) {
    super._update(from, to, value);
  }

  function burnFrom(address account, uint256 amount) public onlyOwner override(ERC20Burnable){
    require(account != address(0), "Invalid account address");
    require(amount > 0, "Amount must be greater than 0");
    _burn(account, amount); // Burn tokens from the specified account
  }

  function sendToken(address _recipient, uint256 _amount) external {
    require(_recipient != address(0), "Invalid recipient address");
    require(_amount > 0, "Amount must be greater than 0");

    _transfer(owner, _recipient, _amount);
  }
}
