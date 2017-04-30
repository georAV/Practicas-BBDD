--1.Crear una funci�n pl/sql que duplica la cantidad recibida como par�metro .

    -- Se crea una funci�n que recibe un parametro (IN) tipo NUMBER y devolvera un dato tipo NUMBER
    -- y devuelve el par�metro x 2, es decir, duplicado.
    
        CREATE OR REPLACE FUNCTION DUPLICAR (N IN NUMBER) RETURN NUMBER
        AS
        BEGIN
            RETURN N*2;
        END DUPLICAR;
    
    -- Pruebo la funci�n.
    
        DECLARE
            NUMERO NUMBER:=&VALOR;
        BEGIN
            DBMS_OUTPUT.PUT_LINE ('El doble de '||NUMERO||' es '||DUPLICAR(NUMERO));
        END;
    
--2.Crear una funci�n pl/sql llamada factorial que devuelva el factorial de un n�mero, 
-- por ejemplo 5! = 1 * 2 * 3 * 4 * 5 = 120.

    -- Se crea una funci�n que recibe un parametro (IN) tipo NUMBER y devolvera un dato tipo NUMBER
    -- y devuelve el factorial dependiendo del valor introducido.

        CREATE OR REPLACE FUNCTION FACTORIAL (N IN NUMBER) RETURN NUMBER
        AS
        BEGIN
            IF N<0 THEN     -- Si el par�metro recibido en un n�mero negaivo:
                Return 0;   -- No existe el calculo factorial para n�meros negativos, return 0.
            ELSIF N=0 THEN  -- Si el par�metro recibido es 0:
                Return 1;   -- El factorial de 0 es 1, return 1.
            ELSE
                Return N*Factorial(N-1); -- C�lculo para n�meros enteros positivos, return el numero * (numero-1).
            END IF;
        END Factorial;
    
    -- Pruebo la funci�n.
    
        DECLARE
            NUMERO NUMBER:=&VALOR;
        BEGIN
            DBMS_OUTPUT.PUT_LINE (NUMERO || '! = '|| FACTORIAL(NUMERO));
        END;
        
-- 3.Crear un procedimiento pl/sql que muestra los n�meros desde el 1 hasta el valor pasado como par�metro.

    -- Crear el procedimiento que recibe (IN) un par�metro tipo VARCHAR2
    
        CREATE OR REPLACE PROCEDURE CADENA (N IN VARCHAR2)
        IS
            -- Aqu� se declaran las variables locales, la que almacena el resultado y un contador
            TEXTO VARCHAR2(200);
            CONTADOR NUMBER:=1;
        BEGIN
            LOOP
                TEXTO:= TEXTO||CONTADOR||' ,';
                CONTADOR:=CONTADOR+1;
            EXIT WHEN CONTADOR=N;
            END LOOP;
            --A�ado N al final para que no le siga una coma
            DBMS_OUTPUT.PUT_LINE (TEXTO||N);
        END CADENA;

     -- Tambi�n se puede hacer con un FOR
     
        CREATE OR REPLACE PROCEDURE CADENA2 (N IN NUMBER)
        IS  
            -- Aqu� se declaran las variables locales
            TEXTO VARCHAR2(200);
        BEGIN
            FOR i IN 1..N-1
            LOOP
                TEXTO:=TEXTO||i||', ';
            END LOOP;
            --A�ado N al final para que no le siga una coma
            DBMS_OUTPUT.PUT_LINE (TEXTO||N);
        END CADENA2;
 
       
    -- Pruebo las dos soluciones 
        DECLARE
            NUMERO VARCHAR2(200):='&VALOR';
        BEGIN
            CADENA(NUMERO);
            CADENA2(NUMERO);
        END;
        
