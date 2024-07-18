-- Consulta 1: Seleccionar usuarios con mayor reputación
SELECT TOP 200 DisplayName, Location, Reputation
FROM Users
ORDER BY Reputation DESC;


-- Consulta 2: Seleccionar títulos de posts con sus autores
SELECT TOP 200 p.Title, u.DisplayName
FROM Posts p
JOIN Users u ON p.OwnerUserId = u.AccountId
WHERE p.OwnerUserId IS NOT NULL;


-- Consulta 3: Calcular el promedio de Score de los Posts por usuario
SELECT TOP 200 u.DisplayName, AVG(p.Score) AS AverageScore
FROM Posts p
JOIN Users u ON p.OwnerUserId = u.AccountId
WHERE p.OwnerUserId IS NOT NULL
GROUP BY u.DisplayName
ORDER BY AverageScore DESC;


-- Consulta 4: Encontrar usuarios con más de 100 comentarios
SELECT TOP 200 u.DisplayName
FROM Users u
WHERE u.AccountId IN (
    SELECT c.UserId
    FROM Comments c
    GROUP BY c.UserId
    HAVING COUNT(c.UserId) > 100
);


-- Consulta 5: Actualizar ubicaciones vacías
UPDATE Users
SET Location = 'Desconocido'
WHERE Location IS NULL OR Location = '';

-- Mensaje de confirmación
PRINT 'La actualización se realizó correctamente para las primeras 200 filas afectadas.';

-- Verificar los primeros 200 cambios realizados
SELECT TOP 200 DisplayName, Location
FROM Users
WHERE Location = 'Desconocido';



-- Consulta 6: Eliminar comentarios de usuarios con menos de 100 de reputación
-- Contar el número de comentarios que serán eliminados
DECLARE @DeletedCount INT;

SELECT @DeletedCount = COUNT(*)
FROM Comments c
JOIN Users u ON c.UserId = u.AccountId
WHERE u.Reputation < 100;

-- Eliminar los comentarios
DELETE c
FROM Comments c
JOIN Users u ON c.UserId = u.AccountId
WHERE u.Reputation < 100;

-- Mostrar el mensaje con el número de comentarios eliminados
PRINT CAST(@DeletedCount AS VARCHAR(10)) + ' comentarios fueron eliminados';



-- Consulta 7: Mostrar el número total de publicaciones, comentarios y badges por usuario
SELECT TOP 200 u.DisplayName,
       ISNULL(p.TotalPosts, 0) AS TotalPosts,
       ISNULL(c.TotalComments, 0) AS TotalComments,
       ISNULL(b.TotalBadges, 0) AS TotalBadges
FROM Users u
LEFT JOIN (
    SELECT OwnerUserId, COUNT(*) AS TotalPosts
    FROM Posts
    GROUP BY OwnerUserId
) p ON u.AccountId = p.OwnerUserId
LEFT JOIN (
    SELECT UserId, COUNT(*) AS TotalComments
    FROM Comments
    GROUP BY UserId
) c ON u.AccountId = c.UserId
LEFT JOIN (
    SELECT UserId, COUNT(*) AS TotalBadges
    FROM Badges
    GROUP BY UserId
) b ON u.AccountId = b.UserId
ORDER BY TotalPosts DESC, TotalComments DESC, TotalBadges DESC;


-- Consulta 8: Mostrar las 10 publicaciones más populares
SELECT TOP 10 Title, Score
FROM Posts
ORDER BY Score DESC;


-- Consulta 9: Mostrar los 5 comentarios más recientes
SELECT TOP 5 Text, CreationDate
FROM Comments
ORDER BY CreationDate DESC;