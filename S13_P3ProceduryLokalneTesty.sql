CREATE OR ALTER PROCEDURE RezerwujTeraz
@Par_Imie varchar(30),
@Par_Nazwisko varchar(30),
@Par_IleDni int,
@Par_JakiPokoj varchar(4)
AS
BEGIN
SET XACT_ABORT ON;
BEGIN TRANSACTION
DECLARE @Par_IDG int
SET @Par_IDG = (SELECT IDGosc FROM dbo.Gosc WHERE Imie = @Par_Imie AND Nazwisko = @Par_Nazwisko);
DECLARE @Par_IDTP int
SET @Par_IDTP = (SELECT IDTypPokoj FROM dbo.TypPokoj WHERE NazwaPokoj = @Par_JakiPokoj);
DECLARE @Par_IDP int
SET @Par_IDP = (SELECT TOP 1 IDPokoj FROM dbo.Pokoj WHERE IDTypPokoj = @Par_IDTP  AND Stan = 'GOT');
INSERT INTO Rezerwacja (IDGosc, DataRezerwacji, DataRozpoczecia, DataZakonczenia, IDStatus, KwotaLaczna, Uwagi)
VALUES (@Par_IDG,GETDATE(),GETDATE(),DATEADD(day,@Par_IleDni,GETDATE()),2,(SELECT CenaPokoj FROM dbo.Pokoj WHERE IDPokoj = @Par_IDP),'Brak')



UPDATE dbo.Pokoj
SET Stan = 'ZAJ' WHERE IDPokoj = @Par_IDP;

IF (@@ERROR <> 0)
	BEGIN
		RAISERROR('Rezerwacja nie powiodla sie',16,1);
		ROLLBACK TRANSACTION
	END
	ELSE
COMMIT TRANSACTION
END;
GO

