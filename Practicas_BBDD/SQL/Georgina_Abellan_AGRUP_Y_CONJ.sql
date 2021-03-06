--AGRUPACIONES.

--1. Edad y cantidad de edad
/*sobre la agrupaci�n de distintas edades, mostrar edad y cuantos ALUMNOS hay en cada agrupaci�n*/

SELECT EDAD, COUNT(*) CANTIDAD FROM ALUMNOS GROUP BY EDAD; 

--2. Nombres de alumnos que se repitan
/* Sobre agrupaci�n de nombres, cuales son los que se repiten*/

SELECT NOMBRE FROM ALUMNOS GROUP BY NOMBRE HAVING COUNT(*)>1;

--3. Cuantos aviones de cada tipo hay
/* Sobre agrupacion de modelo, cuantos aviones hay (contar las veces que se repite modelo)*/

SELECT MODELO, COUNT(*) CANTIDAD FROM AVIONES GROUP BY MODELO;

--4. Sacar nombre aeropuertos y cuantos aviones han volado a ellos como destino.
/* Sobre agrupacion de aeropuertos, saber cuantos aviones (contando los numeros de vuelo) vuelan
hacia ellos como destino*/

SELECT NOMBRE, COUNT(NUM_VUELO)  
FROM PROGRAMA_VUELO, AEROPUERTOS
WHERE COD_AERO_ATERRIZAR=CODIGO
GROUP BY NOMBRE ORDER BY NOMBRE; 

--5. Fechas donde hayan volado mas de 5 aviones
/*Sobre agrupacion de fecha, cuales de ellas se repiten m�s de 5 de veces*/

SELECT FECHA_VUELO, COUNT(*) CANT_AVIONES
FROM VOLAR
GROUP BY FECHA_VUELO    
HAVING COUNT(*)>5;      

--6.Primera fecha en la que se matriculo un alumno de cada asignatura
/*Sobre agrupacion de codigos, cual es la minima fecha en cada uno*/

SELECT MIN(FECHA), COD_ASIG         -- QUE QUIERO SABER : MINIMA FECHA
FROM MATRICULAR GROUP BY COD_ASIG;  -- AGRUPADA POR REPETICION DE ASIGNATURAS

--SI QUIERO QUE EN VEZ DEL CODIGO SAQUE EL NOMBRE DE LA ASINATURA

SELECT MIN(FECHA), NOMBRE
FROM MATRICULAR, ASIGNATURAS
WHERE COD_ASIG=COD
GROUP BY NOMBRE;

--7. ALUMNOS QUE CONTENGAN A Y QUE LA SUMA DE SUS EDADES SEA MAYOR QUE 30 O MENOR QUE 20 
/*Sobre agrupacion de alumnos que contengan A,
sacar los alumnos que sumen >30 y <20 en sus edades.*/

SELECT NOMBRE, SUM(EDAD) SUMA FROM ALUMNOS  
WHERE NOMBRE LIKE '%A%'
GROUP BY NOMBRE
HAVING SUM(EDAD)>30 OR SUM(EDAD)<20;

--8. DNI , NOMBRE ALUMNOS Y FECHA ULTIMA MATRICULACION SI ES SUPERIOR A 1/1/2014
--Y MEDIA DE SUS NOTAS MAYOR A 5

SELECT DNI, NOMBRE, MAX(FECHA)
FROM ALUMNOS, MATRICULAR
WHERE DNI=DNI_ALU
GROUP BY DNI, NOMBRE, FECHA
HAVING MAX(FECHA)>'01/01/2014' AND AVG(NOTA)>5;

--9. Numeros de vuelo que tengan mas de 3 escalas y sean vuelos de entre semana.

SELECT TE.NUM_VUELO, COUNT(*) ESCALAS
FROM TENER_ESCALA TE, PROGRAMA_VUELO PR
WHERE TE.NUM_VUELO=PR.NUM_VUELO 
AND INSTR(PR.DIAS_SEMANA,'DOMINGO')=0 AND INSTR(PR.DIAS_SEMANA,'SABADO')=0
AND INSTR(PR.DIAS_SEMANA,',D')=0 AND INSTR(PR.DIAS_SEMANA,',S')=0
GROUP BY TE.NUM_VUELO
HAVING COUNT(*)>3;

--10. Aeropuertos que tengan mas de 5 vuelos como salida y 7 com odestino.
/*Sobre la agrupaci�n de aeropuertos , contar despegues y contar aterrizajes
mientras sean mayor a 5 y mayor a 7 respectivamente*/

SELECT NOMBRE, COUNT(COD_AERO_DESPEGAR), COUNT (COD_AERO_ATERRIZAR)
FROM AEROPUERTOS, PROGRAMA_VUELO
WHERE CODIGO=COD_AERO_DESPEGAR OR CODIGO=COD_AERO_ATERRIZAR
GROUP BY NOMBRE
HAVING COUNT(COD_AERO_DESPEGAR)>5 AND COUNT(COD_AERO_ATERRIZAR)>7; 


-- CONJUNTOS

