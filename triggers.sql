Create Trigger tri_dostawa On Zamowienie After Insert
As
	If (Select SUM(wartosc_brutto) From Faktury
		Where nr_faktury = (Select MAX(nr_zamowienia) From Zamowienie
		Where (Month(GETDATE()) = Month(data_zlozenia) AND DAY(GETDATE()) = DAY(data_zlozenia)))) > 300
begin
	
	Update Zamowienie
	Set koszt_dostawy = 0
	Where nr_zamowienia = (Select MAX(nr_zamowienia) From Zamowienie
		Where (Month(GETDATE()) = Month(data_zlozenia) AND DAY(GETDATE()) = DAY(data_zlozenia)))
end
Go


Create Trigger tri_egzemplarz On egzemplarz Instead Of Delete
As
	Update Egzemplarz
	Set czy_sprzedano = 1
	Where nr_seryjny = (Select d.nr_seryjny From deleted d)

	Print 'Nie mozna usuwac egzeplarzy z rejestru'
	Rollback
GO

Delete from egzemplarz Where nr_seryjny = '06456843'
Delete from egzemplarz Where nr_seryjny = '44102074'

Dodaj_zamowienie 'Serwiliusz01' , 'druk07'
Select * from Zamowienie
Dodaj_zamowienie 'Serwiliusz01' , 'klaw547'
Select * from Zamowienie
