CREATE PROCEDURE Wstaw_klienta (
        @login VARCHAR(64),
        @haslo VARCHAR(64),
        @imie VARCHAR(64),
		@nazwisko VARCHAR(64),
		@nip VARCHAR(64),
		@nazwa_firmy VARCHAR(64),
		)
AS
INSERT INTO klient (login, haslo, szef, imie, nazwisko, nip, nazwa_firmy)
        VALUES (@login, @haslo, @szef, @imie, @nazwisko, @nip, @nazwa_firmy)
GO