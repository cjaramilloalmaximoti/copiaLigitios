-- ----------------------------
-- Procedure structure for ObtProspectosPorCaracteristicas
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtProspectosPorCaracteristicas`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectosPorCaracteristicas`(IN `pIdEmpresa` INT, IN `ParametrosXML` VARCHAR(65535), IN `pIdSexo` INT, IN `pIdEstadoCivil` INT, IN `pIdEscolaridad` INT, IN `pEdadMin` INT, IN `pEdadMax` INT)
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
	SET @SQL = 'SELECT 	DISTINCT P.IdProspecto, P.Nombre, P.Apellidos
							FROM 		prospecto P ';
	SET @I = 1;
	WHILE (@I <= @COUNT) DO
		SET @SQL = concat( @SQL, ' INNER 	JOIN prospectocaracteristica PC',@I,' ON P.IdProspecto = PC',@I,'.IdProspecto' );
		SET @I = @I + 1;
	END	WHILE;

	SET @SQL = concat( @SQL, ' WHERE		P.IdEmpresa = ' );		
	SET @SQL = concat( @SQL, CONVERT ( pIdEmpresa, CHAR ) );	
	SET @SQL = concat( @SQL, ' AND p.Estatus = 1 ' );	

	if(pIdSexo != -1) then
		SET @SQL = concat( @SQL, ' AND p.IdSexo = ',pIdSexo,' ');	
	end if;

	if(pIdEstadoCivil != -1) then
		SET @SQL = concat( @SQL, ' AND p.IdEstadoCivil = ',pIdEstadoCivil,' ');	
	end if;

	if(pIdEscolaridad != -1) then
		SET @SQL = concat( @SQL, ' AND p.IdEscolaridad = ',pIdEscolaridad,' ');	
	end if;

	if(pEdadMin != -1) then
		SET @sEdad = concat( ' AND CEILING((((365 * YEAR(CURDATE())) - (365 * (YEAR(FechaNacimiento)))) + (MONTH(CURDATE()) - MONTH(FechaNacimiento)) * 30 + (DAY(CURDATE()) - DAY(FechaNacimiento))) / 365) >= ',pEdadMin,' ');	
	end if;

	if(pEdadMax != -1) then
		SET @sEdad = concat( ' AND CEILING((((365 * YEAR(CURDATE())) - (365 * (YEAR(FechaNacimiento)))) + (MONTH(CURDATE()) - MONTH(FechaNacimiento)) * 30 + (DAY(CURDATE()) - DAY(FechaNacimiento))) / 365) <= ',pEdadMax,' ');	
	end if;

	if(pEdadMin != -1 and pEdadMax != -1) then
		SET @sEdad = concat( ' AND CEILING((((365 * YEAR(CURDATE())) - (365 * (YEAR(FechaNacimiento)))) + (MONTH(CURDATE()) - MONTH(FechaNacimiento)) * 30 + (DAY(CURDATE()) - DAY(FechaNacimiento))) / 365) BETWEEN ',pEdadMin,' and ',pEdadMax,' ');	
	end if;

	SET @SQL = concat( @SQL, @sEdad);	

	SET @I = 1;
	WHILE (@I <= @COUNT) DO
		SET @IdCaracteristicaParticular = EXTRACTVALUE (@ParametrosXML,CONCAT('/Parametros/Parametro[',@I,']/IdCaracteristicaParticular'));
		
		SET @SQL = concat( @SQL, ' AND PC',@I,'.IdCaracteristicaParticular = ',@IdCaracteristicaParticular,' ' );

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

		SET @SQL = concat( @SQL, ' AND PC',@I,'.Valor IN (',@Valor,') ' );		
		SET @I = @I + 1;
	END	WHILE;

	-- SELECT @COUNT_VALOR;
	-- SELECT @SQL;
	PREPARE stmt1 
	FROM @SQL;
	EXECUTE stmt1;

END