// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FuzzToken {
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint allowance);

    string constant public name = "FuzzToken";
    string constant public symbol = "FZT";
    uint8 constant public decimals = 18;

    uint public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    function transfer(address to, uint value) external returns (bool) {
        return _transfer(msg.sender, to, value);
    }

    function transferOneToken() external {
        balanceOf[msg.sender] += 1e18;
    }

    function transferFrom(address from, address to, uint value) external returns (bool) {
        require(allowance[from][msg.sender] >= value, "FZT: Insufficient allowance");
        allowance[from][msg.sender] -= value;
        emit Approval(from, msg.sender, allowance[from][msg.sender]);
        return _transfer(from, to, value);
    }

    function _transfer(address from, address to, uint value) private returns (bool) {
        require(balanceOf[from] >= value, "FZT: Insufficient sender balance");
        emit Transfer(from, to, value);
        balanceOf[from] -= value;
        balanceOf[to] += value;
        return true;
    }

    function approve(address spender, uint value) external returns (bool) {
        require(balanceOf[msg.sender] >= value, "FZT: Insufficient sender balance");
        emit Approval(msg.sender, spender, value);
        allowance[msg.sender][spender] += value;
        return true;
    }
}
