--śmiga
CREATE PROCEDURE Wstaw_klienta (
        @login VARCHAR(64),
        @haslo VARCHAR(64),
        @imie VARCHAR(64),
		@nazwisko VARCHAR(64),
		@nip VARCHAR(64)=NULL,
		@nazwa_firmy VARCHAR(64)=NULL
AS

INSERT INTO klient (login, haslo, imie, nazwisko, nip, nazwa_firmy)
        VALUES (@login, @haslo, @imie, @nazwisko, @nip, @nazwa_firmy)

GO
-- Wstaw_klienta 'test1', 'test2', 'test3', 'test4', '12345678910', 'test6'
-- NIEŚMIGA do poprawki
CREATE PROCEDURE Usun_klienta (
		@login VARCHAR(64)
		)
AS
BEGIN
	IF NOT EXISTS (SELECT klient_login 
                                                FROM zamowienie
                                                WHERE klient_login = @login)

		DELETE FROM klient
		WHERE login = @login
		DELETE from adres
		WHERE login= @login
		DELETE FROM kontakt
		where login = @login
	ELSE
		PRINT N'Nie mozna usunac podanego klienta'
END
GO
--PrawieŚmiga
CREATE PROCEDURE Wstaw_adres (
        @login VARCHAR(64),
        @ulica VARCHAR(64),
        @nr_domu INT=NULL,
		@nr_lokalu  INT,
		@kod_pocztowy VARCHAR(64),
		@miasto VARCHAR(64))
AS

INSERT INTO adres (klient_login, ulica, nr_domu, nr_lokalu, kod_pocztowy, miasto)
        VALUES (@login, @ulica, @nr_domu, @nr_lokalu, @kod_pocztowy, @miasto)

GO

--PrawieŚmiga
CREATE PROCEDURE Zmodyfikuj_adres (
        @login VARCHAR(64),
        @ulica VARCHAR(64),
        @nr_domu INT=NULL,
		@nr_lokalu  INT,
		@kod_pocztowy VARCHAR(64),
		@miasto VARCHAR(64))
AS
UPDATE 	adres 
SET 	ulica = @ulica, 
		nr_domu = @nr_domu,
		nr_lokalu = @nr_lokalu,
		kod_pocztowy = @kod_pocztowy,
		miasto = @miasto
WHERE 	klient_login = @login
GO

--śmiga
CREATE PROCEDURE Usun_adres (
		@login VARCHAR(64)
		)
AS
	DELETE FROM adres
	WHERE klient_login = @login
GO

--śmiga
CREATE PROCEDURE Wstaw_kontakt (
        @login VARCHAR(64),
        @nr_tel INT,
        @fax INT,
		@email VARCHAR(64)
		)
AS
INSERT INTO kontakt (klient_login, nr_tel, fax, email)
        VALUES (@login, @nr_tel, @fax, @email)
GO

--śmiga
CREATE PROCEDURE Usun_kontakt (
		@login VARCHAR(64)
		)
AS
	DELETE FROM kontakt
	WHERE klient_login = @login
GO

--śmiga
CREATE PROCEDURE Wstaw_produkt (
        @kod VARCHAR(64),
        @nazwa VARCHAR(64),
		@producent VARCHAR(64),
		@netto MONEY,
		@brutto MONEY,
		@kolor VARCHAR(64),
		@ilosc VARCHAR(64),
		@kategoria VARCHAR(64)
		)
AS
INSERT INTO produkt (kod_produktu, nazwa_produktu, producent, cena_netto, cena_brutto, kolor, ilosc, kategoria)
        VALUES (@kod, @nazwa, @producent, @netto, @brutto, @kolor, @ilosc, @kategoria)
GO

--śmiga
CREATE PROCEDURE Usun_produkt (
		@kod VARCHAR(64)
		)
AS
	DELETE FROM produkt
	WHERE kod_produktu = @kod
GO





