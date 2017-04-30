--1 , Realiza el ejercicio 6 de funciones, usando excepciones.

    --6- Crea una función llamada, PVP que toma como argumento un código de producto, una descripción y un coste del producto, 
    --y realice una inserción en una tabla PRODUCTOS si el código de producto (PK) no existe 
    --y en caso de existir actualice los datos de decripción y coste y devuelva el precio de venta al público, 
    --que resulta de aplicarle a ese precio de coste un margen comercial del 20%.
    
        CREATE OR REPLACE FUNCTION PVP (COD IN VARCHAR2, DES IN VARCHAR2, CSTE IN NUMBER) RETURN NUMBER
        AS
            CODIGO_2 VARCHAR2(5);
        BEGIN
            SELECT CODIGO INTO CODIGO_2 FROM PRODUCTOS WHERE CODIGO=COD;
            UPDATE PRODUCTOS SET DESCRIPCION=DES, PRECIO=CSTE WHERE CODIGO=CODIGO_2;
            RETURN (CSTE+(CSTE*20/100));
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE ('Insertando nuevo producto...');
            INSERT INTO PRODUCTOS VALUES (COD, DES, CSTE);
            RETURN (CSTE+(CSTE*20/100));
        END PVP;

    --Pruebo la funcion
    
        DECLARE
        BEGIN
         DBMS_OUTPUT.PUT_LINE ('Precio de venta: '||PVP('VVVV1', 'TOMATES ROJOS', 2)||' €');
         DBMS_OUTPUT.PUT_LINE ('Precio de venta: '||PVP('VVVV1', 'TOMATES VERDES', 4)||' €');
        END;

-- 2- Realiza el ejercicio anterior dando un mensaje de error en caso de que ya exista. (Sin hacer el update)
     
        CREATE OR REPLACE FUNCTION PVP2 (COD IN VARCHAR2, DES IN VARCHAR2, CSTE IN NUMBER) RETURN NUMBER
        AS
        BEGIN
            INSERT INTO PRODUCTOS VALUES (COD, DES, CSTE);
            RETURN (CSTE+(CSTE*20/100));
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE ('El producto ' ||COD|| ' ya existe.');
            RETURN (CSTE+(CSTE*20/100));
        END PVP2;
    
    --Pruebo la funcion
    
        DECLARE
        BEGIN
         DBMS_OUTPUT.PUT_LINE ('Precio de venta: '||PVP2('VVVV1', 'TOMATES ROJOS', 2)||' €');
         DBMS_OUTPUT.PUT_LINE ('Precio de venta: '||PVP2('VVVV2', 'TOMATES VERDES', 3)||' €');
        END;
        
--3 - Realiza el ejercicio anterior dando un mensaje de error en caso de que no existe. (Sin hacer el insert)

        CREATE OR REPLACE FUNCTION PVP3 (COD IN VARCHAR2, DES IN VARCHAR2, CSTE IN NUMBER) RETURN NUMBER
        AS
            CODIGO_2 VARCHAR2(5);
        BEGIN
            SELECT CODIGO INTO CODIGO_2 FROM PRODUCTOS WHERE CODIGO=COD;
            UPDATE PRODUCTOS SET DESCRIPCION=DES, PRECIO=CSTE WHERE CODIGO=CODIGO_2;
            RETURN (CSTE+(CSTE*20/100));
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE ('El producto no existe.');
            RETURN 0;
        END PVP3;
        
        --Pruebo la funcion
    
        DECLARE
        BEGIN
         DBMS_OUTPUT.PUT_LINE ('Precio de venta: '||PVP3('VVVV4', 'TOMATES ROJOS', 2)||' €');
        END;
        
