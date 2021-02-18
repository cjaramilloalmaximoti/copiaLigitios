DROP PROCEDURE InsVacante;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante`(IN `pTitulo` VARCHAR(100), IN `pSubTitulo` VARCHAR(100), IN `pDescripcion` VARCHAR(100), IN `pFechaContratacion` TIMESTAMP, IN `pNumeroVacantes` INT(11), IN `pSalario` DOUBLE, IN `pIdTipoContrato` INT(11), IN `pIdCliente` INT, IN `pIdTipoJornada` INT(11), IN `pIdCiudad` VARCHAR(20), IN `pIdUsuarioCreacion` INT(11), IN `pIdUsuarioUltimoModifico` INT(11), IN `pEstatus` TINYINT(4), IN `pComentarios` VARCHAR(300), IN `pIdEmpresa` INT(11), IN `pFase` INT(11), IN `pFechaEntrega` DATETIME, IN `pDetalles` VARCHAR(500))
BEGIN
DECLARE pIdVacante int;
		INSERT INTO reclutamiento.vacante 
		(
			vacante.Titulo,
			vacante.SubTitulo,
			vacante.Descripcion,
			vacante.FechaContratacion,
			vacante.NumeroVacantes,
			vacante.Salario, 
			vacante.IdTipoContrato,
			vacante.IdCliente,
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
			pSubTitulo,
			pDescripcion,
			pFechaContratacion,
			pNumeroVacantes,
			pSalario, 
			pIdTipoContrato,
			pIdCliente,
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
    IF (pDetalles != null) THEN
    SET @SQL = pDetalles;
	PREPARE stmt1 
	FROM @SQL;
	EXECUTE stmt1;
    deallocate prepare stmt1;
    END IF;
    SET pIdVacante= (SELECT MAX(IdVacante) FROM reclutamiento.vacante);
	SELECT NULL AS ErrorMessage, pIdVacante as IdVacante;
END ;;	