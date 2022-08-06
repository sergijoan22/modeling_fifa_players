USE DatosFifa
GO

DROP TABLE IF EXISTS [fifa].[equipos]
GO

DROP TABLE IF EXISTS [fifa].[ligas]
GO

DROP TABLE IF EXISTS [fifa].[posiciones]
GO

-- DIMENSION LIGA
CREATE TABLE [fifa].[ligas]
(
id_liga int IDENTITY(1,1) primary key,
nombre_liga varchar(50),
categoria_liga int not null
)
GO

INSERT INTO [fifa].[ligas] (nombre_liga, categoria_liga)
SELECT DISTINCT COALESCE(liga, 'Agente libre') as liga, COALESCE(categoria_liga, '0')
FROM [fifa].[jugadores]
ORDER BY liga


-- DIMENSION EQUIPO
CREATE TABLE [fifa].[equipos]
(
id_equipo int IDENTITY(1,1) primary key,
nombre_equipo varchar(50),
liga_equipo varchar(50),
id_liga int FOREIGN KEY REFERENCES [fifa].[ligas]
)
GO

-- se insertan los distintos equipos que tienen los jugadores
INSERT INTO [fifa].[equipos] (nombre_equipo, liga_equipo)
SELECT DISTINCT COALESCE(club, 'Agente libre') as equipo, COALESCE(liga, 'Agente libre') as liga
FROM [fifa].[jugadores]
ORDER BY equipo

-- league id from the dimension is added
UPDATE [fifa].[equipos]
SET id_liga = l.[id_liga]
from [fifa].[equipos] e inner join [fifa].[ligas] l on e.[liga_equipo] = l.[nombre_liga]

--remove column with league name
alter table [fifa].[equipos]
drop column liga_equipo



-- DIMENSION POSICIONES

DROP TABLE IF EXISTS [fifa].[posiciones]
GO

CREATE TABLE [fifa].[posiciones]
(
id_posicion int IDENTITY(1,1) primary key,
posicion varchar(50),
rol varchar(10),
id_rol int
)
GO

INSERT INTO [fifa].[posiciones] (posicion)
SELECT DISTINCT posicion
FROM [fifa].[jugadores]
ORDER BY posicion

UPDATE [fifa].[posiciones]
SET rol =
(
CASE
WHEN posicion = 'GK' THEN 'Portero'
WHEN posicion LIKE '%B' THEN 'Defensa'
WHEN posicion LIKE '%M' THEN 'Medio'
WHEN posicion LIKE '%[STWF]' THEN 'Delantero'
ELSE 'Sin definir' END
)

UPDATE [fifa].[posiciones]
SET id_rol =
(
CASE
WHEN rol = 'Portero' THEN 1
WHEN rol = 'Defensa' THEN 2
WHEN rol = 'Medio' THEN 3
WHEN rol = 'Delantero' THEN 4
ELSE 0 END
)


-- DIMENSION MEDIA
DROP TABLE IF EXISTS [fifa].[rating]
GO

CREATE TABLE [fifa].[rating]
(
id_rating int primary key,
rating_round int
)
GO

DECLARE @N INT = (SELECT CEILING(MIN(MEDIA)/10)*10 from [fifa].[jugadores])
WHILE @N <= 99 
	BEGIN
		INSERT INTO [fifa].[rating](id_rating, rating_round) values (@N, CEILING(@N/10)*10)
		SET @N = @N + 1
	END


-- DIMENSION POTENTIAL
DROP TABLE IF EXISTS [fifa].[potential]
GO

CREATE TABLE [fifa].[potential]
(
id_potential int primary key,
potential_round int
)
GO

DECLARE @N INT = (SELECT CEILING(MIN(potencial)/10)*10 from [fifa].[jugadores])
WHILE @N <= 99 
	BEGIN
		INSERT INTO [fifa].[potential](id_potential, potential_round) values (@N, CEILING(@N/10)*10)
		SET @N = @N + 1
	END



-- DIMENSION HEIGHT
DROP TABLE IF EXISTS [fifa].[height]
GO

CREATE TABLE [fifa].[height]
(
id_height int primary key,
height_group varchar(20)
)
GO

DECLARE @N INT = (SELECT MIN(altura) from [fifa].[jugadores])
WHILE @N <= (SELECT MAX(altura) from [fifa].[jugadores]) 
	BEGIN
		INSERT INTO [fifa].[height](id_height) values (@N)
		SET @N = @N + 1
	END

UPDATE [fifa].[height]
SET height_group =
(
CASE
WHEN id_height < 166 THEN 'Very short'
WHEN id_height < 177 THEN 'Short'
WHEN id_height < 183 THEN 'Average'
WHEN id_height < 191 THEN 'Tall'
ELSE 'Very tall'
END
)

-- DIMENSION WEIGHT
DROP TABLE IF EXISTS [fifa].[weight]
GO

CREATE TABLE [fifa].[weight]
(
id_weight int primary key,
weight_group varchar(20)
)
GO

DECLARE @N INT = (SELECT MIN(peso) from [fifa].[jugadores])
WHILE @N <= (SELECT MAX(peso) from [fifa].[jugadores]) 
	BEGIN
		INSERT INTO [fifa].[weight](id_weight) values (@N)
		SET @N = @N + 1
	END