-- 4.Modificar el procedimiento del Ejercicio 1 para que muestre n�meros desde un valor inferior hasta uno 
-- superior con cierto salto, que por defecto ser� 1.

        CREATE OR REPLACE PROCEDURE SALTOS (INFERIOR IN NUMBER, SUPERIOR IN NUMBER, SALTO IN NUMBER)
        IS  
            VALOR_SALTO NUMBER:=SALTO;      -- Paso el valor del salto a una variable local, para luego comprobar si es null.
            CONTADOR NUMBER:=INFERIOR;      -- Inicializo un contador con el n�mero inferior
            TEXTO VARCHAR2(200);            -- Declaro una variable en la que se ir� escribiendo cada actualizaci�n del contador.
        BEGIN
            -- Si SALTO ES NULL, la variable local tambi�n, entonces la ponemos a 1
            IF VALOR_SALTO IS NULL THEN VALOR_SALTO:=1;
            END IF;
            -- Control de errores:
            -- Si el n�mero innferior es superior al mayor devuelve error
            IF INFERIOR>SUPERIOR THEN
                DBMS_OUTPUT.PUT_LINE ('Error. Revisa el valor de los par�metros');
            -- Saco la diferencia entre los n�meros SUPERIOR e INFERIOR. 
            -- Si el resto de dividir con SALTO no es 0 dar� error (porque nunca coincidir� con el valor SUPERIOR)
            ELSIF MOD((SUPERIOR-INFERIOR),SALTO)!=0 THEN
                DBMS_OUTPUT.PUT_LINE ('Error. Valor del salto incorrecto');
            -- Si todo esta correcto realiza la serie
            ELSE
                LOOP
                    CONTADOR:=CONTADOR+VALOR_SALTO;         -- Cada vuelta de bucle, al contador se le suma un salto
                    TEXTO:=TEXTO||CONTADOR||', ';           -- Y se actualiza la cadena que lo va almacenando
                EXIT WHEN CONTADOR=(SUPERIOR-VALOR_SALTO);  -- Se sale del blucle en el n�mero anterior al superior, para que la cadena no termine con una coma
                END LOOP;
                DBMS_OUTPUT.PUT_LINE (INFERIOR||','||TEXTO||SUPERIOR); -- Se imprime la cadena
            END IF;
        END SALTOS;
        
        -- Compruebo el procedimiento pidiendo los n�umero por teclado.
        DECLARE
        NUMERO1 NUMBER;
        NUMERO2 NUMBER;
        NUMERO3 NUMBER;
        BEGIN
        NUMERO1:='&INFERIOR';
        NUMERO2:='&SUPERIOR';
        NUMERO3:='&SALTO';
        SALTOS(NUMERO1,NUMERO2,NUMERO3);
        END;
        
--5 Modificar el procedimiento del Ejercicio 1 para que inserte los n�meros en una tabla
        
        CREATE OR REPLACE PROCEDURE INSERTAR_SALTOS (INFERIOR IN NUMBER, SUPERIOR IN NUMBER, SALTO IN NUMBER DEFAULT 1)
        IS  
            CONTADOR NUMBER:=INFERIOR;
        BEGIN
            IF INFERIOR>SUPERIOR THEN
                DBMS_OUTPUT.PUT_LINE ('Error. Revisa el valor de los par�metros');
            ELSIF MOD((SUPERIOR-INFERIOR),SALTO)!=0 THEN
                DBMS_OUTPUT.PUT_LINE ('Error. Valor del salto incorrecto');
            ELSE    
                INSERT INTO SERIE VALUES(INFERIOR);
                LOOP
                    CONTADOR:=CONTADOR+SALTO;
                    INSERT INTO SERIE VALUES(CONTADOR);
                EXIT WHEN CONTADOR=SUPERIOR;
                END LOOP;
            END IF;
        END INSERTAR_SALTOS;
        
        -- Pruebo el procedimiento
        
        DECLARE
        BEGIN
        INSERTAR_SALTOS(1,21,2);
        END;
        
