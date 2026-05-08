DROP DATABASE IF EXISTS sistema_medico;
CREATE DATABASE IF NOT EXISTS sistema_medico;
USE sistema_medico;

-- Tabla ESPECIALIDAD
CREATE TABLE ESPECIALIDAD (
id_especialidad INT PRIMARY KEY AUTO_INCREMENT,
especialidad ENUM ('ENDODONCISTA','ORTODONCISTA','CIRUGIA','GENERAL','PERIODONCISTA') NOT NULL
);

-- Tabla ESTADO
CREATE TABLE ESTADO (
id_estado INT PRIMARY KEY AUTO_INCREMENT,
nombre ENUM ('PENDIENTE','ACTIVO','CANCELADO') NOT NULL
);

-- Tabla DOCTOR
CREATE TABLE DOCTOR (
id_doctor INT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL, 
id_especialidad INT NOT NULL,
fecha_nacimiento DATE,
direccion VARCHAR(255),
numero_colegiado CHAR (10),
FOREIGN KEY (id_especialidad)  REFERENCES ESPECIALIDAD (id_especialidad) ON DELETE CASCADE
);

-- Tabla PACIENTE
CREATE TABLE PACIENTE (
id_paciente INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100), 
apellido VARCHAR(100), 
telefono VARCHAR(20), 
correo_electronico VARCHAR(20),
fecha_nacimiento DATE
);

-- Tabla HISTORIAL_CLINICO
CREATE TABLE HISTORIAL_CLINICO (
id_historial_clinico INT PRIMARY KEY AUTO_INCREMENT,
id_paciente INT NOT NULL,
fecha_creacion DATE, 
grupo_sanguineo VARCHAR(5),
FOREIGN KEY (id_paciente)  REFERENCES PACIENTE (id_paciente) ON DELETE CASCADE
);

-- Tabla CITA
CREATE TABLE CITA (
id_cita INT PRIMARY KEY AUTO_INCREMENT,
fecha DATE NOT NULL,
hora TIME NOT NULL,
motivo TEXT,
id_estado INT NOT NULL,
id_paciente INT NOT NULL,
id_doctor INT NOT NULL,
FOREIGN KEY (id_estado)  REFERENCES ESTADO (id_estado) ON DELETE CASCADE,
FOREIGN KEY (id_paciente)  REFERENCES PACIENTE (id_paciente) ON DELETE CASCADE,
FOREIGN KEY (id_doctor)  REFERENCES DOCTOR (id_doctor) ON DELETE CASCADE
);

-- Tabla TRATAMIENTO
CREATE TABLE TRATAMIENTO (
id_tratamiento INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(150) NOT NULL,
descripcion TEXT
);

-- Tabla DETALLE_CITA
CREATE TABLE DETALLE_CITA (
id_detalle INT PRIMARY KEY AUTO_INCREMENT,
id_cita INT NOT NULL,
id_tratamiento INT NOT NULL,
observaciones TEXT,
FOREIGN KEY (id_cita)  REFERENCES CITA (id_cita) ON DELETE CASCADE,
FOREIGN KEY (id_tratamiento)  REFERENCES TRATAMIENTO (id_tratamiento) ON DELETE CASCADE
);

-- Inserciones en ESPECIALIDAD (Ajustado a nuestros nombres exactos)
INSERT INTO ESPECIALIDAD (especialidad) VALUES 
('GENERAL'), 
('ENDODONCISTA'), 
('ORTODONCISTA'), 
('CIRUGIA'), 
('PERIODONCISTA');

-- Inserciones en ESTADO
INSERT INTO ESTADO (nombre) VALUES 
('PENDIENTE'), 
('ACTIVO'), 
('CANCELADO');

-- Inserciones en TRATAMIENTO (15 tipos)
INSERT INTO TRATAMIENTO (nombre, descripcion) VALUES 
('Limpieza Bucal', 'Eliminación de sarro y placa bacteriana.'),
('Endodoncia Molar', 'Tratamiento del nervio en pieza posterior.'),
('Ortodoncia Invisible', 'Alineadores transparentes.'),
('Cirugía de Cordales', 'Extracción de muelas del juicio.'),
('Curetaje', 'Limpieza profunda de las encías.'),
('Blanqueamiento', 'Aclaramiento dental químico.'),
('Obturación (Empaste)', 'Reparación de cavidad por caries.'),
('Implante Dental', 'Sustitución de raíz por perno de titanio.'),
('Radiografía 3D', 'Escaneo completo para diagnóstico.'),
('Frenectomía', 'Intervención quirúrgica de frenillo.'),
('Revisión General', 'Chequeo preventivo semestral.'),
('Protección Pulpar', 'Tratamiento previo a la endodoncia.'),
('Brackets Cerámicos', 'Ortodoncia estética.'),
('Gingivoplastia', 'Remodelación quirúrgica de encías.'),
('Corona Circonio', 'Prótesis fija de alta resistencia.');



