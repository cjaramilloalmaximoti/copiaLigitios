drop procedure ObtProspectosCaracteristicasParticulares

DELIMITER ;;    
CREATE PROCEDURE `ObtProspectosCaracteristicasParticulares`(IN `pNombre` VARCHAR(255), IN `pActivo` INT, IN `pIdCaracteristica` VARCHAR(500), IN `pValor` VARCHAR(500), IN `pIdEmpresa` INT)
BEGIN
SET @SQL = 
'SELECT DISTINCT
	pro.IdProspecto,
	concat_ws(" ", pro.Nombre, pro.Apellidos) as NombreCompleto,
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
    pro.foto as Foto,
    (SELECT Nombre FROM reclutamiento.catalogo WHERE IdCatalogo = pro.IdEstadoCivil) AS NombreEstadoCivil,
	(SELECT Nombre FROM reclutamiento.catalogo WHERE IdCatalogo = pro.IdSexo) AS NombreSexo,
	(SELECT Nombre FROM reclutamiento.catalogo WHERE IdCatalogo = pro.IdEscolaridad) AS NombreEscolaridad,
    (Select MAX(bitacora.FechaCreacion) FROM bitacora WHERE bitacora.IdProspecto = pro.IdProspecto) as FechaContacto,
	pro.Estatus
FROM reclutamiento.prospecto pro
	LEFT JOIN reclutamiento.prospectocaracteristica ON pro.IdProspecto = reclutamiento.prospectocaracteristica.IdProspecto';
    IF (pIdEmpresa != 0) THEN
    SET @SQL = concat(@SQL,' WHERE pro.IdEmpresa = ',pIdEmpresa,'');
    ELSE SET @SQL = concat(@SQL,' WHERE  1=1 ');
    END IF;
    iF(pIdCaracteristica != '') THEN
    SET @SQL = concat(@SQL,' AND (reclutamiento.prospectocaracteristica.IdCaracteristicaParticular = ',pIdCaracteristica,')');
    END IF;
    IF(pNombre != '') THEN
    SET @SQL = concat(@SQL,' AND (pro.Nombre LIKE ',pNombre,' or pro.Apellidos LIKE',pNombre,')');
    END IF;
    IF(pActivo != -1) THEN
    SET @SQL = concat(@SQL,' AND (pro.Estatus = ',pActivo,')');
    END IF;
	PREPARE stmt1 
	FROM @SQL;
	EXECUTE stmt1;
    deallocate prepare stmt1;
    END;;
    
    CREATE INDEX IDX_Prospecto_IdEmpresa_NU_NC ON prospecto(IdEmpresa);
    CREATE FULLTEXT INDEX IDX_Prospecto_Nombre_NU_NC ON prospecto(Nombre);
    CREATE FULLTEXT INDEX IDX_Prospecto_Apelllidos_NU_NC ON prospecto(Apellidos);
    CREATE FULLTEXT INDEX IDX_ProspectoCaracteristica_Valor_NU_NC ON prospectocaracteristica(Valor);