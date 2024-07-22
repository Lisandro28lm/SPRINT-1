
-- ------------------ NIVEL 1 ------------------
-- //// 	EJERCICIO 1 (Nivel 1)

DESCRIBE company;
DESCRIBE transaction;

SELECT *
FROM company;
SELECT * 
FROM transaction;

-- //// 	EJERCICIO 2 (Nivel 1)
-- // 2.a. Listado de los países que están haciendo compras (utilizando JOIN)

SELECT DISTINCT c.country
FROM company as c
JOIN transaction as t
ON c.id = t.company_id
WHERE c.country IS NOT NULL;

-- // 2.b  Desde cuántos países se realizan las compras.

SELECT COUNT(DISTINCT c.country) as Total_Paises_Compra
FROM company as c
JOIN transaction as t
ON c.id = t.company_id
WHERE c.country IS NOT NULL;

-- // 2.c  Identifica la compañía con el promedio más grande de ventas.

SELECT c.company_name, ROUND(AVG(amount),2) as Promedio_Ventas
FROM company as c
JOIN transaction as t
ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.company_name
ORDER BY Promedio_Ventas DESC
LIMIT 1;

-- //// 	EJERCICIO 3 (Nivel 1)
-- // 3.a  Muestra todas las transacciones realizadas por empresas de Alemania. (SIN JOINS)

SELECT t.id as transaction_id,
       c.id as company_id,
       c.company_name,
       c.country
FROM transaction t,
     (SELECT id, company_name, country
      FROM company
      WHERE country = 'Germany') as c
WHERE t.company_id = c.id;

                                      
-- // 3.b Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.
SELECT *
FROM company as c
WHERE c.id in (SELECT t.company_id
			   FROM transaction as t
			   WHERE t.amount > (SELECT AVG(AMOUNT)
								 FROM transaction));
												
-- // 3.c Eliminarán del sistema las empresas que no tienen transacciones registradas, entrega el listado de estas empresas.

SELECT c.company_name as Cias_sin_transacciones
FROM company as c
WHERE NOT EXISTS (SELECT t.company_id
			  FROM transaction as t
              WHERE t.company_id = c.id);
              
              
-- ------------------ NIVEL 2------------------
-- //// 	EJERCICIO 1  (Nivel 2)
-- // Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. Muestra la fecha de cada transacción junto con el total de las ventas.

SELECT DATE(timestamp), SUM(amount) as Top_5_Vtas
FROM transaction as t
WHERE declined = 0
GROUP BY DATE(timestamp)
ORDER BY Top_5_Vtas DESC
LIMIT 5;

-- //// 	EJERCICIO 2  (Nivel 2)
-- // ¿Cuál es el promedio de ventas por país? Presenta los resultados ordenados de mayor a menor medio.
SELECT c.country, round(AVG(amount),2) as Promedio_Vtas_Pais
FROM transaction as t
JOIN company as c
ON t.company_id = c.id
WHERE declined = 0
AND c.country IS NOT NULL
GROUP BY  c.country
ORDER BY AVG(amount) DESC;

          
-- //// 	EJERCICIO 3  (Nivel 2)
-- // Mostrar el listado de todas las transacciones realizadas por empresas que estan en el mismo pais que "Non Institute"

-- // 3.a Muestra el Listado con JOIN y subconsultas
SELECT t.id, t.amount, c.company_name, c.country
FROM transaction as t
JOIN company as c
ON c.id = t.company_id
WHERE c.country = (SELECT c1.country
				   FROM company as c1
                   WHERE c1.company_name = "Non Institute");

-- // 3.c Muestra el Listado con subconsultas
SELECT *
FROM transaction as t
WHERE t.company_id IN (SELECT c.id
					  FROM company as c
					  WHERE c.country =  (SELECT c1.country
										  FROM company as c1
										  WHERE c1.company_name = "Non Institute"));


-- ------------------ NIVEL 3------------------
-- //// 	EJERCICIO 1  (Nivel 3)
-- // Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones con un valor comprendido entre 100 y 200 euros y,
-- en alguna de estas fechas: 29 de abril de 2021, 20 de julio de 2021 y 13 de marzo de 2022. Ordena los resultados de mayor a menor cantidad.

SELECT c.company_name as nombre, c.phone as telefono, c.country as pais, date(t.timestamp) as fecha, t.amount as importe
FROM company as c
JOIN transaction as t
ON c.id = t.company_id
WHERE t.amount BETWEEN 100 and 200
AND DATE(timestamp) in ("2021-04-29","2021-07-20","2022-03-13")
order by t.amount desc;

-- //// 	EJERCICIO 2 (Nivel 3)
-- // Cantidad de transacciones que realizan las empresas y listado para especificar si tienen mas de 4 transacciones o menos de 4.

SELECT t.company_id, c.company_name, COUNT(t.company_id) as Recuento,
	   CASE
	   WHEN	COUNT(t.company_id) >= 4 THEN "4 o mas operaciones"
       ELSE "menos de 4 operaciones"
       END as Cant_Operaciones
FROM transaction as t
JOIN company as c
ON t.company_id = c.id
WHERE c.company_name IS NOT NULL
GROUP BY t.company_id
ORDER BY Recuento DESC;
