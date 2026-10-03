create schema if not exists `ecommerce`;
use ecommerce;

-- criação de tabelas
create table Cliente(
id_cliente int not null auto_increment primary key,
email varchar(100) null,
senha varchar(30) null,
telefone varchar(12) null,
data_cadastro date null
);

create table tipo_cliente(
idCategoria_cliente int not null auto_increment,
nome varchar(255) not null,
primary key (idCategoria_cliente)
);

create table Categoria(
id_categoria int not null auto_increment,
descricao varchar(255) not null,
primary key(id_categoria)
);

create table Fornecedor(
id_fornecedor int not null auto_increment,
razao_social varchar(100) not null,
cnpj char(14) null,
telefone varchar(20) null,
email varchar(100) null,
primary key(id_fornecedor)
);

create table Terceiro(
id_terceiro int not null auto_increment,
nome varchar(100) null,
cnpj char(14) null,
email varchar(100) null,
primary key (id_terceiro)
);

create table Produto_terceiro(
idProduto_terceiro int not null auto_increment,
id_terceiro int not null,
primary key(idProduto_terceiro),
constraint fk_Produto_terceiro_terceiro
	foreign key(id_terceiro)
    references Terceiro(id_terceiro)
    on delete restrict
    on update cascade
  );
  
create table Cliente_PF(
idCliente_PF int not null auto_increment,
cpf char(11) null,
nome_completo  varchar(100) null,
data_nascimento date null,
Cliente_id_cliente int not null,
Cliente_tipo_cliente_idCategoria_cliente int not null,
primary key(idCliente_PF),
constraint fk_Cliente_PF_Cliente1
	foreign key(Cliente_id_cliente)
    references Client(id_cliente)
    on delete no action on update no action,
constraint fk_Cliente_PF_tipo_cliente1
	foreign key(Cliente_tipo_cliente_idCategoria_cliente)
    references tipo_cliente(idCategoria_cliente)
    on delete no action on update no action
    );

create table Cliente_PJ(
idCliente_PJ int not null auto_increment,
cnpj char(14) null,
razao_social varchar(100) null,
nome_fantasia varchar(45) null,
Cliente_id_cliente int not null,
Cliente_tipo_cliente_idCategoria_cliente int not null,
primary key(idCliente_PJ),
constraint fk_Cliente_PJ_Cliente1
	foreign key(Cliente_id_cliente)
    references Cliente(id_cliente)
    on delete no action on update no action,
constraint fk_Cliente_PJ_tipo_cliente1
	foreign key(Cliente_tipo_cliente_idCategoria_cliente)
    references tipo_cliente(idCategoria_cliente)
    on delete no action on update no action
);

create table Produto(
id_produto int not null auto_increment,
nome varchar(100) null,
descricao varchar(255) null,
preco decimal(10,2) null,
peso decimal(10,2) null,
categoria varchar(45) null,
data_cadastro date null,
Categoria_id_categoria int not null,
primary key(id_produto),
constraint fk_Produto_Categoria1
	foreign key(Categoria_id_categoria)
    references Categoria(id_categoria)
    on delete no action on update no action
);

create table Estoque(
id_estoque int not null auto_increment,
quantidade int null,
localizacao varchar(45) null,
primary key(id_estoque)
);

create table Pedido(
id_pedido int not null auto_increment,
data_pedido date null,
valor_total decimal(10,2) null,
status_pedido enum('Em andamento', 'Finalizado', 'Cancelado') null default 'Em andamento',
Cliente_id_cliente int not null,
primary key(id_pedido),
constraint fk_Pedido_Cliente1
	foreign key(Cliente_id_cliente)
    references Cliente(id_cliente)
    on delete no action on update no action
);

