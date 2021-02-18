DROP Procedure ActVacante;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActVacante`(IN `pIdVacante` INT, IN `pTitulo` VARCHAR(100), IN `pSubTitulo` VARCHAR(100), IN `pDescripcion` VARCHAR(100), IN `pFechaContratacion` DATE, IN `pNumeroVacantes` INT(11), IN `pSalario` DOUBLE, IN `pIdTipoContrato` INT(11), IN `pIdCliente` INT, IN `pIdTipoJornada` INT(11), IN `pIdCiudad` VARCHAR(20), IN `pIdUsuarioUltimoModifico` INT(11), IN `pEstatus` TINYINT(4), IN `pComentarios` VARCHAR(300), IN `pIdEmpresa` INT(11), IN `pFase` VARCHAR(90), IN `pFechaEntrega` DATE, IN `pDetalles` VARCHAR(500))
BEGIN
SET @SQL = pDetalles;
  IF(
    SELECT COUNT(1)
    FROM reclutamiento.vacante
    WHERE vacante.Titulo= pTitulo
      AND vacante.descripcion=pDescripcion
      AND vacante.FechaContratacion = pFechaContratacion
      AND vacante.NumeroVacantes=pNumeroVacantes
      AND vacante.Salario=pSalario
      AND vacante.IdTipoContrato=pIdTipoContrato
      AND vacante.IdTipoJornada=pIdTipoJornada
      AND vacante.IdCiudad=pIdCiudad
      AND vacante.FechaEntrega=pFechaEntrega
      AND vacante.idEmpresa =pIdEmpresa
      AND vacante.Estatus=pEstatus
    )!=0 
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
	vacante.FechaEntrega=pFechaEntrega,
    vacante.SubTitulo = pSubTitulo,
    vacante.IdCliente = pIdCliente
      WHERE
        IdVacante=pIdVacante AND IdEmpresa=pIdEmpresa;
	PREPARE stmt1 
	FROM @SQL;
	EXECUTE stmt1;
    deallocate prepare stmt1;
    SELECT NULL AS ErrorMessage;
  END IF;
END ;;