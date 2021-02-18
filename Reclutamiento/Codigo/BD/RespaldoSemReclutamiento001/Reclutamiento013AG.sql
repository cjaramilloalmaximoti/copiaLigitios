ALTER TABLE `empresa` CHANGE `Contraseña` `Contrasenia` VARCHAR(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL; 

DROP PROCEDURE IF EXISTS `ObtEmpresas`;
DELIMITER $$
 CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtEmpresas`() NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN SELECT IdEmpresa, Dominio, ProductKey, Administrador, Contrasenia, NombreComercial, RutaLogo FROM empresa; 
END$$
DELIMITER ;

ALTER TABLE `cliente` CHANGE `Activo` `Estatus` TINYINT(1) NOT NULL DEFAULT '1';

DROP TABLE IF EXISTS `clientedocumentos`;

CREATE TABLE IF NOT EXISTS `clientedocumentos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IdCliente` int(11) NOT NULL,
  `IdDocumento` int(11) NOT NULL,
  `Nombre` varchar(150) NOT NULL,
  `Url` varchar(150) NOT NULL,
  `Estatus` tinyint(4) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL,
  `IdUsuarioModificacion` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL,
  `Idempresa` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `prospectodocumentos`;

CREATE TABLE IF NOT EXISTS `prospectodocumentos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IdProspecto` int(11) NOT NULL,
  `IdDocumento` int(11) NOT NULL,
  `Nombre` varchar(150) NOT NULL,
  `Url` varchar(150) NOT NULL,
  `Estatus` tinyint(4) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL,
  `IdUsuarioModificacion` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL,
  `Idempresa` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



set @forma = 'Prospecto';
set @formaLink = 'Prospectos';
set @formaAccion = 'Prospecto_Index';
set @formaControlador = 'Configuracion';
set @id_forma = (select idForma from Forma Where (ClaveCodigo = @forma));

delete from formapermiso where idForma = @id_forma;
delete from formaRol where idForma = @id_forma;
delete from forma where idforma = @id_forma;

insert into Forma(ClaveCodigo, Nombre, EsOpcionMenu, Estatus, IdFormaPadre, TextoLink, Accion, Controlador
	, EsDropdown, Orden, IdUsuarioCreacion,FechaCreacion, IdUsuarioUltimoModifico,FechaModificacion
	, OrigenOperacion, Descripcion, IdEmpresa, EsSuperAdministrador
)
values(
	@forma
	, @forma
	, 1, 1
	, 2
	, @formaLink
	, @formaAccion
	, @formaControlador
	, 0, 4, 1, now(), 1, now(), 1, '(Administracion) Forma correspondiente a Vacantes', 1, 0
	);

SET @id_forma = (select idForma from Forma where (ClaveCodigo='Prospecto'));

insert into FormaRol(
  IdForma, IdRol, Privilegios, IdUsuarioCreacion, FechaCreacion, IdUsuarioUltimoModifico, 
  FechaModificacion, OrigenOperacion, IdEmpresa 
)
values( @id_forma, 2, 15, 1, now(), 1, now(), 1 , 1);

insert into FormaPermiso( 
  IdForma , IdPermiso, IdUsuarioCreacion, FechaCreacion, IdUsuarioUltimoModifico, FechaModificacion, OrigenOperacion, 
  IdEmpresa, NombrePermiso
)
values
( @id_forma, 1, 1, now(), 1,now(), 1, 1, 'Consultar' ),
( @id_forma, 1, 2, now(), 1,now(), 1, 1, 'Agregar' ),
( @id_forma, 1, 3, now(), 1,now(), 1, 1, 'Actualizar' ),
( @id_forma, 1, 4, now(), 1,now(), 1, 1, 'Eliminar' );



set @forma = 'Vacante';
set @formaLink = 'Vacantes';
set @formaAccion = 'Vacante_Index';
set @formaControlador = 'Configuracion';
set @id_forma = (select idForma from Forma Where (ClaveCodigo = @forma));


delete from formapermiso where idForma = @id_forma;
delete from formaRol where idForma = @id_forma;
delete from forma where idforma = @id_forma;


insert into Forma(ClaveCodigo, Nombre, EsOpcionMenu, Estatus, IdFormaPadre, TextoLink, Accion, Controlador
	, EsDropdown, Orden, IdUsuarioCreacion,FechaCreacion, IdUsuarioUltimoModifico,FechaModificacion
	, OrigenOperacion, Descripcion, IdEmpresa, EsSuperAdministrador
)
values(
	@forma
	, @forma
	, 1, 1
	, 2
	, @formaLink
	, @formaAccion
	, @formaControlador
	, 0, 4, 1, now(), 1, now(), 1, '(Administracion) Forma correspondiente a Vacantes', 1, 0
	);

SET @id_forma = (select idForma from Forma where(ClaveCodigo='Prospecto'));

insert into FormaRol(
  IdForma, IdRol, Privilegios, IdUsuarioCreacion, FechaCreacion, IdUsuarioUltimoModifico, 
  FechaModificacion, OrigenOperacion, IdEmpresa 
)
values( @id_forma, 2, 15, 1, now(), 1, now(), 1 , 1);

insert into FormaPermiso( 
  IdForma , IdPermiso, IdUsuarioCreacion, FechaCreacion, IdUsuarioUltimoModifico, FechaModificacion, OrigenOperacion, 
  IdEmpresa, NombrePermiso
)
values
( @id_forma, 1, 1, now(), 1,now(), 1, 1, 'Consultar' ),
( @id_forma, 1, 2, now(), 1,now(), 1, 1, 'Agregar' ),
( @id_forma, 1, 3, now(), 1,now(), 1, 1, 'Actualizar' ),
( @id_forma, 1, 4, now(), 1,now(), 1, 1, 'Eliminar' );



DROP PROCEDURE IF EXISTS `InsDocsCliente`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsDocsCliente`(
  IN `pIdCliente` INT, 
  IN `pIdDocumento` INT, 
  IN `pNombre` VARCHAR(150), 
  IN `pUrl` VARCHAR(250),
  IN `pEstatus` TINYINT,
  IN `pIdUsuarioLog` INT,
  IN `pIdEmpresa` INT 
) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER 
BEGIN 
  DECLARE pId INT; 

  INSERT INTO clientedocumentos ( 
    IdCliente, IdDocumento, Nombre, Url, Estatus, IdUsuarioCreacion, FechaCreacion,
    IdUsuarioModificacion, FechaModificacion, IdEmpresa
  ) VALUES ( 
    pIdCliente, pIdDocumento, pNombre, pUrl, pEstatus, PIdUsuarioLog, now(), 
    pIdUsuarioLog, now(), pIdEmpresa
  ); 

  set pId = 1; 
  SELECT null as ErrorMessage, pIdDocumento as Id; 
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `ObtDocsCliente`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDocsCliente`(
  IN `pIdCliente` INT, 
  IN `pIdEmpresa` INT
)
BEGIN	
	SELECT
	   c.IdCliente as IdCliente,
	   c.IdDocumento as IdDocumento,
	   c.Nombre as Nombre,
	   c.Url as Url,
	   c.IdEmpresa as Idempresa,
	   cat.Nombre as DescDocumento,
	   c.Id
	FROM clientedocumentos c, catalogo cat
	where (c.IdDocumento = cat.IdCatalogo) 
	  AND
	  c.IdCliente = pIdCliente AND c.IdEmpresa = pIdEmpresa;

END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `EliDocsCliente`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliDocsCliente`(
  IN `pId` INT
)
BEGIN	
	declare pIdCD INT;
    
	DELETE FROM clientedocumentos
	WHERE ( Id = pId ) ;
	
    set pIdCD = 1;
    SELECT null as ErrorMessage;
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
) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER 
BEGIN
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