create table Pagamento(
id_pagamento int not null auto_increment,
valor decimal(10,2) null,
forma enum('PIX', 'BOLETO', 'CARTÃO') null,
parcela int null default 1,
status_pagamento enum('Pendente', 'Pago') null,
Pedido_id_pedido int not null,
primary key(id_pagamento),
constraint fk_Pagamento_Pedido1
	foreign key(id_pagamento)
    references Pedido(id_pedido)
    on delete no action on update no action
);

create table Item_pedido(
id_itemPedido int not null auto_increment,
quantidade int null,
preco_unitario decimal(10,2) null,
Pedido_id_pedido int not null,
Produto_id_produto int not null,
primary key(id_itemPedido),
constraint fk_Item_pedido_Pedido1
	foreign key(Pedido_id_pedido)
    references Pedido(id_pedido)
    on delete no action on update no action,
constraint fk_Item_pedido_Produto1
	foreign key(Produto_id_produto)
    references Produto(id_produto)
    on delete no action on update no action
);

create table Entrega(
id_entrega int not null auto_increment,
codigo_rastreio varchar(45) null,
status_entrega varchar(45) null,
data_pedido date null,
data_prevista date null,
transportadora varchar(45) null,
Pedido_id_pedido int not null,
primary key(id_entrega),
constraint fk_Entrega_Pedido1
	foreign key(Pedido_id_pedido)
    references Pedido(id_pedido)
    on delete no action on update no action
);

create table Pagamento_Cartao(
id_pagamentoCartao int not null,
numero varchar(20) null,
validade date null,
token varchar(255) null,
Pagamento_id_pagamento int not null,
primary key(id_pagamentoCartao),
constraint fk_Pagamento_Cartao_Pagamento1
	foreign key(Pagamento_id_pagamento)
    references Pagamento(id_pagamento)
    on delete no action on update no action
);

CREATE TABLE Status_Historico( 
    idStatus_historico INT NOT NULL AUTO_INCREMENT, 
    data_hora DATETIME NULL, 
    status_anterior VARCHAR(45) NULL, 
    status_atual VARCHAR(45) NULL, 
    status_historico VARCHAR(100) NULL, 
    Pedido_id_pedido INT NULL, 
    Entrega_id_entrega INT NULL,  
    PRIMARY KEY(idStatus_historico),
    CONSTRAINT fk_status_historico_Entrega1 
        FOREIGN KEY(Entrega_id_entrega) 
        REFERENCES Entrega(id_entrega) 
        ON DELETE NO ACTION ON UPDATE NO ACTION, 
    
    CONSTRAINT fk_Status_Historico_Pedido1 
        FOREIGN KEY(Pedido_id_pedido) 
        REFERENCES Pedido(id_pedido) 
        ON DELETE NO ACTION ON UPDATE NO ACTION 
);

create table Produto_Fornecedor(
produto_id_Produto int not null,
fornecedor_id_fornecedor int not null,
primary key (Produto_id_produto, fornecedor_id_fornecedor),
constraint Produto_Fornecedor_Produto1
	foreign key(Produto_id_produto)
    references Produto(id_produto)
    on delete no action on update no action,
constraint Produto_Fornecedor_Fornecedor1
	foreign key(Fornecedor_id_fornecedor)
    references Fornecedor(id_fornecedor)
    on delete no action on update no action
);
show tables;

insert into tipo_cliente(idCategoria_cliente, nome) values
(1, 'Pessoa Física'),
(2, 'Pessoa Jurídica');

insert into categoria(id_categoria, descricao) values
(1, 'Eletrônicos'),
(2, 'Roupas e Calçacos'),
(3, 'Casa e Decoração'),
(4, 'Livros'),
(5, 'Beleza e Cuidados');
     
insert into fornecedor(id_fornecedor, razao_social, cnpj, telefone, email) values
(1,'Tech Distribuidora LTDA', '12345678000199', '11999990001', 'contato@techdist.com'),
(2, 'Moda Fashion SA', '98765432000188', '11988880002', 'vendas@modafashion.com'),
(3, 'Casa & Cia', '11223344000177', '11977770003', 'suport@casacia.com'),
(4, 'Livraria Saber', '44332211000166', '11966660004', 'pedidos@saber.com'),
(5, 'Beleza Pura Cosméticos', '55667788000155', '11955550005', 'atendimento@belezapura.com');

