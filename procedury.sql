CREATE PROCEDURE Wstaw_klienta (
        @login VARCHAR(64),
        @haslo VARCHAR(64),
        @imie VARCHAR(64),
		@nazwisko VARCHAR(64),
		@nip VARCHAR(64),
		@nazwa_firmy VARCHAR(64))
AS
BEGIN
                RAISERROR ('Wprowadziles bledne dane. Prosze, sprawdz je.',
                        16,
                        1
                )
END
INSERT INTO klient (login, haslo, imie, nazwisko, nip, nazwa_firmy)
        VALUES (@login, @haslo, @imie, @nazwisko, @nip, @nazwa_firmy)

GO
-- Wstaw_klienta 'test1', 'test2', 'test3', 'test4', '12345678910', 'test6'

