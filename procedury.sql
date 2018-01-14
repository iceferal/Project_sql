--Klient

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

--Kontakt

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
CREATE PROCEDURE Zmodyfikuj_kontakt (
        @login VARCHAR(64),
        @nr_tel INT,
        @fax INT,
		@email VARCHAR(64)
		)
AS
UPDATE 	kontakt 
SET 	nr_tel = @nr_tel, 
		fax = @fax,
		email = @email
WHERE 	klient_login = @login
GO

--Zmodyfikuj_kontakt 'Wili65', 999999999, 123456789, 'wili65@gmail.com'

--śmiga
CREATE PROCEDURE Usun_kontakt (
		@login VARCHAR(64)
		)
AS
	DELETE FROM kontakt
	WHERE klient_login = @login
GO

-- Produkt

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

--Procedura raportuje wszystkie zamowienia z danego typu wysyłki
CREATE PROCEDURE Dostawy (
        @rodzaj_dostawy VARCHAR(64)
		)
AS
SELECT nr_zamowienia,
		klient_login,
		data_zlozenia,
		data_wysylki
FROM zamowienie
WHERE forma_dostawy = @rodzaj_dostawy
GO

-- Dostawy 'kurier

-- Dodaj zamowienie dla pojedynczej sztuki

Create Procedure Dodaj_zamowienie (
		@login Varchar(64),
		@produkt Varchar(64))
As
If exists (Select TOP 1 nr_seryjny From Egzemplarz Where (produkt_kod_produktu Like @produkt AND czy_sprzedano = 0) ORDER BY nr_seryjny)
begin
	Declare @id Int;
		If not exists (Select id_zamowienia From Zamowienie)
		set @id = 1
		else
		Set @id = (Select MAX(id_zamowienia) From Zamowienie) + 1;

	Declare @nr Int;
		If not exists (Select nr_zamowienia From Zamowienie)
		set @nr = 1
		else If exists (Select MAX(nr_zamowienia) From Zamowienie Where (klient_login = @login AND Month(GETDATE()) = Month(data_zlozenia) AND DAY(GETDATE()) = DAY(data_zlozenia)))
		set @nr = (Select MAX(nr_zamowienia) From Zamowienie Where (klient_login = @login AND Month(GETDATE()) = Month(data_zlozenia) AND DAY(GETDATE()) = DAY(data_zlozenia)))
		else
		Set @nr = (Select MAX(nr_zamowienia) From Zamowienie) + 1;
	
	Declare @fak int;
		If not exists (Select faktura From Faktury)
		set @fak = 1
		else
		Set @fak = (Select MAX(faktura) From Faktury ) + 1;

	Declare @nrfak int;
		If not exists (Select nr_faktury From Faktury)
		set @nrfak = 1
		else If exists (Select MAX(nr_faktury) From Faktury Where (klient_login = @login AND Month(GETDATE()) = Month(data_sprzedazy) AND DAY(GETDATE()) = DAY(data_sprzedazy)))
		set @nrfak = (Select MAX(nr_faktury) From Faktury Where (klient_login = @login AND Month(GETDATE()) = Month(data_sprzedazy) AND DAY(GETDATE()) = DAY(data_sprzedazy)))
		else
		Set @nrfak = (Select MAX(nr_faktury) From Faktury ) + 1;

	Insert Into Zamowienie (id_zamowienia, nr_zamowienia, klient_login) Values
		( @id, @nr, @login )
	Insert Into Faktury (faktura, nr_faktury, zamowienie_nr, klient_login, wartosc_netto, wartosc_brutto) Values
		( @fak, @nrfak, @nr, @login, (Select cena_netto from Produkt where kod_produktu = @produkt), (Select cena_brutto from Produkt where kod_produktu = @produkt) )
	Insert Into produktZamowienie Values
		( @produkt, @id )
	Insert Into produktFaktura Values
		( @produkt, @fak )

	Declare @seria Int;
	Set @seria = (Select TOP 1 nr_seryjny From Egzemplarz Where (produkt_kod_produktu Like @produkt AND czy_sprzedano = 0) ORDER BY nr_seryjny)

	Update Egzemplarz
		Set czy_sprzedano = 1
		Where nr_seryjny = @seria
end
else
	Print 'brak dostępnych egzeplarzy tego produktu!'
Go
