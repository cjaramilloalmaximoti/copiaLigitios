USE `directma_reclutamiento`;
DROP procedure IF EXISTS `ObtCaracteristicasValores`;

DELIMITER $$
USE `directma_reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasValores`(
	IN `pIdCaracteristicas` VARCHAR(5000))
BEGIN
###### test call ObtCaracteristicasValores('226,227,28')
	SET @SQL = Concat( '
    SELECT pc.IdProspecto, group_concat(c.Nombre, ";", pc.valor) valores FROM 
	prospectocaracteristica pc
	inner join
	caracteristicas c
	on c.IdCaracteristica = pc.IdCaracteristicaParticular
	where pc.IdCaracteristicaParticular in (',pIdCaracteristicas,')
	group by pc.IdProspecto');
     PREPARE stmt1 
	FROM @SQL;
	EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
    END$$

DELIMITER ;

