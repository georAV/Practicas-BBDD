--1

    -- Son equivalentes, por un lado:
    Identificador1 NUMBER, identificador 1 NUMBER y IDENTIFICADOR1 NUMBER

    -- y por otro lado:
    Identificador_1 NUMBER y IdEntificador_1 NUMBER

    -- Porque PL/SQL no es case sensitive, no distingue entre mayúsculas y minúsculas.

--2 
    
    Primera variable VARCHAR2(40); -- No es valido porque no se admiten espacios para declarar variables
    end BOOLEAN;                   -- No es válido porque no se admite usar palabras reservadas.
    Una_variable VARCHAR2(40);     -- Esta declaración SI es válida.
    Otra-variable VARCHAR2(40);    -- No es válido porque no se admiten guiones.
    
--3
    -- No funcionaria porque tipo empleado VARCHAR2(4) contiene un espacio, y no se admiten.
    --Se puede resolver juntando las palabras o colocando un guión bajo entre ellas.
    
    tipo_empleado VARCHAR2(4);
    
    -- de esta manera también habría que cambiar la variable en la seccion de ejecución:
    
    SELECT name, address, type
    INTO nombre, direccion, tipo_empleado
    FROM emp;
    
--4 
    --No es válida la sentencia total numero1(6,2), porque toma el tipo de dato de numero1,
    -- por lo que no puede especificar ni modificar la precisión del tipo base.

--5
    -- No son válidas:
    id_externo NUMBER(4) NOT NULL; -- Porque siendo NOT NULL debe estar inicializada con un valor.
    suma NUMBER:=cosa + la_otra;   -- Porque no se puede referenciar una variable antes de ser declarada.
    tipo_otro tipo_uno%TYPE;       -- Porque toma el tipo de dato de "tipo_uno" que es not null, por lo que debe de
                                   -- estar inicializada con un valor, al igual que tipo_uno.

--6
    valor1 emp%ROWTYPE;         -- Toma un registro de todos los tipos de dato de la tabla "emp"
                                -- es decir, VARCHAR2(40), VARCHAR2(255) y NUMBER(10)
    valor2 emp.nombre%TYPE;     -- Toma el tipo de dato de la columna "nombre" de la tabla "emp"
                                -- es decir, VARCHAR2(40)
    valor3 emp.telefono%TYPE;   -- Toma el tipo de dato de la columna "telefono" de la tambla "emp"
                                -- es decir, NUMBER(10)
    CURSOR c1 IS
    SELECT nombre,direccion FROM emp; -- Recupera el tipo de dato de los campos nombre y direccion de la tabla emp
                                      -- es decir, VARCHAR2(40) y VARCHAR2(255)
    valor4 c1%ROWTYPE;          -- Toma el valor de c1, es decir, VARCHAR2(40) y VARCHAR2(255)
    valor5 emp%ROWTYPE;         -- Toma el registro de los tipos de dato de la tabla emp
                                -- es decir, VARCHAR2(40), VARCHAR2(255) y NUMBER(10)

--7
    valor1:=valor5; -- Es correcto, porque toman el mismo valor, que es el registro de los tipos de dato de la tabla emp.
    valor4:=valor1; -- No es correcto porque valor4 toma el tipo de registro de c1, sobre los campos nombre y dirección, 
                    -- mientras que valor1 toma el registro sobre todos los campos de la tabla.
                    
--8
    -- No son correctas ninguna de las dos porque no se permite esa forma de declaración.
    -- Las variables hay que declararlas una por una:
        i NUMBER;
        j NUMBER;
        ...  
-- 9.
DECLARE 
    TEXTO VARCHAR2(50) :='Hola';
BEGIN
    DBMS_OUTPUT.put_line(TEXTO);
END;

--10.

DECLARE
    NUMERO1 NUMBER:=20;
    NUMERO2 NUMBER:=5;
    NUMERO3 NUMBER:=NUMERO1+NUMERO2;
    
BEGIN
    DBMS_OUTPUT.put_line(NUMERO1 || '+' || NUMERO2 || ' es igual a' || NUMERO3);
END;

--11

DECLARE
    FECHA DATE :=SYSDATE;
BEGIN
    DBMS_OUTPUT.put_line(FECHA);
END;

--12

DECLARE
    FECHA VARCHAR2(4):= TO_CHAR(SYSDATE,'YYYY');
BEGIN
    DBMS_OUTPUT.put_line(FECHA);
END;