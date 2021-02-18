
-- ----------------------------
-- Procedure structure for ObtProspectosPorCaracteristicas
-- ----------------------------
/*
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

		CALL ObtProspectosPorCaracteristicas (1 ,@ParametrosXML ,@pIdSexo, @pIdEstadoCivil, @pIdEscolaridad, @pEdadMin, @pEdadMax);
*/

DROP PROCEDURE IF EXISTS `ObtProspectosPorCaracteristicas`;
DELIMITER ;;
CREATE PROCEDURE `ObtProspectosPorCaracteristicas`(IN `pIdEmpresa` INT, IN `ParametrosXML` VARCHAR(65535),IN `pIdSexo` INT,IN `pIdEstadoCivil` INT,IN `pIdEscolaridad` INT,IN `pEdadMin` INT,IN `pEdadMax` INT)
BEGIN
	SET @pXML = REPLACE(ParametrosXML,'[','<');
	SET @pXML = REPLACE(@pXML,']','>');

	SET @COUNT = (SELECT EXTRACTVALUE (@pXML,'COUNT(/Parametros/Parametro)'));	
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

/*
	if(pIdSexo != 0) then
	SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND p.IdSexo = ',pIdSexo,' ');	
	end if;

	if(pIdEstadoCivil != 0) then
	SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND p.IdEstadoCivil = ',pIdEstadoCivil,' ');	
	end if;

	if(pIdEscolaridad != 0) then
	SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND p.IdEscolaridad = ',pIdEscolaridad,' ');	
	end if;

	if(pEdadMin != 0) then
	SET @sEdad = concat( ' AND CEILING((((365 * YEAR(CURDATE())) - (365 * (YEAR(FechaNacimiento)))) + (MONTH(CURDATE()) - MONTH(FechaNacimiento)) * 30 + (DAY(CURDATE()) - DAY(FechaNacimiento))) / 365) >= ',pEdadMin,' ');	
	end if;

	if(pEdadMax != 0) then
	SET @sEdad = concat( ' AND CEILING((((365 * YEAR(CURDATE())) - (365 * (YEAR(FechaNacimiento)))) + (MONTH(CURDATE()) - MONTH(FechaNacimiento)) * 30 + (DAY(CURDATE()) - DAY(FechaNacimiento))) / 365) <= ',pEdadMax,' ');	
	end if;

	if(pEdadMin != 0 and pEdadMax != -1) then
	SET @sEdad = concat( ' AND CEILING((((365 * YEAR(CURDATE())) - (365 * (YEAR(FechaNacimiento)))) + (MONTH(CURDATE()) - MONTH(FechaNacimiento)) * 30 + (DAY(CURDATE()) - DAY(FechaNacimiento))) / 365) BETWEEN ',pEdadMin,' and ',pEdadMax,' ');	
	end if;

	SET @SQL_INTERNO = concat( @SQL_INTERNO, @sEdad);	
*/

	SET @I = 1;
	WHILE (@I <= @COUNT) DO
		SET @IdCaracteristicaParticular = EXTRACTVALUE (@pXML,CONCAT('/Parametros/Parametro[',@I,']/IdCaracteristicaParticular'));
		
		SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND PC',@I,'.IdCaracteristicaParticular = ',@IdCaracteristicaParticular,' ' );

		SET @COUNT_VALOR =  (SELECT EXTRACTVALUE (@pXML,CONCAT('COUNT(/Parametros/Parametro[',@I,']/Valor)')));	

		SET @I_VALOR = 1;
		SET @COMA = '';
		SET @COMILLAS = '''';
		SET @Valor = '';
		WHILE (@I_VALOR <= @COUNT_VALOR) DO
			SET @Valor_S = EXTRACTVALUE (@pXML,CONCAT('/Parametros/Parametro[',@I,']/Valor[',@I_VALOR,']'));
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
