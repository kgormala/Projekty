USE PrzedszkoleDB;
GO

-- Rodzice (10 rekordów)
INSERT INTO Rodzice (Imie, Nazwisko) VALUES 
('Katarzyna', 'Kowalska'), ('Tomasz', 'Nowak'), ('Magdalena', 'Wiœniewska'), 
('Jan', 'D¹browski'), ('Anna', 'Lewandowska'), ('Piotr', 'Zieliñski'), 
('Ewa', 'Kaczmarek'), ('Marek', 'Szymañski'), ('Alicja', 'WoŸniak'), 
('Krzysztof', 'Jankowski');

-- Personel (5 rekordów)
INSERT INTO Personel (Imie, Nazwisko) VALUES 
('Anna', 'Kowalska'), ('Piotr', 'Nowak'), ('Joanna', 'Mazur'), 
('Tomasz', 'Wójcik'), ('Barbara', 'Kamiñska');

-- Grupy (4 rekordy)
INSERT INTO Grupy (NazwaGrupy, IdPersonelu) VALUES 
('S³oneczniki', 1), ('Têcze', 2), ('Biedronki', 3), ('Motylki', 4);

-- Dzieci (15 rekordów)
INSERT INTO Dzieci (Imie, Nazwisko, DataUrodzenia, InformacjeMedyczne, IdGrupy, IdRodzica) VALUES 
('Jan', 'Kowalski', '2020-05-15', '{"allergie": ["orzechy"], "uwagi": "wymaga epipenu"}', 1, 1),
('Maria', 'Nowak', '2019-11-20', '{"allergie": [], "uwagi": "brak"}', 2, 2),
('Zofia', 'Wiœniewska', '2020-03-10', '{"allergie": ["mleko"], "uwagi": "dieta bezlaktozowa"}', 1, 3),
('Jakub', 'D¹browski', '2019-08-25', '{"allergie": [], "uwagi": "brak"}', 3, 4),
('Alicja', 'Lewandowska', '2020-07-12', '{"allergie": ["py³ki"], "uwagi": "inhalator"}', 2, 5),
('Kacper', 'Zieliñski', '2019-12-01', '{"allergie": [], "uwagi": "brak"}', 4, 6),
('Lena', 'Kaczmarek', '2020-01-30', '{"allergie": ["jajka"], "uwagi": "unikaæ jajek"}', 3, 7),
('Miko³aj', 'Szymañski', '2019-09-15', '{"allergie": [], "uwagi": "brak"}', 1, 8),
('Julia', 'WoŸniak', '2020-04-22', '{"allergie": ["koty"], "uwagi": "astma"}', 4, 9),
('Oliwia', 'Jankowska', '2019-10-05', '{"allergie": [], "uwagi": "brak"}', 2, 10),
('Emilia', 'Kowalska', '2020-06-18', '{"allergie": ["orzechy"], "uwagi": "wymaga epipenu"}', 3, 1),
('Filip', 'Nowak', '2019-07-30', '{"allergie": [], "uwagi": "brak"}', 4, 2),
('Hanna', 'Wiœniewska', '2020-02-14', '{"allergie": ["gluten"], "uwagi": "dieta bezglutenowa"}', 1, 3),
('Igor', 'D¹browski', '2019-11-11', '{"allergie": [], "uwagi": "brak"}', 2, 4),
('Natalia', 'Lewandowska', '2020-08-09', '{"allergie": ["truskawki"], "uwagi": "unikaæ owoców"}', 3, 5);

-- Dy¿ury (10 rekordów)
INSERT INTO Dyzury (IdPersonelu, IdGrupy, CzasRozpoczecia, CzasZakonczenia) VALUES 
(1, 1, '2025-03-04 08:00', '2025-03-04 14:00'), (2, 2, '2025-03-04 08:00', '2025-03-04 14:00'),
(3, 3, '2025-03-04 08:00', '2025-03-04 14:00'), (4, 4, '2025-03-04 08:00', '2025-03-04 14:00'),
(5, 1, '2025-03-05 08:00', '2025-03-05 14:00'), (1, 2, '2025-03-05 08:00', '2025-03-05 14:00'),
(2, 3, '2025-03-05 08:00', '2025-03-05 14:00'), (3, 4, '2025-03-05 08:00', '2025-03-05 14:00'),
(4, 1, '2025-03-06 08:00', '2025-03-06 14:00'), (5, 2, '2025-03-06 08:00', '2025-03-06 14:00');

-- Wyposa¿enie (10 rekordów)
INSERT INTO Wyposazenie (Nazwa, Kategoria, Ilosc, IdGrupy) VALUES 
('Klocki', 'Zabawki', 50, 1), ('Myd³o', 'Higiena', 10, 2), ('Kredki', 'Artyku³y plastyczne', 30, 3),
('Pi³ka', 'Zabawki', 15, 4), ('Papier kolorowy', 'Artyku³y plastyczne', 100, 1),
('Rêczniki papierowe', 'Higiena', 20, 2), ('Puzzle', 'Zabawki', 25, 3),
('Farbki', 'Artyku³y plastyczne', 40, 4), ('Chusteczki', 'Higiena', 50, 1), ('Lalka', 'Zabawki', 10, 2);

-- Zakupy (12 rekordów)
INSERT INTO Zakupy (IdWyposazenia, DataZakupu, Ilosc, Koszt) VALUES 
(1, '2025-02-01', 20, 50.00), (2, '2025-02-15', 5, 15.00), (3, '2025-02-10', 10, 25.00),
(4, '2025-02-20', 5, 10.00), (5, '2025-02-05', 50, 30.00), (6, '2025-02-25', 10, 20.00),
(7, '2025-02-12', 15, 35.00), (8, '2025-02-18', 20, 40.00), (9, '2025-02-08', 30, 15.00),
(10, '2025-02-22', 5, 25.00), (1, '2025-03-01', 10, 25.00), (2, '2025-03-02', 5, 15.00);

-- Opinie (10 rekordów)
INSERT INTO Opinie (Ocena, Komentarz, IdRodzica) VALUES 
(4, 'Œwietny personel, ale wiêcej zabawek by³oby mi³o!', 1),
(5, 'Cudowne przedszkole, bardzo polecam.', 2),
(3, 'Dobre podejœcie do dzieci, ale czasem chaos.', 3),
(5, 'Moje dziecko uwielbia grupê Biedronki!', 4),
(4, 'Opiekunowie s¹ super, ale plac zabaw wymaga remontu.', 5),
(5, 'Wszystko œwietnie zorganizowane.', 6),
(2, 'Za ma³o uwagi na alergie mojego dziecka.', 7),
(4, 'Dobra atmosfera, polecam.', 8),
(5, 'Najlepsze przedszkole w okolicy!', 9),
(3, 'Czasem brakuje komunikacji z rodzicami.', 10);