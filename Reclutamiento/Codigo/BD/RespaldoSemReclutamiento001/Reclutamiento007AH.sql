-- ============================================= 	
 -- Nombre: Modificacion a tabla y sps de [vacante]
 -- Fecha de Creación: 28/02/2018
 -- Objetivo: Insertar el registro de usuarios. 
 -- Desarrollador: Armando Herrera
 -- =============================================
 
 /* Cambia el tipo de dato en la columna Fase de la tabla Vacante */
ALTER TABLE `reclutamiento`.`vacante` 
CHANGE COLUMN `Fase` `Fase` INT(11) NULL DEFAULT NULL ;

ALTER TABLE `vacantecaracteristica` ADD `Comentario` VARCHAR(255) NOT NULL AFTER `IdCaracteristicaParticular`; 

 /* Cambia el tipo de dato en la columna Activo de la Tqbla vacantecaracteristica */
ALTER TABLE `reclutamiento`.`vacantecaracteristica` 
ADD COLUMN `Activo` TINYINT NULL AFTER `Comentario`;

/* SP Inserta en Vacantes Caracteristicas */ 
USE `reclutamiento`;
DROP procedure IF EXISTS `InsVacanteCaracteristica`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacanteCaracteristica`(
	IN `pIdVacante` INT(11),
	IN `pIdCaracteristicaParticular` INT(11),
	IN `pValor` VARCHAR(100),
	IN `pComentario` VARCHAR(200),
	IN `pActivo` TINYINT
	)
	
BEGIN

DECLARE pIdVacanteCaracteristica INT(11);

	IF( SELECT COUNT(1)
			FROM reclutamiento.vacantecaracteristica
			WHERE 
				vacantecaracteristica.IdVacante= pIdVacante
			AND vacantecaracteristica.IdCaracteristicaParticular= pIdCaracteristicaParticular
			AND vacantecaracteristica.Valor= pValor) !=0 
	THEN 
		SELECT 'Error al insertar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
	ELSE 
		INSERT INTO 
				reclutamiento.vacantecaracteristica (
				vacantecaracteristica.IdVacante ,
				vacantecaracteristica.IdCaracteristicaParticular,
				vacantecaracteristica.Valor,
				vacantecaracteristica.Comentario,
				vacantecaracteristica.Activo

			)
		VALUES (
				pIdVacante,
				pIdCaracteristicaParticular,
				pValor,
				pComentario, 
				pActivo
				);

			SET pIdVacanteCaracteristica= (SELECT MAX(vacantecaracteristica.IdVacanteCaracteristica) 
											FROM
												reclutamiento.vacantecaracteristica);
			
			SELECT NULL AS ErrorMessage, pIdVacanteCaracteristica as pIdVacanteCaracteristica;
	END IF ;

END$$

DELIMITER ;

/* SP Actualiza en Vacantes Caracteristicas */ 
USE `reclutamiento`;
DROP procedure IF EXISTS `ActVacanteCaracteristica`;

DELIMITER $$
USE `reclutamiento`$$
CREATE PROCEDURE `ActVacanteCaracteristica`
	 (
		IN pIdVacanteCaracteristica INT (11),
		IN pIdVacante INT(11),
		IN pIdCaracteristicaParticular INT(11),
		IN pValor VARCHAR(100),
		IN pComentario VARCHAR(200)
	)
BEGIN
	
	IF( SELECT COUNT(1)
			FROM reclutamiento.vacantecaracteristica
			WHERE 
				vacantecaracteristica.IdVacante= pIdVacante
			AND vacantecaracteristica.IdCaracteristicaParticular= pIdCaracteristicaParticular
			AND vacantecaracteristica.Valor= pValor) !=0 
	THEN 
		SELECT 'Error al insertar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
	ELSE

		UPDATE 
				reclutamiento.vacantecaracteristica
		SET
			
				vacantecaracteristica.IdVacante= pIdVacante,
				vacantecaracteristica.IdCaracteristicaParticular= pIdCaracteristicaParticular,
				vacantecaracteristica.Valor= pValor,
				vacantecaracteristica.Comentarios= PCommentario,
				vacantecaracteristica.Activo= pActivo
		WHERE 
				vacantecaracteristica.IdVacanteCaracteristica= pIdVacanteCaracteristica;

	SELECT NULL AS ErrorMessage;
END IF ;

END$$

DELIMITER ;

/* SP Obtiene  Vacantes Caracteristicas */ 
USE `reclutamiento`;
DROP procedure IF EXISTS `ObtVacanteCaracteristica`;

DELIMITER $$
USE `reclutamiento`$$
CREATE PROCEDURE `ObtVacanteCaracteristica` (IN pActivo TINYINT)
BEGIN
	SELECT 
			vacantecaracteristica.IdVacanteCaracteristica,
			vacantecaracteristica.IdVacante ,
			vacantecaracteristica.IdCaracteristicaParticular,
			vacantecaracteristica.Valor,
			vacantecaracteristica.Comentario,
			vacantecaracteristica.Activo
	FROM 
		reclutamiento.vacantecaracteristica 
	WHERE 
		vacantecaracteristica.Activo=pActivo;

END$$

DELIMITER ;

INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (7,'Reclutamiento007AH','Armando Herrera','20180103','');
