use base_consorcio;
/*backup proyecto*/

/*1_completa*/

backup database  base_consorcio to disk= 'C:\copiasSeguridad\backup20112023.bak'; /*creamos backup de la base de datos y guardamos en una direccion*/

/*2_diferencial*/
backup database  base_consorcio to disk= 'C:\copiasSeguridad\backup20112023.bak' with differential;


/*para crear mas rapido*/
go
create proc copiaBD @bd varchar(20) , @nomcopia varchar(30) /*una forma de ahorra tiempo es crear PROCEDURE , asi creamos instrucciones predifinidas*/
as
declare @sql varchar (100)
set @sql = 'backup database '+@bd +' to disk='+char(39)+'C:\copiasSeguridad\'+@nomcopia+'.bak'+char(39)
exec(@sql);
go
 
copiaBD 'base_consorcio','nombreCopiaSeguridad'; /*creamos BACKUP median el uso del procedure*/  
go


/*creamos los backup*/

--base datos

/*WITH FORMAT, INIT;: Son opciones adicionales para la copia de seguridad
FORMAT sobreescribe cualquier copia de seguridad existente
*/

BACKUP DATABASE base_consorcio
TO DISK = 'C:\copiasSeguridad\backup_baseDatos.bak'
WITH FORMAT, INIT;
go

--otra version
backup database  base_consorcio to disk= 'C:\copiasSeguridad\backup20112023.bak';

go

--comprobamos el modo de recuperacion

SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'base_consorcio';

--sys.databases= contiene informaci�n sobre todas las bases de datos
--cambiamos el modelo de recupeacion a full

ALTER DATABASE base_consorcio SET RECOVERY FULL;
/*modos de backup 


Simple: Elimina autom�ticamente los registros de transacciones una vez 
completadas las operaciones; no permite backups de registros de transacciones 
individuales, ideal para bases de datos donde la p�rdida de datos no es cr�tica
 y se prioriza el rendimiento.

Bulk Logged: Registra operaciones masivas m�nimamente para reducir el tama�o 
del registro; permite backups de registros de transacciones, �til para operaciones 
masivas, pero las restauraciones pueden requerir consideraciones adicionales debido 
a las operaciones masivas registradas m�nimamente.

Full: Registra todas las operaciones en el registro de transacciones; permite backups 
de registros de transacciones para restauraciones a puntos espec�ficos en el tiempo,
 proporciona m�xima protecci�n de datos, pero requiere una gesti�n cuidadosa del espacio
  del registro para evitar el crecimiento excesivo.*/

-- backup log registros
BACKUP LOG base_consorcio
TO DISK = 'C:\copiasSeguridad\registrosBackup.trn'
WITH FORMAT, INIT;

go

--restauracion de las base de datos , recuperar las copias de seguridad
use master -- usamos base de datos master pq no debe estar en uso la bd que vamos a restaurar
RESTORE DATABASE base_consorcio
FROM DISK = 'C:\copiasSeguridad\backup_baseDatos.bak'
WITH REPLACE, NORECOVERY;
/*NORECOVERY=  Esto permite restaurar m�s archivos de copia de seguridad ya que la base de datos no estar� disponible para su uso despu�s de la restauraci�n*/

go
RESTORE LOG base_consorcio
FROM DISK = 'C:\copiasSeguridad\registrosBackup.trn'
WITH RECOVERY;

/*RECOVERY = Despu�s de esta operaci�n, la base de datos estar� disponible y se permitir�n operaciones de lectura y escritura en ella.*/


