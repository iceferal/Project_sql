CREATE VIEW Dane_Klientow(login, imie, nazwisko, ulica, nr_domu, kod_pocztowy, miasto, nr_tel, email)
AS
(
	SELECT  login,
			imie,
			nazwisko,
			ulica,
			nr_domu,
			kod_pocztowy,
			miasto,
			nr_tel,
			email
	FROM    klient k
	JOIN	kontakt kont
	ON		kont.klient_login = k.login
	JOIN	adres adr
	ON		adr.klient_login = k.login
);
GO

--SELECT * FROM Dane_Klientow