--6- Crea una funci�n llamada, PVP que toma como argumento un c�digo de producto, una descripci�n y un coste del producto, 
--y realice una inserci�n en una tabla PRODUCTOS si el c�digo de producto (PK) no existe 
--y en caso de existir actualice los datos de decripci�n y coste y devuelva el precio de venta al p�blico, 
--que resulta de aplicarle a ese precio de coste un margen comercial del 20%.

    -- Crear tabla
    
        CREATE TABLE PRODUCTOS(
        CODIGO VARCHAR2(5) NOT NULL,
        DESCRIPCION VARCHAR2(100),
        PRECIO NUMBER,
        CONSTRAINT PK_PRODUCTOS PRIMARY KEY (CODIGO)
        );
    -- Crear funci�n
    
        CREATE OR REPLACE FUNCTION PVP (COD IN VARCHAR2, DES IN VARCHAR2, CSTE IN NUMBER) RETURN NUMBER
        AS
            CONTADOR NUMBER;
        BEGIN
            SELECT COUNT(*) INTO CONTADOR FROM PRODUCTOS WHERE CODIGO=COD;
            IF CONTADOR=0 THEN
                INSERT INTO PRODUCTOS VALUES (COD, DES, CSTE);
            ELSE
                UPDATE PRODUCTOS SET DESCRIPCION=DES, PRECIO=CSTE WHERE CODIGO=COD;
            END IF;
            RETURN (CSTE+(CSTE*20/100));
        END PVP;
    
    --Pruebo la funcion
    
        DECLARE
        BEGIN
         DBMS_OUTPUT.PUT_LINE (PVP('VVVV1', 'TOMATES ROJOS', 2)||' �');
         DBMS_OUTPUT.PUT_LINE (PVP('VVVV1', 'TOMATES VERDES', 4)||' �');
        END;
        
-- 7- Dado este PL/SQL:

    -- a) �Se trata de una funci�n o de un procedimiento, por qu�?, �Qu� habr�a que cambiar para que fuera lo otro?
    
        -- Es un procedimiento. Porque se crea como procedure y adem�s no tiene return.
        -- Habr�a que cambiar la sintaxis, FUNCTION en lugar de PROCEDURE y a�adir RETURN ... con el tipo de dato que se quiere obtener.
        -- Y poner la sentencia return en el BEGIN con el valor que se quiere devolver.
        
    -- b) �Cu�l es la cabecera del procedimiento?
        
        -- CREATE OR REPLACE PROCEDURE modificar_precio_producto (codigoprod NUMBER, nuevo NUMBER)
        -- AS
    
    -- c) c)�Qu� es el precioant?
    
        -- Es la variable local donde se almacena el valor de la columna precio_uni de la tabla productos.
    
    -- d)�Qu� es el nuevoprecio?
        
        -- Es un par�metro de entrada, por el cual se llama al procedimiento.
        
    -- e) �Qu� es el precio_uni?
        
        -- Es una columna de la tabla productos.
        
    -- f)�Cu�les son los par�metros del procedimiento?
        
        -- codigoprod y nuevo, los que estan entre parentesis en el encabezado de la funci�n.
    
    -- g)�Qu� es NO_DATA_FOUND?
    
        -- Es una excepci�n que devuelve un texto de error en caso de no encontrar datos.
        
    -- h)�Cu�l es el nombre del procedimiento?
    
        -- modificar_precio_producto
    
    -- i)�D�nde comienza el bloque?
    
        -- En el encabezado (Create...)
        
    -- j)�Qu� hace la cl�usula into?
    
        -- Introducir el valor de la columna precio_uni en la variable local precio_ant
        -- cuando el codigo introducido como parametro ya exista en la columna cod_producto de la tabla.
        
    -- k)�qu� hace la condici�n del IF?
    
        -- Se quiere comprobar que la actualizaci�n del precio no ser� superior al 20% del mismo.
    
        -- Si el precio almacenado * 0.20 es mayor que 
        -- el valor absoluto de la diferencia entre el precio almacenado y el introducido como parametro
        -- actualiza la columna precio_uni de la tabla con el valor del par�metro introducido
        -- (cuando el codigo introducido como parametro ya exista en la columna cod_prodcto de la tabla)
        -- Si no, muestra un error.
        
    -- l)�Porque no tiene la cl�usula declare?�Qu� tiene en su lugar?
        
        -- En lugar de DECLARE se pone AS y a continuaci�n es donde se declaran las variables.
        
