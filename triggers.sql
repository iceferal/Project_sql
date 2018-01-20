--- dziala i zapierdala

Create Trigger tri_dostawa On Zamowienie After Insert
As
	If (Select SUM(wartosc_brutto) From Faktury
		Where nr_faktury = (Select MAX(nr_zamowienia) From Zamowienie
		Where (Month(GETDATE()) = Month(data_zlozenia) AND DAY(GETDATE()) = DAY(data_zlozenia)))) > 300
	Declare @nr INTEGER
	Set @nr = (Select MAX(nr_zamowienia) From Zamowienie
		Where (Month(GETDATE()) = Month(data_zlozenia) AND DAY(GETDATE()) = DAY(data_zlozenia)))

	Update Zamowienie
	Set koszt_dostawy = 0
	Where nr_zamowienia = @nr
Go
