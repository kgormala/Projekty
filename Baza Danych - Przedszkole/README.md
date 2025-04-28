# Baza Danych PrzedszkoleDB - System Wspierający Zarządzanie Przedszkolem

## Opis Projektu

Projekt bazy danych PrzedszkoleDB został stworzony, aby kompleksowo wspierać zarządzanie małym przedszkolem. Baza danych organizuje kluczowe informacje w osiem powiązanych tabel, umożliwiając efektywne zarządzanie różnorodnymi aspektami działalności przedszkola.

## Technologie Użyte

* **Język Bazy Danych:** T-SQL
* **System Zarządzania Bazą Danych (DBMS):** Microsoft SQL Server (MSSQL)
* **Narzędzia:** SQL Server Management Studio (SSMS)

## Struktura Bazy Danych

Baza danych PrzedszkoleDB składa się z następujących tabel:

* `Rodzice`:  Przechowuje dane osobowe rodziców dzieci (`IdRodzica` - INT, PK, IDENTITY, `Imie` - NVARCHAR(50), NOT NULL, `Nazwisko` - NVARCHAR(50), NOT NULL).
* `Personel`:  Przechowuje dane osobowe personelu przedszkola (`IdPersonelu` - INT, PK, IDENTITY, `Imie` - NVARCHAR(50), NOT NULL, `Nazwisko` - NVARCHAR(50), NOT NULL).
* `Grupy`:  Zawiera informacje o grupach dzieci, w tym nazwy grup i przypisanych opiekunów (`IdGrupy` - INT, PK, IDENTITY, `NazwaGrupy` - NVARCHAR(50), NOT NULL, `IdPersonelu` - INT, FK, REFERENCES Personel(IdPersonelu)).
* `Dzieci`:  Przechowuje dane osobowe dzieci oraz informacje o przynależności do grupy i dane medyczne (`IdDziecka` - INT, PK, IDENTITY, `Imie` - NVARCHAR(50), NOT NULL, `Nazwisko` - NVARCHAR(50), NOT NULL, `DataUrodzenia` - DATE, NOT NULL, `InformacjeMedyczne` - NVARCHAR(MAX), CHECK (ISJSON(InformacjeMedyczne) = 1), `IdGrupy` - INT, FK, REFERENCES Grupy(IdGrupy), `IdRodzica` - INT, FK, REFERENCES Rodzice(IdRodzica)).
* `Dyzury`:  Zawiera harmonogram pracy personelu, w tym daty, godziny i przypisane grupy (`IdDyzuru` - INT, PK, IDENTITY, `IdPersonelu` - INT, FK, REFERENCES Personel(IdPersonelu), `IdGrupy` - INT, FK, REFERENCES Grupy(IdGrupy), `CzasRozpoczecia` - DATETIME, NOT NULL, `CzasZakonczenia` - DATETIME, NOT NULL).
* `Wyposazenie`:  Zawiera listę wyposażenia przedszkola (np. zabawki, środki higieniczne) z informacjami o nazwie, kategorii i ilości (`IdWyposazenia` - INT, PK, IDENTITY, `Nazwa` - NVARCHAR(100), NOT NULL, `Kategoria` - NVARCHAR(50), NOT NULL, `Ilosc` - INT, NOT NULL, CHECK (Ilosc \>= 0), `IdGrupy` - INT, FK, REFERENCES Grupy(IdGrupy)).
* `Zakupy`:  Rejestruje historię zakupów przedszkola, w tym daty, ilości i koszty (`IdZakupu` - INT, PK, IDENTITY, `IdWyposazenia` - INT, FK, REFERENCES Wyposazenie(IdWyposazenia), `DataZakupu` - DATE, NOT NULL, `Ilosc` - INT, NOT NULL, `Koszt` - DECIMAL(10,2), NOT NULL).
* `Opinie`:  Przechowuje oceny i komentarze od rodziców (`IdOpinii` - INT, PK, IDENTITY, `Ocena` - INT, NOT NULL, CHECK (Ocena BETWEEN 1 AND 5), `Komentarz` - NVARCHAR(MAX), `IdRodzica` - INT, FK, REFERENCES Rodzice(IdRodzica)).

## Indeksy

Dodatkowo, w bazie danych zdefiniowano następujące indeksy:

* `IX_Dzieci_IdGrupy` na kolumnie `IdGrupy` w tabeli `Dzieci`.
* `IX_Dyzury_IdPersonelu` na kolumnie `IdPersonelu` w tabeli `Dyzury`.
* `IX_Zakupy_IdWyposazenia` na kolumnie `IdWyposazenia` w tabeli `Zakupy`.
* `IX_Wyposazenie_IdGrupy` na kolumnie `IdGrupy` w tabeli `Wyposazenie`.
* Unikalny, nieklastrowany indeks `UQ_IdOpinii` na kolumnie `IdOpinii` w tabeli `Opinie`.

## Indeks Pełnotekstowy

