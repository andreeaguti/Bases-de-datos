
/*Ejercicio 1: Primero de primaria escribe un procedimiento que devuelva como resultado la suma 
de dos números enteros los cuales se le pasan como parámetros */

DELIMITER $$
DROP PROCEDURE IF EXISTS primero_primaria $$

CREATE PROCEDURE primero_primaria(
IN num1 INT,
IN num2 INT,
OUT suma INT
)
BEGIN
	SET suma = num1 + num2;
END$$ 
DELIMITER ;

SET @m_num1 = 5;  
SET @m_num2 = 5;
SET @m_suma = 0;  

CALL primero_primaria(@m_num1, @m_num2, @m_suma);

SELECT @m_suma AS Suma;

/*Ejercicio 2: ¿Segundo de primaria? escribe un procedimiento que devuelva como resultados la 
suma y la multiplicación de dos números enteros. El resultado de la multiplicación debe 
devolverse en la misma variable que determina el segundo número  */

DELIMITER $$
CREATE PROCEDURE segundo_primaria(
IN num1 INT,
INOUT num2 INT,
OUT suma INT
)
BEGIN
	SET suma = num1 + num2;
    SET num2 = num1 * num2;
END$$ 

SET @mi_num2 = 5; 
SET @mi_suma = 0;

CALL segundo_primaria(5, @mi_num2, @mi_suma);

SELECT @mi_num2 AS Multiplicacion, @mi_suma AS Suma;


/*Ejercicio 3: Recuperación del primer ciclo rehaz la actividad 1 con una función en lugar de un 
procedimiento*/

DELIMITER $$
CREATE FUNCTION recuperacion(num1 INT, num2 INT)
RETURNS INT /*Indica qué tipo de dato será el resultado*/
DETERMINISTIC
BEGIN
	RETURN num1 + num2;
END$$

SELECT recuperacion(5,5);

/*Ejercicio 4: Día sin IVA crea un procedimiento que reciba como parámetro un precio y calcule su 
precio sin IVA (considera IVA al 21%), devolviéndolo en una variable */
DROP PROCEDURE IF EXISTS dia_sinIva;

DELIMITER $$
CREATE PROCEDURE dia_sinIva(
IN precio DOUBLE,
OUT division DOUBLE
)
BEGIN
	SET division = precio / 1.21;
END$$ 
DELIMITER ;

SET @m_precio = 100;
SET @m_division = 0; 
 
CALL dia_sinIva(@m_precio, @m_division);

SELECT @m_division AS DiaSinIVA;



/*Ejercicio 5: Del calendario no Crear una función para mostrar el día de la semana según el valor de 
entrada numérico: 1 para lunes, 2 para martes, etc…  */

DROP FUNCTION IF EXISTS calendario;

DELIMITER $$

CREATE FUNCTION calendario(p_dia INT) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE nombre_dia VARCHAR(20);
    
    CASE p_dia
        WHEN 1 THEN SET nombre_dia = 'Lunes';
        WHEN 2 THEN SET nombre_dia = 'Martes';
        WHEN 3 THEN SET nombre_dia = 'Miercoles';
        WHEN 4 THEN SET nombre_dia = 'Jueves';
        WHEN 5 THEN SET nombre_dia = 'Viernes';
        WHEN 6 THEN SET nombre_dia = 'Sabado';
        WHEN 7 THEN SET nombre_dia = 'Domingo';
        ELSE SET nombre_dia = 'Error';
    END CASE;
    
    RETURN nombre_dia; 
END$$
DELIMITER ;

SELECT calendario(1);


/*Ejercicio 6: Esto compila… y calcula crear una función calculadora que realice operaciones con dos 
números decimales. La operación a realizar depende de un tercer parámetro que puede 
ser suma, resta, mult o div   */

USE Actividad02_UD4;
DROP FUNCTION IF EXISTS calculadora;

DELIMITER $$

CREATE FUNCTION calculadora(n1 DOUBLE, n2 DOUBLE, operacion VARCHAR(20)) 
RETURNS DOUBLE /*Indica qué tipo de dato será el resultado*/
DETERMINISTIC
BEGIN
	DECLARE resultado DOUBLE;
    CASE operacion
     WHEN 'suma' THEN SET resultado =  n1 + n2;
     WHEN 'resta' THEN SET resultado =  n1 - n2;
     WHEN 'multiplicacion' THEN SET resultado =  n1 * n2;
     WHEN 'div' THEN 
            IF n2 <> 0 THEN
                SET resultado = n1 / n2;
            ELSE
                SET resultado = NULL; 
            END IF;
        ELSE 
            SET resultado = 0;
     END CASE;
     
     RETURN resultado; 
END$$

DELIMITER ;

SELECT calculadora(5, 5, 'suma') AS ResultadoSuma;
SELECT calculadora(5, 5, 'resta') AS ResultadoResta;
SELECT calculadora(5, 5, 'multiplicacion') AS ResultadoMultiplicacion;
SELECT calculadora(5, 5, 'div') AS ResultadoDiv;
SELECT calculadora(5, 0, 'div') AS ResultadoDivMala;


/*Ejercicio 7: El factorial crea un procedimiento que calcule el factorial de N. N será un número 
proporcionado por el usuario como argumento al procedimiento*/

DROP PROCEDURE IF EXISTS factorial;

DELIMITER $$

CREATE PROCEDURE factorial(
    IN n INT,
    OUT res BIGINT
)
BEGIN
    SET res = 1;

    IF n < 0 THEN
        SET res = NULL; 
    ELSE
        WHILE n > 1 DO
            SET res = res * n;
            SET n = n - 1;
        END WHILE;
    END IF;
END$$

DELIMITER ;


SET @m_res = 0;
CALL factorial(5, @m_res);
SELECT @m_res AS Factorial_de_5;


CALL factorial(10, @m_res);
SELECT @m_res AS Factorial_de_10;



/*Ejercicio 8: El mismo saco crea un procedimiento que introduce en una tabla denominada 
“impares” los primeros 50 números impares   */

-- Primero, nos aseguramos de que la tabla existe para poder insertar los datos
CREATE TABLE IF NOT EXISTS impares (
    numero INT
);

DROP PROCEDURE IF EXISTS mismo_saco;

DELIMITER $$

CREATE PROCEDURE mismo_saco()
BEGIN
    DECLARE contador INT DEFAULT 1;       -- Para contar cuántos números llevamos
    DECLARE numero_actual INT DEFAULT 1;  -- El número impar que vamos a meter
    

    -- Queremos exactamente los primeros 50 números impares
    WHILE contador <= 50 DO
        INSERT INTO impares (numero) VALUES (numero_actual);
        
        SET numero_actual = numero_actual + 2;
        -- Incrementamos el contador
        SET contador = contador + 1;
    END WHILE;
END$$

DELIMITER ;

-- Llamamos al procedimiento
CALL mismo_saco();

-- Comprobamos que la tabla tiene los 50 números
SELECT * FROM impares;
