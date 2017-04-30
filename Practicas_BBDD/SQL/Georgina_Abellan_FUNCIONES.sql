--1 . Actualiza la edad a null de los alumnos en cuyo nombre aparezca la cadena "bond"

UPDATE ALUMNOS SET EDAD = NULL WHERE INSTR(NOMBRE,'BOND')>0;

--2. Plazas vacías minima y maxima y sumas de ellas.

SELECT MAX (CAPACIDAD-PLAZAS_OCUPADAS),MIN (CAPACIDAD-PLAZAS_OCUPADAS),SUM(CAPACIDAD), SUM(PLAZAS_OCUPADAS)
FROM AVIONES, VOLAR
WHERE CODIGO=COD_AVION;

-- suma de las plazas vacías en las que plazas_ocupadas este a null, y cuantas veces aparece este campo a null
SELECT SUM(CAPACIDAD), COUNT(CAPACIDAD)
FROM AVIONES, VOLAR
WHERE CODIGO=COD_AVION AND PLAZAS_OCUPADAS IS NULL;

--El minimo sale negativo, busco el error.

SELECT CODIGO, CAPACIDAD, PLAZAS_OCUPADAS FROM AVIONES, VOLAR WHERE CODIGO=COD_AVION AND CAPACIDAD<PLAZAS_OCUPADAS;

--Pongo las plazas_ocupadas al maximo al que pueden estar. 
--Uso subconsulta para traer los datos de otra tabla.

UPDATE VOLAR VO 
SET PLAZAS_OCUPADAS = (SELECT CAPACIDAD FROM AVIONES AV WHERE AV.CODIGO = VO.COD_AVION)
WHERE PLAZAS_OCUPADAS>(SELECT CAPACIDAD FROM AVIONES AV WHERE AV.CODIGO = VO.COD_AVION); 

-- 3. Numero total de matriculaciones y la fecha más antigua.

SELECT COUNT(DNI_ALU), MIN(FECHA)
FROM MATRICULAR;

-- 4. Escribir cadena de texto en DUAL

SELECT LPAD('X',205,'X') FROM DUAL;

-- 5. Insertar lo anterior en nombre de un director, cortando caracteres

-/*comprobar que aeropuertos (a través del codigo) no tienen director asignado y elegir uno.
(+) se usa en el lado contrario*/

SELECT AER.CODIGO, DIR.NOMBRE 
FROM AEROPUERTOS AER,DIRECTOR DIR WHERE AER.CODIGO = DIR.COD_AEROPUERTO(+);

/* insertar nombre de director rellenando todas las claves que no pueden ser nulas
Me invento el dni, pongo el codigo elegido y hago una select de DUAL extrayendo una subcadena de 60 bytes
que es el máximo tamaño del campo*/

INSERT INTO DIRECTOR (DNI,COD_AEROPUERTO, NOMBRE) 
VALUES
('567C','ABD', (SELECT SUBSTR(LPAD('X',205,'X'),1, 60)FROM DUAL));

--compruebo

SELECT * FROM DIRECTOR WHERE DNI='567C';

-- 6. Actualizar notas de asignaturas

--Como se que el codigo esta compuesto por una letra al inicio, puedo hacer decode con substring

UPDATE MATRICULAR SET NOTA=DECODE (SUBSTR(COD_ASIG,1,1),CHR(65), 4.9555555,
                                                        CHR(67), 5.9255555,
                                                        CHR(70), 8.3453634,
                                                        9.3323423);
                                                        
--En caso de no conocer si existen letras, lo hago así

UPDATE MATRICULAR SET NOTA=4.9555555 WHERE INSTR(COD_ASIG,CHR(65))>0;
UPDATE MATRICULAR SET NOTA=5.9255555 WHERE INSTR(COD_ASIG,CHR(67))>0;
UPDATE MATRICULAR SET NOTA=8.3453634 WHERE INSTR(COD_ASIG,CHR(70))>0;
UPDATE MATRICULAR SET NOTA=9.3323423 WHERE INSTR(COD_ASIG,CHR(65))=0 
AND INSTR(COD_ASIG,CHR(67))=0 AND INSTR(COD_ASIG,CHR(70))=0;

--7. Consulta de notas redondeadas y truncadas