--Rezerwacja przed:
/*
IDRezerwacja IDGosc      DataRezerwacji DataRozpoczecia DataZakonczenia IDStatus    KwotaLaczna           Uwagi
------------ ----------- -------------- --------------- --------------- ----------- --------------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1            84          2025-06-17     2025-08-03      2025-08-04      1           150,00                BRAK                                                                                                                                                                                                                                                            
2            85          2025-06-17     2025-08-21      2025-08-23      1           200,00                BRAK                                                                                                                                                                                                                                                            
3            86          2025-06-17     2025-08-25      2025-08-26      1           500,00                BRAK                                                                                                                                                                                                                                                            
4            87          2025-06-17     2025-08-24      2025-08-25      1           300,00                BRAK                                                                                                                                                                                                                                                            
5            85          2025-06-17     2025-08-27      2025-08-28      2           500,00                BRAK                                                                                                                                                                                                                                                            
6            89          2025-06-17     2025-08-08      2025-08-23      1           400,00                BRAK                                                                                                                                                                                                                                                            
7            90          2025-06-17     2025-08-04      2025-08-05      3           500,00                Uczulenie na we³ne                                                                                                                                                                                                                                              
8            91          2025-06-17     2025-08-19      2025-08-23      1           1500,00               BRAK                                                                                                                                                                                                                                                            
9            91          2025-06-17     2025-08-28      2025-08-26      2           1050,00               BRAK                                                                                                                                                                                                                                                            
12           96          2025-06-27     2025-06-27      2025-06-28      1           150,00                NULL
13           96          2025-06-27     2025-06-27      2025-06-28      1           250,00                NULL
14           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
15           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
16           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL

(14 rows affected)

--Pokoje Przed

IDPokoj     IDTypPokoj  Lozko1Os    Lozko2Os    LiczbaMiejsc Stan Uwagi                                                                                                                                                                                                                                                            Wstawka CenaPokoj             KompletRecznik KompletWH   UpominekPowitalny ButelkaWody PokojPalacz Szklanka
----------- ----------- ----------- ----------- ------------ ---- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ------- --------------------- -------------- ----------- ----------------- ----------- ----------- -----------
1           1           1           0           1            GOT  BRAK                                                                                                                                                                                                                                                             BRAK    200,00                1              1           1                 1           TAK         1
2           1           1           0           1            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    150,00                1              1           1                 1           NIE         1
3           1           1           0           1            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    150,00                1              1           1                 1           NIE         1
4           1           1           0           1            GOT  BRAK                                                                                                                                                                                                                                                             BRAK    150,00                1              1           1                 1           NIE         1
5           1           1           0           1            PRZ+ BRAK                                                                                                                                                                                                                                                             BRAK    150,00                1              1           1                 1           NIE         1
6           2           0           1           2            GOT  BRAK                                                                                                                                                                                                                                                             BRAK    250,00                2              2           2                 2           NIE         2
7           2           0           1           2            PRZ+ BRAK                                                                                                                                                                                                                                                             BRAK    250,00                2              2           2                 2           NIE         2
8           3           3           0           3            GOT  BRAK                                                                                                                                                                                                                                                             BRAK    400,00                3              3           3                 3           NIE         3
9           4           2           1           4            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    500,00                4              4           4                 4           NIE         4
10          5           6           0           6            GOT  BRAK                                                                                                                                                                                                                                                             BRAK    800,00                6              6           6                 6           NIE         3
11          2           0           2           2            GOT  BRAK                                                                                                                                                                                                                                                             BRAK    250,00                2              2           2                 2           NIE         2
12          2           0           1           2            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    250,00                2              2           2                 2           NIE         2
13          1           1           0           1            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    150,00                1              1           1                 1           NIE         1
14          4           2           1           4            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    500,00                4              4           4                 4           NIE         4
15          4           2           1           4            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    500,00                4              4           4                 4           NIE         4
16          4           2           1           4            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    500,00                4              4           4                 4           NIE         4

(16 rows affected)

--Pokoje po

IDPokoj     IDTypPokoj  Lozko1Os    Lozko2Os    LiczbaMiejsc Stan Uwagi                                                                                                                                                                                                                                                            Wstawka CenaPokoj             KompletRecznik KompletWH   UpominekPowitalny ButelkaWody PokojPalacz Szklanka
----------- ----------- ----------- ----------- ------------ ---- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ------- --------------------- -------------- ----------- ----------------- ----------- ----------- -----------
1           1           1           0           1            GOT  BRAK                                                                                                                                                                                                                                                             BRAK    200,00                1              1           1                 1           TAK         1
2           1           1           0           1            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    150,00                1              1           1                 1           NIE         1
3           1           1           0           1            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    150,00                1              1           1                 1           NIE         1
4           1           1           0           1            GOT  BRAK                                                                                                                                                                                                                                                             BRAK    150,00                1              1           1                 1           NIE         1
5           1           1           0           1            PRZ+ BRAK                                                                                                                                                                                                                                                             BRAK    150,00                1              1           1                 1           NIE         1
6           2           0           1           2            ZAJ  BRAK                                                                                                                                                                                                                                                             BRAK    250,00                2              2           2                 2           NIE         2
7           2           0           1           2            PRZ+ BRAK                                                                                                                                                                                                                                                             BRAK    250,00                2              2           2                 2           NIE         2
8           3           3           0           3            GOT  BRAK                                                                                                                                                                                                                                                             BRAK    400,00                3              3           3                 3           NIE         3
9           4           2           1           4            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    500,00                4              4           4                 4           NIE         4
10          5           6           0           6            GOT  BRAK                                                                                                                                                                                                                                                             BRAK    800,00                6              6           6                 6           NIE         3
11          2           0           2           2            GOT  BRAK                                                                                                                                                                                                                                                             BRAK    250,00                2              2           2                 2           NIE         2
12          2           0           1           2            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    250,00                2              2           2                 2           NIE         2
13          1           1           0           1            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    150,00                1              1           1                 1           NIE         1
14          4           2           1           4            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    500,00                4              4           4                 4           NIE         4
15          4           2           1           4            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    500,00                4              4           4                 4           NIE         4
16          4           2           1           4            PRZ  BRAK                                                                                                                                                                                                                                                             BRAK    500,00                4              4           4                 4           NIE         4

(16 rows affected)

--Rezerwacja po
IDRezerwacja IDGosc      DataRezerwacji DataRozpoczecia DataZakonczenia IDStatus    KwotaLaczna           Uwagi
------------ ----------- -------------- --------------- --------------- ----------- --------------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1            84          2025-06-17     2025-08-03      2025-08-04      1           150,00                BRAK                                                                                                                                                                                                                                                            
2            85          2025-06-17     2025-08-21      2025-08-23      1           200,00                BRAK                                                                                                                                                                                                                                                            
3            86          2025-06-17     2025-08-25      2025-08-26      1           500,00                BRAK                                                                                                                                                                                                                                                            
4            87          2025-06-17     2025-08-24      2025-08-25      1           300,00                BRAK                                                                                                                                                                                                                                                            
5            85          2025-06-17     2025-08-27      2025-08-28      2           500,00                BRAK                                                                                                                                                                                                                                                            
6            89          2025-06-17     2025-08-08      2025-08-23      1           400,00                BRAK                                                                                                                                                                                                                                                            
7            90          2025-06-17     2025-08-04      2025-08-05      3           500,00                Uczulenie na we³ne                                                                                                                                                                                                                                              
8            91          2025-06-17     2025-08-19      2025-08-23      1           1500,00               BRAK                                                                                                                                                                                                                                                            
9            91          2025-06-17     2025-08-28      2025-08-26      2           1050,00               BRAK                                                                                                                                                                                                                                                            
12           96          2025-06-27     2025-06-27      2025-06-28      1           150,00                NULL
13           96          2025-06-27     2025-06-27      2025-06-28      1           250,00                NULL
14           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
15           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
16           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
18           86          2025-12-02     2025-12-02      2025-12-06      2           250,00                Brak                                                                                                                                                                                                                                                            

(15 rows affected)


Completion time: 2025-12-02T14:33:56.6305006+01:00
*/

