-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-05-04 15:06:44.095

-- tables
-- Table: Aplicacao
CREATE TABLE Application (
    id integer NOT NULL CONSTRAINT Application_pk PRIMARY KEY,
    applier integer NOT NULL,
    vaccine integer NOT NULL,
    dose varchar(4) NOT NULL,
    patient integer NOT NULL,
    application_date date NOT NULL,
    campaign integer,
    due_date date,
    CONSTRAINT Patient_Application FOREIGN KEY (patient)
    REFERENCES Patient (id),
    CONSTRAINT Application_Applier FOREIGN KEY (applier)
    REFERENCES Applier (id),
    CONSTRAINT Application_Campaign FOREIGN KEY (campaign)
    REFERENCES Campaign (id),
    CONSTRAINT Application_Vaccine FOREIGN KEY (vaccine)
    REFERENCES Vaccine (id)
);

-- Table: Aplicante
CREATE TABLE Applier (
    id integer NOT NULL CONSTRAINT Applier_pk PRIMARY KEY,
    cns varchar(15) NOT NULL,
    establishment integer NOT NULL,
    person integer NOT NULL,
    CONSTRAINT cns_applier UNIQUE (cns),
    CONSTRAINT person_applier UNIQUE (person),
    CONSTRAINT Applier_Establishment FOREIGN KEY (establishment)
    REFERENCES Establishment (id),
    CONSTRAINT Applier_Person FOREIGN KEY (person)
    REFERENCES Person (id)
);

-- Table: Campanha
CREATE TABLE Campaign (
    title varchar(30) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    description varchar(100) NOT NULL,
    id integer NOT NULL CONSTRAINT Campaign_pk PRIMARY KEY
);

-- Table: Categoria_Prioritaria
CREATE TABLE Priority_Category (
    id integer NOT NULL CONSTRAINT Group_pk PRIMARY KEY,
    code varchar(10) NOT NULL,
    name varchar(10) NOT NULL,
    "group" integer NOT NULL,
    description varchar(150) NOT NULL,
    CONSTRAINT code_category UNIQUE (code),
    CONSTRAINT Category_Priority_Group FOREIGN KEY ("group")
    REFERENCES Priority_Group (id)
);

-- Table: Estabelecimento
CREATE TABLE Establishment (
    id integer NOT NULL CONSTRAINT Establishment_pk PRIMARY KEY,
    cnes varchar(7) NOT NULL,
    name varchar(50) NOT NULL,
    locality integer NOT NULL,
    CONSTRAINT cnes UNIQUE (cnes),
    CONSTRAINT Establishment_Locality FOREIGN KEY (locality)
    REFERENCES Locality (id)
);

-- Table: Grupo_Prioritario
CREATE TABLE Priority_Group (
    id integer NOT NULL CONSTRAINT Group_pk PRIMARY KEY,
    code varchar(10) NOT NULL,
    name varchar(10) NOT NULL,
    description varchar(150) NOT NULL,
    CONSTRAINT code_group UNIQUE (code)
);

-- Table: Localidade
CREATE TABLE Locality (
    id integer NOT NULL CONSTRAINT Locality_pk PRIMARY KEY,
    name varchar(40) NOT NULL,
    city varchar(40) NOT NULL,
    state varchar(2) NOT NULL,
    ibge_code varchar(7) NOT NULL,
    CONSTRAINT ibge_code UNIQUE (ibge_code)
);

-- Table: Lote
CREATE TABLE Vaccine_Batch (
    id integer NOT NULL CONSTRAINT Vaccine_pk PRIMARY KEY,
    number varchar(10) NOT NULL,
    quantity integer NOT NULL,
    CONSTRAINT number UNIQUE (number)
);

-- Table: Paciente
CREATE TABLE Patient (
    id integer NOT NULL CONSTRAINT Patient_pk PRIMARY KEY,
    cns varchar(15) NOT NULL,
    maternal_condition varchar(10) NOT NULL,
    person integer NOT NULL,
    category integer NOT NULL,
    CONSTRAINT cns_patient UNIQUE (cns),
    CONSTRAINT person_patient UNIQUE (person),
    CONSTRAINT Patient_Person FOREIGN KEY (person)
    REFERENCES Person (id),
    CONSTRAINT Patient_Category FOREIGN KEY (category)
    REFERENCES Priority_Category (id)
);

-- Table: Pessoa
CREATE TABLE Person (
    id integer NOT NULL CONSTRAINT Person_pk PRIMARY KEY,
    cpf varchar(11) NOT NULL,
    name varchar(50) NOT NULL,
    birth_date date NOT NULL,
    sex varchar(1) NOT NULL,
    mother_name varchar(50) NOT NULL,
    father_name varchar(50) NOT NULL,
    locality integer NOT NULL,
    CONSTRAINT cpf UNIQUE (cpf),
    CONSTRAINT Person_Locality FOREIGN KEY (locality)
    REFERENCES Locality (id)
);

-- Table: Vacina
CREATE TABLE Vaccine (
    id integer NOT NULL CONSTRAINT Vaccine_pk PRIMARY KEY,
    sipni_code varchar(10) NOT NULL,
    name varchar(15) NOT NULL,
    laboratory varchar(30) NOT NULL,
    batch integer NOT NULL,
    CONSTRAINT sipni_code UNIQUE (sipni_code),
    CONSTRAINT Vaccine_Batch FOREIGN KEY (batch)
    REFERENCES Vaccine_Batch (id)
);


INSERT INTO Application (applier, vaccine, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D1", 1, "2021-01-01", 1, "2021-04-01");

INSERT INTO Applier (cns, establishment, person)
VALUES ('278794316530006', 1, 1);

INSERT INTO Campaign (title, start_date, end_date, description)
VALUES ('Campanha de Vacinação', '2020-01-01', '2020-12-31', 'Campanha de Vacinação');

INSERT INTO Priority_Category (code, name, "group", description)
VALUES ('Idosos', 'Idosos', 1, 'Categoria de pessoas com mais de 60 anos');

INSERT INTO Establishment (cnes, name, locality)
VALUES ('1234567', 'Estabelecimento 1', 1);

INSERT INTO Priority_Group (code, name, description)
VALUES ('Idosos', 'Idosos', 'Grupo de pessoas com mais de 60 anos');

INSERT INTO Locality (name, city, state, ibge_code)
VALUES ('São Paulo', 'São Paulo', 'SP', '3550308');

INSERT INTO Vaccine_Batch (number, quantity)
VALUES ('123456', 10);

INSERT INTO Patient (cns, maternal_condition, person, category)
VALUES ('832070136190005', 'NENHUMA', 2, 1);

INSERT INTO Person (cpf, name, birth_date, sex, mother_name, father_name, locality)
VALUES ('69309106271', 'Maria', '2000-01-01', 'F', 'Maria Madalena', 'João Pedro', 1);

INSERT INTO Person (cpf, name, birth_date, sex, mother_name, father_name, locality)
VALUES ('63773671040', 'Marcia', '2000-03-01', 'F', 'Maria Madalena', 'João Pedro', 1);

INSERT INTO Vaccine (sipni_code, name, laboratory, batch)
VALUES ('VAC-01', 'Vacina 1', 'Laboratorio 1', 1);