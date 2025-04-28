-- Widok dostêpnych samochodów z informacjami o marce, modelu i kategorii
CREATE VIEW WidokDostepneSamochody
AS
SELECT
    s.SamochodID,
    ms.Nazwa AS Marka,
    md.Nazwa AS Model,
    kp.Nazwa AS Kategoria,
    s.NumerRejestracyjny,
    s.RokProdukcji,
    s.Przebieg
FROM Samochody s
JOIN ModeleSamochodow md ON s.ModelID = md.ModelID
JOIN MarkiSamochodow ms ON md.MarkaID = ms.MarkaID
JOIN KategoriePojazdow kp ON s.KategoriaID = kp.KategoriaID
WHERE s.CzyDostepny = 1;
GO

-- Widok aktualnych wypo¿yczeñ z informacjami o samochodzie i kliencie
CREATE VIEW WidokAktualneWypozyczenia
AS
SELECT
    w.WypozyczenieID,
    ms.Nazwa + ' ' + md.Nazwa AS Samochod,
    s.NumerRejestracyjny,
    k.Imie + ' ' + k.Nazwisko AS Klient,
    w.DataWypozyczenia,
    w.DataZwrotuPlanowana
FROM Wypozyczenia w
JOIN Samochody s ON w.SamochodID = s.SamochodID
JOIN Klienci k ON w.KlientID = k.KlientID
JOIN ModeleSamochodow md ON s.ModelID = md.ModelID
JOIN MarkiSamochodow ms ON md.MarkaID = ms.MarkaID
WHERE w.DataZwrotuRzeczywista IS NULL;
GO

-- Widok historii wypo¿yczeñ
CREATE VIEW WidokHistoriaWypozyczen
AS
SELECT
    w.WypozyczenieID,
    ms.Nazwa + ' ' + md.Nazwa AS Samochod,
    s.NumerRejestracyjny,
    k.Imie + ' ' + k.Nazwisko AS Klient,
    w.DataWypozyczenia,
    w.DataZwrotuPlanowana,
    w.DataZwrotuRzeczywista,
    w.KosztCalkowity
FROM Wypozyczenia w
JOIN Samochody s ON w.SamochodID = s.SamochodID
JOIN Klienci k ON w.KlientID = k.KlientID
JOIN ModeleSamochodow md ON s.ModelID = md.ModelID
JOIN MarkiSamochodow ms ON md.MarkaID = ms.MarkaID;
GO