DELIMITER $$

USE `directma_reclutamiento`$$

DROP PROCEDURE IF EXISTS `ObtProspectosCaracteristicasParticulares`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectosCaracteristicasParticulares`(IN `pNombre` VARCHAR(255), IN `pActivo` INT, IN `pIdCaracteristica` VARCHAR(5000), IN `pValor` VARCHAR(5000), IN `pIdEmpresa` INT)
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
    (SELECT Nombre FROM catalogo WHERE IdCatalogo = pro.IdEstadoCivil) AS NombreEstadoCivil,
	(SELECT Nombre FROM catalogo WHERE IdCatalogo = pro.IdSexo) AS NombreSexo,
	(SELECT Nombre FROM catalogo WHERE IdCatalogo = pro.IdEscolaridad) AS NombreEscolaridad,
    (Select MAX(bitacora.FechaCreacion) FROM bitacora WHERE bitacora.IdProspecto = pro.IdProspecto) as FechaContacto,
	pro.Estatus,
	pro.CP,
    pro.Calle,
    pro.Clave_Colonia
FROM prospecto pro
	LEFT JOIN prospectocaracteristica ON pro.IdProspecto = prospectocaracteristica.IdProspecto';
    IF (pIdEmpresa != 0) THEN
    SET @SQL = CONCAT(@SQL,' WHERE pro.IdEmpresa = ',pIdEmpresa,'');
    ELSE SET @SQL = CONCAT(@SQL,' WHERE  1=1 ');
    END IF;
    IF(pIdCaracteristica != '') THEN
    SET @SQL = CONCAT(@SQL,' AND (prospectocaracteristica.IdCaracteristicaParticular = ',pIdCaracteristica,')');
    END IF;
    IF(pNombre != '') THEN
    SET @SQL = CONCAT(@SQL,' AND (pro.Nombre LIKE ',pNombre,' or pro.Apellidos LIKE',pNombre,')');
    END IF;
    IF(pActivo != -1) THEN
    SET @SQL = CONCAT(@SQL,' AND (pro.Estatus = ',pActivo,')');
    END IF;
	PREPARE stmt1 
	FROM @SQL;
	EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
    END$$

DELIMITER ;