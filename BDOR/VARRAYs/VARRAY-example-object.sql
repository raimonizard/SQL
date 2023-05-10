CREATE OR REPLACE TYPE v_llistat_caracters AS VARRAY(5) OF VARCHAR2(20);

DECLARE
	llista v_llistat_caracters;
BEGIN
	llista := NEW v_llistat_caracters('Carla','Ramon'0);
	DBMS_OUTPUT.PUT_LINE(llista(2));
	llista(3) := 'Hola';
END;