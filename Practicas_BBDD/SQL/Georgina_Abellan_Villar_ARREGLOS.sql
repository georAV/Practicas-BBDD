-- AEROPUERTO

CREATE TABLE PASAJEROS (
PASAPORTE VARCHAR2(15) NOT NULL,
NOMBRE VARCHAR2(60),
DIRECCION VARCHAR2(60),
NACIONALIDAD VARCHAR2(30),
CONSTRAINT PK_PASAJEROS PRIMARY KEY (PASAPORTE)
);

CREATE TABLE PASAJE (
PAS_PASAJE VARCHAR2 (15) NOT NULL,
NUM_VUELOS_PAS NUMBER,
CONSTRAINT PK_PASAJE PRIMARY KEY (PAS_PASAJE),
CONSTRAINT FK_PAS_PAS FOREIGN KEY (PAS_PASAJE) REFERENCES PASAJEROS (PASAPORTE)
);

CREATE TABLE TRIPULACION (
PAS_TRIPULACION VARCHAR2 (15) NOT NULL,
ANYOS NUMBER,
CONSTRAINT PK_TRIPULACION PRIMARY KEY (PAS_TRIPULACION),
CONSTRAINT FK_PAS_TRIP FOREIGN KEY (PAS_TRIPULACION) REFERENCES PASAJEROS (PASAPORTE)
);

CREATE TABLE ABORDO (
PAS_ABORDO VARCHAR2 (15) NOT NULL,
NUM_VUELO VARCHAR2 (10) NOT NULL,
COD_AVION VARCHAR2 (10) NOT NULL,
FECHA_VUELO DATE NOT NULL,
CONSTRAINT PK_ABORDO PRIMARY KEY (PAS_ABORDO, NUM_VUELO, COD_AVION, FECHA_VUELO),
CONSTRAINT FK_ABORDO_PASAJERO FOREIGN KEY (PAS_ABORDO) REFERENCES PASAJEROS(PASAPORTE),
CONSTRAINT FK_ABORDO_VOLAR FOREIGN KEY (NUM_VUELO, COD_AVION, FECHA_VUELO) REFERENCES VOLAR (NUM_VUELO, COD_AVION, FECHA_VUELO)
);

CREATE TABLE SUBIR_BAJAR (
PAS_PASAJE VARCHAR2 (15) NOT NULL,
COD_AEROPUERTO VARCHAR2 (10) NOT NULL,
NUM_VUELO VARCHAR2 (10) NOT NULL,
COD_AVION VARCHAR2 (10) NOT NULL,
FECHA_VUELO DATE NOT NULL,
CONSTRAINT PK_SUBIR_BAJAR PRIMARY KEY (PAS_PASAJE, COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO),
CONSTRAINT FK_SUB_BAJ_PASAJE FOREIGN KEY (PAS_PASAJE) REFERENCES PASAJE(PAS_PASAJE),
CONSTRAINT FK_SUB_BAJ_TENER_ESCALA FOREIGN KEY (COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO) 
REFERENCES TENER_ESCALA (COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO)
);

--Voy a hacerlo con vistas para practicar, en vez de insertar uno por uno, espero que sea un problema.

-- Creo la vista de los alumnos, con los campos que me interesan
CREATE VIEW VISTA_PASAJE (PASAPORTE, NOMBRE, PAIS)
AS SELECT DNI, NOMBRE, PAIS
FROM FUNCIONES_AL.ALUMNOS;

-- Y la uso para rellenar pasajeros.
INSERT INTO PASAJEROS (PASAPORTE, NOMBRE, NACIONALIDAD) SELECT * FROM FUNCIONES_AL.VISTA_PASAJE; 

-- Creo una vista de pasajeros para tenerla en este usuario.

CREATE VIEW VISTA_PASAJE_II (PASAPORTE)
AS SELECT PASAPORTE FROM PASAJEROS;

