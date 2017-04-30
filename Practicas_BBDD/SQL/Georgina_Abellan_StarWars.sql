--STAR WARS

--1. Arreglar actores.

-- a, Sacar actores repetidos y cuantos hay.

SELECT NOMBRE, COUNT(*) FROM ACTORES GROUP BY NOMBRE HAVING COUNT(*)>1;

-- b) Saca los ACTORES repetidos que no están en HACER_CASTING ni en
-- PERSONAJES, atención NINGUNO de los repetidos deben estar, es decir, que
-- puede q tenga varios repetidos y unos estén y otros no, esta select SOLO quiero los
-- que NINGUNO este.

SELECT NOMBRE FROM ACTORES
WHERE NOMBRE IN 
(SELECT NOMBRE FROM ACTORES
GROUP BY NOMBRE
HAVING COUNT(*)>1)
AND NSS NOT IN (SELECT HA.NSS FROM HACER_CASTING HA, ACTORES AC WHERE HA.NSS=AC.NSS)
AND NSS NOT IN (SELECT NSS_ACTOR FROM PERSONAJES, ACTORES WHERE NSS_ACTOR=NSS);

-- c)Crea una tabla temporal con todos los ACTORES repetidos que nos servirá de
-- BACKUP (todos los datos de ACTORES).

CREATE TABLE TMP_ACTORES AS SELECT * FROM ACTORES WHERE NOMBRE IN
(SELECT NOMBRE FROM ACTORES GROUP BY NOMBRE HAVING COUNT(*)>1);

-- d)Elimina hasta dejar 1 solo ACTOR por cada uno de los repetidos que no están en
-- HACER_CASTING ni en PERSONAJES del punto b)

DELETE ACTORES AC WHERE NOMBRE IN (SELECT NOMBRE FROM ACTORES
                                GROUP BY NOMBRE
                                HAVING COUNT(*)>1)
                                AND NSS NOT IN (SELECT AC.NSS FROM HACER_CASTING HA, ACTORES AC WHERE HA.NSS=AC.NSS)
                                AND NSS NOT IN (SELECT NSS_ACTOR FROM PERSONAJES WHERE NSS_ACTOR=NSS) 
                                AND NSS> (SELECT MIN(NSS) FROM ACTORES AC2 WHERE AC.NOMBRE=AC2.NOMBRE);   

-- Y EL EJERCICIO UNO QUEDA ANULADO.... ESTAS SON LAS SQL QUE FALTAN....

-- e) Ahora saca una select de los que tienen repetidos y unos están en
-- HACER_CASTING o en PERSONAJES y otros no, en ese caso elimina todos los
-- que no estén.

-- Saber lo que se eliminaran los que los dos ultimos campos esten a null
select ac.*, hd.nss, p.nss_actor from ACTORES ac, HACER_CASTING hd, PERSONAJES p
where ac.nss=hd.nss(+)
and ac.nss=p.nss_actor(+)
and  ac.nombre in (
  select NOMBRE
   from ACTORES
   group by NOMBRE
   having count(*)>1);


delete ACTORES ac
where nombre in (
  select NOMBRE
   from ACTORES
   group by NOMBRE
   having count(*)>1)
   and nss not in (select nss from HACER_CASTING)
   and nss not in (select nss_actor from PERSONAJES);
   
--f) Del resto (los que SÍ están en estas tablas) actualiza en HACER_CASTING y
--PERSONAJES todos los NSS al MINIMO alfabéticamente de todos los repetidos
--y elimina los demás. OJO no elimines ACTORES que estén en
--HACER_CASTING o PERSONAJES pero que no esté repetidos.

update HACER_CASTING h
   set nss = (select min(nss)
               from ACTORES
               where nombre = (select nombre from ACTORES where nss=h.nss)
               group by nombre
               having count(*)>1)
where nss in ( select nss from actores where nombre in (
                                          select NOMBRE
                                           from ACTORES
                                           group by NOMBRE
                                           having count(*)>1));                
                                           

select nombre
               from ACTORES
               group by nombre
               having count(*)>1;


alter table personajes drop constraint uk_nss_actor;



update PERSONAJES h
   set nss_actor = (select min(nss)
               from ACTORES
               where nombre = (select nombre from ACTORES where nss=h.nss_actor)
               group by nombre
               having count(*)>1)
where nss_actor in ( select nss from actores where nombre in (
                                          select NOMBRE
                                           from ACTORES
                                           group by NOMBRE
                                           having count(*)>1));                  

                                           

delete ACTORES ac
where nombre in (
  select NOMBRE
   from ACTORES
   group by NOMBRE
   having count(*)>1)
   and nss not in (select nss from HACER_CASTING)
   and nss not in (select nss_actor from PERSONAJES);                                               
   
   
   
    select NOMBRE
   from ACTORES
   group by NOMBRE
   having count(*)>1;
   
   
