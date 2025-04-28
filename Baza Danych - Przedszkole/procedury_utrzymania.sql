USE PrzedszkoleDB;
GO

-- Procedura 1: Kontrola integralnoœci
CREATE PROCEDURE Utrzymanie_KontrolaIntegralnosci
AS
BEGIN
    DBCC CHECKDB ('PrzedszkoleDB') WITH NO_INFOMSGS;
    IF @@ERROR = 0
        PRINT 'Kontrola integralnoœci zakoñczona pomyœlnie.';
    ELSE
        RAISERROR ('B³¹d podczas kontroli integralnoœci bazy danych!', 16, 1);
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
    WITH INIT, FORMAT, NAME = 'Pe³na kopia zapasowa PrzedszkoleDB', STATS = 10;
    IF @@ERROR = 0
        PRINT 'Kopia zapasowa utworzona pomyœlnie: ' + @NazwaPliku;
    ELSE
        RAISERROR ('B³¹d podczas tworzenia kopii zapasowej!', 16, 1);
END;
GO

-- Procedura 3: Aktualizacja statystyk
CREATE PROCEDURE Utrzymanie_AktualizacjaStatystyk
AS
BEGIN
    EXEC sp_updatestats;
    IF @@ERROR = 0
        PRINT 'Statystyki rozk³adu zaktualizowane pomyœlnie.';
    ELSE
        RAISERROR ('B³¹d podczas aktualizacji statystyk!', 16, 1);
END;
GO

-- Zadania SQL Server Agent
USE msdb;
GO

-- Zadanie 1: Kontrola integralnoœci (niedziela 2:00)
EXEC sp_add_job 
    @job_name = N'PrzedszkoleDB_KontrolaIntegralnosci',
    @enabled = 1,
    @description = N'Cotygodniowa kontrola integralnoœci bazy danych PrzedszkoleDB';
EXEC sp_add_jobstep 
    @job_name = N'PrzedszkoleDB_KontrolaIntegralnosci',
    @step_name = N'Uruchom kontrolê integralnoœci',
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
    @description = N'Codzienna pe³na kopia zapasowa bazy danych PrzedszkoleDB';
EXEC sp_add_jobstep 
    @job_name = N'PrzedszkoleDB_KopiaZapasowa',
    @step_name = N'Uruchom kopiê zapasow¹',
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
    @description = N'Cotygodniowa aktualizacja statystyk rozk³adu bazy danych PrzedszkoleDB';
EXEC sp_add_jobstep 
    @job_name = N'PrzedszkoleDB_AktualizacjaStatystyk',
    @step_name = N'Uruchom aktualizacjê statystyk',
    @subsystem = N'TSQL',
    @command = N'EXEC PrzedszkoleDB.dbo.Utrzymanie_AktualizacjaStatystyk',
    @database_name = N'PrzedszkoleDB';
EXEC sp_add_jobschedule 
    @job_name = N'PrzedszkoleDB_AktualizacjaStatystyk',
    @name = N'Harmonogram tygodniowy',
    @freq_type = 8, @freq_interval = 64, @freq_recurrence_factor = 1, @active_start_time = 20000;
EXEC sp_add_jobserver @job_name = N'PrzedszkoleDB_AktualizacjaStatystyk';