CREATE DATABASE gatilho;
USE gatilho;

CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    valor_unitario DECIMAL(10,2),
    dt_validade DATE NOT NULL,
    estoque INT NOT NULL DEFAULT 0
);

CREATE TABLE vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    data_venda DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    caixa_registrador INT NOT NULL
);

CREATE TABLE itensVendidos (
    id_ItemVendido INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_produto FOREIGN KEY (id_produto) REFERENCES produtos(id_produto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_venda FOREIGN KEY (id_venda) REFERENCES vendas(id_venda) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO produtos (nome, valor_unitario, dt_validade, estoque) VALUES 
('leite', 4.95, '2023-11-27', 100), 
('café', 18.95, '2024-02-20', 30),
('bolachas', 5.00, '2024-01-31', 40);

INSERT INTO vendas (data_venda, valor_total, caixa_registrador) VALUES 
('2022-11-27', 0.00, 1), 
('2022-11-27', 0.00, 2);

INSERT INTO itensVendidos VALUES 
(1, 1, 1, 12, 4.95), 
(2, 1, 2, 12, 18.95), 
(3, 1, 3, 3, 5.00);

DELIMITER //

CREATE TRIGGER tgrInserirItensVendidos 
AFTER INSERT ON itensVendidos 
FOR EACH ROW 
BEGIN
    UPDATE produtos  
    SET estoque = estoque - NEW.quantidade 
    WHERE id_produto = NEW.id_produto;

    UPDATE vendas  
    SET valor_total = valor_total + (NEW.quantidade * NEW.valor_unitario) 
    WHERE id_venda = NEW.id_venda;
END;
//

DELIMITER ;

SELECT * FROM produtos; 
SELECT * FROM vendas; 
SELECT * FROM itensVendidos;

INSERT INTO itensVendidos VALUES (4,1,3, 1 , 4.44); 

SELECT * FROM produtos; 
SELECT * FROM vendas; 
SELECT * FROM itensVendidos;

DELIMITER //

CREATE TRIGGER tgrItensVendidoRemovidos 
AFTER DELETE ON itensVendidos 
FOR EACH ROW 
BEGIN
    UPDATE produtos  
    SET estoque = estoque + OLD.quantidade 
    WHERE id_produto = OLD.id_produto;

    UPDATE vendas  
    SET valor_total = valor_total - (OLD.quantidade * OLD.valor_unitario) 
    WHERE id_venda = OLD.id_venda;
END;
//

DELIMITER ;

SELECT * FROM produtos; 
SELECT * FROM vendas; 
SELECT * FROM itensVendidos;

DELETE FROM itensVendidos WHERE id_ItemVendido = 1;

SELECT * FROM produtos; 
SELECT * FROM vendas; 
SELECT * FROM itensVendidos;

DROP DATABASE gatilho;