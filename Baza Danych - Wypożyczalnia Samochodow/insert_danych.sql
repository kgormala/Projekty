-- Wstawianie danych do tabeli MarkiSamochodow
INSERT INTO MarkiSamochodow (Nazwa) VALUES
('Toyota'),
('Ford'),
('BMW'),
('Audi'),
('Skoda');

-- Wstawianie danych do tabeli ModeleSamochodow
INSERT INTO ModeleSamochodow (MarkaID, Nazwa) VALUES
((SELECT MarkaID FROM MarkiSamochodow WHERE Nazwa = 'Toyota'), 'Corolla'),
((SELECT MarkaID FROM MarkiSamochodow WHERE Nazwa = 'Toyota'), 'RAV4'),
((SELECT MarkaID FROM MarkiSamochodow WHERE Nazwa = 'Ford'), 'Focus'),
((SELECT MarkaID FROM MarkiSamochodow WHERE Nazwa = 'Ford'), 'Mondeo'),
((SELECT MarkaID FROM MarkiSamochodow WHERE Nazwa = 'BMW'), 'Seria 3'),
((SELECT MarkaID FROM MarkiSamochodow WHERE Nazwa = 'BMW'), 'X5'),
((SELECT MarkaID FROM MarkiSamochodow WHERE Nazwa = 'Audi'), 'A4'),
((SELECT MarkaID FROM MarkiSamochodow WHERE Nazwa = 'Audi'), 'Q7'),
((SELECT MarkaID FROM MarkiSamochodow WHERE Nazwa = 'Skoda'), 'Octavia'),
((SELECT MarkaID FROM MarkiSamochodow WHERE Nazwa = 'Skoda'), 'Kodiaq');

-- Wstawianie danych do tabeli KategoriePojazdow
INSERT INTO KategoriePojazdow (Nazwa, StawkaDniowa) VALUES
('Ekonomiczny', 50.00),
('Kompaktowy', 75.00),
('SUV', 120.00),
('Premium', 150.00);

-- Wstawianie danych do tabeli Samochody
INSERT INTO Samochody (ModelID, KategoriaID, NumerRejestracyjny, RokProdukcji, Przebieg) VALUES
((SELECT ModelID FROM ModeleSamochodow WHERE Nazwa = 'Corolla'), (SELECT KategoriaID FROM KategoriePojazdow WHERE Nazwa = 'Ekonomiczny'), 'KR12345', 2020, 55000),
((SELECT ModelID FROM ModeleSamochodow WHERE Nazwa = 'RAV4'), (SELECT KategoriaID FROM KategoriePojazdow WHERE Nazwa = 'SUV'), 'KR67890', 2021, 40000),
((SELECT ModelID FROM ModeleSamochodow WHERE Nazwa = 'Focus'), (SELECT KategoriaID FROM KategoriePojazdow WHERE Nazwa = 'Kompaktowy'), 'WA54321', 2019, 62000),
((SELECT ModelID FROM ModeleSamochodow WHERE Nazwa = 'Seria 3'), (SELECT KategoriaID FROM KategoriePojazdow WHERE Nazwa = 'Premium'), 'DW98765', 2022, 30000),
((SELECT ModelID FROM ModeleSamochodow WHERE Nazwa = 'Octavia'), (SELECT KategoriaID FROM KategoriePojazdow WHERE Nazwa = 'Kompaktowy'), 'PO11223', 2023, 20000),
((SELECT ModelID FROM ModeleSamochodow WHERE Nazwa = 'Q7'), (SELECT KategoriaID FROM KategoriePojazdow WHERE Nazwa = 'SUV'), 'SL44556', 2020, 70000);

-- Wstawianie danych do tabeli Klienci
INSERT INTO Klienci (Imie, Nazwisko, Adres, NumerTelefonu, Email) VALUES
('Jan', 'Kowalski', 'ul. Kwiatowa 10, Kraków', '123-456-789', 'jan.kowalski@email.com'),
('Anna', 'Nowak', 'al. Jana Paw³a II 5, Warszawa', '987-654-321', 'anna.nowak@poczta.pl'),
('Piotr', 'Wiœniewski', 'ul. D³uga 15, Gdañsk', '555-123-456', 'piotr.wisniewski@gmail.com'),
('Katarzyna', 'Zaj¹c', 'Rynek G³ówny 20, Wroc³aw', '666-777-888', 'katarzyna.zajac@onet.pl');

-- Wstawianie danych do tabeli Wypozyczenia
INSERT INTO Wypozyczenia (SamochodID, KlientID, DataZwrotuPlanowana) VALUES
((SELECT SamochodID FROM Samochody WHERE NumerRejestracyjny = 'KR12345'), (SELECT KlientID FROM Klienci WHERE Nazwisko = 'Kowalski'), '2025-05-05'),
((SELECT SamochodID FROM Samochody WHERE NumerRejestracyjny = 'WA54321'), (SELECT KlientID FROM Klienci WHERE Nazwisko = 'Nowak'), '2025-05-10'),
((SELECT SamochodID FROM Samochody WHERE NumerRejestracyjny = 'DW98765'), (SELECT KlientID FROM Klienci WHERE Nazwisko = 'Wiœniewski'), '2025-05-03'),
((SELECT SamochodID FROM Samochody WHERE NumerRejestracyjny = 'PO11223'), (SELECT KlientID FROM Klienci WHERE Nazwisko = 'Zaj¹c'), '2025-05-12');