W bazie danych zaimplementowano indeks pełnotekstowy na kolumnie `Komentarz` w tabeli `Opinie`, co umożliwia efektywne wyszukiwanie w komentarzach rodziców (jeśli usługa Full-Text Search jest zainstalowana w SQL Server).

## Kluczowe Funkcjonalności

Projekt zawiera następujące kluczowe elementy:

* **Przechowywanie Danych Podopiecznych:** System przechowuje dane osobowe dzieci oraz elastyczne dane medyczne (alergie, wskazania zdrowotne, diety) w formacie JSON.
* **Zarządzanie Grupami:** Umożliwia przechowywanie informacji o grupach dzieci i przypisywanie opiekunów.
* **Śledzenie Wyposażenia i Zakupów:** Pozwala na kontrolę stanu zasobów przedszkola oraz analizę historii zakupów.
* **Zarządzanie Personelem i Dyżurami:** Umożliwia przechowywanie danych personelu i planowanie dyżurów.
* **Zbieranie i Analiza Opinii:** System zbiera opinie od rodziców i umożliwia ich analizę za pomocą wyszukiwania słów kluczowych (dzięki indeksowi pełnotekstowemu).
* **Obsługa Różnych Użytkowników:** System definiuje różne role użytkowników (personel, zaopatrzeniowiec, specjalista ds. mediów, kierownik) z różnymi poziomami dostępu do danych .
* **Optymalizacja Wydajności:** Baza danych zawiera indeksy optymalizujące szybkość działania.
* **Audyty Dostępu do Danych Wrażliwych:** Monitorowanie dostępu do danych wrażliwych (np., danych dzieci) za pomocą audytów.
* **Przykładowe Zapytania i Procedury:** Zestaw zapytań i procedur ułatwiających codzienne zadania (np., wyszukiwanie dzieci z alergiami, raporty wydatków).
* **Procedury Utrzymania Bazy Danych:** Automatyczne procedury utrzymania, takie jak kontrola integralności, kopie zapasowe i aktualizacja statystyk.

## Role i Uprawnienia

System definiuje następujące role i uprawnienia:

* **RolaPersonelu:** Ma uprawnienia SELECT do tabel `Dzieci`, `Grupy` i `Opinie`.
* **RolaZaopatrzeniowca:** Ma uprawnienia SELECT, INSERT i UPDATE do tabel `Wyposazenie` i `Zakupy`.
* **RolaMediow:** Ma uprawnienia SELECT do tabel `Opinie` i `Rodzice`.
* **RolaKierownika:** Ma uprawnienia SELECT do wszystkich tabel (`Rodzice`, `Personel`, `Grupy`, `Dzieci`, `Dyzury`, `Wyposazenie`, `Zakupy`, `Opinie`).

Dodatkowo, system implementuje audytowanie dostępu do danych:

* Audytowane są operacje SELECT na tabeli `Dzieci` wykonywane przez role `RolaPersonelu` i `RolaKierownika`.
* Audytowane są operacje SELECT na tabeli `Rodzice` wykonywane przez role `RolaMediow` i `RolaKierownika`.
* Audytowane są operacje UPDATE na tabeli `Dzieci` wykonywane przez wszystkich użytkowników (public).

## Procedury Utrzymania

System zawiera procedury składowane do automatycznego utrzymania bazy danych:

* `Utrzymanie_KontrolaIntegralnosci`:  Sprawdza integralność bazy danych za pomocą `DBCC CHECKDB`.
* `Utrzymanie_KopiaZapasowa`:  Tworzy pełną kopię zapasową bazy danych.
* `Utrzymanie_AktualizacjaStatystyk`:  Aktualizuje statystyki rozkładu danych za pomocą `sp_updatestats`.

Te procedury są uruchamiane automatycznie przez zadania SQL Server Agent:

* Kontrola integralności:  Uruchamiana w każdą niedzielę o 2:00.
* Kopia zapasowa: Uruchamiana codziennie o 1:00.
* Aktualizacja statystyk: Uruchamiana w każdą sobotę o 2:00.

## Przykładowe Zapytania i Procedury (zgodnie ze skryptem `zapytania_i_procedury.sql`)

System definiuje następujące przykładowe zapytania i procedury składowane:

* **Zapytania:**
    * Zapytanie 1: Lista dzieci z alergiami (wykorzystuje `JSON_VALUE` do parsowania danych z kolumny `InformacjeMedyczne`).
    * Zapytanie 2: Średnia ocena opinii od rodziców dla każdej grupy.
    * Zapytanie 3: Wyposażenie z niskim stanem.
* **Procedury Składowane:**
    * `DodajZakup`: Dodaje nowy zakup i aktualizuje stan wyposażenia.
    * `ZnajdzDzieciZAllegia`: Wyszukuje dzieci z określoną alergią (wykorzystuje `OPENJSON` do parsowania danych z kolumny `InformacjeMedyczne`).
    * `RaportZakupowGrupy`: Generuje raport miesięczny zakupów dla danej grupy.


## Autor

Konrad Gromala
