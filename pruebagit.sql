WITH salidas AS(
	SELECT
	departamento,
	DATE_TRUNC('MONTH', fecha_salida) AS MES,
	COUNT(*) AS empleados_salidos
FROM empleados_rotacion
	WHERE fecha_salida IS NOT NULL
	GROUP BY departamento,
	DATE_TRUNC('MONTH', fecha_salida)

),

empleados_inicio AS(

SELECT
	departamento,
	DATE_TRUNC('MONTH', fecha_ingreso) AS MES,
	COUNT(*) AS empleados_al_inicio
FROM empleados_rotacion
	WHERE fecha_ingreso <= DATE_TRUNC('MONTH',NOW())
	GROUP BY departamento,
	DATE_TRUNC('MONTH', fecha_ingreso)
	
)

SELECT
	salidas.departamento,
	salidas.mes,
	salidas.empleados_salidos,
	COALESCE(empleados_inicio.empleados_al_inicio,0) AS Empleados_al_inicio,
	CASE
			WHEN COALESCE(empleados_inicio.empleados_al_inicio,0)= 0 THEN 0
			ELSE salidas.empleados_salidos::DECIMAL / COALESCE(empleados_inicio.empleados_al_inicio,0)
			END AS tasa_rotacion
	
FROM salidas LEFT JOIN empleados_inicio 
	ON salidas.departamento = empleados_inicio.departamento
AND salidas.mes = empleados_inicio.mes


