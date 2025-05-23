-- Wyświetlenie wszystkich dostępnych samochodów wraz z marką, modelem i kategorią
SELECT * FROM WidokDostepneSamochody;

-- Wyświetlenie tylko marek i modeli dostępnych samochodów
SELECT Marka, Model FROM WidokDostepneSamochody;

-- Wyświetlenie aktualnych wypożyczeń, pokazując nazwę samochodu i klienta
SELECT * FROM WidokAktualneWypozyczenia;

-- Wyświetlenie tylko nazwy samochodu i nazwiska klienta z aktualnych wypożyczeń
SELECT Samochod, Klient FROM WidokAktualneWypozyczenia;

-- Wyświetlenie historii wszystkich wypożyczeń
SELECT * FROM WidokHistoriaWypozyczen;

-- Wyświetlenie historii wypożyczeń dla konkretnego klienta
SELECT wh.Samochod, wh.DataWypozyczenia, wh.DataZwrotuRzeczywista, wh.KosztCalkowity
FROM WidokHistoriaWypozyczen wh
WHERE wh.Klient LIKE '%Kowalski%';