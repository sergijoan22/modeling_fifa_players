-- Creates the database if it does not exist
IF NOT EXISTS ( SELECT  *
                FROM sys.databases
                where name = 'DatosFifa'
			  )
    EXEC('CREATE DATABASE DatosFifa');
GO

USE DatosFifa
GO

-- Creates the schema if it does not exist
IF NOT EXISTS ( SELECT  *
                FROM    INFORMATION_SCHEMA.SCHEMATA
                WHERE   schema_name = 'fifa'
			  )
    EXEC('CREATE SCHEMA fifa');
GO

