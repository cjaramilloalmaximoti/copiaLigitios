USE `directma_reclutamiento`;
DROP procedure IF EXISTS `InsProspecto`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsProspecto`(
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
  INSERT INTO prospecto 
	(
	  Nombre,
	  Apellidos,
	  FechaNacimiento,
	  RFC,
	  Email,
	  TelefonoMovil, 
	  TelefonoOtro,
	  IdSexo,
      Clave_Colonia,
      CP,
	  Direccion, 
	  Salario, 
	  SalarioFinal,
	  IdEstadoCivil,
	  IdEscolaridad,
	  IdUsuarioCreacion,
	  FechaCreacion,
	  IdUsuarioUltimoModifico,
	  FechaModificacion,
	  Estatus,
	  Comentario,
      NivelIngles,
	  IdEmpresa,
      Calle
	)
	VALUES
	(
	  pNombre,
	  pApellidos,
	  pFechaNacimiento,
	  pRFC,
	  pEmail,
	  pTelefonoMovil,
	  pTelefonoOtro,
	  pIdSexo,
      pClaveColonia,
      pCP,
	  pDireccion,
	  pSalario,
	  pSalarioFinal,
	  pIdEstadoCivil,
	  pIdEscolaridad,
	  pIdUsuarioLog,
	  now(),
      pIdUsuarioLog,
	  now(),
	  pEstatus,
	  pComentario,
      pNivelIngles,
	  pIdEmpresa,
      pCalle
      );
      
      set pIdProspecto = (SELECT MAX(IdProspecto) from prospecto);
      
      update prospecto set foto = ifnull(concat(pIdProspecto, pFoto), '') where idProspecto = pIdProspecto;
      
      SELECT null as ErrorMessage, pIdProspecto as IdProspecto;
END$$

DELIMITER ;

