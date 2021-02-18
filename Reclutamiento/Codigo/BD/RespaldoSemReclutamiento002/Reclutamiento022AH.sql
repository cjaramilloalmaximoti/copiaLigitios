-- ============================================= 	
 -- Nombre: SP [Reclutamiento 022AH] 
 -- Fecha de Creación: 16/03/2018
 -- Objetivo: Sps insertar, actualizar y obtener Caracteristicas Particulares
 -- Desarrollador: Armando Herrera
 -- ============================================= 
 

 -- Obtener caracteristicas Particulares
 
 USE `reclutamiento`;
DROP procedure IF EXISTS `ObtCaracteristicasParticulares`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasParticulares`(
	IN pIdEmpresa INT(11),
	IN pEstatus TINYINT (4),
 	IN pIdTipoCampo int(11)
)
BEGIN
	IF pEstatus < 0 AND pIdTipoCampo < 0 THEN  

SELECT 
				caracteristicaparticular.IdCaracteristicaParticular,
				caracteristicaparticular.Nombre,
				caracteristicaparticular.IdTipoCampo,
				caracteristicaparticular.Estatus,
				caracteristicaparticular.IdEmpresa,
				cg.Nombre as TipoCampo
		FROM 
				reclutamiento.caracteristicaparticular
		INNER JOIN caracteristicageneral as cg on caracteristicaparticular.IdTipoCampo=cg.IdCaracteristicaGeneral 

		WHERE 
				caracteristicaparticular.IdEmpresa = pIdEmpresa;





ELSEIF  pEstatus < 0 AND  pIdTipoCampo >= 0 THEN 

		SELECT 
				caracteristicaparticular.IdCaracteristicaParticular,
				caracteristicaparticular.Nombre,
				caracteristicaparticular.IdTipoCampo,
				caracteristicaparticular.Estatus,
				caracteristicaparticular.IdEmpresa,
				cg.Nombre as TipoCampo
		FROM 
				reclutamiento.caracteristicaparticular
		INNER JOIN caracteristicageneral as cg on caracteristicaparticular.IdTipoCampo=cg.IdCaracteristicaGeneral 

		WHERE 
				caracteristicaparticular.IdEmpresa = pIdEmpresa
		AND 
				caracteristicaparticular.IdTipoCampo = pIdTipoCampo;


ELSEIF  pEstatus >= 0 AND  pIdTipoCampo < 0 THEN 


SELECT 
				caracteristicaparticular.IdCaracteristicaParticular,
				caracteristicaparticular.Nombre,
				caracteristicaparticular.IdTipoCampo,
				caracteristicaparticular.Estatus,
				caracteristicaparticular.IdEmpresa,
				cg.Nombre as TipoCampo
		FROM 
				reclutamiento.caracteristicaparticular
		INNER JOIN caracteristicageneral as cg on caracteristicaparticular.IdTipoCampo=cg.IdCaracteristicaGeneral 
		WHERE 
				caracteristicaparticular.IdEmpresa = pIdEmpresa
		AND 
				caracteristicaparticular.Estatus = pEstatus;


ELSE
		SELECT 
				caracteristicaparticular.IdCaracteristicaParticular,
				caracteristicaparticular.Nombre,
				caracteristicaparticular.IdTipoCampo,
				caracteristicaparticular.Estatus,
				caracteristicaparticular.IdEmpresa,
				cg.Nombre as TipoCampo
		FROM 
				reclutamiento.caracteristicaparticular
		INNER JOIN caracteristicageneral as cg on caracteristicaparticular.IdTipoCampo=cg.IdCaracteristicaGeneral 

		WHERE 
				caracteristicaparticular.IdEmpresa = pIdEmpresa
		AND 
				caracteristicaparticular.Estatus = pEstatus
		AND 
				caracteristicaparticular.IdTipoCampo = pIdTipoCampo;

END IF;
		
END$$

DELIMITER ;

-- Insertar 
USE `reclutamiento`;
DROP procedure IF EXISTS `InsCaracteristicaParticular`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCaracteristicaParticular`(
	IN pClave VARCHAR(10),
	IN pNombre VARCHAR(100),
	IN pIdTipoCampo INT(11),
	IN pIdUsuarioCreacion INT(11),
	IN pEstatus TINYINT(4),
	IN pIdEmpresa INT(11)
)
BEGIN

	DECLARE pIdCaracteristicaParticular INT(11);

	IF (SELECT COUNT(1)
			FROM reclutamiento.caracteristicaparticular
			WHERE 
					caracteristicaparticular.Clave=pClave 
				AND  caracteristicaparticular.Nombre=pNombre
				AND caracteristicaparticular.IdTipoCampo = pIdTipoCampo 
				AND caracteristicaparticular.IdEmpresa= pIdEmpresa
				AND caracteristicaparticular.Estatus=pEstatus
		)!=0 THEN 
			SELECT 'Error al insertar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
		
	ELSE 
		INSERT INTO reclutamiento.caracteristicaparticular
			(
				caracteristicaparticular.Clave,
				caracteristicaparticular.Nombre,
				caracteristicaparticular.IdTipoCampo,
				caracteristicaparticular.FechaCreacion,
				caracteristicaparticular.IdUsuarioCreacion,
				caracteristicaparticular.FechaModificacion,
				caracteristicaparticular.IdUsuarioUltimoModifico,
				caracteristicaparticular.Estatus,
				caracteristicaparticular.IdEmpresa
			)	
			VALUES 
			(
				pClave,
				pNombre,
				pIdTipoCampo, 
				NOW(),
				pIdUsuarioCreacion,
				NOW(),
				pIdUsuarioCreacion, 
				pEstatus, 
				pIdEmpresa
			);

			SET pIdCaracteristicaParticular= (SELECT MAX(IdCaracteristicaParticular) FROM reclutamiento.caracteristicaparticular);
			SELECT  NULL AS ErrorMessage, pIdCaracteristicaParticular as IdCaracteristicaParticular;

		END IF ;
END$$

DELIMITER ;


-- Actualizar 

USE `reclutamiento`;
DROP procedure IF EXISTS `ActCaracteristicaParticular`;

DELIMITER $$z
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCaracteristicaParticular`(
	IN pIdCaracteristicaParticular VARCHAR(10),
	IN pNombre VARCHAR(100),
	IN pIdTipoCampo INT(11),
	IN pIdUsuarioUltimoModifico INT(11),
	IN pEstatus TINYINT(4),
	IN pIdEmpresa INT(11)
)
BEGIN
	UPDATE
		reclutamiento.caracteristicaparticular
	SET
		caracteristicaparticular.Nombre =pNombre,
		caracteristicaparticular.IdTipoCampo = pIdTipoCampo, 
		caracteristicaparticular.IdUsuarioUltimoModifico = pIdUsuarioUltimoModifico,
		caracteristicaparticular.FechaModificacion=NOW(),
		caracteristicaparticular.Estatus= pEstatus,
		caracteristicaparticular.IdEmpresa = pIdEmpresa
	WHERE 
		caracteristicaparticular.IdCaracteristicaParticular= pIdCaracteristicaParticular;

	SELECT NULL AS ErrorMessage;
END$$

DELIMITER ;




 
 
 
 
 
 
 INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (22,'Reclutamiento022AH','Armando Herrera',CURDATE() ,'Sps insertar y obtener Caracteristicas Particulares');