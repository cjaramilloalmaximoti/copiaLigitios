select * from prospecto;
alter table prospecto add Calle Varchar(100) not null;

USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ActProspecto`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActProspecto`(
IN `pIdProspecto` INT, 
IN `pNombre` VARCHAR(100), 
IN `pApellidos` VARCHAR(100), 
IN `pFechaNacimiento` TIMESTAMP, 
IN `pRFC` VARCHAR(13), 
IN `pEmail` VARCHAR(100), 
IN `pTelefonoMovil` VARCHAR(10), 
IN `pTelefonoOtro` VARCHAR(10), 
IN `pIdSexo` INT, 
IN `pDireccion` VARCHAR(250), 
IN `pSalario` DOUBLE, 
IN `pIdEstadoCivil` INT, 
IN `pIdEscolaridad` INT, 
IN `pIdUsuarioLog` INT, 
IN `pEstatus` TINYINT(1), 
IN `pIdEmpresa` INT, 
IN `pClaveColonia` VARCHAR(10), 
IN `pCP` VARCHAR(10), 
IN `pComentario` VARCHAR(250), 
IN `pNivelIngles` VARCHAR(50), 
IN `pFoto` VARCHAR(50),
IN `pCalle`VARCHAR(100)
)
BEGIN 
	UPDATE prospecto
	SET
	  Nombre = pNombre,
	  Apellidos = pApellidos, 
	  FechaNacimiento = pFechaNacimiento,
	  RFC = pRFC,
	  Email = pEmail,
	  TelefonoMovil = pTelefonoMovil, 
	  TelefonoOtro = pTelefonoOtro,
	  IdSexo = pIdSexo,
      Clave_Colonia = pClaveColonia,
      CP = pCP,
	  Direccion = pDireccion,
	  Salario = pSalario,
	  IdEstadoCivil = pIdEstadoCivil,
	  IdEscolaridad = pIdEscolaridad,
	  IdUsuarioUltimoModifico = pIdUsuarioLog,
	  FechaModificacion = now(),
	  Estatus = pEstatus,
      NivelIngles = pNivelIngles,
	  Comentario = pComentario,
      foto = ifnull(concat(pFoto), ''),
      Calle = pCalle
	WHERE IdProspecto = pIdProspecto
		  and IdEmpresa = pIdEmpresa;
        
        SELECT null as ErrorMessage;
END$$

DELIMITER ;

