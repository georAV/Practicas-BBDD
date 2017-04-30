--1- Realiza un cursor sobre la tabla Bancos y sucursales, donde indiques el nombre del banco y el de cada sucursal. 
--Hazlo con Fecth y con FOR.

    /*CREATE TABLE BANCO(
    NOMBRE_BANCO VARCHAR(20));
    CREATE TABLE SUCURSAL(
    NOMBRE_SUCURSAL VARCHAR(20));
    INSERT INTO BANCO VALUES ('SANTANDER');
    INSERT INTO BANCO VALUES ('TRIODOS');
    INSERT INTO BANCO VALUES ('EVOBANK');
    INSERT INTO SUCURSAL VALUES ('AL');
    INSERT INTO SUCURSAL VALUES ('VEN');
    INSERT INTO SUCURSAL VALUES ('MAD');*/

    -- Con Fetch
        
        DECLARE 
            CURSOR NOMBRES_CURSOR IS
            SELECT NOMBRE_BANCO, NOMBRE_SUCURSAL FROM BANCO, SUCURSAL;
            V_NOM_BANCO BANCO.NOMBRE_BANCO%TYPE;
            V_NOM_SUCURSAL SUCURSAL.NOMBRE_SUCURSAL%TYPE;
        BEGIN
            OPEN NOMBRES_CURSOR;
            FETCH NOMBRES_CURSOR INTO V_NOM_BANCO, V_NOM_SUCURSAL;
            WHILE NOMBRES_CURSOR%FOUND
            LOOP
                DBMS_OUTPUT.PUT_LINE(V_NOM_BANCO||' , '|| V_NOM_SUCURSAL);
                FETCH NOMBRES_CURSOR INTO V_NOM_BANCO, V_NOM_SUCURSAL;
            END LOOP;
            CLOSE NOMBRES_CURSOR;
        END;
        
     --Con for
     
        DECLARE
            CURSOR NOMBRES2_CURSOR IS
            SELECT NOMBRE_BANCO, NOMBRE_SUCURSAL FROM BANCO, SUCURSAL;
        BEGIN
        FOR i IN NOMBRES2_CURSOR
        LOOP
            DBMS_OUTPUT.PUT_LINE(i.NOMBRE_BANCO|| ' , ' ||i.NOMBRE_SUCURSAL);
        END LOOP;
        END;
        
--2- Crea un campo en la tabla Cuenta, llamándolo “Rentable”, 
--recorre la tabla Cuenta y si el haber es mayor que el debe actualizar a S de los contrario a N, 
--sumando las rentables y las no rentables y sacándolas por pantalla al final. Usa ROWID para hacerlo 
--(identificador único para cada registros de una BD).
       
   /* CREATE TABLE CUENTA(
    RENTABLE VARCHAR2(1),
    HABER NUMBER,
    DEBER NUMBER);

    INSERT INTO CUENTA VALUES (NULL, 20, 10);
    INSERT INTO CUENTA VALUES (NULL, 0, 40);*/
    
    DECLARE
        CURSOR CUENTA_CURSOR IS
        SELECT ROWID, HABER, DEBER FROM CUENTA;
        SUMA_RENTABLES NUMBER :=0;
        SUMA_N_RENTABLES NUMBER:=0;
    BEGIN
        FOR i IN CUENTA_CURSOR
        LOOP
            IF i.HABER>i.DEBER THEN
                UPDATE CUENTA SET RENTABLE='S' WHERE ROWID=i.ROWID;
                SUMA_RENTABLES:=SUMA_RENTABLES+1;
            ELSE
                UPDATE CUENTA SET RENTABLE='N' WHERE ROWID=i.ROWID;
                SUMA_N_RENTABLES:=SUMA_N_RENTABLES+1;
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('RENTABLES : '||SUMA_RENTABLES||' . No rentables : ' || SUMA_N_RENTABLES);
    END;
    
-- 3- Mira de realizar lo anterior con una UPDATE Masiva.
    
    UPDATE CUENTA SET RENTABLE= DECODE (SIGN(HABER-DEBER), -1, 'N', 'S');

