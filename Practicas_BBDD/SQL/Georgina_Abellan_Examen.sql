--MUNDIAL

/*1- Obtén la selección que más goles ha marcado en todos los Mundiales, indistintamente si el partido lo
jugó de local o de visitante, debe aparecer junto a dicha selección, los goles totales marcados y el
número de partidos que jugó para marcarlos (2,5 ptos).
NOTA: Recuerda que los goles marcados por el EQUIPO_L están en RESULTADO_L y del EQUIPO_V
en RESULTADO_V.*/

SELECT EQUIPO, SUM(PARTIDOS), SUM(GOLES) FROM(
    SELECT EQUIPO, COUNT(*)PARTIDOS ,SUM(RESULTADO_L) GOLES FROM EQUIPOS, PARTIDO WHERE EQUIPO=EQUIPO_L
    GROUP BY EQUIPO
    UNION
    SELECT EQUIPO, COUNT(*)PARTIDOS ,SUM(RESULTADO_V) GOLES FROM EQUIPOS, PARTIDO WHERE EQUIPO=EQUIPO_V
    GROUP BY EQUIPO)
GROUP BY EQUIPO HAVING SUM(GOLES)=(SELECT MAX(SUM(GOLES))
                                      FROM (SELECT EQUIPO, SUM(RESULTADO_L) GOLES 
                                            FROM EQUIPOS, PARTIDO WHERE EQUIPO=EQUIPO_L
                                            GROUP BY EQUIPO
                                            UNION
                                            SELECT EQUIPO, SUM(RESULTADO_V) GOLES 
                                            FROM EQUIPOS, PARTIDO WHERE EQUIPO=EQUIPO_V
                                            GROUP BY EQUIPO)
                                      GROUP BY EQUIPO);

/* Desde la FIFA te indican que han encontrado errores en la base de datos, te solicitan
que indiques todos los datos de los partidos donde los goles indicados en el resultado de dicho partido
no coincidan con los goles marcados por los jugadores en el mismo.
(1,25 ptos) (Pista: Cuidado con los resultados 0-0)*/

SELECT * FROM PARTIDO WHERE
RESULTADO_L != (SELECT COUNT(*) FROM JUGAR JU, GOL
                WHERE EQUIPO_L=EQUIPO_L_PART AND EQUIPO_V=EQUIPO_V_PART AND FECHA=FECHA_PART
                AND EQUIPO_L_PART=EQUIPO_L_GOL AND EQUIPO_V_PART=EQUIPO_V_GOL AND FECHA_PART=FECHA_GOL 
                AND NOMBRE_JUG=JUGADOR_GOL
                AND NOMBRE_JUG IN (SELECT NOMBRE FROM JUGADOR
                                   WHERE JU.EQUIPO_L_PART =EQUIPO_JUGADOR)                
                GROUP BY EQUIPO_L_GOL, EQUIPO_V_GOL, FECHA_GOL)
OR
RESULTADO_V != (SELECT COUNT(*) FROM JUGAR JU, GOL
                WHERE EQUIPO_L=EQUIPO_L_PART AND EQUIPO_V=EQUIPO_V_PART AND FECHA=FECHA_PART
                AND EQUIPO_L_PART=EQUIPO_L_GOL AND EQUIPO_V_PART=EQUIPO_V_GOL AND FECHA_PART=FECHA_GOL 
                AND NOMBRE_JUG=JUGADOR_GOL
                AND NOMBRE_JUG IN (SELECT NOMBRE FROM JUGADOR
                                   WHERE JU.EQUIPO_V_PART =EQUIPO_JUGADOR)
                GROUP BY EQUIPO_L_GOL, EQUIPO_V_GOL, FECHA_GOL);
                

/*3- Obtén el jugador que mas goles ha marcado jugando como delantero en el mundial 2010 y jugando
menos de 470 minutos en todos sus partidos. Debes obtener el jugador y la cantidad de goles marcados
(2,5 ptos)*/

SELECT JUGADOR_GOL, COUNT(*) FROM GOL 
WHERE JUGADOR_GOL IN (
                     SELECT NOMBRE_JUG FROM JUGAR WHERE PUESTO_JUGAR='DL' AND TO_CHAR(FECHA_PART,'YYYY')='2010'
                     GROUP BY NOMBRE_JUG
                     HAVING SUM(MIN_JUGAR)<470)