DROP PROCEDURE IF EXISTS `ActCliente`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCliente`(IN `pIdCliente` INT, IN `pIdEmpresa` INT, IN `pRFC` VARCHAR(13), IN `pRazonSocial` VARCHAR(96), IN `pNombreComercial` VARCHAR(64), IN `pDireccion` VARCHAR(250), IN `pContacto_Nombre` VARCHAR(64), IN `pContacto_Email` VARCHAR(64), IN `pContacto_Telefono` VARCHAR(32), IN `pComentarios` VARCHAR(128), IN `pEstatus` TINYINT(1), IN `pIdUsuarioLog` INT, IN `pEmpresaCorreo` VARCHAR(64), IN `pEmpresaTelefono` VARCHAR(64)) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN

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
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClientes`(IN `pRazonSocial` VARCHAR(96), IN `pEstatus` TINYINT, IN `pIdEmpresa` INT) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN

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
	   Estatus
	FROM cliente
	where RazonSocial like concat('%', IFNULL(pRazonSocial, ''), '%')
			and Estatus between pDesde and pHasta
			AND IdEmpresa = pIdEmpresa;

END$$
DELIMITER ;




DROP PROCEDURE IF EXISTS `InsDocsProspecto`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsDocsProspecto`(
  IN `pIdProspecto` INT, 
  IN `pIdDocumento` INT, 
  IN `pNombre` VARCHAR(150), 
  IN `pUrl` VARCHAR(250),
  IN `pEstatus` TINYINT,
  IN `pIdUsuarioLog` INT,
  IN `pIdEmpresa` INT 
) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER 
BEGIN 
  DECLARE pId INT; 

  INSERT INTO prospectodocumentos ( 
    IdProspecto, IdDocumento, Nombre, Url, Estatus, IdUsuarioCreacion, FechaCreacion,
    IdUsuarioModificacion, FechaModificacion, IdEmpresa
  ) VALUES ( 
    pIdProspecto, pIdDocumento, pNombre, pUrl, pEstatus, PIdUsuarioLog, now(), 
    pIdUsuarioLog, now(), pIdEmpresa
  ); 

  set pId = 1; 
  SELECT null as ErrorMessage, pIdDocumento as Id; 
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `ObtDocsProspecto`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDocsProspecto`(
  IN `pIdProspecto` INT, 
  IN `pIdEmpresa` INT
)
BEGIN	
	SELECT
	   p.IdProspecto as IdProspecto,
	   p.IdDocumento as IdDocumento,
	   p.Nombre as Nombre,
	   p.Url as Url,
	   p.IdEmpresa as Idempresa,
	   cat.Nombre as DescDocumento,
	   p.Id
	FROM prospectodocumentos p, catalogo cat
	where (p.IdDocumento = cat.IdCatalogo) 
	  AND
	  p.IdProspecto = pIdProspecto AND p.IdEmpresa = pIdEmpresa;

