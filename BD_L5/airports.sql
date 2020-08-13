use airportdb;
drop table airports;
CREATE TABLE  airports (
  kodICAO VARCHAR(4) NOT NULL PRIMARY KEY,
  kodIATA VARCHAR(3) NOT NULL,
  nazwa VARCHAR(200) NOT NULL,
  miasto VARCHAR(45) NOT NULL,
  kraj VARCHAR(45) NOT NULL,
  longitudeMinuty INT NOT NULL,
  longitudeStopnie INT NOT NULL,
  longitudeSekundy INT NOT NULL,
  kierunekLongitude VARCHAR(1) NOT NULL,
  lattitudeMinuty INT NOT NULL,
  lattitudeStopnie INT NOT NULL,
  lattitudeSekundy INT NOT NULL,
  kierunekLattitude VARCHAR(1) NOT NULL,
  położenie INT NOT NULL
  );


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

SET SQL_SAFE_UPDATES=0;
DELETE FROM airports WHERE kierunekLongitude="U" OR kierunekLattitude="U" ;
-- a)
SELECT nazwa, położenie FROM airports ORDER BY położenie DESC LIMIT 5; 
-- b)
SELECT nazwa, położenie FROM airports ORDER BY położenie ASC LIMIT 5; 
-- c)
SELECT COUNT(nazwa) FROM airports WHERE kierunekLattitude= "N";
-- d)
SELECT COUNT(nazwa) FROM airports WHERE kierunekLattitude= "S";
-- e)
SELECT COUNT(nazwa) FROM airports WHERE kierunekLongitude= "E";
-- f)
SELECT COUNT(nazwa) FROM airports WHERE kierunekLongitude= "W";
-- g)
SELECT COUNT(nazwa) FROM airports WHERE kraj = "Poland";

-- h)
SELECT COUNT(nazwa) FROM airports WHERE kierunekLattitude IN ("N","S") AND longitudeStopnie<26 
OR  kierunekLattitude IN ("N","S") AND longitudeStopnie = 26 AND longitudeMinuty < 23
OR longitudeStopnie = 26 AND longitudeMinuty = 23 AND longitudeSekundy<16;

-- i)
SELECT kraj, nazwa, longitudeStopnie, longitudeMinuty FROM airports
WHERE longitudeStopnie BETWEEN 67 and 90 
OR  longitudeStopnie = 66 AND longitudeMinuty > 34 
ORDER BY kraj DESC; 

-- j)
SELECT kraj, COUNT(nazwa) AS ilosc FROM airports GROUP BY kraj ORDER BY COUNT(kraj) DESC LIMIT 5; -- ????????jak zrobic rosnaco

-- k)
SELECT kraj, COUNT(nazwa) AS ilosc FROM airports GROUP BY kraj ORDER BY COUNT(kraj) ASC LIMIT 5;

-- l)
SELECT nazwa, kraj FROM airports -- rome
WHERE (longitudeStopnie BETWEEN 11 AND 13) AND (lattitudeStopnie BETWEEN 40 AND 42) ;

-- m)
 SELECT COUNT(nazwa) FROM airports WHERE kodICAO LIKE 'F%' 
 OR kodICAO LIKE 'G%'
 OR kodICAO LIKE 'H%' ;
 
 -- n)
  SELECT COUNT(nazwa) FROM airports WHERE kodICAO LIKE 'E%' OR kodICAO LIKE 'L%' ;

-- o)
 SELECT COUNT(nazwa) FROM airports WHERE kodICAO LIKE 'O%' 
 OR kodICAO LIKE 'R%' 
 OR kodICAO LIKE 'U%' 
 OR kodICAO LIKE 'L%'
 OR kodICAO LIKE 'V%'
 OR kodICAO LIKE 'W%'
 OR kodICAO LIKE 'Z%';
 
 -- p)
 SELECT nazwa, kraj FROM airports WHERE nazwa LIKE '%k_';
 
 -- r)
 SELECT nazwa, położenie FROM airports WHERE (kodICAO LIKE 'Y%' AND położenie<0) ORDER BY położenie;
SELECT nazwa, położenie FROM airports WHERE kodICAO LIKE 'Y%' order by położenie asc; -- -> zadne 
  
  -- s)
  SELECT nazwa, położenie FROM airports WHERE kodICAO LIKE'Y%' AND ( położenie BETWEEN 300 AND 500);
  
  -- t)
  SELECT DISTINCT lattitudeStopnie FROM airports WHERE kraj='Poland' AND lattitudeStopnie = (SELECT MAX(lattitudeStopnie) FROM airports WHERE kraj='Poland');
  
  -- u)
    SELECT DISTINCT lattitudeStopnie FROM airports WHERE kraj='Poland' AND lattitudeStopnie  = (SELECT MIN(lattitudeStopnie ) FROM airports WHERE kraj='Poland');
  
  
  



