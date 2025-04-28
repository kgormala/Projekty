-- Tworzenie bazy danych
CREATE DATABASE PrzedszkoleDB;
GO

USE PrzedszkoleDB;
GO

-- Tworzenie tabel
CREATE TABLE Rodzice (
    IdRodzica INT PRIMARY KEY IDENTITY(1,1),
    Imie NVARCHAR(50) NOT NULL,
    Nazwisko NVARCHAR(50) NOT NULL
);

CREATE TABLE Personel (
    IdPersonelu INT PRIMARY KEY IDENTITY(1,1),
    Imie NVARCHAR(50) NOT NULL,
    Nazwisko NVARCHAR(50) NOT NULL
);

CREATE TABLE Grupy (
    IdGrupy INT PRIMARY KEY IDENTITY(1,1),
    NazwaGrupy NVARCHAR(50) NOT NULL,
    IdPersonelu INT FOREIGN KEY REFERENCES Personel(IdPersonelu)
);

CREATE TABLE Dzieci (
    IdDziecka INT PRIMARY KEY IDENTITY(1,1),
    Imie NVARCHAR(50) NOT NULL,
    Nazwisko NVARCHAR(50) NOT NULL,
    DataUrodzenia DATE NOT NULL,
    InformacjeMedyczne NVARCHAR(MAX) CHECK (ISJSON(InformacjeMedyczne) = 1),
    IdGrupy INT FOREIGN KEY REFERENCES Grupy(IdGrupy),
    IdRodzica INT FOREIGN KEY REFERENCES Rodzice(IdRodzica)
);

CREATE TABLE Dyzury (
    IdDyzuru INT PRIMARY KEY IDENTITY(1,1),
    IdPersonelu INT FOREIGN KEY REFERENCES Personel(IdPersonelu),
    IdGrupy INT FOREIGN KEY REFERENCES Grupy(IdGrupy),
    CzasRozpoczecia DATETIME NOT NULL,
    CzasZakonczenia DATETIME NOT NULL
);

CREATE TABLE Wyposazenie (
    IdWyposazenia INT PRIMARY KEY IDENTITY(1,1),
    Nazwa NVARCHAR(100) NOT NULL,
    Kategoria NVARCHAR(50) NOT NULL,
    Ilosc INT NOT NULL CHECK (Ilosc >= 0),
    IdGrupy INT FOREIGN KEY REFERENCES Grupy(IdGrupy)
);

CREATE TABLE Zakupy (
    IdZakupu INT PRIMARY KEY IDENTITY(1,1),
    IdWyposazenia INT FOREIGN KEY REFERENCES Wyposazenie(IdWyposazenia),
    DataZakupu DATE NOT NULL,
    Ilosc INT NOT NULL,
    Koszt DECIMAL(10,2) NOT NULL
);

CREATE TABLE Opinie (
    IdOpinii INT PRIMARY KEY IDENTITY(1,1),
    Ocena INT NOT NULL CHECK (Ocena BETWEEN 1 AND 5),
    Komentarz NVARCHAR(MAX),
    IdRodzica INT FOREIGN KEY REFERENCES Rodzice(IdRodzica)
);

-- Indeksy
CREATE INDEX IX_Dzieci_IdGrupy ON Dzieci(IdGrupy);
CREATE INDEX IX_Dyzury_IdPersonelu ON Dyzury(IdPersonelu);
CREATE INDEX IX_Zakupy_IdWyposazenia ON Zakupy(IdWyposazenia);
CREATE INDEX IX_Wyposazenie_IdGrupy ON Wyposazenie(IdGrupy);

-- Indeks pe³notekstowy (jeœli Full-Text Search jest zainstalowany)
CREATE UNIQUE NONCLUSTERED INDEX UQ_IdOpinii ON Opinie(IdOpinii);
CREATE FULLTEXT CATALOG PrzedszkoleFullTextCatalog AS DEFAULT;
CREATE FULLTEXT INDEX ON Opinie(Komentarz) KEY INDEX UQ_IdOpinii;