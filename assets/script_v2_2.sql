-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-05-04 15:06:44.095

-- tables
-- Table: Aplicacao
CREATE TABLE Aplicacao (
    id integer NOT NULL CONSTRAINT Aplicacao_pk PRIMARY KEY,
    aplicante_id integer NOT NULL,
    vacina_id integer NOT NULL,
    dose varchar(4) NOT NULL,
    paciente_id integer NOT NULL,
    data date NOT NULL,
    campanha_id integer,
    data_aprazamento date,
    CONSTRAINT Paciente_Aplicacao FOREIGN KEY (paciente_id)
    REFERENCES Paciente (id),
    CONSTRAINT Aplicacao_Aplicante FOREIGN KEY (aplicante_id)
    REFERENCES Aplicante (id),
    CONSTRAINT Aplicacao_Campanha FOREIGN KEY (campanha_id)
    REFERENCES Campanha (id),
    CONSTRAINT Aplicacao_Vacina FOREIGN KEY (vacina_id)
    REFERENCES Vacina (id)
);

-- Table: Aplicante
CREATE TABLE Aplicante (
    id integer NOT NULL CONSTRAINT Aplicante_pk PRIMARY KEY,
    cns varchar(15) NOT NULL,
    nome varchar(50) NOT NULL,
    estabelecimento_id integer NOT NULL,
    pessoa_id integer NOT NULL,
    CONSTRAINT cns_aplicante UNIQUE (cns),
    CONSTRAINT pessoa_id_aplicante UNIQUE (pessoa_id),
    CONSTRAINT Aplicante_Estabelecimento FOREIGN KEY (estabelecimento_id)
    REFERENCES Estabelecimento (id),
    CONSTRAINT Aplicante_Pessoa FOREIGN KEY (pessoa_id)
    REFERENCES Pessoa (id)
);

-- Table: Campanha
CREATE TABLE Campanha (
    titulo varchar(30) NOT NULL,
    inicio date NOT NULL,
    termino date NOT NULL,
    descricao varchar(100) NOT NULL,
    id integer NOT NULL CONSTRAINT Campanha_pk PRIMARY KEY
);

-- Table: Categoria_Prioritaria
CREATE TABLE Categoria_Prioritaria (
    id integer NOT NULL CONSTRAINT Grupo_pk PRIMARY KEY,
    codigo varchar(10) NOT NULL,
    nome varchar(10) NOT NULL,
    grupo_id integer NOT NULL,
    descricao varchar(150) NOT NULL,
    CONSTRAINT codigo_categoria UNIQUE (codigo),
    CONSTRAINT Categoria_Grupo_Prioritario FOREIGN KEY (grupo_id)
    REFERENCES Grupo_Prioritario (id)
);

-- Table: Estabelecimento
CREATE TABLE Estabelecimento (
    id integer NOT NULL CONSTRAINT Estabelecimento_pk PRIMARY KEY,
    cnes varchar(7) NOT NULL,
    nome varchar(50) NOT NULL,
    localidade_id integer NOT NULL,
    CONSTRAINT cnes UNIQUE (cnes),
    CONSTRAINT Estabelecimento_Localidade FOREIGN KEY (localidade_id)
    REFERENCES Localidade (id)
);

-- Table: Grupo_Prioritario
CREATE TABLE Grupo_Prioritario (
    id integer NOT NULL CONSTRAINT Grupo_pk PRIMARY KEY,
    codigo varchar(10) NOT NULL,
    nome varchar(10) NOT NULL,
    descricao varchar(150) NOT NULL,
    CONSTRAINT codigo_grupo UNIQUE (codigo)
);

-- Table: Localidade
CREATE TABLE Localidade (
    id integer NOT NULL CONSTRAINT Localidade_pk PRIMARY KEY,
    nome varchar(40) NOT NULL,
    municipio varchar(40) NOT NULL,
    estado varchar(2) NOT NULL,
    codigo_ibge varchar(7) NOT NULL,
    CONSTRAINT codigo_ibge UNIQUE (codigo_ibge)
);

