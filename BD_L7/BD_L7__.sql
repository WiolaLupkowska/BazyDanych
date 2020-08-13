CREATE DATABASE klubydb;
USE klubydb;

CREATE TABLE kluby(
id VARCHAR(5) PRIMARY KEY,
nazwa varchar(45));

CREATE TABLE mistrzowie(  -- importuje sie tylko 5
id VARCHAR(10) ,
FOREIGN KEY(id) REFERENCES kluby(id),
rok INT);

CREATE TABLE sedziowie(
id VARCHAR(5) PRIMARY KEY,
imie VARCHAR(20),
nazwisko VARCHAR(20));


CREATE TABLE mecze(
mecz_ID char(4) not null primary key,
    data DATE,
    gospodarz_id char(4) not null,
    gosc_id char(4) not null,
    sedzia_id char(4) not null,
    gole_gosp int,
    gole_gosc int,
    gole_do_przerwy_gospodarz int,
    gole_do_przerwy_gosc int,
    strzaly_gospodarz int,
    strzaly_gosc int,
    strzaly_celne_gospodarz int,
    strzaly_celne_gosc int,
    faule_gospodarz int,
    faule_gosc int,
    rzuty_rozne_gospodarz int,
    rzuty_rozne_gosc int,
    zolte_kartki_gospodarz int,
    zolte_kartki_gosc int,
    czerwone_kartki_gospodarz int,
    czerwone_kartki_gosc int,
    foreign key (gospodarz_id) references kluby(id),
    foreign key (gosc_id) references kluby(id),
    foreign key (sedzia_id) references sedziowie(id));
    
    -- a
   -- moja druzyna :Everton
SELECT @kid:= (select id from kluby where id='T16');
   
select concat(((select sum(strzaly_celne_gosc) from mecze where gosc_ID=@kid) + 
(select sum(strzaly_celne_gospodarz) from mecze where gospodarz_ID=@kid)), ":",
((select sum(strzaly_gosc) from mecze where gospodarz_ID=@kid) + 
(select sum(strzaly_gospodarz) from mecze where gosc_ID=@kid))
-((select sum(strzaly_celne_gosc) from mecze where gosc_ID=@kid) + 
(select sum(strzaly_celne_gospodarz) from mecze where gospodarz_ID=@kid))) 
as trafione_do_stracone;
   
   -- b
   SELECT @x:=(select count(gole_gosp) from mecze WHERE gospodarz_id= @kid and gole_gosp>gole_gosc)
   + (select count(gole_gosp) from mecze WHERE gosc_id= @kid and gole_gosp<gole_gosc) as wygrane;
   
   -- c
	SELECT @x:=(select count(gole_gosp) from mecze WHERE gospodarz_id= @kid and gole_gosp>gole_gosc)
   + (select count(gole_gosp) from mecze WHERE gosc_id= @kid and gole_gosp<gole_gosc) as wygrane ,
   @y:= (select count(gole_gosp) from mecze WHERE gospodarz_id= @kid and gole_gosp=gole_gosc) +
   (select count(gole_gosp) from mecze WHERE gosc_id= @kid and gole_gosp<gole_gosc) as remisy,
   @z:= @x*3+@y*1 as punkty;
   
-- d lepsze
select m.data, gospodarze.nazwa as gospodarz, goscie.nazwa as gosc,
concat(m.gole_gosp, ":", m.gole_gosc) as wyniki from mecze m
join kluby gospodarze on gospodarze.id = m.gospodarz_id
join kluby goscie on goscie.id = m.gosc_id
where m.gosc_id = @kid or m.gospodarz_id =@kid
order by m.data;

-- e
select m.data, gospodarze.nazwa as gospodarz, goscie.nazwa as gosc,
concat(m.gole_gosp, ":", m.gole_gosc) as wyniki, s.imie as sedzia from mecze m
join kluby gospodarze on gospodarze.id = m.gospodarz_id
join kluby goscie on goscie.id = m.gosc_id
join sedziowie s on m.sedzia_id=s.id
where m.gosc_id = @kid or m.gospodarz_id =@kid
order by m.data;
 
 -- f 
 select @x:=(select count(mecz_ID) from mecze where (gospodarz_id=@kid 
 and (gole_do_przerwy_gospodarz<gole_do_przerwy_gosc) 
 and(gole_gosp>=gole_gosc))) as moja_drużyna_gospodarzem,
 @y:= (select count(mecz_ID) from mecze where (gosc_id=@kid and (gole_do_przerwy_gosc<gole_do_przerwy_gospodarz) 
 and(gole_gosc>=gole_gosp))) as moja_druzyna_gosciem,
 @z:=@x+@y;

-- g
select @x:=((select sum(strzaly_gospodarz) from mecze where gospodarz_id=@kid) + 
(select sum(strzaly_gosc) from mecze where gosc_id=@kid)) as strzaly,
@y:=((select sum(strzaly_celne_gospodarz) from mecze where gospodarz_id=@kid) + 
(select sum(strzaly_celne_gosc) from mecze where gosc_id=@kid)) as celne,
@z:=@y/@x*100 as procentCelnych;

-- h
select sedzia.imie, sedzia.id, count(mecze.mecz_ID) as count from mecze
join sedziowie sedzia on sedzia.id=mecze.sedzia_id where gospodarz_id=@kid or gosc_id=@kid
group by sedzia.imie order by count desc;

-- i
 select (select count(mecz_ID) from mecze where gosc_id=@kid and faule_gosc>faule_gospodarz)+
(select count(mecz_ID) from mecze where gospodarz_id=@kid and faule_gospodarz>faule_gosc) as bardziejBrutalneMecze;
 
-- j
 select count(id) from mistrzowie where id=@kid and (rok>2000 and rok<2016);
 
 
 -- ----------------------------------------------------------2
 -- a
 select count(mistrzowie.id) as count, k.nazwa from mistrzowie
 join kluby k on k.id=mistrzowie.id
 group by nazwa order by count desc;
 
 -- b
 select datediff(max(data), min(data)) as liczbaDni from mecze;
 
 -- c
 select count(mecz_ID) from mecze where year(mecze.data)=2016 or year(mecze.data)=2015;
 
 -- d
 select @czer:= (select sum(czerwone_kartki_gospodarz) from mecze) + (select sum(czerwone_kartki_gosc) from mecze),
 @zolte:= (select sum(zolte_kartki_gospodarz) from mecze) + (select sum(zolte_kartki_gosc) from mecze),
 @mecz:= (select count(mecz_ID) from mecze);
 
 select @czer/@mecz as czerwone, @zolte/@mecz as zolte;
 
 -- e
 select @goscieWygr:= (select count(mecz_ID) from mecze where gole_gosc>gole_gosp) as goscieWygrana,
 @gospWygr:= (select count(mecz_ID) from mecze where gole_gosp>gole_gosc) as gospodarzeWygrana;
 