-- 4- Utiliza un cursor y un bucle LOOP simple para recuperar y mostrar los datos de todos Los productos. 
-- Indica al final cuantos productos hay.
    
     /*INSERT INTO PRODUCTOS VALUES ('VVVV1', 'FRESAS', 3);
       INSERT INTO PRODUCTOS VALUES ('VVVV2', 'TOMATES', 1);
       INSERT INTO PRODUCTOS VALUES ('VVVV3', 'KIWIS', 2);*/
       
     DECLARE
         CURSOR PRODUCTOS_CURSOR IS SELECT * FROM PRODUCTOS;
         V_CODIGO PRODUCTOS.CODIGO%TYPE;
         V_DESCR PRODUCTOS.DESCRIPCION%TYPE;
         V_PRECIO PRODUCTOS.PRECIO%TYPE;
         CONTADOR NUMBER :=0;
     BEGIN
        OPEN PRODUCTOS_CURSOR;
        LOOP
            FETCH PRODUCTOS_CURSOR INTO V_CODIGO, V_DESCR, V_PRECIO;
            EXIT WHEN PRODUCTOS_CURSOR%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Codigo: '|| V_CODIGO || ' , Descripción: ' || V_DESCR || ' , Precio: ' || V_PRECIO || ' €.');
            CONTADOR:=CONTADOR+1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE ('Total productos: ' ||CONTADOR);
        CLOSE PRODUCTOS_CURSOR;
     END;
    
-- 5- Usa el cursor del loop directamente en el bucle

     DECLARE
        CURSOR PRODUCTOS_CURSOR IS SELECT * FROM PRODUCTOS;
        CONTADOR NUMBER :=0;
     BEGIN
        FOR i IN PRODUCTOS_CURSOR
        LOOP
            DBMS_OUTPUT.PUT_LINE('Codigo: '|| i.CODIGO || ' , Descripción: ' || i.DESCRIPCION || ' , Precio: ' || i.PRECIO || ' €.');
            CONTADOR:=CONTADOR+1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE ('Total productos: ' ||CONTADOR);
     END;
     
-- 6- Usa ahora un while
    
    DECLARE
        CURSOR PRODUCTOS_CURSOR IS SELECT * FROM PRODUCTOS;
        V_CODIGO PRODUCTOS.CODIGO%TYPE;
        V_DESCR PRODUCTOS.DESCRIPCION%TYPE;
        V_PRECIO PRODUCTOS.PRECIO%TYPE;
        CONTADOR NUMBER :=0;
    BEGIN
        OPEN PRODUCTOS_CURSOR;
        FETCH PRODUCTOS_CURSOR INTO V_CODIGO, V_DESCR, V_PRECIO;
        WHILE PRODUCTOS_CURSOR%FOUND
        LOOP
            DBMS_OUTPUT.PUT_LINE('Codigo: '|| V_CODIGO || ' , Descripción: ' || V_DESCR || ' , Precio: ' || V_PRECIO || ' €.');
            FETCH PRODUCTOS_CURSOR INTO V_CODIGO, V_DESCR, V_PRECIO;
            CONTADOR:=CONTADOR+1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE ('Total productos: ' ||CONTADOR);
        CLOSE PRODUCTOS_CURSOR;
     END;
     