-- 4- Provoca un error para que salte una excepción y captúrala antes de salir de la función.

    --Inserto un producto
    
        INSERT INTO PRODUCTOS VALUES ('VVVV5', 'TOMATES ROJOS', 2);
        
    -- Función que provoca error
        
        CREATE OR REPLACE FUNCTION PVP4 (COD IN VARCHAR2, DES IN VARCHAR2, CSTE IN NUMBER) RETURN VARCHAR2
        AS
            CODIGO_2 VARCHAR2(5);
        BEGIN
            SELECT CODIGO INTO CODIGO_2 FROM PRODUCTOS WHERE CODIGO=COD;
            INSERT INTO PRODUCTOS VALUES (CODIGO_2, DES, CSTE);
            RETURN (CSTE+(CSTE*20/100));
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE ('El producto ya existe');
            RETURN (CSTE+(CSTE*20/100));
        END PVP4;
        
        --Pruebo la funcion
    
        DECLARE
        BEGIN
         DBMS_OUTPUT.PUT_LINE (PVP4('VVVV5', 'TOMATES ROJOS', 2)|| ' €');
        END;
        
--5- Anida todas las excepciones posibles de los ejercicios anteriores en la misma función.

        CREATE OR REPLACE FUNCTION PVP5 (COD IN VARCHAR2, DES IN VARCHAR2, CSTE IN NUMBER) RETURN NUMBER
        AS
            CODIGO_2 VARCHAR2(5);
        BEGIN
            SELECT CODIGO INTO CODIGO_2 FROM PRODUCTOS WHERE CODIGO=COD;
            UPDATE PRODUCTOS SET CODIGO=CODIGO_2, DESCRIPCION=DES, PRECIO=CSTE WHERE CODIGO!=CODIGO_2;
            RETURN (CSTE+(CSTE*20/100));
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE ('El producto no existe.Insertando uno nuevo...');
            INSERT INTO PRODUCTOS VALUES (COD, DES, CSTE);
            RETURN (CSTE+(CSTE*20/100));
       
            WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE ('El producto ' ||COD|| ' ya existe.');
            RETURN (CSTE+(CSTE*20/100));
        END PVP5;
        
        --Pruebo la funcion
        
        BEGIN
         DBMS_OUTPUT.PUT_LINE (PVP5('VVVV6', 'TOMATES ROJOS', 2)); -- Este no encuentra datos
         DBMS_OUTPUT.PUT_LINE (PVP5('VVVV6', 'TOMATES ROJOS', 2)); -- Este dice que ya existe
        END;
        
--6-Muestra el número de productos, de forma que indique “No hay productos” en vez de “Hay 0 productos”.

    CREATE OR REPLACE FUNCTION PVP6 (COD IN VARCHAR2, DES IN VARCHAR2, CSTE IN NUMBER) RETURN NUMBER
    AS
        CONTADOR NUMBER;
        SIN_PRODUCTOS EXCEPTION;
    BEGIN
        SELECT COUNT(*) INTO CONTADOR FROM PRODUCTOS;
        IF CONTADOR>0 THEN
            RETURN CONTADOR;
        ELSE
            RAISE SIN_PRODUCTOS;
        END IF;
    EXCEPTION
    WHEN SIN_PRODUCTOS THEN
        DBMS_OUTPUT.PUT_LINE ('No hay productos.');
        RETURN 0;
    END PVP6;
    
    -- Pruebo la función
    DELETE PRODUCTOS;
    
    BEGIN
         DBMS_OUTPUT.PUT_LINE (PVP6('VVVV1', 'TOMATES ROJOS', 2));
    END;
        
