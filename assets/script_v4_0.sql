-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-05-04 15:06:44.095

-- tables
-- Table: Aplicacao
CREATE TABLE Application (
    id integer NOT NULL CONSTRAINT Application_pk PRIMARY KEY,
    applier integer NOT NULL,
    vaccine_batch integer NOT NULL,
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
    CONSTRAINT Application_Vaccine_Batch FOREIGN KEY (vaccine_batch)
    REFERENCES Vaccine_Batch (id)
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
    title varchar(100) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    description varchar(200) NOT NULL,
    id integer NOT NULL CONSTRAINT Campaign_pk PRIMARY KEY,
    CONSTRAINT title UNIQUE (title)
);

-- Table: Categoria_Prioritaria
CREATE TABLE Priority_Category (
    id integer NOT NULL CONSTRAINT Group_pk PRIMARY KEY,
    code varchar(100) NOT NULL,
    name varchar(100) NOT NULL,
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
    code varchar(100) NOT NULL,
    name varchar(100) NOT NULL,
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
    vaccine integer NOT NULL,
    CONSTRAINT number UNIQUE (number)
    CONSTRAINT Vaccine FOREIGN KEY (vaccine)
    REFERENCES Vaccine (id)
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
    birth_date date,
    sex varchar(1) NOT NULL,
    mother_name varchar(50) NOT NULL,
    father_name varchar(50) NOT NULL,
    locality integer,
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
    CONSTRAINT sipni_code UNIQUE (sipni_code)
);