USE `directma_reclutamiento`;
DROP procedure IF EXISTS `InsProspecto`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsProspecto`(
IN `pIdProspecto` INT, 
IN `pNombre` VARCHAR(100), 
IN `pApellidos` VARCHAR(100), 
IN `pFechaNacimiento` TIMESTAMP, 
IN `pRFC` VARCHAR(13), 
IN `pEmail` VARCHAR(100), 
IN `pTelefonoMovil` VARCHAR(10), 
IN `pTelefonoOtro` VARCHAR(10), 
IN `pIdSexo` INT,
IN `pDireccion` VARCHAR(250), 
IN `pSalario` DOUBLE, 
IN `pIdEstadoCivil` INT, 
IN `pIdEscolaridad` INT, 
IN `pIdUsuarioLog` INT, 
IN `pEstatus` TINYINT(1), 
IN `pIdEmpresa` INT, 
IN `pClaveColonia` VARCHAR(10), 
IN `pCP` VARCHAR(10), 
IN `pComentario` VARCHAR(250), 
IN `pNivelIngles` VARCHAR(50), 
IN `pFoto` VARCHAR(50),
IN `pCalle`VARCHAR(100)
)
BEGIN 
  INSERT INTO prospecto 
	(
	  Nombre,
	  Apellidos,
	  FechaNacimiento,
	  RFC,
	  Email,
	  TelefonoMovil, 
	  TelefonoOtro,
	  IdSexo,
      Clave_Colonia,
      CP,
	  Direccion,
	  Salario,
	  IdEstadoCivil,
	  IdEscolaridad,
	  IdUsuarioCreacion,
	  FechaCreacion,
	  IdUsuarioUltimoModifico,
	  FechaModificacion,
	  Estatus,
	  Comentario,
      NivelIngles,
	  IdEmpresa,
      Calle
	)
	VALUES
	(
	  pNombre,
	  pApellidos,
	  pFechaNacimiento,
	  pRFC,
	  pEmail,
	  pTelefonoMovil,
	  pTelefonoOtro,
	  pIdSexo,
      pClaveColonia,
      pCP,
	  pDireccion,
	  pSalario,
	  pIdEstadoCivil,
	  pIdEscolaridad,
	  pIdUsuarioLog,
	  now(),
      pIdUsuarioLog,
	  now(),
	  pEstatus,
	  pComentario,
      pNivelIngles,
	  pIdEmpresa,
      pCalle
      );
      
      set pIdProspecto = (SELECT MAX(IdProspecto) from prospecto);
      
      update prospecto set foto = ifnull(concat(pIdProspecto, pFoto), '') where idProspecto = pIdProspecto;
      
      SELECT null as ErrorMessage, pIdProspecto as IdProspecto;
END$$

DELIMITER ;

USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ObtProspectoId`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectoId`(IN `pIdProspecto` INT)
BEGIN	
	SELECT
	   p.IdProspecto as IdProspecto,
	   p.Nombre as Nombre,
	   p.Apellidos as Apellidos,
           p.FechaNacimiento as FechaNacimiento,
	   p.RFC as RFC,
	   p.Email as Email,
           p.TelefonoMovil as TelefonoMovil,
	   p.TelefonoOtro as TelefonoOtro,
	   p.Direccion as Direccion,
	   p.Salario as Salario,
	   p.IdSexo as IdSexo, 
       cSexo.Nombre as NombreSexo,
	   p.IdCiudad as IdCiudad,
	   p.IdEstadoCivil as IdEstadoCivil,
       cEC.Nombre as NombreEstadoCivil,
	   p.IdEscolaridad as IdEscolaridad,   
       cEsco.Nombre as NombreEscolaridad,
	   p.Estatus as Estatus,
       p.Calle
	FROM prospecto p left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
    	  left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
          left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo
	where 
		p.IdProspecto = pIdProspecto;
END$$

DELIMITER ;

USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ObtProspectoPorCliente`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectoPorCliente`(IN `pCliente` INT)
BEGIN
SELECT DISTINCT
			p.IdProspecto AS IdProspecto,
			CONCAT(p.Nombre,' ', p.Apellidos) AS NombreCompleto,
			p.Nombre AS Nombre,
			p.Apellidos AS Apellidos,
			p.FechaNacimiento AS FechaNacimiento,
			p.RFC AS RFC,
			p.Email AS Email,
			p.TelefonoMovil AS TelefonoMovil,
			p.TelefonoOtro AS TelefonoOtro,
			p.Clave_Colonia AS Clave_Colonia,
			p.CP AS CP,
			p.Direccion AS Direccion,
			p.Salario AS Salario,
			p.IdSexo AS IdSexo, 
			cSexo.Nombre AS NombreSexo,
			p.IdEstadoCivil AS IdEstadoCivil,
			cEC.Nombre AS NombreEstadoCivil,
			p.IdEscolaridad AS IdEscolaridad,   
			cEsco.Nombre AS NombreEscolaridad,
			p.Estatus AS Estatus,
			p.Comentario, 
			p.NivelIngles,
			colonia.Nombre AS NombreColonia,
			(Select MAX(bitacora.FechaCreacion) FROM bitacora WHERE bitacora.IdProspecto = p.IdProspecto) AS FechaContacto,
			p.foto,
			vp.Finalista,
			vp.Invitaciones, p.Calle 
FROM prospecto p
LEFT JOIN vacante_prospecto vp ON vp.IdProspecto = p.IdProspecto
LEFT JOIN vacante vac ON vac.IdVacante = vp.IdVacante 
LEFT JOIN catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
LEFT JOIN catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
LEFT JOIN catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo
LEFT JOIN colonia ON (p.Clave_Colonia = colonia.Clave_colonia
AND p.CP = Colonia.CodigoPostal)
WHERE vac.IdCliente = pCliente
GROUP BY p.IdProspecto;
END$$

DELIMITER ;

USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ObtProspectos`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectos`(IN `pNombre` VARCHAR(100), IN `pActivo` INT, IN `pIdEmpresa` INT)
BEGIN
	Declare pDesde tinyint;
	Declare pHasta tinyint;	
         
	if(pActivo = -1) then
		SET pDesde = 0;
		SET pHasta = 1;
	else
		SET pDesde = pActivo;
		SET pHasta = pActivo;
	end if;
	
	SELECT
	   p.IdProspecto as IdProspecto,
	   CONCAT(p.Nombre,' ', p.Apellidos) as NombreCompleto,
	   p.Nombre as Nombre,
	   p.Apellidos as Apellidos,
           p.FechaNacimiento as FechaNacimiento,
	   p.RFC as RFC,
	   p.Email as Email,
           p.TelefonoMovil as TelefonoMovil,
	   p.TelefonoOtro as TelefonoOtro,
           p.Clave_Colonia as Clave_Colonia,
           p.CP as CP,
	   p.Direccion as Direccion,
	   p.Salario as Salario,
	   p.IdSexo as IdSexo, 
           cSexo.Nombre as NombreSexo,
	   p.IdEstadoCivil as IdEstadoCivil,
           cEC.Nombre as NombreEstadoCivil,
	   p.IdEscolaridad as IdEscolaridad,   
           cEsco.Nombre as NombreEscolaridad,
	   p.Estatus as Estatus,
	   p.Comentario,
       p.NivelIngles,
	   colonia.Nombre as NombreColonia,
	   (Select MAX(bitacora.FechaCreacion) FROM bitacora WHERE bitacora.IdProspecto = p.IdProspecto) as FechaContacto,
       p.foto, p.Calle
	FROM prospecto p left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
    	  left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
          left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo
	  left join colonia on (p.Clave_Colonia = colonia.Clave_colonia
			AND p.CP = Colonia.CodigoPostal
		)
	where (p.Nombre like concat('%', IFNULL(pNombre, ''), '%')
		OR p.Apellidos like concat('%', IFNULL(pNombre, ''), '%')	)
		AND p.Estatus between pDesde and pHasta
		AND p.IdEmpresa = pIdEmpresa;
END$$

DELIMITER ;


USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ObtProspectosCaracteristicasParticulares`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectosCaracteristicasParticulares`(IN `pNombre` VARCHAR(255), IN `pActivo` INT, IN `pIdCaracteristica` VARCHAR(500), IN `pValor` VARCHAR(500), IN `pIdEmpresa` INT)
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
    pro.Clave_Colonia,
    pro.Calle
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

