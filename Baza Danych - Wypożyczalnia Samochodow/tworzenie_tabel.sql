CREATE DATABASE WypozyczalniaSamochodow;

USE WypozyczalniaSamochodow;

CREATE TABLE MarkiSamochodow (
    MarkaID INT PRIMARY KEY IDENTITY(1,1),
    Nazwa NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE ModeleSamochodow (
    ModelID INT PRIMARY KEY IDENTITY(1,1),
    MarkaID INT NOT NULL,
    Nazwa NVARCHAR(50) NOT NULL,
    FOREIGN KEY (MarkaID) REFERENCES MarkiSamochodow(MarkaID),
    UNIQUE (MarkaID, Nazwa)
);

CREATE TABLE KategoriePojazdow (
    KategoriaID INT PRIMARY KEY IDENTITY(1,1),
    Nazwa NVARCHAR(50) NOT NULL UNIQUE,
    StawkaDniowa DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Samochody (
    SamochodID INT PRIMARY KEY IDENTITY(1,1),
    ModelID INT NOT NULL,
    KategoriaID INT NOT NULL,
    NumerRejestracyjny VARCHAR(20) NOT NULL UNIQUE,
    RokProdukcji INT,
    Przebieg INT,
    CzyDostepny BIT NOT NULL DEFAULT 1, -- 1 oznacza dostêpny, 0 niedostêpny
    FOREIGN KEY (ModelID) REFERENCES ModeleSamochodow(ModelID),
    FOREIGN KEY (KategoriaID) REFERENCES KategoriePojazdow(KategoriaID)
);

CREATE TABLE Klienci (
    KlientID INT PRIMARY KEY IDENTITY(1,1),
    Imie NVARCHAR(50) NOT NULL,
    Nazwisko NVARCHAR(50) NOT NULL,
    Adres NVARCHAR(255),
    NumerTelefonu VARCHAR(20),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE Wypozyczenia (
    WypozyczenieID INT PRIMARY KEY IDENTITY(1,1),
    SamochodID INT NOT NULL,
    KlientID INT NOT NULL,
    DataWypozyczenia DATE NOT NULL DEFAULT GETDATE(),
    DataZwrotuPlanowana DATE NOT NULL,
    DataZwrotuRzeczywista DATE,
    KosztCalkowity DECIMAL(10, 2),
    FOREIGN KEY (SamochodID) REFERENCES Samochody(SamochodID),
    FOREIGN KEY (KlientID) REFERENCES Klienci(KlientID)
);