// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Donation {
    address public owner;
    bool private locked;

    struct Doacao {
        address donor;
        uint256 amount;
        uint256 timestamp;
    }

    Doacao[] private donations;
    mapping(address => uint256) public totalDonatedBy;

    event DonationReceived(address indexed donor, uint256 amount, uint256 timestamp);
    event Withdraw(address indexed owner, uint256 amount, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Apenas o dono pode executar");
        _;
    }

    modifier noReentrant() {
        require(!locked, "Reentrancy detected");
        locked = true;
        _;
        locked = false;
    }

    constructor() {
        owner = msg.sender;
        locked = false;
    }

    function donate() external payable {
        require(msg.value > 0, "Valor da doacao deve ser maior que zero");
        donations.push(Doacao({ donor: msg.sender, amount: msg.value, timestamp: block.timestamp }));
        totalDonatedBy[msg.sender] += msg.value;
        emit DonationReceived(msg.sender, msg.value, block.timestamp);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getDonationsCount() external view returns (uint256) {
        return donations.length;
    }

    function getDonation(uint256 index) external view returns (address donor, uint256 amount, uint256 timestamp) {
        require(index < donations.length, "Indice fora do intervalo");
        Doacao storage d = donations[index];
        return (d.donor, d.amount, d.timestamp);
    }

    function withdrawAll() external onlyOwner noReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "Saldo zero");
        (bool sent, ) = payable(owner).call{value: balance}("");
        require(sent, "Falha no envio de funds");
        emit Withdraw(owner, balance, block.timestamp);
    }

    function withdrawAmount(uint256 amount) external onlyOwner noReentrant {
        require(amount > 0, "Valor precisa ser maior que zero");
        uint256 balance = address(this).balance;
        require(amount <= balance, "Saldo insuficiente");
        (bool sent, ) = payable(owner).call{value: amount}("");
        require(sent, "Falha no envio de funds");
        emit Withdraw(owner, amount, block.timestamp);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Endereco invalido");
        owner = newOwner;
    }

    receive() external payable {
        donations.push(Doacao({ donor: msg.sender, amount: msg.value, timestamp: block.timestamp }));
        totalDonatedBy[msg.sender] += msg.value;
        emit DonationReceived(msg.sender, msg.value, block.timestamp);
    }
}
