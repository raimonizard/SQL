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
	-- Declarem procediment setPreu
    MEMBER PROCEDURE setPreu(p_preu FLOAT)
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
			SELF.pes := p_pes;
			SELF.preu := p_preu;
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
	-- Definim els setters		
	MEMBER PROCEDURE setPreu(p_preu FLOAT) IS
		BEGIN
			SELF.preu := p_preu;
		END;
END;

/* 
	Aquesta barra permet executar més d'un bloc de codi
	Ens mostra un error de 'Unsupported Command' però no cal donar-li importància.
*/
/

DECLARE
	-- Declarem dos objectes de la classe Bici.
	bici_1 Bici;
	bici_2 Bici;
	-- Declarem una variable simple tipus VARCHAR2
	nom_model VARCHAR2(30);
BEGIN
	-- Inicialitzem bici_1 usant el constructor per defecte
	bici_1 := NEW Bici(1, 'Canyon', 'Ultimate SL CF', 'Road', 1, 7.5, 2400);
	-- Inicialitzem bici_2 usant el constructor fet a mida
	bici_2 := NEW Bici('Cannondale', 'Lefty 9', 8, 25);
	nom_model := bici_1.getModel();
	DBMS_OUTPUT.PUT_LINE('El model de la bici 1 és ' || nom_model || ' i el seu preu és de ' || TO_CHAR(bici_1.getPreu) || '€');
	bici_1.setPreu(2500);
    DBMS_OUTPUT.PUT_LINE('El model de la bici 1 és ' || nom_model || ' i el seu preu és de ' || TO_CHAR(bici_1.getPreu) || '€');	
	DBMS_OUTPUT.PUT_LINE('El model de la bici 2 és ' || bici_2.getModel());
	
	IF bici_1 > bici_2 THEN
	    DBMS_OUTPUT.PUT_LINE('La bici 1 és més gran que la bici 2');
    ELSE
        DBMS_OUTPUT.PUT_LINE('La bici 2 és més gran que la bici 1');
    END IF;
END;
	