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
 