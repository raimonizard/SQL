CREATE OR REPLACE TYPE Bici AS OBJECT(
  marca VARCHAR2(30),
  model VARCHAR2(30),
  tipus VARCHAR2(20),
  es_professional NUMBER(1),
  pes FLOAT,
  preu FLOAT,
  MEMBER FUNCTION getMarca RETURN VARCHAR2,
  MEMBER FUNCTION getPreu RETURN FLOAT,
  MEMBER PROCEDURE setPreu(pPreu FLOAT),
  MEMBER PROCEDURE toString,
  CONSTRUCTOR FUNCTION Bici(pMarca VARCHAR2, pModel VARCHAR2) RETURN SELF AS RESULT
);

/

CREATE OR REPLACE TYPE BODY Bici AS
  MEMBER FUNCTION getMarca RETURN VARCHAR2 IS
  BEGIN
    RETURN SELF.marca;
  END;
  MEMBER FUNCTION getPreu RETURN FLOAT IS
  BEGIN
    RETURN SELF.preu;
  END;
  MEMBER PROCEDURE setPreu(pPreu FLOAT) IS
  BEGIN
    SELF.preu := pPreu;
  END;
  MEMBER PROCEDURE toString IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('La marca de la bici és: ' || SELF.marca || ' i el model és: ' || SELF.model);
  END;
  CONSTRUCTOR FUNCTION Bici(pMarca VARCHAR2, pModel VARCHAR2) RETURN SELF AS RESULT IS
  BEGIN
    SELF.marca := pMarca;
    SELF.model := pModel;
	RETURN ;
  END;
END;

/

DECLARE
 bici1 Bici;
 bici2 Bici;
BEGIN
 bici1 := NEW Bici('Orbea','Nose', 'BTT', 0, 10, 200);
 DBMS_OUTPUT.PUT_LINE('La marca de la bici és: ' || bici1.getMarca() || ' i el seu preu és: '|| bici1.getPreu());
 bici1.setPreu(1000);
 DBMS_OUTPUT.PUT_LINE('La marca de la bici és: ' || bici1.getMarca() || ' i el seu preu és: '|| bici1.getPreu());
 bici2 := NEW Bici('BMC', 'Alonso');
 bici2.toString();
END;
