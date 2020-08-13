create DATABASE lista1;
/* 
1. ID albumu- zmienna TINYINT
		wyjaśnienie: mamy tylko 3 rekordy
	nazwa albumu- zmienna VARCHAR
		wyjaśnienie- przechowuje ciąg znaków do długości podanej w nawiasie, przechowywane będą słowa o różnej długości 
	data wydania- zmienna DATE
		wyjaśnienie- ta zmienna służy do przechowywania dat
	styl- zmienna VARCHAR
		wyjaśnienie: tak samo jak w przypadku nazy albumu
	artysta- zmienna VARCHAR
		wyjaśnienie: jw.
    
    
    */
    
    drop table albumy_CD;
USE lista1;
  CREATE TABLE albumy_CD (
    id_albumu TINYINT AUTO_INCREMENT PRIMARY KEY,
    nazwa_albumu VARCHAR(30),
    data_wydania DATE,
    styl VARCHAR(30),
    artysta VARCHAR(30)
);
    
    INSERT INTO albumy_CD(nazwa_albumu, data_wydania, styl, artysta) VALUES ('Morze','1956-06-06', 'jazz','George Sea');
    INSERT INTO albumy_CD(nazwa_albumu, data_wydania, styl, artysta) VALUES ('Fale','1961-12-30', 'pop','Anna Wave');
    INSERT INTO albumy_CD(nazwa_albumu, data_wydania, styl, artysta) VALUES ('Piasek','2000-01-14', 'metal','Adam Sandler');
    
    SELECT * FROM albumy_CD;