PARTE 3 – BACKUP E RECOVERY - usaremos o PowerSheel

1. Verificaremos se o MySQL está no PATH do Windows
mysql --version
mysqldump --version

2. Criar diretório para armazenar os backups
New-Item -ItemType Directory -Force -Path "C:\Backups\ecommerce"
Set-Location "C:\Backups\ecommerce"

3. Backup completo do banco de dados ecommerce (estrutura + dados)
mysqldump -u root -p `
  --databases ecommerce `
  --routines `
  --events `
  --triggers `
  --single-transaction `
  --set-gtid-purged=OFF `
  --result-file="C:\Backups\ecommerce\ecommerce_full_backup.sql"
  
4. Backup apenas da estrutura (sem dados)
mysqldump -u root -p `
  --databases ecommerce `
  --no-data `
  --routines `
  --events `
  --triggers `
  --result-file="C:\Backups\ecommerce\ecommerce_schema_only.sql"
  
5. Backup sem estrutura (apenas dados)
mysqldump -u root -p `
  --databases ecommerce `
  --no-create-info `
  --skip-triggers `
  --result-file="C:\Backups\ecommerce\ecommerce_data_only.sql"
  
6. Verificar quais bancos de dados existem no servidor
mysql -u root -p -e "SHOW DATABASES;"

7. Backup de múltiplos bancos de dados
mysqldump -u root -p `
  --databases ecommerce sakila world `
  --routines `
  --events `
  --triggers `
  --single-transaction `
  --result-file="C:\Backups\ecommerce\multiplos_bancos_backup.sql"
  
8. Backup com rotinas, eventos e procedures
mysqldump -u root -p `
  --databases ecommerce `
  --no-data `
  --routines `
  --events `
  --skip-triggers `
  --result-file="C:\Backups\ecommerce\ecommerce_routines_events.sql"
  
9.Compactação de backups
Compress-Archive -Path "C:\Backups\ecommerce\*.sql" `
                 -DestinationPath "C:\Backups\ecommerce\backup_ecommerce_$(Get-Date -Format 'yyyyMMdd_HHmmss').zip"

10. Recovery completo
Get-Content "C:\Backups\ecommerce\ecommerce_full_backup.sql" -Raw | mysql -u root -p

11. Recriando banco do zero - apenas estruturas
cmd /c "mysql -u root -p < C:\Backups\ecommerce\ecommerce_schema_only.sql"

12. Restauração apenas dos dados
cmd /c "mysql -u root -p < C:\Backups\ecommerce\ecommerce_schema_only.sql"

13. Restauração de múltiplos bancos de dados
cmd /c "mysql -u root -p < C:\Backups\ecommerce\multiplos_bancos_backup.sql"

14. Validação da Restauração
mysql -u root -p -e "USE ecommerce; SHOW TABLES; SELECT COUNT(*) AS total_clientes FROM cliente; SELECT COUNT(*) AS total_pedidos FROM pedido;"

15. Validação das Triggers 
mysql -u root -p -e "USE ecommerce; SHOW TRIGGERS; SHOW EVENTS; SHOW PROCEDURE STATUS WHERE Db='ecommerce';"

  