SELECT * FROM Rezerwacja
GO
Select * FROM Pokoj
GO

--


--TRIGER AFTER
CREATE OR ALTER TRIGGER Trg_DeleteRezerwacja
ON dbo.Rezerwacja
AFTER DELETE
AS
BEGIN
INSERT INTO Rezerwacja_Archiwum (IDRezerwacja, IDGosc,DataRezerwacji, DataRozpoczecia, DataZakonczenia, IDStatus, KwotaLaczna, Uwagi, DataAnulowania, Uzytkownik)
SELECT IDRezerwacja, IDGosc, DataRezerwacji, DataRozpoczecia, DataZakonczenia, IDStatus, KwotaLaczna, Uwagi, GETDATE(), SUSER_SNAME() FROM DELETED
END;
GO

--Rezerwacja_Archwium przed
/*
IDRezerwacjArchwium IDRezerwacja IDGosc      DataRezerwacji DataRozpoczecia DataZakonczenia IDStatus    KwotaLaczna           Uwagi                                                                                                                                                                                                                                                            DataAnulowania Uzytkownik
------------------- ------------ ----------- -------------- --------------- --------------- ----------- --------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -------------- --------------------------------------------------------------------------------------------------------------------------------

(0 rows affected)


Completion time: 2025-12-02T14:43:16.3475637+01:00

*/
SELECT * FROM Rezerwacja_Archiwum
GO
--Rezerwacja Archwium po
/*
IDRezerwacjArchwium IDRezerwacja IDGosc      DataRezerwacji DataRozpoczecia DataZakonczenia IDStatus    KwotaLaczna           Uwagi                                                                                                                                                                                                                                                            DataAnulowania Uzytkownik
------------------- ------------ ----------- -------------- --------------- --------------- ----------- --------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -------------- --------------------------------------------------------------------------------------------------------------------------------
1                   17           86          2025-12-02     2025-12-02      2025-12-06      2           250,00                Brak                                                                                                                                                                                                                                                             2025-12-02     Snajper202

(1 row affected)

*/
--TRIGER BEFORE
CREATE OR ALTER TRIGGER Trg_BeforeRezerwacja
ON dbo.Rezerwacja
FOR INSERT
AS
BEGIN
INSERT INTO Rezerwacja_Modyfikacja
VALUES(SUSER_SNAME(),'Insert',GETDATE())
END;
GO
--Rezerwacja-Modyfikacja przed
/*
IDModyfikacja Uzytkownik                                                                                                                       Akcja                          DataAkcji
------------- -------------------------------------------------------------------------------------------------------------------------------- ------------------------------ ----------

(0 rows affected)


Completion time: 2025-12-02T15:51:05.1259080+01:00

*/
Select * FROM Rezerwacja_Modyfikacja
/*
IDModyfikacja Uzytkownik                                                                                                                       Akcja                          DataAkcji
------------- -------------------------------------------------------------------------------------------------------------------------------- ------------------------------ ----------
1             Snajper202                                                                                                                       Insert                         2025-12-02

(1 row affected)

*/



