DROP DATABASE IF EXISTS empleados;
CREATE DATABASE IF NOT EXISTS empleados;
USE empleados;

DROP TABLE IF EXISTS dept_emp,
                     empleado, 
                     departamento;

CREATE TABLE empleado (
    cod_empleado      INT             NOT NULL,
    fecha_nacimiento  DATE            NOT NULL,
    nombre  VARCHAR(14)     NOT NULL,
    apellido   VARCHAR(16)     NOT NULL,
    sexo      ENUM ('M','F')  NOT NULL,    
    fecha_contratacion  DATE            NOT NULL,
    PRIMARY KEY (cod_empleado)
);

CREATE TABLE departamento (
    cod_departamento     CHAR(4)         NOT NULL,
    nombre_departamento   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (cod_departamento),
    UNIQUE  KEY (nombre_departamento)
);

CREATE TABLE dept_emp (
    cod_empleado      INT             NOT NULL,
    cod_departamento     CHAR(4)         NOT NULL,
    fecha_desde   DATE            NOT NULL,
    fecha_hasta     DATE            NOT NULL,
    FOREIGN KEY (cod_empleado)  REFERENCES empleado   (cod_empleado)  ON DELETE CASCADE,
    FOREIGN KEY (cod_departamento) REFERENCES departamento (cod_departamento) ON DELETE CASCADE,
    PRIMARY KEY (cod_empleado,cod_departamento)
);

INSERT INTO `empleado` VALUES (10001,'1953-09-02','Georgi','Facello','M','2021-06-26'),
(10002,'1964-06-02','Bezalel','Simmel','F','2018-11-21'),
(10003,'1979-12-03','Parto','Bamford','M','2019-08-28'),
(10004,'1982-05-01','Chirstian','Koblick','M','2022-12-01'),
(10005,'1983-01-21','Kyoichi','Maliniak','M','2019-09-12'),
(10006,'1990-04-20','Anneke','Preusig','F','2018-06-02'),
(10007,'1965-05-23','Tzvetan','Zielinski','F','2018-02-10'),
(10008,'1990-02-19','Saniya','Kalloufi','M','2021-09-15'),
(10009,'1991-04-19','Sumant','Peac','F','2019-02-18'),
(10010,'1978-06-01','Duangkaew','Piveteau','F','2018-08-24'),
(10011,'1972-11-07','Mary','Sluis','F','2018-01-22'),
(10012,'1988-09-02','Lucas','Perez','M','2019-06-26');

INSERT INTO `departamento` VALUES 
('d001','Marketing'),
('d002','Finance'),
('d003','Human Resources'),
('d004','Production'),
('d005','Development'),
('d006','Quality Management'),
('d007','Sales'),
('d008','Research'),
('d009','Customer Service'),
('d010','IT');

INSERT INTO `dept_emp` VALUES (10001,'d006','2021-06-26','9999-01-01'),
(10002,'d006','2018-11-21','9999-01-01'),
(10003,'d004','2019-08-28','9999-01-01'),
(10004,'d004','2022-12-01','9999-01-01'),
(10005,'d004','2019-09-12','9999-01-01'),
(10006,'d005','2018-06-02','9999-01-01'),
(10007,'d008','2018-02-10','9999-01-01'),
(10008,'d006','2021-09-15','2022-07-31'),
(10009,'d006','2019-02-18','9999-01-01'),
(10010,'d004','2018-08-24','2020-10-11'),
(10010,'d006','2020-10-12','9999-01-01'),
(10011,'d005','2018-01-22','2019-09-10'),
(10012,'d005','2019-06-26','9999-01-01');

ALTER TABLE dept_emp
ADD salario DECIMAL (10,2);

UPDATE dept_emp SET salario = 34000.00 WHERE cod_empleado = '10001';
UPDATE dept_emp SET salario = 20000.00 WHERE cod_empleado = '10002';
UPDATE dept_emp SET salario = 22000.00 WHERE cod_empleado = '10003';
UPDATE dept_emp SET salario = 29500.00 WHERE cod_empleado = '10004';
UPDATE dept_emp SET salario = 34000.00 WHERE cod_empleado = '10005';
UPDATE dept_emp SET salario = 34000.00 WHERE cod_empleado = '10006';
UPDATE dept_emp SET salario = 34000.00 WHERE cod_empleado = '10007';
UPDATE dept_emp SET salario = 34000.00 WHERE cod_empleado = '10008';
UPDATE dept_emp SET salario = 34000.00 WHERE cod_empleado = '10009';
UPDATE dept_emp SET salario = 34000.00 WHERE cod_empleado = '10010';
UPDATE dept_emp SET salario = 34000.00 WHERE cod_empleado = '10011';
UPDATE dept_emp SET salario = 34000.00 WHERE cod_empleado = '10012';


