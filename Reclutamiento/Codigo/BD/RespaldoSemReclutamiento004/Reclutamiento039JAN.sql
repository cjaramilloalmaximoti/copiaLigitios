USE reclutamiento;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS ObtProspectosPorCaracteristicas;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectosPorCaracteristicas`(IN `pIdEmpresa` INT, IN `ParametrosXML` VARCHAR(65535),IN `pIdSexo` INT,IN `pIdEstadoCivil` INT,IN `pIdEscolaridad` INT,IN `pEdadMin` INT,IN `pEdadMax` INT, IN `pIdVacante` INT)
BEGIN

	SET @pXML = REPLACE(ParametrosXML,'[','<');

	SET @pXML = REPLACE(@pXML,']','>');



	SET @COUNT = (SELECT EXTRACTVALUE (@pXML,'COUNT(/Parametros/Parametro)'));	

	SET @SQL_EXTERNO = concat('SELECT

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

       p.foto,
       (select count(*) FROM vacante_prospecto WHERE idvacante=', CONVERT(pIdVacante, CHAR) ,' and IdProspecto = p.IdProspecto and Estatus > 0) > 0 Seleccionado

	FROM prospecto p left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo

    	  left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo

          left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo

		  left join colonia on (p.Clave_Colonia = colonia.Clave_colonia

		  AND p.CP = Colonia.CodigoPostal 

		)

	where p.Estatus > 0 and p.IdEmpresa = ');

    SET @SQL_EXTERNO = concat( @SQL_EXTERNO, CONVERT ( pIdEmpresa, CHAR ) );

	SET @SQL_EXTERNO = concat( @SQL_EXTERNO, ' AND p.IdProspecto IN ' );	

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
$$

DELIMITER ;

DROP PROCEDURE IF EXISTS ObtProsVacante;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProsVacante`(IN `pIdVacante` INT, IN `pIdEmpresa` INT)
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

       p.foto,
	   vp.Finalista,
	   vp.Invitaciones

	FROM prospecto p 
    inner JOIN vacante_prospecto vp on p.IdProspecto = vp.IdProspecto
    left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo

    left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo

    left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo

	left join colonia on (p.Clave_Colonia = colonia.Clave_colonia

			AND p.CP = Colonia.CodigoPostal 

	)

	where vp.Estatus > 0 and vp.IdVacante = pIdVacante

		AND p.IdEmpresa = pIdEmpresa;

END
$$

DELIMITER ;

DROP PROCEDURE IF EXISTS InsVacante_Prospecto;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante_Prospecto`(IN `pIdVacante` INT, IN `pDetalles` MEDIUMTEXT)
BEGIN

DECLARE _list MEDIUMTEXT DEFAULT NULL;
DECLARE _next TEXT DEFAULT NULL;
DECLARE _nextlen INT DEFAULT NULL;
DECLARE _value TEXT DEFAULT NULL;

START TRANSACTION ; 

	SET _list = pDetalles;

	iterator:
	LOOP

        -- Sale del clico Loop si la cadena se queda vacia o es nula.
		-- Esta validación es necesaria para salir del ciclo loop.
		IF LENGTH(TRIM(_list)) = 0 OR _list IS NULL THEN
			LEAVE iterator;
		END IF;
		
		-- Obtiene la siguiente instrucción de la cadena.
		SET _next = SUBSTRING_INDEX(_list,';',1);
		
		-- Guarda el tamaño del texto en la cadena para despues eliminarlo.
		SET _nextlen = LENGTH(_next);
		
		-- Asignar el texto al comando a ejecutar.
		SET @SQL = TRIM(_next); 
		
		PREPARE stmt1 FROM @SQL; 

		EXECUTE stmt1; 

		DEALLOCATE PREPARE stmt1;
		
		-- Reescribe en la cadena original, reemplazando por nada para quitar el texto
		-- ya ejecutado.
		-- Los argumentos son:
	    -- Cadena original, posición inicial, cuántos caracteres a remover y 
		-- que caracter usarás para reemplazar, en este caso 
		-- un caracter en blanco, que remueve el tamaño del texto + 1;
		SET _list = INSERT(_list,1,_nextlen + 1,'');
		
	END LOOP iterator;

	SELECT NULL AS ErrorMessage; 

COMMIT;

END
$$

DELIMITER ;

DROP PROCEDURE IF EXISTS InsVacante_ProspectoActivo;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante_ProspectoActivo`(IN `pIdVacante` INT, IN `pIdProspecto` INT)
BEGIN
	SET @id = (SELECT id FROM vacante_prospecto WHERE idvacante = pIdVacante and idprospecto = pIdProspecto LIMIT 1);
	IF @id is null  THEN
		insert into vacante_prospecto (IdVacante, IdProspecto, Estatus) values (pIdVacante, pIdProspecto, 1);
    ELSE
		update vacante_prospecto set Estatus = 1 WHERE id = @id;
	END if;
END
$$

DELIMITER ;

DROP PROCEDURE IF EXISTS InsVacante_ProspectoFinalista;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante_ProspectoFinalista`(IN `pIdVacante` INT, IN `pIdProspecto` INT, IN `pFinalista` TINYINT(1))
BEGIN
	
	UPDATE Vacante_Prospecto SET Finalista = pFinalista
	WHERE Idvacante = pIdVacante and IdProspecto = pIdProspecto;
	
	SELECT NULL AS ErrorMessage; 
END
$$

DELIMITER ;

DROP PROCEDURE IF EXISTS InsVacante_ProspectoInvitado;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante_ProspectoInvitado`(IN `pIdVacante` INT, IN `pIdProspecto` INT)
BEGIN
	
	UPDATE Vacante_Prospecto SET Invitaciones = Invitaciones + 1
	WHERE Idvacante = pIdVacante and IdProspecto = pIdProspecto;
	
	SELECT NULL AS ErrorMessage;
END
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS EliVacante_Prospecto;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EliVacante_Prospecto`(IN `pIdVacante` INT, IN `pIdProspecto` INT)
BEGIN
	
	UPDATE Vacante_Prospecto SET ESTATUS = 0
	WHERE Idvacante = pIdVacante and IdProspecto = pIdProspecto;
	
	SELECT ROW_COUNT() as Registros_Afectados;
END
$$

DELIMITER ;

DROP TRIGGER IF EXISTS trigger_vacante_prospecto;

DELIMITER $$

CREATE TRIGGER trigger_vacante_prospecto
BEFORE INSERT ON vacante_prospecto
FOR EACH ROW 
   BEGIN
		IF(SELECT 1 FROM vacante_prospecto WHERE idvacante = NEW.idvacante and idprospecto = NEW.idprospecto LIMIT 1) THEN
			signal sqlstate '45000' SET MESSAGE_TEXT = 'El prospecto ya esta registrado!';
		END if;
   END;
$$

DELIMITER ;

ALTER TABLE vacante_prospecto ADD Estatus TINYINT(1) DEFAULT 1;
ALTER TABLE vacante_prospecto ADD Invitaciones INT DEFAULT 0;
ALTER TABLE vacante_prospecto ADD Finalista TINYINT(1) DEFAULT 0;