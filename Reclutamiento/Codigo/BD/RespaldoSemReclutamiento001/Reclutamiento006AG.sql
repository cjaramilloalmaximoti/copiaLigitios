ALTER TABLE `prospecto` CHANGE `Estatus` `Estatus` TINYINT(1) NULL DEFAULT '1';

DROP PROCEDURE IF EXISTS `ObtProspectos`; 
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectos`(IN `pNombre` VARCHAR(100), IN `pActivo` INT, IN `pIdEmpresa` INT) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN Declare pDesde tinyint; Declare pHasta tinyint; if(pActivo = -1) then SET pDesde = 0; SET pHasta = 1; else SET pDesde = pActivo; SET pHasta = pActivo; end if; SELECT IdProspecto, Nombre, Apellidos, FechaNacimiento, RFC, Email, TelefonoMovil, TelefonoOtro, Direccion, CV, Foto, Salario, IdSexo, IdCiudad, IdEstadoCivil, IdProfesion, Activo FROM prospecto where Nombre like concat('%', IFNULL(pNombre, ''), '%') and Apellido like concat('%', IFNULL(pNombre, ''), '%') and Activo between pDesde and pHasta AND IdEmpresa = pIdEmpresa; 
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
	IdTipoCatalogo = (Select IdTipoCatalogo From TipoCatalogo Where Nombre = pNombreCatalogo)
	AND IdEmpresa = pIdEmpresa;

END$$
DELIMITER ;

INSERT INTO `tipocatalogo`
(`IdEmpresa`, `IdTipoCatalogo`, `Nombre`, `NombreSingular`, `TipoSubCatalogo`, `IdTipoCatalogo_SubCatalogo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Visible`) 
VALUES 
(1,5,'Tipo Contrato','Tipo Contrato',0,16,1,now(),1,now(),1),
(1,6,'Tipo Jornada','Tipo Jornada',0,16,1,now(),1,now(),1),
(1,7,'Tipo Fase','Tipo Fase',0,16,1,now(),1,now(),1);

DROP PROCEDURE IF EXISTS `ObtProspectos`; 
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectos`(
  IN `pNombre` VARCHAR(100),
  IN `pActivo` INT,
  IN `pIdEmpresa` INT
)
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
	   IdProspecto,
	   Nombre,
	   Apellidos,
	   FechaNacimiento,
	   RFC,
	   Email,
           TelefonoMovil,
	   TelefonoOtro,
	   Direccion,
	   CV,
	   Foto,
	   Salario,
	   IdSexo,
	   IdCiudad,
	   IdEstadoCivil,
	   IdProfesion,   
	   Estatus
	FROM prospecto
	where Nombre like concat('%', IFNULL(pNombre, ''), '%')
			and Apellidos like concat('%', IFNULL(pNombre, ''), '%')
			and Estatus between pDesde and pHasta
			AND IdEmpresa = pIdEmpresa;

END$$
DELIMITER ;

INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (6,'Reclutamiento006AG','Alejandro Gutiérrez','20180228','Alta de Tipos Catalogos, Procedimiento ObtProspectos');
