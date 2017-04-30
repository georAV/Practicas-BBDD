--1.- ¿Funcionaria el siguiente código?. Explicar por qué y como
--solucionarlo (si se os ocurren varias formas de arreglarlo, explicarlas todas).

    -- No funciona. Hay ambigüedad en los nombres. PL/SQL da preferencia a los nombres de variables y parámtros, 
    -- entonces al hacer UPDATE dept se está referenciando al contador del loop, no a la tabla.
    -- La solución es cambiar el nombre del contador del loop 
        
        DECLARE
            base NUMBER:=100;
        BEGIN
            FOR i IN 1..10 
            LOOP
                UPDATE dept SET nom_dept=base+i
                WHERE cod_dept=base+i;
            END LOOP;
        END;
        
    -- o llamar a la tabla con el usuario.tabla
    
        DECLARE
            base NUMBER:=100;
        BEGIN
            FOR dept IN 1..10 
            LOOP
                UPDATE usuario.dept SET nom_dept=base+dept
                WHERE cod_dept=base+dept;
            END LOOP;
        END;
        
--2- ¿Qué ocurriría al ejecutar el siguiente código?, ¿Por qué?, ¿Cómo arreglarlo? 
--(Si existen varias posibilidades, comentarlas e indicar cual sería más eficiente).

    -- Que borraria todas las filas. PL/SQL da prioridad a los nombres de las columnas sobre los nombres
    -- de las variables, entonces la variable que se menciona en el where se interpreta como si fuera la columna.
    -- Para arreglarlo hay que cambiar el nombre de la variable, siendo ésta solución la más eficiente.

        DECLARE
            nombre VARCHAR2(40):='Fernandez';
        BEGIN
            DELETE FROM emp WHERE ap1_emp=nombre;
            COMMIT;
        END;
        
    
--3.- ¿Es correcto el siguiente código en PL/SQL?, ¿Por qué? Nota:Ignorar el funcionamiento del código (no hace nada), 
-- ceñirse exclusivamente a la sintaxis válida en PL/SQL.

    FOR ctr IN 1..10 
    LOOP
        IF NOT fin THEN
            INSERT INTO temp
            VALUES (ctr, 'Hola');
            COMMIT;
            factor:=ctr*2;
        ELSE
            ctr:=10;
        END IF;
    END LOOP;
    
    -- No es correcto porque dentro de un LOOP el contador del FOR puede ser referenciado pero no se le puede asignar
    -- ningún valor. Entonces la sentencia que  hay en el ELSE (crt:=10;) no es valida.
    
-- 4.- ¿Qué resultado provoca la ejecución del siguiente código PL/SQL?

    DECLARE
        variable NUMBER:=1;
        almacenamos NUMBER:=1;
    BEGIN
        FOR i IN 5..variable LOOP
        almacenamos:=almacenamos+i;
        END LOOP;
        INSERT INTO traza VALUES(TO_CHAR(almacenamos));
        COMMIT;
    END;
    
    -- Insertará en la tabla una cadena de caracteres con el valor que tome la variable
    -- después de terminar el bucle.
    
--5- ¿Qué da este bloque?

    DECLARE
        V_num NUMBER;
    BEGIN
        SELECT COUNT(*) INTO V_num
        FROM productos;
        DBMS_OUTPUT.PUT_LINE(V_num);
    END;
    
    -- Saca el recuento de productos y asigna ese valor a la variable V_num.
    -- Después imprime ese valor.
    
-- 6- Crea una tabla MENSAJES con un solo campo VALOR, de tipo VARCHAR2(5). 
-- Crea un bloque que inserte 8 elementos en la tabla con valores del 1 al 10, excepto el 4 y 5.

    CREATE TABLE MENSAJES (
    VALOR VARCHAR2(5)
    );

    DECLARE
    BEGIN
        FOR i IN 1..10
        LOOP
            IF (i !=4 AND i!=5) THEN
            INSERT INTO MENSAJES VALUES ((TO_CHAR(i))); 
            END IF;
        END LOOP;
    END;
    
   -- DELETE MENSAJES;

--7- Vuelve a usar la tabla anterior con los datos ya rellenos, 
--y si el número que insertas es menor que 4 entonces debes sacar un mensaje de error si ya existe, 
--si el número es mayor o igual que 4, debes insertarlo si no existe y actualizarlo sumándole 1 si ya existe.

    DECLARE
    BEGIN
        FOR i IN 1..10
        LOOP
            IF i<4 THEN
                DBMS_OUTPUT.PUT_LINE('El número ya existe');
            ELSIF i=4 THEN
                INSERT INTO MENSAJES VALUES (i);
            ELSE
                UPDATE MENSAJES SET valor=(TO_CHAR(i+1)) WHERE valor=i; 
            END IF;
        END LOOP;
    END;
 
