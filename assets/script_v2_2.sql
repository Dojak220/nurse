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
    priority_group integer NOT NULL,
    description varchar(150) NOT NULL,
    CONSTRAINT code_category UNIQUE (code),
    CONSTRAINT Category_Priority_Group FOREIGN KEY (priority_group)
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
    priority_category integer NOT NULL,
    CONSTRAINT cns_patient UNIQUE (cns),
    CONSTRAINT person_patient UNIQUE (person),
    CONSTRAINT Patient_Person FOREIGN KEY (person)
    REFERENCES Person (id),
    CONSTRAINT Patient_Category FOREIGN KEY (priority_category)
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

-- Aplication
INSERT INTO Application (applier, vaccine, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D1", 1, "2021-01-01", 1, "2021-04-01");

INSERT INTO Application (applier, vaccine, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D1", 2, "2021-01-01", 1, "2021-04-01");

INSERT INTO Application (applier, vaccine, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D1", 3, "2021-01-01", 1, "2021-04-01");

INSERT INTO Application (applier, vaccine, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D1", 4, "2021-01-01", 1, "2021-04-01");

INSERT INTO Application (applier, vaccine, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D1", 5, "2021-01-01", 1, "2021-04-01");

INSERT INTO Application (applier, vaccine, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D2", 1, "2022-05-01", 1, "2022-07-01");

INSERT INTO Application (applier, vaccine, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D2", 2, "2022-05-01", 1, "2022-07-01");

INSERT INTO Application (applier, vaccine, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D2", 3, "2022-05-10", 1, "2022-07-01");

INSERT INTO Application (applier, vaccine, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D2", 4, "2022-05-11", 1, "2022-07-01");

INSERT INTO Application (applier, vaccine, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D2", 5, "2022-05-12", 1, "2022-07-01");
-- End of Application

INSERT INTO Applier (cns, establishment, person)
VALUES ('278794316530006', 1, 1);

INSERT INTO Campaign (title, start_date, end_date, description)
VALUES ('Campanha de Vacinação', '2021-01-01', '2022-12-31', 'Campanha de Vacinação');

-- Priority_Category
INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ('Idosos', 'Idosos', 1, 'Categoria de pessoas com mais de 60 anos');

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ('Crianças', 'Crianças', 2, 'Categoria de pessoas com idade entre 3 e 11 anos');

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ('Bebês', 'Bebês', 2, 'Categoria de pessoas com idade entre 0 e 2 anos');
-- End of Priority_Category

INSERT INTO Establishment (cnes, name, locality)
VALUES ('1234567', 'Estabelecimento 1', 1);

-- Priority_Group
INSERT INTO Priority_Group (code, name, description)
VALUES ('Idosos', 'Idosos', 'Grupo de pessoas com mais de 60 anos');

INSERT INTO Priority_Group (code, name, description)
VALUES ('Jovens', 'Jovens', 'Grupo de pessoas com menos de 60 anos');
-- End of Priority_Group

INSERT INTO Locality (name, city, state, ibge_code)
VALUES ('São Paulo', 'São Paulo', 'SP', '3550308');

INSERT INTO Vaccine_Batch (number, quantity)
VALUES ('123456', 10);

-- Patient
INSERT INTO Patient (cns, maternal_condition, person, priority_category)
VALUES ('832070136190005', 'GESTANTE', 1, 1);

INSERT INTO Patient (cns, maternal_condition, person, priority_category)
VALUES ('266312995450018', 'NENHUM', 2, 1);

INSERT INTO Patient (cns, maternal_condition, person, priority_category)
VALUES ('168478844750009', 'NENHUM', 3, 1);

INSERT INTO Patient (cns, maternal_condition, person, priority_category)
VALUES ('172899520230005', 'NENHUMA', 4, 2);

INSERT INTO Patient (cns, maternal_condition, person, priority_category)
VALUES ('291012854870006', 'NENHUMA', 5, 3);
-- End of Patient

-- Person
INSERT INTO Person (cpf, name, birth_date, sex, mother_name, father_name, locality)
VALUES ('69309106271', 'Maria de Jesus Sousa', '1950-01-01', 'F', 'Maria Madalena', 'João Pedro', 1);

INSERT INTO Person (cpf, name, birth_date, sex, mother_name, father_name, locality)
VALUES ('37635116878', 'José de Jesus Sousa', '1960-01-01', 'M', 'Maria Madalena', 'João Pedro', 1);

INSERT INTO Person (cpf, name, birth_date, sex, mother_name, father_name, locality)
VALUES ('86782229480', 'Jaquim de Jesus Sousa', '1955-01-01', 'M', 'Maria Madalena', 'João Pedro', 1);

INSERT INTO Person (cpf, name, birth_date, sex, mother_name, father_name, locality)
VALUES ('63773671040', 'Marcia Rodrigues de Araújo', '2015-03-01', 'F', 'Maria Madalena', 'João Pedro', 1);

INSERT INTO Person (cpf, name, birth_date, sex, mother_name, father_name, locality)
VALUES ('51893955966', 'Valentina Castro Silva', '2021-03-01', 'F', 'Maria Madalena', 'João Pedro', 1);
-- End of Person

INSERT INTO Vaccine (sipni_code, name, laboratory, batch)
VALUES ('123456', 'Vacina 1', 'Laboratorio 1', 1);