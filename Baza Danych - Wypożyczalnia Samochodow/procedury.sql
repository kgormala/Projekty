-- Dodawanie nowej marki samochodu
CREATE PROCEDURE DodajMarkeSamochodu (@Nazwa NVARCHAR(50))
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM MarkiSamochodow WHERE Nazwa = @Nazwa)
    BEGIN
        INSERT INTO MarkiSamochodow (Nazwa) VALUES (@Nazwa);
    END;
END;
GO

-- Dodawanie nowego modelu samochodu
CREATE PROCEDURE DodajModelSamochodu (@MarkaID INT, @Nazwa NVARCHAR(50))
AS
BEGIN
    IF EXISTS (SELECT 1 FROM MarkiSamochodow WHERE MarkaID = @MarkaID) AND
       NOT EXISTS (SELECT 1 FROM ModeleSamochodow WHERE MarkaID = @MarkaID AND Nazwa = @Nazwa)
    BEGIN
        INSERT INTO ModeleSamochodow (MarkaID, Nazwa) VALUES (@MarkaID, @Nazwa);
    END;
END;
GO

-- Dodawanie nowej kategorii pojazdu
CREATE PROCEDURE DodajKategoriePojazdow (@Nazwa NVARCHAR(50), @StawkaDniowa DECIMAL(10, 2))
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM KategoriePojazdow WHERE Nazwa = @Nazwa)
    BEGIN
        INSERT INTO KategoriePojazdow (Nazwa, StawkaDniowa) VALUES (@Nazwa, @StawkaDniowa);
    END;
END;
GO

-- Dodawanie nowego samochodu
CREATE PROCEDURE DodajSamochod (
    @ModelID INT,
    @KategoriaID INT,
    @NumerRejestracyjny VARCHAR(20),
    @RokProdukcji INT = NULL,
    @Przebieg INT = NULL
)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM ModeleSamochodow WHERE ModelID = @ModelID) AND
       EXISTS (SELECT 1 FROM KategoriePojazdow WHERE KategoriaID = @KategoriaID) AND
       NOT EXISTS (SELECT 1 FROM Samochody WHERE NumerRejestracyjny = @NumerRejestracyjny)
    BEGIN
        INSERT INTO Samochody (ModelID, KategoriaID, NumerRejestracyjny, RokProdukcji, Przebieg)
        VALUES (@ModelID, @KategoriaID, @NumerRejestracyjny, @RokProdukcji, @Przebieg);
    END;
END;
GO

-- Dodawanie nowego klienta
CREATE PROCEDURE DodajKlienta (
    @Imie NVARCHAR(50),
    @Nazwisko NVARCHAR(50),
    @Adres NVARCHAR(255) = NULL,
    @NumerTelefonu VARCHAR(20) = NULL,
    @Email VARCHAR(100) = NULL
)
AS
BEGIN
    IF @Email IS NULL OR NOT EXISTS (SELECT 1 FROM Klienci WHERE Email = @Email)
    BEGIN
        INSERT INTO Klienci (Imie, Nazwisko, Adres, NumerTelefonu, Email)
        VALUES (@Imie, @Nazwisko, @Adres, @NumerTelefonu, @Email);
    END;
END;
GO

-- Wypo¿yczenie samochodu
CREATE PROCEDURE WypozyczSamochod (@SamochodID INT, @KlientID INT, @DataZwrotuPlanowana DATE)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Samochody WHERE SamochodID = @SamochodID AND CzyDostepny = 1) AND
       EXISTS (SELECT 1 FROM Klienci WHERE KlientID = @KlientID)
    BEGIN
        INSERT INTO Wypozyczenia (SamochodID, KlientID, DataZwrotuPlanowana)
        VALUES (@SamochodID, @KlientID, @DataZwrotuPlanowana);

        UPDATE Samochody SET CzyDostepny = 0 WHERE SamochodID = @SamochodID;
    END
    ELSE
    BEGIN
        RAISERROR('Samochód jest niedostêpny lub nie istnieje podany klient.', 16, 1);
        RETURN;
    END;
END;
GO

-- Zwrot samochodu
CREATE PROCEDURE ZwrocSamochod (@WypozyczenieID INT, @DataZwrotuRzeczywista DATE = NULL)
AS
BEGIN
    DECLARE @SamochodID_temp INT;
    DECLARE @DataWyp DATE;
    DECLARE @StawkaDniowa DECIMAL(10, 2);
    DECLARE @DniWypozyczenia INT;

    SELECT @SamochodID_temp = w.SamochodID, @DataWyp = w.DataWypozyczenia
    FROM Wypozyczenia w
    WHERE w.WypozyczenieID = @WypozyczenieID AND w.DataZwrotuRzeczywista IS NULL;

    SELECT @StawkaDniowa = cp.StawkaDniowa
    FROM Samochody s
    JOIN KategoriePojazdow cp ON s.KategoriaID = cp.KategoriaID
    WHERE s.SamochodID = @SamochodID_temp;

    IF @SamochodID_temp IS NOT NULL
    BEGIN
        UPDATE Wypozyczenia
        SET DataZwrotuRzeczywista = ISNULL(@DataZwrotuRzeczywista, GETDATE()),
            KosztCalkowity = DATEDIFF(day, @DataWyp, ISNULL(@DataZwrotuRzeczywista, GETDATE())) * @StawkaDniowa
        WHERE WypozyczenieID = @WypozyczenieID;

        UPDATE Samochody SET CzyDostepny = 1 WHERE SamochodID = @SamochodID_temp;
    END
    ELSE
    BEGIN
        RAISERROR('Nieprawid³owe ID wypo¿yczenia lub samochód zosta³ ju¿ zwrócony.', 16, 1);
        RETURN;
    END;
END;
GO