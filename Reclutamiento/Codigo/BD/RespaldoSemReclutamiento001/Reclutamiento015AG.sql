DROP PROCEDURE IF EXISTS `ObtProspectos`;

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
	where (p.Nombre like concat('%', IFNULL(pNombre, ''), '%')
		OR p.Apellidos like concat('%', IFNULL(pNombre, ''), '%'))
		AND p.Estatus between pDesde and pHasta
		AND p.IdEmpresa = pIdEmpresa;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `ObtProspectoId`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectoId`(
  IN `pIdProspecto` INT
)
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
	   p.Estatus as Estatus
	FROM prospecto p left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
    	  left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
          left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo
	where 
		p.IdProspecto = pIdProspecto;

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `ObtClienteId`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClienteId`(
  IN `pIdCliente` INT
)
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
	   Estatus
	FROM cliente
	where 
		IdCliente = pIdCliente;

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `ObtDetallesCatalogo`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDetallesCatalogo`(
  IN `pNombreCatalogo` VARCHAR(100),
  IN `pIdEmpresa` INT
)
BEGIN
SELECT 
	*
FROM 
	catalogo

WHERE 
	IdTipoCatalogo = (Select IdTipoCatalogo From TipoCatalogo Where NombreSingular = pNombreCatalogo)
	AND IdEmpresa = pIdEmpresa AND EsActivo = 1;
END$$
DELIMITER ;


INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (15,'Reclutamiento015AG','Alejandro Gutiérrez','20180312','');