INSERT INTO DOCTOR (id_doctor, nombre, id_especialidad, fecha_nacimiento, direccion, numero_colegiado) VALUES 
(101, 'Dr. Alberto Ruiz', 4, '1985-04-12', 'Calle Mayor 10, Madrid', 'COL-282801'), -- CIRUGIA
(102, 'Dra. Elena Beltrán', 2, '1988-11-20', 'Av. Libertad 5, Barcelona', 'COL-080802'), -- ENDODONCISTA
(103, 'Dr. Carlos Soler', 3, '1979-01-30', 'Calle Luna 45, Valencia', 'COL-464603'), -- ORTODONCISTA
(104, 'Dra. Sofía Méndez', 1, '1992-06-15', 'Plaza España 2, Sevilla', 'COL-414104'), -- GENERAL
(105, 'Dr. Jorge Valdivia', 5, '1983-09-05', 'Calle Real 12, Zaragoza', 'COL-505005'), -- PERIODONCISTA
(106, 'Dra. Marina Costa', 1, '1990-12-01', 'Paseo Marítimo 8, Málaga', 'COL-292906'), -- GENERAL
(107, 'Dr. Samuel Paz', 4, '1975-03-22', 'Gran Vía 100, Bilbao', 'COL-484807'); -- CIRUGIA

INSERT INTO PACIENTE (nombre, apellido, telefono, correo_electronico, fecha_nacimiento) VALUES 
('Juan', 'García', '600111222', 'juan@mail.com', '1995-02-10'),
('Lucía', 'Martín', '600333444', 'lucia@mail.com', '1988-05-15'),
('Pedro', 'Gómez', '600555666', 'pedro@mail.com', '2001-08-20'),
('Ana', 'Sanz', '600777888', 'ana@mail.com', '1975-11-30'),
('David', 'López', '600999000', 'david@mail.com', '1992-04-05'),
('Marta', 'Fernández', '611222333', 'marta@mail.com', '1983-09-12'),
('Luis', 'Torres', '611444555', 'luis@mail.com', '1999-12-25'),
('Rosa', 'Díaz', '611666777', 'rosa@mail.com', '1968-07-18'),
('Raúl', 'Castro', '611888999', 'raul@mail.com', '1990-01-14'),
('Elena', 'Vázquez', '622111222', 'elena@mail.com', '2005-06-22'),
('Pablo', 'Serrano', '622333444', 'pablo@mail.com', '1980-03-08'),
('Carla', 'Ibáñez', '622555666', 'carla@mail.com', '1994-10-27'),
('Hugo', 'Ramos', '622777888', 'hugo@mail.com', '1987-11-02'),
('Sara', 'Gil', '622999000', 'sara@mail.com', '2000-09-19'),
('Mario', 'Ortiz', '633111222', 'mario@mail.com', '1972-05-31'),
('Nerea', 'Moya', '633333444', 'nerea@mail.com', '1996-08-14'),
('Javier', 'Blanco', '633555666', 'javier@mail.com', '1989-12-04'),
('Irene', 'Rubio', '633777888', 'irene@mail.com', '1982-02-28'),
('Óscar', 'Marín', '633999000', 'oscar@mail.com', '2003-04-11'),
('Alba', 'Pérez', '644111222', 'alba@mail.com', '1991-07-07');

INSERT INTO HISTORIAL_CLINICO (id_paciente, fecha_creacion, grupo_sanguineo)
SELECT id_paciente, '2026-01-10', ELT(FLOOR(RAND()*4) + 1, 'A+', 'B+', 'O+', 'AB-') FROM PACIENTE;