--Y relleno el pasaje (excepto 3 dni que los dejo para la tripulación)

INSERT INTO PASAJE (PAS_PASAJE) SELECT PASAPORTE FROM VISTA_PASAJE_II WHERE PASAPORTE NOT IN ('732E','566L','668');

-- Y relleno la tripulación con los 3 dni escogidos.
INSERT INTO TRIPULACION (PAS_TRIPULACION) SELECT PASAPORTE FROM VISTA_PASAJE_II WHERE PASAPORTE IN ('732E','566L','668B');

--Inserto a todos en Abordo , para el pasaporte vuelvo a usar la vista. Los aviones son escogidos respecto a sus escalas.

-- Elijo un vuelo sin escalas y lo inserto en abordo

SELECT * FROM VOLAR WHERE (NUM_VUELO, COD_AVION, FECHA_VUELO) NOT IN (SELECT NUM_VUELO, COD_AVION, FECHA_VUELO FROM TENER_ESCALA);
INSERT INTO ABORDO (PAS_ABORDO, NUM_VUELO, COD_AVION, FECHA_VUELO) 
SELECT PASAPORTE, 'AAC002', 'AZ123', '25/03/2014' FROM VISTA_PASAJE_II;

-- Elijo un vuelo con una escala y lo inserto en abordo

SELECT NUM_VUELO, COD_AVION, FECHA_VUELO FROM VOLAR
WHERE (NUM_VUELO, COD_AVION, FECHA_VUELO) IN 
(SELECT NUM_VUELO, COD_AVION, FECHA_VUELO FROM TENER_ESCALA GROUP BY NUM_VUELO, COD_AVION, FECHA_VUELO HAVING COUNT(*)=1);
INSERT INTO ABORDO (PAS_ABORDO, NUM_VUELO, COD_AVION, FECHA_VUELO) 
SELECT PASAPORTE, 'AB4901', 'BE190', '03/03/2016' FROM VISTA_PASAJE_II;

-- Elijo un vuelo con 2 escalas y lo inserto en abordo

SELECT NUM_VUELO, COD_AVION, FECHA_VUELO FROM VOLAR
WHERE (NUM_VUELO, COD_AVION, FECHA_VUELO) IN 
(SELECT NUM_VUELO, COD_AVION, FECHA_VUELO FROM TENER_ESCALA GROUP BY NUM_VUELO, COD_AVION, FECHA_VUELO HAVING COUNT(*)=2);
INSERT INTO ABORDO (PAS_ABORDO, NUM_VUELO, COD_AVION, FECHA_VUELO) 
SELECT PASAPORTE, '7D9851', 'BO777', '13/02/2014' FROM VISTA_PASAJE_II;

--Insertar en subir-bajar que 3 pasajes suban en la segunda escala del vuelo que tenga mas escalas.
-- Como he buscado los vuelos a conciencia con las select se los datos.

INSERT INTO SUBIR_BAJAR (PAS_PASAJE, COD_AEROPUERTO, NUM_VUELO, COD_AVION, FECHA_VUELO) 
SELECT PAS_PASAJE,'JAG', '7D9851', 'BO777', '13/02/2014' FROM PASAJE
WHERE PAS_PASAJE IN ('001H', '061B', '123E');

-- STAR WARS

-- Insertar registros en matar.

INSERT INTO MATAR (SITH_ASESINO, SITH_ASESINADO, CAPI, TEMPO)
SELECT 'ANAKIN SKYWALKER', NOMBRE_SITH,(SELECT MAX(NUM_CAP) FROM CAPITULOS WHERE NUM_TEMPO=3) AS NUM_CAP, 3 
FROM SITH
WHERE GRADO_SITH= 3 AND TIPO_SITH IS NULL;