EXECUTE RezerwujTeraz Ania,Obojczyk,4,DBL
GO
SELECT * FROM Rezerwacja
GO
Select * FROM RezerwacjaUsluga
GO


CREATE OR ALTER PROCEDURE RezerwujUsluge
@Par_IDRezerwacja int,
@Par_Ile int,
@Par_Ktora int
AS
BEGIN 
SET XACT_ABORT ON
BEGIN TRANSACTION
DECLARE @Par_CenaLaczna int
SET @Par_CenaLaczna = ((SELECT Cena FROM dbo.Usluga WHERE IDUsluga = @Par_Ktora)*@Par_Ile);
INSERT INTO RezerwacjaUsluga(IDRezerwacja,IDUsluga,Ilosc,CenaSprzedazy,Uwagi)
VALUES (@Par_IDRezerwacja,@Par_Ktora,@Par_Ile,@Par_CenaLaczna,'Brak')

UPDATE dbo.Rezerwacja
SET KwotaLaczna = (KwotaLaczna + @Par_CenaLaczna)
WHERE IDRezerwacja = @Par_IDRezerwacja

IF (@@ERROR <> 0)
	BEGIN
		RAISERROR('Rezerwacja nie powiodla sie',16,1);
		ROLLBACK TRANSACTION
	END
	ELSE
COMMIT TRANSACTION
END;
GO
/*
--Rezerwacja PRZED
IDRezerwacja IDGosc      DataRezerwacji DataRozpoczecia DataZakonczenia IDStatus    KwotaLaczna           Uwagi
------------ ----------- -------------- --------------- --------------- ----------- --------------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1            84          2025-06-17     2025-08-03      2025-08-04      1           150,00                BRAK                                                                                                                                                                                                                                                            
2            85          2025-06-17     2025-08-21      2025-08-23      1           200,00                BRAK                                                                                                                                                                                                                                                            
3            86          2025-06-17     2025-08-25      2025-08-26      1           500,00                BRAK                                                                                                                                                                                                                                                            
4            87          2025-06-17     2025-08-24      2025-08-25      1           300,00                BRAK                                                                                                                                                                                                                                                            
5            85          2025-06-17     2025-08-27      2025-08-28      2           500,00                BRAK                                                                                                                                                                                                                                                            
6            89          2025-06-17     2025-08-08      2025-08-23      1           400,00                BRAK                                                                                                                                                                                                                                                            
7            90          2025-06-17     2025-08-04      2025-08-05      3           500,00                Uczulenie na we³ne                                                                                                                                                                                                                                              
8            91          2025-06-17     2025-08-19      2025-08-23      1           1500,00               BRAK                                                                                                                                                                                                                                                            
9            91          2025-06-17     2025-08-28      2025-08-26      2           1050,00               BRAK                                                                                                                                                                                                                                                            
12           96          2025-06-27     2025-06-27      2025-06-28      1           150,00                NULL
13           96          2025-06-27     2025-06-27      2025-06-28      1           250,00                NULL
14           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
15           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
16           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
18           86          2025-12-02     2025-12-02      2025-12-06      2           250,00                Brak                                                                                                                                                                                                                                                            

(15 rows affected)

--RezerwacjaUsluga PRZED
IDRezerwacjaUsluga IDRezerwacja IDUsluga    Ilosc       CenaSprzedazy         Uwagi
------------------ ------------ ----------- ----------- --------------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1                  2            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
2                  3            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
3                  1            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
4                  4            4           5           15,00                 BRAK                                                                                                                                                                                                                                                            
5                  4            5           6           60,00                 BRAK                                                                                                                                                                                                                                                            
6                  2            2           2           200,00                BRAK                                                                                                                                                                                                                                                            
7                  9            5           2           20,00                 BRAK                                                                                                                                                                                                                                                            
8                  8            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
10                 2            1           2           100,00                BRAK                                                                                                                                                                                                                                                            

(9 rows affected)
*/

