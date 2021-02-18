SELECT 
	concat_ws(' ', pro.Nombre, pro.Apellidos) as NombreCompleto,
    pro.Nombre,
    pro.Apellidos,
	pro.Direccion,
	pro.FechaNacimiento,
	pro.TelefonoMovil,
	pro.TelefonoOtro,
    pro.RFC,
    pro.Email,
    pro.Salario,
    pro.NivelIngles,
    pro.Comentario,
    pro.IdEstadoCivil,
    pro.IdSexo,
    pro.IdEscolaridad,
    (SELECT Nombre FROM reclutamiento.catalogo WHERE IdCatalogo = pro.IdEstadoCivil) AS NombreEstadoCivil,
	(SELECT Nombre FROM reclutamiento.catalogo WHERE IdCatalogo = pro.IdSexo) AS NombreSexo,
	(SELECT Nombre FROM reclutamiento.catalogo WHERE IdCatalogo = pro.IdEscolaridad) AS NombreEscolaridad,
	pro.Estatus
FROM reclutamiento.prospecto pro
	LEFT JOIN reclutamiento.prospectocaracteristica ON pro.IdProspecto = reclutamiento.prospectocaracteristica.IdProspecto ;
    
    SELECT Valor
FROM reclutamiento.prospecto pro
	LEFT JOIN reclutamiento.prospectocaracteristica ON pro.IdProspecto = reclutamiento.prospectocaracteristica.IdProspecto 
    where (IdCaracteristicaParticular = 43 and (valor = 'Regular' or valor = 'Alto' or valor = 'Nulo' )) or (IdCaracteristicaParticular=43 and valor='true');
/*******************************************************************************************************************************************************************/
set @prueba = '28 or reclutamiento.prospectocaracteristica.IdCaracteristicaParticular = 31';
set @prueba2 = 'Minimo';
set @SQL = 'Select 
	pro.Nombre,
	pro.Direccion,
	pro.FechaNacimiento,
	pro.TelefonoMovil,
	pro.TelefonoOtro,
	(select Nombre from reclutamiento.catalogo where IdCatalogo = pro.IdSexo) as Sexo,
	(select Nombre from reclutamiento.catalogo where IdCatalogo = pro.IdEscolaridad) as Profesion,
	pro.Estatus
from reclutamiento.prospecto pro
	join reclutamiento.prospectocaracteristica on pro.IdProspecto = reclutamiento.prospectocaracteristica.IdProspecto
    where (reclutamiento.prospectocaracteristica.IdCaracteristicaParticular = 31)
    and (reclutamiento.prospectocaracteristica.Valor = ?);';
    PREPARE stmt1 
	FROM @SQL;
    
	EXECUTE stmt1 USING @prueba2;
    
    
    
DELIMITER ;;    
CREATE PROCEDURE `ObtProspectosCaracteristicasParticulares`(IN `pNombre` VARCHAR(255), IN `pActivo` INT, IN `pIdCaracteristica` VARCHAR(500), IN `pValor` VARCHAR(500), IN `pIdEmpresa` INT)
BEGIN
SET @SQL = 
'SELECT 
	pro.Nombre as NombreCompleto,
	pro.Direccion,
	pro.FechaNacimiento,
	pro.TelefonoMovil,
	pro.TelefonoOtro,
	(SELECT Nombre FROM reclutamiento.catalogo WHERE IdCatalogo = pro.IdSexo) AS NombreSexo,
	(SELECT Nombre FROM reclutamiento.catalogo WHERE IdCatalogo = pro.IdEscolaridad) AS NombreEscolaridad,
	pro.Estatus
FROM reclutamiento.prospecto pro
	JOIN reclutamiento.prospectocaracteristica ON pro.IdProspecto = reclutamiento.prospectocaracteristica.IdProspecto';
    SET @SQL = concat(@SQL,' WHERE 
    (reclutamiento.prospectocaracteristica.IdCaracteristicaParticular = ',pIdCaracteristica,')
    AND (',pValor,');');
	PREPARE stmt1 
	FROM @SQL;
	EXECUTE stmt1;
    deallocate prepare stmt1;
    END;;
    /********************************************************************************************************************************************************************/
    SELECT * FROM reclutamiento.prospectocaracteristica po
join prospecto on po.IdProspecto = prospecto.IdProspecto
where 
(IdCaracteristicaParticular=28 and IdCaracteristicaParticular=31 and IdCaracteristicaParticular=44) 
and (valor =  'true' and valor = 'Minimo' and STR_TO_DATE(Valor,'%d/%m/%Y') between cast('2017/11/20' as date) and cast('2018/11/20' as date))
and po.IdProspecto = prospecto.IdProspecto;

select * from prospectocaracteristica where STR_TO_DATE(Valor,'%d/%m/%Y') between cast('2017/11/20' as date) and cast('2018/11/20' as date);

SELECT * FROM reclutamiento.prospectocaracteristica
WHERE
1=1 AND
Valor BETWEEN 10 AND 53;

select DISTINCT prospecto.IdProspecto, Nombre from prospecto join prospectocaracteristica on prospecto.IdProspecto = prospectocaracteristica.IdProspecto
where prospecto.IdProspecto = prospectocaracteristica.IdProspecto
and (IdCaracteristicaParticular=28 or IdCaracteristicaParticular=31 or IdCaracteristicaParticular=44);
select prospectocaracteristica.IdProspecto from prospectocaracteristica where IdCaracteristicaParticular=28 and IdCaracteristicaParticular=31 and IdCaracteristicaParticular=44