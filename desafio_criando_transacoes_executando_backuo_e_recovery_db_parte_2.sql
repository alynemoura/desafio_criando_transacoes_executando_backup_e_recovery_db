use sql_company;

-- criando a Procedure 
drop procedure if exists sp_alocar_empregado_projeto;

delimiter $$

create procedure sp_alocar_empregado_projeto(
	in p_ssn char(9),
    in p_pno int,
    in p_hours decimal(3,1),
    in p_bonus_percent decimal(5,2)
)
begin
	-- variáveis para verificação
    declare v_empregado_existe int default 0;
    declare v_projeto_existe int default 0;
    declare v_horas_totais decimal(5,1) default 0;
    declare v_salario_atual decimal(10,2) default 0;
    
    -- Handler de erro genérico - se qualquer exceção SQL ocorrer, faz o rollback total
    declare exit handler for sqlexception
    begin
		rollback;
        select 'ERRO: trasnsação cancelada por exceção SQL.' as Mensagem;
	end;
    
    -- Iniciando a transação
    start transaction;
    
    -- verifica se o empregado existe
    select count(*) into v_empregado_existe
    from employee
    where Ssn = p_ssn;
    
    if v_empregado_existe = 0 then
		rollback;
        select 'ERRO: empregado não encontrado. Transação cancelada (ROLLBACK TOTAL).' as Mensagem;
	else
    -- savepoint após confirmar que o empregado existe
		savepoint sp_empregado_ok;
        
	-- verifica se o projeto existe (erro parcial -> rollback to salveppoint)
		select count(*) into v_projeto_existe
        from project
        where Pnumber = p_pno;
        
        if v_projeto_existe = 0 then
			rollback to savepoint sp_empregado_ok;
            select 'ERRO: projeto não encontrado; ROLLBACK PARCIAL (até o savepoint).' as Mensagem;
		else
        -- savepoint após confirmar que o projeto existe 
			savepoint sp_projeto_ok;
            
		-- verifica se a soma de horarios do empregado não ultrapassa 40h
			select ifnull(sum(Hours), 0) into v_horas_totais
            from works_on
            where Essn = p_ssn;
            
            if (v_horas_totais + p_hours) > 40 then
				rollback to savepoint sp_projeto_ok;
                select 'ERRO: carga horária execederia 40h. ROLLBACK PARCIAL (até o savepoint).' as Mensagem;
			
            else 
		-- operaçõs da transação: aloca o empregado no projeto
				insert into works_on (Essn, Pno, Hours)
                values (p_ssn, p_pno, p_hours);
                
		-- aplica bonus ao salários
				select Salary into v_salario_atual
                from employee
                where Ssn = p_ssn;
                
                update employee
                set Salary = Salary * (1 + p_bonus_percent / 100)
                where Ssn = p_ssn;
                
		-- Insere um dependente 
				insert into dependent (Essn, Dependent_name, Sex, Bdate, Relationship)
                values(p_ssn, 'Novo_Beneficiario', 'F', curdate(), 'Filho');
                
		-- se tudo estiver certo, confirma
				commit;
                select 'SUCESSO: empregado alocado, salário atualizado e dependente inserido.' as Mensagem;
			end if;
		end if;
	end if;
end$$

delimiter $$;

-- Testando a Procedure
call sp_alocar_empregado_projeto('123456789', 10, 5.0, 5.0);

-- Testando rollback total
call sp_alocar_empregado_projeto('000000000', 10, 5.0, 5.0);

-- Testando projeto inexistente 
call sp_alocar_empregado_projeto('123456789', 999, 5.0, 5.0);

-- Excesso de carga horária rollback parcial 
call sp_alocar_empregado_projeto('123456789', 20, 5.0, 5.0);



