-- 1 . Crear un disparador que consiga mantener actualizada la tabla transacción 
-- cada vez que se modifique la tabla cuenta (se cambie el atributo balance).

    CREATE TABLE CUENTAS(
    NRO_CUENTA VARCHAR2(10) NOT NULL,
    BALANCE NUMBER,
    CONSTRAINT PK_CUENTA PRIMARY KEY (NRO_CUENTA));

    CREATE TABLE TRANSACCION(
    NRO_CUENTA VARCHAR2(10) NOT NULL,
    HORA_MODIFICACION DATE NOT NULL,
    ID_CLIENTE VARCHAR2(10),
    ANT_BALANCE NUMBER,
    ACT_BALANCE NUMBER,
    CONSTRAINT PK_TRANSACCION PRIMARY KEY (NRO_CUENTA, HORA_MODIFICACION),
    CONSTRAINT FK_TRANS_CUENTAS FOREIGN KEY (NRO_CUENTA) REFERENCES CUENTAS (NRO_CUENTA)
    );

    -- Crear el disparador. 
    -- Como pide mantener actualizada transacción tras actualizar balance de cuentas, sera AFETER UPDATE

    CREATE OR REPLACE TRIGGER ACTUALIZAR_TRANS
    AFTER UPDATE OF BALANCE ON CUENTAS
    FOR EACH ROW
    BEGIN
        UPDATE TRANSACCION SET ANT_BALANCE=:OLD.BALANCE, ACT_BALANCE=:NEW.BALANCE
        WHERE NRO_CUENTA=:NEW.NRO_CUENTA;
    END;

    --DROP TRIGGER ACTUALIZAR_TRANS;

/* 2- Supongamos que tenemos una tabla de distancias de diferentes rutas y que
queremos guardar estas distancias en kilómetros y en millas.
Distancias: PK ruta (10 caracteres), distancia_k (numérico), distancia_m (numérico).
Crear disparadores para conseguir que cuando se introduzca (o se modifique)
Una distancia en kilómetros, automáticamente se introduzca también en millas
y viceversa. (1 Km=0.621371 millas y 1 Milla=1.609344 Km)*/

    CREATE TABLE DISTANCIAS(
    RUTA VARCHAR2(10) NOT NULL,
    DISTANCIA_K NUMBER (20,5),
    DISTANCIA_M NUMBER (20,5),
    CONSTRAINT PK_DISTANCIAS PRIMARY KEY (RUTA));
    
    -- Crear disparador. Como dice actualizar millas al insertar o modificar km, sera after update
    
    CREATE OR REPLACE TRIGGER ACT_DISTANCIAS
    BEFORE INSERT OR UPDATE ON DISTANCIAS
    FOR EACH ROW
    DECLARE
        ERRORNULL EXCEPTION;
    BEGIN
        IF (:NEW.DISTANCIA_K IS NULL AND :NEW.DISTANCIA_M IS NULL) THEN
            RAISE ERRORNULL;
        ELSIF :NEW.DISTANCIA_M IS NULL THEN
            :NEW.DISTANCIA_M:=:NEW.DISTANCIA_K * 0.621371;
        ELSIF :NEW.DISTANCIA_K IS NULL THEN
            :NEW.DISTANCIA_K:=:NEW.DISTANCIA_M * 1.609344;
        END IF; 
    EXCEPTION
        WHEN ERRORNULL THEN
        RAISE_APPLICATION_ERROR (-20010, 'No se ha introducido ninguna distancia');
    END;
    
    INSERT INTO DISTANCIAS (RUTA, DISTANCIA_K) VALUES ('KK', 1);
    INSERT INTO DISTANCIAS (RUTA, DISTANCIA_M) VALUES ('KK2', 40);
    INSERT INTO DISTANCIAS VALUES ('KK3', NULL, NULL);
    
    -- DROP TRIGGER DISTANCIAS;
    DELETE DISTANCIAS;
    
