CREATE DATABASE biblioteca;
USE biblioteca;

CREATE TABLE autor(
	id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    nacionalidad VARCHAR(40) NOT NULL
);

SELECT * FROM autor;

INSERT INTO autor(nombre,nacionalidad) 
VALUES ('Aurelio Valenzuela', 'Argentina'),
('Siobhan O’Reilly', 'Irlanda'),
('Kenji Takanawa', 'Japón'),
('Elara Vance', 'Canadá'),
('Malik Al-Sayed', 'Egipto');


CREATE TABLE editorial(
	id_editorial INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    pais VARCHAR(40) NOT NULL
    
);

SELECT * FROM editorial;

INSERT INTO editorial(nombre,pais)
VALUES ('Ediciones del Abismo', 'España'),
('Cresta de Marfil', 'Sudáfrica'),
('Nova Alvorada', 'Brasil'),
('Vientos de Jade', 'Taiwán'),
('Pórtico de Niebla', 'Escocia');

CREATE TABLE categoria(
	id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL
);

SELECT * FROM categoria;

INSERT INTO categoria(nombre)
VALUES ('Realismo Estático'),
('Antropología Ficticia'),
('Ciber-Barroco'),
('Naturalismo de Vanguardia'),
('Meta-ficción Teológica');

CREATE TABLE libro(
	id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    id_editorial INT NOT NULL,
    anio_publicacion DATE NOT NULL,
    FOREIGN KEY (id_editorial) REFERENCES editorial (id_editorial)
);


SELECT * FROM libro;

SELECT 
    l.id_libro, 
    l.titulo, 
    e.nombre AS nombre_editorial, 
    e.pais,
    l.anio_publicacion
FROM libro l
INNER JOIN editorial e ON l.id_editorial = e.id_editorial;


INSERT INTO libro(titulo,id_editorial,anio_publicacion)
VALUES ('El Teorema del Eco Eterno', 1, '2026-01-15'),
    ('Sombras en el Jardín de Kioto', 4, '2025-11-20'),
    ('Manual de Supervivencia para Nómadas Digitales', 5, '2024-03-10'),
    ('El Laberinto de los Relojes de Arena', 3, '2026-02-05'),
    ('Cero Absoluto: El Código del Ártico', 2, '2023-08-30');

CREATE TABLE libro_autor (
    id_libro INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES libro(id_libro),
    FOREIGN KEY (id_autor) REFERENCES autor(id_autor)
);

SELECT * FROM libro_autor;

INSERT INTO libro_autor(id_libro,id_autor)
VALUES (1, 5), (1, 3), (3, 1), (4, 4), (2, 2), (5, 5), (1, 2);

SELECT 
    l.titulo AS 'Libro', 
    GROUP_CONCAT(a.nombre SEPARATOR ' y ') AS 'Autores'
FROM libro l
JOIN libro_autor la ON l.id_libro = la.id_libro
JOIN autor a ON la.id_autor = a.id_autor
GROUP BY l.id_libro;




CREATE TABLE libro_categoria(
	id_libro_categoria INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    id_libro INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria),
    FOREIGN KEY (id_libro) REFERENCES libro (id_libro)
);

SELECT * FROM libro_categoria;

INSERT INTO libro_categoria(id_categoria,id_libro)
VALUES (1, 2), (2, 2), (3,3), (4, 2), (5, 2), (3, 4), (5, 1), (4, 5) ; ;

SELECT 
    l.titulo AS 'Libro', 
    IFNULL(GROUP_CONCAT(c.nombre SEPARATOR ' y '), 'Sin categoría') AS 'Categorias'
FROM libro l
LEFT JOIN libro_categoria lc ON l.id_libro = lc.id_libro
LEFT JOIN categoria c ON lc.id_categoria = c.id_categoria
GROUP BY l.id_libro;

-- Mostrar todos los datos juntos 

SELECT 
    l.titulo AS 'Libro',
    e.nombre AS 'Editorial',
    l.anio_publicacion AS 'Año',
    IFNULL(GROUP_CONCAT(DISTINCT a.nombre SEPARATOR ', '), 'Sin Autor') AS 'Autores',
    IFNULL(GROUP_CONCAT(DISTINCT c.nombre SEPARATOR ', '), 'Sin Categoría') AS 'Categorías'
FROM libro l
LEFT JOIN editorial e ON l.id_editorial = e.id_editorial
LEFT JOIN libro_autor la ON l.id_libro = la.id_libro
LEFT JOIN autor a ON la.id_autor = a.id_autor
LEFT JOIN libro_categoria lc ON l.id_libro = lc.id_libro
LEFT JOIN categoria c ON lc.id_categoria = c.id_categoria
GROUP BY l.id_libro;

-- FINAL




CREATE TABLE usuario(
	id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    fecha_registro DATE NOT NULL
);
-- Funcionalidad Usuarios 

SELECT * FROM usuario;

