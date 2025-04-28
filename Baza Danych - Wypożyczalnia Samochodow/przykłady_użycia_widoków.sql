-- Wyœwietlenie wszystkich dostêpnych samochodów wraz z mark¹, modelem i kategori¹
SELECT * FROM WidokDostepneSamochody;

-- Wyœwietlenie tylko marek i modeli dostêpnych samochodów
SELECT Marka, Model FROM WidokDostepneSamochody;

-- Wyœwietlenie aktualnych wypo¿yczeñ, pokazuj¹c nazwê samochodu i klienta
SELECT * FROM WidokAktualneWypozyczenia;

-- Wyœwietlenie tylko nazwy samochodu i nazwiska klienta z aktualnych wypo¿yczeñ
SELECT Samochod, Klient FROM WidokAktualneWypozyczenia;

-- Wyœwietlenie historii wszystkich wypo¿yczeñ
SELECT * FROM WidokHistoriaWypozyczen;

-- Wyœwietlenie historii wypo¿yczeñ dla konkretnego klienta
SELECT wh.Samochod, wh.DataWypozyczenia, wh.DataZwrotuRzeczywista, wh.KosztCalkowity
FROM WidokHistoriaWypozyczen wh
WHERE wh.Klient LIKE '%Kowalski%';