EXEC RezerwujUsluge 18,3,9;
GO
/*
Rezerwacja PO
IDRezerwacja IDGosc      DataRezerwacji DataRozpoczecia DataZakonczenia IDStatus    KwotaLaczna           Uwagi
------------ ----------- -------------- --------------- --------------- ----------- --------------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1            84          2025-06-17     2025-08-03      2025-08-04      1           150,00                BRAK                                                                                                                                                                                                                                                            
2            85          2025-06-17     2025-08-21      2025-08-23      1           200,00                BRAK                                                                                                                                                                                                                                                            
3            86          2025-06-17     2025-08-25      2025-08-26      1           500,00                BRAK                                                                                                                                                                                                                                                            
4            87          2025-06-17     2025-08-24      2025-08-25      1           300,00                BRAK                                                                                                                                                                                                                                                            
5            85          2025-06-17     2025-08-27      2025-08-28      2           500,00                BRAK                                                                                                                                                                                                                                                            
6            89          2025-06-17     2025-08-08      2025-08-23      1           400,00                BRAK                                                                                                                                                                                                                                                            
7            90          2025-06-17     2025-08-04      2025-08-05      3           500,00                Uczulenie na we³ne                                                                                                                                                                                                                                              
8            91          2025-06-17     2025-08-19      2025-08-23      1           1500,00               BRAK                                                                                                                                                                                                                                                            
9            91          2025-06-17     2025-08-28      2025-08-26      2           1050,00               BRAK                                                                                                                                                                                                                                                            
12           96          2025-06-27     2025-06-27      2025-06-28      1           150,00                NULL
13           96          2025-06-27     2025-06-27      2025-06-28      1           250,00                NULL
14           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
15           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
16           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
18           86          2025-12-02     2025-12-02      2025-12-06      2           475,00                Brak                                                                                                                                                                                                                                                            

(15 rows affected)
RezerwacjaUsluga PO
IDRezerwacjaUsluga IDRezerwacja IDUsluga    Ilosc       CenaSprzedazy         Uwagi
------------------ ------------ ----------- ----------- --------------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1                  2            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
2                  3            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
3                  1            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
4                  4            4           5           15,00                 BRAK                                                                                                                                                                                                                                                            
5                  4            5           6           60,00                 BRAK                                                                                                                                                                                                                                                            
6                  2            2           2           200,00                BRAK                                                                                                                                                                                                                                                            
7                  9            5           2           20,00                 BRAK                                                                                                                                                                                                                                                            
8                  8            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
10                 2            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
11                 18           9           3           225,00                Brak                                                                                                                                                                                                                                                            

(10 rows affected)
*/

CREATE OR ALTER PROCEDURE RezerwacjaUslugaAnuluj
@Par_IDRezerwacjaUsluga int
AS
BEGIN
SET XACT_ABORT ON
BEGIN TRANSACTION
UPDATE dbo.Rezerwacja
SET KwotaLaczna = KwotaLaczna - (SELECT CenaSprzedazy FROM dbo.RezerwacjaUsluga WHERE IDRezerwacjaUsluga = @Par_IDRezerwacjaUsluga)
WHERE IDRezerwacja = (SELECT IDRezerwacja FROM dbo.RezerwacjaUsluga WHERE IDRezerwacjaUsluga = @Par_IDRezerwacjaUsluga)

DELETE RezerwacjaUsluga 
WHERE IDRezerwacjaUsluga = @Par_IDRezerwacjaUsluga

IF (@@ERROR <> 0)
	BEGIN
		RAISERROR('Rezerwacja nie powiodla sie',16,1);
		ROLLBACK TRANSACTION
	END
	ELSE
COMMIT TRANSACTION

END;
GO

