USE DatosFifa
GO

drop table if exists fifa.calendario
GO

create table fifa.calendario
(
fecha date primary key,
anio int,
mes int,
dia_semana int,
dia_mes int
)
GO


-- Anio minimo en la tabla de jugadores
DECLARE @MinimumYear int = (SELECT CONVERT(int, YEAR(MIN(fecha_nacimiento))) FROM fifa.jugadores)
-- fecha inicial del calendario, 1 de Enero del anio minimo
DECLARE @StartDate date = CONCAT('01/01/', RIGHT(@MinimumYear, 2))
-- fecha final del calendario, 31 de diciembre de este anio
DECLARE @EndDate DATE = CONCAT('01/01/', YEAR(GETDATE()) + 1); --End Value of Date Range
-- variable de fecha para iterar el bucle while
DECLARE @CurrentDate DATE = @StartDate

-- eliminar 
TRUNCATE TABLE fifa.calendario

WHILE @CurrentDate < @EndDate  
	BEGIN
		INSERT INTO fifa.calendario (fecha,anio, mes, dia_semana, dia_mes) VALUES (@CurrentDate, YEAR(@CurrentDate), MONTH(@CurrentDate), DATEPART(WEEKDAY, @CurrentDate), DAY(@CurrentDate));
		SET @CurrentDate = DATEADD(day,1, @CurrentDate)
	END



PRINT 'CALENDAR CREATED'

