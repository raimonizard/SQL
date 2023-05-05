
-- Declaració del tipus (Classe) Persona	
CREATE OR REPLACE TYPE T_Persona AS OBJECT(
	-- Atributs
	dni VARCHAR2(9),
	nom VARCHAR2(50),
	cognom1 VARCHAR2(50),
	cognom2 VARCHAR2(50),
	dataNaixement DATE,
	paisNaixement VARCHAR2(50),
	-- Declarem constructor amb certs paràmetres
	CONSTRUCTOR FUNCTION T_Persona(dni VARCHAR2) RETURN SELF AS RESULT,
	-- Declarem un segon constructor amb certs paràmetres
	CONSTRUCTOR FUNCTION T_Persona(dni VARCHAR2, nom VARCHAR2, dataNaixement DATE) RETURN SELF AS RESULT,
	-- Declarem funció toString (retorna un varchar)
	MEMBER FUNCTION toString RETURN VARCHAR2,
	-- Declarem el procediment setNom
	MEMBER PROCEDURE setNom(pnom VARCHAR2),
	-- Calcular edat i mostrar per pantalla
	MEMBER PROCEDURE calcEdat,
	-- Declarem la funció MAP per poder comparar persones segons el seu DNI
	FINAL MAP MEMBER FUNCTION compararPersones RETURN VARCHAR2 -- Aquest mètode no pot ser modificat en els tipus hereus
) NOT FINAL; -- Hem d'afegir NOT FINAL per tal de que aquest tipus pugui heretar.

/
    
-- Definició del tipus Persona
CREATE OR REPLACE TYPE BODY T_Persona AS
    /****************************/
    -- Definim codi del primer constructor
	CONSTRUCTOR FUNCTION T_Persona (dni VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		SELF.dni := dni;
		RETURN ;
	END;
	/****************************/
    -- Definim codi del segon constructor
	CONSTRUCTOR FUNCTION T_Persona (dni VARCHAR2, nom VARCHAR2, dataNaixement DATE) RETURN SELF AS RESULT IS
	BEGIN
		SELF.dni := dni;
		SELF.nom := nom;
		SELF.dataNaixement := dataNaixement;
		RETURN ;
	END;
	/****************************/
	MEMBER FUNCTION toString RETURN VARCHAR2 IS
        frase VARCHAR2(100);
    BEGIN
        frase := 'El dni de la persona és: ' || SELF.dni || ' i el seu nom és: ' || SELF.nom;
        RETURN frase;
	END;
	/****************************/
	MEMBER PROCEDURE setNom(pnom VARCHAR2) IS
	BEGIN
	    SELF.nom := pnom;
	END;
	/****************************/
	MEMBER PROCEDURE calcEdat IS
	    anys INT := 0;
	BEGIN
	    anys := EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM SELF.dataNaixement);
	    DBMS_OUTPUT.PUT_LINE('La persona ' || SELF.nom || ' té ' || anys || ' anys');
	END;
	/****************************/
	-- Definim la funció MAP per poder comparar persones segons el seu DNI
	FINAL MAP MEMBER FUNCTION compararPersones RETURN VARCHAR2 IS
	BEGIN
		RETURN SELF.dni;
	END;
	/****************************/
END;


-- Main de l'aplicació en codi PL/SQL
DECLARE
	nom VARCHAR2(50);
	dni VARCHAR2(9);
	maench T_Persona;
	guiu T_Persona;
BEGIN
	dni := '12345678J';
	DBMS_OUTPUT.PUT_LINE('La variable DNI té el valor:' || dni);
	maench := NEW T_Persona('11111111Q', 'Andreu', TO_DATE('19/12/2003','DD/MM/YYYY'));
	DBMS_OUTPUT.PUT_LINE(maench.toString());
	maench.setNom('Josep Maria');
	DBMS_OUTPUT.PUT_LINE(maench.toString());
	maench.calcEdat();
	guiu := NEW T_Persona('11111102Q', 'Marc', TO_DATE('10/12/2002','DD/MM/YYYY'));
	
	-- Usem el mètode de comparació MAP per a comparar persones
	IF guiu > maench THEN
	    DBMS_OUTPUT.PUT_LINE('En Guiu és més gran');
	ELSE
	    DBMS_OUTPUT.PUT_LINE('En Maench és més gran');
	END IF;
	
END;

-- Tipus T_Alumne que hereta de T_Persona
CREATE OR REPLACE TYPE T_Alumne UNDER T_Persona( -- Hem d'afegir la paraula clau UNDER
	curs INTEGER,
	CONSTRUCTOR FUNCTION T_Alumne(dni VARCHAR2, nom VARCHAR2, curs INTEGER) RETURN SELF AS RESULT,
	OVERRIDING MEMBER FUNCTION toString RETURN VARCHAR2 -- Sobre-escrivim el mètode toString de la classe T_Persona (OVERRIDING)
);

/

CREATE OR REPLACE TYPE BODY T_Alumne AS
	CONSTRUCTOR FUNCTION T_Alumne (dni VARCHAR2, nom VARCHAR2, curs INTEGER) RETURN SELF AS RESULT IS
	BEGIN
		SELF.dni := dni;
		SELF.nom := nom;
		SELF.curs := curs;
		RETURN ;
	END;
	OVERRIDING MEMBER FUNCTION toString RETURN VARCHAR2 IS -- La funció sobreescrita toString
	frase VARCHAR2(500);
    BEGIN
        frase := 'El dni de l''alumne és: ' || SELF.dni || ' i el seu nom és: ' || SELF.nom || ' i el seu curs ' || self.curs;
        RETURN frase;
	END;
END;

-- Bloc PL/SQL (Main)
DECLARE
    alumne1 T_Alumne;
    personeta T_Persona;
    alumne2 T_Persona; -- Declaro una T_Persona
	persona2 T_Persona;
BEGIN
    alumne1 := NEW T_Alumne('12345678P','Illanas',1);
    DBMS_OUTPUT.PUT_LINE(alumne1.toString);
    
    personeta := NEW T_Persona('12345678I');
    DBMS_OUTPUT.PUT_LINE(personeta.toString);
    
    alumne2 := NEW T_Alumne('12345680T','Rabaneda',1); -- Inicialitzo la T_Persona a través del constructor de T_Alumne
    DBMS_OUTPUT.PUT_LINE(alumne2.toString);

	IF alumne1 > alumne2 THEN
        DBMS_OUTPUT.PUT_LINE('Guanya l''Illanas');
	ELSE
        DBMS_OUTPUT.PUT_LINE('Guanya el Rabaneda i Sevilla primera división');
	END IF;
	persona2 := NEW T_Alumne('12345678P','Hector',1);
	DBMS_OUTPUT.PUT_LINE(persona2.toString);
END;

/
    
DROP TABLE personetes;

/

CREATE TABLE personetes OF T_Persona(dni primary key);

/

INSERT INTO personetes VALUES(NEW T_Persona('11111111Q', 'Héctur', TO_DATE('19/12/2003','DD/MM/YYYY')));

/

SELECT *
FROM personetes;

/

INSERT INTO personetes VALUES(NEW T_Alumne('11111112Q', 'Ramon', 1));

/

DECLARE
    ramon T_Persona;
BEGIN
	SELECT VALUE(p) INTO ramon FROM personetes p WHERE p.dni = '11111112Q';
	DBMS_OUTPUT.PUT_LINE(ramon.toString());
END;

/

-- Equivalent a instanceof de Java
SELECT * FROM personetes p WHERE VALUE(p) IS OF (T_Alumne);
    
/

-- Mostrar id i value:
SELECT object_id, object_value FROM personetes;