AND TO_CHAR(FECHA_GOL,'YYYY')='2010'
GROUP BY JUGADOR_GOL
HAVING COUNT(*)=(SELECT MAX(COUNT(*)) FROM GOL 
                 WHERE JUGADOR_GOL IN 
                                     (SELECT NOMBRE_JUG FROM JUGAR 
                                      WHERE PUESTO_JUGAR='DL' AND TO_CHAR(FECHA_PART,'YYYY')='2010'
                                      GROUP BY NOMBRE_JUG
                                      HAVING SUM(MIN_JUGAR)<470)
                 AND TO_CHAR(FECHA_GOL,'YYYY')='2010'
                 GROUP BY JUGADOR_GOL);

/*4- Saca el nombre del jugador, cuantos goles ha marcado y cuantos minutos ha jugado en todos los
mundiales en el caso que no haya marcado ningún gol o no haya jugado ningún partido también debe
salir indicando 0 en cada caso. Debes ordenar por numero de minutos descendentemente y por numero
de goles ascendentemente usando alias para ambos campos, se llamaran goles y minutos. (2 ptos).*/


SELECT NOMBRE, NVL(SUM(MIN_JUGAR),0) MINUTOS, COUNT(JUGADOR_GOL) GOLES FROM JUGADOR, JUGAR, GOL
WHERE NOMBRE=NOMBRE_JUG(+) AND NOMBRE_JUG=JUGADOR_GOL(+)
GROUP BY NOMBRE
ORDER BY  MINUTOS DESC, GOLES;

/*5- Obtén el nombre ordenado descendente de cada selección juntos con los partidos que ha ganado como
local y con los partidos que ha ganado como visitante (2 ptos).*/

SELECT EQUIPO, LO.LOCAL, VI.VISITANTE FROM EQUIPOS,
    (SELECT EQUIPO_L, COUNT(*) LOCAL FROM PARTIDO 
    WHERE RESULTADO_L>RESULTADO_V GROUP BY EQUIPO_L) LO,
    (SELECT EQUIPO_V, COUNT(*) VISITANTE FROM PARTIDO 
    WHERE RESULTADO_L<RESULTADO_V GROUP BY EQUIPO_V) VI
WHERE EQUIPO=LO.EQUIPO_L AND EQUIPO=VI.EQUIPO_V
ORDER BY EQUIPO DESC;

/*6- Inserta 1 laboratorio y 1 federativo inventándote los datos. Para luego con este laboratorio y este
federativo, inserta análisis antidoping para cada partido del Mundial, de modo que se harán el control en
cada partido todos aquellos jugadores que más minutos han jugado en cada partido, quedando exentos
(es decir, quitando) aquellos jugadores que ya lleven hechos más de 5 análisis. (2,5 ptos)*/

INSERT INTO LABORATORIO (CIF, NOMBRE, DIRECCION, TELEFONO) VALUES ('123A', 'LAB',NULL, NULL);
INSERT INTO FEDERATIVO(ID_TARJ, NOMBRE, TELEFONO) VALUES ('098', 'FED', NULL);

--JUGADORES QUE MAS MINUTOS HAN JUGADO EN CADA PARTIDO, CON MENOS DE 5 PARTIDOS

INSERT INTO ANALISIS (JUGADOR, EQUIPO_L, EQUIPO_V, FECHA_PART, CIF, ID_TARJETA)
SELECT NOMBRE_JUG, EQUIPO_L_PART,EQUIPO_V_PART, FECHA_PART, CIF, ID_TARJ
FROM JUGAR, LABORATORIO, FEDERATIVO  
WHERE MIN_JUGAR IN (SELECT MAX(MIN_JUGAR) FROM JUGAR GROUP BY EQUIPO_L_PART, EQUIPO_V_PART, FECHA_PART)
AND NOMBRE_JUG IN (SELECT NOMBRE_JUG FROM JUGAR GROUP BY NOMBRE_JUG HAVING COUNT(*)<5);

