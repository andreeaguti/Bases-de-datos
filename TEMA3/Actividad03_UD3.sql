DROP DATABASE IF EXISTS taxi;
CREATE DATABASE taxi;
USE taxi;

CREATE TABLE Taxi (
matricula CHAR(9) PRIMARY KEY,
marca VARCHAR(20),
modelo VARCHAR(20),
num_pasajeros INT,
es_adaptado BOOLEAN
);
CREATE TABLE Conductor (
dni_nie VARCHAR(10) PRIMARY KEY,
nombre VARCHAR(30),
apellidos VARCHAR(50),
direccion VARCHAR(100),
matricula CHAR(9),
FOREIGN KEY (matricula) REFERENCES taxi(matricula)
);
CREATE TABLE Carrera (
id_carrera INT AUTO_INCREMENT PRIMARY KEY,
origen VARCHAR(100),
destino VARCHAR(100),
precio DECIMAL(6, 2),
es_nocturna BOOLEAN,
matricula CHAR(9),
FOREIGN KEY (matricula) REFERENCES taxi(matricula)
);

INSERT INTO Taxi VALUES ('1234 CHB', 'Toyota', 'Prius', 4, TRUE);
INSERT INTO Taxi VALUES ('3243 CHB', 'Audi', 's-line', 4, FALSE);
INSERT INTO Taxi VALUES ('2345 CHB', 'Citroen', 'ds', 4, TRUE);
INSERT INTO Taxi VALUES ('2378 CHB', 'Passat', 'v16', 4, TRUE);
INSERT INTO Taxi VALUES ('7069 CHB', 'Mercedes', 'Benz', 4, FALSE);

INSERT INTO Conductor VALUES ('11111111N', 'Juan','Garcia' , 'Calle a', '3243 CHB');
INSERT INTO Conductor VALUES ('22222222K', 'Ana', 'Garcia' ,'Calle b', '2345 CHB');
INSERT INTO Conductor VALUES ('33333333L', 'Luis', 'Lopez' ,'Calle c', '2378 CHB');
INSERT INTO Conductor VALUES ('44444444J', 'Marta', 'Ruiz' ,'Calle d', '7069 CHB');
INSERT INTO Conductor VALUES ('55555555Y', 'Irene', 'Sainz' ,'Calle e', '7069 CHB');

INSERT INTO Carrera VALUES (1, 'Centro','Aeropuerto' , 22.50, FALSE, '1234 CHB');
INSERT INTO Carrera VALUES (2, 'Estacion', 'Hotel' ,12.00, TRUE, '3243 CHB');
INSERT INTO Carrera VALUES (3, 'Calle Mayor', 'Hospital' ,10.00, FALSE, '2345 CHB');
INSERT INTO Carrera VALUES (4, 'Puerto', 'Centro', 15.00, TRUE, '2345 CHB');
INSERT INTO Carrera VALUES (5, 'Norte', 'Domicilio' ,8.50, TRUE, '2378 CHB');
INSERT INTO Carrera VALUES (6, 'Aeropuerto', 'Norte' ,30.00, TRUE, '2378 CHB');
INSERT INTO Carrera VALUES (7, 'Sur', 'Centro' ,20.00, FALSE,'7069 CHB');
INSERT INTO Carrera VALUES (8, 'Estacion', 'Barrio' , 11.00, TRUE, '7069 CHB');

/*Ejercicio 01: Muestra la matrícula, marca y modelo de todos los coches que tienen asignado un conductor (y los datos de los conductores -DNI/NIE y nombre-). */
SELECT t.matricula, t.marca, t.modelo, c.dni_nie, c.nombre
FROM Taxi t
INNER JOIN Conductor c ON t.matricula = c.matricula;

/*Ejercicio 02: Muestra el origen y destino de todos los servicios, así como la matrícula del taxi que se utilizó y si estaba adaptado para clientes discapacitados */
SELECT c.origen, c.destino, t.matricula, t.es_adaptado
FROM Carrera c 
INNER JOIN Taxi t ON c.matricula = t.matricula;


/*Ejercicio 03: Lista todos los nombres de conductores y DNI/NIE y sus respectivos coches (marca, modelo, matrícula y número de pasajeros). */
SELECT c.nombre, c.dni_nie, t.marca, t.modelo, t.matricula, t.num_pasajeros
FROM Conductor c
INNER JOIN Taxi t ON c.matricula = t.matricula;

/*Ejercicio 04: Enumera todos los detalles de todos los taxis y todos los conductores. */
SELECT * FROM Taxi t
LEFT JOIN Conductor c ON t.matricula = c.matricula;

/*Ejercicio 05: Muestra todos los detalles de todos los servicios y todos los taxis. */
SELECT * FROM Carrera c
LEFT JOIN Taxi t ON c.matricula = t.matricula;
