-- Banco de Dados:

CREATE DATABASE CafeteriaBomGosto;

-- Tabela Comanda:

CREATE TABLE Comanda(
	id_comanda INT PRIMARY KEY NOT NULL,
	data DATE NOT NULL,
	nr_mesa INT NOT NULL,
	nome_cliente VARCHAR(100) NOT NULL
);

-- Tabela Cardápio:

CREATE TABLE Cardapio (
	id_cardapio INT PRIMARY KEY NOT NULL,
	nome_item VARCHAR(100) UNIQUE NOT NULL,
	descricao TEXT,
	preco_unitario DECIMAL (10, 2) NOT NULL
);

-- Tabela Item da Comanda:

CREATE TABLE Item_Comanda (
	id_item_comanda INT PRIMARY KEY NOT NULL,
	quantidade INT NOT NULL,
	id_comanda INT NOT NULL,
	id_cardapio INT NOT NULL,
	FOREIGN KEY(id_comanda) REFERENCES Comanda(id_comanda),
	FOREIGN KEY(id_cardapio) REFERENCES Cardapio(id_cardapio),
    UNIQUE (id_comanda, id_cardapio)
);


-- Inserção de Dados:

-- Comandas
INSERT INTO Comanda(id_comanda, data, nr_mesa, nome_cliente)
VALUES (1, '2025-10-12', 5, 'Amelie'),
(2, '2025-10-12', 5, 'Charlotte'),
(3, '2025-10-13', 7, 'Ana'),
(4, '2025-10-19', 1, 'Duda'),
(5, '2025-10-19', 8, 'Beatriz'); 

-- Cardápio de Bebidas
INSERT INTO Cardapio (id_cardapio, nome_item, descricao, preco_unitario)
VALUES (1, 'Expresso', 'Cafe puro.', 5.50),
(2, 'Capuccino', 'Expresso, leite vaporizado e espuma.', 12.00),
(3, 'Mocaccino', 'Chocolate, expresso e leite.', 15.00),
(4, 'Latte Macchiato', 'Leite vaporizado com um toque de expresso.', 13.50),
(5, 'Limonada', 'Suco de Limão, água mineral, com ou sem açúcar.', 10.00),
(6, 'Refrigerante', 'Coca-cola, Guaraná', 7.00),
(7, 'Água mineral', 'Com gás ou sem gás', 5.00);

-- Cardápio de Lanches:
INSERT INTO Cardapio (id_cardapio, nome_item, descricao, preco_unitario)
VALUES (8, 'Sanduíche simples', 'Pão de forma, queijo, presunto e requeijão', 8.00),
(9, 'Sanduíche com salada', 'Pão de forma, queijo, presunto, requeijão, alface, tomate, ovo', 10.00),
(10, 'Sanduíche de frango', 'Pão de forma, requeijão, alface, tomate, frango desfiado', 15.00),
(11, 'Brownie', 'Base de chocolate e recheio de creme de leite em pó.', 15.00),
(12, 'Fatia de Torta morango e chantilly', 'Recheio de morangos com brigadeiro em chocolate branco e chantilly.', 17.00);

-- Itens da Comanda
INSERT INTO Item_Comanda (id_item_comanda, quantidade, id_comanda, id_cardapio)
VALUES
-- Comanda 1 (Amelie, 2025-10-12)
(1, 2, 1, 1),
(2, 1, 1, 3),

-- Comanda 2 (Charlotte, 2025-10-12)
(3, 1, 2, 3),

-- Comanda 3 (Ana, 2025-10-13)
(4, 1, 3, 2),
(5, 3, 3, 1),

-- Comanda 4 (Duda, 2025-10-19)
(6, 1, 4, 1),
(7, 2, 4, 3),

-- Comanda 5 (Beatriz, 2025-10-19)
(9, 1, 5, 4);

-- CONSULTAS:

-- 1) Cardápio ordenada por nome:
SELECT
    id_cardapio, nome_item, descricao, preco_unitario
FROM
    Cardapio
ORDER BY
    nome_item;

-- 2) Ordenar por data, código e por nome do café:

SELECT 
    comanda.id_comanda,
    comanda.data,
    comanda.nr_mesa,
    comanda.nome_cliente,
    cardapio.nome_item,
    cardapio.descricao,
    item_comanda.quantidade,
    cardapio.preco_unitario,
    (item_comanda.quantidade * cardapio.preco_unitario) AS preco_total
FROM 
    Comanda comanda
JOIN 
    Item_Comanda item_comanda 
    ON comanda.id_comanda = item_comanda.id_comanda
JOIN 
    Cardapio cardapio 
    ON item_comanda.id_cardapio = cardapio.id_cardapio
ORDER BY 
    comanda.data,
    comanda.id_comanda,
    cardapio.nome_item;
-- 3) Listar todas as comandas e mostrar o valor total da comanda, ordenando por data a listagem:
SELECT 
    comanda.id_comanda,
    comanda.nome_cliente,
    comanda.nr_mesa,
    comanda.data,
    SUM(item_comanda.quantidade * cardapio.preco_unitario) AS total_comanda
FROM 
    Comanda comanda
JOIN 
    Item_Comanda item_comanda 
    ON comanda.id_comanda = item_comanda.id_comanda
JOIN 
    Cardapio cardapio 
    ON item_comanda.id_cardapio = cardapio.id_cardapio
GROUP BY 
    comanda.id_comanda,
    comanda.nome_cliente,
    comanda.nr_mesa,
    comanda.data
ORDER BY 
    comanda.data;


-- 4) Mesma listagem das comandas da questão anterior, mas trazendo apenas as comandas que possuem mais do que um tipo de café na comanda:

SELECT 
    comanda.id_comanda,
    comanda.nome_cliente,
    comanda.nr_mesa,
    comanda.data,
    SUM(item_comanda.quantidade * cardapio.preco_unitario) AS total_comanda,
    COUNT(DISTINCT cardapio.id_cardapio) AS qtd_itens
FROM 
    Comanda comanda
JOIN 
    Item_Comanda item_comanda 
    ON comanda.id_comanda = item_comanda.id_comanda
JOIN 
    Cardapio cardapio 
    ON item_comanda.id_cardapio = cardapio.id_cardapio
GROUP BY 
    comanda.id_comanda,
    comanda.nome_cliente,
    comanda.nr_mesa,
    comanda.data
HAVING 
    COUNT(DISTINCT cardapio.id_cardapio) > 1
ORDER BY 
    comanda.data;

-- 5) Total de faturamento por data, ordenando por data a consulta:

SELECT 
    comanda.data,
    SUM(item_comanda.quantidade * cardapio.preco_unitario) AS faturamento_total
FROM 
    Comanda comanda
JOIN 
    Item_Comanda item_comanda 
    ON comanda.id_comanda = item_comanda.id_comanda
JOIN 
    Cardapio cardapio 
    ON item_comanda.id_cardapio = cardapio.id_cardapio
GROUP BY 
    comanda.data
ORDER BY 
    comanda.data;
