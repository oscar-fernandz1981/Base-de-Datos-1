use base_consorcio;

--creamos la tabla gastoNew
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


--select * from gasto;


--CARGA DE UN MILLON DE REGISTROS
--INSERCION POR LOTES

--select * from gastoNew;

/*declare @tamanioLote int = 1000; -- Tamaño del lote
declare @cont int = 1; -- Contador de lotes

-- Inicia un bucle para la inserción por lotes
while @cont <= 1000000 -- Cambia 1000 por el número de lotes necesarios para un millón de registros
begin
    insert into gastoNew (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    select top (@tamanioLote) idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
    from gasto
    --where idgasto not in (select idgastoNew from gastoNew); -- Evita duplicados

    set @cont = @cont + 1;
end;



-- Declarar el tamaño del lote y el contador
DECLARE @BatchSize INT = 1000; -- Tamaño del lote
DECLARE @Counter INT = 1;     -- Contador de lotes

-- Iniciar un bucle para la inserción por lotes
WHILE @Counter <= 1000000 -- Cambia 1000 al número de lotes necesarios para un millón de registros
BEGIN
    -- Insertar registros desde gasto a gastoNew en lotes
    INSERT INTO gastoNew (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    SELECT TOP (@BatchSize) idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
    FROM gasto
    WHERE idgasto NOT IN (SELECT idgasto FROM gastoNew); -- Evitar duplicados

    SET @Counter = @Counter + 1;
END;

insert into gastoNew (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
select idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
from gasto
order by idgasto
offset 0 rows
fetch next 1000000 rows only; -- Ajusta el tamaño del lote según tus necesidades*/

INSERT INTO gastoNew (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
SELECT idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
FROM (
    SELECT idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe,
           ROW_NUMBER() OVER (ORDER BY idgasto) AS RowNumber
    FROM gasto
) AS Subquery
WHERE RowNumber BETWEEN 1 AND 1000000; -- Ajusta el tamaño del lote según tus necesidades