-- Citas del mes de mayo 2026
INSERT INTO CITA (fecha, hora, motivo, id_estado, id_paciente, id_doctor) VALUES 
('2026-05-01', '09:00:00', 'Extracción', 2, 1, 101),
('2026-05-01', '10:00:00', 'Nervio inflamado', 2, 2, 102),
('2026-05-01', '11:00:00', 'Ajuste orto', 2, 3, 103),
('2026-05-01', '12:00:00', 'Limpieza', 3, 4, 104),
('2026-05-02', '09:00:00', 'Encías sangrantes', 1, 5, 105),
('2026-05-02', '10:30:00', 'Dolor muela', 2, 6, 104),
('2026-05-02', '11:30:00', 'Quitar puntos', 2, 7, 107),
('2026-05-03', '09:00:00', 'Cirugía', 2, 8, 101),
('2026-05-03', '10:00:00', 'Revisión', 2, 9, 106),
('2026-05-03', '11:00:00', 'Endodoncia', 2, 10, 102),
('2026-05-04', '16:00:00', 'Seguimiento', 2, 11, 103),
('2026-05-04', '17:00:00', 'Caries', 1, 12, 104),
('2026-05-05', '09:00:00', 'Urgencia', 2, 13, 102),
('2026-05-05', '10:00:00', 'Higiene', 2, 14, 106),
('2026-05-05', '11:00:00', 'Consultoría', 2, 15, 101),
('2026-05-06', '12:00:00', 'Piorrea', 2, 16, 105),
('2026-05-06', '13:00:00', 'Manchas dentales', 3, 17, 106),
('2026-05-07', '09:00:00', 'Muela juicio', 2, 18, 107),
('2026-05-07', '10:00:00', 'Brackets sueltos', 2, 19, 103),
('2026-05-07', '11:00:00', 'Limpieza', 2, 20, 104),
('2026-05-08', '09:00:00', 'Dolor', 1, 1, 106),
('2026-05-08', '10:00:00', 'Conducto', 2, 2, 102),
('2026-05-09', '11:00:00', 'Aparato', 2, 3, 103),
('2026-05-09', '12:00:00', 'Cirugía leve', 2, 5, 101),
('2026-05-10', '09:00:00', 'Empaste', 2, 6, 104),
('2026-05-10', '10:00:00', 'Limpieza', 2, 7, 106),
('2026-05-11', '11:00:00', 'Muela', 2, 8, 107),
('2026-05-11', '12:00:00', 'Sensibilidad', 2, 10, 102),
('2026-05-12', '16:00:00', 'Mensual', 2, 11, 103),
('2026-05-12', '17:00:00', 'Revision', 1, 12, 104),
('2026-05-13', '09:30:00', 'Dolor', 2, 13, 102),
('2026-05-13', '11:00:00', 'Higiene', 2, 14, 106),
('2026-05-14', '12:00:00', 'Cordales', 2, 15, 107),
('2026-05-14', '13:00:00', 'Encías', 2, 16, 105),
('2026-05-15', '16:00:00', 'Blanqueo', 2, 17, 104),
('2026-05-15', '17:00:00', 'Quitar muela', 2, 18, 101),
('2026-05-16', '09:00:00', 'Orto', 2, 19, 103),
('2026-05-16', '10:00:00', 'Gingivitis', 2, 20, 105),
('2026-05-17', '11:00:00', 'Caries', 2, 1, 104),
('2026-05-17', '12:00:00', 'Limpieza Profunda', 2, 4, 106);

-- Detalles de Cita (Relación 1 a 1 para cubrir los inserts pedidos)
INSERT INTO DETALLE_CITA (id_cita, id_tratamiento, observaciones) VALUES 
(1, 4, 'Extracción complicada.'), (2, 2, 'Nervio muy afectado.'),
(3, 3, 'Cambio de gomas.'), (4, 1, 'Paciente no se presentó.'),
(5, 5, 'Inicio de tratamiento periodontal.'), (6, 7, 'Obturación realizada.'),
(7, 4, 'Retirada de sutura.'), (8, 4, 'Sin complicaciones.'),
(9, 11, 'Estado general óptimo.'), (10, 12, 'Protección colocada.'),
(11, 13, 'Brackets estéticos.'), (12, 7, 'Caries pequeña.'),
(13, 2, 'Segunda fase.'), (14, 1, 'Mucha placa bacteriana.'),
(15, 11, 'Evaluación inicial.'), (16, 14, 'Reducción de inflamación.'),
(17, 6, 'Reprogramada.'), (18, 4, 'Impactación ósea.'),
(19, 3, 'Arco cambiado.'), (20, 1, 'Recomendado hilo dental.'),
(21, 11, 'Dolor inespecífico.'), (22, 2, 'Finalizada.'),
(23, 13, 'Revisión brackets.'), (24, 10, 'Frenillo lingual.'),
(25, 7, 'Resina usada.'), (26, 1, 'Limpieza anual.'),
(27, 4, 'Anestesia local.'), (28, 2, 'Urgencia nocturna.'),
(29, 3, 'Todo bien.'), (30, 11, 'Sano.'),
(31, 2, 'Irritación pulpar.'), (32, 1, 'Ultrasonidos.'),
(33, 4, 'Muela inferior.'), (34, 5, 'Curetaje por cuadrantes.'),
(35, 6, 'Esmalte resistente.'), (36, 4, 'Sangrado normal.'),
(37, 3, 'Ajuste final.'), (38, 5, 'Control de placa.'),
(39, 7, 'Diente 24.'), (40, 1, 'Profilaxis.');

