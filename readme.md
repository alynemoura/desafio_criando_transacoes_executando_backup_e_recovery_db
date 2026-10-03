# Projeto: Desafio de Transações, Procedures, Backup e Recovery em MySQL 🚀

  

##  📌 Descrição do Projeto
  
Este projeto foi desenvolvido como parte de um desafio prático de banco de dados, abordando conceitos essenciais de transações, procedures com controle de erro e backup/recovery utilizando o MySQL e mysqldump.


## 📖 Sobre o Projeto

Este repositório contém a resolução de três etapas de um desafio voltado ao domínio de recursos avançados do MySQL:

1. **Transações manuais** - execução de comandos SQL com controle explícito de **COMMIT** e **ROLLBACK**, desabilitando o autocommit.

2. **Transações dentro de procedures** - implementação de uma procedure com tratamento de erros via **HANDLER**, utilizando **ROLLBACK** total ou parcial(**SAVEPOINT**).

3.**Backup e Recovery** - utilização do **mysqldump** para realizar abckup e restauração dos bancos de company e ecommerce, incluindo procedures, eventos e outros recursos.

### Observação: nas partes 1 e 2 foi utilizado o banco **company**; na parte 3, utilizamos o banco **ecommerce**.


## ⚙️ Pré-requisitos
- MySQL Server 8.0+(ou versão compatível)
- MySQL Workbench (ou outro cliente SQL)
- Acesso ao terminal com o utilitário **mysqldump** disponível
- Bancos de dados **company** e **ecommerce** previamente criados


## 🧩 Parte 1 – Transações

Objetivo: Executar modificações na base de dados por meio de trasações manuais.

## 🧩 Parte 2 – Transação com Procedure

Objetivo: Criar uma procedure que encapsula uma transação com verificação com verificação de erro, realizando **ROLLBACK** total ou parcial via **SAVEPOINT**.

##🧩 Parte 3 – Backup e Recovery

Objetivo: Realizar backup e recovery do banco de dados **ecommerce** com **mysqldump**, incluindo procedures, eventos e outros recursos.


## 🛠 Tecnologias Utilizadas
- MySQL 8.0

- mysqldump

- MySQL Workbench


👤 Autor
Desenvolvido por Aline Moura, como parte do desafio de banco de dados da Formação SQL Database Specialist, na DIO.

GitHub: @alynemoura

LinkedIn: https://www.linkedin.com/in/aomoura/?isSelfProfile=true