insert into terceiro(id_terceiro, nome, cnpj, email) values
(1, 'Marktplace Express', '11111111000111', 'express@market.com'),
(2, 'Vende Mais Online', '22222222000122', 'contato@vendemais.com');

insert into cliente(id_cliente, email, senha, telefone, data_cadastro) values
(1, 'joao.silva@gmail.com', 'senha123', '11912341234', '2024-01-15'),
(2, 'maria_oliveira@hotmail.com', 'segura456',  '11956785678', '2024-02-20'),
(3,'carlos.rodrigues@yahoo.com', 'forte798', '11990129012', '2024-03-10'),
(4, 'ana.souza@gmail.com', 'ana123', '11934563456', '2024-04-05'),
(5, 'pedro_lima@outlook.com', 'pedro456', '11978907890', '2024-05-12'),
(6, 'lucas.ferreira@gmail.com', 'lucas789', '11923452345', '2024-06-18'),
(7, 'juliana.costa@hotmail.com', 'juli123', '11967896789', '2024-07-22'),
(8, 'rafael.santos@gmail.com', 'rafa456', '11901230123', '2024-08-30'),
(9, 'camila.almeida@yahoo.com', 'cami789', '11945674567', '2024-09-14'),
(10, 'thiago.martins@gmail.com', 'thiago123', '11989018901', '2024-10-01');

insert into cliente_pf(idCliente_PF, cpf, nome_completo, data_nascimento, Cliente_id_cliente, Cliente_tipo_cliente_idCategoria_cliente) values
(1, '12345678901', 'João Silva', '1985-03-20', 1, 1),
(2, '98765432100', 'Maria Oliveira', '1992-07-10', 2, 1),
(3, '11122233344', 'Carlos Rodrigues', '1980-12-05', 3, 1),
(4, '55566677788', 'Ana Souza', '1995-01-25', 4,1),
(5, '99988877766', 'Pedro Lima', '1988-09-15', 5, 1),
(6, '44455566677', 'Lucas Ferreira', '1999-11-30', 6, 1);

insert into cliente_pj(idCliente_PJ, cnpj, razao_social, nome_fantasia, Cliente_id_cliente, Cliente_tipo_cliente_idCategoria_cliente) values
(1,'33445566000199', 'Tech Solutions Ltda', 'TechSol', 7, 2),
(2, '77889900000188', 'Construtora RJ', 'ConstRJ', 8, 2),
(3, '11223344000177', 'Serviços Gerais ME',  'Sergen', 9,2),
(4, '66778899000166', 'Logística Rápida', 'LogRap', 10, 2);

insert into produto(id_produto, nome, descricao, preco, peso, categoria, data_cadastro, Categoria_id_categoria) values
(1, 'Smartphone X', 'Tela 6.5, 128G', 1200.00, 0.200, 'Eletrônico', '2024-01-01', 1),
(2, 'Notebook Pro', '16GB RAM, SSD 512', 3500.00, 2.000, 'Eletrônico', '2024-01-10',1 ),
(3, 'Camiseta Branca', 'Algodão, G', 29.90, 0.150, 'Moda', '2024-02-01',2 ),
(4, 'Tênis Corrida', 'Amortecimento', 199.90, 0.800, 'Moda', '2024-02-15', 2),
(5, 'Sofá 3 Lugares', 'Couro Sintético', 850.00, 45.000, 'Casa', '2024-03-01', 3),
(6, 'Mesa de Jantar', 'Madeira, 6 lugares', 550.00, 30.000, 'Casa', '2024-03-20', 3),
(7, 'Livro SQL', 'Aprendendo SQL', 89.90, 0.500, 'Livros', '2024-04-01', 4),
(8, 'Livro Python', 'Introdução', 79.90, 0.400, 'Livros', '2024-04-10', 4),
(9, 'Shampoo', 'Cabelos Secos', 25.00, 0.300, 'Beleza', '2024-05-01', 5),
(10, 'Perfume Importado', '100ml', 220.00, 0.250, 'Beleza', '2024-05-15', 5);

