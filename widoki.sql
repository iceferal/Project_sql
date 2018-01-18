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

CREATE VIEW WszystkieZamowienia(nr_zamowienia, login, nazwa_produktu, cena_netto, cena_brutto)
AS
(SELECT z.nr_zamowienia,
		k.login,
		p.nazwa_produktu ,
		p.cena_netto,
		p.cena_brutto
FROM klient k
JOIN zamowienie z
ON z.klient_login=k.login
JOIN produktZamowienie PR
ON Pr.zamowienie_nr=z.id_zamowienia
JOIN produkt p
ON p.kod_produktu=PR.produkt_kod_produktu
)
GO

--SElect * from WszystkieZamowienia