-- O ASI: JUGADORES QUE MAS MINUTOS HAN JUGADO EN CADA PARTIDO, QUITANDO LOS QUE APARECEN MAS DE 5 VECES

INSERT INTO ANALISIS (JUGADOR, EQUIPO_L, EQUIPO_V, FECHA_PART, CIF, ID_TARJETA)
SELECT NOMBRE_JUG, EQUIPO_L_PART,EQUIPO_V_PART, FECHA_PART, CIF, ID_TARJ
FROM JUGAR, LABORATORIO, FEDERATIVO  
WHERE MIN_JUGAR IN (SELECT MAX(MIN_JUGAR) FROM JUGAR GROUP BY EQUIPO_L_PART, EQUIPO_V_PART, FECHA_PART)
MINUS 
SELECT NOMBRE_JUG, EQUIPO_L_PART,EQUIPO_V_PART, FECHA_PART, CIF, ID_TARJ
FROM JUGAR, LABORATORIO, FEDERATIVO
WHERE MIN_JUGAR IN (SELECT MAX(MIN_JUGAR) FROM JUGAR GROUP BY EQUIPO_L_PART, EQUIPO_V_PART, FECHA_PART)
AND NOMBRE_JUG IN (SELECT NOMBRE_JUG FROM JUGAR GROUP BY NOMBRE_JUG HAVING COUNT(*)>5);


-- STAR WARS

--7- Temporadas que haya abarcado más de 1 película y en cuyas actuaciones haya participado personajes
--que haya participado en más de 2 derribos, ya sea como derribado o como el que derriba.
                                          
SELECT DISTINCT TITULO_TEMPO, TE.NUM_TEMPO FROM TEMPORADAS TE, CAPITULOS CA, ACTUAR AC
WHERE TE.NUM_TEMPO=CA.NUM_TEMPO AND CA.NUM_TEMPO=AC.TEMPORADA
AND TE.NUM_TEMPO IN 
    (SELECT PE.NUM_TEMPORADA FROM PELICULAS PE GROUP BY NUM_TEMPORADA HAVING COUNT(*)>1)
AND AC.NOM_PERSONAJE IN 
    (SELECT NOMBRE FROM PERSONAJES 
    WHERE NOMBRE IN 
        (SELECT NOMBRE_REB FROM REBELDE WHERE NOMBRE_REB IN 
             (SELECT NOM_REBELDE FROM DERRIBAR GROUP BY NOM_REBELDE HAVING COUNT(*)>2))
    OR NOMBRE IN 
        (SELECT NOMBRE_IMP FROM IMPERIAL WHERE NOMBRE_IMP IN 
             (SELECT NOM_IMPERIAL FROM DERRIBAR GROUP BY NOM_IMPERIAL HAVING COUNT(*)>2)));
           

--8- Es un error muy típico poner el campo EDAD en un modelo, con el problema enorme de
--actualización que conlleva, elimina este campo de la tabla ACTORES, para calcular la edad se usa la
--FECHA DE NACIMIENTO. Obtén para cada película el título de la película junto con el nombre del
--actor de mayor edad que ha realizado el CASTING, saca también su edad.

ALTER TABLE ACTORES DROP COLUMN EDAD;

SELECT TITULO, NOMBRE, (TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(FECHA_NAC,'YYYY'))EDAD 
FROM ACTORES AC, PELICULAS PE , HACER_CASTING HA
WHERE HA.NSS=AC.NSS AND HA.CODIGO_PELICULA=PE.COD_PELI
AND FECHA_NAC = (SELECT MIN(FECHA_NAC) FROM ACTORES AC2 , HACER_CASTING HA2
                 WHERE HA2.NSS=AC2.NSS AND HA2.CODIGO_PELICULA=PE.COD_PELI 
                 GROUP BY HA2.CODIGO_PELICULA)
ORDER BY TITULO DESC;
   
--9- El capitulo que menos actuaciones tenga donde no se hayan convertido ningún Jedi al lado obscuro.
--Debes usar NOT IN y NOT EXISTS (1,75 ptos).
--(Nota: Recuerda que CONVERTIR ya no es tabla, sus campos están en JEDI)
--Pista: Cuidado con el NOT IN).

