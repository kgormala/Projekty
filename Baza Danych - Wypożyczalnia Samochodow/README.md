# System Zarządzania Wypożyczalnią Samochodów (T-SQL MSSQL)

## Opis Projektu
Ten projekt przedstawia prosty system zarządzania wypożyczalnią samochodów zaimplementowany w języku T-SQL dla bazy danych Microsoft SQL Server (MSSQL). System ten umożliwia efektywne zarządzanie podstawowymi aspektami działalności wypożyczalni, takimi jak ewidencja marek i modeli samochodów, kategorii pojazdów, dostępnych samochodów, danych klientów oraz procesów wypożyczeń i zwrotów. Projekt zawiera kompletną strukturę bazy danych, procedury składowane do wykonywania kluczowych operacji, widoki ułatwiające przeglądanie danych oraz triggery zapewniające integralność danych.

## Technologie Użyte
* **Język:** T-SQL
* **Baza Danych:** Microsoft SQL Server (MSSQL)
* **Narzędzia:** SQL Server Management Studio (SSMS)

## Struktura Bazy Danych
Projekt składa się z następujących tabel:
* `MarkiSamochodow`: Zawiera informacje o markach samochodów (`MarkaID` - klucz główny, `Nazwa` - unikalna nazwa marki).
* `ModeleSamochodow`: Zawiera informacje o modelach samochodów, powiązane z markami (`ModelID` - klucz główny, `MarkaID` - klucz obcy do `MarkiSamochodow`, `Nazwa` - nazwa modelu, unikalna w obrębie marki).
* `KategoriePojazdow`: Zawiera informacje o kategoriach pojazdów i ich stawkach dziennych (`KategoriaID` - klucz główny, `Nazwa` - unikalna nazwa kategorii, `StawkaDniowa` - cena za dzień wypożyczenia).
* `Samochody`: Zawiera szczegółowe informacje o poszczególnych pojazdach (`SamochodID` - klucz główny, `ModelID` - klucz obcy do `ModeleSamochodow`, `KategoriaID` - klucz obcy do `KategoriePojazdow`, `NumerRejestracyjny` - unikalny numer rejestracyjny, `RokProdukcji`, `Przebieg`, `CzyDostepny` - flaga wskazująca dostępność).
* `Klienci`: Zawiera dane klientów wypożyczalni (`KlientID` - klucz główny, `Imie`, `Nazwisko`, `Adres`, `NumerTelefonu`, `Email` - unikalny adres e-mail).
* `Wypozyczenia`: Rejestruje informacje o wypożyczeniach (`WypozyczenieID` - klucz główny, `SamochodID` - klucz obcy do `Samochody`, `KlientID` - klucz obcy do `Klienci`, `DataWypozyczenia` - domyślnie aktualna data, `DataZwrotuPlanowana`, `DataZwrotuRzeczywista`, `KosztCalkowity`).

## Kluczowe Funkcjonalności
Projekt zawiera następujące kluczowe elementy:

* **Procedury Składowane:**
    * `DodajMarkeSamochodu`: Dodaje nową markę samochodu do bazy danych.
    * `DodajModelSamochodu`: Dodaje nowy model samochodu dla określonej marki.
    * `DodajKategoriePojazdow`: Dodaje nową kategorię pojazdów z określoną stawką dzienną.
    * `DodajSamochod`: Dodaje nowy samochód do bazy danych, przypisując go do modelu i kategorii.
    * `DodajKlienta`: Dodaje nowego klienta do systemu.
    * `WypozyczSamochod`: Obsługuje proces wypożyczenia samochodu, zmieniając jego status na niedostępny.
    * `ZwrocSamochod`: Obsługuje proces zwrotu samochodu, aktualizuje datę zwrotu i oblicza całkowity koszt wypożyczenia.
* **Widoki:**
    * `WidokDostepneSamochody`: Prezentuje listę aktualnie dostępnych samochodów wraz z informacjami o marce, modelu i kategorii.
    * `WidokAktualneWypozyczenia`: Wyświetla listę aktualnie wypożyczonych samochodów wraz z danymi klientów i planowanymi datami zwrotu.
    * `WidokHistoriaWypozyczen`: Pokazuje historię wszystkich wypożyczeń z uwzględnieniem dat wypożyczenia, planowanych i rzeczywistych dat zwrotu oraz kosztów.
* **Triggery:**
    * `Tr_BlokujUsuniecieMarki`: Zapobiega usunięciu marki samochodu, jeśli w bazie danych istnieją powiązane z nią modele.
    * `Tr_BlokujUsuniecieKategorii`: Zapobiega usunięciu kategorii pojazdu, jeśli istnieją przypisane do niej samochody.

## Czego się Nauczyłem
Podczas tworzenia tego projektu zdobyłem i utrwaliłem wiedzę z zakresu:
* Projektowania relacyjnych baz danych.
* Implementacji struktury bazy danych w T-SQL (tworzenie tabel, definiowanie kluczy głównych i obcych, ograniczeń).
* Tworzenia i wykorzystania procedur składowanych do enkapsulacji logiki biznesowej i manipulacji danymi.
* Tworzenia widoków w celu uproszczenia zapytań i prezentacji danych.
* Implementacji triggerów w celu zapewnienia integralności danych i automatyzacji pewnych akcji.
* Podstawowych operacji CRUD (Create, Read, Update, Delete) w T-SQL.

## Kontakt
* Konrad Gromala
* kgromala86@gmail.com