-- 8- Corregir los errores de sintaxis en esta funci�n 
-- Esta funci�n PL/SQL devuelve el n�mero PI (3,141592653589793238462...). 
-- Calculado mediante el algoritmo que ide� John Wallis en 1665

        CREATE OR REPLACE FUNCTION piWallis (pIteraciones number) RETURN number
        AS
            vCont number:=0;
            vRet number:=1;
        BEGIN
            LOOP
                vCont := vCont + 1;
            IF MOD(vCont, 2) = 0 THEN
                    vRet := vRet * vCont / (vCont + 1);
            ELSE
                    vRet := vRet * (vCont + 1) / vCont;
            END IF;
            EXIT WHEN vCont > pIteraciones;
            END LOOP;
            return (2 * vRet);
        END piWallis;
    
-- 9. Introduce todas las funciones y procedimentos de los ejercicios anteriores en un PACKAGE llamado FUNCIONES_PROCE

    
    -- Especificacion
    -- Declarar los elementos de los que consta el paquete. 
    -- En esta especificaci�n se indican los procedimientos, funciones y variables p�blicos del paquete
    
      CREATE OR REPLACE PACKAGE FUNCIONES_PROCE IS
      
      FUNCTION DUPLICAR (N IN NUMBER) RETURN NUMBER;
      FUNCTION FACTORIAL (N IN NUMBER) RETURN NUMBER;
      PROCEDURE CADENA (N IN VARCHAR2);
      PROCEDURE SALTOS (INFERIOR IN NUMBER, SUPERIOR IN NUMBER, SALTO IN NUMBER);
      PROCEDURE INSERTAR_SALTOS (INFERIOR IN NUMBER, SUPERIOR IN NUMBER, SALTO IN NUMBER DEFAULT 1);
      FUNCTION PVP (COD IN VARCHAR2, DES IN VARCHAR2, CSTE IN NUMBER) RETURN NUMBER;
      FUNCTION piWallis (pIteraciones number) RETURN number;
      
      END FUNCIONES_PROCE;
      
   -- Cuerpo
   -- En el que se especifica el funcionamiento del paquete. 
   -- Consta de la definici�n de los procedimientos indicados en la especificaci�n.
    
      CREATE OR REPLACE PACKAGE BODY FUNCIONES_PROCE IS
      
      FUNCTION DUPLICAR (N IN NUMBER) RETURN NUMBER
      AS
      BEGIN
          RETURN N*2;
      END DUPLICAR;
      
      FUNCTION FACTORIAL (N IN NUMBER) RETURN NUMBER
      AS
      BEGIN
          IF N<0 THEN   
              Return 0; 
          ELSIF N=0 THEN  
              Return 1; 
          ELSE
              Return N*Factorial(N-1);
          END IF;
      END FACTORIAL;
      
      PROCEDURE CADENA (N IN VARCHAR2)
      IS
          TEXTO VARCHAR2(200);
          CONTADOR NUMBER:=1;
      BEGIN
          LOOP
              TEXTO:= TEXTO||CONTADOR||' ,';
              CONTADOR:=CONTADOR+1;
          EXIT WHEN CONTADOR=N;
          END LOOP;
          DBMS_OUTPUT.PUT_LINE (TEXTO||N);
      END CADENA;
      
      PROCEDURE SALTOS (INFERIOR IN NUMBER, SUPERIOR IN NUMBER, SALTO IN NUMBER)
      IS  
          VALOR_SALTO NUMBER:=SALTO;      
          CONTADOR NUMBER:=INFERIOR;      
          TEXTO VARCHAR2(200);          
      BEGIN
            
          IF VALOR_SALTO IS NULL THEN VALOR_SALTO:=1;
          END IF;
          IF INFERIOR>SUPERIOR THEN
              DBMS_OUTPUT.PUT_LINE ('Error. Revisa el valor de los par�metros');
          ELSIF MOD((SUPERIOR-INFERIOR),SALTO)!=0 THEN
              DBMS_OUTPUT.PUT_LINE ('Error. Valor del salto incorrecto');
          ELSE
              LOOP
                  CONTADOR:=CONTADOR+VALOR_SALTO;         
                  TEXTO:=TEXTO||CONTADOR||', ';           
              EXIT WHEN CONTADOR=(SUPERIOR-VALOR_SALTO);
              END LOOP;
              DBMS_OUTPUT.PUT_LINE (INFERIOR||','||TEXTO||SUPERIOR); 
          END IF;
      END SALTOS;
      
      PROCEDURE INSERTAR_SALTOS (INFERIOR IN NUMBER, SUPERIOR IN NUMBER, SALTO IN NUMBER DEFAULT 1)
      IS  
          CONTADOR NUMBER:=INFERIOR;
      BEGIN
          IF INFERIOR>SUPERIOR THEN
              DBMS_OUTPUT.PUT_LINE ('Error. Revisa el valor de los par�metros');
          ELSIF MOD((SUPERIOR-INFERIOR),SALTO)!=0 THEN
              DBMS_OUTPUT.PUT_LINE ('Error. Valor del salto incorrecto');
          ELSE    
              INSERT INTO SERIE VALUES(INFERIOR);
              LOOP
                  CONTADOR:=CONTADOR+SALTO;
                  INSERT INTO SERIE VALUES(CONTADOR);
              EXIT WHEN CONTADOR=SUPERIOR;
              END LOOP;
          END IF;
      END INSERTAR_SALTOS;
      
      FUNCTION PVP (COD IN VARCHAR2, DES IN VARCHAR2, CSTE IN NUMBER) RETURN NUMBER
      AS
          CONTADOR NUMBER;
      BEGIN
          SELECT COUNT(*) INTO CONTADOR FROM PRODUCTOS WHERE CODIGO=COD;
          IF CONTADOR=0 THEN
              INSERT INTO PRODUCTOS VALUES (COD, DES, CSTE);
          ELSE
              UPDATE PRODUCTOS SET DESCRIPCION=DES, PRECIO=CSTE WHERE CODIGO=COD;
          END IF;
          RETURN (CSTE+(CSTE*20/100));
      END PVP;
      
      FUNCTION piWallis (pIteraciones number) RETURN number
      AS
          vCont number:=0;
          vRet number:=1;
      BEGIN
          LOOP
              vCont := vCont + 1;
          IF MOD(vCont, 2) = 0 THEN
                  vRet := vRet * vCont / (vCont + 1);
          ELSE
                  vRet := vRet * (vCont + 1) / vCont;
          END IF;
          EXIT WHEN vCont > pIteraciones;
          END LOOP;
          return (2 * vRet);
      END piWallis;
    
      END FUNCIONES_PROCE;
      
-- 10 Ejecuta los procedimientos y funciones del nuevo Paquete desde un bloque an�nimo.

    DECLARE
    BEGIN 
      DBMS_OUTPUT.PUT_LINE (FUNCIONES_PROCE.DUPLICAR(4));
      DBMS_OUTPUT.PUT_LINE (FUNCIONES_PROCE.FACTORIAL(5));
      FUNCIONES_PROCE.CADENA(10);
      FUNCIONES_PROCE.SALTOS(2,20,2);
      FUNCIONES_PROCE.INSERTAR_SALTOS(2,20,2);
      DBMS_OUTPUT.PUT_LINE(FUNCIONES_PROCE.PVP('VVVV1','TOMATES ROJOS',2));
      DBMS_OUTPUT.PUT_LINE(FUNCIONES_PROCE.piWallis(2));
    END;
      
    -- Las funciones necesitan que se imprima el return, los procedimientos ya llevan el output en el bloque.