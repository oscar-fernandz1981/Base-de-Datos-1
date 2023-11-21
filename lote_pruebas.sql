--USE base_consorcio;

--Activamos la funcion para ver el plan de ejecucion para poder observar que indice se utiliza.

--Para ver las operaciones de entrada/salida y el tiempo de ejecucion de las consultas.
SET STATISTICS IO, TIME ON;

--Cracion del indice columnar no agrupado IDX_gastoNew con todas las columnas de la tabla gastoNew. 
CREATE NONCLUSTERED COLUMNSTORE INDEX IDX_gastoNew 
ON gastoNew(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe);

--Elimina el indice IDX_gastoNEW de la tabla gastoNew
  DROP INDEX IDX_gastoNew ON gastoNew;

--Ver el contenido y la estructura de la tabla gastoNew.
SELECT * FROM gastoNew;

--Sin indice columnar: logical reads 5704, 4617 ms.
--Con indice columnar: lob logical reads 1234, 4582 ms.

--Cantidad de registros que existen en la tabla gastoNew.
SELECT COUNT(*) FROM gastoNew;

--Sin indice columnar: logical reads 5704, 88 ms.
--Con indice columnar: lob logical reads 673, 14 ms.


--Prueba 1
--Lista de registros con idprovincia = 6.
SELECT idprovincia
FROM gastoNew
WHERE idprovincia = 6;

--Prueba 2
--Lista de idprovincia, idlocalidad, idconsorcio y importe con fecha de pago 01-01-2015.
SELECT idprovincia, idlocalidad, idconsorcio, importe
FROM gastoNew
WHERE fechapago = '2015-01-01';

--Sin indice columnar: logical reads 5704, 92 ms.
--Con indice columnar: lob logical reads 2470, 83 ms.

--Prueba 3
--Lista de importa total de la fecha 01-01-2015.
SELECT SUM(importe)
FROM gastoNew
WHERE fechapago = '2015-01-01';

--Sin indice columnar: logical reads 5704, 52 ms.
--Con indice columnar: lob logical reads 1071, 14 ms.

--Prueba 4
--Lista de importe mayores a 50000.
SELECT importe
FROM gastoNew
WHERE importe > 50000;

--Sin indice columnar: logical reads 5704, 1708 ms.
--Con indice columnar: lob logical reads 817, 1878 ms.


--Prueba 5
--Provincia con un importe superior a 1000000000
SELECT idprovincia, sum(importe) AS importe_provincia
FROM gastoNew
GROUP BY idprovincia
HAVING sum(importe) >= 1000000000;



--Prueba 6
--Importe que pago cada provincia el dia 01-01-2015.
SELECT idprovincia, sum(importe) AS importe_provincia, fechapago
FROM gastoNew
GROUP BY idprovincia, fechapago
HAVING fechapago = '2015-01-01';

--Sin indice columnar: logical reads 5704, 65 ms.
--Con indice columnar: lob logical reads 1075, 30 ms.
