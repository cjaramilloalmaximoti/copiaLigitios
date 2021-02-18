-- ============================================= 	
 -- Nombre: Modificacion a tabla y sps de [vacante]
 -- Fecha de Creación: 01/03/2018
 -- Desarrollador: Armando Herrera
 -- =============================================

 -- Caracteristicas Particulares -- 

 /* SP Inserta CaracteristicaParticular */
 USE `reclutamiento`;
DROP procedure IF EXISTS `InsCaracteristicaParticular`;

DELIMITER $$
USE `reclutamiento`$$
CREATE PROCEDURE `InsCaracteristicaParticular` 
(
	IN pClave VARCHAR(10),
	IN pNombre VARCHAR(100),
	IN pIdTipoCampo INT(11),
	IN pIdUsuarioCreacion INT(11),
	IN pIdUsuarioUltimoModifico INT(11),
	IN pFechaModificacion TIMESTAMP,
	IN pEstatus TINYINT(4),
	IN pIdEmpresa INT(11)
)
BEGIN
	DECLARE IdCaracteristicaParticular INT(11);
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
				caracteristicaparticular.IdUsuarioCreacion,
				caracteristicaparticular.IdUsuarioUltimoModifico,
				caracteristicaparticular.FechaModificacion,
				caracteristicaparticular.Estatus,
				caracteristicaparticular.IdEmpresa
			)	
			VALUES 
			(
				pClave,
				pNombre,
				pIdTipoCampo, 
				pIdUsuarioCreacion,
				pIdUsuarioUltimoModifico, 
				NOW(),
				pEstatus, 
				pIdEmpresa
			);
			SET IdCaracteristicaParticular= (SELECT MAX(IdCaracteristicaParticular) FROM reclutamiento.caracteristicaparticular);
			SELECT  NULL AS ErrorMessage, IdCaracteristicaParticular as IdCaracteristicaParticular;
		END IF ;
END$$

DELIMITER ;

 /* SP Actualiza CaracteristicaParticular */
 USE `reclutamiento`;
DROP procedure IF EXISTS `ActCaracteristicaParticular`;

DELIMITER $$
USE `reclutamiento`$$
CREATE PROCEDURE `ActCaracteristicaParticular` 
(
	IN pIdCaracteristicaParticular VARCHAR(10),
	IN pClave VARCHAR(10),
	IN pNombre VARCHAR(100),
	IN pIdTipoCampo INT(11),
	IN pIdUsuarioCreacion INT(11),
	IN pIdUsuarioUltimoModifico INT(11),
	IN pFechaModificacion TIMESTAMP,
	IN pEstatus TINYINT(4),
	IN pIdEmpresa INT(11)
)
BEGIN
	UPDATE
		reclutamiento.caracteristicaparticular
	SET
		caracteristicaparticular.Clave =pClave,
		caracteristicaparticular.Nombre =pNombre,
		caracteristicaparticular.IdTipoCampo = pIdTipoCampo, 
		caracteristicaparticular.IdUsuarioCreacion= pIdUsuarioCreacion,
		caracteristicaparticular.IdUsuarioUltimoModifico = pIdUsuarioUltimoModifico,
		caracteristicaparticular.FechaModificacion=NOW(),
		caracteristicaparticular.Estatus= pEstatuS,
		caracteristicaparticular.IdEmpresa = pIdEmpresa
	WHERE 
		caracteristicaparticular.IdCaracteristicaParticular= pIdCaracteristicaParticular;

	SELECt NULL AS ErrorMessage;
END$$

DELIMITER ;

 /* SP Obtiene CaracteristicaParticular */
USE `reclutamiento`;
DROP procedure IF EXISTS `ObtCaracteristicaParticular`;
DELIMITER $$
USE `reclutamiento`$$
CREATE PROCEDURE `ObtCaracteristicaParticular` 
(
	IN pIdEmpresa INT(11), 
	IN pEstatus TINYINT (4)
)
BEGIN
		SELECT 
				caracteristicaparticular.IdCaracteristicaParticular,
				caracteristicaparticular.Clave,
				caracteristicaparticular.Nombre,
				caracteristicaparticular.IdTipoCampo,
				caracteristicaparticular.IdUsuarioCreacion,
				caracteristicaparticular.IdUsuarioUltimoModifico,
				caracteristicaparticular.FechaModificacion,
				caracteristicaparticular.Estatus,
				caracteristicaparticular.IdEmpresa
		FROM 
				reclutamiento.caracteristicaparticular
		WHERE 
				caracteristicaparticular.IdEmpresa = pIdEmpresa
		AND 
				caracteristicaparticular.Estatus= pEstatus;
END$$

DELIMITER ;

INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (9,'Reclutamiento009AH','Armando Herrera','20180103','');