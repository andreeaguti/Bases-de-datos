/*
El Orden de las cláusulas: SQL es muy estricto. El orden siempre debe ser:
SELECT -> (¿Qué columnas quieres?)
FROM -> (¿De qué tabla principal?)
JOIN -> (¿Con qué otras tablas conectas?)
WHERE -> (Filtro para filas individuales. Ej: sueldo > 2000) Nunca pongas una función como AVG, SUM o COUNT en el WHERE.
GROUP BY -> (¿Cómo agrupas los datos? Ej: por departamento)
HAVING -> (Filtro para grupos. Ej: donde la media del grupo sea > 5000)
ORDER BY -> (¿Cómo lo ordenas?) ASC o DESC
LIMIT -> (¿Cuántos registros quieres?)

Los Tipos de JOIN (Visualízalos)
INNER JOIN: Es el más común. Solo muestra filas que tienen coincidencia en ambas tablas. Si un empleado no tiene departamento, no sale.
LEFT JOIN: Muestra todos los de la tabla de la izquierda, aunque no tengan pareja en la derecha.

WHERE nombre LIKE 'A%': Nombres que empiezan por A.
WHERE nombre LIKE '%a': Nombres que terminan en a.
WHERE nombre LIKE '%os%': Nombres que contienen "os" en cualquier parte.

En las bases de datos de empleados que estás usando, la fecha '9999-01-01' es una constante mágica.
Significa: "En la actualidad" o "Todavía activo".
Si el enunciado dice "empleados actuales" o "salario actual", debes poner en el WHERE que la fecha de fin (to_date) sea igual a '9999-01-01'.


Si quieres ver quién ha sido contratado justo hoy:
SELECT * FROM employees WHERE hire_date = CURDATE();


Calcular la edad o antigüedad:
SELECT first_name, TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS antiguedad
FROM employees;












*/

