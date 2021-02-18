DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectosCaracteristicasParticulares`(IN `pNombre` VARCHAR(255), IN `pActivo` INT, IN `pIdCaracteristica` VARCHAR(5000), IN `pValor` VARCHAR(5000), IN `pIdEmpresa` INT, IN `pCaracteristicasGenerales` VARCHAR(5000))
BEGIN

#### test: call obtProspectosCaracteristicasParticulares('',-1, '','',1,'')

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
pro.SalarioFinal,
pro.NivelIngles,
pro.Comentario,
pro.IdEstadoCivil,
pro.IdSexo,
pro.IdEscolaridad,
pro.foto as Foto,
IFNULL(TIMESTAMPDIFF(YEAR,pro.FechaNacimiento,now()),0) AS Edad,
(SELECT Nombre FROM catalogo WHERE IdCatalogo = pro.IdEstadoCivil) AS NombreEstadoCivil,
(SELECT Nombre FROM catalogo WHERE IdCatalogo = pro.IdSexo) AS NombreSexo,
(SELECT Nombre FROM catalogo WHERE IdCatalogo = pro.IdEscolaridad) AS NombreEscolaridad,
(Select MAX(bitacora.FechaCreacion) FROM bitacora WHERE bitacora.IdProspecto = pro.IdProspecto) as FechaContacto,
pro.Estatus,
pro.CP,
pro.Calle,
pro.Clave_Colonia,
col.CiudadEstado
FROM prospecto pro
LEFT JOIN prospectocaracteristica ON pro.IdProspecto = prospectocaracteristica.IdProspecto
LEFT JOIN (SELECT p.IdProspecto, concat (cd.`Nombre`,", ", e.`Nombre`) as CiudadEstado FROM prospecto P
INNER JOIN colonia C ON c.`Clave_Colonia` = P.`Clave_Colonia` AND P.`CP` = C.`CodigoPostal`
INNER JOIN ciudad cd ON Cd.`Clave_Ciudad` = C.`Clave_Ciudad` AND cd.`Clave_Estado` = c.`Clave_Estado` AND Cd.`Clave_Pais` = C.`Clave_Pais`
INNER JOIN estado E ON E.`Clave_Estado` = C.`Clave_Estado`) col on col.IdProspecto = pro.IdProspecto';

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

    

    IF(pCaracteristicasGenerales != '') THEN 

    SET @SQL = CONCAT(@SQL,pCaracteristicasGenerales);

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