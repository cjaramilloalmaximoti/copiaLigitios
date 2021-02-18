use directma_reclutamiento;
alter table vacante modify descripcion varchar(400);
USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ActVacante`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActVacante`(IN `pIdVacante` INT, IN `pTitulo` VARCHAR(100), IN `pSubTitulo` VARCHAR(100), IN `pDescripcion` VARCHAR(400), IN `pFechaContratacion` DATE, IN `pNumeroVacantes` INT(11), IN `pSalario` DOUBLE, IN `pIdTipoContrato` INT(11), IN `pIdCliente` INT, IN `pIdTipoJornada` INT(11), IN `pIdCiudad` VARCHAR(20), IN `pIdUsuarioUltimoModifico` INT(11), IN `pEstatus` TINYINT(4), IN `pComentarios` VARCHAR(300), IN `pIdEmpresa` INT(11), IN `pFase` VARCHAR(90), IN `pFechaEntrega` DATE, IN `pDetalles` VARCHAR(500))
BEGIN
SET @SQL = pDetalles;

  IF(
    SELECT COUNT(1)
    FROM vacante
    WHERE vacante.Titulo= pTitulo
      AND vacante.descripcion=pDescripcion
      AND vacante.FechaContratacion = pFechaContratacion
      AND vacante.NumeroVacantes=pNumeroVacantes
      AND vacante.Salario=pSalario
      AND vacante.IdTipoContrato=pIdTipoContrato
      AND vacante.IdTipoJornada=pIdTipoJornada
      AND vacante.IdCiudad=pIdCiudad
      AND vacante.FechaEntrega=pFechaEntrega
      AND vacante.idEmpresa =pIdEmpresa
      AND vacante.Estatus=pEstatus
    )!=0 
THEN 
      SELECT 'Error al actualizar: La vacante que intenta guardar ya esta registrada.' AS ErrorMessage;
  ELSE
      UPDATE vacante
 SET 
    vacante.Titulo=pTitulo,
    vacante.Descripcion=pDescripcion,
	vacante.FechaContratacion=pFechaContratacion,
	vacante.NumeroVacantes=pNumeroVacantes,
	vacante.Salario=pSalario,
	vacante.IdTipoContrato=pIdTipoContrato,
	vacante.IdTipoJornada=pIdTipoJornada,
	vacante.IdCiudad=pIdCiudad,
	vacante.IdUsuarioUltimoModifico=pIdUsuarioUltimoModifico,
	vacante.FechaModificacion = NOW(),
	vacante.Estatus= pEstatus,
	vacante.Comentarios=pComentarios,
	vacante.Fase= pFase,
	vacante.FechaEntrega=pFechaEntrega,
    vacante.SubTitulo = pSubTitulo,
    vacante.IdCliente = pIdCliente
      WHERE
        IdVacante=pIdVacante AND IdEmpresa=pIdEmpresa;
	PREPARE stmt1 
	FROM @SQL;
	EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1; 
    SELECT NULL AS ErrorMessage;
  END IF;
END$$

DELIMITER ;

USE `directma_reclutamiento`;
DROP procedure IF EXISTS `InsVacante`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante`(IN `pTitulo` VARCHAR(100), IN `pSubTitulo` VARCHAR(100), IN `pDescripcion` VARCHAR(400), IN `pFechaContratacion` TIMESTAMP, IN `pNumeroVacantes` INT(11), IN `pSalario` DOUBLE, IN `pIdTipoContrato` INT(11), IN `pIdCliente` INT, IN `pIdTipoJornada` INT(11), IN `pIdCiudad` VARCHAR(20), IN `pIdUsuarioCreacion` INT(11), IN `pIdUsuarioUltimoModifico` INT(11), IN `pEstatus` TINYINT(4), IN `pComentarios` VARCHAR(300), IN `pIdEmpresa` INT(11), IN `pFase` INT(11), IN `pFechaEntrega` DATETIME)
BEGIN
DECLARE pIdVacante INT;
		INSERT INTO vacante 
		(
			vacante.Titulo,
			vacante.SubTitulo,
			vacante.Descripcion,
			vacante.FechaContratacion,
			vacante.NumeroVacantes,
			vacante.Salario, 
			vacante.IdTipoContrato,
			vacante.IdCliente,
			vacante.IdTipoJornada, 
			vacante.IdCiudad, 
			vacante.IdUsuarioCreacion,
			vacante.FechaCreacion,
			vacante.IdUsuarioUltimoModifico,
			vacante.FechaModificacion,
			vacante.Estatus, 
			vacante.Comentarios,
			vacante.IdEmpresa, 
			vacante.Fase,
			vacante.FechaEntrega
		)
			VALUES
		(
			pTitulo,
			pSubTitulo,
			pDescripcion,
			pFechaContratacion,
			pNumeroVacantes,
			pSalario, 
			pIdTipoContrato,
			pIdCliente,
			pIdTipoJornada, 
			pIdCiudad, 
			pIdUsuarioCreacion,
			NOW(),
			pIdUsuarioUltimoModifico,
			NOW(),
			pEstatus, 
			pComentarios,
			pIdEmpresa,
			pFase, 
			pFechaEntrega
		);
	SET pIdVacante= (SELECT MAX(IdVacante) FROM vacante);
	SELECT NULL AS ErrorMessage, pIdVacante AS IdVacante;
END$$

DELIMITER ;


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
USE `directma_reclutamiento`;
DROP procedure IF EXISTS `InsBitacora`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsBitacora`(IN `pIdProspecto` INT, IN `pComentario` VARCHAR(250), IN `pIdUsuarioLog` INT, IN `pFechaCreacion` timestamp)
BEGIN
    DECLARE pIdBitacora INT;
	if pFechaCreacion is null then 
		INSERT INTO bitacora
		(
			IdProspecto,
			Comentario,
			IdUsuarioCreacion,
			FechaCreacion
		)
		VALUES
		(
			pIdProspecto,
			pComentario,
			pIdUsuarioLog,
			now()
		);
    else
		INSERT INTO bitacora
		(
			IdProspecto,
			Comentario,
			IdUsuarioCreacion,
			FechaCreacion
		)
		VALUES
		(
			pIdProspecto,
			pComentario,
			pIdUsuarioLog,
			pFechaCreacion
		);
        end if;
         
	set pIdBitacora = (SELECT MAX(IdBitacora) from bitacora);
        SELECT null as ErrorMessage, pIdBitacora as IdBitacora;
        
END$$

DELIMITER ;

