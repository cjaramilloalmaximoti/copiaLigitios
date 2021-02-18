-- ============================================= 	
 -- Nombre: Modificacion a tabla y sps de [vacante]
 -- Fecha de Creación: 28/02/2018
 -- Objetivo: Insertar el registro de usuarios. 
 -- Desarrollador: Armando Herrera
 -- ============================================= 
 
USE `reclutamiento`;
 -- Add Columna vacante.Fase 
ALTER TABLE `reclutamiento`.`vacante` 
ADD COLUMN `Fase` VARCHAR(90) NULL AFTER `IdEmpresa`;

 -- Add Columna vacante.FechaEntrega
ALTER TABLE `reclutamiento`.`vacante` 
ADD COLUMN `FechaEntrega` DATETIME NULL DEFAULT NULL AFTER `Fase`;



/*	Agrega SP InsVacante` - Inserta vacante */ 
USE `reclutamiento`;
DROP procedure IF EXISTS `InsVacante`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante`(
-- Parametros -- 
IN `pTitulo`  VARCHAR(100),
IN `pDescripcion` VARCHAR(1024),
IN `pFechaContratacion` TIMESTAMP,
IN `pNumeroVacantes` INT(11),
IN `pSalario` DOUBLE,
IN `pIdTipoContrato` INT(11),
IN `pIdTipoJornada` INT(11),
IN `pIdCiudad` INT(11),
IN `pIdUsuarioCreacion` INT(11),
IN `pIdUsuarioUltimoModifico` INT(11),
IN `pEstatus` TINYINT(4),
IN `pIdEmpresa` INT(11),
IN `pFase`  VARCHAR(900),
IN `pFechaEntrega`  DATETIME
	)
BEGIN

DECLARE pIdVacante int;

IF (SELECT COUNT(1)
	FROM reclutamiento.vacante
	WHERE vacante.Descripcion 
	AND vacante.estatus =1 
	AND vacante.IdEmpresa= pIdEmpresa
     ) !=0 THEN 
		SELECT 'Error al insertar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
	else
		INSERT INTO reclutamiento.vacante 
		(
			vacante.Titulo,
			vacante.Descripcion,
			vacante.FechaContratacion,
			vacante.NumeroVacantes,
			Salario, 
			vacanteIdTipoContrato,
			vacante.IdTipoJornada, 
			vacante.IdCiudad, 
			vacante.IdUsuarioCreacion,
			vacante.FechaCreacion,
			vacante.IdUsuarioUltimoModifico,
			vacante.FechaModificacion,
			vacante.Estatus, 
			vacante.IdEmpresa, 
			vacante.Fase,
			vacante.FechaEntrega
		)
			values
		(
			pTitulo,
			pDescripcion,
			pFechaContratacion,
			pNumeroVacantes,
			pSalario, 
			pIdTipoContrato,
			pIdTipoJornada, 
			pIdCiudad, 
			pIdUsuarioCreacion,
			NOW(),
			pIdUsuarioUltimoModifico,
			NOW(),
			pEstatus, 
			pIdEmpresa,
			pFase, 
			pFechaEntrega
		);
	SET pIdVacante= (SELECT MAX(IdVacante) FROM reclutamiento.vacante);
	SELECT NULL AS ErrorMessage, pIdVacante as IdVacante;
end if;

END$$

DELIMITER ;


/* SP Actualiza vacante  */ 

USE `reclutamiento`;
DROP procedure IF EXISTS `ActVacante`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActVacante`(
IN `pIdVacante` INT,
IN `pTitulo`  VARCHAR(100),
IN `pDescripcion` VARCHAR(1024),
IN `pFechaContratacion` TIMESTAMP,
IN `pNumeroVacantes` INT(11),
IN `pSalario` DOUBLE,
IN `pIdTipoContrato` INT(11),
IN `pIdTipoJornada` INT(11),
IN `pIdCiudad` INT(11),
IN `pIdUsuarioUltimoModifico` INT(11),
IN `pEstatus` TINYINT(4),
IN `pIdEmpresa` INT(11),
IN `pFase`  VARCHAR(90),
IN `pFechaEntrega`  VARCHAR(90)

)
BEGIN

	IF(
			SELECT COUNT(1)
			FROM reclutamiento.vacante
			WHERE vacante.descripcion=pDescripcion
			AND vacante.IdCliente= pIdCliente
			AND vacante.idEmpresa =pIdEmpresa

			AND vacante.Estatus=1)!=0 
	THEN 
			SELECT 'Error al actualizar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
	ELSE
			UPDATE reclutamiento.vacante
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
				vacante.FechaModificacion = now(),
				vacante.Estatus= pEstatus, 
				vacante.IdEmpresa= pIdEmpresa,
				vacante.Fase= pFase, 
				vacante.FechaEntrega=pFechaEntrega
			WHERE 
				IdVacante=pIdVacante
			AND 
				IdEmpresa=pIdEmpresa;

	SELECT NULL AS ErrorMessage;

END IF;

END$$

DELIMITER ;

/*  SP Obtener vacantes (Todas) */ 

USE `reclutamiento`;
DROP procedure IF EXISTS `ObtVacantes`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtVacantes`(
	IN `pIdEmpresa` int,
	IN `pEstatus` tinyInt  
)
BEGIN
	Declare pDesde tinyint;
	Declare pHasta tinyint;	
			
	if(pEstatus = -1) then
			SET pDesde = 0;
			SET pHasta = 1;
	else
			SET pDesde = pEstatus;
			SET pHasta = pEstatus;
	end if;

	SELECT 
			vacante.Titulo,
			vacante.Descripcion,
			vacante.FechaContratacion,
			vacante.NumeroVacantes,
			vacante.Salario, 
			vacante.IdTipoContrato,
			vacante.IdTipoJornada, 
			vacante.IdCiudad, 
			vacante.IdUsuarioCreacion,
			vacante.FechaCreacion,
			vacante.IdUsuarioUltimoModifico,
			vacante.FechaModificacion,
			vacante.Estatus, 
			vacante.IdEmpresa, 
			vacante.Fase,
			vacante.FechaEntrega
	FROM 
			reclutamiento.vacante
	WHERE 
			vacante.IdEmpresa = pIdEmpresa
			and vacante.Estatus between pDesde and pHasta;
END$$

DELIMITER ;


INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (5,'Reclutamiento005AH','Armando Herrera','20180228','');



