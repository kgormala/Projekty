-- Wyzwalacz, który automatycznie ustawia 'CzyDostepny' na 0 przy dodawaniu nowego wypo¿yczenia (alternatywnie do procedury WypozyczSamochod)
 CREATE TRIGGER Tr_PoWypozyczeniu
 ON Wypozyczenia
 AFTER INSERT
 AS
 BEGIN
     UPDATE Samochody
     SET CzyDostepny = 0
     WHERE SamochodID IN (SELECT SamochodID FROM inserted);
 END;
 GO


-- Wyzwalacz, który uniemo¿liwia usuniêcie marki samochodu, jeœli istniej¹ powi¹zane modele
CREATE TRIGGER Tr_BlokujUsuniecieMarki
ON MarkiSamochodow
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM ModeleSamochodow WHERE MarkaID IN (SELECT MarkaID FROM deleted))
    BEGIN
        RAISERROR('Nie mo¿na usun¹æ marki, poniewa¿ istniej¹ powi¹zane modele samochodów.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    ELSE
    BEGIN
        DELETE FROM MarkiSamochodow WHERE MarkaID IN (SELECT MarkaID FROM deleted);
    END;
END;
GO

-- Wyzwalacz, który uniemo¿liwia usuniêcie kategorii pojazdu, jeœli istniej¹ powi¹zane samochody
CREATE TRIGGER Tr_BlokujUsuniecieKategorii
ON KategoriePojazdow
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Samochody WHERE KategoriaID IN (SELECT KategoriaID FROM deleted))
    BEGIN
        RAISERROR('Nie mo¿na usun¹æ kategorii, poniewa¿ istniej¹ powi¹zane samochody.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    ELSE
    BEGIN
        DELETE FROM KategoriePojazdow WHERE KategoriaID IN (SELECT KategoriaID FROM deleted);
    END;
END;
GO