-- Aplication
INSERT INTO Application (applier, vaccine_batch, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D1", 1, "2021-01-01", 1, "2021-04-01");

INSERT INTO Application (applier, vaccine_batch, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D1", 2, "2021-01-01", 1, "2021-04-01");

INSERT INTO Application (applier, vaccine_batch, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D1", 3, "2021-01-01", 1, "2021-04-01");

INSERT INTO Application (applier, vaccine_batch, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D1", 4, "2021-01-01", 1, "2021-04-01");

INSERT INTO Application (applier, vaccine_batch, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D1", 5, "2021-01-01", 1, "2021-04-01");

INSERT INTO Application (applier, vaccine_batch, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D2", 1, "2022-06-01", 1, "2022-07-01");

INSERT INTO Application (applier, vaccine_batch, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D2", 2, "2022-06-01", 1, "2022-07-01");

INSERT INTO Application (applier, vaccine_batch, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D2", 3, "2022-06-09", 1, "2022-07-01");

INSERT INTO Application (applier, vaccine_batch, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D2", 4, "2022-06-10", 1, "2022-07-01");

INSERT INTO Application (applier, vaccine_batch, dose, patient , application_date, campaign , due_date)
VALUES (1, 1, "D2", 5, "2022-06-11", 1, "2022-07-01");
-- End of Application

INSERT INTO Applier (cns, establishment, person)
VALUES ("278794316530006", 1, 1);

INSERT INTO Campaign (title, start_date, end_date, description)
VALUES ("Campanha de Vacina????o", "2021-01-01", "2022-12-31", "Campanha de Vacina????o");

INSERT INTO Establishment (cnes, name, locality)
VALUES ("1234567", "Estabelecimento 1", 1);

INSERT INTO Locality (name, city, state, ibge_code)
VALUES ("S??o Paulo", "S??o Paulo", "SP", "3550308");

INSERT INTO Vaccine_Batch (number, quantity, vaccine)
VALUES ("123456", 10, 1);

-- Patient
INSERT INTO Patient (cns, maternal_condition, person, priority_category)
VALUES ("832070136190005", "GESTANTE", 1, 1);

INSERT INTO Patient (cns, maternal_condition, person, priority_category)
VALUES ("266312995450018", "NENHUM", 2, 1);

INSERT INTO Patient (cns, maternal_condition, person, priority_category)
VALUES ("168478844750009", "NENHUM", 3, 1);

INSERT INTO Patient (cns, maternal_condition, person, priority_category)
VALUES ("172899520230005", "NENHUMA", 4, 2);

INSERT INTO Patient (cns, maternal_condition, person, priority_category)
VALUES ("291012854870006", "NENHUMA", 5, 3);
-- End of Patient

-- Person
INSERT INTO Person (cpf, name, birth_date, sex, mother_name, father_name, locality)
VALUES ("69309106271", "Maria de Jesus Sousa", "1950-01-01", "F", "Maria Madalena", "Jo??o Pedro", 1);

INSERT INTO Person (cpf, name, birth_date, sex, mother_name, father_name, locality)
VALUES ("37635116878", "Jos?? de Jesus Sousa", "1960-01-01", "M", "Maria Madalena", "Jo??o Pedro", 1);

INSERT INTO Person (cpf, name, birth_date, sex, mother_name, father_name, locality)
VALUES ("86782229480", "Jaquim de Jesus Sousa", "1955-01-01", "M", "Maria Madalena", "Jo??o Pedro", 1);

INSERT INTO Person (cpf, name, birth_date, sex, mother_name, father_name, locality)
VALUES ("63773671040", "Marcia Rodrigues de Ara??jo", "2015-03-01", "F", "Maria Madalena", "Jo??o Pedro", 1);

INSERT INTO Person (cpf, name, birth_date, sex, mother_name, father_name, locality)
VALUES ("51893955966", "Valentina Castro Silva", "2021-03-01", "F", "Maria Madalena", "Jo??o Pedro", 1);
-- End of Person

INSERT INTO Vaccine (sipni_code, name, laboratory)
VALUES ("123456", "Vacina 1", "Laboratorio 1");

-- Priority_Group
INSERT INTO Priority_Group (code, name, description)
VALUES ("Comorbidades", "Comorbidades", "Comorbidades");

INSERT INTO Priority_Group (code, name, description)
VALUES ("Faixa Et??ria", "Faixa Et??ria", "Faixa Et??ria");

INSERT INTO Priority_Group (code, name, description)
VALUES ("Pessoas de 60 nos ou mais Institucionalizadas", "Pessoas de 60 nos ou mais Institucionalizadas", "Pessoas de 60 nos ou mais Institucionalizadas");

INSERT INTO Priority_Group (code, name, description)
VALUES ("For??as Armadas (membros ativos)", "For??as Armadas (membros ativos)", "For??as Armadas (membros ativos)");

INSERT INTO Priority_Group (code, name, description)
VALUES ("For??as de Seguran??a e Salvamento", "For??as de Seguran??a e Salvamento", "For??as de Seguran??a e Salvamento");

INSERT INTO Priority_Group (code, name, description)
VALUES ("Povos e Comunidades Tradicionais", "Povos e Comunidades Tradicionais", "Povos e Comunidades Tradicionais");

INSERT INTO Priority_Group (code, name, description)
VALUES ("Povos Ind??genas", "Povos Ind??genas", "Povos Ind??genas");

INSERT INTO Priority_Group (code, name, description)
VALUES ("Trabalhadores da Educa????o", "Trabalhadores da Educa????o", "Trabalhadores da Educa????o");

INSERT INTO Priority_Group (code, name, description)
VALUES ("Trabalhadores de Sa??de", "Trabalhadores de Sa??de", "Trabalhadores de Sa??de");

INSERT INTO Priority_Group (code, name, description)
VALUES ("Trabalhadores de Transporte", "Trabalhadores de Transporte", "Trabalhadores de Transporte");

INSERT INTO Priority_Group (code, name, description)
VALUES ("Pessoas com Defici??ncia", "Pessoas com Defici??ncia", "Pessoas com Defici??ncia");

INSERT INTO Priority_Group (code, name, description)
VALUES ("Pessoas em Situa????o de Rua", "Pessoas em Situa????o de Rua", "Pessoas em Situa????o de Rua");

INSERT INTO Priority_Group (code, name, description)
VALUES ("Trabalhadores Portu??rios", "Trabalhadores Portu??rios", "Trabalhadores Portu??rios");

INSERT INTO Priority_Group (code, name, description)
VALUES ("Funcion??rio do Sistema de Priva????o de Liberdade", "Funcion??rio do Sistema de Priva????o de Liberdade", "Funcion??rio do Sistema de Priva????o de Liberdade");

INSERT INTO Priority_Group (code, name, description)
VALUES ("Popula????o Privada de Liberdade", "Popula????o Privada de Liberdade", "Popula????o Privada de Liberdade");
-- End of Priority_Group

-- Priority_Category

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Anemia Falciforme", "Anemia Falciforme", 1, "Anemia Falciforme");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("C??ncer", "C??ncer", 1, "C??ncer");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Diabetes Mellitus", "Diabetes Mellitus", 1, "Diabetes Mellitus");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Doen??a Pulmonar Obstrutiva Cr??nica", "Doen??a Pulmonar Obstrutiva Cr??nica", 1, "Doen??a Pulmonar Obstrutiva Cr??nica");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Doen??a Renal", "Doen??a Renal", 1, "Doen??a Renal");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Doen??as Cardiovasculares e Cerebrovasculares", "Doen??as Cardiovasculares e Cerebrovasculares", 1, "Doen??as Cardiovasculares e Cerebrovasculares");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Hipertens??o de dif??cil controle ou com complica????es/les??o de ??rg??o alvo", "Hipertens??o de dif??cil controle ou com complica????es/les??o de ??rg??o alvo", 1, "Hipertens??o de dif??cil controle ou com complica????es/les??o de ??rg??o alvo");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Indiv??duos Transplantados de ??rg??o S??lido", "Indiv??duos Transplantados de ??rg??o S??lido", 1, "Indiv??duos Transplantados de ??rg??o S??lido");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Obesidade Grave (Imc???40)", "Obesidade Grave (Imc???40)", 1, "Obesidade Grave (Imc???40)");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("S??ndrome de Down", "S??ndrome de Down", 1, "S??ndrome de Down");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Pessoas de 60 a 64 anos", "Pessoas de 60 a 64 anos", 2, "Pessoas de 60 a 64 anos");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Pessoas de 65 a 69 anos", "Pessoas de 65 a 69 anos", 2, "Pessoas de 65 a 69 anos");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Pessoas de 70 a 74 anos", "Pessoas de 70 a 74 anos", 2, "Pessoas de 70 a 74 anos");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Pessoas de 75 a 79 anos", "Pessoas de 75 a 79 anos", 2, "Pessoas de 75 a 79 anos");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Pessoas de 80 anos ou mais", "Pessoas de 80 anos ou mais", 2, "Pessoas de 80 anos ou mais");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Pessoas de 60 nos ou mais Institucionalizadas", "Pessoas de 60 nos ou mais Institucionalizadas", 3, "Pessoas de 60 nos ou mais Institucionalizadas");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Marinha do Brasil - MB", "Marinha do Brasil - MB", 4, "Marinha do Brasil - MB");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Ex??rcito Brasileiro - EB", "Ex??rcito Brasileiro - EB", 4, "Ex??rcito Brasileiro - EB");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("For??a A??rea Brasileira - FAB", "For??a A??rea Brasileira - FAB", 4, "For??a A??rea Brasileira - FAB");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Bombeiro Civil", "Bombeiro Civil", 5, "Bombeiro Civil");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Bombeiro Militar", "Bombeiro Militar", 5, "Bombeiro Militar");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Guarda Municipal", "Guarda Municipal", 5, "Guarda Municipal");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Policial Rodovi??rio Federal", "Policial Rodovi??rio Federal", 5, "Policial Rodovi??rio Federal");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Policial Civil", "Policial Civil", 5, "Policial Civil");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Policial Federal", "Policial Federal", 5, "Policial Federal");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Policial Militar", "Policial Militar", 5, "Policial Militar");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Quilombola", "Quilombola", 6, "Quilombola");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Ribeirinha", "Ribeirinha", 6, "Ribeirinha");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Povos ind??genas em terras ind??genas", "Povos ind??genas em terras ind??genas", 7, "Povos ind??genas em terras ind??genas");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Ensino B??sico", "Ensino B??sico", 8, "Ensino B??sico");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Ensino Superior", "Ensino Superior", 8, "Ensino Superior");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Auxiliar de Veterin??rio", "Auxiliar de Veterin??rio", 9, "Auxiliar de Veterin??rio");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Bi??logo", "Bi??logo", 9, "Bi??logo");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Biom??dico", "Biom??dico", 9, "Biom??dico");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Cozinheiro e Auxiliares", "Cozinheiro e Auxiliares", 9, "Cozinheiro e Auxiliares");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Cuidador de Idosos", "Cuidador de Idosos", 9, "Cuidador de Idosos");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Doula/Parteira", "Doula/Parteira", 9, "Doula/Parteira");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Enfermeiro(a)", "Enfermeiro(a)", 9, "Enfermeiro(a)");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Farmac??utico", "Farmac??utico", 9, "Farmac??utico");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Fisioterapeutas", "Fisioterapeutas", 9, "Fisioterapeutas");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Fonoaudi??logo", "Fonoaudi??logo", 9, "Fonoaudi??logo");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Funcion??rio do Sistema Funer??rio que tenham contato com cad??veres potencialmente contaminados", "Funcion??rio do Sistema Funer??rio que tenham contato com cad??veres potencialmente contaminados", 9, "Funcion??rio do Sistema Funer??rio que tenham contato com cad??veres potencialmente contaminados");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("M??dico", "M??dico", 9, "M??dico");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("M??dico Veterin??rio", "M??dico Veterin??rio", 9, "M??dico Veterin??rio");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Motorista de Ambul??ncia", "Motorista de Ambul??ncia", 9, "Motorista de Ambul??ncia");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Nutricionista", "Nutricionista", 9, "Nutricionista");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Odontologista", "Odontologista", 9, "Odontologista");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Pessoal da Limpeza", "Pessoal da Limpeza", 9, "Pessoal da Limpeza");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Profissionais de Educa????o F??sica", "Profissionais de Educa????o F??sica", 9, "Profissionais de Educa????o F??sica");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Psic??logo", "Psic??logo", 9, "Psic??logo");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Recepcionista", "Recepcionista", 9, "Recepcionista");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Seguran??a", "Seguran??a", 9, "Seguran??a");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Assistentes Sociais", "Assistentes Sociais", 9, "Assistentes Sociais");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("T??cnico de Enfermagem", "T??cnico de Enfermagem", 9, "T??cnico de Enfermagem");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("T??cnico de Veterin??rio", "T??cnico de Veterin??rio", 9, "T??cnico de Veterin??rio");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Terapeuta Ocupacional", "Terapeuta Ocupacional", 9, "Terapeuta Ocupacional");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Outros", "Outros", 9, "Outros");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Auxiliar de Enfermagem", "Auxiliar de Enfermagem", 9, "Auxiliar de Enfermagem");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("T??cnico de Odontologia", "T??cnico de Odontologia", 9, "T??cnico de Odontologia");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("A??reo", "A??reo", 10, "A??reo");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Caminhoneiro", "Caminhoneiro", 10, "Caminhoneiro");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Coletivo Rodovi??rio Passageiros Urbano e de Longo Curso", "Coletivo Rodovi??rio Passageiros Urbano e de Longo Curso", 10, "Coletivo Rodovi??rio Passageiros Urbano e de Longo Curso");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Ferrovi??rio", "Ferrovi??rio", 10, "Ferrovi??rio");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Metrovi??rio", "Metrovi??rio", 10, "Metrovi??rio");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Aquavi??rio", "Aquavi??rio", 10, "Aquavi??rio");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Pessoas com Defici??ncia Institucionalizadas", "Pessoas com Defici??ncia Institucionalizadas", 11, "Pessoas com Defici??ncia Institucionalizadas");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Pessoas com Defici??ncias Permanente Grave", "Pessoas com Defici??ncias Permanente Grave", 11, "Pessoas com Defici??ncias Permanente Grave");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Pessoas em Situa????o de Rua", "Pessoas em Situa????o de Rua", 12, "Pessoas em Situa????o de Rua");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Trabalhadores Portu??rios", "Trabalhadores Portu??rios", 13, "Trabalhadores Portu??rios");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Funcion??rio do Sistema de Priva????o de Liberdade", "Funcion??rio do Sistema de Priva????o de Liberdade", 14, "Funcion??rio do Sistema de Priva????o de Liberdade");

INSERT INTO Priority_Category (code, name, priority_group, description)
VALUES ("Popula????o Privada de Liberdade", "Popula????o Privada de Liberdade", 15, "Popula????o Privada de Liberdade");