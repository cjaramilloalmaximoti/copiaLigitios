INSERT INTO `reclutamiento`.`parametro`
(`IdParametro`,
`Nombre`,
`Descripcion`,
`Valor`,
`EsActivo`,
`EsSensitivo`,
`IdUsuarioCreacion`,
`FechaCreacion`,
`IdUsuarioUltimoModifico`,
`FechaModificacion`,
`OrigenOperacion`,
`IdEmpresa`)
VALUES
(14,
'TituloNotificacionInvitacionVacante',
'Título del correo para las invitaciones a las vacantes.',
'Invitación al proceso de selección',
1,
0,
1,
NOW(),
0,
NULL,
1,
1
);

INSERT INTO `reclutamiento`.`parametro`
(`IdParametro`,
`Nombre`,
`Descripcion`,
`Valor`,
`EsActivo`,
`EsSensitivo`,
`IdUsuarioCreacion`,
`FechaCreacion`,
`IdUsuarioUltimoModifico`,
`FechaModificacion`,
`OrigenOperacion`,
`IdEmpresa`)
VALUES
(15,
'CorreoInvitacionVacante',
'Cuerpo del correo en formato html que se va a enviar como invitación a los prospectos para las vacantes.',
'<html xmlns:o><head></head><body><div align="center">
 <table align="center" width="50%">
 <tr><th align="center"><font size="4"><br />Invitación al Proceso de Selección</font></th></tr>
 <tr><td width="25%"><br /><br /><o:p>Estimado: <b>%%NombreProspecto%%</b><br /><br />	Por medio del presente te invitamos a formar parte del proceso de selección de la vacante: <b>%%NombreVacante%%</b> de la empresa: <b>%%NombreEmpresa%%.</b><br />
 <p>Para postularte favor de enviar un correo a la dirección: <b>%%EmailEmpresa%%</b> y una persona se pondrá en contacto para más detalles.</p>
 </o:p></td></tr>
 <tr><td><o:p><br /><br />Este es un correo automático favor de no responder.</o:p></td></tr>
 </table>
 </div></body></html>',
1,
0,
1,
NOW(),
0,
NULL,
1,
1
);

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
use reclutamiento;
DROP PROCEDURE IF EXISTS `ObtEmpresas`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtEmpresas`()
BEGIN

	SELECT 

		IdEmpresa,

        Dominio,

        ProductKey,

        Administrador,

        Contrasenia,

        NombreComercial,

        RutaLogo,

		Email

    FROM empresa;

END
$$

DELIMITER ;