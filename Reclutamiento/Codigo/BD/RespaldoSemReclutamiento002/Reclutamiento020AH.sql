-- ============================================= 	
 -- Nombre: SP [] 
 -- Fecha de Creación: 16/03/2018
 -- Objetivo: Altas - Bajas - Cambios de Caracteristicas Generales
 -- Desarrollador: Armando Herrera
 -- ============================================= 
 -- Crear tabla
 
 
USE `reclutamiento`;
DROP table if exists `caracteristicageneral`;



CREATE TABLE `caracteristicageneral` (
  `IdCaracteristicaGeneral` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) DEFAULT NULL,
  `FechaCreacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioCreacion` int(11) DEFAULT NULL,
  `FechaModificacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioUltimoModifico` int(11) DEFAULT NULL,
  `Estatus` tinyint(4) DEFAULT NULL,
  `IdEmpresa` int(11) DEFAULT NULL,
  PRIMARY KEY (`IdCaracteristicaGeneral`),
  UNIQUE KEY `IdCaracteristicaGeneral_UNIQUE` (`IdCaracteristicaGeneral`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='IdCaracteristicaGeneral';

DELIMITER ;

-- Altas

USE `reclutamiento`;
DROP procedure IF EXISTS `InsCaracteristicaGeneral`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCaracteristicaGeneral`(
	IN pNombre VARCHAR(100),
	IN pIdUsuarioCreacion INT(11),
	IN pEstatus TINYINT(4),
	IN pIdEmpresa INT(11)
)
BEGIN

	DECLARE pidCaracteristicaGeneral INT(11);

	IF (SELECT COUNT(1)
			FROM reclutamiento.caracteristicageneral
			WHERE 
				caracteristicageneral.Nombre=pNombre
				AND caracteristicageneral.IdEmpresa= pIdEmpresa
				AND caracteristicageneral.Estatus=pEstatus
		)!=0 THEN 
			SELECT 'Error al insertar: La Caracteristica General queC:\Users\user\Desktop\Proyectos\Workspace\ALM.Reclutamiento.Datos\CadenaConexion.cs intenta guardar ya esta siendo utilizado.' as ErrorMessage;
		
	ELSE 
		INSERT INTO reclutamiento.caracteristicageneral
			(
				caracteristicageneral.Nombre,
				caracteristicageneral.FechaCreacion,
				caracteristicageneral.IdUsuarioCreacion,
				caracteristicageneral.FechaModificacion,

				caracteristicageneral.IdUsuarioUltimoModifico,
				caracteristicageneral.Estatus,
				caracteristicageneral.IdEmpresa
			)	
			VALUES 
			(
				pNombre,
				NOW(),
				pIdUsuarioCreacion,
				NOW(),
				pIdUsuarioCreacion,
				pEstatus, 
				pIdEmpresa
			);

			SET pidCaracteristicaGeneral= (SELECT MAX(IdCaracteristicaGeneral) FROM reclutamiento.caracteristicageneral);
			SELECT  NULL AS ErrorMessage, pidCaracteristicaGeneral as IdCaracteristicaGeneral;

		END IF ;
END$$

DELIMITER ;


-- Cambios

USE `reclutamiento`;
DROP procedure IF EXISTS `ActCaracteristicaGeneral`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCaracteristicaGeneral`(
	IN pIdCaracteristicaGeneral int(11),
	IN pNombre VARCHAR(100),
	IN pIdUsuarioUltimoModifico INT(11),
	IN pEstatus TINYINT(4),
	IN pIdEmpresa INT(11)
)
BEGIN
UPDATE caracteristicageneral
SET 
		caracteristicageneral.Nombre =pNombre,
		caracteristicageneral.IdUsuarioUltimoModifico= pIdUsuarioUltimoModifico,
		caracteristicageneral.Estatus = pEstatus,
		caracteristicageneral.IdEmpresa = pIdEmpresa
WHERE 
		caracteristicageneral.IdCaracteristicaGeneral= pIdCaracteristicaGeneral;

SELECT NULL AS ErrorMessage;

END$$

DELIMITER ;


-- Obtener 

USE `reclutamiento`;
DROP procedure IF EXISTS `ObtCaracteristicasGenerales`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasGenerales`(
IN 	`pNombre` varchar(100) ,
IN `pIdEmpresa` int (11),
IN `pEstatus` tinyInt 
)
BEGIN

IF pNombre IS NULL THEN SET pNombre=''; END IF;

IF pEstatus < 0 THEN
			SELECT 
				caracteristicageneral.IdCaracteristicaGeneral,
				caracteristicageneral.Nombre,
				caracteristicageneral.Estatus,
				caracteristicageneral.FechaCreacion
			FROM 
				reclutamiento.caracteristicageneral
			WHERE 
				caracteristicageneral.idEmpresa= pIdEmpresa
			AND 
				caracteristicageneral.Nombre LIKE CONCAT('%', pNombre, '%');
			
	ELSE 

		SELECT 
				caracteristicageneral.IdCaracteristicaGeneral,
				caracteristicageneral.Nombre,
				caracteristicageneral.Estatus,
				caracteristicageneral.FechaCreacion
			FROM 
				reclutamiento.caracteristicageneral
			WHERE 
				caracteristicageneral.idEmpresa= pIdEmpresa
			AND 
				caracteristicageneral.Nombre LIKE CONCAT('%', pNombre, '%')
			AND 
				caracteristicageneral.Estatus = pEstatus;
END IF;
	
END$$

DELIMITER ;


 
 
 
 
 
 
 
 
 
 INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (20,'Reclutamiento020AH','Armando Herrera',CURDATE() ,'Creacion Altas Cambios Obtener Caracteristicas Generales');