insert into estoque(id_estoque, quantidade, localizacao) values
(1, 50, 'Prateleira A1'),
(2, 20, 'Prateleira A2'),
(3, 100, 'Prateleira B3'),
(4, 30, 'Prateleira C1'),
(5, 5, 'Estoque D4'),
(6, 8, 'estoque E2'),
(7, 40, 'Prateleira F5'),
(8, 35, 'Prateleira G1'),
(9, 60, ' Caixa 40'),
(10, 15, 'Caixa 42');

insert into pedido(id_pedido, data_pedido, valor_total, status_pedido, Cliente_id_cliente) values
(1, '2024-06-01', 1200.00, 'Finalizado', 1),
(2, '2024-06-05', 3500.00, 'Finalizado', 2),
(3, '2024-06-10', 59.80, 'Finalizado', 3),
(4, '2024-06-15', 199.90, 'Em andamento', 4),
(5, '2024-06-20', 850.00, 'Finalizado', 5),
(6, '2024-07-01', 89.90, 'Cancelado', 6),
(7, '2024-07-05', 245.00, 'Finalizado', 7),
(8, '2024-07-10', 750.00, 'Finalizado', 8),
(9, '2024-07-15', 1200.00, 'Em andamento', 9),
(10, '2024-07-20', 220.00, 'Finalizado', 10);

insert into item_pedido(id_itemPedido, quantidade, preco_unitario, Pedido_id_pedido, Produto_id_produto) values
(1, 1, 1200.00, 1, 1),
(2, 1, 3500.00, 2, 2),
(3, 2, 29.90, 3, 3),
(4, 1, 199.90, 4, 4),
(5, 1, 850.00, 5, 5),
(6, 1, 89.90, 6, 7),
(7, 1, 25.00, 7, 9),
(8, 1, 220.00, 7, 10),
(9, 1, 550.00, 8, 6),
(10, 1, 1200.00, 8, 6),
(11, 1, 220.00, 10, 10);

insert into pagamento(id_pagamento, valor, forma, parcela, status_pagamento, Pedido_id_pedido) values
(1, 1200.00, 'PIX', 1,  'Pago', 1),
(2, 3500.00, 'CARTÃO', 3, 'Pago', 2),
(3, 59.80, 'BOLETO', 1, 'Pago', 3),
(4, 199.90, 'PIX', 1, 'Pendente', 4),
(5, 850.00, 'CARTÃO', 2, 'Pago', 5),
(6, 89.90, 'CARTÃO', 1, 'Pago', 6),
(7, 245.00, 'BOLETO', 1, 'Pago', 7),
(8, 750.00, 'PIX', 1, 'Pago', 8),
(9, 1200.00, 'CARTÃO', 3, 'Pendente', 9),
(10, 220.00, 'PIX', 1, 'Pago', 10);

insert into pagamento_cartao(id_pagamentoCartao, numero, validade, token, Pagamento_id_pagamento) values
(1, '****1234', '2025-12-01', 'tok_123', 2),
(2, '****5678', '2025-06-01', 'tok_456', 4),
(3, '****9012', '2025-10-01', 'tok_789', 5),
(4, '****3456', '2026-03-01', 'tok_012', 6),
(5, '****7890', '2025-01-01', 'tok-345', 7),
(6, '****2345', '2025-09-01', 'tok_678', 9);

update pagamento_cartao
set validade = '2027-01-01'
where id_pagamentoCartao = 5;