SELECT NUM_CAP, NUM_TEMPO FROM CAPITULOS 
WHERE EXISTS(SELECT 1 FROM ACTUAR 
             WHERE CAPITULO=NUM_CAP AND NUM_TEMPO=TEMPORADA
             AND (CAPITULO, TEMPORADA) NOT IN (SELECT NUM_CAPITULO, NUM_TEMPORADA FROM JEDI
                                               WHERE NUM_CAPITULO=CAPITULO AND NUM_TEMPORADA=TEMPORADA)
             GROUP BY 1
             HAVING COUNT(*)=(SELECT MIN(COUNT(*)) FROM ACTUAR 
                              WHERE NOT EXISTS (SELECT 1 FROM JEDI WHERE NUM_CAPITULO=CAPITULO AND NUM_TEMPORADA=TEMPORADA)
                              GROUP BY CAPITULO, TEMPORADA));

-- o así 
SELECT NUM_CAP, NUM_TEMPO FROM CAPITULOS, ACTUAR 
WHERE NUM_CAP=CAPITULO AND NUM_TEMPO=TEMPORADA
AND (CAPITULO, TEMPORADA) NOT IN (SELECT NUM_CAPITULO, NUM_TEMPORADA FROM JEDI
                                  WHERE NUM_CAPITULO=CAPITULO AND NUM_TEMPORADA=TEMPORADA)
GROUP BY NUM_CAP, NUM_TEMPO
HAVING COUNT(*)= (SELECT MIN(COUNT(*)) FROM ACTUAR WHERE NOT EXISTS (SELECT 1 FROM JEDI
                 WHERE NUM_CAPITULO=CAPITULO AND NUM_TEMPORADA=TEMPORADA) GROUP BY CAPITULO, TEMPORADA);                         

--10- Personajes que hayan sido interpretados por Actores nacidos antes de 1960 y que tengan 2 palabras
--en el nombre o que hayan participado en más de 3 actuaciones sin que ningún fan haya hecho
--comentarios de las mismas o que hayan sido menos de 5 pero que su localizaciones tengan un coste
--superior a 50.000 y además de todo esto, que hayan sido SITH asesinando a otro SITH de mayor grado
--que ellos o que hayan sido un JEDI que nunca los hayan convertido al lado obscuro. A todo esto quítale
--los personajes tengan una H en el NSS y que no tengan reclutador. Debes usar al menos 1 vez EXISTS
--(3 ptos).


SELECT PE.NOMBRE FROM PERSONAJES PE, ACTORES AC 
WHERE EXISTS (SELECT 1 FROM ACTORES AC 
              WHERE NSS_ACTOR=NSS AND TO_CHAR(FECHA_NAC,'YYYY')<'1960' 
              AND INSTR (PE.NOMBRE,' ')>=1)
UNION

SELECT NOM_PERSONAJE FROM PERSONAJES PE, ACTUAR AC
WHERE NOM_PERSONAJE=NOMBRE 
AND (NOM_PERSONAJE, CAPITULO, TEMPORADA, COD_LOC) NOT IN 
                                                        (SELECT NOM_PERSONAJE, NUM_CAP, NUM_TEMPO, CODIGO_LOC 
                                                         FROM COMENTAR)
GROUP BY NOM_PERSONAJE HAVING COUNT(*)>3

UNION

SELECT NOM_PERSONAJE FROM PERSONAJES PE, ACTUAR AC, LOCALIZACIONES LO
WHERE NOM_PERSONAJE=NOMBRE 
AND AC.COD_LOC=LO.COD_LOC AND LO.COD_LOC>'50000'
GROUP BY NOM_PERSONAJE HAVING COUNT(*)<5

INTERSECT

SELECT DISTINCT NOMBRE FROM PERSONAJES
WHERE NOMBRE IN (SELECT NOMBRE_IMP FROM IMPERIAL, SITH ASE, SITH ADO, MATAR WHERE NOMBRE_IMP=ASE.NOMBRE_SITH 
                 AND ASE.NOMBRE_SITH=SITH_ASESINO AND ADO.NOMBRE_SITH = SITH_ASESINADO AND ASE.GRADO_SITH<ADO.GRADO_SITH)
