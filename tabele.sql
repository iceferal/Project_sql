 
CREATE TABLE klient
    (
     login VARCHAR (64) NOT NULL ,
     haslo VARCHAR (64) NOT NULL ,
     imie VARCHAR (64) NOT NULL CONSTRAINT ck_klient_imie CHECK (imie LIKE '[A-Z]%'),
     nazwisko VARCHAR (64) NOT NULL CONSTRAINT ck_klient_nazw CHECK (nazwisko LIKE '[A-Z]%'),
     nip VARCHAR (64) CONSTRAINT ck_klient_nip CHECK(nip LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
     nazwa_firmy VARCHAR (64)
    )
    ON "default"
GO
 
ALTER TABLE klient ADD CONSTRAINT klient_PK PRIMARY KEY CLUSTERED (login)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON )
     ON "default"
    GO 


 
CREATE TABLE adres
    (
     klient_login VARCHAR (64) NOT NULL,
     ulica VARCHAR (64) NOT NULL CONSTRAINT ck_adres_ul CHECK (ulica LIKE '[A-Z]%'),
     nr_domu INTEGER NOT NULL CONSTRAINT ck_adres_dom CHECK (nr_domu > 0),
     nr_lokalu INTEGER CONSTRAINT ck_adres_lok CHECK (nr_lokalu > 0),
     kod_pocztowy VARCHAR (64) NOT NULL CONSTRAINT ck_adres_kod CHECK(kod_pocztowy LIKE '[0-9][0-9]-[0-9][0-9][0-9]'),
     miasto VARCHAR (64) NOT NULL CONSTRAINT ck_adres_mia CHECK (miasto LIKE '[A-Z]%')
    )
    ON "default"
GO
 
ALTER TABLE adres ADD CONSTRAINT adres_PK PRIMARY KEY CLUSTERED (klient_login)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON )
     ON "default"
    GO


 
CREATE TABLE kontakt
    (
     klient_login VARCHAR (64) NOT NULL,
     nr_tel INTEGER NOT NULL CONSTRAINT ck_kont_tel CHECK(nr_tel LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
     fax INTEGER NOT NULL CONSTRAINT ck_kont_fax CHECK(fax LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
     email VARCHAR (64) NOT NULL CONSTRAINT ck_email_mal CHECK (email LIKE '%@%'),
    )
    ON "default"
GO
 
ALTER TABLE kontakt ADD CONSTRAINT kontakt_PK PRIMARY KEY CLUSTERED (klient_login)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON )
     ON "default"
    GO



CREATE TABLE produkt
    (
     kod_produktu VARCHAR (64) NOT NULL ,
     nazwa_produktu VARCHAR (64) NOT NULL CONSTRAINT ck_nazwprod_nazwa CHECK (nazwa_produktu LIKE '[A-Z]%'),
     producent VARCHAR (64) NOT NULL CONSTRAINT ck_prod_prod CHECK (producent LIKE '[A-Z]%'),
     cena_netto MONEY NOT NULL CONSTRAINT ck_cennet_cena CHECK (cena_netto > 0),
     cena_brutto MONEY NOT NULL CONSTRAINT ck_cenbrut_cena CHECK (cena_brutto > 0),
     kolor VARCHAR (64) NOT NULL ,
	 ilosc INTEGER NOT NULL CONSTRAINT ck_ilosc_ile CHECK (ilosc >=0),
     kategoria VARCHAR (64) NOT NULL CONSTRAINT ck_kateg_kat CHECK (kategoria LIKE '[A-Z]%')
    )
    ON "default"
GO
 
ALTER TABLE produkt ADD CONSTRAINT produkt_PK PRIMARY KEY CLUSTERED (kod_produktu)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON )
     ON "default"
    GO
 


CREATE TABLE faktury
    (
     faktura INTEGER NOT NULL ,
     nr_faktury INTEGER NOT NULL CONSTRAINT ck_faktury_nr CHECK (nr_faktury > 0),
   --  zamowienie_nr INTEGER NOT NULL CONSTRAINT ck_faktury_zam CHECK (zamowienie_nr > 0),
     klient_login VARCHAR (64) NOT NULL,
     data_sprzedazy DATETIME NOT NULL CONSTRAINT ck_faktury_data DEFAULT GETDATE(),
     wartosc_netto MONEY NOT NULL CONSTRAINT ck_faktury_wn CHECK (wartosc_netto > 0),
     wartosc_brutto MONEY NOT NULL CONSTRAINT ck_faktury_wb CHECK (wartosc_brutto > 0),
     forma_platnosci VARCHAR (64) NOT NULL CONSTRAINT ck_faktury_forma CHECK (forma_platnosci IN ('przedplata', 'platnosc przy odbiorze')) DEFAULT 'przedplata'
    )
    ON "default"
GO
 
ALTER TABLE faktury ADD CONSTRAINT faktury_PK PRIMARY KEY CLUSTERED (faktura)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON )
     ON "default"
    GO
 


CREATE TABLE produktFaktura
    (
     produkt_kod_produktu VARCHAR (64) NOT NULL, 
     faktury_faktura INTEGER NOT NULL 
    )
    ON "default"
