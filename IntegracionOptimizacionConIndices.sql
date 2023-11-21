USE base_consorcio;

--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS IO, TIME ON;

--Elimina el indice columnar creado en la tabla gastoNew
DROP INDEX IDX_gastoNew ON gastoNew;

--Consulta: Gastos del periodo 8 
SELECT g.idgastoNew, g.periodo, g.fechapago, t.descripcion
FROM gastoNew g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;


--SqlServer toma la PK de gasto como indice CLUSTERED, asique para crear el solicitado en periodo debemos primero eliminar el actual
ALTER TABLE gastoNew
	DROP CONSTRAINT PK_gastoNew;


--Transformamos la PK en un indice NONCLUSTERED
ALTER TABLE gastoNew
	ADD CONSTRAINT PK_gastoNew PRIMARY KEY NONCLUSTERED (idgastoNew);

--Creamos un nuevo indice CLUSTERED en periodo
CREATE CLUSTERED INDEX IDX_gastoNew_periodo
ON gastoNew (periodo);

--Creamos un nuevo indice NONCLUSTERED en periodo, idtipogasto, idgastoNew y fechapago en ese orden.
CREATE NONCLUSTERED INDEX IDX_gastoNew_periodo_idtipogasto_idgastoNew_fechapago
ON gastoNew (periodo, idtipogasto, idgastoNew, fechapago);



--Eliminar el indice IDX_gastoNew_periodo
DROP INDEX IDX_gastoNew_periodo_idtipogasto_idgastoNew_fechapago ON gastoNew;