OR NOMBRE IN (SELECT NOMBRE_REB FROM REBELDE, JEDI WHERE NOMBRE=NOMBRE_REB AND NOMBRE_REB= NOMBRE_JEDI
              AND NOM_SITH IS NULL)

MINUS

SELECT NOMBRE FROM PERSONAJES WHERE INSTR(NSS_ACTOR, 'H')>0
AND NOMBRE_RECLUTADOR IS NULL;

/*11- Escribe cuál seria el enunciado cuya solución seria estos SQL (1,5 pto):
Nota: Tu enunciado debe explicar el porque de cada cosa efectuada en los SQL
(Pista: El resultado de un count nunca es NULL, mínimo es 0.)*/

-- Añadir una columna llamada entrevista con tipo de dato numerico la tabla hacer casting.
ALTER TABLE HACER_CASTING ADD ENTREVISTA NUMBER;
alter table hacer_casting drop column entrevista;

-- La actualización del campo pretende asignar un número de entrevista al actor que figura en la tabla hacer_casting
-- cuando el codigo de la pelicula sea EPVII

-- Para ello, se le da un número que se incrementa en uno a partir de 
-- el recuento de la cantidad de actores, de la tabla actores,
-- cuya fecha de nacimiento sea mayor que la de todos los actores que figuran en la tabla hacer_casting principal

UPDATE HACER_CASTING hc SET entrevista = (SELECT count(*)+1 FROM ACTORES
                                            WHERE FECHA_NAC > (SELECT FECHA_NAC FROM ACTORES ac
                                                                WHERE ac.NSS=hc.NSS)
                                            -- y cuyos nss esten entre los que 
                                            -- hayan hecho el casting de la pelicula con codigo EPVII
                                            AND nss IN (SELECT nss                  
                                                        FROM HACER_CASTING
                                                        WHERE CODIGO_PELICULA='EPVII'))
WHERE CODIGO_PELICULA='EPVII';


--AEROPUERTO

/*12- Saca todos los datos del avión, la fecha de vuelo, días de la semana que vuela y la línea aérea y
ordénalos descendentemente por fecha de vuelo, de aquellos aviones de IBERIA que su modelo
contenga la palabra BOEING, que vuele en vuelos de julio de 2013, que la primera letra del numero de
vuelo sea una consonante. (0,5 ptos)
(NOTA: Ten en cuenta que hay datos en minúscula y otros en mayúscula)*/

SELECT AV.*, PR.DIAS_SEMANA, VO.FECHA_VUELO FROM AVIONES AV, PROGRAMA_VUELO PR, VOLAR VO
WHERE AV.CODIGO=VO.COD_AVION AND PR.NUM_VUELO=VO.NUM_VUELO
AND UPPER(AV.LINEA_AEREA)='IBERIA'
AND INSTR(UPPER(AV.MODELO),'BOEING')>0
AND TO_CHAR(VO.FECHA_VUELO,'MM/YYYY')='07/2013'
AND UPPER(VO.NUM_VUELO) NOT LIKE 'A%' AND UPPER(VO.NUM_VUELO) NOT LIKE 'E%' AND UPPER(VO.NUM_VUELO) NOT LIKE 'I%'
    AND UPPER(VO.NUM_VUELO) NOT LIKE 'O%' AND UPPER(VO.NUM_VUELO) NOT LIKE 'U%'
ORDER BY FECHA_VUELO DESC;

/*13- Nuestro famoso alumno James Bond nos pide ayuda para localizar en el modelo del aeropuerto a un
espía y su cómplice. Conocemos que el cómplice es un director cuyo país es TURKEY, el espía es
controlador de este director, y sabemos que el espía despegó desde el aeropuerto que el mismo dirige,
conocemos de ese vuelo parte del código del avión que utilizó 757 y que lo efectuó durante 2014,
sabemos que el destino del avión era un aeropuerto que contiene las palabras ANGELES y AIRPORT,
pero que hizo una escala en la ciudad de ACAPULCO donde se oculta en este momento. Debe conseguir
en una sola consulta el nombre del espía y de su cómplice. (1 pto)
(Pista: Ojo que alguna Tabla la necesitarás más de una vez.)*/

