CREATE PROCEDURE Wstaw_klienta (
        @login VARCHAR(64),
        @haslo VARCHAR(64),
        @imie VARCHAR(64),
		@nazwisko VARCHAR(64),
		@nip VARCHAR(64),
		@nazwa_firmy VARCHAR(64))
AS

INSERT INTO klient (login, haslo, imie, nazwisko, nip, nazwa_firmy)
        VALUES (@login, @haslo, @imie, @nazwisko, @nip, @nazwa_firmy)

GO
-- Wstaw_klienta 'test1', 'test2', 'test3', 'test4', '12345678910', 'test6'

CREATE PROCEDURE Usun_klienta (
		@login VARCHAR(64)
		)
AS
IF NOT EXISTS (SELECT klient_login 
                                                FROM zamowienie
                                                WHERE klient_login = @login)
BEGIN
	DELETE FROM klient
	WHERE login = @login
END
GO