-- 10 CONSULTAS

/*Muestra las citas programadas para una fecha específica, incluyendo el nombre del paciente y del doctor. Útil para la vista diaria de recepción. */
SELECT C.hora, P.nombre AS Paciente, D.nombre AS Doctor, C.motivo 
FROM CITA C
JOIN PACIENTE P ON C.id_paciente = P.id_paciente
JOIN DOCTOR D ON C.id_doctor = D.id_doctor
WHERE C.fecha = '2026-05-01' AND C.id_estado = 2;

/*Cuenta cuántas citas tiene asignadas cada doctor. Ideal para estadísticas de productividad.*/
SELECT D.nombre, COUNT(C.id_cita) AS total_citas
FROM DOCTOR D
LEFT JOIN CITA C ON D.id_doctor = C.id_doctor
GROUP BY D.id_doctor;

/*Obtiene todos los tratamientos que se le han realizado a un paciente específico a lo largo del tiempo*/
SELECT P.nombre, P.apellido, C.fecha, T.nombre AS tratamiento, DC.observaciones
FROM PACIENTE P
JOIN CITA C ON P.id_paciente = C.id_paciente
JOIN DETALLE_CITA DC ON C.id_cita = DC.id_cita
JOIN TRATAMIENTO T ON DC.id_tratamiento = T.id_tratamiento
WHERE P.id_paciente = 1;


/*Identifica qué servicios son los más populares en la clínica*/
SELECT T.nombre, COUNT(DC.id_detalle) AS veces_realizado
FROM TRATAMIENTO T
JOIN DETALLE_CITA DC ON T.id_tratamiento = DC.id_tratamiento
GROUP BY T.id_tratamiento
ORDER BY veces_realizado DESC;

/*Busca pacientes que existen en la base de datos pero no tienen ninguna cita registrada en la tabla CITA*/
SELECT nombre, apellido, telefono 
FROM PACIENTE 
WHERE id_paciente NOT IN (SELECT DISTINCT id_paciente FROM CITA);

/*Agrupa a los médicos según su especialidad técnica.*/
SELECT E.especialidad, D.nombre, D.numero_colegiado
FROM ESPECIALIDAD E
JOIN DOCTOR D ON E.id_especialidad = D.id_especialidad
ORDER BY E.especialidad;

/*Calcula cuántas citas se pierden por inasistencia o cancelación.*/
SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM CITA)) AS porcentaje_canceladas
FROM CITA 
WHERE id_estado = 3;

/*Listar clientes*/
SELECT 
    id_paciente AS ID,
    CONCAT(apellido, ', ', nombre) AS 'Paciente',
    telefono AS 'Teléfono',
    correo_electronico AS 'Email',
    TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS 'Edad'
FROM PACIENTE
ORDER BY apellido ASC;

/*Listar médicos y su especialidad*/
SELECT 
    D.id_doctor AS 'ID Medico',
    D.nombre AS 'Nombre del Doctor',

    E.especialidad AS 'Especialidad Dental',
    D.numero_colegiado AS 'Nº Colegiado'
FROM DOCTOR D
JOIN ESPECIALIDAD E ON D.id_especialidad = E.id_especialidad
ORDER BY E.especialidad ASC;

/*Listado historiales clinicos*/
SELECT 
    H.id_historial_clinico AS 'Nº Historial',
    CONCAT(P.nombre, ' ', P.apellido) AS 'Paciente',
    H.grupo_sanguineo AS 'SANGRE',
    DATE_FORMAT(H.fecha_creacion, '%d/%m/%Y') AS 'Fecha Apertura'
FROM HISTORIAL_CLINICO H
JOIN PACIENTE P ON H.id_paciente = P.id_paciente
ORDER BY H.id_historial_clinico;

