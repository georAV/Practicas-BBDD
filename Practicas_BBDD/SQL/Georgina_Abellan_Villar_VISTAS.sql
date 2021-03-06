--VISTAS

/*1 VISTA SOBRE DIRECTOR, SOBRE TODOS LOS CAMPOS EXCEPTO COD_CONTR
USAR ALIAS PARA DIFERENCIAR CAMPOS*/

CREATE VIEW DIRECTOR_DATOS (NIF, AEROP, NOM, DIREC, TLF, NACIONALIDAD)
AS SELECT DNI, COD_AEROPUERTO, NOMBRE, DIRECCION, TELEFONO, PAIS
FROM DIRECTOR;

/*2 INSERT, UPDATE, DETELE SOBRE LA VISTA. COMPROBAR CAMBIOS*/

SELECT CODIGO FROM AEROPUERTOS WHERE CODIGO NOT IN (SELECT COD_AEROPUERTO FROM DIRECTOR);-- VER QUE AEROPUERTO NO TIENE CONTROLADOR.

INSERT INTO DIRECTOR_DATOS (NIF, AEROP, NOM, DIREC, TLF, NACIONALIDAD)
VALUES ('R99Y', 'KOA','KKCHUP', 'LA LUNA', 54, 'JUPITER');

SELECT * FROM DIRECTOR WHERE DNI='R99Y'; -- COMPROBAR LA TABLA DE ORIGEN.

UPDATE DIRECTOR_DATOS SET TLF='0' WHERE NIF='R99Y';
SELECT * FROM DIRECTOR WHERE DNI='R99Y'; -- COMPROBAR TABLA ORIGEN

DELETE DIRECTOR_DATOS WHERE NIF='R99Y';
SELECT * FROM DIRECTOR WHERE DNI='R99Y'; -- COMPROBAR TABLA ORIGEN

/*3 ELIMINAR LA VISTA Y VOLVERLA A CREAR COMO S�LO LECTURA, COMPROBAR QUE NO SE PUEDEN HACER CAMBIOS.
CRUZAR CON AEROPUERTOS Y COMPROBAR QUE NO ES ACTUALIZABLE*/

DROP VIEW DIRECTOR_DATOS;
CREATE  VIEW DIRECTOR_DATOS (NIF, AEROP, NOM, DIREC, TLF, NACIONALIDAD)
AS SELECT DNI, COD_AEROPUERTO, NOMBRE, DIRECCION, TELEFONO, PAIS
FROM DIRECTOR
WITH READ ONLY;

-- COMPROBAR QUE NO SE PUEDE MODIFICAR 

INSERT INTO DIRECTOR_DATOS (NIF, AEROP, NOM, DIREC, TLF, NACIONALIDAD)
VALUES ('R99Y', 'KOA','KKCHUP', 'LA LUNA', 54, 'JUPITER');

--CRUZAR VISTA CON AEROPUERTOS

CREATE OR REPLACE VIEW DIRECTOR_DATOS (NIF, AEROP, NOM, DIREC, TLF, NACIONALIDAD)
AS SELECT DNI,COD_AEROPUERTO, DI.NOMBRE, DIRECCION, TELEFONO, DI.PAIS
FROM DIRECTOR DI, AEROPUERTOS AE WHERE CODIGO=COD_AEROPUERTO;

-- COMPROBAR QUE NO SE PUEDE ACTUALIZAR

UPDATE DIRECTOR_DATOS SET TLF='0';
SELECT * FROM DIRECTOR WHERE DNI='R99Y'; -- COMRPUEBO QUE SI QUE SE HA ACTUALIZADO...

/* 4. ELIMINA VISTA Y VUELVELA A CREAR CON TODOS LOS CAMPOS
Y SOLO CON DIRECTORES QUE NO TENGAN CONTROLADORES*/

DROP VIEW DIRECTOR_DATOS;

CREATE VIEW DIRECTOR_DATOS (NIF, AEROP, NOM, DIREC, TLF, NACIONALIDAD, NIF_CONTR)
AS SELECT DNI, COD_AEROPUERTO, NOMBRE, DIRECCION, TELEFONO, PAIS, DNI_CONTR
FROM DIRECTOR WHERE DNI_CONTR IS NULL;

SELECT * FROM DIRECTOR WHERE DNI_CONTR IS NULL; --ELEGIR UN DNI SIN CONTROLADOR
UPDATE DIRECTOR_DATOS SET NIF_CONTR='R99Y' WHERE NIF='11111111Z'; -- INSERTAR CONTROLADOR Y COMPROBAR LA VISTA

/* 5. ELIMINAR VISTA Y CREARLA CON WITH CHECK OPTION
COMPROBAR QUE NO SE PUEDE ACTUALIZAR*/

DROP VIEW DIRECTOR_DATOS;

