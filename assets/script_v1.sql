-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-03-12 20:01:39.193

-- tables
-- Table: Aplicacao
CREATE TABLE Aplicacao (
    id bigint NOT NULL CONSTRAINT Aplicacao_pk PRIMARY KEY,
    paciente varchar(11) NOT NULL,
    data date NOT NULL,
    aplicante bigint NOT NULL,
    lote int NOT NULL,
    dose varchar(4) NOT NULL,
    campanha bigint,
    data_aprazamento date,
    CONSTRAINT Paciente_Aplicacao FOREIGN KEY (paciente)
    REFERENCES Paciente (cpf),
    CONSTRAINT Aplicacao_Aplicante FOREIGN KEY (aplicante)
    REFERENCES Aplicante (id),
    CONSTRAINT Aplicacao_Campanha FOREIGN KEY (campanha)
    REFERENCES Campanha (id),
    CONSTRAINT Aplicacao_Lote FOREIGN KEY (lote)
    REFERENCES Lote (id_lote)
);

-- Table: Aplicante
CREATE TABLE Aplicante (
    id bigint NOT NULL CONSTRAINT Aplicante_pk PRIMARY KEY,
    cns varchar(15) NOT NULL,
    nome varchar(50) NOT NULL,
    estabelecimento bigint NOT NULL,
    CONSTRAINT Aplicante_Estabelecimento FOREIGN KEY (estabelecimento)
    REFERENCES Estabelecimento (id)
);

-- Table: Campanha
CREATE TABLE Campanha (
    id bigint NOT NULL CONSTRAINT Campanha_pk PRIMARY KEY,
    titulo varchar(30) NOT NULL,
    inicio date NOT NULL,
    termino date NOT NULL,
    descricao varchar(100) NOT NULL
);

-- Table: Carteira_Vacinacao
CREATE TABLE Carteira_Vacinacao (
    id bigint NOT NULL CONSTRAINT Carteira_Vacinacao_pk PRIMARY KEY,
    paciente varchar(11) NOT NULL,
    aplicacao bigint NOT NULL,
    CONSTRAINT Carteira_Vacinacao_Paciente FOREIGN KEY (paciente)
    REFERENCES Paciente (cpf),
    CONSTRAINT Carteira_Vacinacao_Aplicacao FOREIGN KEY (aplicacao)
    REFERENCES Aplicacao (id)
);

-- Table: Estabelecimento
CREATE TABLE Estabelecimento (
    id bigint NOT NULL CONSTRAINT Estabelecimento_pk PRIMARY KEY,
    cnes varchar(20) NOT NULL,
    nome varchar(50) NOT NULL,
    localidade bigint NOT NULL,
    CONSTRAINT Estabelecimento_Localidade FOREIGN KEY (localidade)
    REFERENCES Localidade (id)
);

-- Table: Grupo
CREATE TABLE Grupo (
    id bigint NOT NULL CONSTRAINT Grupo_pk PRIMARY KEY,
    codigo varchar(10) NOT NULL,
    nome varchar(10) NOT NULL,
    descricao varchar(150) NOT NULL
);

-- Table: Localidade
CREATE TABLE Localidade (
    id bigint NOT NULL CONSTRAINT Localidade_pk PRIMARY KEY,
    nome varchar(40) NOT NULL,
    municipio varchar(40) NOT NULL,
    estado varchar(2) NOT NULL,
    codigo_ibge varchar(10) NOT NULL
);

-- Table: Lote
CREATE TABLE Lote (
    id_lote int NOT NULL CONSTRAINT Vacina_pk PRIMARY KEY,
    numero_lote varchar(10) NOT NULL,
    quantidade int NOT NULL
);

-- Table: Paciente
CREATE TABLE Paciente (
    cpf varchar(11) NOT NULL CONSTRAINT Paciente_pk PRIMARY KEY,
    nome varchar(50) NOT NULL,
    cns varchar(15) NOT NULL,
    nascimento date NOT NULL,
    sexo character(1) NOT NULL,
    nome_mae varchar(50) NOT NULL,
    grupo bigint NOT NULL,
    nome_pai varchar(50) NOT NULL,
    localidade bigint NOT NULL,
    Localidade_id bigint NOT NULL,
    condicao_maternal varchar(10) NOT NULL,
    CONSTRAINT Paciente_Localidade FOREIGN KEY (Localidade_id)
    REFERENCES Localidade (id),
    CONSTRAINT Paciente_Grupo FOREIGN KEY (grupo)
    REFERENCES Grupo (id)
);

-- Table: Vacina
CREATE TABLE Vacina (
    cogido_sipni varchar(10) NOT NULL CONSTRAINT Vacina_pk PRIMARY KEY,
    nome varchar(15) NOT NULL,
    produtor varchar(30) NOT NULL,
    lote int NOT NULL,
    CONSTRAINT Lote_Vacina FOREIGN KEY (lote)
    REFERENCES Lote (id_lote)
);

-- End of file.

