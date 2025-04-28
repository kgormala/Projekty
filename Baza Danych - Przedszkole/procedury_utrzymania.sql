USE PrzedszkoleDB;
GO

-- Procedura 1: Kontrola integralno�ci
CREATE PROCEDURE Utrzymanie_KontrolaIntegralnosci
AS
BEGIN
    DBCC CHECKDB ('PrzedszkoleDB') WITH NO_INFOMSGS;
    IF @@ERROR = 0
        PRINT 'Kontrola integralno�ci zako�czona pomy�lnie.';
    ELSE
        RAISERROR ('B��d podczas kontroli integralno�ci bazy danych!', 16, 1);
END;
GO

-- Procedura 2: Kopia zapasowa
CREATE PROCEDURE Utrzymanie_KopiaZapasowa
AS
BEGIN
    DECLARE @NazwaPliku NVARCHAR(256);
    SET @NazwaPliku = 'C:\Backups\PrzedszkoleDB_' + 
                      CONVERT(NVARCHAR(20), GETDATE(), 112) + '_' + 
                      REPLACE(CONVERT(NVARCHAR(5), GETDATE(), 108), ':', '') + '.bak';
    BACKUP DATABASE PrzedszkoleDB 
    TO DISK = @NazwaPliku
    WITH INIT, FORMAT, NAME = 'Pe�na kopia zapasowa PrzedszkoleDB', STATS = 10;
    IF @@ERROR = 0
        PRINT 'Kopia zapasowa utworzona pomy�lnie: ' + @NazwaPliku;
    ELSE
        RAISERROR ('B��d podczas tworzenia kopii zapasowej!', 16, 1);
END;
GO

-- Procedura 3: Aktualizacja statystyk
CREATE PROCEDURE Utrzymanie_AktualizacjaStatystyk
AS
BEGIN
    EXEC sp_updatestats;
    IF @@ERROR = 0
        PRINT 'Statystyki rozk�adu zaktualizowane pomy�lnie.';
    ELSE
        RAISERROR ('B��d podczas aktualizacji statystyk!', 16, 1);
END;
GO

-- Zadania SQL Server Agent
USE msdb;
GO

-- Zadanie 1: Kontrola integralno�ci (niedziela 2:00)
EXEC sp_add_job 
    @job_name = N'PrzedszkoleDB_KontrolaIntegralnosci',
    @enabled = 1,
    @description = N'Cotygodniowa kontrola integralno�ci bazy danych PrzedszkoleDB';
EXEC sp_add_jobstep 
    @job_name = N'PrzedszkoleDB_KontrolaIntegralnosci',
    @step_name = N'Uruchom kontrol� integralno�ci',
    @subsystem = N'TSQL',
    @command = N'EXEC PrzedszkoleDB.dbo.Utrzymanie_KontrolaIntegralnosci',
    @database_name = N'PrzedszkoleDB';
EXEC sp_add_jobschedule 
    @job_name = N'PrzedszkoleDB_KontrolaIntegralnosci',
    @name = N'Harmonogram tygodniowy',
    @freq_type = 8, @freq_interval = 1, @freq_recurrence_factor = 1, @active_start_time = 20000;
EXEC sp_add_jobserver @job_name = N'PrzedszkoleDB_KontrolaIntegralnosci';

-- Zadanie 2: Kopia zapasowa (codziennie 1:00)
EXEC sp_add_job 
    @job_name = N'PrzedszkoleDB_KopiaZapasowa',
    @enabled = 1,
    @description = N'Codzienna pe�na kopia zapasowa bazy danych PrzedszkoleDB';
EXEC sp_add_jobstep 
    @job_name = N'PrzedszkoleDB_KopiaZapasowa',
    @step_name = N'Uruchom kopi� zapasow�',
    @subsystem = N'TSQL',
    @command = N'EXEC PrzedszkoleDB.dbo.Utrzymanie_KopiaZapasowa',
    @database_name = N'PrzedszkoleDB';
EXEC sp_add_jobschedule 
    @job_name = N'PrzedszkoleDB_KopiaZapasowa',
    @name = N'Harmonogram codzienny',
    @freq_type = 4, @freq_interval = 1, @active_start_time = 10000;
EXEC sp_add_jobserver @job_name = N'PrzedszkoleDB_KopiaZapasowa';

-- Zadanie 3: Aktualizacja statystyk (sobota 2:00)
EXEC sp_add_job 
    @job_name = N'PrzedszkoleDB_AktualizacjaStatystyk',
    @enabled = 1,
    @description = N'Cotygodniowa aktualizacja statystyk rozk�adu bazy danych PrzedszkoleDB';
EXEC sp_add_jobstep 
    @job_name = N'PrzedszkoleDB_AktualizacjaStatystyk',
    @step_name = N'Uruchom aktualizacj� statystyk',
    @subsystem = N'TSQL',
    @command = N'EXEC PrzedszkoleDB.dbo.Utrzymanie_AktualizacjaStatystyk',
    @database_name = N'PrzedszkoleDB';
EXEC sp_add_jobschedule 
    @job_name = N'PrzedszkoleDB_AktualizacjaStatystyk',
    @name = N'Harmonogram tygodniowy',
    @freq_type = 8, @freq_interval = 64, @freq_recurrence_factor = 1, @active_start_time = 20000;
EXEC sp_add_jobserver @job_name = N'PrzedszkoleDB_AktualizacjaStatystyk';