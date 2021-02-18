USE `directma_reclutamiento`;
DROP procedure IF EXISTS `InsCatalogo`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCatalogo`(`pClave` VARCHAR(12), `pIdUsuarioLog` INT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(256), `pIdTipoCatalogo` SMALLINT, `pIdEmpresa` INT)
BEGIN
	DECLARE pIdCatalogo INT;
    IF((SELECT COUNT(*) FROM Catalogo WHERE Clave = pClave AND IdTipoCatalogo = pIdTipoCatalogo) != 0) THEN
        SELECT-1;
	ELSE
	INSERT INTO Catalogo 
		(
			Clave 
			,Nombre
			,Descripcion
			,IdTipoCatalogo
			,IdUsuarioCreacion
			,IdUsuarioUltimoModifico
			,FechaCreacion
			,FechaModificacion
            ,IdEmpresa
		)
		VALUES
		(
			pClave
			,pNombre
			,pDescripcion
			,pIdTipoCatalogo
			,pIdUsuarioLog
			,pIdUsuarioLog
			,now()
			,now()
            ,pIdEmpresa
		);
        
        SELECT MAX(IdCatalogo) from Catalogo;
        END IF;
END$$

DELIMITER ;
USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ActCatalogo`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCatalogo`(`pClave` VARCHAR(12), `pIdUsuarioLog` INT, `pIdCatalogo` INT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(256), `pIdTipoCatalogo` SMALLINT, `pEsActivo` TINYINT, `pIdEmpresa` INT)
BEGIN
	IF((SELECT COUNT(*) FROM Catalogo WHERE Clave = pClave AND IdTipoCatalogo = pIdTipoCatalogo AND IdCatalogo!=pIdCatalogo) != 0) THEN
        SELECT-1;
	ELSE
		UPDATE Catalogo
			SET 
				Clave = pClave
				,Nombre = pNombre
				,Descripcion = pDescripcion
				,IdTipoCatalogo = pIdTipoCatalogo
				,EsActivo = pEsActivo
				,FechaModificacion = now()
				,IdUsuarioUltimoModifico = pIdUsuarioLog
			WHERE
			IdCatalogo = pIdCatalogo
			and IdEmpresa = pIdEmpresa;
			select 0;
	END IF;
END$$

DELIMITER ;


 