INSERT INTO MATAR (SITH_ASESINO, SITH_ASESINADO, CAPI, TEMPO)
SELECT 'PALPATINE', NOMBRE_SITH,1,(SELECT MAX(NUM_TEMPO) FROM CAPITULOS WHERE NUM_CAP=1)AS NUM_TEMPO
FROM SITH
WHERE GRADO_SITH= 1 AND TIPO_SITH IS NULL;

-- Modificar convertir.

ALTER TABLE JEDI ADD (NUM_CAPITULO NUMBER(3), NUM_TEMPORADA  NUMBER(2), NOM_SITH VARCHAR2(60));

ALTER TABLE JEDI ADD (
  CONSTRAINT FK_JEDI_CAPTIULO FOREIGN KEY (NUM_CAPITULO, NUM_TEMPORADA) REFERENCES CAPITULOS (NUM_CAP,NUM_TEMPO),
  CONSTRAINT FK_JEDI_SITH FOREIGN KEY (NOM_SITH) REFERENCES SITH (NOMBRE_SITH));

UPDATE JEDI J
  SET (NUM_CAPITULO, NUM_TEMPORADA, NOM_SITH) = (SELECT NUM_CAPITULO, NUM_TEMPORADA, NOM_SITH
                                                   FROM CONVERTIR C
                                                   WHERE J.NOMBRE_JEDI=C.NOM_JEDI                                                   
                                                     AND (NUM_CAPITULO, NUM_TEMPORADA) = (SELECT MIN(NUM_CAPITULO), MIN(NUM_TEMPORADA)
                                                                                            FROM CONVERTIR C2
                                                                                            WHERE J.NOMBRE_JEDI=C2.NOM_JEDI
                                                                                            AND NUM_TEMPORADA = (SELECT MIN(NUM_TEMPORADA)
                                                                                                                    FROM CONVERTIR C3
                                                                                                                   WHERE J.NOMBRE_JEDI=C3.NOM_JEDI)))
 WHERE NOMBRE_JEDI in (SELECT NOM_JEDI FROM CONVERTIR);

 DROP TABLE CONVERTIR;
 
 --4- Se detecta que el analista ha cometido un error en el diseño y te mandan arreglarlo, la tabla
--COMENTAR es una relación M:M con una agregación a la ternaria, luego es un error que tenga 4 FK, por
--lo que se ha traducido el físico como si fuera una cuaternaria, resuelve el problema dejando las FK
--correctas para el diseño, elimina y crea lo que sea necesario, para resolverlo vas a tener que realizar una
--inserción en ACTUAR usando COMENTAR. Después de la inserción los campos PROBLEMA y
--SOLUCION, usando el campo COMENTARIO debe quedar de la siguiente forma: En “problema”
--meterás los 10 primeros caracteres del comentario correspondiente y en “solución” los 4 últimos, salvo
--que sea vacío que entonces pondrás ‘SIN PROBLEMA’, ‘SIN SOLUCIÓN’.

alter table COMENTAR drop constraint fk_comentar_personajes;
      
alter table COMENTAR drop constraint fk_comentar_localizaciones;
      
alter table COMENTAR drop constraint fk_comentar_capitulo;
      
insert into ACTUAR
  (select distinct NUM_CAP, NUM_TEMPO, NOM_PERSONAJE, CODIGO_LOC, nvl(substr(COMENTARIO,1,10),'SIN PROBLEMA'), 
  nvl(substr(comentario,length(comentario)-5),'SIN SOLUCION')
       from COMENTAR
       where (NUM_CAP, NUM_TEMPO, NOM_PERSONAJE, CODIGO_LOC) not in 
       (select CAPITULO, TEMPORADA, NOM_PERSONAJE, COD_LOC from ACTUAR));
      
alter table comentar add constraint fk_comentar_actuar foreign key (NUM_CAP, NUM_TEMPO, NOM_PERSONAJE, CODIGO_LOC)
references ACTUAR (CAPITULO, TEMPORADA, NOM_PERSONAJE, COD_LOC); 





