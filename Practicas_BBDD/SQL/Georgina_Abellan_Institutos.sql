-- INSTITUTOS

--SELECTS

/* 1. Nom, poblacio, extensio y densitat de poblacio*/

SELECT NOM, POBLACIO, EXTENSIO, (POBLACIO/EXTENSIO) DENSITAT FROM POBLACIONS;

/*2.-Saca las distintas localidades donde haya institutos (cada localidad solo ha de salir una vez)*/

SELECT NOM FROM POBLACIONS WHERE NOM IN (SELECT LOCALITAT FROM INSTITUTS);

/*3.- Saca las poblaciones de habla valenciana que estén a más de 1.000 de altura.*/

SELECT * FROM POBLACIONS WHERE LLENGUA = 'V' AND ALTURA>1000;

/*4.- Saca las poblaciones de una densidad de población de más de 200 h/Km2 y una altura de más de 500 m.*/

SELECT * FROM POBLACIONS WHERE (POBLACIO/EXTENSIO)>200 AND ALTURA>500;

/*5.- Saca el número de comarcas de cada provincia.*/

SELECT COUNT(*) FROM COMARQUES GROUP BY PROVINCIA;

/*6.- Saca todas las poblaciones, ordenadas por comarca, y dentro de la misma comarca por nombre.*/

SELECT NOM, PO.NOM_C FROM POBLACIONS PO, COMARQUES CO WHERE PO.NOM_C= CO.NOM_C ORDER BY NOM_C, NOM;

-- o también...

SELECT * FROM POBLACIONS PO WHERE PO.NOM_C IN (SELECT CO.NOM_C FROM COMARQUES CO) ORDER BY NOM_C, NOM;

/* 7.- Saca las poblaciones de la comarca de l'Alt Maestrat, ordenadas por altura de forma descendente.*/

SELECT NOM FROM POBLACIONS WHERE NOM_C='Alt Maestrat' ORDER BY ALTURA DESC;

-- o también

SELECT * FROM POBLACIONS WHERE NOM_C='Alt Maestrat' ORDER BY ALTURA DESC;

--AGRUPACIONES.

/*1.- Calcular el número de Institutos de cada población.
Solamente obtener aquellas poblaciones que tienen institutos*/

SELECT LOCALITAT, COUNT(*) INSTITUTOS FROM INSTITUTS GROUP BY LOCALITAT HAVING COUNT(*)>=1;

/*2.- Saca las comarcas de más de 100.000 habitantes.*/

SELECT CO.NOM_C, SUM(POBLACIO)HABITANTES 
FROM COMARQUES CO, POBLACIONS PO 
WHERE CO.NOM_C = PO.NOM_C
GROUP BY CO.NOM_C HAVING SUM(POBLACIO)>100000;

/*3.- Saca la densidad de población de cada comarca, ordenada por esta de forma descendente.*/

SELECT CO.NOM_C, SUM(POBLACIO/EXTENSIO) DENSIDAD
FROM COMARQUES CO, POBLACIONS PO
WHERE CO.NOM_C=PO.NOM_C
GROUP BY CO.NOM_C
ORDER BY DENSIDAD DESC;

/* 4. Cuenta cuantas lenguas son originarias de cada comarca.*/

SELECT NOM_C, COUNT(DISTINCT LLENGUA)
FROM POBLACIONS 
GROUP BY NOM_C;


--INNER Y OUTER JOIN

/* 1. Saca todas las poblaciones, ordenadas por provincia, 
dentro de la misma provincia por comarca, 
y dentro de cada comarca por nombre de la población.*/

SELECT PO.NOM, PO.NOM_C, PROVINCIA FROM POBLACIONS PO, COMARQUES CO
WHERE PO.NOM_C = CO.NOM_C ORDER BY  PO.NOM_C, PROVINCIA, PO.NOM;

--2.- Saca el número de habitantes de cada población y su cantidad de institutos (incluyendo los que no tienen).

SELECT PO.NOM, POBLACIO, COUNT(LOCALITAT)FROM POBLACIONS PO, INSTITUTS INS
WHERE PO.NOM=LOCALITAT(+)
GROUP BY PO.NOM, POBLACIO;

/*3. Saca el número de habitantes por instituto de aquellas poblaciones que tienen instituto.*/

SELECT DISTINCT PO.NOM, POBLACIO/COUNT(*) FROM POBLACIONS PO, INSTITUTS
WHERE PO.NOM= LOCALITAT 
GROUP BY PO.NOM, POBLACIO ORDER BY PO.NOM;

/*4.- Saca cuátos pueblos hablan valenciano en cada comarca, indicando también la provincia.*/

SELECT DISTINCT CO.NOM_C, PROVINCIA FROM POBLACIONS PO, COMARQUES CO
WHERE PO.NOM_C= CO.NOM_C AND LLENGUA='V' ORDER BY CO.NOM_C;

/*5.- Saca las comarcas y el numero institutos de cada comarca, incluyento aquellos que no tienen ninguno.*/

SELECT DISTINCT CO.NOM_C, COUNT(*) FROM COMARQUES CO, INSTITUTS INS, POBLACIONS PO
WHERE CO.NOM_C=PO.NOM_C AND PO.NOM(+)=LOCALITAT
GROUP BY CO.NOM_C;

--SUBCONSULTAS

/* 1.- Saca los pueblos con más habitantes que la media.*/

SELECT * FROM POBLACIONS WHERE POBLACIO > (SELECT AVG(POBLACIO) FROM POBLACIONS);

/*2.- Saca toda la información del pueblo con menos habitantes que tenga instituto*/

SELECT * FROM POBLACIONS WHERE POBLACIO=(SELECT MIN(POBLACIO)FROM POBLACIONS WHERE NOM IN (SELECT LOCALITAT FROM INSTITUTS));

/*3.- Saca los pueblos de más de 2.000 h. que no tengan instituto. */

SELECT * FROM POBLACIONS WHERE POBLACIO>2000 AND NOM NOT IN (SELECT LOCALITAT FROM INSTITUTS);

/*5.- Saca las comarcas que tienen más institutos que la media.*/

SELECT DISTINCT NOM_C FROM POBLACIONS WHERE NOM IN 
(SELECT LOCALITAT FROM INSTITUTS
GROUP BY LOCALITAT HAVING COUNT(*) >
(SELECT TRUNC(AVG(COUNT(*))) FROM INSTITUTS GROUP BY LOCALITAT));



