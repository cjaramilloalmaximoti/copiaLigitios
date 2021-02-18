-- ----------------------------
-- Table structure for vacante_prospecto
-- ----------------------------
DROP TABLE IF EXISTS `vacante_prospecto`;
CREATE TABLE `vacante_prospecto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idvacante` int(11) NOT NULL,
  `idProspecto` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idvacante` (`idvacante`),
  KEY `idProspecto` (`idProspecto`)
) ENGINE=MyISAM AUTO_INCREMENT=196 DEFAULT CHARSET=latin1;


ALTER TABLE vacante ADD SubTitulo VARCHAR(100);
ALTER TABLE vacante ADD IdCliente int;
ALTER TABLE vacante ADD IdFuentePublicacion int;


-- ----------------------------
-- Procedure structure for ActVacante
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActVacante`;
DELIMITER ;;
CREATE PROCEDURE `ActVacante`(IN `pIdVacante` INT, IN `pTitulo` VARCHAR(100),IN `pSubTitulo` VARCHAR(100), IN `pDescripcion` VARCHAR(100), IN `pFechaContratacion` DATE, IN `pNumeroVacantes` INT(11), IN `pSalario` DOUBLE, IN `pIdTipoContrato` INT(11), IN `pIdCliente` INT(11), IN `pIdTipoJornada` INT(11), IN `pIdCiudad` VARCHAR(20), IN `pIdUsuarioUltimoModifico` INT(11), IN `pEstatus` TINYINT(4), IN `pComentarios` VARCHAR(300), IN `pIdEmpresa` INT(11), IN `pFase` VARCHAR(90), IN `pFechaEntrega` DATE
, in `pDetalles` MEDIUMTEXT)
BEGIN
START TRANSACTION;
	

  IF(
    SELECT COUNT(1)
 
    FROM reclutamiento.vacante
 
    WHERE vacante.Titulo= pTitulo
 
      AND vacante.SubTitulo=pSubTitulo

			AND vacante.descripcion=pDescripcion
 
      AND vacante.FechaContratacion = pFechaContratacion
 
      AND vacante.NumeroVacantes=pNumeroVacantes

      AND vacante.Salario=pSalario
			
      AND vacante.IdTipoContrato=pIdTipoContrato

			AND vacante.IdCliente=pIdCliente
			
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
			  vacante.SubTitulo=pSubTitulo,
        vacante.Descripcion=pDescripcion,
	vacante.FechaContratacion=pFechaContratacion,
	vacante.NumeroVacantes=pNumeroVacantes,
	vacante.Salario=pSalario,
	vacante.IdTipoContrato=pIdTipoContrato,
	vacante.IdCliente=pIdCliente,
	vacante.IdTipoJornada=pIdTipoJornada,
	vacante.IdCiudad=pIdCiudad,
	vacante.IdUsuarioUltimoModifico=pIdUsuarioUltimoModifico,

	vacante.FechaModificacion = now(),
	vacante.Estatus= pEstatus,
	vacante.Comentarios=pComentarios,
	vacante.Fase= pFase,
	vacante.FechaEntrega=pFechaEntrega
      WHERE
        IdVacante=pIdVacante AND IdEmpresa=pIdEmpresa;



    SELECT NULL AS ErrorMessage;

  END IF;

/* Eliminar los registros Detalles*/

        delete from vacante_fuente where idvacante = pIdVacante;


      /* Iniciar a insertar en tabla detalles  */

      -- set @sql = replace(pDetalles, 'idValor', pIdCaracteristica) ;

      set @sql = pDetalles;

      prepare stmt1 from @sql;

      execute stmt1;

      SELECT null as ErrorMessage;

COMMIT;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsVacante
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsVacante`;
DELIMITER ;;
CREATE PROCEDURE `InsVacante`(IN `pTitulo` VARCHAR(100),IN `pSubTitulo` VARCHAR(100), IN `pDescripcion` VARCHAR(100), IN `pFechaContratacion` TIMESTAMP, IN `pNumeroVacantes` INT(11), IN `pSalario` DOUBLE, IN `pIdTipoContrato` INT(11), IN `pIdCliente` INT(11), IN `pIdTipoJornada` INT(11), IN `pIdCiudad` VARCHAR(20), IN `pIdUsuarioCreacion` INT(11), IN `pIdUsuarioUltimoModifico` INT(11), IN `pEstatus` TINYINT(4), IN `pComentarios` VARCHAR(300), IN `pIdEmpresa` INT(11), IN `pFase` INT(11),
 IN `pFechaEntrega` DATETIME, in `pDetalles` MEDIUMTEXT)
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
	SET pIdVacante= (SELECT MAX(IdVacante) FROM reclutamiento.vacante);

	SELECT NULL AS ErrorMessage, pIdVacante as IdVacante;
        
        /* Iniciar a insertar en tabla detalles  */
        set @sql = replace(pDetalles, 'idValor', pIdVacante) ;
        
            prepare stmt1 from @sql;
            execute stmt1; 

	
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtProsVacante
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtProsVacante`;
DELIMITER ;;
CREATE PROCEDURE `ObtProsVacante`(IN `pIdVacante` INT, IN `pIdEmpresa` INT)
BEGIN
	
	SELECT
	   p.IdProspecto as IdProspecto,
	   CONCAT(p.Nombre,' ', p.Apellidos) as NombreCompleto,
	   p.Nombre as Nombre,
	   p.Apellidos as Apellidos,
           p.FechaNacimiento as FechaNacimiento,
	   p.RFC as RFC,
	   p.Email as Email,
           p.TelefonoMovil as TelefonoMovil,
	   p.TelefonoOtro as TelefonoOtro,
           p.Clave_Colonia as Clave_Colonia,
           p.CP as CP,
	   p.Direccion as Direccion,
	   p.Salario as Salario,
	   p.IdSexo as IdSexo, 
           cSexo.Nombre as NombreSexo,
	   p.IdEstadoCivil as IdEstadoCivil,
           cEC.Nombre as NombreEstadoCivil,
	   p.IdEscolaridad as IdEscolaridad,   
           cEsco.Nombre as NombreEscolaridad,
	   p.Estatus as Estatus,
	   p.Comentario,
       p.NivelIngles,
	   colonia.Nombre as NombreColonia,
	   (Select MAX(bitacora.FechaCreacion) FROM bitacora WHERE bitacora.IdProspecto = p.IdProspecto) as FechaContacto,
       p.foto
	FROM prospecto p inner JOIN vacante_prospecto vp on p.IdProspecto = vp.IdProspecto left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
    	  left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
          left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo
	  left join colonia on (p.Clave_Colonia = colonia.Clave_colonia
			AND p.CP = Colonia.CodigoPostal 
		)
	where vp.IdVacante = pIdVacante
		AND p.IdEmpresa = pIdEmpresa;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtProspectosPorCaracteristicas
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtProspectosPorCaracteristicas`;
DELIMITER ;;
CREATE PROCEDURE `ObtProspectosPorCaracteristicas`(IN `pIdEmpresa` INT, IN `ParametrosXML` VARCHAR(65535))
BEGIN

	/* -----------------------------------------
   *** Como llamar el SP 
   -----------------------------------------

		SET @ParametrosXML = '
		<Parametros>
			<Parametro>
				<IdCaracteristicaParticular>31</IdCaracteristicaParticular>
				<Valor>Alto</Valor>
			</Parametro>
			<Parametro>
				<IdCaracteristicaParticular>28</IdCaracteristicaParticular>
				<Valor>true</Valor>
			</Parametro>
		</Parametros>';


		SET @pIdSexo = NULL;

		SET @pIdEstadoCivil = NULL;

		SET @pIdEscolaridad = NULL;

		SET @pEdadMin = 20;

		SET @pEdadMax = 30;

		CALL ObtProspectosPorCaracteristicas (1 ,@ParametrosXML ,@pIdSexo, @pIdEstadoCivil, @pIdEscolaridad, @pEdadMin, @pEdadMax);*/


	SET @COUNT = (SELECT EXTRACTVALUE (ParametrosXML,'COUNT(/Parametros/Parametro)'));	
	SET @SQL_EXTERNO = 'SELECT
	   p.IdProspecto as IdProspecto,
	   CONCAT(p.Nombre,'' ' ''', p.Apellidos) as NombreCompleto,
	   p.Nombre as Nombre,
	   p.Apellidos as Apellidos,
           p.FechaNacimiento as FechaNacimiento,
	   p.RFC as RFC,
	   p.Email as Email,
           p.TelefonoMovil as TelefonoMovil,
	   p.TelefonoOtro as TelefonoOtro,
           p.Clave_Colonia as Clave_Colonia,
           p.CP as CP,
	   p.Direccion as Direccion,
	   p.Salario as Salario,
	   p.IdSexo as IdSexo, 
           cSexo.Nombre as NombreSexo,
	   p.IdEstadoCivil as IdEstadoCivil,
           cEC.Nombre as NombreEstadoCivil,
	   p.IdEscolaridad as IdEscolaridad,   
           cEsco.Nombre as NombreEscolaridad,
	   p.Estatus as Estatus,
	   p.Comentario,
       p.NivelIngles,
	   colonia.Nombre as NombreColonia,
	   (Select MAX(bitacora.FechaCreacion) FROM bitacora WHERE bitacora.IdProspecto = p.IdProspecto) as FechaContacto,
       p.foto
	FROM prospecto p inner JOIN vacante_prospecto vp on p.IdProspecto = vp.IdProspecto left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
    	  left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
          left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo
	  left join colonia on (p.Clave_Colonia = colonia.Clave_colonia
			AND p.CP = Colonia.CodigoPostal 
		)
	where p.IdEmpresa = ';
  SET @SQL_EXTERNO = concat( @SQL_EXTERNO, CONVERT ( pIdEmpresa, CHAR ) );	
	SET @SQL_EXTERNO = concat( @SQL_EXTERNO, ' AND p.IdProspecto = ' );	
	SET @SQL_INTERNO = '(SELECT 	DISTINCT P.IdProspecto
											FROM 		prospecto P ';
	SET @I = 1;
	WHILE (@I <= @COUNT) DO
		SET @SQL_INTERNO = concat( @SQL_INTERNO, ' INNER 	JOIN prospectocaracteristica PC',@I,' ON P.IdProspecto = PC',@I,'.IdProspecto' );
		SET @I = @I + 1;
	END	WHILE;

	SET @SQL_INTERNO = concat( @SQL_INTERNO, ' WHERE		P.IdEmpresa = ' );		
	SET @SQL_INTERNO = concat( @SQL_INTERNO, CONVERT ( pIdEmpresa, CHAR ) );	
	SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND p.Estatus = 1 ' );	

	-- if(pIdSexo != -1) then
	-- 	SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND p.IdSexo = ',pIdSexo,' ');	
	-- end if;

	-- if(pIdEstadoCivil != -1) then
	-- 	SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND p.IdEstadoCivil = ',pIdEstadoCivil,' ');	
	-- end if;

	-- if(pIdEscolaridad != -1) then
	-- 	SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND p.IdEscolaridad = ',pIdEscolaridad,' ');	
	-- end if;

	-- if(pEdadMin != -1) then
	-- 	SET @sEdad = concat( ' AND CEILING((((365 * YEAR(CURDATE())) - (365 * (YEAR(FechaNacimiento)))) + (MONTH(CURDATE()) - MONTH(FechaNacimiento)) * 30 + (DAY(CURDATE()) - DAY(FechaNacimiento))) / 365) >= ',pEdadMin,' ');	
	-- end if;

	-- if(pEdadMax != -1) then
	-- 	SET @sEdad = concat( ' AND CEILING((((365 * YEAR(CURDATE())) - (365 * (YEAR(FechaNacimiento)))) + (MONTH(CURDATE()) - MONTH(FechaNacimiento)) * 30 + (DAY(CURDATE()) - DAY(FechaNacimiento))) / 365) <= ',pEdadMax,' ');	
	-- end if;

	-- if(pEdadMin != -1 and pEdadMax != -1) then
	-- 	SET @sEdad = concat( ' AND CEILING((((365 * YEAR(CURDATE())) - (365 * (YEAR(FechaNacimiento)))) + (MONTH(CURDATE()) - MONTH(FechaNacimiento)) * 30 + (DAY(CURDATE()) - DAY(FechaNacimiento))) / 365) BETWEEN ',pEdadMin,' and ',pEdadMax,' ');	
	-- end if;

	-- SET @SQL_INTERNO = concat( @SQL_INTERNO, @sEdad);	

	SET @I = 1;
	WHILE (@I <= @COUNT) DO
		SET @IdCaracteristicaParticular = EXTRACTVALUE (@ParametrosXML,CONCAT('/Parametros/Parametro[',@I,']/IdCaracteristicaParticular'));
		
		SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND PC',@I,'.IdCaracteristicaParticular = ',@IdCaracteristicaParticular,' ' );

		SET @COUNT_VALOR =  (SELECT EXTRACTVALUE (ParametrosXML,CONCAT('COUNT(/Parametros/Parametro[',@I,']/Valor)')));	

		SET @I_VALOR = 1;
		SET @COMA = '';
		SET @COMILLAS = '''';
		SET @Valor = '';
		WHILE (@I_VALOR <= @COUNT_VALOR) DO
			SET @Valor_S = EXTRACTVALUE (@ParametrosXML,CONCAT('/Parametros/Parametro[',@I,']/Valor[',@I_VALOR,']'));
			SET @Valor = concat(@Valor,@COMA,@COMILLAS,@Valor_S,@COMILLAS);
			SET @COMA = ',';
		SET @I_VALOR = @I_VALOR + 1;
		END	WHILE;

		SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND PC',@I,'.Valor IN (',@Valor,') ' );		
		SET @I = @I + 1;
	END	WHILE;

	SET @SQL = concat(@SQL_EXTERNO, @SQL_INTERNO, ')');
	-- SELECT @SQL;
	PREPARE stmt1 
	FROM @SQL;
	EXECUTE stmt1;

END
;;
DELIMITER ;