
ALTER TABLE `prospecto` DROP `CV`, DROP `Foto`; 
ALTER TABLE `prospecto` CHANGE `IdProfesion` `IdEscolaridad` INT(11) NULL DEFAULT NULL;

DROP PROCEDURE `InsProspecto`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsProspecto`(IN `pIdProspecto` INT, IN `pNombre` VARCHAR(100), IN `pApellidos` VARCHAR(100), IN `pFechaNacimiento` TIMESTAMP, IN `pRFC` VARCHAR(13), IN `pEmail` VARCHAR(100), IN `pTelefonoMovil` VARCHAR(10), IN `pTelefonoOtro` VARCHAR(10), IN `pIdSexo` INT, IN `pDireccion` VARCHAR(250), IN `pSalario` DOUBLE, IN `pIdCiudad` INT, IN `pIdEstadoCivil` INT, IN `pIdEscolaridad` INT, IN `pIdUsuarioLog` INT, IN `pEstatus` TINYINT(1), IN `pIdEmpresa` INT) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN 
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
	  Direccion,
	  Salario,
	  IdCiudad,
	  IdEstadoCivil,
	  IdEscolaridad,
	  IdUsuarioCreacion,
	  FechaCreacion,
	  IdUsuarioUltimoModifico,
	  FechaModificacion,
	  Estatus,
	  IdEmpresa
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
	  pDireccion,
	  pSalario,
	  pIdCiudad,
	  pIdEstadoCivil,
	  pIdEscolaridad,
	  pIdUsuarioLog,
	  now(),
      pIdUsuarioLog,
	  now(),
	  pEstatus,
	  pIdEmpresa
      );
      
      set pIdProspecto = (SELECT MAX(IdProspecto) from prospecto);
        SELECT null as ErrorMessage, pIdProspecto as IdProspecto;
END$$
DELIMITER ;


DROP PROCEDURE `ActProspecto`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActProspecto`(IN `pIdProspecto` INT, IN `pNombre` VARCHAR(100), IN `pApellidos` VARCHAR(100), IN `pFechaNacimiento` TIMESTAMP, IN `pRFC` VARCHAR(13), IN `pEmail` VARCHAR(100), IN `pTelefonoMovil` VARCHAR(10), IN `pTelefonoOtro` VARCHAR(10), IN `pIdSexo` INT, IN `pDireccion` VARCHAR(250), IN `pSalario` DOUBLE, IN `pIdCiudad` INT, IN `pIdEstadoCivil` INT, IN `pIdEscolaridad` INT, IN `pIdUsuarioLog` INT, IN `pEstatus` TINYINT(1), IN `pIdEmpresa` INT) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN 

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
	  Direccion = pDireccion,
	  Salario = pSalario,
	  IdCiudad = pIdCiudad,
	  IdEstadoCivil = pIdEstadoCivil,
	  IdEscolaridad = pIdEscolaridad,
	  IdUsuarioUltimoModifico = pIdUsuarioLog,
	  FechaModificacion = now(),
	  Estatus = pEstatus
	WHERE IdProspecto = pIdProspecto
		  and IdEmpresa = pIdEmpresa;
        
        SELECT null as ErrorMessage;
END$$
DELIMITER ;




DROP PROCEDURE `ObtProspectos`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectos`(IN `pNombre` VARCHAR(100), IN `pActivo` INT, IN `pIdEmpresa` INT) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN
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
	   p.Estatus as Estatus
	FROM prospecto p left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
    	  left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
          left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo
	where p.Nombre like concat('%', IFNULL(pNombre, ''), '%')
			and p.Apellidos like concat('%', IFNULL(pNombre, ''), '%')
			and p.Estatus between pDesde and pHasta
			AND p.IdEmpresa = pIdEmpresa;

END$$
DELIMITER ;


