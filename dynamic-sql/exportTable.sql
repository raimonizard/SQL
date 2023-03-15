USE northwind;

DELIMITER ++
DROP PROCEDURE IF EXISTS exportTable ++

CREATE PROCEDURE exportTable(IN nomtaula VARCHAR(30))
BEGIN
	SET @nomFitxer = REPLACE(REPLACE(CONCAT(nomtaula,"_",REPLACE(now(),":",""),".csv"),' ','_'),'-','');
	SET @sintaxi = CONCAT("SELECT *
							FROM ",nomtaula," ","
							INTO OUTFILE '",@nomFitxer,"'",
							" CHARACTER SET utf8mb4
							FIELDS TERMINATED BY ';'
							OPTIONALLY ENCLOSED BY '""'
							LINES TERMINATED BY '\\n'; ");
    
    PREPARE instruccio FROM @sintaxi;
    EXECUTE instruccio;
    DEALLOCATE PREPARE instruccio;
END ++

DELIMITER ;

CALL exportTable('products');