UPDATE [fifa].[weight]
SET weight_group =
(
CASE
WHEN id_weight < 70 THEN 'Light'
WHEN id_weight < 90 THEN 'Average'
ELSE 'Heavy'
END
)



-- DIMENSION EDAD
DROP TABLE IF EXISTS [fifa].[edad]
GO

CREATE TABLE [fifa].[edad]
(
id_edad int primary key,
grupo_edad varchar(20)
)
GO

DECLARE @N INT = (SELECT MIN(EDAD) from fifa.jugadores)
WHILE @N <= (SELECT MAX(EDAD) from fifa.jugadores) 
	BEGIN
		INSERT INTO [fifa].[edad](id_edad) values (@N)
		SET @N = @N + 1
	END

UPDATE [fifa].[edad]
SET grupo_edad = 
(
CASE
WHEN id_edad <= 20 THEN 'Promise'
WHEN id_edad <= 24 THEN 'Young'
WHEN id_edad <= 29 THEN 'Average'
WHEN id_edad <= 34 THEN 'Veteran'
ELSE 'Old'
END
)


-- DIMENSION NACIONALIDAD
DROP TABLE IF EXISTS [fifa].[nacionalidades]
GO

CREATE TABLE [fifa].[nacionalidades]
(
id_nacionalidad int IDENTITY(1,1) primary key,
nacionalidad varchar(50)
)
GO

-- se insertan las distintas nacionalidades que tienen los jugadores
INSERT INTO [fifa].[nacionalidades] (nacionalidad)
SELECT DISTINCT nacionalidad
FROM [fifa].[jugadores]
ORDER BY nacionalidad


-- DIMENSION WORK RATE OFENSIVO
DROP TABLE IF EXISTS [fifa].[work_rate_offensive]
GO

CREATE TABLE [fifa].[work_rate_offensive]
(
id_work_rate int IDENTITY(1,1) primary key,
work_rate varchar(10)
)
GO

-- se insertan las distintas nacionalidades que tienen los jugadores
INSERT INTO [fifa].[work_rate_offensive] (work_rate)
SELECT DISTINCT work_rate_offensive
FROM [fifa].[jugadores]
ORDER BY work_rate_offensive


-- DIMENSION WORK RATE DEFENSIVO
DROP TABLE IF EXISTS [fifa].[work_rate_defensive]
GO

CREATE TABLE [fifa].[work_rate_defensive]
(
id_work_rate int IDENTITY(1,1) primary key,
work_rate varchar(10)
)
GO

-- se insertan las distintas nacionalidades que tienen los jugadores
INSERT INTO [fifa].[work_rate_defensive] (work_rate)
SELECT DISTINCT work_rate_defensive
FROM [fifa].[jugadores]
ORDER BY work_rate_defensive


-- DIMENSION BODY TYPE
DROP TABLE IF EXISTS [fifa].[body_types]
GO

CREATE TABLE [fifa].[body_types]
(
id_body_type int IDENTITY(1,1) primary key,
body_type varchar(20),
body_type_specific varchar(20),
unique_body_type varchar(20)
)
GO

-- se insertan las distintas nacionalidades que tienen los jugadores
INSERT INTO [fifa].[body_types] (body_type_specific)
SELECT DISTINCT tipo_cuerpo
FROM [fifa].[jugadores]
ORDER BY tipo_cuerpo

UPDATE [fifa].[body_types]
SET body_type = 
(
CASE
WHEN CHARINDEX ( '(' , body_type_specific) = 0 THEN body_type_specific
ELSE SUBSTRING(body_type_specific, 0, CHARINDEX ( ' ' , body_type_specific) )
END
)

UPDATE [fifa].[body_types]
SET unique_body_type =
(
CASE
WHEN body_type = 'Unique' THEN 'Unique'
ELSE 'Generic'
END
)


-- DIMENSION SKILLS
DROP TABLE IF EXISTS [fifa].[skills]
GO

CREATE TABLE [fifa].[skills]
(
id_skill int primary key,
skil_visual varchar(10)
)
GO

DECLARE @N INT = 1
WHILE @N <= 5
	BEGIN
		INSERT INTO [fifa].[skills](id_skill, skil_visual) values (@N, REPLICATE ( '*' , @N )   )
		SET @N = @N + 1
	END


-- DIMENSION PIE MALO
DROP TABLE IF EXISTS [fifa].[pie_malo]
GO

CREATE TABLE [fifa].[pie_malo]
(
id_pie_malo int primary key,
pie_malo_visual varchar(10)
)
GO

DECLARE @N INT = 1
WHILE @N <= 5
	BEGIN
		INSERT INTO [fifa].[pie_malo](id_pie_malo, pie_malo_visual) values (@N, REPLICATE ( '*' , @N )   )
		SET @N = @N + 1
	END


-- DIMENSION PIE PREFERIDO
DROP TABLE IF EXISTS [fifa].[preferred_foot]
GO

CREATE TABLE [fifa].[preferred_foot]
(
id_preferred_foot int IDENTITY(1,1) primary key,
preferred_foot varchar(50)
)
GO

-- se insertan ambos pies 
INSERT INTO [fifa].[preferred_foot] (preferred_foot)
SELECT DISTINCT pie_preferido
FROM [fifa].[jugadores]
ORDER BY pie_preferido


PRINT 'DIMENSION TABLES CREATED'



