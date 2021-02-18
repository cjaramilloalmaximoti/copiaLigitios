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
	   p.SalarioFinal as SalarioFinal,
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