SELECT ROUND(NOTA), ROUND(NOTA,2), ROUND(NOTA,3), -- ROUND REDONDEA EL ULTIMO DECIMAL RESPECTO AL SIGUIENTE
TRUNC (NOTA), TRUNC(NOTA,2), TRUNC(NOTA,3)        -- TRUNC CORTA SIN REDONDEAR
FROM MATRICULAR;

--8. Sacar modelos de 4 formas distintas.

SELECT UPPER(MODELO), LOWER(MODELO), INITCAP(MODELO), MODELO
FROM AVIONES;

--9. Insertar DIRECTORES.

--Buscar aeropuertos sin director, ya que es campo no nulo, para elegir codigos sin director asociado.

SELECT AER.CODIGO, DIR.NOMBRE 
FROM AEROPUERTOS AER,DIRECTOR DIR WHERE AER.CODIGO = DIR.COD_AEROPUERTO(+);

-- caso a. Añadir cadena a la izquierda

INSERT INTO DIRECTOR (DNI, COD_AEROPUERTO, NOMBRE)
VALUES
('90', 'ABE', LPAD('Tengo haches a la izquierda',32,'H'));

-- caso b. Añadir cadena a la derecha

INSERT INTO DIRECTOR (DNI, COD_AEROPUERTO, NOMBRE)
VALUES
('95', 'ABJ', RPAD('Tengo haches a la derecha',30,'H'));

-- caso c. insertar director sacado de una select de matricular (reeplazar 'bond' por código ASCII).

INSERT INTO DIRECTOR (DNI, COD_AEROPUERTO, NOMBRE)
VALUES
('100', 'ABL', REPLACE ((SELECT DISTINCT NOMBRE FROM MOD_ALUMNOS.ALUMNOS WHERE NOMBRE='JAMES BOND'),'BOND',ASCII('A'))); --DISTINCT porque hay varios James Bond, que solo me devuelva una fila.

--caso d. Rellenar DNI con ceros hasta completar 9 digitos.

--Sabiendo que hay que usar group by, Encotrar dos dni que al rellenarse de ceros queden igual.

SELECT LPAD(DNI,9,'0'),COUNT(*) FROM DIRECTOR GROUP BY LPAD(DNI,9,'0') HAVING COUNT(*)>1;

-- Sabiendo el dni, lo busco para saber cuantos ceros tiene realmente y poder actualizarlo

SELECT DNI FROM DIRECTOR WHERE DNI LIKE '%111J';

UPDATE DIRECTOR SET DNI='21212121X', DNI_CONTR='21212121X' WHERE DNI='00000111J';

-- AÑADE CEROS A TODOS LOS DNI.

UPDATE DIRECTOR SET DNI=LPAD(DNI,9,'0'), DNI_CONTR=LPAD(DNI_CONTR,9,'0') WHERE LENGTH(DNI)<9 ;

--caso e. Borrar las haches de los dos primeros casos.

UPDATE DIRECTOR SET NOMBRE = REPLACE (NOMBRE,'H') WHERE DNI='90' OR DNI='95';

--10. Rellenar los null de las tablas alumnos y asignaturas

UPDATE ALUMNOS SET NOMBRE=NVL(NOMBRE, 'CACACHIP');
UPDATE ALUMNOS SET TELEFONO=NVL(TELEFONO,'0');
UPDATE ALUMNOS SET PAIS=NVL(PAIS,'DESCONOCIDO');
UPDATE ASIGNATURAS SET NOMBRE =NVL(NOMBRE,'DESCONOCIDO');

--11. Conversiones

--caso a; SACAR AÑOS, MESES Y DIAS DESDE LA FECHA DE MATRICULACIÓN HASTA HOY

SELECT TO_NUMBER(TO_CHAR(FECHA,'YYYYMMDD'),'99999999') FROM MATRICULAR; --Convertir los tipos de dato

--Pero me ha parecido mas sencillo hacerlo asi.

SELECT 
--AÑOS. Cojo la fecha truncada, hago months_between con la fecha de matriculación y divido /12 . Trunc para quitar decimales
''||TRUNC((TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), FECHA)))/12)||' Años',

