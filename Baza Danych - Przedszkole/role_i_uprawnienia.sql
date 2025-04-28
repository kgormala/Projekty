-- W bazie master
USE master;
GO

CREATE LOGIN UzytkownikPersonel WITH PASSWORD = 'Personel123!';
CREATE LOGIN UzytkownikZaopatrzenie WITH PASSWORD = 'Zaopatrzenie123!';
CREATE LOGIN UzytkownikMedia WITH PASSWORD = 'Media123!';
CREATE LOGIN UzytkownikKierownik WITH PASSWORD = 'Kierownik123!';

CREATE SERVER AUDIT PrzedszkoleAudit
TO FILE (FILEPATH = 'C:\SQLAudits\', MAXSIZE = 50 MB)
WITH (ON_FAILURE = CONTINUE);

CREATE SERVER AUDIT SPECIFICATION PrzedszkoleServerAuditSpec
FOR SERVER AUDIT PrzedszkoleAudit
ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP),
ADD (FAILED_LOGIN_GROUP);

ALTER SERVER AUDIT PrzedszkoleAudit WITH (STATE = ON);
ALTER SERVER AUDIT SPECIFICATION PrzedszkoleServerAuditSpec WITH (STATE = ON);

-- W bazie PrzedszkoleDB
USE PrzedszkoleDB;
GO

CREATE USER UzytkownikPersonel FOR LOGIN UzytkownikPersonel;
CREATE USER UzytkownikZaopatrzenie FOR LOGIN UzytkownikZaopatrzenie;
CREATE USER UzytkownikMedia FOR LOGIN UzytkownikMedia;
CREATE USER UzytkownikKierownik FOR LOGIN UzytkownikKierownik;

CREATE ROLE RolaPersonelu;
GRANT SELECT ON Dzieci TO RolaPersonelu;
GRANT SELECT ON Grupy TO RolaPersonelu;
GRANT SELECT ON Opinie TO RolaPersonelu;
ALTER ROLE RolaPersonelu ADD MEMBER UzytkownikPersonel;

CREATE ROLE RolaZaopatrzeniowca;
GRANT SELECT, INSERT, UPDATE ON Wyposazenie TO RolaZaopatrzeniowca;
GRANT SELECT, INSERT, UPDATE ON Zakupy TO RolaZaopatrzeniowca;
ALTER ROLE RolaZaopatrzeniowca ADD MEMBER UzytkownikZaopatrzenie;

CREATE ROLE RolaMediow;
GRANT SELECT ON Opinie TO RolaMediow;
GRANT SELECT ON Rodzice TO RolaMediow;
ALTER ROLE RolaMediow ADD MEMBER UzytkownikMedia;

CREATE ROLE RolaKierownika;
GRANT SELECT ON Rodzice TO RolaKierownika;
GRANT SELECT ON Personel TO RolaKierownika;
GRANT SELECT ON Grupy TO RolaKierownika;
GRANT SELECT ON Dzieci TO RolaKierownika;
GRANT SELECT ON Dyzury TO RolaKierownika;
GRANT SELECT ON Wyposazenie TO RolaKierownika;
GRANT SELECT ON Zakupy TO RolaKierownika;
GRANT SELECT ON Opinie TO RolaKierownika;
ALTER ROLE RolaKierownika ADD MEMBER UzytkownikKierownik;

CREATE DATABASE AUDIT SPECIFICATION PrzedszkoleDBAuditSpec
FOR SERVER AUDIT PrzedszkoleAudit
ADD (SELECT ON Dzieci BY RolaPersonelu),
ADD (SELECT ON Dzieci BY RolaKierownika),
ADD (SELECT ON Rodzice BY RolaMediow),
ADD (SELECT ON Rodzice BY RolaKierownika),
ADD (UPDATE ON Dzieci BY public);

ALTER DATABASE AUDIT SPECIFICATION PrzedszkoleDBAuditSpec WITH (STATE = ON);