 
## 	-----------EJERCICIO 2 (NIVEL 1)
# Listado de los países que están haciendo compras

select distinct c.country
from transaction as t
join company as c
on t.company_id = c.id;

# Desde cuántos países se realizan las compras.
select count(distinct c.country) as NroPaises_que_compran
from transaction as t
join company as c
on t.company_id = c.id;

# Identifica la compañía con la mayor media de ventas.
select c.company_name, round(avg(t.amount),2) as prom_vta
from transaction as t
join company as c
on t.company_id = c.id
where t.declined = 0
group by c.company_name
order by avg(t.amount) desc
limit 1;


## 	-----------EJERCICIO 3 (NIVEL 1)
########## Muestra todas las transacciones realizadas por empresas de Alemania	

select t.id as transc_operac_Cia_Alemania
from transaction as t
where t.company_id in (select c.id
						from company as c
                        where c.country = "Germany");
                        
########## Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones..
select distinct (select c.company_name 
		from company as c
        where c.id = t.company_id)
from transaction as t
where t.amount > (select avg(amount)
					from transaction);
                    
########## Eliminarán del sistema las empresas que no tienen transacciones registradas, entrega el listado de estas empresas.
### ver posibilidadel uso clausula not exists 

select distinct c.id
from company as c
where c.id not in (select t.company_id
					from transaction as t);


##EJERCICIO 1 (NIVEL 2)
### Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
## Muestra la fecha de cada transacción junto con el total de las ventas.

###---> Entiendo que es igual tanto con en uno y otro caso, no utilice ni Join ni subconsulta.
select date(t.timestamp), sum(amount)
from transaction as t
where declined = 0
group by date(t.timestamp)
order by sum(amount) desc
limit 5;


### Ejercicio 2 (NIVEL 2)
###¿Cuál es el promedio de ventas por país? Presenta los resultados ordenados de mayor a menor medio.
select c.country, round(avg(amount),2) as Promedio_Vtas_Pais
from transaction as t
join company as c
on t.company_id = c.id
where declined = 0
group by  c.country
order by avg(amount) desc;

select (select c.country
		from company as c
		where t.company_id = c.id) as t2, avg(amount)
from transaction as t
where declined = 0
group by t2
order by avg(amount) desc;


### Ejercicio 3 (NIVEL 2)
###En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia
### a la compañía "Non Institute". Para ello, te piden la lista de todas las transacciones realizadas por empresas que están situadas en el mismo país que esta compañía.

                    
select t.id
from transaction as t
join company as c
on t.company_id = c.id
where c.country in (select c.country
					from company as c
                    where c.company_name= "Non Institute")
and c.company_name != "Non Institute";

## este útlimo con Subconsulta no llegué al resultado

#####--> CON SUBCONSULTA
select t.id
from transaction as t
where t.company_id = (select c.id
						from company as c
						where c.company_name = "Non Institute");


### ---------- NIVEL 3 -----------------###
### Ejercicio 1 (NIVEL 3)
### Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones con 
## un valor comprendido entre 100 y 200 euros y en alguna de estas fechas: 29 de abril de 2021, 20 de julio de 2021 
## y 13 de marzo de 2022. Ordena los resultados de mayor a menor cantidad.


select c.company_name as nombre, c.phone as telefono, c.country as pais, date(t.timestamp) as fecha, t.amount as importe
from company as c
join transaction as t
on c.id = t.company_id
where t.amount between 100 and 200
and date(t.timestamp) in ("2021-04-29","2021-07-20","2022-03-13")
order by t.amount desc;


### ---------- NIVEL 3 -----------------###
### Ejercicio 2
### Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, por lo que
### te piden la información sobre la cantidad de transacciones que realizan las empresas, pero el departamento de recursos humanos es exigente y quiere un listado de las empresas donde especifiques si tienen más de 4 transacciones o menos.

select
	c.company_name,
    case 
		when count(t.id) >= 4 then "4 operaciones o más"
		else 'menos de 4 operaciones'
		end as 'filtro cant operaciones'
from transaction as t
join company as c
on t.company_id = c.id
group by c.company_name, t.company_id;


select *
from transaction;

select *
from company;
