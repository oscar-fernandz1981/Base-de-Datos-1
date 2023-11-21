create database Pruebas;


use Pruebas;

Create table provincia (idprovincia int primary key, 
			descripcion varchar(50),
			km2 int,
			cantdptos int,
			poblacion int,
			nomcabe varchar(50))
go
-------------------

Create table localidad (idprovincia int, 
			idlocalidad int, 
			descripcion varchar(50),
			Constraint PK_localidad PRIMARY KEY (idprovincia, idlocalidad),
			Constraint FK_localidad_pcia FOREIGN KEY (idprovincia)  REFERENCES provincia(idprovincia)						 					     					     					     				     					     
						)
go
-------------------

Create table zona (idzona int identity primary key, 
         	    descripcion varchar(50))
go
-------------------

Create table conserje (idconserje int identity primary key, 
			apeynom varchar(50),
			tel varchar(20),
			fechnac datetime,
			estciv varchar(1)  NULL default ('S') 
			CONSTRAINT CK_estadocivil CHECK (estciv IN ('S', 'C','D','O')),
			)
go
-------------------

Create table administrador (idadmin int identity primary key, 
			    apeynom varchar(50),
			    viveahi varchar(1)  NULL default ('N') 
			    CONSTRAINT CK_habitante_viveahi CHECK (viveahi IN ('S', 'N')),
			    tel varchar(20),
			    sexo varchar(1)  NOT NULL 
			    CONSTRAINT CK_sexo CHECK (sexo IN ('F', 'M')),
                            fechnac datetime)

go
-------------------

Create table tipogasto	(idtipogasto int primary key, 
			 descripcion varchar(50))
go
-------------------

Create table consorcio	(idprovincia int,
                         idlocalidad int,
                         idconsorcio int, 
			 nombre varchar(50),
			 direccion varchar(250),					     
			 idzona int,	
			 idconserje int,	
			 idadmin int,	
			 Constraint PK_consorcio PRIMARY KEY (idprovincia, idlocalidad,idconsorcio),
			 Constraint FK_consorcio_pcia FOREIGN KEY (idprovincia,idlocalidad)  REFERENCES localidad(idprovincia,idlocalidad),
			 Constraint FK_consorcio_zona FOREIGN KEY (idzona)  REFERENCES zona(idzona),						 					     					     					     				     					     
			 Constraint FK_consorcio_conserje FOREIGN KEY (idconserje)  REFERENCES conserje(idconserje),
			 Constraint FK_consorcio_admin FOREIGN KEY (idadmin)  REFERENCES administrador(idadmin)						 					     					     					     				     					     						 						 						 					     					     					     				     					     						 
							)
go
-------------------


                         
Create table gastoNew	(
			 idgastoNew int identity,
			 idprovincia int,
                         idlocalidad int,
                         idconsorcio int, 
			 periodo int,
			 fechapago datetime,					     
			 idtipogasto int,
			 importe decimal (8,2),	
			 Constraint PK_gastoNew PRIMARY KEY (idgastoNew),
			 Constraint FK_gastoNew_consorcio FOREIGN KEY (idprovincia,idlocalidad,idconsorcio)  REFERENCES consorcio(idprovincia,idlocalidad,idconsorcio),
			 Constraint FK_gastoNew_tipo FOREIGN KEY (idtipogasto)  REFERENCES tipogasto(idtipogasto)					     					     						 					     					     
							)
go



DECLARE @id_gasto INT = 1   --declaramos variable que sera el id
 
WHILE @id_gasto < 1000000
 BEGIN
   insert into gastoNew (idgastoNew, idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe)
   values (@id_gasto, 2,2,2,4,'2020-12-12',4,140)
    SET @id_gasto = @id_gasto + 1
    CONTINUE
 END

 --select * from gastoNew;

 /*
 -- Crear una tabla temporal para almacenar los registros temporales
CREATE TABLE #TempTable (ID INT, Nombre VARCHAR(50))

-- Declarar una variable para el contador
DECLARE @Counter INT
SET @Counter = 1

-- Definir el número total de registros a insertar (1 millón en este caso)
DECLARE @TotalRecords INT
SET @TotalRecords = 1000000

-- Bucle para insertar registros repetidos
WHILE @Counter <= @TotalRecords
BEGIN
    INSERT INTO #TempTable (idgastoNew, idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe)
    VALUES (@Counter, @Counter ,@Counter ,@Counter , @Counter , '2022-11-12',2,125)
    SET @Counter = @Counter + 1
END

-- Insertar los registros de la tabla temporal en la tabla principal
INSERT INTO gastoNew(ID, Nombre)
SELECT ID, Nombre FROM #TempTable

-- Eliminar la tabla temporal
DROP TABLE #TempTable
*/
