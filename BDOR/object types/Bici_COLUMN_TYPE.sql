/*
	TYPE Bici:
	Declaració dels atributs i mètodes de la classe Bici
	Tal i com es pot observar, no s'especifica nombre de dígits en els tipus de dades dels paràmetres dels mètodes.
*/
CREATE OR REPLACE TYPE Bici AS OBJECT(
    id NUMBER(4),
    marca VARCHAR2(30),
    model VARCHAR2(30),
    tipus VARCHAR2(20),
    es_professional NUMBER(1),
    pes FLOAT,
    preu FLOAT,
	-- Declarem constructor
    CONSTRUCTOR FUNCTION Bici(p_marca VARCHAR2, p_model VARCHAR2, p_pes FLOAT, p_preu FLOAT) RETURN SELF AS RESULT,
    -- MAP MEMBER FUNCTION
    MAP MEMBER FUNCTION funcioOrdenar RETURN FLOAT,
	-- Declarem funció getModel
    MEMBER FUNCTION getModel RETURN VARCHAR2,
	-- Declarem funció getPreu
    MEMBER FUNCTION getPreu RETURN FLOAT,
    -- Declarem un toString
    MEMBER PROCEDURE toString,
	-- Declarem procediment setPreu
    MEMBER PROCEDURE setPreu(p_preu FLOAT),
    -- STATIC PROCEDURE
    STATIC FUNCTION sumaValors(a INT, b INT) RETURN INT
    );
	
/* 
	Aquesta barra permet executar més d'un bloc de codi
	Ens mostra un error de 'Unsupported Command' però no cal donar-li importància.
*/
/
	
/*
	TYPE BODY Bici:
	Definició dels constructors, funcions i mètodes declarats en el TYPE anterior.
*/
CREATE OR REPLACE TYPE BODY Bici AS
	-- Definim constructor amb dos paràmetres concrets
	CONSTRUCTOR FUNCTION Bici (p_marca VARCHAR2, p_model VARCHAR2, p_pes FLOAT, p_preu FLOAT) RETURN SELF AS RESULT IS
		BEGIN
			SELF.marca := p_marca;
			SELF.model := p_model;
			RETURN ;
		END;
	-- Definició MAP MEMBER FUNCTION
	MAP MEMBER FUNCTION funcioOrdenar RETURN FLOAT IS
	    BEGIN
	        IF SELF.Preu IS NULL OR SELF.Pes IS NULL THEN
	            RETURN 0;
            ELSE
	            RETURN SELF.Preu / SELF.Pes;
            END IF;
	    END;
	-- Definim els getters
	MEMBER FUNCTION getModel RETURN VARCHAR2 IS
		BEGIN
			RETURN SELF.model;
		END;
	MEMBER FUNCTION getPreu RETURN FLOAT IS
		BEGIN
			RETURN SELF.preu;
		END;
	-- Definim toString
	MEMBER PROCEDURE toString IS
	    BEGIN
	        DBMS_OUTPUT.PUT_LINE('La bicicleta és de la marca: '||SELF.marca||' i el seu model és: '||SELF.model);
	    END;
	-- Definim els setters
	MEMBER PROCEDURE setPreu(p_preu FLOAT) IS
		BEGIN
			SELF.preu := p_preu;
		END;
	STATIC FUNCTION sumaValors(a INT, b INT) RETURN INT IS
	    BEGIN
	        RETURN a + b;
	    END;
END;

/* 
	Aquesta barra permet executar més d'un bloc de codi
	Ens mostra un error de 'Unsupported Command' però no cal donar-li importància.
*/
/

-- DROP TABLE bicicletes;

-- Creem una taula amb una columna de tipus complex (Bici)    :
CREATE TABLE bicicletes(
    bicicleta Bici,
    nomClient VARCHAR2(40)
);

-- Comprovem que no hi ha dades:	
SELECT *
FROM bicicletes;
	
-- Inserim una fila a la taula	
INSERT INTO bicicletes VALUES
(new Bici(1, 'Canyon', 'Ultimate SL CF', 'Road', 1, 7.5, 2400),'Raimon');

DECLARE
    bici_tmp Bici;
BEGIN
    -- Comprovem que hi ha una fila, però que el valor de la columna 1 no sap com imprimir-lo.
    SELECT bicicleta
    INTO bici_tmp
    FROM bicicletes;
    bici_tmp.toString();

END;