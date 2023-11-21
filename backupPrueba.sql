use base_consorcio;
/*backup proyecto*/

/*1_completa*/

backup database  base_consorcio to disk= 'C:\Users\antonio\Downloads\Backup.bak'; /*creamos backup de la base de datos y guardamos en una direccion*/

/*2_diferencial*/
backup database  base_consorcio to disk= 'C:\Users\antonio\Downloads\Backup.bak' with differential;


/*para crear mas rapido*/
go
create proc copiaBD @bd varchar(20) , @nomcopia varchar(30) /*una forma de ahorra tiempo es crear PROCEDURE , asi creamos instrucciones predifinidas*/
as
declare @sql varchar (100)
set @sql = 'backup database '+@bd +' to disk='+char(39)+'C:\Users\antonio\Downloads\'+@nomcopia+'.bak'+char(39)
exec(@sql);
go
 
copiaBD 'base_consorcio','nombreCopiaSeguridad'; /*creamos BACKUP median el uso del procedure*/  