-- 7-

        CREATE TABLE ALUMNOS (
        NUMMATRICULA NUMBER NOT NULL,
        NOMBRE VARCHAR2(15),
        APELLIDOS VARCHAR2(30),
        TITULACION VARCHAR2(15),
        PRECIOMATRICULA NUMBER, 
        CONSTRAINT PK_ALUMNOS PRIMARY KEY (NUMMATRICULA));
        
        CREATE TABLE ALUMNOSINF(
        IDMATRICULA NUMBER NOT NULL,
        NOMRE_APELLIDOS VARCHAR2(50),
        PRECIO NUMBER,
        CONSTRAINT PK_ALUMNOSINF PRIMARY KEY (IDMATRICULA));
    
        INSERT INTO ALUMNOS VALUES (1, 'JUAN', 'ÁLVAREZ', 'ADMINISTRATIVO', 1000);
        INSERT INTO ALUMNOS VALUES (2, 'JOSÉ', 'JIMENEZ', 'INFORMATICA', 1200);
        INSERT INTO ALUMNOS VALUES (3, 'MARIA', 'PÉREZ', 'ADMINISTRATIVO', 1000);
        INSERT INTO ALUMNOS VALUES (4, 'ELENA', 'MARTÍNEZ', 'INFORMATICA', 1200);
        
        DECLARE
            CURSOR ALUMNOS_CURSOR IS
            SELECT * FROM ALUMNOS;
            NOM_APE VARCHAR(50);
        BEGIN
            FOR i IN ALUMNOS_CURSOR
            LOOP
                IF i.TITULACION='INFORMATICA' THEN
                    DBMS_OUTPUT.PUT_LINE(i.NOMBRE || ', '|| i.APELLIDOS);
                    NOM_APE:=i.NOMBRE ||' ' || i.APELLIDOS;
                    INSERT INTO ALUMNOSINF VALUES(i.NUMMATRICULA, NOM_APE, i.PRECIOMATRICULA);
                END IF;
            END LOOP;
        END;
        
-- 8- 

    INSERT INTO DEPARTAMENTO VALUES (1, 'A', NULL, 100, NULL, NULL);
    INSERT INTO DEPARTAMENTO VALUES (2, 'B', NULL, 50, NULL, NULL);
    INSERT INTO DEPARTAMENTO VALUES (3, 'C', NULL, 20, NULL, NULL);
    
    
    INSERT INTO EMPLEADO VALUES (123, 'PEPE', 'GERENTE', NULL, NULL, 10, NULL, 1);
    INSERT INTO EMPLEADO VALUES (124, 'JUAN', 'COMERCIAL', NULL, NULL, 20, NULL, 2);
    INSERT INTO EMPLEADO VALUES (125, 'JESUS', 'ADMINIST', NULL, NULL, 30, NULL, 3);
    INSERT INTO EMPLEADO VALUES (126, 'PABLO', 'ADMINIST', NULL, NULL, 30, NULL, 3);

   -- A) Rellenar la columna presupuesto teniendo en cuenta las subidas de salario segun la profesión de los empleados.
   
   DECLARE
        CURSOR EMP_CURSOR IS SELECT CATEGORIA, SALARIO, NUM_DEPARTAMENTO FROM EMPLEADO;
   BEGIN
        FOR i IN EMP_CURSOR
        LOOP
            IF i.CATEGORIA ='GERENTE' THEN
                UPDATE DEPARTAMENTO SET PRESUPUESTO=PRESUPUESTO + (i.SALARIO + (i.SALARIO*20/100))
                WHERE NUM_DEPART=i.NUM_DEPARTAMENTO;
            ELSIF i.CATEGORIA='COMERCIAL' THEN
                UPDATE DEPARTAMENTO SET PRESUPUESTO=PRESUPUESTO + (i.SALARIO + (i.SALARIO*20/100))
                WHERE NUM_DEPART=i.NUM_DEPARTAMENTO;
            ELSE
                UPDATE DEPARTAMENTO SET PRESUPUESTO=PRESUPUESTO + (i.SALARIO + (i.SALARIO*20/100))
                WHERE NUM_DEPART=i.NUM_DEPARTAMENTO;
            END IF;
        END LOOP;
   END;
   
   -- B) Actualizar TOTAL_SALARIOS Y MEDIA_SALARIOS de DEPARTAMENTOS.
   -- Crear un cursor que devuelva los departamentos y otro que devuelva el salario y el codigo de empleado del departamento.
   
   DECLARE
   
        CURSOR EMP_CURSOR IS SELECT NOMBRE_EMPLEADO, SALARIO, NUM_DEPARTAMENTO FROM EMPLEADO;
        CURSOR MEDIA_CURSOR IS SELECT COUNT(*) CANTIDAD, NUM_DEPARTAMENTO FROM EMPLEADO GROUP BY NUM_DEPARTAMENTO;
        
   BEGIN
        FOR i IN EMP_CURSOR
        LOOP
            DBMS_OUTPUT.PUT_LINE(i.NOMBRE_EMPLEADO||','|| i.SALARIO||','|| i.NUM_DEPARTAMENTO);
            FOR j IN (SELECT * FROM DEPARTAMENTO WHERE NUM_DEPART = i.NUM_DEPARTAMENTO)
            LOOP
                UPDATE DEPARTAMENTO SET TOTAL_SALARIOS=TOTAL_SALARIOS + i.SALARIO
                WHERE j.NUM_DEPART= i.NUM_DEPARTAMENTO AND NUM_DEPART=j.NUM_DEPART;
                DBMS_OUTPUT.PUT_LINE(j.NOMBRE_DEPART);
            END LOOP;
        END LOOP;
        FOR i IN MEDIA_CURSOR
        LOOP
            UPDATE DEPARTAMENTO SET MEDIA_SALARIOS=TOTAL_SALARIOS/i.CANTIDAD 
            WHERE i.NUM_DEPARTAMENTO=NUM_DEPART;
        END LOOP;
   END;
   
