--wyświetla nazwy produktow podanego producenta. jesli takowego nie ma/jest bledny, wyswietla liste wszystkich producentow

CREATE FUNCTION ListaProduktow
(
    @nazwa VARCHAR(64)
)
    RETURNS @produkty TABLE(nazwa VARCHAR(64))
AS
BEGIN
    IF @nazwa IN (SELECT producent FROM produkt)
        INSERT INTO @produkty
                SELECT nazwa_produktu
                FROM   produkt
                WHERE  producent = @nazwa;
    ELSE
        INSERT INTO @produkty
                SELECT DISTINCT producent
                FROM   produkt;
        RETURN;
END;

--SELECT * FROM ListaProduktow('Bosh')
--SELECT * FROM ListaProduktow('OnePlus')


--zwraca liste zamowien danego klienta
CREATE FUNCTION ZamowieniaKlienta(
	@login VARCHAR(64)
	)
RETURNS TABLE
AS
RETURN 
SELECT nr_zamowienia,
		login,
		cena_brutto 
FROM klient k
JOIN zamowienie z
ON z.klient_login=k.login
JOIN produktZamowienie PR
ON Pr.zamowienie_nr=z.id_zamowienia
JOIN produkt p
ON p.kod_produktu=PR.produkt_kod_produktu
WHERE k.login=@login

--SELECT * FROM ZamowieniaKlienta('Alim32')


--nie dziala jak powinno
CREATE FUNCTION LiczbaZamowien
(
    @login VARCHAR(64)
)
    RETURNS INT
AS
	DECLARE @wynik INT
	SELECT @wynik= COUNT(z.nr_zamowienia)
	FROM zamowienie Z
	WHERE z.klient_login = @login
BEGIN
	RETURN @wynik
END;

--zwraca totalna cene zamowienia
CREATE FUNCTION CenaZamowienia
(
	@numer INT
)
RETURNS MONEY
AS
BEGIN
DECLARE @suma MONEY
set @suma = (SELECT SUM(cena_brutto) FROM WszystkieZamowienia)
RETURN @suma
END;

--SELECT dbo.CenaZamowienia(1)