CREATE OR REPLACE TYPE noticia_t AS OBJECT(
  codigo NUMBER,
  fecha DATE,
  num_dias_publicado NUMBER,
  texto VARCHAR2(500),
  ORDER MEMBER FUNCTION compararFechaPub(n noticia_t) RETURN NUMBER
);

/

CREATE OR REPLACE TYPE BODY noticia_t AS
  ORDER MEMBER FUNCTION compararFechaPub(n noticia_t) RETURN NUMBER IS
  BEGIN
    RETURN n.fecha - SELF.fecha;
  END;
END;

/

DECLARE
  n1 noticia_t;
  n2 noticia_t;
BEGIN
  n1 := noticia_t(1,'01-MAR-2020',2,'test');
  n2 := noticia_t(1,'02-MAR-2020',3,'test');
  DBMS_OUTPUT.PUT_LINE('La primera noticia se publicó: '
  ||TO_CHAR(n1.compararFechaPub(n2))||' dias antes');
END;