-- 3. Transformar el siguiente esquema relacional haciendo desaparecer las claves ajenas mediante el uso de disparadores

	/*He estado planteándolo pero no me ha dado tiempo, si puedo y no has cerrado todavía la entrega 
	lo seguiré intentando :P*/
	
-- 4. Considerando las siguientes dos tablas,

    CREATE TABLE DEPARTAMENTOS (num_dep varchar2(10), nombre varchar2(10), presupuesto number,
    constraint pk_departamentos primary key (num_dep)
    );

    CREATE TABLE EMPLEADOS( nss number, nombre varchar2(10), salario number, num_dep varchar2(10),
    constraint pk_empleados primary key (nss),
    constraint fk_empl_dep foreign key (num_dep) references departamentos (num_dep));

    
    /*- Diseñar un disparador que al insertar un nuevo empleado, automáticamente
    quede actualizado el presupuesto total del departamento al que el empleado
    pertenece, añadiéndole el salario asignado al nuevo empleado.*/
    
    CREATE OR REPLACE TRIGGER ACT_PRESUPUESTO
    AFTER INSERT ON EMPLEADOS
    FOR EACH ROW
    BEGIN
        UPDATE DEPARTAMENTOS SET PRESUPUESTO= PRESUPUESTO + :NEW.SALARIO
        WHERE NUM_DEP=:NEW.NUM_DEP;
    END;
    
    -- Probar:
    
    INSERT INTO DEPARTAMENTOS VALUES('1', 'PROG', 10);
    INSERT INTO EMPLEADOS VALUES (234, 'GANDALF', 10, '1');
    INSERT INTO EMPLEADOS VALUES (235, 'KKCHIP', 10, '1');
    
   -- DELETE EMPLEADOS;
   -- DELETE DEPARTAMENTOS;

    /*- Diseñar un disparador que al modificar el salario de un empleado,
    automáticamente quede actualizado el presupuesto total del departamento al que
    el empleado pertenece, en función del nuevo salario asignado al empleado.*/
    
    CREATE OR REPLACE TRIGGER ACT_SALARIO
    AFTER UPDATE OF SALARIO ON EMPLEADOS
    FOR EACH ROW
    BEGIN
        UPDATE DEPARTAMENTOS SET PRESUPUESTO= PRESUPUESTO -:OLD.SALARIO
        WHERE NUM_DEP=:NEW.NUM_DEP;
        UPDATE DEPARTAMENTOS SET PRESUPUESTO= PRESUPUESTO +:NEW.SALARIO
        WHERE NUM_DEP=:NEW.NUM_DEP;
    END;
    
    -- Probar:
    
    UPDATE EMPLEADOS SET SALARIO=15 WHERE NSS='234';
    
/* 5- Si tenemos una serie de disparadores cuyo evento es el mismo y cuya acción
es la inserción de filas en una tabla, pero de forma que estén definidos de la
siguiente manera:
? 1 a nivel de orden con temporalidad BEFORE
? 1 a nivel de orden con temporalidad AFTER
? 1 a nivel de fila con temporalidad BEFORE
? 1 a nivel de fila con temporalidad AFTER
Determinar, mediante un ejemplo, el orden en que se irán activando dichos
disparadores mostrando como va variando el contenido de la tabla en la que se
inserta.*/

El orden de activación sería el siguiente:

tipo before a nivel de orden (solo se ejecuta una vez)
tipo before a nivel de fila (con each row, se ejecuta una vez para cada fila)
se ejecuta la orden que desencadena el trigger
tipo after a nivel de fila (con each row, se ejecuta una vez para cada fila)
tipo after a nivel de orden (solo se ejecuta una vez)


Ejemplo:
Insertar en matricular alumnos matriculados en asignaturas.

1,  Antes de insertar un alumno en matricular, verificar que existen menos de 30 matriculados.
    De manera que si ya hay 30 salte una excepción.
2,  Antes de insertar, comprobar si el alumno ya esta matriculado en esa asignatura.
3,  Despues de insertar, hacer un recuento del numero de matriculas que tiene cada alumno. 
4,  Actualizar el numero de alumnos matriculados.



            
        
    
    