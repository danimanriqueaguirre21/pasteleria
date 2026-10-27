

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


INSERT INTO rol (nombre)
SELECT 'ADMINISTRADOR'
    WHERE NOT EXISTS (
    SELECT 1 FROM rol WHERE nombre = 'ADMINISTRADOR'
);

INSERT INTO rol (nombre)
SELECT 'CLIENTE'
    WHERE NOT EXISTS (
    SELECT 1 FROM rol WHERE nombre = 'CLIENTE'
);

INSERT INTO rol (nombre)
SELECT 'CAJERO'
    WHERE NOT EXISTS (
    SELECT 1 FROM rol WHERE nombre = 'CAJERO'
);

INSERT INTO rol (nombre)
SELECT 'REPARTIDOR'
    WHERE NOT EXISTS (
    SELECT 1 FROM rol WHERE nombre = 'REPARTIDOR'
);

-- Clave de las cuatro cuentas de prueba: 12345678
INSERT INTO usuario (nombres, apellidos, correo, contrasena, estado, id_rol)
SELECT 'Admin', 'Pasteleria', 'admin@pasteleria.com',
       '$2b$10$1.pOnOo3XGQpCyz9dL0uxuQG8XlSlnUh04IW/HXm8w8KbC6DGjHT.',
       TRUE, id_rol
FROM rol WHERE nombre = 'ADMINISTRADOR'
  AND NOT EXISTS (SELECT 1 FROM usuario WHERE correo = 'admin@pasteleria.com');

INSERT INTO usuario (nombres, apellidos, correo, contrasena, estado, id_rol)
SELECT 'Ana', 'Cliente', 'cliente@pasteleria.com',
       '$2b$10$1.pOnOo3XGQpCyz9dL0uxuQG8XlSlnUh04IW/HXm8w8KbC6DGjHT.',
       TRUE, id_rol
FROM rol WHERE nombre = 'CLIENTE'
  AND NOT EXISTS (SELECT 1 FROM usuario WHERE correo = 'cliente@pasteleria.com');

INSERT INTO usuario (nombres, apellidos, correo, contrasena, estado, id_rol)
SELECT 'Luis', 'Cajero', 'cajero@pasteleria.com',
       '$2b$10$1.pOnOo3XGQpCyz9dL0uxuQG8XlSlnUh04IW/HXm8w8KbC6DGjHT.',
       TRUE, id_rol
FROM rol WHERE nombre = 'CAJERO'
  AND NOT EXISTS (SELECT 1 FROM usuario WHERE correo = 'cajero@pasteleria.com');

INSERT INTO usuario (nombres, apellidos, correo, contrasena, estado, id_rol)
SELECT 'Cliente', 'Mostrador', 'mostrador@pasteleria.com',
       '$2b$10$1.pOnOo3XGQpCyz9dL0uxuQG8XlSlnUh04IW/HXm8w8KbC6DGjHT.',
       TRUE, id_rol
FROM rol WHERE nombre = 'CLIENTE'
  AND NOT EXISTS (SELECT 1 FROM usuario WHERE correo = 'mostrador@pasteleria.com');

INSERT INTO usuario (nombres, apellidos, correo, contrasena, estado, id_rol)
SELECT 'Mario', 'Repartidor', 'repartidor@pasteleria.com',
       '$2b$10$1.pOnOo3XGQpCyz9dL0uxuQG8XlSlnUh04IW/HXm8w8KbC6DGjHT.',
       TRUE, id_rol
FROM rol WHERE nombre = 'REPARTIDOR'
  AND NOT EXISTS (SELECT 1 FROM usuario WHERE correo = 'repartidor@pasteleria.com');

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

INSERT INTO contacto (nombre, correo, asunto, mensaje)
SELECT 'Ana Pérez', 'ana@correo.com', 'Consulta',
       '¿Hacen tortas personalizadas para cumpleaños?'
WHERE NOT EXISTS (
    SELECT 1 FROM contacto WHERE correo = 'ana@correo.com' AND asunto = 'Consulta'
);

INSERT INTO promocion (titulo, descripcion, imagen, estado)
SELECT 'Tortas para tu celebración',
       'Pide tu torta con anticipación y recógela en tienda.',
       'promo-pasteleria.jpg',
       TRUE
WHERE NOT EXISTS (
    SELECT 1 FROM promocion WHERE titulo = 'Tortas para tu celebración'
);

INSERT INTO promocion (titulo, descripcion, imagen, estado)
SELECT 'Cupcakes de fresa',
       'Caja de cupcakes para compartir en reuniones.',
       'cupcake-fresa.jpg',
       TRUE
WHERE NOT EXISTS (
    SELECT 1 FROM promocion WHERE titulo = 'Cupcakes de fresa'
);

INSERT INTO promocion (titulo, descripcion, imagen, estado)
SELECT 'Galletas de mantequilla',
       'Llévalas como detalle o para acompañar el café.',
       'galleta.jpg',
       TRUE
WHERE NOT EXISTS (
    SELECT 1 FROM promocion WHERE titulo = 'Galletas de mantequilla'
);
