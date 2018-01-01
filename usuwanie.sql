IF OBJECT_ID('adres', 'U') IS NOT NULL
  ALTER TABLE adres
      DROP CONSTRAINT adres_klient_FK
  GO
  DROP TABLE adres;
 
IF OBJECT_ID('egzemplarz', 'U') IS NOT NULL
  ALTER TABLE egzemplarz
      DROP CONSTRAINT egzemplarz_produkt_FK
  GO
  DROP TABLE egzemplarz;
 
IF OBJECT_ID('faktury', 'U') IS NOT NULL
  ALTER TABLE faktury
      DROP CONSTRAINT faktury_klient_FK
  GO

IF OBJECT_ID('kontakt', 'U') IS NOT NULL
  ALTER TABLE kontakt
      DROP CONSTRAINT kontakt_klient_FK
  GO
  DROP TABLE kontakt;
 
IF OBJECT_ID('produktFaktura', 'U') IS NOT NULL
  ALTER TABLE produktFaktura
      DROP CONSTRAINT produktFaktura_faktury_FK
  GO
 
  ALTER TABLE produktFaktura
      DROP CONSTRAINT produktFaktura_produkt_FK
  GO
  DROP TABLE produktFaktura;
 
IF OBJECT_ID('produktZamowienie', 'U') IS NOT NULL
  ALTER TABLE produktZamowienie
      DROP CONSTRAINT produktZamowienie_produkt_FK
  GO
 
  ALTER TABLE produktZamowienie
      DROP CONSTRAINT produktZamowienie_zamowienie_FK
  GO
  DROP TABLE produktZamowienie;
 
--IF OBJECT_ID('zamowienie', 'U') IS NOT NULL
--  ALTER TABLE zamowienie
--      DROP CONSTRAINT zamowienie_faktury_FK
--  GO
 
 
IF OBJECT_ID('produkt', 'U') IS NOT NULL
  DROP TABLE produkt;

  ALTER TABLE faktury
      DROP CONSTRAINT faktury_zamowienie_FK
  GO
  DROP TABLE faktury; 

    ALTER TABLE zamowienie
      DROP CONSTRAINT zamowienie_klient_FK
  GO
  DROP TABLE zamowienie;

  IF OBJECT_ID('klient', 'U') IS NOT NULL
  DROP TABLE klient;