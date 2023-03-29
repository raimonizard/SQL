USE mymovies;
/*
1. Crea un trigger a la base de dades mymovies que, abans d'un update sobre la taula movies, 
guardi les dades originals que hi havia a la taula en una taula nova. 
Aquesta taula nova, és dirà movies_version i contindrà les mateixes columnes que la taula 
original més una columna de tipus datetime per a guardar l'hora de l'update i també una altra 
columna per a especificar la versió del canvi.
És a dir, si hi ha hagut tres canvis de nom sobre la taula movies, la taula movies_version 
tindrà tres files per a la mateixa fila i l'id de la versió anirà de 1 a 3. 
Pensa com resoldràs la situació de saber a quin número de versió estem.
*/
/****************************************************
			INIT
****************************************************/
	USE mymovies;
    
    DROP TABLE IF EXISTS mymovies.movies_version;

	CREATE TABLE mymovies.movies_version AS 
		SELECT m.*, NOW() as update_date, 1 as update_version
		FROM mymovies.movies m;

	ALTER TABLE mymovies.movies_version
	ADD PRIMARY KEY (id, update_version);
    
	ALTER TABLE movies_version MODIFY update_date DATETIME DEFAULT NOW();        

	SELECT *
	FROM mymovies.movies_version;

	-- Test
    INSERT INTO mymovies.movies_version(id,update_version)
    VALUES(1,2);
    
	SELECT *
	FROM mymovies.movies_version;
    
    DELETE FROM movies_version
    WHERE id = 1 and update_version = 2;
    
/****************************************************
			TRIGGER
****************************************************/
	DELIMITER %%
	DROP TRIGGER IF EXISTS mymovies.beforeUpdateMovie %%

	CREATE TRIGGER mymovies.beforeUpdateMovie BEFORE UPDATE ON movies
	FOR EACH ROW
	BEGIN
		DECLARE v_update_version INT DEFAULT 0;
		
		SELECT IFNULL(MAX(update_version),0)
		INTO v_update_version
		FROM mymovies.movies_version
		WHERE id = OLD.id;
		
		INSERT INTO mymovies.movies_version(id, name, year, stockUnits, price, update_date, update_version)
		VALUES(OLD.id, NEW.name, NEW.year, NEW.stockUnits, NEW.price, NOW(), v_update_version + 1);
		
	END %%

	DELIMITER ;

/****************************************************
			TEST TRIGGER
****************************************************/
	SELECT *
    FROM mymovies.movies;
    
    UPDATE mymovies.movies
	SET name = 'Resacón en las vegas', year = 2020
	WHERE id = 1;

	SELECT *
	FROM mymovies.movies_version
	WHERE id = 1;