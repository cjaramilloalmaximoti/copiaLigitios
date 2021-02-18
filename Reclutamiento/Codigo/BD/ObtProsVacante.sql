USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ObtProsVacante`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProsVacante`(IN `pIdVacante` INT, IN `pIdEmpresa` INT)
BEGIN

	

	SELECT

	   p.IdProspecto as IdProspecto,

	   CONCAT(p.Nombre,' ', p.Apellidos) as NombreCompleto,

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

	   p.SalarioFinal as SalarioFinal,

	   p.IdSexo as IdSexo, 

           cSexo.Nombre as NombreSexo,

	   p.IdEstadoCivil as IdEstadoCivil,

           cEC.Nombre as NombreEstadoCivil,

	   p.IdEscolaridad as IdEscolaridad,   

           cEsco.Nombre as NombreEscolaridad,

	   p.Estatus as Estatus,

	   p.Comentario,

       p.NivelIngles,

	   colonia.Nombre as NombreColonia,

	   (Select MAX(bitacora.FechaCreacion) FROM bitacora WHERE bitacora.IdProspecto = p.IdProspecto) as FechaContacto,

       p.foto,
	   vp.Finalista,
	   vp.Invitaciones

	FROM prospecto p 
    inner JOIN vacante_prospecto vp on p.IdProspecto = vp.IdProspecto
    left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo

    left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo

    left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo

	left join colonia on (p.Clave_Colonia = colonia.Clave_colonia

			AND p.CP = Colonia.CodigoPostal 

	)

	where vp.Estatus > 0 and vp.IdVacante = pIdVacante

		AND p.IdEmpresa = pIdEmpresa;

END$$

DELIMITER ;