SELECT UNO.NOMBRE COMPLICE, DOS.NOMBRE ESPIA  FROM DIRECTOR UNO, DIRECTOR DOS 
WHERE UNO.PAIS='TURKEY'
AND UNO.DNI_CONTR=DOS.DNI
AND DOS.COD_AEROPUERTO IN (SELECT AE.CODIGO FROM AEROPUERTOS AE, PROGRAMA_VUELO PR, VOLAR VO, AVIONES AV
                            WHERE AE.CODIGO=PR.COD_AERO_DESPEGAR
                            AND PR.NUM_VUELO=VO.NUM_VUELO
                            AND AV.CODIGO=VO.COD_AVION 
                            AND VO.COD_AVION LIKE '%757%'
                            AND TO_CHAR(FECHA_VUELO,'YYYY')='2014'
                            AND PR.COD_AERO_ATERRIZAR IN 
                                                        (SELECT CODIGO FROM AEROPUERTOS WHERE NOMBRE LIKE '%ANGELES%'
                                                        AND NOMBRE LIKE '%AIRPORT%')
                            AND (VO.NUM_VUELO, VO.COD_AVION, VO.FECHA_VUELO) IN 
                                                                               (SELECT NUM_VUELO, COD_AVION, FECHA_VUELO 
                                                                               FROM TENER_ESCALA, AEROPUERTOS 
                                                                               WHERE COD_AEROPUERTO=CODIGO
                                                                               AND CIUDAD='ACAPULCO'));

/*14- Realiza una vista actualizable, con los datos necesarios de los DIRECTORES que tengan una A en
su tercera letra, y que si quitamos los 9 de su teléfono se quedan solo con 3 dígitos, debes asegurar que
la vista no se puede actualizar si incumplimos estos criterios. En la vista el campo nombre debe llamarse
dire. (1 pto)*/
                            
CREATE VIEW DATOS_DIRE (DNI, COD_AEROPUERTO, DIRE, DIRECCION, TELEFONO, PAIS, DNI_CONTR)
AS SELECT * FROM DIRECTOR
WHERE (NOMBRE LIKE'__A%' OR NOMBRE LIKE'__a%')
AND LENGTH(REPLACE(TO_CHAR(TELEFONO,'999999999'),'9'))=3
WITH CHECK OPTION;

--COMPROBACION
INSERT INTO DATOS_DIRE (DNI, COD_AEROPUERTO, DIRE, DIRECCION, TELEFONO, PAIS, DNI_CONTR)
SELECT * FROM DIRECTOR;

/*15- Dime el nombre del director y del director que lo controla y los nombres de los aeropuertos de los
que son responsables, de todos aquellos donde ambos dirijan aeropuertos del mismo país, siempre y
cuando no sean la misma persona, es decir que no tendremos en cuenta cuando el director sea
controlador de si mismo. (1 pto)*/

SELECT DIR.NOMBRE, DIR2.NOMBRE, DIR.COD_AEROPUERTO, DIR2.COD_AEROPUERTO
FROM DIRECTOR DIR, DIRECTOR DIR2, AEROPUERTOS AE, AEROPUERTOS AE2
WHERE DIR.DNI_CONTR=DIR2.DNI
AND DIR.DNI_CONTR!=DIR.DNI
AND DIR.COD_AEROPUERTO=AE.CODIGO
AND DIR2.COD_AEROPUERTO=AE2.CODIGO
AND AE.PAIS=AE2.PAIS;

--ARREGLOS

--A1

/*a) Escribe como si de un supuesto nuevo se tratará los cambios que debes hacer en el modelo lógico
para pasar de la agregación a la ternaria.*/

VOLAR (COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO, PLAZAS_OCUPADAS, NUM_ESCALA, PASAJEROS_SUBEN, PASAJEROS_BAJAN)
PK: (COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO)
FK: (COD_AEROPUERTO -> AEROPUERTOS)
FK: (NUM_VUELO -> PROGRAMA_VUELO)
FK: (COD_AVION -> AVIONES)