CREATE VIEW DIRECTOR_DATOS (NIF, AEROP, NOM, DIREC, TLF, NACIONALIDAD, NIF_CONTR)
AS SELECT *
FROM DIRECTOR WHERE DNI_CONTR IS NULL
WITH CHECK OPTION;

UPDATE DIRECTOR_DATOS SET NIF_CONTR='R99Y' WHERE NIF='22222222Y'; -- COMPROBAR

/*6. CREAR VISTA SOBRE TMP_DIRECTORES*/

CREATE FORCE VIEW VISTA_TMP AS SELECT * FROM TMP_DIRECTORES; -- CREAR VISTA 
CREATE TABLE TMP_DIRECTORES AS SELECT * FROM DIRECTOR;       -- CREAR TABLA

SELECT * FROM VISTA_TMP; -- COMPROBAR 


/*7. HACER VISTA DEL EJERCICIO 5 DE CONJUNTOS*/

CREATE VIEW EJERCICIO_5 
AS SELECT * FROM DIRECTOR 
WHERE COD_AEROPUERTO IN (SELECT CODIGO FROM AEROPUERTOS WHERE PAIS= 'ESPA�A') 
AND DNI_CONTR IS NULL 
UNION ALL
SELECT * FROM DIRECTOR
WHERE PAIS= 'USA'
AND COD_AEROPUERTO IN 
(SELECT AE.CODIGO FROM AEROPUERTOS AE, PROGRAMA_VUELO PR, VOLAR VO 
WHERE AE.CODIGO=PR.COD_AERO_DESPEGAR AND PR.NUM_VUELO=VO.NUM_VUELO  
GROUP BY AE.CODIGO,PR.COD_AERO_DESPEGAR HAVING COUNT(*)<3) 
UNION ALL
SELECT * FROM DIRECTOR
WHERE NOMBRE LIKE '__E' OR NOMBRE LIKE '__e'; 

/*8. LA VISTA NO ES ACTUALIZABLE PORQUE HAY CRUCE ENTRE TABLAS
ME PARECE IGUAL DE FACIL HACERLO SIN VISTA Y CON ELLA PORQUE YA TENGO EL EJERCICIO HECHO
PERO SI PODEMOS GUARDAR LA VISTA DE UNA SELECT GRANDE Y HACER CONSULTAS SOBRE ELLA ES MUY VENTAJOSO*/

-- PAIS QUE M�S DIRECTORES TIENE QUE CUMPLEN CON EL EJERCICIO 5 USANDO VISTA.

SELECT PAIS
FROM EJERCICIO_5
GROUP BY PAIS
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM EJERCICIO_5 GROUP BY PAIS);

-- PAIS QUE M�S DIRECTORES TIENE QUE CUMPLEN CON EL EJERCICIO 5 SIN USAR VISTA.

SELECT PAIS FROM
(SELECT * FROM DIRECTOR 
WHERE COD_AEROPUERTO IN (SELECT CODIGO FROM AEROPUERTOS WHERE PAIS= 'ESPA�A') 
AND DNI_CONTR IS NULL 
UNION ALL
SELECT * FROM DIRECTOR
WHERE PAIS= 'USA' 
AND COD_AEROPUERTO IN 
(SELECT AE.CODIGO FROM AEROPUERTOS AE, PROGRAMA_VUELO PR, VOLAR VO  
WHERE AE.CODIGO=PR.COD_AERO_DESPEGAR AND PR.NUM_VUELO=VO.NUM_VUELO  
GROUP BY AE.CODIGO,PR.COD_AERO_DESPEGAR HAVING COUNT(*)<3) 
UNION ALL
SELECT * FROM DIRECTOR
WHERE NOMBRE LIKE '__E' OR NOMBRE LIKE '__e') 
GROUP BY PAIS
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM 
                  (SELECT * FROM DIRECTOR 
                  WHERE COD_AEROPUERTO IN (SELECT CODIGO FROM AEROPUERTOS WHERE PAIS= 'ESPA�A') 
                  AND DNI_CONTR IS NULL 
                  UNION ALL
                  SELECT * FROM DIRECTOR
                  WHERE PAIS= 'USA' 
                  AND COD_AEROPUERTO IN 
                  (SELECT AE.CODIGO FROM AEROPUERTOS AE, PROGRAMA_VUELO PR, VOLAR VO  
                  WHERE AE.CODIGO=PR.COD_AERO_DESPEGAR AND PR.NUM_VUELO=VO.NUM_VUELO  
                  GROUP BY AE.CODIGO,PR.COD_AERO_DESPEGAR HAVING COUNT(*)<3) 
                  UNION ALL
                  SELECT * FROM DIRECTOR
                  WHERE NOMBRE LIKE '__E' OR NOMBRE LIKE '__e')
                  GROUP BY PAIS);


