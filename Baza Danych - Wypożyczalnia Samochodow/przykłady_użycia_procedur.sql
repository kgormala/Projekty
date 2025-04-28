-- Dodanie nowej marki samochodu
EXEC DodajMarkeSamochodu @Nazwa = 'Tesla';

-- Dodanie nowego modelu samochodu dla istniej�cej marki
DECLARE @markaID INT;
SELECT @markaID = MarkaID
FROM MarkiSamochodow
WHERE Nazwa = 'Tesla';

EXEC DodajModelSamochodu @MarkaID = @markaID, @Nazwa = 'Model 3';


-- Dodanie nowej kategorii pojazdu
EXEC DodajKategoriePojazdow @Nazwa = 'Elektryczny', @StawkaDniowa = 180.00;

-- Dodanie nowego samochodu
DECLARE @ModelID INT;
DECLARE @KategoriaID INT;

SELECT @ModelID = ModelID
FROM ModeleSamochodow
WHERE Nazwa = 'Model 3';

SELECT @KategoriaID = KategoriaID
FROM KategoriePojazdow
WHERE Nazwa = 'Elektryczny';

EXEC DodajSamochod
    @ModelID = @ModelID,
    @KategoriaID = @KategoriaID,
    @NumerRejestracyjny = 'EL00001',
    @RokProdukcji = 2024,
    @Przebieg = 10000;


-- Dodanie nowego klienta
EXEC DodajKlienta
    @Imie = 'Marek',
    @Nazwisko = 'Nowacki',
    @Adres = 'ul. S�oneczna 3, Pozna�',
    @NumerTelefonu = '444-555-666',
    @Email = 'marek.nowacki@wp.pl';

-- Pr�ba wypo�yczenia niedost�pnego samochodu (powinna zwr�ci� b��d)
DECLARE @SamochodID INT;
DECLARE @KlientID INT;

SELECT @SamochodID = SamochodID
FROM Samochody
WHERE NumerRejestracyjny = 'KR12345';

SELECT @KlientID = KlientID
FROM Klienci
WHERE Nazwisko = 'Nowak';

EXEC WypozyczSamochod
    @SamochodID = @SamochodID,
    @KlientID = @KlientID,
    @DataZwrotuPlanowana = '2024-06-20';


-- Zwr�cenie samochodu
EXEC ZwrocSamochod @WypozyczenieID = 1, @DataZwrotuRzeczywista = '2024-06-14';

-- Zwr�cenie samochodu bez podawania daty zwrotu (u�yje aktualnej daty)
EXEC ZwrocSamochod @WypozyczenieID = 2;