ALTER TABLE `cliente` ADD `Clave_Colonia` VARCHAR(10) NOT NULL AFTER `NombreComercial`, ADD `CP` VARCHAR(10) NOT NULL AFTER `Clave_Colonia`; 
ALTER TABLE `prospecto` ADD `CP` VARCHAR(10) NOT NULL AFTER `IdCiudad`; 
ALTER TABLE `prospecto` CHANGE `IdCiudad` `Clave_Colonia` VARCHAR(10) NOT NULL;
update prospecto set Clave_Colonia = '1265', CP = '37220';
ALTER TABLE `prospecto` ADD `Comentario` VARCHAR(250) NULL AFTER `Estatus`; 


DROP PROCEDURE IF EXISTS `obtColonias`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtColonias`(
  IN `pClaveCiudad` VARCHAR(512),
  IN `pClaveEstado` VARCHAR(512),
  IN `pNombre` VARCHAR(512),
  IN `pActivo` INT
)
BEGIN
SELECT Clave_Colonia
      , Nombre
      , CodigoPostal
FROM colonia
WHERE Nombre like concat('%', IFNULL(pNombre, ''), '%') 
	AND Clave_Ciudad = pClaveCiudad
	AND Clave_Estado = pClaveEstado
	AND Estatus = pActivo
ORDER BY Nombre ASC;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `obtCP`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCP`(
  IN `pCP` VARCHAR(512)
)
BEGIN
  SELECT
    col.Clave_Colonia
    , CONCAT(col.Clave_Estado,'|',est.Nombre) as Clave_Estado
    , CONCAT(col.Clave_Ciudad,'|',ciu.Nombre) as Clave_Ciudad
    , col.Nombre
    , col.CodigoPostal
  FROM 
    colonia col inner join estado est on col.Clave_Estado = est.Clave_Estado
		inner join ciudad ciu on (col.Clave_Ciudad = ciu.Clave_Ciudad 
			and col.Clave_Estado = ciu.Clave_Estado )
  WHERE
    col.CodigoPostal = pCP AND col.Estatus = 1;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `InsCliente`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCliente`(
  IN `pIdEmpresa` INT, 
  IN `pRFC` VARCHAR(13), 
  IN `pRazonSocial` VARCHAR(96), 
  IN `pNombreComercial` VARCHAR(64), 
  IN `pDireccion` VARCHAR(250), 
  IN `pContacto_Nombre` VARCHAR(64), 
  IN `pContacto_Email` VARCHAR(64), 
  IN `pContacto_Telefono` VARCHAR(32), 
  IN `pComentarios` VARCHAR(128), 
  IN `pEstatus` TINYINT(1), 
  IN `pIdUsuarioLog` INT,
  IN `pEmpresaCorreo` VARCHAR(64), 
  IN `pEmpresaTelefono` VARCHAR(64), 
  IN `pClaveColonia` VARCHAR(10), 
  IN `pCP` VARCHAR(10)
  ) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER 
  BEGIN
    DECLARE pIdCliente INT;
    
 	IF (SELECT COUNT(1)
 		from cliente 
 		where	RFC = pRFC 
                AND IdEmpresa = pIdEmpresa) != 0 THEN
		SELECT 'Error al insertar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
	ELSE
	
	INSERT INTO cliente
	(
		IdEmpresa,
		RFC,
		RazonSocial,
		NombreComercial,
        Clave_Colonia,
        CP,
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
		FechaModificacion
	)
	VALUES
	(
		pIdEmpresa,
		pRFC,
		pRazonSocial,
		pNombreComercial,
        pClaveColonia,
        pCP,
		pDireccion,
        pEmpresaCorreo,
        pEmpresaTelefono,
		pContacto_Nombre,
		pContacto_Email,
		pContacto_Telefono,
		pComentarios,
		pEstatus,
		pIdUsuarioLog,
		now(),
		pIdUsuarioLog,
		now()
	);
        
	set pIdCliente = (SELECT MAX(IdCliente) from cliente);
        SELECT null as ErrorMessage, pIdCliente as IdCliente;
        
	END IF;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `ActCliente`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCliente`(
  IN `pIdCliente` INT, 
  IN `pIdEmpresa` INT, 
  IN `pRFC` VARCHAR(13), 
  IN `pRazonSocial` VARCHAR(96), 
  IN `pNombreComercial` VARCHAR(64), 
  IN `pDireccion` VARCHAR(250), 
  IN `pContacto_Nombre` VARCHAR(64), 
  IN `pContacto_Email` VARCHAR(64), 
  IN `pContacto_Telefono` VARCHAR(32), 
  IN `pComentarios` VARCHAR(128), 
  IN `pEstatus` TINYINT(1), 
  IN `pIdUsuarioLog` INT, 
  IN `pEmpresaCorreo` VARCHAR(64), 
  IN `pEmpresaTelefono` VARCHAR(64), 
  IN `pClaveColonia` VARCHAR(10), 
  IN `pCP` VARCHAR(10)
  ) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER 
