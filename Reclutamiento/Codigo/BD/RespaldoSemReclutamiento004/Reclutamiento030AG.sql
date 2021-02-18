DROP PROCEDURE IF EXISTS `ActCaracteristicas`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCaracteristicas`(
  
  IN `pIdEmpresa` INT, 
  
  IN `pIdCaracteristica` INT, 
  
  IN `pNombre` VARCHAR(200), 
  
  IN `pDescripcion` VARCHAR(200), 
  
  IN `pTipoCampo` VARCHAR(50), 
  
  IN `pAprobada` TINYINT(1), 
  
  IN `pComentario` VARCHAR(250), 
 
  IN `pIdUsuarioLog` INT, 
  
  IN `pEsActivo` TINYINT(1),
  
  in `pDetalles` MEDIUMTEXT

)
BEGIN
  START TRANSACTION;

    SET autocommit = 0;

    UPDATE caracteristicas

    SET 
      Nombre = pNombre,

      Descripcion = pDescripcion,

      TipoCampo = pTipoCampo,

      Aprobada = pAprobada,

      Comentario = IFNULL(pComentario,''),

      IdUsuarioModificacion = pIdUsuarioLog,

      FechaModificacion = now(),

      EsActivo = pEsActivo

    WHERE 
      IdCaracteristica = pIdCaracteristica;
      -- and IdEmpresa = pIdEmpresa;


      /* Eliminar los registros Detalles*/

        delete from caracteristica_categoria where idCaracteristica = pIdCaracteristica;


      /* Iniciar a insertar en tabla detalles  */

      -- set @sql = replace(pDetalles, 'idValor', pIdCaracteristica) ;

      set @sql = pDetalles;

      prepare stmt1 from @sql;

      execute stmt1;

      SELECT null as ErrorMessage;
COMMIT;
END$$
DELIMITER ;