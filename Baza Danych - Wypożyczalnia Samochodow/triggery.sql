-- Wyzwalacz, kt�ry automatycznie ustawia 'CzyDostepny' na 0 przy dodawaniu nowego wypo�yczenia (alternatywnie do procedury WypozyczSamochod)
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


-- Wyzwalacz, kt�ry uniemo�liwia usuni�cie marki samochodu, je�li istniej� powi�zane modele
CREATE TRIGGER Tr_BlokujUsuniecieMarki
ON MarkiSamochodow
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM ModeleSamochodow WHERE MarkaID IN (SELECT MarkaID FROM deleted))
    BEGIN
        RAISERROR('Nie mo�na usun�� marki, poniewa� istniej� powi�zane modele samochod�w.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    ELSE
    BEGIN
        DELETE FROM MarkiSamochodow WHERE MarkaID IN (SELECT MarkaID FROM deleted);
    END;
END;
GO

-- Wyzwalacz, kt�ry uniemo�liwia usuni�cie kategorii pojazdu, je�li istniej� powi�zane samochody
CREATE TRIGGER Tr_BlokujUsuniecieKategorii
ON KategoriePojazdow
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Samochody WHERE KategoriaID IN (SELECT KategoriaID FROM deleted))
    BEGIN
        RAISERROR('Nie mo�na usun�� kategorii, poniewa� istniej� powi�zane samochody.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    ELSE
    BEGIN
        DELETE FROM KategoriePojazdow WHERE KategoriaID IN (SELECT KategoriaID FROM deleted);
    END;
END;
GO