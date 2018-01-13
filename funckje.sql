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


--nie dziala jak powinno
CREATE FUNCTION LiczbaZamowien
(
    @login VARCHAR(64)
)
    RETURNS INT
AS
BEGIN
	DECLARE @wynik INT
	SELECT @wynik= COUNT(z.nr_zamowienia)
	FROM zamowienie Z
	WHERE z.klient_login = @login
	RETURN @wynik
END;