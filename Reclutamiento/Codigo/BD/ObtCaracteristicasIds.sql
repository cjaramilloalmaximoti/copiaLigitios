USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ObtCaracteristicasIds`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasIds`(
	IN `pIdCaracteristicas` VARCHAR(5000))
BEGIN
###### test: call ObtCaracteristicasIds('226,227');
SET @SQL = Concat( '
	SELECT
    IdCaracteristica 
    , Nombre
    from caracteristicas
	where IdCaracteristica in (', pIdCaracteristicas, ')');
    PREPARE stmt1 
	FROM @SQL;
	EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
    END$$

DELIMITER ;