-- 8- Crea una tabla PRODUCTO(CODPROD, NOMPROD, PRECIO), usando SQL (no uses un bloque PL/SQL).
-- Añade un producto a la tabla usando una sentencia insert dentro de un bloque PL/SQL.

    CREATE TABLE PRODUCTO(
    CODPROD VARCHAR2(10) NOT NULL,
    NOMPROD VARCHAR2(30),
    PRECIO NUMBER,
    CONSTRAINT PK_PRODUCTO PRIMARY KEY (CODPROD)
    );

    DECLARE
    BEGIN
    INSERT INTO PRODUCTO VALUES ('D234','CHOCOLATE',2.25);
    END;
    
-- 9. Añade otro producto, ahora utilizando una lista de variables en la sentencia insert.

    DECLARE
        COD_1 VARCHAR2 (30):='R891';
        NOM_1 VARCHAR2 (30):='VAINILLA';
        PRE_1 NUMBER:=3.10;
    BEGIN
        INSERT INTO PRODUCTO VALUES(COD_1, NOM_1, PRE_1);
    END;
    
-- 10. Añade, ahora usando un registro PL/SQL, dos produtos más.
 
    DECLARE
        PROD_2 PRODUCTO%ROWTYPE;
        PROD_3 PRODUCTO%ROWTYPE;
        
    BEGIN
        PROD_2.CODPROD:='T765';
        PROD_2.NOMPROD:='LIMON';
        PROD_2.PRECIO:=1.90;
        
        PROD_3.CODPROD:='B654';
        PROD_3.NOMPROD:='FRESA';
        PROD_3.PRECIO:=2.20;
        
        
        INSERT INTO PRODUCTO VALUES (PROD_2.CODPROD, PROD_2.NOMPROD, PROD_2.PRECIO);
        INSERT INTO PRODUCTO VALUES (PROD_3.CODPROD, PROD_3.NOMPROD, PROD_3.PRECIO);
    END;
    
    -- También he visto que se puede hacer así
    
    DECLARE
        TYPE PROD IS RECORD
        (CODPROD VARCHAR2(30),
         NOMPROD VARCHAR2 (30),
         PRECIO NUMBER);
         
        PROD_2 PROD;
        PROD_3 PROD;
        
    BEGIN
        PROD_2.CODPROD:='T765';
        PROD_2.NOMPROD:='LIMON';
        PROD_2.PRECIO:=1.90;
        
        PROD_3.CODPROD:='B654';
        PROD_3.NOMPROD:='FRESA';
        PROD_3.PRECIO:=2.20;
        
        
        INSERT INTO PRODUCTO VALUES (PROD_2.CODPROD, PROD_2.NOMPROD, PROD_2.PRECIO);
        INSERT INTO PRODUCTO VALUES (PROD_3.CODPROD, PROD_3.NOMPROD, PROD_3.PRECIO);
    END;
    
-- 11. Borra el primer producto insertado, e incrementa el precio de los demás en un 5%.

    DECLARE
    BEGIN
        DELETE FROM PRODUCTO WHERE NOMPROD='CHOCOLATE';
        UPDATE PRODUCTO SET PRECIO= PRECIO+(PRECIO*5/100);
    END;
    
--12. Obtén y muestra por pantalla el número de productos que hay almacenados, 
-- usando select ... Into y el mensaje “Hay n productos”.

    DECLARE
        numero number;
    BEGIN
        SELECT COUNT(*) INTO numero FROM PRODUCTO;
        DBMS_OUTPUT.PUT_LINE('Hay '||numero||' productos.');
    END;
    
-- 13. Obtén y muestra todos los datos de un producto (busca a partir de la clave primaria, 
-- escogiendo un código de producto existente. Usa select ... into y un registro PL/SQL.

    DECLARE
        P_NOMBRE VARCHAR2(30);
        P_PRECIO NUMBER;
    BEGIN
        SELECT NOMPROD, PRECIO INTO P_NOMBRE, P_PRECIO FROM PRODUCTO WHERE CODPROD='R891';
        DBMS_OUTPUT.PUT_LINE('Los datos del producto R891 son, nombre: '||P_NOMBRE|| ' y precio: '||P_PRECIO||' €');
    END;
    
-- 14- Haz un bloque PL/SQL, de forma que se indique que no hay productos, 
-- que hay pocos (si hay entre 1 y 3) 
-- o el número exacto de produtos existentes (si hay más de 3).

    DECLARE
        contador NUMBER;
    BEGIN
        SELECT COUNT(*) INTO contador FROM PRODUCTO;
        IF contador=0 THEN
            DBMS_OUTPUT.PUT_LINE('No hay productos.');
        ELSIF contador >=1 AND contador <=3 THEN
            DBMS_OUTPUT.PUT_LINE('Hay pocos productos.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Hay '||contador||' productos.');
        END IF;
    END;    