/*RezerwacjaUsluga PRZED
IDRezerwacjaUsluga IDRezerwacja IDUsluga    Ilosc       CenaSprzedazy         Uwagi
------------------ ------------ ----------- ----------- --------------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1                  2            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
2                  3            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
3                  1            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
4                  4            4           5           15,00                 BRAK                                                                                                                                                                                                                                                            
5                  4            5           6           60,00                 BRAK                                                                                                                                                                                                                                                            
6                  2            2           2           200,00                BRAK                                                                                                                                                                                                                                                            
7                  9            5           2           20,00                 BRAK                                                                                                                                                                                                                                                            
8                  8            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
10                 2            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
11                 18           9           3           225,00                Brak                                                                                                                                                                                                                                                            

Rezerwacja Przed
IDRezerwacja IDGosc      DataRezerwacji DataRozpoczecia DataZakonczenia IDStatus    KwotaLaczna           Uwagi
------------ ----------- -------------- --------------- --------------- ----------- --------------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1            84          2025-06-17     2025-08-03      2025-08-04      1           150,00                BRAK                                                                                                                                                                                                                                                            
2            85          2025-06-17     2025-08-21      2025-08-23      1           200,00                BRAK                                                                                                                                                                                                                                                            
3            86          2025-06-17     2025-08-25      2025-08-26      1           500,00                BRAK                                                                                                                                                                                                                                                            
4            87          2025-06-17     2025-08-24      2025-08-25      1           300,00                BRAK                                                                                                                                                                                                                                                            
5            85          2025-06-17     2025-08-27      2025-08-28      2           500,00                BRAK                                                                                                                                                                                                                                                            
6            89          2025-06-17     2025-08-08      2025-08-23      1           400,00                BRAK                                                                                                                                                                                                                                                            
7            90          2025-06-17     2025-08-04      2025-08-05      3           500,00                Uczulenie na we³ne                                                                                                                                                                                                                                              
8            91          2025-06-17     2025-08-19      2025-08-23      1           1500,00               BRAK                                                                                                                                                                                                                                                            
9            91          2025-06-17     2025-08-28      2025-08-26      2           1050,00               BRAK                                                                                                                                                                                                                                                            
12           96          2025-06-27     2025-06-27      2025-06-28      1           150,00                NULL
13           96          2025-06-27     2025-06-27      2025-06-28      1           250,00                NULL
14           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
15           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
16           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
18           86          2025-12-02     2025-12-02      2025-12-06      2           475,00                Brak                                                                                                                                                                                                                                                            

*/

EXEC RezerwacjaUslugaAnuluj 11
GO

Select * FROM Rezerwacja
Select * FROM RezerwacjaUsluga
/*Rezerwacja PO
IDRezerwacja IDGosc      DataRezerwacji DataRozpoczecia DataZakonczenia IDStatus    KwotaLaczna           Uwagi
------------ ----------- -------------- --------------- --------------- ----------- --------------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1            84          2025-06-17     2025-08-03      2025-08-04      1           150,00                BRAK                                                                                                                                                                                                                                                            
2            85          2025-06-17     2025-08-21      2025-08-23      1           200,00                BRAK                                                                                                                                                                                                                                                            
3            86          2025-06-17     2025-08-25      2025-08-26      1           500,00                BRAK                                                                                                                                                                                                                                                            
4            87          2025-06-17     2025-08-24      2025-08-25      1           300,00                BRAK                                                                                                                                                                                                                                                            
5            85          2025-06-17     2025-08-27      2025-08-28      2           500,00                BRAK                                                                                                                                                                                                                                                            
6            89          2025-06-17     2025-08-08      2025-08-23      1           400,00                BRAK                                                                                                                                                                                                                                                            
7            90          2025-06-17     2025-08-04      2025-08-05      3           500,00                Uczulenie na we³ne                                                                                                                                                                                                                                              
8            91          2025-06-17     2025-08-19      2025-08-23      1           1500,00               BRAK                                                                                                                                                                                                                                                            
9            91          2025-06-17     2025-08-28      2025-08-26      2           1050,00               BRAK                                                                                                                                                                                                                                                            
12           96          2025-06-27     2025-06-27      2025-06-28      1           150,00                NULL
13           96          2025-06-27     2025-06-27      2025-06-28      1           250,00                NULL
14           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
15           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
16           96          2025-06-27     2025-06-27      2025-06-28      1           200,00                NULL
18           86          2025-12-02     2025-12-02      2025-12-06      2           250,00                Brak                                                                                                                                                                                                                                                            

(15 rows affected)

RezerwacjaUslug PO
IDRezerwacjaUsluga IDRezerwacja IDUsluga    Ilosc       CenaSprzedazy         Uwagi
------------------ ------------ ----------- ----------- --------------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1                  2            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
2                  3            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
3                  1            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
4                  4            4           5           15,00                 BRAK                                                                                                                                                                                                                                                            
5                  4            5           6           60,00                 BRAK                                                                                                                                                                                                                                                            
6                  2            2           2           200,00                BRAK                                                                                                                                                                                                                                                            
7                  9            5           2           20,00                 BRAK                                                                                                                                                                                                                                                            
8                  8            1           2           100,00                BRAK                                                                                                                                                                                                                                                            
10                 2            1           2           100,00                BRAK                                                                                                                                                                                                                                                            

(9 rows affected)