insert into entrega(id_entrega, codigo_rastreio,status_entrega, data_pedido, data_prevista, transportadora, Pedido_id_pedido) values
(1, 'BR123456789', 'ENTREGUE', '2024-06-01', '2024-06-05', 'Correios', 1),
(2, 'BR987654321', 'ENTREGUE', '2024-06-05', '2024-06-10', 'Jadlog', 2),
(3, 'BR111222333', 'ENTREGUE', '2024-06-10', '2024-06-12', 'Correios', 3),
(4, 'BR444555666', 'EM_TRANSITO', '2024-06-15', '2024-06-20', 'Loggi', 4),
(5, 'BR777888999', 'ENTREGUE', '2024-06-20', '2024-06-25', 'Jadlog', 5),
(6, NULL, 'CANCELADO', '2024-07-01', '2024-07-05', 'Correios', 6),
(7, 'BR000111222', 'ENTREGUE', '2024-07-05', '2024-07-10', 'Loggi', 7),
(8, 'BR333444555', 'ENTREGUE', '2024-07-10', '2024-07-15', 'Correios', 8),
(9, 'BR666777888', 'AGUARDANDO', '2024-07-15', '2024-07-20', 'Jadlog', 9),
(10, 'BR999000111', 'ENTREGUE', '2024-07-20', '2024-07-25', 'Loggi', 10);

insert into status_historico(idStatus_historico, data_hora, status_anterior, status_atual, status_historico, Pedido_id_pedido, Entrega_id_entrega) values
(1, '2024-06-01 10:00:00', 'Carrinho', 'Pago', 'Pedido relalizado e pago', 1, 1),
(2, '2024-06-01 14:20:00', 'Pago', 'Em preparo', 'Separando itens', 1, 1),
(3, '2024-06-02 09:00:00', 'Em preparo', 'Enviado', 'Enviado para transportadora', 1, 1),
(4, '2024-07-93 15:25:00', 'Enviado', 'Entregue', 'Entregue ao cliente', 1, 1),
(5, '2024-07-15 10:00:00', 'Carrinho', 'Pago', 'Pagamento realizado', NULL, 4),
(6, '2024-08-01 08:34:00', 'Carrinho', 'Cancelado', 'Cliente desistiu da compra', null, 6);

update status_historico
set data_hora = '2024-07-13 15:25:00'
where idStatus_historico = 4;

insert into produto_fornecedor(produto_id_Produto, fornecedor_id_fornecedor) values
(1, 1), (2, 1),
(3, 2), (4, 2),
(5, 3), (6, 3),
(7, 4), (8, 4),
(9, 5), (10, 5);

-- Triggers para o sistemas de Ecommerce

-- 1. Trigger de Remoção de clientes
use ecommerce;

-- Tabela para armazenar clientes removidos 
create table if not exists clientes_removidos(
	id_cliente_removido int auto_increment primary key,
    id_cliente int,
    email varchar(100),
    telefone varchar(12),
    data_cadastro date,
    data_remocao datetime,
    motivo varchar(255),
    tipo_cliente varchar(20)
);

DELIMITER //

-- Trigger before delete para cliente PF
create trigger before_delete_cliente_pf
before delete on cliente_pf
for each row
begin
	-- busca informações do cliente na tabela cliente
    declare v_email varchar(100);
    declare v_telefone varchar(12);
    declare v_data_cadastro date;
    
    select email, telefone, data_cadastro
    into v_email, v_telefone, v_data_cadastro
    from cliente
    where id_cliente = old.Cliente_id_cliente;
    
    -- Registro no histórico
    insert into clientes_removidos(id_cliente, email, data_cadastro, data_remocao, motivo, tipo_cliente)
    values(
		old.cliente_id_cliente,
        v_email,
        v_telefone,
        v_data_cadastro,
        now(),
        'Cliente PF excluiu sua conta',
        'PF'
    );
    -- Não permite excluir clientes com pedidos ativos
    if exists(
		select 1 from pedido
        where Cliente_id_cliente = old.Cliente_id_cliente
        and status_pedido in ('Em andamento.')
	) then
		signal sqlstate '45000'
        set message_text = 'Não é possível excluir cliente com pedidos em andamento.';
	end if;
