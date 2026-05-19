DROP DATABASE IF EXISTS repasando_triggers;
CREATE DATABASE IF NOT EXISTS repasando_triggers;
USE repasando_triggers;

DROP TABLE IF EXISTS historial_ventas;

CREATE TABLE parroquiano (
fecha_nacimiento DATE, 
nombre VARCHAR(50)
); 
Changeme1*--

/*Ejercicio 1: El portero del Malaspina dada la siguiente tabla, crear un trigger que ponga la edad 
como NULL si se detecta que la persona introducida es menor de edad*/
DELIMITER $$ 

	DROP TRIGGER IF EXISTS malaspina;
 
CREATE TRIGGER malaspina
BEFORE INSERT ON parroquiano  
FOR EACH ROW  --
BEGIN  
	IF TIMESTAMPDIFF (YEAR, NEW.fecha_nacimiento, CURDATE()) <18
		THEN SET NEW.edad = NULL;
	END IF;
END $$

DELIMITER ;

/*EJERCICIO 2:Tu gran boda americana considera la siguiente tabla:
CREATE TABLE employees (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
lastname VARCHAR(50) NOT NULL
);

Se debe implementar un trigger que registre los cambios de apellido de cada empleado, y la fecha cuando estos 
se produjeron. Además, la tabla de employees no almacenará ningún cambio de apellidos si el nuevo apellido es 
igual que el antiguo: en tal caso no se registrará nada.*/

-- Limpiamos las tablas por si ya existían de ejecuciones anteriores
-- 1. Borramos las tablas de la prueba por si acaso existían de antes
DROP TABLE IF EXISTS boda_history;
DROP TABLE IF EXISTS boda_employees;

-- 2. Creamos las tablas con nombres únicos ('boda_employees')
CREATE TABLE boda_employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL
);

CREATE TABLE boda_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    old_lastname VARCHAR(50) NOT NULL,
    new_lastname VARCHAR(50) NOT NULL,
    change_date DATETIME NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES boda_employees(id)
);

-- 3. Creamos el Trigger asociado a nuestra tabla única
DELIMITER $$

CREATE TRIGGER after_boda_lastname_update
AFTER UPDATE ON boda_employees
FOR EACH ROW
BEGIN
    -- Comprobamos si el apellido realmente ha cambiado
    IF OLD.lastname <> NEW.lastname THEN
        INSERT INTO boda_history (employee_id, old_lastname, new_lastname, change_date)
        VALUES (OLD.id, OLD.lastname, NEW.lastname, NOW());
    END IF;
END$$

DELIMITER ;
-- Desactivamos temporalmente el modo seguro
SET SQL_SAFE_UPDATES = 0;

-- COMPROBACIÓN 1: Cambiamos a un apellido NUEVO
UPDATE boda_employees 
SET lastname = 'Bouvier' 
WHERE name = 'Homer';

SELECT * FROM boda_history;

-- COMPROBACIÓN 2: Intentamos cambiar al MISMO apellido
UPDATE boda_employees 
SET lastname = 'Bouvier' 
WHERE name = 'Homer';

SELECT * FROM boda_history;

-- Lo volvemos a activar por seguridad
SET SQL_SAFE_UPDATES = 1;

/*EJERCICIO 3: Ya no me llamo así en el ejemplo anterior hemos registrado una auditoría de apellidos. Ahora vamos a crear un trigger que registre tanto cambios de nombre 
como de apellidos. Para ello, se propone la creación de una tabla como la que se expone a continuación:
CREATE TABLE employees_audit (
id INT AUTO_INCREMENT PRIMARY KEY,
employeeNumber INT NOT NULL,
campoModificado VARCHAR(50) NOT NULL,
valorAntiguo VARCHAR(50) NOT NULL,
valorNuevo VARCHAR(50) NOT NULL,
changedate DATETIME DEFAULT NULL
);
En campoModificado guardaremos nombre o apellido según corresponda, así como almacenaremos los valores antiguos y 
nuevos (y la fecha del cambio).*/
-- 1. Creamos la tabla de auditoría tal y como pide el enunciado
DROP TABLE IF EXISTS employees_audit;

