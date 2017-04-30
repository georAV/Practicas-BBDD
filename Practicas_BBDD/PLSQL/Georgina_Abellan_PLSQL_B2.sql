--1.- ¿Es correcta la siguiente sintaxis General de la sentencia IF-THEN ELSE?,¿Por qué?, ¿Cómo la escribirías?.

    -- No es correcta porque no hay que poner el segundo BEGIN, y además ENDFIN se escribe con espacio "END IF"
    -- Por otro lado, para que funcione el bloque hay que declarar variables.
    DECLARE
        ...
    BEGIN
        IF condicion1 THEN
        secuencia_de_instrucciones1;
        ELSE
        secuencia_de_instrucciones2;
        END IF;
    END;

--2.- ¿Qué resultado nos daría la siguiente comparación?

    -- Que en un procedimiento la sentencia return no puede contener ninguna expresión.
    -- Return tiene que devolver un valor, por lo que se usa en bloques tipo FUNCION

-- 3.- Indicar que errores existen en el siguiente código fuente:

    -- Que dentro del LOOP no tiene que haber ningún BEGIN
    -- Además los valores booleanos se escriben sin entrecomillar.
    
-- 4- ¿Qué valor contendrá la variable 'sumador' al salir del bucle?, ¿Por qué?

    -- Ninguno porque no está inicializada.

--5.- ¿Qué resultado dará la ejecución del siguiente código?

    -- Lo mismo que la anterior, ninguno porque la variable no está inicializada.
    -- Además el tipo de dato se ha especificado de una cifra, por lo que el bucle no puede llevarse a cabo.
    
--6- ¿ Funcionaría el siguiente trozo de código?, ¿Por qué?, ¿Cómo arreglarlo?

    -- No funciona porque la condición VALOR = NULL no es valida, hay que poner VALOR IS NULL
    
-- 7.- Escribir la sintaxis General de un código que evalúe si se cumple una condición, 
-- en caso de cumplirse que ejecute una serie de sentencias,
-- en caso contrario que evalúe otra, que de cumplirse ejecute otras instrucciones, 
-- si ésta no se cumple que evalúe una tercera condición.. y así N veces. 
-- En caso de existir varias soluciones, comentarlas y escribir la más óptima o clara.

    -- a) Con if, elsif, else  para varias condiciones, escribir tantos elsif como condiciones haya.
    
        DECLARE
        BEGIN
            IF condicion_a THEN 
                sentencia_1;
                sentencia_2;
                sentencia_3;
                ELSIF condicion_b THEN
                sentencia_4;
                sentencia_5;
                sentencia_6;
                -- ELSIF n veces
                ELSE
                sentencia_n;
            END IF;
       END;
       
     --b) Con CASE
     
         DECLARE
         BEGIN
            CASE 
            WHEN condicion_a THEN
                sentencia_1;
                sentencia_2;
            WHEN condicion_b THEN
                sentencia_3;
                sentencia_4;
            -- y asi n veces
            ELSE
                sentencia_n;
            END CASE;
     
    -- c) Con bucle for
    
        DECLARE
        BEGIN
            FOR contador IN 1..n  -- n veces
            LOOP
                IF condicion_a THEN
                    sentencia_1;
                ELSIF condicion_b THEN
                    sentencia_2;
                ELSE
                    sentencia_3;
                END IF;
            END LOOP;
        END;
            
      
--8.- Implementar en PL/SQL un bucle infinito que vaya sumando
--valores en una variable de tipo NUMBER.

    DECLARE
        numero number:=0;
    BEGIN
        LOOP
            numero:=numero +1;
        END LOOP;
    END;
    
--9.- En base al bucle anterior, añadirle la condición de que salga cuando
--la variable sea mayor que 10.000.
    
    DECLARE
        numero number:=0;
    BEGIN
        LOOP
            numero:=numero +1;
        EXIT WHEN numero>10000;
        END LOOP;
        DBMS_OUTPUT.put_line(numero);
    END;
    
    -- O también..
    
    DECLARE
        numero number:=0;
    BEGIN
        WHILE numero<=10000
        LOOP
            numero:=numero +1;
        END LOOP;
        DBMS_OUTPUT.put_line(numero);
    END;
    
    -- O también..
    DECLARE
        numero number:=0;
        cumple boolean:=FALSE;
    BEGIN
        WHILE NOT cumple
        LOOP
            numero:=numero +1;
            IF numero>10000
            THEN cumple:=TRUE;
            END IF;
        END LOOP;
        DBMS_OUTPUT.put_line(numero);
    END;
    
--10.- Implementar un bucle en PL/SQL mediante la sentencia WHILE,
--en el cual vayamos sumando valores a una variable mientras ésta sea
--menor que 10, y asegurándonos de que el bucle se ejecuta por lo menos una vez.

    DECLARE
        numero number:=0;
    BEGIN
        WHILE numero<10
        LOOP
            numero:=numero +1;
        END LOOP;
        DBMS_OUTPUT.put_line(numero);
    END;
    
-- 11.- Implementar en PL/SQL, el código necesario de un programa que
-- al final de su ejecución haya almacenado en una variable llamada 'cadena',
-- el siguiente valor: cadena:='10*9*8*7*6*5*4*3*2*1'
    
    DECLARE
        cadena varchar(50);
        contador number:=10;
    BEGIN
        WHILE NOT contador=1
        LOOP
        cadena:=cadena||contador||'*';
        contador:=contador-1;
        END LOOP;
        DBMS_OUTPUT.put_line(cadena||'1');
    END;      