end //


DROP TRIGGER before_delete_cliente_pf;
DROP TRIGGER before_delete_cliente_pf;

DELIMITER $$
CREATE TRIGGER before_delete_cliente_pf
BEFORE DELETE ON cliente_pf
FOR EACH ROW
BEGIN
    DECLARE v_email VARCHAR(100);
    DECLARE v_telefone VARCHAR(12);
    DECLARE v_data_cadastro DATE;
    
    -- Busca informações do cliente
    SELECT email, telefone, data_cadastro
    INTO v_email, v_telefone, v_data_cadastro
    FROM cliente
    WHERE id_cliente = OLD.Cliente_id_cliente;
    
    -- Registro no histórico (ORDEM CORRETA da tabela)
    INSERT INTO clientes_removidos(
        data_cadastro,
        data_remocao,
        id_cliente,
        email,
        telefone,
        tipo_cliente,
        motivo
    )
    VALUES(
        v_data_cadastro,                    -- data_cadastro
        NOW(),                              -- data_remocao
        OLD.Cliente_id_cliente,            -- id_cliente
        v_email,                            -- email
        v_telefone,                         -- telefone
        'PF',                               -- tipo_cliente
        'Cliente PF excluiu sua conta'      -- motivo
    );
    
    -- Não permite excluir clientes com pedidos ativos
    IF EXISTS(
        SELECT 1 FROM pedido
        WHERE Cliente_id_cliente = OLD.Cliente_id_cliente
        AND status_pedido IN ('Em andamento.')
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível excluir cliente com pedidos em andamento.';
    END IF;
END$$
DELIMITER ;


-- 2. Trigger de atualização de preços

-- Tabela para histórico de alterações de preços de produtos
create table if not exists historico_precos_produtos(
	id_historico int auto_increment primary key,
    id_produto int,
    nome_produto varchar(100),
    preco_antigo decimal(10, 2),
    preco_novo decimal(10, 2),
    data_alteracao datetime,
    usuario varchar(100),
    motivo varchar(255)
);

DELIMITER //

-- Trigger before update para produtos
create trigger before_update_preco_produto
before update on Produto
for each row
begin

	if old.preco != new.preco then
		if new.preco < 0 then
			signal sqlstate '45000'
            set message_text = 'Preço do produto não pode ser negativo.';
		end if;
        
        if new.preco < (old.preco * 0.5) then
			signal sqlstate '45000'
            set message_text = 'Redução de preço não pode ser superior a 50%.';
		end if;
        
        insert into historico_precos_produtos(id_produto, nome_produto, preco_antigo, preco_novo, data_alteracao, usuario, motivo)
		values(old.id_produto, old.nome, old.preco, new.preco, now(), 'SISTEMA', 'Atualização de preço');
	end if;
    
    if new.categoria is null or new.categoria = '' then
		signal sqlstate '45000'
        set message_text = 'Produto deve ter uma categoria definida.';
	end if;
end //

DELIMITER ;


-- 3. Trigger de inserção de novos produtos e pedidos

-- Tabela para log de novos produtos
create table if not exists log_novos_produtos(
	id_log int auto_increment primary key,
    id_produto int,
    nome_produto varchar(100),
    preco decimal(10, 2),
    categoria varchar(45),
    data_cadastro datetime,
    usuario varchar(100)
);
drop table log_novos_produtod;

-- Tabela para log de novos pedidos
create table if not exists log_novos_pedidos(
	id_log int auto_increment primary key,
    id_pedido int,
    id_cliente int,
    valor_total decimal(10, 2),
    data_pedido datetime,
    status_pedido varchar(20),
    quantidade_itens int
);


-- Trigger After insert para novos produtos
DELIMITER //

create trigger after_insert_produto
after insert on Produto 
for each row
begin
	insert into log_novos_produtos(id_produto, nome_produto, preco, categoria, data_cadastro, usuario)
    values(new.id_produto, new.nome, new.preco, new.categoria, now(), 'SISTEMA');
    
    if new.preco > 5000 then
		insert into alerta_estoquen (produto_id, mensagem, data_alerta)
        values (new.id_produto, 'Produto com valor acima de R$ 5.000 cadastraado', now());
	end if;
end //
DELIMITER ;

-- Trigger after insert para novos pedidos
DELIMITER //

create trigger after_insert_pedido
after insert on Pedido
for each row
begin
	declare v_quantidade_itens int;
    
	select coalesce(sum(quantidade), 0) into v_quantidade_itens
	from Item_pedido
	where Pedido_id_pedido = new.id_pedido; 
        
	insert into log_novos_pedidos(id_pedido, id_cliente, valor_total, data_pedido, status_pedido, quantidade_itens)
    values(new.id_pedido, new.Cliente_id_cliente, new.valor_total, now(), new.status_pedido, v_quantidade_itens);
    
    if not exists(
		select 1 from Pedido
        where Cliente_id_cliente = new.Cliente_id_cliente
        and id_pedido != new.id_pedido
	) then
		insert into cliente_primeiro_pedido (id_cliente, data_primeiro_pedido, id_pedido)
        values (new.Cliente_id_cliente, now(), new.id_pedido);
	end if;
end //

DELIMITER ;

-- 4. Trigger para atualização de estoque

-- tabela para histórico de alterações de estoque
create table if not exists historico_estoque(
	id_historico int auto_increment primary key,
    id_estoque int,
    quantidade_anterior int,
    quantidade_nova int,
    data_alteracao datetime,
    motivo varchar(255),
    id_pedido int null
);

-- tabela para alertas de estoque baixo
create table if not exists alertas_estoque(
	id_alerta int auto_increment primary key,
    produto_id int,
    mensagem varchar(255),
    data_alerta datetime,
    resolvido boolean default false
);

-- Trigger after update para estoque

DELIMITER //

create trigger after_update_estoque
after update on Estoque
for each row 
begin 
	if old.quantidade != new.quantidade then
		insert into historico_estoque(id_estoque, quantidade_nova, data_alteracao, motivo)
        values(old.id_estoque, old.quantidade, new.quantidade, now(), 'Atualização manual');
        
        if new.quantidade < 10 and new.quantidade > 0 then
			insert into alertas_estoque(produto_id, mensagem, data_alerta)
            values(
				(select id_produto from Produto limit 1),
                concat('Estoque baixp: ', new.quantidade, ' unidades restantes.'),
                now()
            );
		end if;
		
        if new.quantidade = 0 then
			insert into alerta_estoque(produto_id, mensagem, data_alerta)
            values(
				(select id_produto from Produto limit 1),
                'PRODUTO ESGOTADO - Necessário reabastecimento.',
                now()
            );
		end if;
	end if;
end //

DELIMITER ;

-- 5. Trigger para Status de pedidos
-- Tabela para auditoria de mudanças de status de pedido
create table if not exists auditoria_status_pedido(
	id_auditoria int auto_increment primary key,
    id_pedido int,
    status_anterior varchar(45),
    status_novo varchar(45),
    data_alteracao datetime,
    usuario varchar(100)
);

-- Trigger before update para status de pedido
DELIMITER //
create trigger before_update_status_pedidos
before update on Pedido
for each row
begin
	declare v_status_pagamento varchar(20);
    
    if old.status_pedido != new.status_pedido then
    
		if old.status_pedido = 'Finalizado' and new.status_pedido = 'Cancelado' then
			signal sqlstate '45000'
			set message_text = 'Não é possível cancelar um pedido já finalizado.';
		end if;
    
		if new.status_pedido = 'Finalizado' then
			select status_pagamento into v_status_pagamento
			from Pagamento
			where Pedido_id_pedido = old.id_pedido
			limit 1;
        
			if v_status_pagamento = 'Pendente' then
				signal sqlstate '45000'
				set message_text = 'Não é possível finalizar pedido com pagamento pendente.';
			end if;
		end if;
    
		insert into auditoria_status_pedido(id_pedido, status_anterior, status_novo, data_alteracao, usuario)
		values(old.id_pedido, old.status_pedido, new.status_pedido, now(), 'SISTEMA');
	end if;

end //

DELIMITER ;


-- 6. Trigger para validação de Pagamento 
-- trigger before insert para pagamentos

DELIMITER //

create trigger before_insert_pagamento
before insert on Pagamento
for each row
begin
	
    if new.forma = 'CARTÃO' and new.parcela > 12 then
		signal sqlstate '45000'
        set message_text = 'Número máximo de parcelas é 12.';
	end if;
    
    if new.forma in ('PIX', 'BOLETO')  and new.parcela > 1 then
		signal sqlstate '45000'
        set message_text = 'PIX e BOLETO só permitem 1 parcela.';
	end if;
    
    if new.valor < 0 then
		signal sqlstate '45000'
        set message_text = 'Valor do pagamento não pode ser negativo.';
	end if;
    
    if new.status_pagamento is null then
		set new.status_pagamento = 'Pendente';
	end if;
end //

DELIMITER ;

DELIMITER //
create trigger after_update_status_pedido
after update on pedido
for each row
begin
	if old.status_pedido != new.status_pedido then
		insert  into auditoria_status_pedido(
			id_pedido,
            status_anterior,
            status_novo,
            data_alteracao,
            usuario
        )
        values(
			new.id_pedido,
            old.status_pedido,
            new.status_pedido,
            now(),
            user()
        );
	end if;
end //

DELIMITER ;

-- testando as Triggers

--  teste 1: Tentar excluir cliente com pedido em andamento (tem que dá erro)
delete from Cliente_PF where Cliente_id_cliente = 4;

-- teste 2: excluir cliente sem pedido
delete from cliente_pf where Cliente_id_cliente = 2;
DESC clientes_removidos;
select * from clientes_removidos;

-- teste 3: atualizar proço dos produtos
update produto set preco = 1500.00 where id_produto = 1;

show triggers like 'produto';

-- teste 4: tentar reduzir preço em mais de 50% (precisa dar erro)
update produto set preco = 500.00 where id_produto = 1;

-- teste 5: inserir novo produto
insert into produto(nome, descricao, peso, categoria, data_cadastro, Categoria_id_categoria)
values('tablet ultra', 'tela 10.1, 64 GB', 1800.00, 0.350, 'Eletrônicos', curdate());

select * from log_novos_produtos;

-- teste 6: atualizar status pedido
update pedido set status_pedido = 'Cancelado' where id_pedido = 6;
select * from auditoria_status_pedido;
show tables;
SHOW TABLES LIKE '%status%';
SHOW TABLES LIKE '%pedido%';
desc auditoria_status_pedido;
show columns from pedido like 'status%';
select * from  pedido where id_pedido = 6;
select id_pedido, status_pedido from pedido where id_pedido = 6;
desc cliente;
select * from auditoria_status_pedido where id_pedido = 6;

insert into cliente(email, senha, telefone, data_cadastro)
values ('tetse@gmail.com', 'senha1234', '11999999999', curdate());
select * from cliente;

-- teste 7: tentar cancelar pedido finalizado (não funcionará)
update pedido set status_pedido = 'Cancelado' where id_pedido = 1;

select * from alertas_estoque;