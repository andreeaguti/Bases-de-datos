DROP DATABASE IF EXISTS Negocio; 
CREATE DATABASE Negocio; 
USE Negocio; 
 
CREATE TABLE Coche ( 
 cod_coche CHAR(2) PRIMARY KEY, 
    matricula VARCHAR (15),  
    marca VARCHAR (50), 
    modelo VARCHAR (50) 
); 
 
CREATE TABLE Departamento ( 
 cod_departamento CHAR(2) PRIMARY KEY, 
    nombre VARCHAR(100), 
    ubicacion VARCHAR(100) 
); 
 
CREATE TABLE Empleados ( 
 cod_empleado CHAR(2) PRIMARY KEY, 
    dni VARCHAR(9), 
    nombre VARCHAR(30), 
    apellidos VARCHAR(30), 
    fecha_nacimiento DATE, 
    cod_departamento CHAR(2), 
    cod_coche CHAR(2), 
    CONSTRAINT FK_empleado_coche FOREIGN KEY (cod_coche) REFERENCES Coche (cod_coche), 
    CONSTRAINT FK_empleado_departamento FOREIGN KEY (cod_departamento) REFERENCES 
Departamento (cod_departamento) 
);

/*Crea al empleado #1, al departamento #1 y al coche de empresa #1.*/
INSERT INTO Departamento (cod_departamento, nombre, ubicacion)
VALUES (1,'Marketing', 'Planta Baja');

INSERT INTO Coche (cod_coche, matricula, marca, modelo)
VALUES (1, '9567KLP', 'seat', 'leon');

INSERT INTO Empleados (cod_empleado, dni, nombre, apellidos, fecha_nacimiento, cod_departamento, cod_coche)
VALUES (1, '72209248J' , 'Andrea', 'Gutierrez', '2002-03-07', 1, 1);

/*Crea 3 empleados más, utilizando una única sentencia. */
INSERT INTO Empleados (cod_empleado, dni, nombre, apellidos, fecha_nacimiento, cod_departamento, cod_coche)
VALUES (2, '72309248J' , 'Irene', 'Abajas', '2002-02-04', 1, 1),
(3, '72309948J' , 'Julene', 'Gomez', '2002-08-04', 1, 1),
(4, '72309248P' , 'Cristina', 'Iglesias', '2002-06-04', 1, 1);

/*Crea el coche de empresa #2, el cual sólo se identifica por su matrícula. */
INSERT INTO Coche (cod_coche, matricula)
VALUES (2, '9567KGP');

/*Cambia el nombre del empleado #2 a "Carlos".*/
UPDATE Empleados
SET nombre = 'Carlos'
WHERE cod_empleado = 2;

/*Cambia el nombre del departamento #1 a "IT".*/
UPDATE Departamento
SET nombre = 'IT'
WHERE cod_departamento = 1;

/*Cambia la marca a "Seat" y el modelo a "Ibiza" en el coche de empresa #2.*/
UPDATE Coche
SET marca = 'Seat', modelo= 'Ibiza'
WHERE cod_coche = 2;

/*Elimina al empleado #4. */
DELETE FROM Empleados
WHERE cod_empleado = 4;

/*Elimina coche de empresa #2. */
DELETE FROM Coche WHERE cod_coche = 2;

SELECT * FROM Empleados; /*Veo todos los cambios*/

/*Elimina todos los registros.*/
DELETE FROM Empleados;
DELETE FROM Coche;
