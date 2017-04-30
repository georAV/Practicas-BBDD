--1.- �Es correcta la siguiente sintaxis General de la sentencia IF-THEN ELSE?,�Por qu�?, �C�mo la escribir�as?.

    -- No es correcta porque no hay que poner el segundo BEGIN, y adem�s ENDFIN se escribe con espacio "END IF"
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

--2.- �Qu� resultado nos dar�a la siguiente comparaci�n?

    -- Que en un procedimiento la sentencia return no puede contener ninguna expresi�n.
    -- Return tiene que devolver un valor, por lo que se usa en bloques tipo FUNCION

-- 3.- Indicar que errores existen en el siguiente c�digo fuente:

    -- Que dentro del LOOP no tiene que haber ning�n BEGIN
    -- Adem�s los valores booleanos se escriben sin entrecomillar.
    
-- 4- �Qu� valor contendr� la variable 'sumador' al salir del bucle?, �Por qu�?

    -- Ninguno porque no est� inicializada.

--5.- �Qu� resultado dar� la ejecuci�n del siguiente c�digo?

    -- Lo mismo que la anterior, ninguno porque la variable no est� inicializada.
    -- Adem�s el tipo de dato se ha especificado de una cifra, por lo que el bucle no puede llevarse a cabo.
    
--6- � Funcionar�a el siguiente trozo de c�digo?, �Por qu�?, �C�mo arreglarlo?

    -- No funciona porque la condici�n VALOR = NULL no es valida, hay que poner VALOR IS NULL
    
-- 7.- Escribir la sintaxis General de un c�digo que eval�e si se cumple una condici�n, 
-- en caso de cumplirse que ejecute una serie de sentencias,
-- en caso contrario que eval�e otra, que de cumplirse ejecute otras instrucciones, 
-- si �sta no se cumple que eval�e una tercera condici�n.. y as� N veces. 
-- En caso de existir varias soluciones, comentarlas y escribir la m�s �ptima o clara.

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
    
--9.- En base al bucle anterior, a�adirle la condici�n de que salga cuando
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
    
    -- O tambi�n..
    
    DECLARE
        numero number:=0;
    BEGIN
        WHILE numero<=10000
        LOOP
            numero:=numero +1;
        END LOOP;
        DBMS_OUTPUT.put_line(numero);
    END;
    
    -- O tambi�n..
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
--en el cual vayamos sumando valores a una variable mientras �sta sea
--menor que 10, y asegur�ndonos de que el bucle se ejecuta por lo menos una vez.

    DECLARE
        numero number:=0;
    BEGIN
        WHILE numero<10
        LOOP
            numero:=numero +1;
        END LOOP;
        DBMS_OUTPUT.put_line(numero);
    END;
    
-- 11.- Implementar en PL/SQL, el c�digo necesario de un programa que
-- al final de su ejecuci�n haya almacenado en una variable llamada 'cadena',
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