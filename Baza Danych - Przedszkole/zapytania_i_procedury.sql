USE PrzedszkoleDB;
GO

-- Zapytanie 1: Lista dzieci z alergiami
SELECT 
    d.Imie,
    d.Nazwisko,
    g.NazwaGrupy,
    JSON_VALUE(d.InformacjeMedyczne, '$.allergie[0]') AS PierwszaAlergia,
    JSON_VALUE(d.InformacjeMedyczne, '$.uwagi') AS Uwagi
FROM Dzieci d
JOIN Grupy g ON d.IdGrupy = g.IdGrupy
WHERE JSON_VALUE(d.InformacjeMedyczne, '$.allergie[0]') IS NOT NULL
ORDER BY g.NazwaGrupy, d.Nazwisko;

-- Zapytanie 2: Œrednia ocena opinii od rodziców dla ka¿dej grupy
SELECT 
    g.NazwaGrupy,
    AVG(o.Ocena) AS SredniaOcena,
    COUNT(o.IdOpinii) AS LiczbaOpinii
FROM Grupy g
JOIN Dzieci d ON d.IdGrupy = g.IdGrupy
JOIN Rodzice r ON r.IdRodzica = d.IdRodzica
LEFT JOIN Opinie o ON o.IdRodzica = r.IdRodzica
GROUP BY g.NazwaGrupy
ORDER BY SredniaOcena DESC;

-- Zapytanie 3: Wyposa¿enie z niskim stanem
SELECT 
    w.Nazwa,
    w.Kategoria,
    w.Ilosc,
    g.NazwaGrupy
FROM Wyposazenie w
JOIN Grupy g ON w.IdGrupy = g.IdGrupy
WHERE w.Ilosc < 10
ORDER BY w.Ilosc ASC;

-- Procedura 1: Dodanie nowego zakupu
CREATE PROCEDURE DodajZakup
    @IdWyposazenia INT,
    @DataZakupu DATE,
    @Ilosc INT,
    @Koszt DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Zakupy (IdWyposazenia, DataZakupu, Ilosc, Koszt)
    VALUES (@IdWyposazenia, @DataZakupu, @Ilosc, @Koszt);
    UPDATE Wyposazenie SET Ilosc = Ilosc + @Ilosc WHERE IdWyposazenia = @IdWyposazenia;
END;
GO

-- Procedura 2: Dzieci z okreœlon¹ alergi¹
CREATE PROCEDURE ZnajdzDzieciZAllegia
    @Alergia NVARCHAR(50)
AS
BEGIN
    SELECT 
        d.Imie,
        d.Nazwisko,
        g.NazwaGrupy,
        d.InformacjeMedyczne
    FROM Dzieci d
    JOIN Grupy g ON d.IdGrupy = g.IdGrupy
    WHERE EXISTS (
        SELECT 1
        FROM OPENJSON(d.InformacjeMedyczne, '$.allergie') AS alergie
        WHERE alergie.value = @Alergia
    )
    ORDER BY d.Nazwisko;
END;
GO

-- Procedura 3: Raport miesiêczny zakupów dla grupy
CREATE PROCEDURE RaportZakupowGrupy
    @IdGrupy INT,
    @Miesiac DATE
AS
BEGIN
    SELECT 
        g.NazwaGrupy,
        w.Nazwa AS NazwaWyposazenia,
        z.DataZakupu,
        z.Ilosc,
        z.Koszt,
        SUM(z.Koszt) OVER (PARTITION BY g.NazwaGrupy) AS CalkowityKoszt
    FROM Zakupy z
    JOIN Wyposazenie w ON z.IdWyposazenia = w.IdWyposazenia
    JOIN Grupy g ON w.IdGrupy = g.IdGrupy
    WHERE w.IdGrupy = @IdGrupy
        AND YEAR(z.DataZakupu) = YEAR(@Miesiac)
        AND MONTH(z.DataZakupu) = MONTH(@Miesiac)
    ORDER BY z.DataZakupu;
END;
GO