-- 2 . ARRELGO LOCALIZACIONES

--a) Primero vamos a ver que tenemos mal, saca los LOCALIZACIONES repetidos y cuantos hay.

SELECT NOMBRE_LOC FROM LOCALIZACIONES GROUP BY NOMBRE_LOC HAVING COUNT(*)>1;

--b)Actualiza el nombre de estas localizaciones repetidas a los primeros 50 caracteres
--de la SOLUCION (en caso de ser NULO, coge los de PROBLEMA, y si los dos
--son NULO coge el código de localización) que tenga asociada dicha localización,
--si hay más de una ACTUACION saca el que su temporada y capitulo sean el más
--pequeño . Todas las repetidas se quedarán en uno solo y que este que se queda sea
--el que mínimo código de localización tenga

UPDATE LOCALIZACIONES SET NOMBRE_LOC=(SELECT DECODE (NOMBRE_LOC,NULL,SUBSTR(PROBLEMA,1,50),SUBSTR(SOLUCION, 1, 50))
                                      FROM ACTUAR AC, LOCALIZACIONES LO
                                      WHERE AC.COD_LOC=LO.COD_LOC
                                      AND TEMPORADA=(SELECT MIN (TEMPORADA) FROM ACTUAR AC, LOCALIZACIONES LO
                                                    WHERE AC.COD_LOC=LO.COD_LOC)
                                      AND CAPITULO=(SELECT MIN (CAPITULO)FROM ACTUAR AC, LOCALIZACIONES LO
                                                    WHERE AC.COD_LOC=LO.COD_LOC)
                                      AND AC.COD_LOC=(SELECT MIN (AC.COD_LOC) FROM ACTUAR AC, LOCALIZACIONES LO
                                                     WHERE AC.COD_LOC=LO.COD_LOC))
WHERE NOMBRE_LOC IN (SELECT NOMBRE_LOC FROM LOCALIZACIONES GROUP BY  NOMBRE_LOC HAVING COUNT(*)>1);

--???3- Tenemos muchos capitanes C3PO vamos a coger el que el reclutador sea NO NULO y
--cambiemos todos los demás personajes C3PO (usando like) a este personaje, en todas las
--tablas que tengan que ver con Personaje?Rebelde, Imperial…



--4- Tenemos varios tipos de SEXO, lo vamos a reducir a 2, M de (Male) y F (Female),
--actualiza toda la tabla PERSONAJE y ACTORES para que así sea. En DERRIBAR
--también tendremos 2 tipos I (imperial) o R (Rebelde), los 1 serán Rebelde los 0 Imperial, y
--en HACER_CASTING los campos HACER y PROTA deben ser S o N. 
--Cuando los actualices todos haz una restricción de CHECK para que no se pueda meter otra cosa.

UPDATE PERSONAJES SET SEXO= DECODE(SEXO,'HOMBRE','M','MUJER','F');
UPDATE ACTORES SET SEXO= DECODE(SEXO,'HOMBRE','M','MUJER','F');
UPDATE DERRIBAR SET DERRIBADO= DECODE(DERRIBADO,'1','R','0','I','R');
UPDATE HACER_CASTING SET HACER= DECODE(HACER,'1','S','N'), PROTA=DECODE(PROTA,'1','S','N');

ALTER TABLE PERSONAJES ADD CONSTRAINT CHECK_SEXO CHECK(SEXO= DECODE(SEXO,'HOMBRE','M','MUJER','F'));


-- EJERCICIOS STAR WARS. 

-- 1- Actores que tengan todas las vocales en su nombre

SELECT NOMBRE FROM ACTORES WHERE 
(NOMBRE LIKE '%A%' AND NOMBRE LIKE '%E%'AND NOMBRE LIKE '%I%'AND NOMBRE LIKE '%O%'AND NOMBRE LIKE '%U%')
OR
(NOMBRE LIKE '%a%'AND NOMBRE LIKE '%e%'AND NOMBRE LIKE '%i%'AND NOMBRE LIKE '%o%'AND NOMBRE LIKE '%u%');

-- 2- Actores nacidos antes de 1960 y que tengan menos de 4 letras en su nombre

SELECT NOMBRE FROM ACTORES WHERE LENGTH(NOMBRE)<4 
AND EXTRACT(YEAR FROM FECHA_NAC)<'1960';

-- 3- Haz una vista con los Soldados con más de 5 años de experiencia, la vista debe
--impedir que se pueda actualizar si incumple la condición de creación. Debes
--comprobarlo