END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `EliDocsProspecto`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliDocsProspecto`(
  IN `pId` INT
)
BEGIN	
	declare pIdCD INT;
    
	DELETE FROM prospectodocumentos
	WHERE ( Id = pId ) ;
	
    set pIdCD = 1;
    SELECT null as ErrorMessage;
END$$
DELIMITER ;



DROP PROCEDURE IF EXISTS `ActEmpresa`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActEmpresa`(`pIdEmpresa` INT(11), `pDominio` VARCHAR(64), `pProductKey` VARCHAR(256), `pAdministrador` VARCHAR(30), `pContraseña` VARCHAR(250), `pNombreComercial` VARCHAR(100), `pRutaLogo` VARCHAR(200))
BEGIN

	UPDATE empresa
	SET
		Dominio = pDominio,
		ProductKey = pProductKey,
		Administrador = pAdministrador,
		Contraseña = pContraseña,
        NombreComercial = pNombreComercial,
        RutaLogo = pRutaLogo
	WHERE IdEmpresa = pIdEmpresa;


END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `ActParametroEmpresa`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActParametroEmpresa`(`pIdParametro` SMALLINT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(10000), `pValor` VARCHAR(10000), `pEsActivo` BIT, `pEsSensitivo` BIT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT)
BEGIN

	UPDATE parametroempresa
	   SET Nombre = pNombre
		  ,Descripcion = pDescripcion
		  ,Valor = pValor
		  ,EsActivo = pEsActivo
		  ,EsSensitivo = pEsSensitivo
		  ,FechaModificacion = now()
		  ,IdUsuarioUltimoModifico = pIdUsuarioLog
		  ,OrigenOperacion = pOrigenOperacion
	 WHERE IdParametro = pIdParametro;

END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `ObtEmpresas`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtEmpresas`()
BEGIN
	SELECT 
		IdEmpresa,
        Dominio,
        ProductKey,
        Administrador,
        Contraseña,
        NombreComercial,
        RutaLogo
    FROM empresa;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `ObtParametrosEmpresa`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtParametrosEmpresa`(`pNombre` VARCHAR(64), `pDescripcion` VARCHAR(64))
BEGIN

	SELECT IdParametro, Nombre, Descripcion, Valor, EsActivo, EsSensitivo
 	FROM parametroempresa
 	WHERE 
		Nombre LIKE CONCAT('%', pNombre, '%')
        AND Descripcion LIKE CONCAT('%', pDescripcion, '%');

END$$
DELIMITER ;


set @forma = 'CodigoPostal';
set @formaLink = 'CodigoPostal';
set @formaAccion = 'CodigoPostal_Index';
set @formaControlador = 'Configuracion';
set @id = (select idForma from Forma Where ClaveCodigo = @forma);

delete from formapermiso where idForma = @id;
delete from formaRol where idForma = @id;
delete from forma where idforma = @id;

insert into Forma(ClaveCodigo, Nombre, EsOpcionMenu, Estatus, IdFormaPadre, TextoLink, Accion, Controlador
	, EsDropdown, Orden, IdUsuarioCreacion,FechaCreacion, IdUsuarioUltimoModifico,FechaModificacion
	, OrigenOperacion, Descripcion, IdEmpresa, EsSuperAdministrador
)
values(
	@forma
	, @forma
	, 1, 1
	, 2
	, @formaLink
	, @formaAccion
	, @formaControlador
	, 0, 4, 1, now(), 1, now(), 1, '(Administracion) Forma correspondiente a Vacantes', 1, 0
	);

SET @id_forma = (select idForma from Forma where ClaveCodigo = @forma);

insert into FormaRol(
  IdForma, IdRol, Privilegios, IdUsuarioCreacion, FechaCreacion, IdUsuarioUltimoModifico, 
  FechaModificacion, OrigenOperacion, IdEmpresa 
)
values( @id_forma, 2, 15, 1, now(), 1, now(), 1 , 1);

insert into FormaPermiso( 
  IdForma , IdPermiso, IdUsuarioCreacion, FechaCreacion, IdUsuarioUltimoModifico, FechaModificacion, OrigenOperacion, 
  IdEmpresa, NombrePermiso
)
values
( @id_forma, 1, 0, now(), 0,now(), 1, 1, 'Consultar' ),
( @id_forma, 2, 0, now(), 0,now(), 1, 1, 'Agregar' ),
( @id_forma, 3, 0, now(), 0,now(), 1, 1, 'Actualizar' ),
( @id_forma, 4, 0, now(), 0,now(), 1, 1, 'Eliminar' );



DROP PROCEDURE IF EXISTS `ObtUsuarioValidar`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuarioValidar`(
  IN `pIdEmpresa` INT(11), 
  IN `pLogin` VARCHAR(50), 
  IN `pContrasenia` VARCHAR(100)
) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN
    DECLARE pCeroEntero INT(11);
    DECLARE pTrue tinyint(1);    
    DECLARE pFalse tinyint(1);
    
    SET pCeroEntero = 0;
    SET pTrue = 1;
    SET pFalse = 0;

	if exists ( select 1 
	            from empresa 
                    where 
			IdEmpresa = pIdEmpresa 
                        and Administrador = pLogin
                        and Contrasenia    = pContrasenia) then		
		select
			pCeroEntero as IdUsuario,
            IdEmpresa,
            Administrador as Login,
            Administrador as NombreCompleto,
            concat(Administrador, dominio) as CorreoElectronico,
            pTrue as Activo,
            pFalse as EsSuperAdministrador,
            pTrue as EsAdministrador
		from empresa 
        where 
	    IdEmpresa = pIdEmpresa 
            and Administrador = pLogin
            and Contrasenia    = pContrasenia;
	ELSE
		SELECT 
 		  usu.IdUsuario
          ,usu.IdEmpresa
 		  , usu.Login
 		  , usu.Activo
 		  , usu.CodigoRecuperaContrasenia
 		  , usu.UsuarioId
 		  , usu.NombreCompleto
 		  , usu.CorreoElectronico
          , pFalse as EsSuperAdministrador
          , pFalse as EsAdministrador
 		FROM Usuario usu
 		WHERE	usu.IdEmpresa 	= pIdEmpresa
				AND usu.Login	= pLogin
 				AND Contrasenia = pContrasenia
 				AND Activo		= 1;
	END IF;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `ActEmpresa`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActEmpresa`(IN `pIdEmpresa` INT(11), IN `pDominio` VARCHAR(64), IN `pProductKey` VARCHAR(256), IN `pAdministrador` VARCHAR(30), IN `pContrasenia` VARCHAR(250), IN `pNombreComercial` VARCHAR(100), IN `pRutaLogo` VARCHAR(200)) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN

	UPDATE empresa
	SET
		Dominio = pDominio,
		ProductKey = pProductKey,
		Administrador = pAdministrador,
		Contrasenia = pContrasenia,
        NombreComercial = pNombreComercial,
        RutaLogo = pRutaLogo
	WHERE IdEmpresa = pIdEmpresa;
END$$
DELIMITER ;


INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (13,'Reclutamiento013AG','Alejandro Gutiérrez','20180109','');



