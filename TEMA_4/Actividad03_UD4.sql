DROP DATABASE IF EXISTS inventario;
CREATE DATABASE IF NOT EXISTS inventario;
USE inventario;

DROP TABLE IF EXISTS productos,
                     historial_ventas;
                     
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    precio DECIMAL(10,2),
    descripcion VARCHAR(255),
    existencias INT
);

CREATE TABLE historial_ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_vendedor INT,
    id_producto INT,
    unidades_vendidas INT,
    ingresos DECIMAL(10,2),
    fecha_venta DATETIME,
    CONSTRAINT fk_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

/*Ejercicio 1: Me acaba de llegar el camión crea un procedimiento llamado INSERT_PRODUCT que reciba como parámetros el identificador de un producto, 
su precio, una descripción y el número de unidades disponibles e inserte estos datos en la tabla “products”. Introduce 5 productos a tu elección con los campos que consideres oportunos.*/
DROP PROCEDURE IF EXISTS INSERT_PRODUCT;

DELIMITER $$

CREATE PROCEDURE INSERT_PRODUCT(
    IN p_id INT,
    IN p_precio DECIMAL(10,2),
    IN p_desc VARCHAR(255),
    IN p_unidades INT
)
BEGIN
    INSERT INTO productos (id_producto, precio, descripcion, existencias)
    VALUES (p_id, p_precio, p_desc, p_unidades);
END$$

DELIMITER ;


CALL INSERT_PRODUCT(101, 1200.50, 'MacBook', 10);
CALL INSERT_PRODUCT(102, 899.00, 'iPhone 15', 25);
CALL INSERT_PRODUCT(103, 45.99, 'Teclados', 50);
CALL INSERT_PRODUCT(104, 25.00, 'Alfombrilla Gaming', 100);
CALL INSERT_PRODUCT(105, 150.00, 'Monitor 24" Dell', 15);

SELECT * FROM productos;

/*Ejercicio 2: ¿Y éste por cuánto me le dejas? crea un procedimiento llamado SELECT_PRODUCT que reciba como parámetro 
el código del producto y muestre precio, descripción y unidades disponibles */
DROP PROCEDURE IF EXISTS SELECT_PRODUCT;

DELIMITER $$

CREATE PROCEDURE SELECT_PRODUCT(
    IN p_id INT -- Solo necesitamos el ID para buscar el producto
)
BEGIN
	SELECT precio, descripcion, existencias -- Seleccionamos las columnas que nos pide el enunciado
    FROM productos
	WHERE id_producto = p_id;
END$$

DELIMITER ;
CALL SELECT_PRODUCT(101);
CALL SELECT_PRODUCT(103);


/*Ejercicio 3: Trato hecho crear un procedimiento llamado SELL_PRODUCT que reciba como parámetro el ID del vendedor, 
código del producto y las unidades vendidas en la operación de venta, para después descontar dichas unidades del total 
de disponibles. Además, deberá registrar dicha compra en una tabla "sell_history", incluyendo una entrada con el id del 
vendedor, id del producto, unidades vendidas, ingresos por la venta y fecha de la venta.*/
DROP PROCEDURE IF EXISTS SELL_PRODUCT;

DELIMITER $$
CREATE PROCEDURE SELL_PRODUCT(
	IN p_id_vendedor INT,
    IN p_id_producto INT,
    IN p_unidades_vendidas INT
)
BEGIN
-- declaro variables para calcular el ingreso total
    DECLARE v_precio_unidad DECIMAL(10,2);
    DECLARE v_ingresos_totales DECIMAL(10,2);
    
-- Obtengo el precio de la tabla productos
    SELECT precio INTO v_precio_unidad 
    FROM productos 
    WHERE id_producto = p_id_producto;
    
-- Calculo los ingresos totales de esta venta
    SET v_ingresos_totales = v_precio_unidad * p_unidades_vendidas;
    
-- Actualizo las existencias en la tabla productos
	UPDATE productos 
    SET existencias = existencias - p_unidades_vendidas
    WHERE id_producto = p_id_producto;
    
-- Registro la venta en el historial
    INSERT INTO historial_ventas (id_vendedor, id_producto, unidades_vendidas, ingresos, fecha_venta)
    VALUES (p_id_vendedor, p_id_producto, p_unidades_vendidas, v_ingresos_totales, NOW());    

END$$
DELIMITER ;

-- Compruebo que haya funcionado
USE inventario;

CALL SELL_PRODUCT(1, 101, 2);

SELECT * FROM productos WHERE id_producto = 101; -- Compruebo que el stock ha bajado

SELECT * FROM historial_ventas; -- Compruebo que se ha guardado la venta