--  1. ALUMNOS Y ASIGNATURAS CON EL MISMO NUMERO DE CARACTERES EN SUS NOMBRES.

SELECT NOMBRE, LENGTH(NOMBRE) FROM ALUMNOS
WHERE LENGTH(NOMBRE) IN (SELECT LENGTH(NOMBRE) FROM ASIGNATURAS) 
UNION
SELECT NOMBRE, LENGTH(NOMBRE) FROM ASIGNATURAS
WHERE LENGTH(NOMBRE) IN (SELECT LENGTH(NOMBRE) FROM ALUMNOS);

-- 2. ALUMNOS MAYOR DE EDAD MENOS LOS QUE NO SEAN DE ESPA�A

SELECT NOMBRE FROM ALUMNOS WHERE EDAD >=18
MINUS
SELECT NOMBRE FROM ALUMNOS WHERE PAIS!='ESPA�A';

/*3 NOMBRE DE DIRECTORES QUE TIENEN UNA A EN SU NOMBRE
QUE SU TERCERA LETRA NO ES CONSONANTE Y SU LONGITUD ES MAYOR A 5
O QUE NO SON DE AEROPUERTOS DE ESPA�A, FRANCIA O USA.*/

SELECT NOMBRE FROM DIRECTOR WHERE NOMBRE LIKE '%A%' AND LENGTH (NOMBRE)>5 
AND (NOMBRE LIKE '__A%' OR NOMBRE LIKE '__E%' OR NOMBRE LIKE '__I%' OR NOMBRE LIKE '__O%' OR NOMBRE LIKE '__U%'
OR NOMBRE LIKE '__a%' OR NOMBRE LIKE '__e%' OR NOMBRE LIKE '__i%' OR NOMBRE LIKE '__o%' OR NOMBRE LIKE '__u%')
UNION
SELECT NOMBRE FROM DIRECTOR WHERE COD_AEROPUERTO IN 
(SELECT CODIGO FROM AEROPUERTOS WHERE PAIS NOT IN ('ESPA�A', 'FRANCIA', 'USA'));


/*4.NOMBRE DE DIRECTORES QUE TIENEN UNA A EN SU NOMBRE
QUE SU TERCERA LETRA ES CONSONANTE Y SU LONGITUD ES MAYOR A 4
Y QUE NO SON DE AEROPUERTOS DE ESPA�A, FRANCIA O USA*/

SELECT NOMBRE FROM DIRECTOR WHERE NOMBRE LIKE '%A%' AND LENGTH (NOMBRE)>4
AND (NOMBRE NOT LIKE '__A%' AND NOMBRE NOT LIKE '__E%' AND NOMBRE NOT LIKE '__I%' AND NOMBRE NOT LIKE '__O%' AND NOMBRE NOT LIKE '__U%'
AND NOMBRE NOT LIKE '__a%' AND NOMBRE NOT LIKE '__e%' AND NOMBRE NOT LIKE '__i%' AND NOMBRE NOT LIKE '__o%' AND NOMBRE NOT LIKE '__u%')
INTERSECT
SELECT NOMBRE FROM DIRECTOR WHERE COD_AEROPUERTO IN 
(SELECT CODIGO FROM AEROPUERTOS WHERE PAIS NOT IN ('ESPA�A', 'FRANCIA', 'USA'));

/*5. DIRECTORES DE AEROPUERTOS ESPA�OLES QUE NO TENGAN CONTROLADOR
O QUE SEAN NORTEAMERICANOS Y SU AEROPUERTO TENGA <3 SALIDAS
O QUE TENGAN UNA E EN SU TERCERA LETRA DEL NOMBRE
QUE SALGAN DUPLICADOS.*/

SELECT NOMBRE FROM DIRECTOR 
WHERE COD_AEROPUERTO IN (SELECT CODIGO FROM AEROPUERTOS WHERE PAIS= 'ESPA�A') --AEROPUERTO ESPA�OL
AND DNI_CONTR IS NULL -- SIN CONTROLADOR
UNION ALL
SELECT NOMBRE FROM DIRECTOR
WHERE PAIS= 'USA' -- NACIONALIDAD AMERICANA
AND COD_AEROPUERTO IN --Y SU AEROPUERTO SEA IGUAL A:
(SELECT AE.CODIGO FROM AEROPUERTOS AE, PROGRAMA_VUELO PR, VOLAR VO  -- AL CODIGO QUE RESULTA DE :
WHERE AE.CODIGO=PR.COD_AERO_DESPEGAR AND PR.NUM_VUELO=VO.NUM_VUELO  -- CRUZAR AEROPUERTOS CON AEROPUERTOS_DESPEGUE Y ADEMAS COINCIDA SU NUM_VUELO CON EL DE LA TABLA VOLAR 
GROUP BY AE.CODIGO,PR.COD_AERO_DESPEGAR HAVING COUNT(*)<3) -- Y AGRUPAR POR AEROPUERTO DE DESPEGUE
UNION ALL
SELECT NOMBRE FROM DIRECTOR
WHERE NOMBRE LIKE '__E' OR NOMBRE LIKE '__e'; -- O TENGAN UNA E EN SU TERCERA LETRA

