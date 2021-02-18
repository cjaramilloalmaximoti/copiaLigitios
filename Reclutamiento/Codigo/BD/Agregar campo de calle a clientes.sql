select * from cliente;
alter table cliente add Calle varchar (100) not null;
USE `directma_reclutamiento`;
DROP procedure IF EXISTS `InsCliente`;

DELIMITER $$
USE `directma_reclutamiento`$$
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
IN `pCP` VARCHAR(10), 
IN `pCalle` VARCHAR(100))
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
		FechaModificacion,
        calle
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
		now(),
        pCalle
	);
        
	set pIdCliente = (SELECT MAX(IdCliente) from cliente);
        SELECT null as ErrorMessage, pIdCliente as IdCliente;
        
	END IF;
END$$

DELIMITER ;

USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ObtClientes`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClientes`(IN `pRazonSocial` VARCHAR(96), IN `pEstatus` TINYINT, IN `pIdEmpresa` INT)
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
       cliente.Calle,
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

USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ObtClienteId`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClienteId`(IN `pIdCliente` INT)
BEGIN
	SELECT
	   IdCliente,
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
       Calle
	FROM cliente
	where 
		IdCliente = pIdCliente;
END$$

DELIMITER ;
USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ActCliente`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCliente`(
IN `pIdCliente` INT, 
IN `pIdEmpresa` INT, 
IN `pRFC` VARCHAR(13), IN `pRazonSocial` VARCHAR(96), 
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
IN `pCP` VARCHAR(10),
IN `pCalle` VARCHAR(100)
)
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
			FechaModificacion = now(),
            Calle = pCalle
		WHERE IdCliente = pIdCliente
			  and IdEmpresa = pIdEmpresa;
        
        SELECT null as ErrorMessage;
        
	END IF;
END;
DELIMITER;