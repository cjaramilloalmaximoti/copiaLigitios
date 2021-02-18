delete from TipoCatalogo;

INSERT INTO `tipocatalogo`(`IdEmpresa`, `Nombre`, `NombreSingular`, `TipoSubCatalogo`, `IdTipoCatalogo_SubCatalogo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Visible`) 
VALUES (1,'Estado Civil','Estado Civil',0,16,1,'20180226',1,'20180226',1);

INSERT INTO `tipocatalogo`(`IdEmpresa`, `Nombre`, `NombreSingular`, `TipoSubCatalogo`, `IdTipoCatalogo_SubCatalogo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Visible`) 
VALUES (1,'Generos','Generos',0,16,1,'20180226',1,'20180226',1);

INSERT INTO `tipocatalogo`(`IdEmpresa`, `Nombre`, `NombreSingular`, `TipoSubCatalogo`, `IdTipoCatalogo_SubCatalogo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Visible`) 
VALUES (1,'Escolaridad','Escolaridad',0,16,1,'20180226',1,'20180226',1);

INSERT INTO `tipocatalogo`(`IdEmpresa`, `Nombre`, `NombreSingular`, `TipoSubCatalogo`, `IdTipoCatalogo_SubCatalogo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Visible`) 
VALUES (1,'Documentos','Documentos',0,16,1,'20180226',1,'20180226',1);

ALTER TABLE `registroscript` ADD `DescripcionScript` VARCHAR(255) NOT NULL AFTER `Fecha`;
ALTER TABLE `cliente` CHANGE `Empresa_Correo` `EmpresaCorreo` VARCHAR(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, CHANGE `Empresa_Telefono` `EmpresaTelefono` VARCHAR(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL; 
ALTER TABLE `cliente` CHANGE `EmpresaCorreo` `EmpresaCorreo` VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, CHANGE `EmpresaTelefono` `EmpresaTelefono` VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL; 

DROP PROCEDURE insCliente;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCliente`(IN `pIdEmpresa` INT, IN `pRFC` VARCHAR(13), IN `pRazonSocial` VARCHAR(96), IN `pNombreComercial` VARCHAR(64), IN `pDireccion` VARCHAR(250), IN `pContacto_Nombre` VARCHAR(64), IN `pContacto_Email` VARCHAR(64), IN `pContacto_Telefono` VARCHAR(32), IN `pComentarios` VARCHAR(128), IN `pActivo` TINYINT(1), IN `pIdUsuarioLog` INT, IN `pEmpresaCorreo` VARCHAR(64), IN `pEmpresaTelefono` VARCHAR(64))
BEGIN
    DECLARE pIdCliente INT;
    
 	IF (SELECT COUNT(1)
 		from cliente 
 		where	RFC = pRFC 
 				and Activo = 1
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
		Activo,
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

DROP PROCEDURE `ObtClientes`; 

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClientes`(IN `pRazonSocial` VARCHAR(96), IN `pActivo` TINYINT, IN `pIdEmpresa` INT)
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
	   Activo
	FROM cliente
	where RazonSocial like concat('%', IFNULL(pRazonSocial, ''), '%')
			and Activo between pDesde and pHasta
			AND IdEmpresa = pIdEmpresa;

END$$
DELIMITER ;

DROP PROCEDURE `ActCartera`; 
DROP PROCEDURE `ActDeudorAsignacion`; 
DROP PROCEDURE `ActEmpresa`; 
DROP PROCEDURE `ActSegmento`; 
DROP PROCEDURE `EliColumnaSegmento`; 
DROP PROCEDURE `EliErrorImportarDeudores`; 
DROP PROCEDURE `Eli_DetalleCartera`; 
DROP PROCEDURE `InsAcuerdoPago`; 
DROP PROCEDURE `InsAgendarLlamadaDeudor`; 
DROP PROCEDURE `InsCartera`; 
DROP PROCEDURE `InsColumnaSegmento`; 
DROP PROCEDURE `InsContactoDeudor`; 
DROP PROCEDURE `InsDeudor`; 
DROP PROCEDURE `InsDeudorDetalleError`; 
DROP PROCEDURE `InsMapeoSegmento`; 
DROP PROCEDURE `InsPagoComprobado`; 
DROP PROCEDURE `InsSegmento`; 
DROP PROCEDURE `InsSeguimientoDeudor`; 
DROP PROCEDURE `ObtCarteras`; 
DROP PROCEDURE `ObtClientesCartera`; 
DROP PROCEDURE `ObtClientesCarteraTodos`; 
DROP PROCEDURE `ObtClientesCarteras`;
DROP PROCEDURE `ObtColumnasSegmento`; 
DROP PROCEDURE `ObtConfiguracionReportes`; 
DROP PROCEDURE `ObtContactoDeudor`; 
DROP PROCEDURE `ObtDeudores`; 
DROP PROCEDURE `ObtDeudoresAnalista`; 
DROP PROCEDURE `ObtDeudoresAnalistaSeguimiento`; 
DROP PROCEDURE `ObtErrorImportarDeudores`; 
DROP PROCEDURE `ObtEstatusCartera`; 
DROP PROCEDURE `ObtEstatusNoSeguimiento`; 
DROP PROCEDURE `ObtMapeoColumnasSegmento`; 
DROP PROCEDURE `ObtMapeoSegmento`; 
DROP PROCEDURE `ObtRepResumen`; 
DROP PROCEDURE `ObtRepSabana`; 
DROP PROCEDURE `ObtSegmentos`; 
DROP PROCEDURE `ObtSegmentosBuscar`; 
DROP PROCEDURE `ObtSegmentosPorAnalista`; 
DROP PROCEDURE `ObtSeguimientoDeudor`; 

INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (1,'Reclutamiento001AG','Alejandro Gutiérrez','20180226','alta lista catalogos agregar campo descripcion a -registroScript-');

