-- 1- Crea un procedimiento que dado un nombre y una contraseña te cree un usuario y te de permisos.

    CREATE OR REPLACE PROCEDURE CREAR_USUARIO (USUARIO IN VARCHAR2, CONTRA IN VARCHAR2)
    IS
    BEGIN
        EXECUTE IMMEDIATE 'CREATE USER '||USUARIO ||' IDENTIFIED BY '||CONTRA;
        EXECUTE IMMEDIATE 'GRANT ALL PRIVILEGES TO '||USUARIO;
    END CREAR_USUARIO;
    
    --Probar
    DECLARE
    BEGIN
        CREAR_USUARIO('GEOR_2', '1234');
    END;
    
-- 2- Cambia el ejercicio anterior capturando todos los fallos posibles que se puedan dar.

    CREATE OR REPLACE PROCEDURE CREAR_USUARIO (USUARIO IN VARCHAR2, CONTRA IN VARCHAR2)
    IS
        USUARIO_VACIO EXCEPTION;
        CONTRA_VACIA EXCEPTION;
    BEGIN
        IF (USUARIO IS NULL) THEN
            RAISE USUARIO_VACIO;
        ELSIF (CONTRA IS NULL) THEN
            RAISE CONTRA_VACIA;
        ELSE
            EXECUTE IMMEDIATE 'CREATE USER '||USUARIO ||' IDENTIFIED BY '||CONTRA;
            EXECUTE IMMEDIATE 'GRANT ALL PRIVILEGES TO '||USUARIO;
        END IF;
    EXCEPTION
        WHEN USUARIO_VACIO THEN
        RAISE_APPLICATION_ERROR (-20001, 'Falta el usuario');
        WHEN CONTRA_VACIA THEN
        RAISE_APPLICATION_ERROR (-20002, 'Falta la contraseña');
        WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR (-20002, 'Ha ocurrido un error, '||sqlerrm);
    END CREAR_USUARIO;
    
    --Probar
    DECLARE
    BEGIN
        CREAR_USUARIO('', '1234');
    END;
    
    
--3- Crea dinámicamente un tabla de 5 campos, y creale una clave primaria

    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE EDADES(
                           CAMPO_1 NUMBER NOT NULL,
                           CAMPO_2 NUMBER,
                           CAMPO_3 NUMBER,
                           CAMPO_4 NUMBER,
                           CAMPO_5 NUMBER,
                           CONSTRAINT PK_EDADES PRIMARY KEY (CAMPO_1))';
    END;
    
--4- Realiza un procedimiento llamado Busqueda, que entren por parámetros los 5 campos dados 
--y busque dinámicamente todos los datos de la tabla anterior por todos los criterios 
--que no se le pase a NULL a la función, dando un error si todos se pasan a NULL.

CREATE OR REPLACE PROCEDURE BUSQUEDA (C1 IN NUMBER, C2 IN NUMBER, C3 IN NUMBER, C4 IN NUMBER, C5 IN NUMBER)
IS
    ERROR_NULL EXCEPTION;
    RESULTADO EDADES%ROWTYPE;
BEGIN
    IF (C1 IS NULL OR C2 IS NULL OR C3 IS NULL OR C4 IS NULL OR C5 IS NULL) THEN
        RAISE ERROR_NULL;
    ELSE
        EXECUTE IMMEDIATE 'SELECT * FROM EDADES WHERE CAMPO_1 = :1 AND CAMPO_2 = :2 
                           AND CAMPO_3 = :3 AND CAMPO_4 = :4 AND CAMPO_5 = :5 '
                           INTO RESULTADO USING C1, C2, C3, C4, C5 ;
    END IF;
    DBMS_OUTPUT.PUT_LINE(RESULTADO.CAMPO_1||', '||RESULTADO.CAMPO_2||', '||RESULTADO.CAMPO_3||', '||RESULTADO.CAMPO_4||', '||RESULTADO.CAMPO_5);
EXCEPTION
    WHEN ERROR_NULL THEN
    RAISE_APPLICATION_ERROR (-20004,'Faltan parámetros');
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR (-20008, 'Ha ocurrido un error, '||sqlerrm);
END BUSQUEDA;


BEGIN
    BUSQUEDA (1, 21, 41, 61, 81); -- Este muestra la búsqueda
    BUSQUEDA (1, 21, '', 61, 81); -- Aquí salta el error.
END;

-- 5- Crea la tabla usando SQL dinámico y EXECUTE IMMEDIATE dentro de un bloque PL/SQL. 
-- Comprueba que efectivamente la tabla fue creada, con una consulta simple sobre el catalogo de Oracle. 
--Finalmente, elimina (DROP) la tabla

    BEGIN
        EXECUTE IMMEDIATE 'SELECT * FROM EDADES';
        EXECUTE IMMEDIATE 'DROP TABLE PRODUCTO';
    END;
    DROP TABLE T2;
    
--6- De nuevo en un bloque PL/SQL, crea una tabla T2 con un campo S alfanum´ erico,
-- e inserta una fila en esa tabla

    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE T2(S VARCHAR2(10))';
        EXECUTE IMMEDIATE 'INSERT INTO T2 VALUES (''CENIZAS'')';
    END;
    
--7- Recupera e imprime de nuevo los datos de todos los productos, ahora usando SQL dinámico
    
    BEGIN
    EXECUTE IMMEDIATE'
    DECLARE
        CURSOR CUR_PROD IS SELECT * FROM PRODUCTOS;
    BEGIN
        
        FOR i IN CUR_PROD
        LOOP
            DBMS_OUTPUT.PUT_LINE (i.CODIGO|| '' , '' || i.DESCRIPCION ||  '' , '' || i.PRECIO);
        END LOOP;
    END;';
    END;
    
-- 8- Altera la tabla de productos, añadiendo una restricción c_precio_positivo 
-- que compruebe que el precio de un producto es mayor que cero

BEGIN
EXECUTE IMMEDIATE 'ALTER TABLE PRODUCTOS ADD CONSTRAINT CHECK_C_PRECIO_POSITIVO
                  CHECK (PRECIO>0)';
END;