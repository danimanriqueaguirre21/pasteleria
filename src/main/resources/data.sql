

    INSERT INTO categoria (nombre, descripcion, estado)
    SELECT 'Tortas', 'Tortas para cumpleaños y celebraciones', TRUE
    WHERE NOT EXISTS (
    SELECT 1 FROM categoria WHERE nombre = 'Tortas'
);

    INSERT INTO categoria (nombre, descripcion, estado)
    SELECT 'Cupcakes', 'Cupcakes de diferentes sabores', TRUE
    WHERE NOT EXISTS (
    SELECT 1 FROM categoria WHERE nombre = 'Cupcakes'
);

    INSERT INTO categoria (nombre, descripcion, estado)
    SELECT 'Galletas', 'Galletas dulces', TRUE
    WHERE NOT EXISTS (
    SELECT 1 FROM categoria WHERE nombre = 'Galletas'
);

    INSERT INTO categoria (nombre, descripcion, estado)
    SELECT 'Postres', 'Postres individuales', TRUE
    WHERE NOT EXISTS (
    SELECT 1 FROM categoria WHERE nombre = 'Postres'
);


-- Clave de las cuentas de prueba: 12345678
INSERT INTO usuario (nombres, apellidos, correo, contrasena, estado, rol)
SELECT 'Admin', 'Pasteleria', 'admin@pasteleria.com',
       '12345678', TRUE, 'ADMINISTRADOR'
WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE correo = 'admin@pasteleria.com');

INSERT INTO usuario (nombres, apellidos, correo, contrasena, estado, rol)
SELECT 'Ana', 'Cliente', 'cliente@pasteleria.com',
       '12345678', TRUE, 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE correo = 'cliente@pasteleria.com');

INSERT INTO usuario (nombres, apellidos, correo, contrasena, estado, rol)
SELECT 'Luis', 'Cajero', 'cajero@pasteleria.com',
       '12345678', TRUE, 'CAJERO'
WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE correo = 'cajero@pasteleria.com');

INSERT INTO usuario (nombres, apellidos, correo, contrasena, estado, rol)
SELECT 'Cliente', 'Mostrador', 'mostrador@pasteleria.com',
       '12345678', TRUE, 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE correo = 'mostrador@pasteleria.com');

INSERT INTO usuario (nombres, apellidos, correo, contrasena, estado, rol)
SELECT 'Mario', 'Repartidor', 'repartidor@pasteleria.com',
       '12345678', TRUE, 'REPARTIDOR'
WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE correo = 'repartidor@pasteleria.com');

-- Migra las cuentas demo creadas antes con la clave cifrada.
UPDATE usuario
SET contrasena = '12345678'
WHERE correo IN (
    'admin@pasteleria.com',
    'cliente@pasteleria.com',
    'cajero@pasteleria.com',
    'mostrador@pasteleria.com',
    'repartidor@pasteleria.com'
)
  AND contrasena LIKE '$2%';

INSERT INTO producto (nombre, descripcion, precio, stock, imagen, estado, id_categoria)
SELECT 'Torta de chocolate', 'Torta de 1 kg', 45.00, 10, NULL, TRUE, id_categoria
FROM categoria WHERE nombre = 'Tortas'
  AND NOT EXISTS (SELECT 1 FROM producto WHERE LOWER(nombre) = 'torta de chocolate');

UPDATE producto
SET estado = FALSE
WHERE imagen IS NULL
  AND LOWER(nombre) = 'torta de chocolate'
  AND (SELECT COUNT(*)
       FROM producto
       WHERE imagen IS NOT NULL
         AND LOWER(nombre) = 'torta de chocolate') > 0;

INSERT INTO producto (nombre, descripcion, precio, stock, imagen, estado, id_categoria)
SELECT 'Cupcake de vainilla', 'Caja de 6 unidades', 18.00, 20, NULL, TRUE, id_categoria
FROM categoria WHERE nombre = 'Cupcakes'
  AND NOT EXISTS (SELECT 1 FROM producto WHERE nombre = 'Cupcake de vainilla');

INSERT INTO producto (nombre, descripcion, precio, stock, imagen, estado, id_categoria)
SELECT 'Galletas de mantequilla', 'Bolsa de 12 galletas', 12.00, 15, NULL, TRUE, id_categoria
FROM categoria WHERE nombre = 'Galletas'
  AND NOT EXISTS (SELECT 1 FROM producto WHERE nombre = 'Galletas de mantequilla');