-- 9. Crear una tabla NOTAS con los atributos necesarios.
-- Construir un bloque que inserte en la tabla NOTAS 4 filas para cada alumno.
-- Cada fila corresponde a una convocatoria, 3 ordinarias y una extraordinaria.
-- Antes de isertar, comprobar que no están creadas.
-- Las filas deben inicializarse a nulo.

    CREATE TABLE NOTAS (
    NUMMATRICULA NUMBER(10) NOT NULL,
    ASIGNATURA VARCHAR2(20),
    CONVOCATORIA VARCHAR2(20) NOT NULL,
    NOTA NUMBER,
    CONSTRAINT PK_NOTAS PRIMARY KEY (NUMMATRICULA, CONVOCATORIA)
    );

    DECLARE
        CURSOR ALUMNOS_CURSOR IS SELECT * FROM ALUMNOS;
        NUMERO_CONV NUMBER :=0;
    BEGIN
        FOR i IN ALUMNOS_CURSOR
        LOOP
            SELECT COUNT(*) INTO NUMERO_CONV FROM NOTAS WHERE NUMMATRICULA=i.NUMMATRICULA;
            IF NUMERO_CONV=0 THEN
                INSERT INTO NOTAS VALUES(i.NUMMATRICULA, 'PROGRAMACION', 'ORD1', NULL);
                INSERT INTO NOTAS VALUES(i.NUMMATRICULA, 'PROGRAMACION', 'ORD2', NULL);
                INSERT INTO NOTAS VALUES(i.NUMMATRICULA, 'PROGRAMACION', 'ORD3', NULL);
                INSERT INTO NOTAS VALUES(i.NUMMATRICULA, 'PROGRAMACION', 'EXT', NULL);  
           END IF;   
        END LOOP;
    END;
    
-- 10. Crear un bloque que almacene en la tabla AUX_ARTICULOS
-- un número dado de los artículos con mayor precio de la tabla.
-- El número de artículos a almacenar debe ser dado por teclado.

    CREATE TABLE AUX_ARTICULOS AS SELECT * FROM PRODUCTOS;
    DELETE AUX_ARTICULOS;
    
    DECLARE
        CURSOR PROD_CURSOR IS SELECT * FROM PRODUCTOS ORDER BY PRECIO DESC;
        NUMERO NUMBER:= '&VALOR';
        CONTADOR NUMBER:= 0;
        V_REGISTRO PROD_CURSOR%ROWTYPE;
    BEGIN
        OPEN PROD_CURSOR;
        LOOP
            FETCH PROD_CURSOR INTO V_REGISTRO;
            EXIT WHEN CONTADOR=NUMERO;
            INSERT INTO AUX_ARTICULOS VALUES (V_REGISTRO.CODIGO, V_REGISTRO.DESCRIPCION, V_REGISTRO.PRECIO);
            CONTADOR:=CONTADOR+1;
        END LOOP;
        CLOSE PROD_CURSOR;
   END;
   
