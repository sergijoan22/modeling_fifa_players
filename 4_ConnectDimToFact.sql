USE DatosFifa
GO


-- create columns for players table to include id from dimensions (only if not created before)
DECLARE @declared int = 
	(SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = 'fifa' and TABLE_NAME = 'jugadores' and COLUMN_NAME = 'id_equipo')

IF @declared = 0
ALTER TABLE [fifa].[jugadores]
ADD id_equipo int FOREIGN KEY REFERENCES [fifa].[equipos](id_equipo),
	id_posicion int FOREIGN KEY REFERENCES [fifa].[posiciones](id_posicion),
	id_nacionalidad int FOREIGN KEY REFERENCES [fifa].[nacionalidades](id_nacionalidad),
	id_work_rate_offensive int FOREIGN KEY REFERENCES [fifa].[work_rate_offensive](id_work_rate),
	id_work_rate_defensive int FOREIGN KEY REFERENCES [fifa].[work_rate_defensive](id_work_rate),
	id_body_type int FOREIGN KEY REFERENCES [fifa].[body_types](id_body_type),
	id_preferred_foot int FOREIGN KEY REFERENCES [fifa].[preferred_foot](id_preferred_foot)
GO

-- ADDING INFO TO ID COLUMNS

-- team_id
DECLARE @id_agente_libre int = (select id_equipo from [fifa].[equipos] where nombre_equipo = 'Agente Libre')
UPDATE [fifa].[jugadores]
SET id_equipo = COALESCE(e.[id_equipo],@id_agente_libre)
				from [fifa].[jugadores] j 
				left join [fifa].[equipos] e on j.[club] = e.[nombre_equipo]
GO

-- id_position
UPDATE [fifa].[jugadores]
SET id_posicion = p.id_posicion
				from [fifa].[jugadores] j 
				left join [fifa].[posiciones] p on j.[posicion] = P.[posicion]
GO


-- id_nacionalidad
UPDATE [fifa].[jugadores]
SET id_nacionalidad = n.id_nacionalidad
				from [fifa].[jugadores] j 
				left join [fifa].[nacionalidades] n on j.[nacionalidad] = n.[nacionalidad]
GO


-- id_work_rate_offensive
UPDATE [fifa].[jugadores]
SET id_work_rate_offensive = w.id_work_rate
				from [fifa].[jugadores] j 
				left join [fifa].[work_rate_offensive] w on j.[work_rate_offensive] = w.[work_rate]
GO

-- id_work_rate_defensive
UPDATE [fifa].[jugadores]
SET id_work_rate_defensive = w.id_work_rate
				from [fifa].[jugadores] j 
				left join [fifa].[work_rate_defensive] w on j.[work_rate_defensive] = w.[work_rate]
GO


-- id_body_type
UPDATE [fifa].[jugadores]
SET id_body_type = b.id_body_type
				from [fifa].[jugadores] j 
				left join [fifa].[body_types] b on j.[tipo_cuerpo] = b.[body_type_specific]
GO


-- id_preferred_foot
UPDATE [fifa].[jugadores]
SET id_preferred_foot = f.id_preferred_foot
				from [fifa].[jugadores] j 
				left join [fifa].[preferred_foot] f on j.[pie_preferido] = f.[preferred_foot]
GO


-- added foreign key constraint to existing column which are going to be related to other dim
ALTER TABLE [fifa].[jugadores]
ADD 
	FOREIGN KEY (fecha_nacimiento) REFERENCES [fifa].[calendario](fecha),
	FOREIGN KEY (media) REFERENCES [fifa].[rating](id_rating),
	FOREIGN KEY (potencial) REFERENCES [fifa].[potential](id_potential),
	FOREIGN KEY (altura) REFERENCES [fifa].[height](id_height),
	FOREIGN KEY (peso) REFERENCES [fifa].[weight](id_weight),
	FOREIGN KEY (edad) REFERENCES [fifa].[edad](id_edad),
	FOREIGN KEY (skills) REFERENCES [fifa].[skills](id_skill),
	FOREIGN KEY (pie_malo) REFERENCES [fifa].[pie_malo](id_pie_malo)

-- eliminar columnas que ya no se usan
ALTER TABLE [fifa].[jugadores]
DROP COLUMN posicion,
club,
liga,
categoria_liga,
nacionalidad,
pie_preferido,
tipo_cuerpo,
work_rate_offensive,
work_rate_defensive
			
PRINT 'MODEL CREATED'