CREATE VIEW SOLD_EXP AS SELECT * FROM SOLDADO WHERE ANYOS_EXP>5
WITH CHECK OPTION;

INSERT INTO SOLD_EXP SELECT * FROM SOLDADO WHERE ANYOS_EXP<5; -- COMPROBAR

--4 - Añade un campo a personaje que tenga un carácter alfanumérico, y actualiza este
-- campo a S si el personaje tiene un reclutador, y N si no es así.

ALTER TABLE PERSONAJES ADD RECLUT VARCHAR2(1);

UPDATE PERSONAJES SET RECLUT='S' WHERE NOMBRE_RECLUTADOR IS NOT NULL;
UPDATE PERSONAJES SET RECLUT='N' WHERE NOMBRE_RECLUTADOR IS NULL;

-- 5- Elimina el campo anterior de la tabla

ALTER TABLE PERSONAJES DROP COLUMN RECLUT;

--6- Vista no actualizable de las Localizaciones visitadas en la 2 temporada

CREATE OR REPLACE VIEW LOC_VISITADAS AS SELECT * FROM LOCALIZACIONES 
WHERE COD_LOC IN
(SELECT COD_LOC FROM ACTUAR WHERE TEMPORADA=2)
WITH CHECK OPTION;

-- 7- Personajes que hayan participado en alguna película con la palabra Star Wars (no se
-- puede usar like). También deben salir las posiciones del 5 al 10 de ese título y en
-- minúsculas

SELECT PE.NOMBRE, LOWER(SUBSTR(TITULO, 5, 5))
FROM PERSONAJES PE, ACTORES AC, HACER_CASTING HA, PELICULAS
WHERE PE.NSS_ACTOR=AC.NSS AND AC.NSS=HA.NSS AND CODIGO_PELICULA=COD_PELI;

-- 8- Cantidad y suma?¿ de todos los derribos efectuados por Rebeldes.

SELECT COUNT(*)FROM DERRIBAR WHERE DERRIBADO='I';

-- 9- Obtén cada personaje Rebelde y a la derecha que aparezca la palabra
--CONVERTIDO o NO CONVERTIDO, si lo ha sido o no

SELECT NOMBRE_REB||' - '||DECODE(NOM_SITH,NULL,'NO CONVERTIDO','CONVERTIDO')FROM REBELDE, JEDI WHERE NOMBRE_REB=NOMBRE_JEDI; 

--10- Saca cuantos diferentes niveles de Jedi tenemos en la base de datos (nivel y cantidad)

SELECT NIVEL_JEDI, COUNT(*) FROM JEDI GROUP BY  NIVEL_JEDI;

--11- Obtén cuántas localizaciones tiene cada capítulo.

SELECT CAPITULO, TEMPORADA,COUNT(*)NUMERO_LOC FROM ACTUAR GROUP BY CAPITULO, TEMPORADA;

--12- Saca el piloto con más derribos.

SELECT NOM_REBELDE, COUNT(*) FROM DERRIBAR GROUP BY NOM_REBELDE
HAVING COUNT (*)=(SELECT MAX(COUNT(*)) FROM DERRIBAR GROUP BY NOM_REBELDE);

-- 13- Saca cada personaje que más ha reclutado.

SELECT NOMBRE_RECLUTADOR, COUNT(*) FROM PERSONAJES 
WHERE NOMBRE_RECLUTADOR IS NOT NULL 
GROUP BY NOMBRE_RECLUTADOR
HAVING COUNT(*)= (SELECT MAX(COUNT(*)) FROM PERSONAJES WHERE NOMBRE_RECLUTADOR IS NOT NULL GROUP BY NOMBRE_RECLUTADOR);

--14- El problema más repetido

SELECT PROBLEMA FROM ACTUAR 
WHERE PROBLEMA IS NOT NULL
GROUP BY PROBLEMA
HAVING COUNT(*)=(SELECT MAX(COUNT(*)) FROM ACTUAR WHERE PROBLEMA IS NOT NULL GROUP BY PROBLEMA);

--15- El usuario con menos comentarios

SELECT USUARIO FROM COMENTAR
GROUP BY USUARIO
HAVING COUNT(*)=(SELECT MAX(COUNT(*))FROM COMENTAR GROUP BY USUARIO);

--17-Obtén las personajes que hayan visitado alguna localización y si no lo han hecho
--también deben salir

SELECT DISTINCT NOMBRE FROM PERSONAJES, ACTUAR WHERE NOMBRE=NOM_PERSONAJE(+);

--18-Saca localizaciones con más de 3 visitas y si hay más de una que solo salga la que el
--código de localización sea menor alfabéticamente.

