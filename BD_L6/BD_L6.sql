-- 1)
SELECT @x:=ABS((SELECT longitudeStopnie FROM airports where kodICAO = "BGSF")- (SELECT longitudeStopnie FROM airports where kodICAO = "BGTL")) AS roznicaStopnie, 
@x:= @x*4 as roznicaStopnieWMinutach, 
@y:=ABS((SELECT longitudeMinuty FROM airports where kodICAO = "BGSF")- (SELECT longitudeMinuty FROM airports where KodICAO = "BGTL")) AS roznicaMinuty ,
@z:= ABS(@x+@y*1/15) AS wynik;

-- 2)
SELECT @g:=11, @m:=5, @s:=4, @t1:=MAKETIME(@g, @m, @s) as godzina1, 
@godziny:=@z/60 as pelneGodziny, @minuty:=@m-@godziny as roznicaMinut, @g2:=@g+@godziny as godzina2 , @m2:=@m+@minuty as minuty2, @t2:=MAKETIME(@g2,@m2,@s) as godzina2;

-- 3)
SELECT nazwa, JSON_OBJECTAGG(kodICAO, kodIATA) FROM airports WHERE kraj="Poland" GROUP BY nazwa;

-- 4)
SELECT concat( "LOT OD: ", (select nazwa from airports where kodICAO = "BGSF") , 
" (",  (select kodIATA from airports where kodICAO = "BGSF"), ") ",
 "  DO: " , (select nazwa from airports where kodICAO = "BGTL"),
 " (",  (select nazwa from airports where kodICAO = "BGTL"), ") ", 
 "DATA ", CURDATE())  AS bilecik;

-- 5)
SELECT concat( "LOT OD: ", (select nazwa from airports where kodICAO = "BGSF") , 
" (",  (select kodIATA from airports where kodICAO = "BGSF"), ") ",
 "  DO: " , (select nazwa from airports where kodICAO = "BGTL"),
 " (",  (select nazwa from airports where kodICAO = "BGTL"), ") ", 
 "DATA ", CURDATE()," DZIEN: ", DAYOFWEEK(CURDATE()))  AS bilecik;
 
 -- 6)
 SELECT @x:=(SELECT SUM(longitudeStopnie) FROM airports where kodIATA = "LAX" or kodIATA = "SIN") as sumaStopni, 
 @y:=(SELECT SUM(longitudeMinuty) FROM airports where kodIATA = "LAX" or kodIATA = "SIN") as sumaMinut,
 @z:=@x+@y*(1/60) as roznicaGeograficznaStopnie, @v:=@z*4 as roznicaCzasowaZegarowa;
 
SELECT DATE_ADD("2017-11-10 22:25:00", INTERVAL -@V+120 MINUTE) AS dataGodzinaWylotuWSingapurze;
SELECT DATE_ADD(DATE_ADD("2017-11-10 22:25:00", INTERVAL -@V+120 MINUTE),INTERVAL 17*60+50 MINUTE) AS dataGodzinaPrzylotuWSingapurze;

-- 7)
SELECT @x1:=(SELECT (lattitudeStopnie+lattitudeMinuty*(1/60)) FROM airports where kodIATA = "LAX") as lattitudeLAX,
 @x2:=(SELECT (lattitudeStopnie+lattitudeMinuty*(1/60)) FROM airports where kodIATA = "SIN") as lattitudeSIN,
 @y1:=(SELECT (longitudeStopnie+longitudeMinuty*(1/60)) FROM airports where kodIATA = "LAX") AS longitudeLAX,
 @y2:=(SELECT (longitudeStopnie+longitudeMinuty*(1/60)) FROM airports where kodIATA = "SIN") AS longitudeSIN,
 @w:=SQRT(POW((@x2-@x1),2) + POW((COS((@x1*PI())/180) * (@y2-@y1)),2)) * (40075.704/360) as wynik;

