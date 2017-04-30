--MUNDIAL

--1- Jugadores que hayan jugado partidos y si no lo han hecho que salgan también,
--debe salir nombre, los equipos que se enfrentaron y el resultado.


SELECT DISTINCT NOMBRE_JUG, EQUIPO_L_PART, EQUIPO_V_PART, RESULTADO_L, RESULTADO_V
FROM JUGAR, PARTIDO
WHERE FECHA_PART=FECHA
UNION
SELECT DISTINCT NOMBRE, NULL, NULL, NULL ,NULL FROM JUGADOR;

--2- El gol más tempranero en cualquier MUNDIAL, saca el minuto, el jugador y el
--partido donde se produjo.

SELECT MINUTO, JUGADOR_GOL, EQUIPO_L_GOL, EQUIPO_V_GOL FROM GOL
WHERE MINUTO= (SELECT MIN(MINUTO) FROM GOL);

-- 3- Saca los delanteros de los equipos que hagan de local que hayan empatado
-- partidos, quitando duplicados.

SELECT DISTINCT NOMBRE FROM JUGADOR, JUGAR, PARTIDO
WHERE PUESTO_JUGAR='DL'
AND EQUIPO_JUGADOR=EQUIPO_L AND NOMBRE_JUG=NOMBRE
AND RESULTADO_L=RESULTADO_V;

--4- Saca todos los jugadores que han jugado en un puesto no habitual al suyo

SELECT NOMBRE FROM JUGADOR, JUGAR 
WHERE NOMBRE=NOMBRE_JUG AND PUESTO_HAB!=PUESTO_JUGAR;

--5- Saca el nombre del jugador que haya marcado el gol más tempranero y el árbitro
--mayor alfabéticamente.

SELECT JUGADOR_GOL FROM GOL 
WHERE MINUTO=(SELECT MIN(MINUTO) FROM GOL)
UNION
SELECT MAX(NOMBRE) FROM ARBITRO;

--6- Muestra la cantidad de goles, la selección a la que pertenece y el máximo goleador
--de todas las primeras partes de los partidos (La primera parte dura 45 minutos)

SELECT NOMBRE, EQUIPO_JUGADOR, COUNT(*) FROM JUGADOR, JUGAR
WHERE NOMBRE=NOMBRE_JUG AND NOMBRE_JUG IN
                                         (SELECT JUGADOR_GOL FROM GOL
                                         GROUP BY JUGADOR_GOL
                                         HAVING COUNT(*)=(SELECT MAX(COUNT(*)) FROM GOL 
                                         WHERE MINUTO <=45 GROUP BY JUGADOR_GOL))
GROUP BY NOMBRE, EQUIPO_JUGADOR;

--7- Muestra los equipos que hayan ganado partidos, sacando duplicados.

SELECT EQUIPO FROM EQUIPOS, PARTIDO
WHERE (EQUIPO=EQUIPO_L AND RESULTADO_L>RESULTADO_V)
OR (EQUIPO=EQUIPO_V AND RESULTADO_V>RESULTADO_L);

--8- Jugadores que hayan metido algún gol y hayan jugado menos de 3 partidos o que
--no hayan marcado ningún gol pero hayan jugado más de 5 partidos.

SELECT NOMBRE_JUG FROM JUGAR 
WHERE NOMBRE_JUG IN (SELECT JUGADOR_GOL FROM GOL)
GROUP BY NOMBRE_JUG HAVING COUNT(*)<3
UNION
SELECT NOMBRE_JUG FROM JUGAR
WHERE NOMBRE_JUG NOT IN (SELECT JUGADOR_GOL FROM GOL)
GROUP BY NOMBRE_JUG HAVING COUNT(*)>5;

--9- Una vista con el resultado que menos se haya dado.

CREATE VIEW RESULTADO_1 AS
(SELECT RESULTADO_L, RESULTADO_V FROM PARTIDO
GROUP BY RESULTADO_L, RESULTADO_V
HAVING COUNT(*)=(SELECT MIN(COUNT(*)) FROM PARTIDO GROUP BY RESULTADO_L, RESULTADO_V));

--10- Cuál es el resultado que más veces se ha dado en los Mundiales siempre que haya
--habido más de 3 goles

SELECT RESULTADO_L, RESULTADO_V FROM PARTIDO
GROUP BY RESULTADO_L, RESULTADO_V
HAVING COUNT(*)=(SELECT MAX(COUNT(*)) FROM PARTIDO 
                WHERE RESULTADO_L>3 OR RESULTADO_V>3 OR (RESULTADO_L+RESULTADO_V>=3)
                GROUP BY RESULTADO_L, RESULTADO_V);