BEGIN
	IF (SELECT COUNT(1)
 		from cliente 
 		where	RFC = pRFC 
				and IdCliente != pIdCliente
 				and Estatus = 1
                AND IdEmpresa = pIdEmpresa) != 0 THEN
		SELECT 'Error al actualizar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
 	ELSE
		UPDATE cliente
		SET
			RFC = pRFC,
			RazonSocial = pRazonSocial,
			NombreComercial = pNombreComercial,
            Clave_Colonia = pClaveColonia,
            CP = pCP,
			Direccion = pDireccion,
            EmpresaCorreo = pEmpresaCorreo,
            EmpresaTelefono = pEmpresaTelefono,
            Contacto_Nombre = pContacto_Nombre,
			Contacto_Email = pContacto_Email,
			Contacto_Telefono = pContacto_Telefono,
			Comentarios = pComentarios,
			Estatus = pEstatus,
			IdUsuarioUltimoModifico = pIdUsuarioLog,
			FechaModificacion = now()
		WHERE IdCliente = pIdCliente
			  and IdEmpresa = pIdEmpresa;
        
        SELECT null as ErrorMessage;
        
	END IF;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `ObtClientes`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClientes`(
  IN `pRazonSocial` VARCHAR(96), 
  IN `pEstatus` TINYINT, 
  IN `pIdEmpresa` INT
)
BEGIN
	Declare pDesde tinyint;
	Declare pHasta tinyint;	
        
	if(pEstatus = -1) then
		SET pDesde = 0;
		SET pHasta = 1;
	else
		SET pDesde = pEstatus;
		SET pHasta = pEstatus;
	end if;
	
	SELECT
	   cliente.IdCliente,
	   cliente.IdEmpresa,
	   cliente.RFC,
	   cliente.RazonSocial,
	   cliente.NombreComercial,
	   cliente.Clave_Colonia,
	   cliente.CP,
	   cliente.Direccion,
       cliente.EmpresaCorreo,
       cliente.EmpresaTelefono,
	   cliente.Contacto_Nombre,
	   cliente.Contacto_Email,
	   cliente.Contacto_Telefono,
	   cliente.Comentarios,
	   cliente.Estatus,
	   colonia.Nombre as NombreColonia
	FROM cliente left join colonia on 
		( cliente.Clave_Colonia = colonia.Clave_colonia
			AND cliente.CP = Colonia.CodigoPostal
		)
	WHERE ( 
	      ( cliente.RazonSocial like concat('%', IFNULL(pRazonSocial, ''), '%')) 
          OR (cliente.NombreComercial like concat('%', IFNULL(pRazonSocial, ''), '%')) 
          OR (cliente.RFC like concat('%', IFNULL(pRazonSocial, ''), '%')) 
          )
		AND cliente.Estatus between pDesde and pHasta
		AND cliente.IdEmpresa = pIdEmpresa;
END$$
DELIMITER ;




DROP PROCEDURE IF EXISTS `InsProspecto`;

DELIMITER $$
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
  IN `pComentario` VARCHAR(250)
) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN 
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
	  pIdEmpresa
      );
      
      set pIdProspecto = (SELECT MAX(IdProspecto) from prospecto);
      SELECT null as ErrorMessage, pIdProspecto as IdProspecto;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `ActProspecto`;

DELIMITER $$
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
  IN `pComentario` VARCHAR(250) 
) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER 
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
	  Comentario = pComentario
	WHERE IdProspecto = pIdProspecto
		  and IdEmpresa = pIdEmpresa;
        
        SELECT null as ErrorMessage;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `ObtProspectos`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectos`(
  IN `pNombre` VARCHAR(100), 
  IN `pActivo` INT, 
  IN `pIdEmpresa` INT
) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER 
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
	   colonia.Nombre as NombreColonia
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

 INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (23,'Reclutamiento023AG','Alejandro Gutiérrez',now() ,'Cambios Clientes, Prospecto, Codigos Postales');