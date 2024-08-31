-- Criação da tabela 'animais'
CREATE TABLE animais (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especie VARCHAR(50) NOT NULL,
    idade INT,
    peso DECIMAL(5, 2),
    habitat VARCHAR(100),
    data_de_entrada DATE DEFAULT CURRENT_DATE
);

-- Inserção de dados na tabela 'animais'
INSERT INTO animais (nome, especie, idade, peso, habitat) VALUES
('Simba', 'Leão', 5, 190.50, 'Savanas da África'),
('Nemo', 'Peixe-palhaço', 2, 0.15, 'Oceano Pacífico'),
('Kaa', 'Cobra', 4, 15.30, 'Floresta Amazônica'),
('Dumbo', 'Elefante', 10, 540.00, 'África'),
('Bambi', 'Cervo', 3, 80.20, 'Florestas da Europa'),
('Baloo', 'Urso', 7, 450.75, 'Montanhas da Índia'),
('Zazu', 'Calau', 2, 0.55, 'Savanas da África'),
('Manny', 'Mamute', 25, 600.00, 'Era do Gelo'),
('Timon', 'Suricato', 3, 0.75, 'Savanas da África'),
('Pumba', 'Javali', 4, 120.00, 'Savanas da África');
