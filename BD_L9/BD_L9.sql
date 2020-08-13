create database nagrody;
use nagrody;

create table aktorzy_aktorki(
id varchar(10) primary key,
name varchar(100)
);

create table nagrody(
id_nagrody varchar (10) primary key,
rok int,
id_ak varchar(10) ,
wiek int,
nazwa_filmu varchar(100),
FOREIGN KEY (id_ak) REFERENCES aktorzy_aktorki(id));


drop table aktorzy_aktorki;
drop table nagrody;


create view laureaci as
select n.rok, a.name as dane,
 n.wiek, n.nazwa_filmu, substring(a.id,2,1) as plec
 from aktorzy_aktorki as a
 join nagrody as n on n.id_ak=a.id;
 
 drop view laureaci;
 
 select*from laureaci;

Delimiter $$ 
 CREATE function plec
(podajID varchar(10)) -- wejsciowe
returns varchar(1)
deterministic
begin
DECLARE x VARCHAR(1) DEFAULT (SELECT substring(aktorzy_aktorki.id,2,1) from aktorzy_aktorki where id=podajID);
return x; -- wyjsciowe
end$$
delimiter ; 
drop function if exists plec;
select plec("AF1");

-- sprawdzenia, widoki pomocnicze do zadan:
 select avg(wiek) as wiekF from nagrody where plec(id_ak)="F";
 select*from laureaci; 
 select count(dane) from laureaci where dane like "%Fonda%";
 select wiek from laureaci where plec="F" order by wiek desc limit 1 ;
 select wiek from laureaci where plec="F" order by wiek asc limit 1 ;

create view wiecejNizJeden as
SELECT dane ,COUNT(dane) as liczba FROM laureaci GROUP BY dane ORDER BY COUNT(dane) desc;
select dane, liczba from wiecejNizJeden where liczba>1;

create view ileOscarow as
SELECT rok ,COUNT(rok) FROM laureaci GROUP BY rok ORDER BY COUNT(rok) ;
drop view ileOscarow;
select*from ileOscarow;
select count(rok) from ileOscarow;

select dane, rok, nazwa_filmu from laureaci where dane ="Al Pacino" or dane ="Jack Nicholson" or dane="Anthony Hopkins";

 select :x1=(select count(plec) from laureaci where plec="F") as kobiety,:x2=(select count(plec) from laureaci where plec="M") as mezczyzni, :x3=:x1/(:x2+:x1);
 select count(plec) from laureaci where plec="M";
 
 select (select count(plec) from laureaci where plec="F")*100/((select count(plec) from laureaci where plec="F")+(select count(plec) from laureaci where plec="M"));
 
create view rozni as 
SELECT distinct dane FROM laureaci GROUP BY dane;
select count(dane) from rozni;

SELECT rok ,COUNT(rok) FROM laureaci GROUP BY rok ORDER BY COUNT(rok) ;
SELECT dane ,COUNT(dane) as liczba FROM laureaci  GROUP BY dane having COUNT(dane)>1 ORDER BY COUNT(dane) desc ;

SELECT rok ,COUNT(rok) FROM laureaci GROUP BY rok ORDER BY COUNT(rok) ;-- ????-- chce policzyc ile jest count rok

SELECT count(distinct dane) FROM laureaci where plec="F";  -- ????? -- to samo

