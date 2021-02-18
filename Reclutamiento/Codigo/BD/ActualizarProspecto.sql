USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ActProspecto`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActProspecto`(
IN `pIdProspecto` INT, 
IN `pNombre` VARCHAR(100), 
IN `pApellidos` VARCHAR(100), 
IN `pFechaNacimiento` TIMESTAMP, 
IN `pRFC` VARCHAR(13),  
IN `pEmail` VARCHAR(100), 
IN `pTelefonoMovil` VARCHAR(10), 
IN `pTelefonoOtro` VARCHAR(10), 
IN `pIdSexo` INT, 
IN `pDireccion` VARCHAR(250), 
IN `pSalario` DOUBLE, 
IN `pSalarioFinal` DOUBLE, 
IN `pIdEstadoCivil` INT, 
IN `pIdEscolaridad` INT, 
IN `pIdUsuarioLog` INT, 
IN `pEstatus` TINYINT(1), 
IN `pIdEmpresa` INT, 
IN `pClaveColonia` VARCHAR(10), 
IN `pCP` VARCHAR(10), 
IN `pComentario` VARCHAR(250), 
IN `pNivelIngles` VARCHAR(50), 
IN `pFoto` VARCHAR(50),
IN `pCalle`VARCHAR(100) 
)
BEGIN 
	UPDATE prospecto
	SET
	  Nombre = pNombre,
	  Apellidos = pApellidos, 
	  FechaNacimiento = pFechaNacimiento,
	  RFC = pRFC,
	  Email = pEmail,
	  TelefonoMovil = pTelefonoMovil, 
	  TelefonoOtro = pTelefonoOtro,
	  IdSexo = pIdSexo,
      Clave_Colonia = pClaveColonia,
      CP = pCP,
	  Direccion = pDireccion,
	  Salario = pSalario,
	  SalarioFinal = pSalarioFinal,
	  IdEstadoCivil = pIdEstadoCivil,
	  IdEscolaridad = pIdEscolaridad,
	  IdUsuarioUltimoModifico = pIdUsuarioLog,
	  FechaModificacion = now(),
	  Estatus = pEstatus,
      NivelIngles = pNivelIngles,
	  Comentario = pComentario,
      foto = ifnull(concat(pFoto), ''),
      Calle = pCalle
	WHERE IdProspecto = pIdProspecto
		  and IdEmpresa = pIdEmpresa;
        SELECT null as ErrorMessage;
END$$

DELIMITER ;