-- 8)
SELECT concat( kodICAO, ":", kodIATA, ":" , nazwa, ";", kraj, ":", lattitudeStopnie, ":", lattitudeMinuty, ":", lattitudeSekundy, ":", kierunekLattitude, ":", longitudeStopnie, ":", longitudeMinuty, ":", longitudeSekundy, ":", kierunekLongitude) as opis from airports WHERE kodICAO="EDDM";

-- 9)
SELECT @x:=(SELECT max(lattitudeStopnie) from airports where kierunekLattitude="N"), 
@y:=(SELECT max(lattitudeStopnie) from airports where kierunekLattitude="S"),
@z:=@x+@y;

SELECT * from airports WHERE lattitudeStopnie=(SELECT max(lattitudeStopnie) from airports where kierunekLattitude="N") 
OR lattitudeStopnie=(SELECT max(lattitudeStopnie) from airports where kierunekLattitude="S");

-- 10)
SELECT @z*111.2 as rozciagloscKM;


-- ZAD 2

USE airportdb;


DROP TABLE airports_statistics;
SET FOREIGN_KEY_CHECKS = 0;
CREATE TABLE airports_statistics(
kodICAO varchar(4) NOT NULL,
-- FOREIGN KEY (kodICAO) REFERENCES airports(kodICAO), //nie działa import przy kluzczu obcym, struktura tabeli prawidłowa (eer)
pasazerowie INT,
ladowania VARCHAR(10)
);
SELECT * FROM airports_statistics;

-- b
drop view v_icao_nazwa_ladowania_i_starty;
CREATE VIEW  v_icao_nazwa_ladowania_i_starty AS SELECT airports.kodICAO, nazwa, ladowania FROM airports 
JOIN airports_statistics s ON s.ladowania where airports.kodICAO=s.kodICAO order by s.ladowania desc ;

select * from v_icao_nazwa_ladowania_i_starty;
drop view  v_icao_nazwa_ladowania_i_starty ;

-- a
drop view v_icao_nazwa_pasazerowie;
CREATE VIEW v_icao_nazwa_pasazerowie AS SELECT airports.kodICAO, nazwa, pasazerowie FROM airports 
JOIN airports_statistics s ON s.pasazerowie where airports.kodICAO=s.kodICAO order by s.pasazerowie desc ;

select * from v_icao_nazwa_pasazerowie;

-- c
SELECT kodICAO from v_icao_nazwa_pasazerowie where kodICAO like "E%"; 
SELECT kodICAO from v_icao_nazwa_ladowania_i_starty where kodICAO like "E%";
 -- w obu sa lotniska z europy
 
 -- d
 select @x:= sum(pasazerowie) from v_icao_nazwa_pasazerowie;
 select @y:= pasazerowie from v_icao_nazwa_pasazerowie where nazwa="CAPITAL";
 select @procent:=@y/@x*100 as procentPasazerowie;
 
  select @x:= sum(ladowania) from v_icao_nazwa_ladowania_i_starty;
 select @y:= ladowania from v_icao_nazwa_ladowania_i_starty where kodICAO="KORD";
 select @procent:=@y/@x*100 as procentLadowania;
 
 -- e 
SELECT @x:=count(kodICAO) from v_icao_nazwa_pasazerowie where kodICAO like "K%";
SELECT @y:=count(kodICAO) from v_icao_nazwa_ladowania_i_starty where kodICAO like "K%";

-- f
 select @x:= sum(pasazerowie) from v_icao_nazwa_pasazerowie;
 select @y:= @x/4000000000*100 as procentPasazerow;
 
 -- g
 SELECT pasazerowie from v_icao_nazwa_pasazerowie where kodICAO like "KATL"
 -- nie ma takiego lotniska na liscie




-- KARTKOWKA
-- rozne rofmy selecta 
-- tworzenie tabel co jest kluczem
-- importowanie excela
-- SORTOWANIE ORDER BY
-- DATY, LANCUCHY CONCATY, WYCIAGNIECIE ROKU Z DATY
-- funkcje segregowalne czyli sumy srednie
-- laczenie tabel i wyswietlanie
-- widoki

 
 






