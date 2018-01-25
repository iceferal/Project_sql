--IF OBJECT_ID('adres', 'U') IS NOT NULL
--  DROP TABLE adres;
 
--IF OBJECT_ID('egzemplarz', 'U') IS NOT NULL
--  DROP TABLE egzemplarz;

--IF OBJECT_ID('kontakt', 'U') IS NOT NULL
--  DROP TABLE kontakt;
 
--IF OBJECT_ID('produktFaktura', 'U') IS NOT NULL
--  DROP TABLE produktFaktura;
 
--IF OBJECT_ID('produktZamowienie', 'U') IS NOT NULL
--  DROP TABLE produktZamowienie;
 
--IF OBJECT_ID('produkt', 'U') IS NOT NULL
--  DROP TABLE produkt;

-- IF OBJECT_ID('faktury', 'U') IS NOT NULL
--  DROP TABLE faktury; 

-- IF OBJECT_ID('zamowienie', 'U') IS NOT NULL
--  DROP TABLE zamowienie;

-- IF OBJECT_ID('klient', 'U') IS NOT NULL
--  DROP TABLE klient;

 
CREATE TABLE klient
    (
     login VARCHAR (64) NOT NULL ,
     haslo VARCHAR (64) NOT NULL ,
     imie VARCHAR (64) NOT NULL CONSTRAINT ck_klient_imie CHECK (imie LIKE '[A-Z]%'),
     nazwisko VARCHAR (64) NOT NULL CONSTRAINT ck_klient_nazw CHECK (nazwisko LIKE '[A-Z]%'),
     nip VARCHAR (64) CONSTRAINT ck_klient_nip CHECK(nip LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
     nazwa_firmy VARCHAR (64),
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

INSERT INTO klient VALUES
( 'Nazar03' , 'xppew%^85' , 'Nazar' ,'Staron' ,'68572088910' ,'Bosch Sp.z o.o.' ),
( 'Przemko27' , 'ogioe(!54' , 'Przemko' ,'Rozek' ,'37382448272' ,'Okno Company' ),
( 'Wili65' , 'lmedn*!59' , 'Wili' ,'Galkowski' ,'76895392878' ,'Ryba S.A.' ),
( 'Hartmund24' , 'mfmer^%45' , 'Hartmund' ,'Jurewicz' ,'13436056105' ,'Canon Company' ),
( 'Aurela54' , 'hqaug@$03' , 'Aurela' ,'Biesiada' ,'21858979550' ,'Olympus Company' ),
( 'Mieryclawa42' , 'amxqz%^09' , 'Mieryclawa' ,'Szumski' ,'69967491286' ,'Ryba Sp.z o.o.' ),
( 'Lilla82' , 'pclqn&%40' , 'Lilla' ,'Budnik' ,'17392732311' ,'Okno Company' ),
( 'Felicytes30' , 'zfmyc%#76' , 'Felicytes' ,'Kijak' ,'64545923690' ,'Olympus Industries' ),
( 'Rodolf72' , 'loxdw@)47' , 'Rodolf' ,'Banka' ,'24446607675' ,'Ryba Company' ),
( 'Hamid56' , 'tttkl%&20' , 'Hamid' ,'Wesoloski' ,'45448760871' ,'Ryba Industries' ),
( 'Wasilika11' , 'kfpis(&74' , 'Wasilika' ,'Brozek' ,'47721984190' ,'Canon Sp.z o.o.' ),
( 'Edda16' , 'zxkli#%49' , 'Edda' ,'Chudzik' ,'17971493081' ,'Okno Company' ),
( 'Kiura33' , 'srlcz##69' , 'Kiura' ,'Marecki' ,'72654823686' ,'Ryba S.A.' ),
( 'Druzjanna54' , 'tbrda$)11' , 'Druzjanna' ,'Golombek' ,'34456709178' ,'Olympus Sp.z o.o.' ),
( 'Praskowia44' , 'pcltx^)98' , 'Praskowia' ,'Goscinski' ,'21404671882' ,'Olympus Company' ),
( 'Przemko63' , 'jlvpm^^94' , 'Przemko' ,'Glogowski' ,'96834940813' ,'Olympus Industries' ),
( 'Margaryta24' , 'zmjsb*#80' , 'Margaryta' ,'Gawrych' ,'77978697139' ,'Okno S.A.' ),
( 'Szymeon06' , 'smucj&(28' , 'Szymeon' ,'Wielgus' ,'94876010755' ,'Sony Company' ),
( 'Tomomasa41' , 'kmtvm**58' , 'Tomomasa' ,'Lipa' ,'63627356983' ,'Okno Company' ),
( 'Bob44' , 'ozmpv$(44' , 'Bob' ,'Sitkowski' ,'71836201010' ,'Sony Sp.z o.o.' ),
( 'Malik48' , 'sogun^&08' , 'Malik' ,'Slomkowski' ,'92821518933' ,'Olympus Company' ),
( 'Simion81' , 'bwlpz#$79' , 'Simion' ,'Mlynarski' ,'53936755672' ,'Ryba Company' ),
( 'Joachem45' , 'wnoem&@37' , 'Joachem' ,'Lata' ,'69398435112' ,'Canon Industries' ),
( 'Otilda81' , 'ivvjm%(68' , 'Otilda' ,'Bienkowski' ,'44274915128' ,'Ryba S.A.' ),
( 'Jacenty74' , 'rlosk&%45' , 'Jacenty' ,'Stepnowski' ,'47648789276' ,'Okno S.A.' ),
( 'Hellena74' , 'mmuxd*!08' , 'Hellena' ,'Karwowski' ,'18048541365' ,'Bosch Sp.z o.o.' ),
( 'Stamislaw14' , 'bxnfs^(77' , 'Stamislaw' ,'Filipkowski' ,'20766512746' ,'Okno Sp.z o.o.' ),
( 'Bogodar74' , 'lqiin#^61' , 'Bogodar' ,'Kozak' ,'76475325916' ,'Sony Industries' ),
( 'Melcyda51' , 'ezisd%!66' , 'Melcyda' ,'Bonar' ,'11313531310' ,'Bosch S.A.' ),
( 'Sawery85' , 'mxuos#*10' , 'Sawery' ,'Siuda' ,'61353501288' ,'Olympus S.A.' ),
( 'Wieczeslawa25' , 'yvxep@@97' , 'Wieczeslawa' ,'Wajda' ,'66461047543' ,'Olympus Sp.z o.o.' ),
( 'Imogena62' , 'gakvl^&10' , 'Imogena' ,'Ogonowski' ,'68877343760' ,'Ryba S.A.' ),
( 'Golfrida87' , 'jyydg%(61' , 'Golfrida' ,'Kaczmarczyk' ,'77075101450' ,'Ryba Company' ),
( 'Serwiliusz01' , 'aqfwf!!36' , 'Serwiliusz' ,'Zuraw' ,'83463405113' ,'Bosch Industries' ),
( 'Boghdan50' , 'mgohy(%76' , 'Boghdan' ,'Blaszkiewicz' ,'88262370905' ,'Sony Company' ),
( 'Alim32' , 'nfeuz^@57' , 'Alim' ,'Banka' ,'72727889390' ,'Olympus Sp.z o.o.' ),
( 'Margo61' , 'sjgeu$!15' , 'Margo' ,'Niemczyk' ,'56223173401' ,'Sony Industries' ),
( 'Hersz03' , 'isswi#^70' , 'Hersz' ,'Terlecki' ,'44180387880' ,'Okno Company' ),
( 'Azacja62' , 'gerrd^(80' , 'Azacja' ,'Piechowski' ,'20796217132' ,'Bosch S.A.' ),
( 'Reinert88' , 'uwkfu*%34' , 'Reinert' ,'Chromy' ,'72037990952' ,'Bosch Company' ),
( 'Zhanna20' , 'hljzz%)72' , 'Zhanna' ,'Gracyalny' ,'37113056472' ,'Ryba Sp.z o.o.' ),
( 'Klementyna03' , 'calhd))95' , 'Klementyna' ,'Nycz' ,'53323024333' ,'Canon Sp.z o.o.' ),
( 'Bibian45' , 'ywpfh*&78' , 'Bibian' ,'Gardocki' ,'67525238067' ,'Okno S.A.' ),
( 'Frida31' , 'lmwrf!#04' , 'Frida' ,'Andrzejewski' ,'40297098423' ,'Ryba Sp.z o.o.' ),
( 'Ignaca73' , 'zjhzm&!79' , 'Ignaca' ,'Paczkowski' ,'71180829079' ,'Olympus Company' ),
( 'Lubomierz36' , 'kfzkx#@22' , 'Lubomierz' ,'Kolinski' ,'90632904638' ,'Olympus Company' ),
( 'Annelisa78' , 'mtgwb)$18' , 'Annelisa' ,'Stodola' ,'66241811186' ,'Okno S.A.' ),
( 'Ermelinda06' , 'tyeee$%03' , 'Ermelinda' ,'Golab' ,'65846945156' ,'Sony Industries' ),
( 'Ruggero43' , 'aizkw)*40' , 'Ruggero' ,'Ciesielski' ,'37559841258' ,'Okno S.A.' ),
( 'Mahmet74' , 'hhcxs*@99' , 'Mahmet' ,'Smialy' ,'42112595635' ,'Ryba Sp.z o.o.' )
 


INSERT INTO kontakt VALUES
( 'Nazar03' , '217078011' , '516172366' ,'Nazar03@o2.pl' ),
( 'Przemko27' , '411777637' , '219058621' ,'Przemko27@gmail.com' ),
( 'Wili65' , '781391787' , '256418182' ,'Wili65@onet.pl' ),
( 'Hartmund24' , '822558684' , '683649848' ,'Hartmund24@gmail.com' ),
( 'Aurela54' , '576621471' , '916369357' ,'Aurela54@amu.edu.pl' ),
( 'Mieryclawa42' , '769405553' , '996205813' ,'Mieryclawa42@hotmail.com' ),
( 'Lilla82' , '822362708' , '634034785' ,'Lilla82@interia.pl' ),
( 'Felicytes30' , '196210713' , '646557368' ,'Felicytes30@gmail.com' ),
( 'Rodolf72' , '253028845' , '498853233' ,'Rodolf72@onet.pl' ),
( 'Hamid56' , '979088186' , '907462531' ,'Hamid56@o2.pl' ),
( 'Wasilika11' , '922198975' , '693700054' ,'Wasilika11@o2.pl' ),
( 'Edda16' , '270137615' , '113791829' ,'Edda16@o2.pl' ),
( 'Kiura33' , '190081701' , '385008848' ,'Kiura33@o2.pl' ),
( 'Druzjanna54' , '788812333' , '923114398' ,'Druzjanna54@outlook.com' ),
( 'Praskowia44' , '195815206' , '318835709' ,'Praskowia44@gmail.com' ),
( 'Przemko63' , '468238041' , '739369137' ,'Przemko63@o2.pl' ),
( 'Margaryta24' , '604158330' , '937922048' ,'Margaryta24@gmail.com' ),
( 'Szymeon06' , '120090493' , '483229873' ,'Szymeon06@outlook.com' ),
( 'Tomomasa41' , '420057888' , '359373112' ,'Tomomasa41@outlook.com' ),
( 'Bob44' , '689449596' , '774906732' ,'Bob44@gmail.com' ),
( 'Malik48' , '812744586' , '965949274' ,'Malik48@hotmail.com' ),
( 'Simion81' , '295622091' , '917165061' ,'Simion81@o2.pl' ),
( 'Joachem45' , '154792124' , '118289922' ,'Joachem45@outlook.com' ),
( 'Otilda81' , '947683230' , '482387153' ,'Otilda81@outlook.com' ),
( 'Jacenty74' , '577067797' , '698050635' ,'Jacenty74@hotmail.com' ),
( 'Hellena74' , '298748841' , '890713430' ,'Hellena74@amu.edu.pl' ),
( 'Stamislaw14' , '584852539' , '234881590' ,'Stamislaw14@o2.pl' ),
( 'Bogodar74' , '934741147' , '698066224' ,'Bogodar74@hotmail.com' ),
( 'Melcyda51' , '611850752' , '592355365' ,'Melcyda51@hotmail.com' ),
( 'Sawery85' , '304646903' , '583211171' ,'Sawery85@amu.edu.pl' ),
( 'Wieczeslawa25' , '402925486' , '439718388' ,'Wieczeslawa25@hotmail.com' ),
( 'Imogena62' , '148421476' , '825075528' ,'Imogena62@outlook.com' ),
( 'Golfrida87' , '413625018' , '199570957' ,'Golfrida87@o2.pl' ),
( 'Serwiliusz01' , '355139605' , '640210323' ,'Serwiliusz01@gmail.com' ),
( 'Boghdan50' , '119861794' , '949389182' ,'Boghdan50@gmail.com' ),
( 'Alim32' , '647941620' , '606999480' ,'Alim32@outlook.com' ),
( 'Margo61' , '301811617' , '393941484' ,'Margo61@interia.pl' ),
( 'Hersz03' , '188682851' , '249733373' ,'Hersz03@outlook.com' ),
( 'Azacja62' , '162922949' , '711270738' ,'Azacja62@onet.pl' ),
( 'Reinert88' , '449941163' , '883746246' ,'Reinert88@gmail.com' ),
( 'Zhanna20' , '125125082' , '601273280' ,'Zhanna20@hotmail.com' ),
( 'Klementyna03' , '791545573' , '178465274' ,'Klementyna03@amu.edu.pl' ),
( 'Bibian45' , '345330582' , '206249262' ,'Bibian45@amu.edu.pl' ),
( 'Frida31' , '280291887' , '116129855' ,'Frida31@o2.pl' ),
( 'Ignaca73' , '482777637' , '927324866' ,'Ignaca73@interia.pl' ),
( 'Lubomierz36' , '114201562' , '977936182' ,'Lubomierz36@interia.pl' ),
( 'Annelisa78' , '312548890' , '882604626' ,'Annelisa78@onet.pl' ),
( 'Ermelinda06' , '211843326' , '370486855' ,'Ermelinda06@onet.pl' ),
( 'Ruggero43' , '874586057' , '174244335' ,'Ruggero43@outlook.com' ),
( 'Mahmet74' , '484017589' , '356249959' ,'Mahmet74@hotmail.com' )


 
INSERT INTO adres VALUES
( 'Nazar03' , 'Rumiankowa' , '45' ,'1' ,'52-100' ,'Gdansk' ),
( 'Przemko27' , 'Rzepowa' , '78' ,'19' ,'81-715' ,'Szczecin' ),
( 'Wili65' , 'Wesola' , '61' ,'37' ,'41-220' ,'Wroclaw' ),
( 'Hartmund24' , 'Kwiatowa' , '27' ,'17' ,'71-586' ,'Krakow' ),
( 'Aurela54' , 'Rumiankowa' , '61' ,'33' ,'93-458' ,'Poznan' ),
( 'Mieryclawa42' , 'Jablkowa' , '71' ,'22' ,'60-220' ,'Lodz' ),
( 'Lilla82' , 'Malinowa' , '33' ,'18' ,'26-571' ,'Warszawa' ),
( 'Felicytes30' , 'Rzepowa' , '85' ,'20' ,'85-508' ,'Warszawa' ),
( 'Rodolf72' , 'Rumiankowa' , '9' ,'46' ,'21-463' ,'Gdansk' ),
( 'Hamid56' , 'Gruszkowa' , '45' ,'34' ,'12-314' ,'Krakow' ),
( 'Wasilika11' , 'Malinowa' , '51' ,'11' ,'70-991' ,'Poznan' ),
( 'Edda16' , 'Malinowa' , '23' ,'19' ,'66-266' ,'Poznan' ),
( 'Kiura33' , 'Mila' , '54' ,'27' ,'67-400' ,'Lodz' ),
( 'Druzjanna54' , 'Jablkowa' , '71' ,'30' ,'71-426' ,'Lodz' ),
( 'Praskowia44' , 'Rumiankowa' , '81' ,'28' ,'14-799' ,'Warszawa' ),
( 'Przemko63' , 'Rumiankowa' , '70' ,'37' ,'81-728' ,'Krakow' ),
( 'Margaryta24' , 'Gruszkowa' , '44' ,'11' ,'33-891' ,'Wroclaw' ),
( 'Szymeon06' , 'Rzepowa' , '6' ,'9' ,'80-214' ,'Gdansk' ),
( 'Tomomasa41' , 'Mila' , '78' ,'34' ,'27-493' ,'Wroclaw' ),
( 'Bob44' , 'Mila' , '98' ,'2' ,'47-484' ,'Gdansk' ),
( 'Malik48' , 'Wesola' , '50' ,'6' ,'37-555' ,'Krakow' ),
( 'Simion81' , 'Kwiatowa' , '79' ,'19' ,'15-202' ,'Krakow' ),
( 'Joachem45' , 'Rumiankowa' , '16' ,'39' ,'40-788' ,'Warszawa' ),
( 'Otilda81' , 'Mila' , '64' ,'3' ,'17-932' ,'Lodz' ),
( 'Jacenty74' , 'Rzepowa' , '72' ,'2' ,'83-194' ,'Warszawa' ),
( 'Hellena74' , 'Kwiatowa' , '40' ,'24' ,'10-237' ,'Wroclaw' ),
( 'Stamislaw14' , 'Rumiankowa' , '9' ,'1' ,'54-107' ,'Wroclaw' ),
( 'Bogodar74' , 'Rzepowa' , '73' ,'4' ,'28-742' ,'Gdansk' ),
( 'Melcyda51' , 'Mila' , '45' ,'17' ,'10-141' ,'Szczecin' ),
( 'Sawery85' , 'Jablkowa' , '53' ,'26' ,'42-357' ,'Krakow' ),
( 'Wieczeslawa25' , 'Malinowa' , '68' ,'29' ,'44-883' ,'Szczecin' ),
( 'Imogena62' , 'Wesola' , '19' ,'28' ,'32-110' ,'Szczecin' ),
( 'Golfrida87' , 'Rzepowa' , '50' ,'4' ,'10-511' ,'Krakow' ),
( 'Serwiliusz01' , 'Wesola' , '21' ,'32' ,'57-900' ,'Poznan' ),
( 'Boghdan50' , 'Mila' , '75' ,'7' ,'13-964' ,'Szczecin' ),
( 'Alim32' , 'Jablkowa' , '10' ,'31' ,'18-147' ,'Wroclaw' ),
( 'Margo61' , 'Malinowa' , '97' ,'23' ,'26-879' ,'Wroclaw' ),
( 'Hersz03' , 'Jablkowa' , '86' ,'42' ,'28-159' ,'Szczecin' ),
( 'Azacja62' , 'Kwiatowa' , '9' ,'49' ,'95-435' ,'Poznan' ),
( 'Reinert88' , 'Jablkowa' , '53' ,'15' ,'73-129' ,'Wroclaw' ),
( 'Zhanna20' , 'Rzepowa' , '6' ,'26' ,'10-952' ,'Szczecin' ),
( 'Klementyna03' , 'Jablkowa' , '28' ,'38' ,'18-801' ,'Krakow' ),
( 'Bibian45' , 'Jablkowa' , '40' ,'48' ,'95-866' ,'Gdansk' ),
( 'Frida31' , 'Mila' , '89' ,'10' ,'53-141' ,'Wroclaw' ),
( 'Ignaca73' , 'Rumiankowa' , '34' ,'31' ,'10-723' ,'Wroclaw' ),
( 'Lubomierz36' , 'Mila' , '97' ,'3' ,'64-621' ,'Krakow' ),
( 'Annelisa78' , 'Wesola' , '81' ,'44' ,'35-202' ,'Wroclaw' ),
( 'Ermelinda06' , 'Rumiankowa' , '51' ,'6' ,'45-653' ,'Gdansk' ),
( 'Ruggero43' , 'Rumiankowa' , '30' ,'5' ,'15-369' ,'Warszawa' ),
( 'Mahmet74' , 'Gruszkowa' , '66' ,'14' ,'39-859' ,'Poznan' )



INSERT INTO produkt VALUES
( 'klaw123', 'Klawiatura przewodowa', 'Logitech', '99.99', '120.98', 'czarny', '1', 'Akcesoria komputerowe' ),
( 'klaw112', 'Klawiatura przewodowa', 'Samsung', '49.99', '60.99', 'czarny', '3', 'Akcesoria komputerowe' ),
( 'klaw547', 'Klawiatura bezprzewodowa', 'Razer', '250.00', '305.00', 'niebieski', '2', 'Akcesoria komputerowe' ),
( 'klaw997', 'Klawiatura bezprzewodowa', 'Sony', '129.99', '159.99', 'fioletowy', '4', 'Akcesoria komputerowe' ),
( 'druk07', 'Drukarka atramentowa', 'Brother', '250.00', '305.00', 'czarny', '2', 'Akcesoria komputerowe' ),
( 'druk99', 'Drukarka laserowa', 'Samsung', '399.99', '489.98', 'bialy', '1', 'Akcesoria komputerowe' ),
( 'monit35', 'Monitor komputerowy', 'Samsung', '509.99', '620.00', 'czarny', '6', 'Akcesoria komputerowe' ),
( 'monit92', 'Monitor komputerowy', 'BenQ', '399.00', '485.99', 'bialy', '3', 'Akcesoria komputerowe' ),
( 'mysz69', 'Myszka komputerowa przewodowa', 'Logitech', '29.99', '36.58', 'czarny', '4', 'Akcesoria komputerowe' ),
( 'mysz07', 'Myszka komputerowa bezprzewodowa', 'Cyborg', '99.99', '121.98', 'czarny', '2', 'Akcesoria komputerowe' ),
( 'zelaz71', 'Zelazko elektryczne', 'Philips', '167.55', '199.99', 'bialy', '3', 'Sprzet AGD' ),
( 'zelaz09', 'Zelazko elektryczne', 'Bosh', '171.31', '209.00', 'czarny', '2', 'Sprzet AGD' ),
( 'odku91', 'Odkurzacz reczny', 'Philips', '97.55', '199.99', 'bialy', '1', 'Sprzet AGD' ),
( 'went63', 'Wentylator przenosny', 'AEG', '99.99', '121.98', 'bialy', '3', 'Sprzet AGD' ),
( 'czaj50', 'Czajnik elektryczny', 'Zelmer', '97.55', '199.99', 'czarny', '5', 'Sprzet AGD' ),
( 'czaj30', 'Czajnik elektryczny', 'Electrolux', '180.99', '219.00', 'czerwony', '2', 'Sprzet AGD' ),
( 'blend02', 'Blender', 'Bosh', '138.99', '169.99', 'srebrny', '5', 'Sprzet AGD' ),
( 'eksp99', 'Ekspres cisnieniowy', 'Siemens', '204.99', '249.99', 'czarny', '2', 'Sprzet AGD' ),
( 'eksp06', 'Ekspres cisnieniowy', 'Ziemens', '399.99', '489.98', 'srebrny', '1', 'Sprzet AGD' ),
( 'miks594', 'Mikser reczny', 'Zelmer', '129.99', '159.99', 'bialy', '3', 'Sprzet AGD' )


INSERT INTO egzemplarz(nr_seryjny, produkt_kod_produktu, data_zakupu) VALUES
( '12254684', 'klaw123', '2016-07-21' ),
( '53415874', 'klaw112', '2017-07-03' ),
( '96541256', 'klaw112', '2012-06-09' ),
( '75214214', 'klaw112', '2016-09-29' ),
( '65325354', 'klaw547', '2014-06-14' ),
( '87421457', 'klaw547', '2017-07-07' ),
( '15365247', 'klaw997', '2016-04-18' ),
( '75425897', 'klaw997', '2015-08-09' ),
( '25423654', 'klaw997', '2015-04-11' ),
( '23568974', 'klaw997', '2011-03-15' ),
( '70412548', 'druk07', '2016-05-21' ),
( '95603541', 'druk07', '2016-09-20' ),
( '74124575', 'druk99', '2017-01-21' ),
( '45757414', 'monit35', '2015-06-16' ),
( '74125474', 'monit35', '2016-11-15' ),
( '77457417', 'monit35', '2014-12-28' ),
( '74287798', 'monit35', '2013-09-01' ),
( '74521525', 'monit35', '2009-02-05' ),
( '75124256', 'monit35', '2016-01-21' ),
( '75145877', 'monit92', '2011-07-27' ),
( '20145257', 'monit92', '2015-06-28' ),
( '10235457', 'monit92', '2016-07-28' ),
( '54785578', 'mysz69', '2014-09-09' ),
( '52314077', 'mysz69', '2016-07-18' ),
( '77872078', 'mysz69', '2017-08-08' ),
( '78078070', 'mysz69', '2016-04-21' ),
( '78232040', 'mysz07', '2017-07-12' ),
( '30782474', 'mysz07', '2016-09-20' ),
( '78208070', 'zelaz71', '2017-09-11' ),
( '83654214', 'zelaz71', '2017-10-16' ),
( '09452178', 'zelaz71', '2017-01-23' ),
( '09642233', 'zelaz09', '2016-11-03' ),
( '78245678', 'zelaz09', '2017-08-05' ),
( '12525444', 'odku91', '2014-07-19' ),
( '30785254', 'went63', '2013-12-21' ),
( '07807524', 'went63', '2016-10-22' ),
( '78082054', 'went63', '2017-09-07' ),
( '07854567', 'czaj50', '2017-05-09' ),
( '90456047', 'czaj50', '2017-02-23' ),
( '93075478', 'czaj50', '2016-03-15' ),
( '97453450', 'czaj50', '2016-06-14' ),
( '08078577', 'czaj50', '2017-01-31' ),
( '87070827', 'czaj30', '2017-02-28' ),
( '08785700', 'czaj30', '2017-05-29' ),
( '78556786', 'blend02', '2017-07-08' ),
( '40257541', 'blend02', '2016-09-19' ),
( '44102074', 'blend02', '2017-04-07' ),
( '44077652', 'blend02', '2017-03-23' ),
( '35636407', 'blend02', '2016-09-20' ),
( '50221120', 'eksp99', '2014-07-18' ),
( '12120120', 'eksp99', '2015-10-12' ),
( '70203217', 'eksp06', '2012-12-25' ),
( '05075721', 'miks594', '2016-09-20' ),
( '64040575', 'miks594', '2017-05-28' ),
( '97774007', 'miks594', '2017-01-01' )

CREATE PROCEDURE Wstaw_klienta (
        @login VARCHAR(64),
        @haslo VARCHAR(64),
        @imie VARCHAR(64),
		@nazwisko VARCHAR(64),
		@nip VARCHAR(64)=NULL,
		@nazwa_firmy VARCHAR(64)=NULL )
AS

INSERT INTO klient (login, haslo, imie, nazwisko, nip, nazwa_firmy)
        VALUES (@login, @haslo, @imie, @nazwisko, @nip, @nazwa_firmy)

GO
-- Wstaw_klienta 'test1', 'test2', 'test3', 'test4', '12345678910', 'test6'
 
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

--Wstaw_kontakt 'test1', 369258147, 123456789, 'test@gmail.com'

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

--Zmodyfikuj_kontakt 'test1', 369258147, 123456789, 'tttttttttttest@gmail.com'

 CREATE PROCEDURE Usun_kontakt (
		@login VARCHAR(64)
		)
AS
	DELETE FROM kontakt
	WHERE klient_login = @login
GO

--Usun_kontakt 'test1'

CREATE PROCEDURE Wstaw_produkt (
        @kod VARCHAR(64),
        @nazwa VARCHAR(64),
		@producent VARCHAR(64),
		@netto MONEY,
		@brutto MONEY,
		@kolor VARCHAR(64),
		@ilosc VARCHAR(64),
		@kategoria VARCHAR(64),
		@seryjny INT
		)
AS
INSERT INTO produkt (kod_produktu, nazwa_produktu, producent, cena_netto, cena_brutto, kolor, ilosc, kategoria)
        VALUES (@kod, @nazwa, @producent, @netto, @brutto, @kolor, @ilosc, @kategoria)
INSERT INTO egzemplarz (nr_seryjny, produkt_kod_produktu)
		VALUES (@seryjny, @kod)
GO

--Wstaw_produkt 'atest1', 'testowy', 'zarabisty', 9999, 1000, 'black', 1, 'test', 9999999

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

-- Dostawy 'kurier'

Create Procedure Dodaj_zamowienie (
		@login Varchar(64),
		@produkt Varchar(64))
As
BEGIN TRAN
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
		else If exists (Select nr_zamowienia From Zamowienie Where (klient_login = @login AND Month(GETDATE()) = Month(data_zlozenia) AND DAY(GETDATE()) = DAY(data_zlozenia)))
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
		else If exists (Select nr_faktury From Faktury Where (klient_login = @login AND Month(GETDATE()) = Month(data_sprzedazy) AND DAY(GETDATE()) = DAY(data_sprzedazy)))
		Set @nrfak = (Select MAX(nr_faktury) From Faktury Where (klient_login = @login AND Month(GETDATE()) = Month(data_sprzedazy) AND DAY(GETDATE()) = DAY(data_sprzedazy)))
		else
		Set @nrfak = (Select MAX(nr_faktury) From Faktury ) + 1;

	Insert Into Zamowienie (id_zamowienia, nr_zamowienia, klient_login) Values
		( @id, @nr, @login )
	Insert Into Faktury (faktura, nr_faktury, klient_login, wartosc_netto, wartosc_brutto) Values
		( @fak, @nrfak, @login, (Select cena_netto from Produkt where kod_produktu = @produkt), (Select cena_brutto from Produkt where kod_produktu = @produkt) )
	Insert Into produktZamowienie Values
		( @produkt, @id )
	Insert Into produktFaktura Values
		( @produkt, @fak )

	Declare @seria Int;
	Set @seria = (Select TOP 1 nr_seryjny From Egzemplarz Where (produkt_kod_produktu Like @produkt AND czy_sprzedano = 0) ORDER BY nr_seryjny)

	Update Egzemplarz
		Set czy_sprzedano = 1,
	     	data_sprzedazy = Getdate()
		Where nr_seryjny = @seria
end
else
	Print 'brak dostępnych egzeplarzy tego produktu!'
COMMIT TRANSACTION
Go

Create Procedure Koszyk (
	@login Varchar(64),
	@pro1 Varchar(64), 
	@pro2 Varchar(64)=NULL,
	@pro3 Varchar(64)=NULL,
	@pro4 Varchar(64)=NULL,
	@pro5 Varchar(64)=NULL)
As
	EXEC Dodaj_zamowienie @login, @pro1
	if @pro2 IS NOT NULL
		EXEC Dodaj_zamowienie @login, @pro2;
	if (@pro3 IS NOT NULL)
		EXEC Dodaj_zamowienie @login, @pro3;
	if (@pro4 IS NOT NULL)
		EXEC Dodaj_zamowienie @login, @pro4;
	if (@pro5 IS NOT NULL)
		EXEC Dodaj_zamowienie @login, @pro5;
Go

-- Koszyk 'test1', 'monit92', 'monit35'

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

--SELECT * FROM ZamowieniaKlienta('test1')

--zwraca totalna cene zamowienia o podanym numerze
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

--SELECT * FROM WszystkieZamowienia

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

--Dodaj_zamowienie 'Serwiliusz01' , 'druk07'
--Select * from Zamowienie
--Dodaj_zamowienie 'Serwiliusz01' , 'klaw547'
--Select * from Zamowienie

