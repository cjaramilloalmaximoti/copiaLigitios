DROP PROCEDURE IF EXISTS `obtEstados`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtEstados`(
  IN `pClavePais` VARCHAR(512),
  IN `pActivo` INT
)
BEGIN
SELECT Clave_Estado
      ,Nombre
FROM estado
WHERE Clave_Pais = pClavePais
	AND Estatus = pActivo
ORDER BY Nombre ASC;
END$$
DELIMITER ;



DROP PROCEDURE IF EXISTS `obtCiudades`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCiudades`(
  IN `pClaveEstado` VARCHAR(512),
  IN `pNombre` VARCHAR(512),
  IN `pActivo` INT
)
BEGIN
SELECT Clave_Ciudad
      ,Nombre
FROM ciudad
WHERE Nombre like concat('%', IFNULL(pNombre, ''), '%') 
	AND Clave_Estado = pClaveEstado
	AND Estatus = pActivo
ORDER BY Nombre ASC;
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
  IN `pEmpresaTelefono` VARCHAR(64)
)
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


INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (16,'Reclutamiento016AG','Alejandro Gutiérrez','20180313','Procedimiento ObtEstados, Ciudades, Modificar InsCLientes');
