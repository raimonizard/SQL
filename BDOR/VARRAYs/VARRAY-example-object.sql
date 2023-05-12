/*
17. Crea un tipo para almacenar números de teléfono cuyos atributos serán:
• Código del país VARCHAR2(2)
• Código de la región VARCHAR2(3)
• Número VARCHAR2(7)
*/

CREATE OR REPLACE TYPE telefon_type AS OBJECT(
    codi_pais VARCHAR2(2),
    codi_regio VARCHAR2(3),
    numero VARCHAR2(7),
    MEMBER PROCEDURE toString
);

CREATE OR REPLACE TYPE BODY telefon_type AS
    MEMBER PROCEDURE toString IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(codi_pais || codi_regio || numero);
    END;
END;

/*
Crea un tipo de datos colección que permita almacenar 5 números de teléfono
*/
DROP TYPE telefon_array;
CREATE OR REPLACE TYPE telefon_array AS VARRAY(5) OF telefon_type;

/*
b) Crea una tabla “agenda” que permita almacenar los números de teléfono asociados a
un nombre de persona.
*/
DROP TYPE agenda_type;
CREATE OR REPLACE TYPE agenda_type AS OBJECT(
    nom VARCHAR2(20),
    cognom1 VARCHAR2(20),
    cognom2 VARCHAR2(20),
    telefons telefon_array
);

/*
c) Inserta valores en la tabla para distintas personas.
d) Modifica uno de los números de teléfono asociados a una persona que exista en la
agenda
e) Muestra por consola los números de teléfono completos de una de las personas que
hayas insertado en la tabla
*/
DROP TABLE agenda_taula;
CREATE TABLE agenda_taula OF agenda_type(PRIMARY KEY (nom, cognom1, cognom2));

SELECT nom, cognom1, cognom2, telefons
FROM agenda_taula
WHERE cognom2 = 'Illanas';

INSERT INTO agenda_taula VALUES('Victor', 'Rabaneda', 'Illanas', NEW telefon_array(
                                                   NEW telefon_type('34', '93', '1234567')
                                                ,  NEW telefon_type('34', '91', '1234567')
                                                ,  NEW telefon_type('34', '91', '4234567')
                                                )
                                );

DECLARE
    telefons telefon_array;
    text VARCHAR(100);
BEGIN
    SELECT telf.telefons
    INTO telefons
    FROM agenda_taula telf
    WHERE telf.cognom2='Illanas';

    FOR i IN 1..telefons.COUNT LOOP
        text := text||telefons(i).codi_pais||'-'||telefons(i).codi_regio||'-'||telefons(i).numero||chr(10);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(text);
END;