--11. Recuperar los proveedores por paises.
-- El resultado debe almacenarse en una nueva tabla Tabla_Aux.
-- con columnas proveedor y país.

-- Utilizar un cursor para recuperar cada pais de la tabla Tabla_Proveedores
-- Y pasar dicho país a un cursor que obtenga el nombre de los proveedores.
-- Una vez obtenido esto, añardirse a la nueva tabla.
-- Crear las dos tablas.

    
    CREATE TABLE TABLA_PROVEEDORES(
    PROVEEDOR VARCHAR2(60) NOT NULL,
    PAIS VARCHAR2 (60),
    CONSTRAINT PK_PROVE PRIMARY KEY (PROVEEDOR));
    
    CREATE TABLE TABLA_AUX(
    PROV_AUX VARCHAR2 (60) NOT NULL,
    PAIS_AUX VARCHAR2(60),
    CONSTRAINT PK_AUX PRIMARY KEY (PROV_AUX),
    CONSTRAINT FK_PROV_AUX FOREIGN KEY (PROV_AUX) REFERENCES TABLA_PROVEEDORES (PROVEEDOR)
    );
    
    INSERT INTO TABLA_PROVEEDORES VALUES ('PROV1', 'ESPAÑA');
    INSERT INTO TABLA_PROVEEDORES VALUES ('PROV2', 'ESPAÑA');
    INSERT INTO TABLA_PROVEEDORES VALUES ('PROV3', 'ALEMANIA');
    
    DECLARE
        CURSOR PAIS_CURSOR IS SELECT PAIS FROM TABLA_PROVEEDORES GROUP BY PAIS;
    BEGIN
        FOR i IN PAIS_CURSOR
        LOOP
            FOR j IN (SELECT * FROM TABLA_PROVEEDORES WHERE PAIS=i.PAIS)
            LOOP
                INSERT INTO TABLA_AUX VALUES (j.PROVEEDOR,j.PAIS);
                DBMS_OUTPUT.PUT_LINE('Proveedor: '||j.PROVEEDOR || ', País: ' ||j.PAIS);
            END LOOP;
        END LOOP;
    END;
    

-- 12. Crea un cursor que obtenga por pantalla los datos de vuelo:
-- Nombre Aeropuerto Origen, nombre aeropuerto destino, director de cada uno si lo tuviera, 
-- año de vuelo y numero de veces que se efectua por año.
            
    DECLARE
        CURSOR AERO_CURSOR IS 
            SELECT VO.NUM_VUELO VUELO, COD_AERO_DESPEGAR, COD_AERO_ATERRIZAR, DIR1.NOMBRE UNO, DIR2.NOMBRE DOS,TO_CHAR(FECHA_VUELO,'YYYY') FECHA, COUNT(*) VECES
            FROM PROGRAMA_VUELO PR, VOLAR VO, DIRECTOR DIR1, DIRECTOR DIR2, AEROPUERTOS AE1, AEROPUERTOS AE2
            WHERE PR.NUM_VUELO=VO.NUM_VUELO
              AND DIR1.COD_AEROPUERTO=AE1.CODIGO AND AE1.CODIGO=PR.COD_AERO_DESPEGAR
              AND DIR2.COD_AEROPUERTO=AE2.CODIGO AND AE2.CODIGO=PR.COD_AERO_ATERRIZAR
            GROUP BY VO.NUM_VUELO, TO_CHAR(FECHA_VUELO,'YYYY'), COD_AERO_DESPEGAR, COD_AERO_ATERRIZAR, DIR1.NOMBRE, DIR2.NOMBRE
            ORDER BY VECES DESC;
            
    BEGIN
        
            FOR i IN AERO_CURSOR
            LOOP

                DBMS_OUTPUT.PUT_LINE('Vuelo: '||i.VUELO||' -- Origen: '||i.COD_AERO_DESPEGAR||' -- Destino: '||i.COD_AERO_ATERRIZAR||' -- Dir.Origen: '||i.UNO
                                        ||' -- Dir.Destino: '||i.DOS||' -- Año: '||i.FECHA||' -- Veces/año: '||i.VECES);
            END LOOP;
    END;
   
    
    
    