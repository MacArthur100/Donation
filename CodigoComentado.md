# Donation.sol

**Descrição**
Contrato Solidity simples para receber doações em ETH. Registra doações (endereço, valor, timestamp), permite consultar doações e permite ao dono sacar os fundos. Ideal para demonstrações, projetos de pequenas ONGs, artistas e criadores.

**Versão do compilador**
- Solidity ^0.8.0

## Funções
- `donate()` (payable)  
  Envia ETH e registra a doação. Não aceita valores zero.

- `getBalance() view returns (uint256)`  
  Retorna o saldo do contrato.

- `getDonationsCount() view returns (uint256)`  
  Retorna quantas doações foram registradas.

- `getDonation(uint256 index) view returns (address donor, uint256 amount, uint256 timestamp)`  
  Retorna os dados de uma doação específica por índice.

- `withdrawAll()` (onlyOwner)  
  Retira todo o saldo do contrato para o dono. Usa proteção contra reentrância.

- `withdrawAmount(uint256 amount)` (onlyOwner)  
  Retira um valor específico, se houver saldo suficiente.

- `transferOwnership(address newOwner)` (onlyOwner)  
  Transfere a propriedade do contrato para outro endereço.

- `receive()` (fallback)  
  Permite receber ETH diretamente e registra a doação.

## Como compilar & deploy (Remix)
1. Abra https://remix.ethereum.org  
2. Crie arquivo `Donation.sol` e cole o código.  
3. Em **Solidity Compiler**, escolha versão 0.8.x e compile.  
4. Em **Deploy & Run Transactions** escolha `Injected Provider - MetaMask`.  
5. Configure MetaMask para uma testnet (Sepolia recomendado) e garanta ETH de teste via faucet.  
6. Faça **Deploy** e confirme na MetaMask.

## Testes rápidos (Remix)
- No campo `value`, coloque `0.01 ether`; chame `donate()` para enviar a doação.  
- Cheque `getBalance()` para ver o saldo.  
- `getDonationsCount()` retorna quantas entradas existem.  
- `getDonation(0)` para ver a primeira doação.  
- Como owner, chame `withdrawAmount` ou `withdrawAll` para sacar.

## Observações de segurança e produção
- O contrato tem proteção simples contra reentrância (`noReentrant`) e usa `call` para transferir ETH.  
- **Para deploy em mainnet**: recomendo testes unitários (Hardhat/Foundry), revisão de segurança, e auditoria para contratos com valor real.  
- Armazenar todas as doações em array on-chain pode ser custoso em operações e gas em projetos de alto volume. Em produção, considerar emitir eventos e indexar off-chain (The Graph / backend).

## Verificação (Etherscan)
- Após o deploy, utilize a funcionalidade "Verify and Publish" no Etherscan/Testnet correspondente. Selecione o mesmo compilador e licença `MIT`, cole o código e verifique.

## Licença
MIT
