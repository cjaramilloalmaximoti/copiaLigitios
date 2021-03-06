DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectoPorCliente`(IN `pCliente` INT)
BEGIN
SELECT 
			p.IdProspecto AS IdProspecto,
			CONCAT(p.Nombre,' ', p.Apellidos) AS NombreCompleto,
			p.Nombre AS Nombre,
			p.Apellidos AS Apellidos,
			p.FechaNacimiento AS FechaNacimiento,
			p.RFC AS RFC,
			p.Email AS Email,
			p.TelefonoMovil AS TelefonoMovil,
			p.TelefonoOtro AS TelefonoOtro,
			p.Clave_Colonia AS Clave_Colonia,
			p.CP AS CP,
			p.Direccion AS Direccion,
			p.Salario AS Salario,
			p.IdSexo AS IdSexo, 
			cSexo.Nombre AS NombreSexo,
			p.IdEstadoCivil AS IdEstadoCivil,
			cEC.Nombre AS NombreEstadoCivil,
			p.IdEscolaridad AS IdEscolaridad,   
			cEsco.Nombre AS NombreEscolaridad,
			p.Estatus AS Estatus,
			p.Comentario,
			p.NivelIngles,
			colonia.Nombre AS NombreColonia,
			(Select MAX(bitacora.FechaCreacion) FROM bitacora WHERE bitacora.IdProspecto = p.IdProspecto) AS FechaContacto,
			p.foto,
			vp.Finalista,
			vp.Invitaciones 
FROM cliente c
JOIN vacante v ON c.IdCliente = v.IdCliente
JOIN vacante_prospecto vp ON v.IdVacante = vp.IdVacante
JOIN prospecto p ON vp.IdProspecto = p.IdProspecto
LEFT JOIN catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
LEFT JOIN catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
LEFT JOIN catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo
LEFT JOIN colonia ON (p.Clave_Colonia = colonia.Clave_colonia
AND p.CP = Colonia.CodigoPostal)
WHERE c.IdCliente = pCliente AND vp.Estatus > 0;
END;;