SELECT NOMBRE_LOC FROM LOCALIZACIONES WHERE COD_LOC IN (SELECT COD_LOC FROM ACTUAR GROUP BY COD_LOC HAVING COUNT(*)>3)
AND NOMBRE_LOC = (SELECT MIN(NOMBRE_LOC) FROM LOCALIZACIONES);

--19-Obtén todos los personajes que no sean ni jedi ni sith.

SELECT NOMBRE FROM PERSONAJES WHERE NOMBRE NOT IN (SELECT NOMBRE_JEDI FROM PERSONAJES, JEDI WHERE NOMBRE_JEDI=NOMBRE)
AND NOMBRE NOT IN (SELECT NOMBRE_SITH FROM PERSONAJES, SITH WHERE NOMBRE_SITH=NOMBRE);

--20-Obtén los fan que no hayan hecho comentarios y los personajes que salgan en másde 1 CAPITULO

SELECT USUARIO FROM FANS WHERE USUARIO NOT IN (SELECT FA.USUARIO FROM COMENTAR CO, FANS FA WHERE FA.USUARIO=CO.USUARIO);

--------------------


SELECT CAPITULO, TEMPORADA  FROM ACTUAR , JEDI
WHERE CAPITULO=NUM_CAPITULO AND NOM_SITH IS NULL
GROUP BY CAPITULO, TEMPORADA
HAVING COUNT(*)=(SELECT MIN(COUNT(*)) FROM ACTUAR, JEDI WHERE CAPITULO=NUM_CAPITULO AND NOM_SITH IS NULL
GROUP BY CAPITULO, TEMPORADA);

SELECT DISTINCT TITULO FROM TEMPORADAS TE, PELICULAS PE, ACTUAR AC
WHERE NUM_TEMPO=NUM_TEMPORADA AND NUM_TEMPO=TEMPORADA
AND NOM_PERSONAJE IN (SELECT NOMBRE FROM PERSONAJES, REBELDE, IMPERIAL, DERRIBAR
                    WHERE NOMBRE=NOMBRE_REB OR NOMBRE=NOMBRE_IMP
                    AND NOMBRE_REB=NOM_REBELDE OR NOMBRE_IMP=NOM_IMPERIAL);
                    
ALTER TABLE ACTORES ADD FECHA DATE;
ALTER TABLE ACTORES DROP COLUMN FECHA;

SELECT TITULO, NOMBRE FROM ACTORES AC, HACER_CASTING HA, PELICULAS
WHERE COD_PELI=CODIGO_PELICULA AND AC.NSS=HA.NSS
AND HA.NSS IN (SELECT NSS FROM ACTORES
                WHERE FECHA_NAC = (SELECT MAX(FECHA_NAC) FROM ACTORES AC, HACER_CASTING HA WHERE AC.NSS=HA.NSS));

SELECT PE.NOMBRE FROM PERSONAJES PE, ACTORES AC WHERE NSS_ACTOR=NSS
AND TO_CHAR(FECHA_NAC,'YYYY')<1960 AND INSTR(AC.NOMBRE,' ')>0
AND PE.NOMBRE IN (SELECT NOM_PERSONAJE FROM ACTUAR GROUP BY NOM_PERSONAJE HAVING COUNT(*)>3);


SELECT PE.NOMBRE FROM PERSONAJES PE, ACTORES AC WHERE NSS_ACTOR=NSS
AND TO_CHAR(FECHA_NAC,'YYYY')<1960 AND INSTR(AC.NOMBRE,' ')>0
AND PE.NOMBRE IN (SELECT NOM_PERSONAJE FROM ACTUAR
                  WHERE (CAPITULO, TEMPORADA, NOM_PERSONAJE, COD_LOC) NOT IN 
                        (NUM_CAP, NUM_TEMPO, NOM_PERSONAJE, CODIGO_LOC FROM COMENTAR)
                  GROUP BY NOM_PERSONAJE HAVING COUNT(*)>3);
                  
SELECT DISTINCT PE.NOMBRE FROM PERSONAJES PE, ACTORES AC WHERE NSS_ACTOR=NSS
AND TO_CHAR(FECHA_NAC,'YYYY')<1960 AND INSTR(AC.NOMBRE,' ')>0
AND PE.NOMBRE IN (SELECT NOM_PERSONAJE FROM ACTUAR GROUP BY NOM_PERSONAJE HAVING COUNT(*)>3)
OR PE.NOMBRE IN (SELECT NOM_PERSONAJE FROM ACTUAR
                 WHERE COD_LOC IN (SELECT COD_LOC FROM LOCALIZACIONES WHERE COSTE_LOC>50000)
                 GROUP BY NOM_PERSONAJE HAVING COUNT(*)<5);--BUENA