SUBIR_BAJAR (COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO, PAS_PASAJE)
PK: (COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO, PAS_PASAJE)
FK: (COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO -> VOLAR)
FK:(PAS_PASAJE -> PASAJE)

ABORDO (COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO, PAS_ABORDO)
PK: (COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO, PAS_ABORDO)
FK: (COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO -> VOLAR)
FK: (PAS_ABORDO -> PASAJEROS)

/* b) Elimina todas las escalas donde el aeropuerto de dicha escala, sea el aeropuerto de
despegue o de aterrizaje de su propio programa de vuelo. (1,5 ptos)*/

DELETE TENER_ESCALA TE 
WHERE NUM_VUELO IN
                (SELECT TE.NUM_VUELO FROM VOLAR VO, AEROPUERTOS AE, PROGRAMA_VUELO PR
                WHERE  TE.NUM_VUELO=VO.NUM_VUELO AND TE.COD_AVION=VO.COD_AVION AND TE.FECHA_VUELO=VO.FECHA_VUELO
                AND TE.COD_AEROPUERTO=AE.CODIGO
                AND (AE.CODIGO=PR.COD_AERO_DESPEGAR OR AE.CODIGO=COD_AERO_ATERRIZAR)
                AND PR.NUM_VUELO=VO.NUM_VUELO);

--c) Cambios de datos en VOLAR.

    -- Añadir las nuevas columnas
    ALTER TABLE VOLAR ADD COD_AEROPUERTO VARCHAR2(3);
    ALTER TABLE VOLAR ADD NUMERO_ESCALA NUMBER (1); 
    ALTER TABLE VOLAR ADD PASAJEROS_BAJAN NUMBER (3);
    ALTER TABLE VOLAR ADD PASAJEROS_SUBEN NUMBER (3);
    
    --Todos los vuelos actuales pasarán a tener el aeropuerto de origen de su programa de vuelo como el
    --aeropuerto de escala y con número de escala 0, los campos pasajeros_suben y bajan quedarán a NULL.
    
    UPDATE VOLAR VO SET COD_AEROPUERTO = (SELECT COD_AERO_DESPEGAR FROM PROGRAMA_VUELO PR
                                          WHERE VO.NUM_VUELO=PR.NUM_VUELO),
                        NUMERO_ESCALA=0, PASAJEROS_BAJAN=NULL, PASAJEROS_SUBEN=NULL;
    
    -- Borrar la restriccion de la clave primaria para poder cambiarla, y añadir el campo que falta a la ternaria
    
    -- Hay que bajar las fk que hacen referencia a volar (abordo y tener_escala)
    -- (Aunque se prodria hacer bajando la pk de volar haciendo CASCADE)
    
    ALTER TABLE ABORDO DROP CONSTRAINT FK_ABORDO_VOLAR; -- Mas tarde la subiremos.
    ALTER TABLE TENER_ESCALA DROP CONSTRAINT FK_TENER_ESCALA_VOLAR;
    
    ALTER TABLE VOLAR DROP CONSTRAINT PK_VOLAR;
    ALTER TABLE VOLAR ADD CONSTRAINT PK_VOLAR PRIMARY KEY (NUM_VUELO, COD_AVION, COD_AEROPUERTO, FECHA_VUELO);
    ALTER TABLE VOLAR ADD CONSTRAINT FK_VOLAR_AEROP FOREIGN KEY (COD_AEROPUERTO) REFERENCES AEROPUERTOS (CODIGO);
    
    --Traspasa los datos de TENER_ESCALA a VOLAR. El campo plazas_ocupadas si es una escala, será
    --la resta de los que suben y bajen en dicha escala. 
    
    INSERT INTO VOLAR (NUM_VUELO, COD_AVION, FECHA_VUELO, PLAZAS_OCUPADAS, COD_AEROPUERTO, NUMERO_ESCALA,
                  PASAJEROS_BAJAN, PASAJEROS_SUBEN)
    SELECT TE.NUM_VUELO, TE.COD_AVION, TE.FECHA_VUELO,
    DECODE (NUMERO_ESCALA, 1, PASAJEROS_SUBEN-PASAJEROS_BAJAN, 0), 
    TE.COD_AEROPUERTO, NUMERO_ESCALA, PASAJEROS_BAJAN, PASAJEROS_SUBEN
    FROM TENER_ESCALA TE
    WHERE (TE.NUM_VUELO,TE.COD_AVION,TE.FECHA_VUELO, TE.COD_AEROPUERTO) NOT IN
    (SELECT NUM_VUELO,COD_AVION,FECHA_VUELO,COD_AEROPUERTO FROM VOLAR);
    
    -- d) Cambio en las 2 agregaciones a la nueva ternaria.
    
    -- Poner la FK de SUBIR_BAJAR_ESCALAS a VOLAR
    
    ALTER TABLE SUBIR_BAJAR DROP CONSTRAINT FK_SUB_BAJ_TENER_ESCALA;
    ALTER TABLE SUBIR_BAJAR ADD CONSTRAINT FK_SUB_BAJ_VOLAR FOREIGN KEY (COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO)
    REFERENCES VOLAR (COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO);
    
    -- ABORDO debes hacer el cambio pertinente en su PK y actualizarla 
    -- con el aeropuerto que no sea escala (numero_escala sea 0)
    
    -- Añadir columna que luego será parte de la pk y actualizarla
    
    ALTER TABLE ABORDO ADD COD_AEROPUERTO VARCHAR(3); 

    UPDATE ABORDO AB SET COD_AEROPUERTO=(SELECT VO.COD_AEROPUERTO FROM VOLAR VO
                                         WHERE VO.NUM_VUELO=AB.NUM_VUELO AND VO.COD_AVION=AB.COD_AVION 
                                         AND VO.FECHA_VUELO=AB.FECHA_VUELO AND NUMERO_ESCALA=0);
                                         
    -- Crear constraint pk y fk
        
    ALTER TABLE ABORDO DROP CONSTRAINT PK_ABORDO; -- BORRAR PK
    
    ALTER TABLE ABORDO ADD CONSTRAINT PK_ABORDO PRIMARY KEY (PAS_ABORDO, NUM_VUELO, COD_AVION, COD_AEROPUERTO, FECHA_VUELO);
    ALTER TABLE ABORDO ADD CONSTRAINT FK_ABORDO_VOLAR FOREIGN KEY (NUM_VUELO, COD_AVION, COD_AEROPUERTO, FECHA_VUELO)
    REFERENCES VOLAR (NUM_VUELO, COD_AVION, COD_AEROPUERTO, FECHA_VUELO);
    
    --Una vez arregladas las agregaciones borro TENER_ESCALA.
    
    DROP TABLE TENER_ESCALA;
    
