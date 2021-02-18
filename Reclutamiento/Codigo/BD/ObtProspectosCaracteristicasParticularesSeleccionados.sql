DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectosCaracteristicasParticularesSeleccionados`(IN `aux` VARCHAR(255))
BEGIN


SET @SQL =  'SELECT DISTINCT pro.IdProspecto,concat_WS(" ", pro.Nombre, pro.Apellidos) as NombreCompleto, pro.Nombre, pro.Apellidos, pro.Direccion, pro.FechaNacimiento, pro.TelefonoMovil, pro.TelefonoOtro, pro.RFC, pro.Email, pro.Salario, pro.SalarioFinal, pro.NivelIngles, pro.Comentario, pro.IdEstadoCivil, pro.IdSexo, pro.IdEscolaridad, pro.foto as Foto, IFNULL(TIMESTAMPDIFF(YEAR,pro.FechaNacimiento,now()),0) AS Edad, (SELECT Nombre FROM catalogo WHERE IdCatalogo = pro.IdEstadoCivil) AS NombreEstadoCivil, (SELECT Nombre FROM catalogo WHERE IdCatalogo = pro.IdSexo) AS NombreSexo, (SELECT Nombre FROM catalogo WHERE IdCatalogo = pro.IdEscolaridad) AS NombreEscolaridad, (Select MAX(bitacora.FechaCreacion) FROM bitacora WHERE bitacora.IdProspecto = pro.IdProspecto) as FechaContacto, pro.Estatus, pro.CP, pro.Calle, pro.Clave_Colonia, col.CiudadEstado FROM prospecto pro LEFT JOIN prospectocaracteristica ON pro.IdProspecto = prospectocaracteristica.IdProspecto LEFT JOIN (SELECT p.IdProspecto, concat (cd.`Nombre`,", ", e.`Nombre`) as CiudadEstado FROM prospecto P INNER JOIN colonia C ON c.`Clave_Colonia` = P.`Clave_Colonia` AND P.`CP` = C.`CodigoPostal` INNER JOIN ciudad cd ON Cd.`Clave_Ciudad` = C.`Clave_Ciudad` AND cd.`Clave_Estado` = c.`Clave_Estado` AND Cd.`Clave_Pais` = C.`Clave_Pais` INNER JOIN estado E ON E.`Clave_Estado` = C.`Clave_Estado`) col on col.IdProspecto = pro.IdProspecto';
 
   IF(aux != '') THEN 

    SET @SQL = CONCAT(@SQL,aux);

    END IF;
    

##select @SQL;
	PREPARE stmt1 

	FROM @SQL;

	EXECUTE stmt1;

    DEALLOCATE PREPARE stmt1;

    END$$
DELIMITER ;