INSERT INTO usuario(nombre, correo, fecha_registro) 
VALUES ('Alejandro Montes de Oca', 'montesoca@gmail.com', '2026-01-15'),
('Beatriz Elena Villalobos', 'elenavillalobos@gmail.com', '2026-02-03'),
('Carlos Eduardo Méndez', 'eduardomendez@gmail.com', '2026-03-12'),
('Diana Patricia Restrepo', 'patriciarestrepo@gmail.com', '2026-04-05'),
('Esteban Ricardo Guevara', 'ricardoguevara@gmail.com', '2026-04-20');


-- FINAL



CREATE TABLE prestamo(
	id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    fecha_prestamo DATE NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
);

-- Funcionalidad Prestamo

-- REINICAR TABLA
TRUNCATE TABLE prestamo;
-- En caso de emergencia


SELECT * FROM prestamo;


INSERT INTO prestamo(id_usuario, fecha_prestamo)
VALUES (1,'2026-05-12'), (1,'2026-05-15'),
 (2,'2026-07-04'), (3,'2026-09-09'), 
(4,'2026-08-22'), (4,'2026-10-29'), 
(4,'2026-12-11'), (5,'2026-10-15');

-- Muestra datos con los nombres envez de ID

SELECT 
    p.id_prestamo, 
    u.nombre, 
    p.fecha_prestamo
FROM prestamo p
JOIN usuario u ON p.id_usuario = u.id_usuario;

-- FINAL


CREATE TABLE detalle_prestamo(
	id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT,
    id_libro INT,
    fecha_devolucion DATE NULL,
    FOREIGN KEY (id_prestamo) REFERENCES prestamo (id_prestamo),
    FOREIGN KEY (id_libro) REFERENCES libro (id_libro)
);

-- Funcionalidad de detalle prestamo

-- ALTER TABLES
ALTER TABLE detalle_prestamo 
MODIFY COLUMN fecha_devolucion DATE NULL;
-- fin

-- REINICAR TABLA
TRUNCATE TABLE detalle_prestamo;
-- En caso de emergencia

SELECT * FROM detalle_prestamo;

INSERT INTO detalle_prestamo(id_prestamo, id_libro, fecha_devolucion)
VALUES (1,3,'2026-06-1'), (2, 2, '2026-06-10'),
 (3, 1, '2026-07-30'), (4, 4, NULL),
 (5, 3, NULL), (6, 5, '2026-11-1'),
 (7, 1, '2027-1-10'), (8, 4, NULL);
 
 -- Mostrar con nombres
 
SELECT 
    dp.id_detalle,
    u.nombre AS 'Usuario',
    l.titulo AS 'Libro',
    IFNULL(fecha_devolucion, 'No devuelto') AS 'Fecha Devolucion'
FROM detalle_prestamo dp
JOIN prestamo p ON dp.id_prestamo = p.id_prestamo
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN libro l ON dp.id_libro = l.id_libro
ORDER BY u.nombre ASC;

-- FINAL

-- FUNCIONES APARTE (NIVELES)

-- Cantidad de prestamos por usuario

SELECT 
    u.nombre AS 'Usuario', 
    COUNT(p.id_prestamo) AS 'Total de Préstamos'
FROM usuario u
LEFT JOIN prestamo p ON u.id_usuario = p.id_usuario
GROUP BY u.id_usuario, u.nombre
ORDER BY u.nombre ASC;

-- FIN


-- Mayor cantidad de prestamos
SELECT 
    u.nombre AS 'Usuario Top', 
    COUNT(p.id_prestamo) AS 'Total de Préstamos'
FROM usuario u
JOIN prestamo p ON u.id_usuario = p.id_usuario
GROUP BY u.id_usuario, u.nombre
ORDER BY COUNT(p.id_prestamo) DESC
LIMIT 1;

-- FIN



-- Cantidad de libros por editorial
SELECT 
    e.nombre AS 'Editorial', 
    COUNT(l.id_libro) AS 'Total de Libros'
FROM libro l
JOIN editorial e ON l.id_editorial = e.id_editorial
GROUP BY e.nombre;

-- FIN

-- Cantidad de libros por categorias

SELECT 
    c.nombre AS 'Categoría',
    COUNT(lc.id_libro) AS 'Total de Libros'
FROM libro_categoria lc
JOIN categoria c ON lc.id_categoria = c.id_categoria
GROUP BY c.nombre;

-- FINAL



-- libro mas prestado 

SELECT l.titulo, COUNT(dp.id_libro) AS total
FROM libro l
JOIN detalle_prestamo dp ON l.id_libro = dp.id_libro
GROUP BY l.id_libro
ORDER BY total DESC
LIMIT 1;


-- Categoria mas popular

SELECT c.nombre, COUNT(dp.id_libro) AS total
FROM categoria c
JOIN libro_categoria lc ON c.id_categoria = lc.id_categoria
JOIN detalle_prestamo dp ON lc.id_libro = dp.id_libro
GROUP BY c.id_categoria
ORDER BY total DESC
LIMIT 1;


-- FINAL