-- A2.

    -- Actualiza todos los AVIONES que la linea_aerea este vacia o tenga menos de 4 caracteres o contenga
    --la palabra "linea". Y los vamos a actualizar con el campo LINEA_AEREA de PROGRAMA de VUELO
    --del vuelo con numero de vuelo más pequeño que haya realizado el AVION a actualizar, en el caso que
    --para ese mínimo numero de vuelo el avión haya realizado más de un vuelo, cogeremos el de menor fecha.
    
      UPDATE AVIONES AV SET AV.LINEA_AEREA =
      (SELECT DISTINCT PR.LINEA_AEREA FROM PROGRAMA_VUELO PR, VOLAR VO
      WHERE AV.CODIGO=VO.COD_AVION AND VO.NUM_VUELO=PR.NUM_VUELO
      AND VO.NUM_VUELO = (SELECT MIN(PR2.NUM_VUELO) FROM PROGRAMA_VUELO PR2, VOLAR VO2
                           WHERE AV.CODIGO=VO2.COD_AVION AND VO2.NUM_VUELO=PR2.NUM_VUELO)
      AND VO.FECHA_VUELO = (SELECT MIN(VO3.FECHA_VUELO) FROM VOLAR VO3
                            WHERE AV.CODIGO=VO3.COD_AVION AND VO3.NUM_VUELO=PR.NUM_VUELO)
      )
      WHERE AV.LINEA_AEREA IS NULL OR LENGTH(AV.LINEA_AEREA)<4 OR AV.LINEA_AEREA LIKE '%LINEA%';