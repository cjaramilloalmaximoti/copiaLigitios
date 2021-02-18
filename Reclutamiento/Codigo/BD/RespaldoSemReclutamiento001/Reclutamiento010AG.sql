ALTER TABLE `prospecto` CHANGE `Nombre` `Nombre` VARCHAR(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL, CHANGE `Apellidos` `Apellidos` VARCHAR(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL, CHANGE `FechaNacimiento` `FechaNacimiento` TIMESTAMP NULL, CHANGE `RFC` `RFC` VARCHAR(13) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL, CHANGE `Email` `Email` VARCHAR(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL, CHANGE `TelefonoMovil` `TelefonoMovil` VARCHAR(15) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL, CHANGE `TelefonoOtro` `TelefonoOtro` VARCHAR(15) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL, CHANGE `IdSexo` `IdSexo` INT(11) NULL, CHANGE `Direccion` `Direccion` VARCHAR(250) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL, CHANGE `CV` `CV` VARCHAR(250) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL, CHANGE `Foto` `Foto` VARCHAR(250) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL, CHANGE `Salario` `Salario` FLOAT NULL, CHANGE `IdCiudad` `IdCiudad` INT(11) NULL, CHANGE `IdEstadoCivil` `IdEstadoCivil` INT(11) NULL, CHANGE `IdProfesion` `IdProfesion` INT(11) NULL, CHANGE `IdUsuarioCreacion` `IdUsuarioCreacion` INT(11) NULL, CHANGE `FechaCreacion` `FechaCreacion` TIMESTAMP NULL, CHANGE `IdUsuarioUltimoModifico` `IdUsuarioUltimoModifico` INT(11) NULL, CHANGE `FechaModificacion` `FechaModificacion` TIMESTAMP NULL, CHANGE `Estatus` `Estatus` TINYINT(1) NULL DEFAULT '1', CHANGE `IdEmpresa` `IdEmpresa` INT(11) NULL DEFAULT NULL;

ALTER TABLE `prospecto` CHANGE `IdProspecto` `IdProspecto` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `prospecto` CHANGE `IdSexo` `IdSexo` INT(11) NULL DEFAULT NULL;
ALTER TABLE `prospecto` CHANGE `Salario` `Salario` FLOAT NULL DEFAULT NULL; 

DROP PROCEDURE if EXISTS `ObtCiudades`; 

DROP PROCEDURE if EXISTS `InsCliente`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCliente`(IN `pIdEmpresa` INT, IN `pRFC` VARCHAR(13), IN `pRazonSocial` VARCHAR(96), IN `pNombreComercial` VARCHAR(64), IN `pDireccion` VARCHAR(250), IN `pContacto_Nombre` VARCHAR(64), IN `pContacto_Email` VARCHAR(64), IN `pContacto_Telefono` VARCHAR(32), IN `pComentarios` VARCHAR(128), IN `pEstatus` TINYINT(1), IN `pIdUsuarioLog` INT, IN `pEmpresaCorreo` VARCHAR(64), IN `pEmpresaTelefono` VARCHAR(64)) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN
    DECLARE pIdCliente INT;
    
 	IF (SELECT COUNT(1)
 		from cliente 
 		where	RFC = pRFC 
 				and Estatus = 1
                AND IdEmpresa = pIdEmpresa) != 0 THEN
		SELECT 'Error al insertar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
	    
 	ELSE
 		
        INSERT INTO cliente
		(
		IdEmpresa,
		RFC,
		RazonSocial,
		NombreComercial,
		Direccion,
        EmpresaCorreo,
        EmpresaTelefono,
        Contacto_Nombre,
		Contacto_Email,
		Contacto_Telefono,
		Comentarios,
		Estatus,
		IdUsuarioCreacion,
		FechaCreacion,
		IdUsuarioUltimoModifico,
		FechaModificacion)
		VALUES
		(
		pIdEmpresa,
		pRFC,
		pRazonSocial,
		pNombreComercial,
		pDireccion,
        pEmpresaCorreo,
        pEmpresaTelefono,
		pContacto_Nombre,
		pContacto_Email,
		pContacto_Telefono,
		pComentarios,
		pActivo,
		pIdUsuarioLog,
		now(),
		pIdUsuarioLog,
		now());
        
		set pIdCliente = (SELECT MAX(IdCliente) from cliente);
        SELECT null as ErrorMessage, pIdCliente as IdCliente;
        
	END IF;
    
END$$
DELIMITER ;


DROP PROCEDURE if EXISTS `InsProspecto`; 

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsProspecto`(
IN `pIdProspecto` INT, IN `pNombre` VARCHAR(100), IN `pApellidos` VARCHAR(100), 
IN `pFechaNacimiento` TIMESTAMP, IN `pRFC` VARCHAR(13), IN `pEmail` VARCHAR(100), 
IN `pTelefonoMovil` VARCHAR(10), IN `pTelefonoOtro` VARCHAR(10), IN `pIdSexo` INT, 
IN `pDireccion` VARCHAR(250), IN `pCV` VARCHAR(250), IN `pFoto` VARCHAR(250), 
IN `pSalario` DOUBLE, IN `pIdCiudad` INT, IN `pIdEstadoCivil` INT, 
IN `pIdProfesion` INT, IN `pIdUsuarioLog` INT, IN `pEstatus` TINYINT(1), 
IN `pIdEmpresa` INT) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER 
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
	  Direccion,
	  CV,
	  Foto,
	  Salario,
	  IdCiudad,
	  IdEstadoCivil,
	  IdProfesion,
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
	  pCV,
	  pFoto,
	  pSalario,
	  pIdCiudad,
	  pIdEstadoCivil,
	  pIdProfesion,
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

drop PROCEDURE if EXISTS `ActProspecto`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActProspecto`(
IN `pIdProspecto` INT, IN `pNombre` VARCHAR(100), IN `pApellidos` VARCHAR(100), 
IN `pFechaNacimiento` TIMESTAMP, IN `pRFC` VARCHAR(13), IN `pEmail` VARCHAR(100), 
IN `pTelefonoMovil` VARCHAR(10), IN `pTelefonoOtro` VARCHAR(10), IN `pIdSexo` INT, 
IN `pDireccion` VARCHAR(250), IN `pCV` VARCHAR(250), IN `pFoto` VARCHAR(250), 
IN `pSalario` DOUBLE, IN `pIdCiudad` INT, IN `pIdEstadoCivil` INT, 
IN `pIdProfesion` INT, IN `pIdUsuarioLog` INT, IN `pEstatus` TINYINT(1), 
IN `pIdEmpresa` INT) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER 
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
	  Direccion = pDireccion,
	  CV = pCV,
	  Foto = pFoto,
	  Salario = pSalario,
	  IdCiudad = pIdCiudad,
	  IdEstadoCivil = pIdEstadoCivil,
	  IdProfesion = pIdProfesion,
	  IdUsuarioUltimoModifico = pIdUsuarioLog,
	  FechaModificacion = now(),
	  Estatus = pEstatus
	WHERE IdProspecto = pIdProspecto
		  and IdEmpresa = pIdEmpresa;
        
        SELECT null as ErrorMessage;

END$$
DELIMITER ;



DROP PROCEDURE if EXISTS `ObtProspectos`; 

DELIMITER $$
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
	   p.Nombre as Nombre,
	   p.Apellidos as Apellidos,
           p.FechaNacimiento as FechaNacimiento,
	   p.RFC as RFC,
	   p.Email as Email,
           p.TelefonoMovil as TelefonoMovil,
	   p.TelefonoOtro as TelefonoOtro,
	   p.Direccion as Direccion,
	   p.CV as CV,
	   p.Foto as Foto,
	   p.Salario as Salario,
	   p.IdSexo as IdSexo, 
           cSexo.Nombre as NombreSexo,
	   p.IdCiudad as IdCiudad,
	   p.IdEstadoCivil as IdEstadoCivil,
           cEC.Nombre as NombreEstadoCivil,
	   p.IdProfesion as IdProfesion,   
           cProf.Nombre as NombreProfesion,
	   p.Estatus as Estatus
	FROM prospecto p left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
    	  left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
          left join catalogo cProf ON p.IdProfesion = cProf.IdCatalogo
	where p.Nombre like concat('%', IFNULL(pNombre, ''), '%')
			and p.Apellidos like concat('%', IFNULL(pNombre, ''), '%')
			and p.Estatus between pDesde and pHasta
			AND p.IdEmpresa = pIdEmpresa;

END$$
DELIMITER ;



INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (10,'Reclutamiento010AG','Alejandro Gutiérrez','20180105','Modificar unas tablas de prospectos, agregar porcedimeitnos de prospectos');