GO
 
ALTER TABLE produktFaktura ADD CONSTRAINT produktFaktura_PK PRIMARY KEY CLUSTERED (produkt_kod_produktu, faktury_faktura)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON )
     ON "default"
    GO


 
CREATE TABLE egzemplarz
    (
     nr_seryjny INTEGER NOT NULL ,
     produkt_kod_produktu VARCHAR (64) NOT NULL,
     data_zakupu DATETIME NOT NULL CONSTRAINT ck_egz_datzak DEFAULT GETDATE(),
     data_sprzedazy DATETIME,
     czy_sprzedano INTEGER NOT NULL CONSTRAINT ck_egz_czy CHECK (czy_sprzedano IN ('0', '1')) DEFAULT '0'
    )
    ON "default"
GO
 
ALTER TABLE egzemplarz ADD CONSTRAINT egzemplarz_PK PRIMARY KEY CLUSTERED (nr_seryjny)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON )
     ON "default"
    GO
 

 
CREATE TABLE zamowienie
    (
     id_zamowienia INTEGER NOT NULL ,
	 nr_zamowienia INTEGER NOT NULL CONSTRAINT ck_zam_nr CHECK (nr_zamowienia > 0),
     klient_login VARCHAR (64) NOT NULL, 
     data_zlozenia DATETIME NOT NULL CONSTRAINT ck_zam_datzl DEFAULT GETDATE(),
     data_realizacji DATETIME NOT NULL CONSTRAINT ck_zam_datreal DEFAULT DATEADD(day,3,GETDATE()),
     data_wysylki DATETIME NOT NULL CONSTRAINT ck_zam_datwys DEFAULT DATEADD(day,3,GETDATE()),
     forma_dostawy VARCHAR (64) NOT NULL  CONSTRAINT ck_zam_forma CHECK (forma_dostawy IN ('kurier', 'poczta polska', 'odbior osobisty')) DEFAULT 'kurier',
	 koszt_dostawy INTEGER NOT NULL DEFAULT '30'
    )
    ON "default"
GO

ALTER TABLE zamowienie
     ADD CONSTRAINT zamowienie_PK PRIMARY KEY CLUSTERED (id_zamowienia)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON )
     ON "default"
    GO 


 
CREATE TABLE produktZamowienie
    (
     produkt_kod_produktu VARCHAR (64) NOT NULL, 
     zamowienie_nr INTEGER NOT NULL 
    )
    ON "default"
GO
 
ALTER TABLE produktZamowienie ADD CONSTRAINT produktZamowienie_PK PRIMARY KEY CLUSTERED (produkt_kod_produktu, zamowienie_nr)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON )
     ON "default"
    GO
 



-- Relacje   

 
ALTER TABLE adres
    ADD CONSTRAINT adres_klient_FK FOREIGN KEY
    (
     klient_login
    )
    REFERENCES klient
    (
     login
    )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
GO
 
ALTER TABLE egzemplarz
    ADD CONSTRAINT egzemplarz_produkt_FK FOREIGN KEY
    (
     produkt_kod_produktu
    )
    REFERENCES produkt
    (
     kod_produktu
    )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
GO


 
ALTER TABLE faktury
    ADD CONSTRAINT faktury_klient_FK FOREIGN KEY
    (
     klient_login
    )
    REFERENCES klient
    (
     login
    )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
GO
 
--ALTER TABLE faktury
--    ADD CONSTRAINT faktury_zamowienie_FK FOREIGN KEY
--    (
--     zamowienie_nr
--    )
--    REFERENCES zamowienie
--    (
--     id_zamowienia
--    )
--    ON DELETE NO ACTION
--    ON UPDATE NO ACTION
--GO
 
ALTER TABLE kontakt
    ADD CONSTRAINT kontakt_klient_FK FOREIGN KEY
    (
     klient_login
    )
    REFERENCES klient
    (
     login
    )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
GO
 
ALTER TABLE produktFaktura
    ADD CONSTRAINT produktFaktura_faktury_FK FOREIGN KEY
    (
     faktury_faktura
    )
    REFERENCES faktury
    (
     faktura
    )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
GO
 
ALTER TABLE produktFaktura
    ADD CONSTRAINT produktFaktura_produkt_FK FOREIGN KEY
    (
     produkt_kod_produktu
    )
    REFERENCES produkt
    (
     kod_produktu
    )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
GO
 
ALTER TABLE produktZamowienie
    ADD CONSTRAINT produktZamowienie_produkt_FK FOREIGN KEY
    (
     produkt_kod_produktu
    )
    REFERENCES produkt
    (
     kod_produktu
    )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
GO
 
ALTER TABLE produktZamowienie
    ADD CONSTRAINT produktZamowienie_zamowienie_FK FOREIGN KEY
    (
     zamowienie_nr
    )
    REFERENCES zamowienie
    (
     id_zamowienia
    )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
GO
 
 
ALTER TABLE zamowienie
    ADD CONSTRAINT zamowienie_klient_FK FOREIGN KEY
    (
     klient_login
    )
    REFERENCES klient
    (
     login
    )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
GO

