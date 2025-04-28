-- Wy�wietlenie wszystkich dost�pnych samochod�w wraz z mark�, modelem i kategori�
SELECT * FROM WidokDostepneSamochody;

-- Wy�wietlenie tylko marek i modeli dost�pnych samochod�w
SELECT Marka, Model FROM WidokDostepneSamochody;

-- Wy�wietlenie aktualnych wypo�ycze�, pokazuj�c nazw� samochodu i klienta
SELECT * FROM WidokAktualneWypozyczenia;

-- Wy�wietlenie tylko nazwy samochodu i nazwiska klienta z aktualnych wypo�ycze�
SELECT Samochod, Klient FROM WidokAktualneWypozyczenia;

-- Wy�wietlenie historii wszystkich wypo�ycze�
SELECT * FROM WidokHistoriaWypozyczen;

-- Wy�wietlenie historii wypo�ycze� dla konkretnego klienta
SELECT wh.Samochod, wh.DataWypozyczenia, wh.DataZwrotuRzeczywista, wh.KosztCalkowity
FROM WidokHistoriaWypozyczen wh
WHERE wh.Klient LIKE '%Kowalski%';