-- Table: Lote
CREATE TABLE Lote (
    id integer NOT NULL CONSTRAINT Vacina_pk PRIMARY KEY,
    numero_lote varchar(10) NOT NULL,
    quantidade integer NOT NULL,
    CONSTRAINT numero_lote UNIQUE (numero_lote)
);

-- Table: Paciente
CREATE TABLE Paciente (
    id integer NOT NULL CONSTRAINT Paciente_pk PRIMARY KEY,
    cns varchar(15) NOT NULL,
    condicao_maternal varchar(10) NOT NULL,
    pessoa_id integer NOT NULL,
    categoria_id integer NOT NULL,
    CONSTRAINT cns_paciente UNIQUE (cns),
    CONSTRAINT pessoa_id_paciente UNIQUE (pessoa_id),
    CONSTRAINT Paciente_Pessoa FOREIGN KEY (pessoa_id)
    REFERENCES Pessoa (id),
    CONSTRAINT Paciente_Categoria FOREIGN KEY (categoria_id)
    REFERENCES Categoria_Prioritaria (id)
);

-- Table: Pessoa
CREATE TABLE Pessoa (
    id integer NOT NULL CONSTRAINT Paciente_pk PRIMARY KEY,
    cpf varchar(11) NOT NULL,
    nome varchar(50) NOT NULL,
    nascimento date NOT NULL,
    sexo varchar(1) NOT NULL,
    nome_mae varchar(50) NOT NULL,
    nome_pai varchar(50) NOT NULL,
    localidade_id integer NOT NULL,
    CONSTRAINT cpf UNIQUE (cpf),
    CONSTRAINT Pessoa_Localidade FOREIGN KEY (localidade_id)
    REFERENCES Localidade (id)
);

-- Table: Vacina
CREATE TABLE Vacina (
    id integer NOT NULL CONSTRAINT Vacina_pk PRIMARY KEY,
    codigo_sipni varchar(10) NOT NULL,
    nome varchar(15) NOT NULL,
    laboratorio varchar(30) NOT NULL,
    lote_id integer NOT NULL,
    CONSTRAINT codigo_sipni UNIQUE (codigo_sipni),
    CONSTRAINT Lote_Vacina FOREIGN KEY (lote_id)
    REFERENCES Lote (id)
);


INSERT INTO Aplicacao (aplicante_id, vacina_id, dose, paciente_id , data, campanha_id , data_aprazamento)
VALUES (1, 1, "D1", 1, "2021-01-01", 1, "2021-04-01");

INSERT INTO Aplicante (cns, nome, estabelecimento_id, pessoa_id)
VALUES ('278794316530006', 'Maria Mercedes Motta', 1, 1);

INSERT INTO Campanha (titulo, inicio, termino, descricao)
VALUES ('Campanha de Vacinação', '2020-01-01', '2020-12-31', 'Campanha de Vacinação');

INSERT INTO Categoria_Prioritaria (codigo, nome, grupo_id, descricao)
VALUES ('Idosos', 'Idosos', 1, 'Categoria de pessoas com mais de 60 anos');

INSERT INTO Estabelecimento (cnes, nome, localidade_id)
VALUES ('1234567', 'Estabelecimento 1', 1);

INSERT INTO Grupo_Prioritario (codigo, nome, descricao)
VALUES ('Idosos', 'Idosos', 'Grupo de pessoas com mais de 60 anos');

INSERT INTO Localidade (nome, municipio, estado, codigo_ibge)
VALUES ('São Paulo', 'São Paulo', 'SP', '3550308');

INSERT INTO Lote (numero_lote, quantidade)
VALUES ('123456', 10);

INSERT INTO Paciente (cns, condicao_maternal, pessoa_id, categoria_id)
VALUES ('832070136190005', 'NENHUMA', 1, 1);

INSERT INTO Pessoa (cpf, nome, nascimento, sexo, nome_mae, nome_pai, localidade_id)
VALUES ('69309106271', 'Maria', '2000-01-01', 'F', 'Maria Madalena', 'João Pedro', 1);

INSERT INTO Vacina (codigo_sipni, nome, laboratorio, lote_id)
VALUES ('VAC-01', 'Vacina 1', 'Laboratorio 1', 1);