-- 7- Crea un bloque PL/SQL en el que insertas un producto con código 3, ya existente. 
--Haz el control de excepciones de forma que un error de clave primaria duplicada se ignore 
--(no se inserta el producto pero el bloque PL/SQL se ejecuta correctamente). 
--Si intentamos insertar un producto con precio negativo, debe aparecer un error

    --Inserto el producto
    
    INSERT INTO PRODUCTOS VALUES ('3', 'PERAS', 3);
    
    -- Función
    
    CREATE OR REPLACE FUNCTION PVP7 (COD IN VARCHAR2, DES IN VARCHAR2, CSTE IN NUMBER) RETURN NUMBER
    AS
       PRECIO_NEGATIVO EXCEPTION;
    BEGIN
       IF CSTE>0 THEN
           INSERT INTO PRODUCTOS VALUES (COD, DES, CSTE);
           RETURN CSTE+(CSTE*20/100);
       ELSE
           RAISE PRECIO_NEGATIVO;
       END IF;
    EXCEPTION
        WHEN PRECIO_NEGATIVO THEN
        DBMS_OUTPUT.PUT_LINE ('El precio no puede ser negativo.');
    WHEN DUP_VAL_ON_INDEX THEN
        NULL;
    END PVP7;
    
    -- Pruebo la función
    
    BEGIN
         DBMS_OUTPUT.PUT_LINE (PVP7('3', 'TOMATES ROJOS', -2));
         DBMS_OUTPUT.PUT_LINE (PVP7('3', 'TOMATES ROJOS', 2));
    END;
    
-- 8- Escribe un bloque PL/SQL donde usas un registro para almacenar los datos de un producto. 
-- El bloque insertará ese producto, pero si el precio no es positivo generará una excepción de tipo precio_prod_invalido, 
-- que deberás declarar previamente, en vez de realizar la inserción.

    
    CREATE OR REPLACE FUNCTION PVP8 (COD IN VARCHAR2, DES IN VARCHAR2, CSTE IN NUMBER) RETURN NUMBER
    AS
       PRODUC PRODUCTOS%ROWTYPE;
       PRECIO_PROD_INVALIDO EXCEPTION;
    BEGIN
       PRODUC.CODIGO:=COD;
       PRODUC.DESCRIPCION:=DES;
       PRODUC.PRECIO:=CSTE;
       IF CSTE>0 THEN
           INSERT INTO PRODUCTOS VALUES (PRODUC.CODIGO, PRODUC.DESCRIPCION, PRODUC.PRECIO);
           RETURN CSTE+(CSTE*20/100);
       ELSE
           RAISE PRECIO_PROD_INVALIDO;
       END IF;
    EXCEPTION
    WHEN PRECIO_PROD_INVALIDO THEN
        DBMS_OUTPUT.PUT_LINE ('Precio invalido.');
    END PVP8;
    
    --Pruebo la función
    BEGIN
         DBMS_OUTPUT.PUT_LINE (PVP8('3', 'TOMATES ROJOS', -2));
    END;
    
-- 9- Modifica el ejercicio anterior, de forma que ahora captures la excepción elevada y produces otra, 
-- con SQLCODE y mensaje de error espífico, usando RAISE_APPLICATION_ERROR

    CREATE OR REPLACE FUNCTION PVP9 (COD IN VARCHAR2, DES IN VARCHAR2, CSTE IN NUMBER) RETURN NUMBER
    AS
       PRODUC PRODUCTOS%ROWTYPE;
       PRECIO_PROD_INVALIDO EXCEPTION;
    BEGIN
       PRODUC.CODIGO:=COD;
       PRODUC.DESCRIPCION:=DES;
       PRODUC.PRECIO:=CSTE;

       IF CSTE>0 THEN
           INSERT INTO PRODUCTOS VALUES (PRODUC.CODIGO, PRODUC.DESCRIPCION, PRODUC.PRECIO);
           RETURN CSTE+(CSTE*20/100);
       ELSE
           RAISE PRECIO_PROD_INVALIDO;
       END IF;
       
    EXCEPTION
    WHEN PRECIO_PROD_INVALIDO THEN
        DBMS_OUTPUT.PUT_LINE ('Precio invalido.');
        RETURN 0;
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20900,'¡¡Error!! '||SQLCODE||SQLERRM);
    END PVP9;
    
    --Pruebo la función
    BEGIN
         DBMS_OUTPUT.PUT_LINE (PVP9('3', 'TOMATES ROJOS', -2)); -- Error de Precio inválido
         DBMS_OUTPUT.PUT_LINE (PVP9('3', 'TOMATES ROJOS', 2)); -- Error de clave primaria duplicada
    END;