--MESES. Months_betwwen entre fecha matriculacion y la de hoy. Trunc para quitar decimales y el que me de 12 meses reemplazo por 0 (porque es 1 año)
''||REPLACE(TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), FECHA)),12,0)||' Meses', 

--DIAS. Cojo el resultado de meses y me quedo con 0 enteros y dos decimales (para eso hago la resta), y multiplico por 30
''||TRUNC((TRUNC((MONTHS_BETWEEN(TRUNC(SYSDATE), FECHA)),2) - (TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), FECHA))))*30)||' Días' 
FROM MATRICULAR;

--caso b, ACTUALIZAR 3 FECHAS CON FORMATOS DISTINTOS

UPDATE MATRICULAR SET FECHA=TO_DATE('05/04/2014', 'DD/MM/YYYY') WHERE DNI_ALU='657I';
UPDATE MATRICULAR SET FECHA=TO_DATE('2014/12/24', 'YYYY/MM/DD') WHERE DNI_ALU='390U';
UPDATE MATRICULAR SET FECHA=TO_DATE('19/06/16', 'DD/MM/YY') WHERE DNI_ALU='988R';

--12. Condicionales

--Apartado a, actualizacion de paises

UPDATE ALUMNOS SET PAIS= DECODE(EDAD,18,'ESPAÑA',
                                     20,'FRANCIA',
                                     25,'ALEMANIA',
                                     30,'USA',
                                     'ARGENTINA');
                                     
--Apartado b, decir si numero de vuelo es par o impar

SELECT NUM_VUELO, DECODE (SUBSTR(NUM_VUELO,-1,1),0,'PAR',
                                                 2,'PAR',
                                                 4,'PAR',
                                                 6,'PAR',
                                                 8,'PAR',
                                                 1,'IMPAR',
                                                 3,'IMPAR',
                                                 5,'IMPAR',
                                                 7,'IMPAR',
                                                 9,'IMPAR',
                                                   'IMPOSIBLE') FROM VOLAR;
                                                   
-- 13. Crear secuencia

CREATE SEQUENCE SEQ_NUMERICA; -- POR DEFECTO
/*START WITH 1
INCREMENT BY 1
MAXVALUE 999999
MINVALUE 1;*/

--14. Crear campo ID NUMBER en alumnos

ALTER TABLE ALUMNOS ADD ID NUMBER;

--15. Insertar 10 alumnos con la secuencia 

INSERT INTO ALUMNOS (DNI,NOMBRE,EDAD,ID) VALUES('458O','BETELGUEUSE', 18, SEQ_NUMERICA.NEXTVAL);
INSERT INTO ALUMNOS (DNI,NOMBRE,EDAD,ID) VALUES('673G','SIRIO',27,SEQ_NUMERICA.NEXTVAL);
INSERT INTO ALUMNOS (DNI,NOMBRE,EDAD,ID) VALUES('892A','CAPELLA', 39, SEQ_NUMERICA.NEXTVAL);
INSERT INTO ALUMNOS (DNI,NOMBRE,EDAD,ID) VALUES('910M','VEGA',105,SEQ_NUMERICA.NEXTVAL);
INSERT INTO ALUMNOS (DNI,NOMBRE,EDAD,ID) VALUES('061B','ALDEBARAN',36,SEQ_NUMERICA.NEXTVAL);
INSERT INTO ALUMNOS (DNI,NOMBRE,EDAD,ID) VALUES('001H','BELLATRIX',30,SEQ_NUMERICA.NEXTVAL);
INSERT INTO ALUMNOS (DNI,NOMBRE,EDAD,ID) VALUES('912M','SPICA',23,SEQ_NUMERICA.NEXTVAL);
INSERT INTO ALUMNOS (DNI,NOMBRE,EDAD,ID) VALUES('732E','ALTAIR',46,SEQ_NUMERICA.NEXTVAL);
INSERT INTO ALUMNOS (DNI,NOMBRE,EDAD,ID) VALUES('566L','ANTARES',21,SEQ_NUMERICA.NEXTVAL);
INSERT INTO ALUMNOS (DNI,NOMBRE,EDAD,ID) VALUES('668B','JABBERWOCKY',19,SEQ_NUMERICA.NEXTVAL);


SELECT SEQ_NUMERICA.CURRVAL FROM DUAL; -- comprobar en qué valor se ha quedado la secuencia.