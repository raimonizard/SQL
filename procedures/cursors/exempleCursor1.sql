USE sakila;

DELIMITER shakira
DROP PROCEDURE IF EXISTS exempleCursor1 shakira

CREATE PROCEDURE exempleCursor1()
BEGIN
	-- Variable semafor per a gestionar amb el handler per l'event final de dades
	DECLARE semafor BIT DEFAULT 0;
    -- Variables per a fer el fectch del cursor
    DECLARE vActor_id SMALLINT;
    DECLARE vFirst_Name VARCHAR(45);
    DECLARE vLast_Name VARCHAR(45);
    DECLARE vLast_Update TIMESTAMP;
    DECLARE vLastMovie SMALLINT;
    DECLARE vNumActors TINYINT DEFAULT 0;
    -- Declarem el cursor
    DECLARE curActors CURSOR FOR (SELECT actor_id, first_name, last_name, last_update FROM sakila.actor);
    -- Declarar el handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET semafor = 1;
    
    SET vLastMovie = (SELECT MAX(film_id) FROM sakila.film);
    -- Obrir cursor per executar consulta i guardar-ho en RAM
    OPEN curActors;
    loopActors: LOOP
		FETCH curActors INTO vActor_id, vFirst_Name, vLast_Name, vLast_Update;
        IF semafor = 1 THEN
			LEAVE loopActors;
		END IF;
        -- Programació de la lògica del loop del cursor
		INSERT INTO sakila.film_actor (actor_id, film_id, last_update)
        VALUES (vActor_id, vLastMovie, NOW());
        SET vNumActors = vNumActors + 1;
    END LOOP loopActors;
    CLOSE curActors;
    SELECT CONCAT('Hi havia ',vNumActors,' actors/actrius dins del cursor') Recompte;
END shakira

DELIMITER ;

CALL exempleCursor1();
