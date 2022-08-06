USE DatosFifa
GO


DROP TABLE IF EXISTS [fifa].[jugadores]
GO

-- crear tabla
create table [fifa].[jugadores]
(
id varchar(10),
nombre varchar(30),
nombre_completo varchar(50),
media int,
potencial int,
posicion varchar(10),
valor float,
sueldo float,
fecha_nacimiento date,
altura int,
peso int,
club varchar(50),
liga varchar(50),
categoria_liga float,
numero_club float,
equipo_cedido varchar(50),
fecha_fichaje date,
fin_contrato float,
nacionalidad varchar (50),
numero_seleccion float,
pie_preferido varchar(10),
pie_malo int,
skills int,
reputacion int,
ratios_trabajo varchar(20),
tipo_cuerpo varchar(20),
clausula_rescision float,
ritmo float,
tiro float,
pase float,
regate float,
defensa float,
fisico float,
url varchar(150),
player_face_url varchar(100),
club_logo_url varchar(100),
club_flag_url varchar(100),
nation_flag_url varchar(100)
)


-- leer el csv
BULK INSERT [fifa].[jugadores]
FROM 'D:\Datos\FifaPlayers\jugadores.csv'
WITH
(
    FIRSTROW = 2, -- as 1st one is header
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
	CODEPAGE = '65001' -- para UTF-8
)


-- cambiar columnas float a int
ALTER TABLE [fifa].[jugadores]
ALTER COLUMN valor int
ALTER TABLE [fifa].[jugadores]
ALTER COLUMN sueldo int
ALTER TABLE [fifa].[jugadores]
ALTER COLUMN numero_club int
ALTER TABLE [fifa].[jugadores]
ALTER COLUMN fin_contrato int
ALTER TABLE [fifa].[jugadores]
ALTER COLUMN categoria_liga int
ALTER TABLE [fifa].[jugadores]
ALTER COLUMN numero_seleccion int
ALTER TABLE [fifa].[jugadores]
ALTER COLUMN clausula_rescision int
ALTER TABLE [fifa].[jugadores]
ALTER COLUMN ritmo int
ALTER TABLE [fifa].[jugadores]
ALTER COLUMN tiro int
ALTER TABLE [fifa].[jugadores]
ALTER COLUMN pase int
ALTER TABLE [fifa].[jugadores]
ALTER COLUMN regate int
ALTER TABLE [fifa].[jugadores]
ALTER COLUMN defensa int
ALTER TABLE [fifa].[jugadores]
ALTER COLUMN fisico int


-- añade la columna edad si no existe
IF NOT EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_NAME = 'jugadores' AND COLUMN_NAME = 'edad')
BEGIN
  ALTER TABLE [fifa].[jugadores]
	ADD edad int;
END;


-- guardar el dia actual en una variable
DECLARE @Now  datetime
SET @Now= CONVERT(DATE, GETDATE())


-- calcular la edad en la columna edad
UPDATE [fifa].[jugadores]
SET edad = DATEDIFF(day, fecha_nacimiento, @Now)/365

-- crear columnas con indices alto y bajo
ALTER TABLE [fifa].[jugadores]
ADD work_rate_offensive varchar(10),
	work_rate_defensive varchar(10)

-- add values to new columns
UPDATE [fifa].[jugadores]
SET work_rate_offensive = SUBSTRING(ratios_trabajo, 0, CHARINDEX ( '/' , ratios_trabajo) ),
	work_rate_defensive = SUBSTRING(ratios_trabajo, CHARINDEX ( '/' , ratios_trabajo) + 1, 20)

-- drop initial column with work rates
ALTER TABLE [fifa].[jugadores]
DROP COLUMN ratios_trabajo

PRINT 'DATA READED'