CREATE TABLE employees_audit ( 
    id INT AUTO_INCREMENT PRIMARY KEY, 
    employeeNumber INT NOT NULL, 
    campoModificado VARCHAR(50) NOT NULL, 
    valorAntiguo VARCHAR(50) NOT NULL, 
    valorNuevo VARCHAR(50) NOT NULL, 
    changedate DATETIME DEFAULT NULL 
);

-- 2. Creamos el nuevo Trigger
DELIMITER $$

CREATE TRIGGER after_boda_fullname_update
AFTER UPDATE ON boda_employees
FOR EACH ROW
BEGIN
    -- Evaluación para el NOMBRE
    IF OLD.name <> NEW.name THEN
        INSERT INTO employees_audit (employeeNumber, campoModificado, valorAntiguo, valorNuevo, changedate)
        VALUES (OLD.id, 'nombre', OLD.name, NEW.name, NOW());
    END IF;

    -- Evaluación para el APELLIDO
    IF OLD.lastname <> NEW.lastname THEN
        INSERT INTO employees_audit (employeeNumber, campoModificado, valorAntiguo, valorNuevo, changedate)
        VALUES (OLD.id, 'apellido', OLD.lastname, NEW.lastname, NOW());
    END IF;
END$$

DELIMITER ;

-- ---------------------------------------------------------
-- PRUEBAS DE COMPROBACIÓN
-- ---------------------------------------------------------

-- Desactivamos el modo seguro temporalmente para poder hacer los UPDATE por nombre
SET SQL_SAFE_UPDATES = 0;

-- Reseteamos el empleado de prueba para saber exactamente qué datos tiene
DELETE FROM boda_employees;
INSERT INTO boda_employees (name, lastname) VALUES ('Homer', 'Simpson');


-- COMPROBACIÓN 1: Cambiamos NOMBRE y APELLIDO a la vez (Debe insertar DOS filas)
UPDATE boda_employees 
SET name = 'Max', lastname = 'Power' 
WHERE name = 'Homer';

-- Miramos la auditoría (Deberías ver una fila para el nombre y otra para el apellido)
SELECT * FROM employees_audit;


-- COMPROBACIÓN 2: Cambiamos solo el APELLIDO (Debe insertar UNA sola fila)
UPDATE boda_employees 
SET lastname = 'Bouvier' 
WHERE name = 'Max';

-- Miramos la auditoría otra vez (Ahora debería haber 3 filas en total)
SELECT * FROM employees_audit;


-- COMPROBACIÓN 3: Intentamos actualizar con los mismos datos actuales (Debe IGNORARLO)
UPDATE boda_employees 
SET name = 'Max', lastname = 'Bouvier' 
WHERE name = 'Max';

-- Comprobamos que el número de filas no ha aumentado
SELECT * FROM employees_audit;

-- Volvemos a activar el modo seguro
SET SQL_SAFE_UPDATES = 1;

/*EJERCICIO 4: La penúltima y nos vamos vuelve al ejemplo anterior. Añade los cambios necesarios para que en caso 
de que se produzca una modificación, esta se realice en la tabla employees. */
-- 1. Borramos el trigger anterior para que no choque con este
DROP TRIGGER IF EXISTS after_boda_fullname_update;

-- 2. Creamos el nuevo Trigger BEFORE UPDATE
DELIMITER $$