/*EJERCICIO 1: ¿Cuántos empleados trabajan en el departamento de gestión de calidad? */
SELECT COUNT(de.cod_empleado) AS total_empleados
FROM dept_emp de
INNER JOIN departamento d ON de.cod_departamento = d.cod_departamento
WHERE d.nombre_departamento = 'Quality Management';

/*EJERCICIO 2: ¿Quién es el empleado mejor pagado del departamento de desarrollo? Aporta su nombre, apellido y salario. */
SELECT de.salario, e.nombre, e.apellido
FROM dept_emp de
INNER JOIN departamento d ON de.cod_departamento = d.cod_departamento
INNER JOIN empleado e ON de.cod_empleado = e.cod_empleado
WHERE d.nombre_departamento = 'Development'
ORDER BY de.salario DESC
LIMIT 1;

/*EJERCICIO 3: ¿Cuál es el nombre y apellido del último empleado contratado en el departamento de producción? ¿En qué fecha fue contratado? */
SELECT e.nombre, e.apellido, de.nombre_departamento, dep.fecha_desde
FROM empleado e
INNER JOIN dept_emp dep ON e.cod_empleado = dep.cod_empleado
INNER JOIN departamento de ON de.cod_departamento = dep.cod_departamento
WHERE de.nombre_departamento = 'Production'
ORDER BY dep.fecha_Desde DESC
LIMIT 1;

/*EJERCICIO 4: Calcular el salario medio de los trabajadores del departamento de producción. */
SELECT AVG(dep.salario) AS media_salario
FROM dept_emp dep
INNER JOIN departamento de ON de.cod_departamento = dep.cod_departamento
WHERE de.nombre_departamento = 'Production';

/*EJERCICIO 5: Mostrar el nombre, apellido y fecha de contratación del empleado que menos gana en el departamento de producción. También muestra su salario. */
SELECT e.nombre, e.apellido, dep.fecha_desde, dep.salario
FROM empleado e
INNER JOIN dept_emp dep ON e.cod_empleado = dep.cod_empleado
INNER JOIN departamento de ON de.cod_departamento = dep.cod_departamento
WHERE de.nombre_departamento = 'Production'
ORDER BY dep.salario ASC
LIMIT 1;

/*EJERCICIO 6: Muestra el nombre, apellidos, sexo y salario del empleado peor pagado de cada departamento. */
SELECT e.nombre, e.apellido, e.sexo, dep.salario, de.nombre_departamento
FROM empleado e
INNER JOIN dept_emp dep ON e.cod_empleado = dep.cod_empleado
INNER JOIN departamento de ON de.cod_departamento = dep.cod_departamento
WHERE (dep.cod_departamento, dep.salario) IN (
    -- Esta subconsulta busca el sueldo más bajo por cada código de departamento
    SELECT cod_departamento, MIN(salario)
    FROM dept_emp
    GROUP BY cod_departamento
);

/*EJERCICIO 7: Calcula el salario medio por sexo. */
SELECT e.sexo, AVG(dep.salario) AS salario_medio
FROM empleado e
INNER JOIN dept_emp dep ON e.cod_empleado = dep.cod_empleado
GROUP BY e.sexo;

/*EJERCICIO 8: Calcula el coste salarial total de todos los empleados del departamento de desarrollo. */
SELECT SUM(dep.salario) AS coste_salarial_total
FROM dept_emp dep
INNER JOIN departamento d ON dep.cod_departamento = d.cod_departamento
WHERE d.nombre_departamento = 'Development';

/*EJERCICIO 9: Calcula el coste salarial total de todos los empleados del departamento de producción que trabajan actualmente en él. */
SELECT SUM(dep.salario) AS coste_total_actual_produccion
FROM dept_emp dep
INNER JOIN departamento de ON dep.cod_departamento = de.cod_departamento
WHERE de.nombre_departamento = 'Production'
  AND dep.fecha_hasta = '9999-02-02';
  
/*EJERCICIO 10: Identifica el departamento con el mayor número de empleados actualmente asignados y muestra el nombre del departamento junto con la cantidad de empleados.*/
SELECT d.nombre_departamento, COUNT(de.cod_empleado) AS cantidad_empleados
FROM dept_emp de
INNER JOIN departamento d ON de.cod_departamento = d.cod_departamento
WHERE de.fecha_hasta = '9999-02-02'
GROUP BY d.nombre_departamento
ORDER BY cantidad_empleados DESC
LIMIT 1;