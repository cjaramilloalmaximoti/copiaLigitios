-- ============================================= 	
 -- Nombre: SP [] 
 -- Fecha de Creación: 16/03/2018
 -- Objetivo: Modificacion a tabla vacantes por nuevos requerimientos
 -- Desarrollador: Armando Herrera
 -- ============================================= 

-- 1 Se Actualiza Tabla vacante clientes

ALTER TABLE `reclutamiento`.`vacante` 
CHANGE COLUMN `IdCiudad` `IdCiudad` VARCHAR(10) NULL DEFAULT NULL ,
ADD COLUMN `Comentarios` VARCHAR(300) NULL DEFAULT NULL AFTER `IdEmpresa`;



-- 2 Se actualiza sp InsVacante

USE `reclutamiento`;
DROP procedure IF EXISTS `InsVacante`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante`(
IN `pTitulo`  VARCHAR(100),
IN `pDescripcion` VARCHAR(100),
IN `pFechaContratacion` TIMESTAMP,
IN `pNumeroVacantes` INT(11),
IN `pSalario` DOUBLE,
IN `pIdTipoContrato` INT(11),
IN `pIdTipoJornada` INT(11),
IN `pIdCiudad` VARCHAR(10),
IN `pIdUsuarioCreacion` INT(11),
IN `pIdUsuarioUltimoModifico` INT(11),
IN `pEstatus` TINYINT(4),
IN `pComentarios` VARCHAR(300),
IN `pIdEmpresa` INT(11),
IN `pFase`  INT(11),
IN `pFechaEntrega`  DATETIME
	)
BEGIN

DECLARE pIdVacante int;
		INSERT INTO reclutamiento.vacante 
		(
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
			vacante.Comentarios,
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
			pComentarios,
			pIdEmpresa,
			pFase, 
			pFechaEntrega
		);
	SET pIdVacante= (SELECT MAX(IdVacante) FROM reclutamiento.vacante);
	SELECT NULL AS ErrorMessage, pIdVacante as IdVacante;
END$$

DELIMITER ;




-- 3 Se actualiza sp ActVacante

USE `reclutamiento`;
DROP procedure IF EXISTS `ActVacante`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActVacante`(
IN `pIdVacante` INT,
IN `pTitulo`  VARCHAR(100),
IN `pDescripcion` VARCHAR(100),
IN `pFechaContratacion` DATE,
IN `pNumeroVacantes` INT(11),
IN `pSalario` DOUBLE,
IN `pIdTipoContrato` INT(11),
IN `pIdTipoJornada` INT(11),
IN `pIdCiudad` VARCHAR(10),
IN `pIdUsuarioUltimoModifico` INT(11),
IN `pEstatus` TINYINT(4),
IN `pComentarios` VARCHAR(300),
IN `pIdEmpresa` INT (11),
IN `pFase`  VARCHAR(90),
IN `pFechaEntrega`  DATE
)
BEGIN

	IF(
			SELECT COUNT(1)
			FROM reclutamiento.vacante
			WHERE vacante.Titulo= pTitulo
			AND vacante.descripcion=pDescripcion
			AND vacante.FechaContratacion= pFechaContratacion
			AND vacante.NumeroVacantes=pNumeroVacantes
			AND vacante.Salario=pSalario
			AND vacante.IdTipoContrato=pIdTipoContrato
			AND vacante.IdTipoJornada=pIdTipoJornada
			AND vacante.IdCiudad=pIdCiudad
			AND vacante.FechaEntrega=pFechaEntrega
			AND vacante.idEmpresa =pIdEmpresa
			AND vacante.Estatus=pEstatus)!=0 
	THEN 
			SELECT 'Error al actualizar: La vacante que intenta guardar ya esta registrada.' as ErrorMessage;
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
				vacante.Comentarios=pComentarios,
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

-- 4 se añade sp ObtenerCiudadTexto

USE `reclutamiento`;
DROP procedure IF EXISTS `ObtCiudadTexto`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCiudadTexto`(
IN `pClaveCiudad` varchar(03),
IN `pClaveEstado` varchar(03)
)
BEGIN

		SELECT 
			ciudad.nombre
		FROM 
			reclutamiento.ciudad
		WHERE 
			ciudad.Clave_Ciudad= pClaveCiudad AND ciudad.Clave_Estado= pClaveEstado;

END$$
DELIMITER ;



INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (18,'Reclutamiento019AH','Armando Herrera',now(),'Requerimiento Comentarios y Ciudad Estado Pais');