CREATE TRIGGER before_boda_fullname_update
BEFORE UPDATE ON boda_employees
FOR EACH ROW
BEGIN
    -- Evaluación para el NOMBRE
    IF OLD.name <> NEW.name THEN
        -- Registramos en la auditoría
        INSERT INTO employees_audit (employeeNumber, campoModificado, valorAntiguo, valorNuevo, changedate)
        VALUES (OLD.id, 'nombre', OLD.name, NEW.name, NOW());
        
        -- Aquí es donde aseguramos/modificamos el valor que se va a guardar en la tabla.
        -- Por ejemplo, podríamos forzar a que el nombre siempre se guarde en MAYÚSCULAS:
        SET NEW.name = UPPER(NEW.name);
    END IF;

    -- Evaluación para el APELLIDO
    IF OLD.lastname <> NEW.lastname THEN
        -- Registramos en la auditoría
        INSERT INTO employees_audit (employeeNumber, campoModificado, valorAntiguo, valorNuevo, changedate)
        VALUES (OLD.id, 'apellido', OLD.lastname, NEW.lastname, NOW());
        
        -- Forzamos también el apellido a MAYÚSCULAS antes de que se guarde en la tabla
        SET NEW.lastname = UPPER(NEW.lastname);
    END IF;
END$$

DELIMITER ;

-- ---------------------------------------------------------
-- PRUEBAS DE COMPROBACIÓN
-- ---------------------------------------------------------

SET SQL_SAFE_UPDATES = 0;

-- Limpiamos las tablas para ver el resultado limpio
DELETE FROM boda_employees;
DELETE FROM employees_audit;

-- Insertamos el empleado inicial (en minúsculas/normal)
INSERT INTO boda_employees (name, lastname) VALUES ('Homer', 'Simpson');


-- COMPROBACIÓN: Hacemos una modificación normal
UPDATE boda_employees 
SET name = 'Max', lastname = 'Power' 
WHERE name = 'Homer';


-- 1. Comprobamos la tabla principal: verás que la modificación SE HA REALIZADO 
-- y además el trigger ha actuado sobre los datos transformándolos a MAYÚSCULAS.
SELECT * FROM boda_employees;

-- 2. Comprobamos la auditoría: se han registrado los cambios correctamente
SELECT * FROM employees_audit;

SET SQL_SAFE_UPDATES = 1;

/*EJERCICIO 5 La última no es la más difícil, ¿o sí? muestra un mensaje de error si alguien intenta introducir números
 al actualizar su nombre. Puedes basarte en tu desarrollo de la actividad 2.*/
 -- 1. Creamos el Trigger BEFORE UPDATE
-- Usamos BEFORE porque queremos frenar el cambio ANTES de que se guarde en la tabla
DELIMITER $$

CREATE TRIGGER before_boda_name_numeric_check
BEFORE UPDATE ON boda_employees
FOR EACH ROW
BEGIN
    -- Validamos si el NOMBRE ha cambiado Y si el nuevo nombre contiene algún número
    -- '[0-9]' busca cualquier dígito del 0 al 9 en la cadena
    IF OLD.name <> NEW.name AND NEW.name REGEXP '[0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El nombre de un empleado no puede contener números.';
    END IF;
END$$

DELIMITER ;

-- ---------------------------------------------------------
-- PRUEBAS DE COMPROBACIÓN
-- ---------------------------------------------------------

SET SQL_SAFE_UPDATES = 0;

-- Reseteamos el empleado de prueba
DELETE FROM boda_employees;
INSERT INTO boda_employees (name, lastname) VALUES ('Homer', 'Simpson');


-- COMPROBACIÓN 1: Intento de actualización INCORRECTO (Con números)
-- Esto DEBE fallar y mostrar tu mensaje de error personalizado
UPDATE boda_employees 
SET name = 'Homer3000' 
WHERE name = 'Homer';

-- Si lanzas un SELECT aquí, verás que el nombre sigue siendo 'Homer' (el cambio se bloqueó)
SELECT * FROM boda_employees;


-- COMPROBACIÓN 2: Intento de actualización CORRECTO (Solo letras)
-- Esto debe funcionar sin ningún problema
UPDATE boda_employees 
SET name = 'Max' 
WHERE name = 'Homer';

-- Verificamos que este cambio sí se ha realizado con éxito
SELECT * FROM boda_employees;

SET SQL_SAFE_UPDATES = 1;
