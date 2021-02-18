USE `reclutamiento`;
DROP procedure IF EXISTS `InsDocsProspecto`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsDocsProspecto`(IN `pIdProspecto` INT, IN `pIdDocumento` INT, IN `pNombre` VARCHAR(150), IN `pUrl` VARCHAR(250), IN `pEstatus` TINYINT, IN `pIdUsuarioLog` INT, IN `pIdEmpresa` INT)
BEGIN 
  DECLARE pId INT; 
  DECLARE pValidacion INT;
  
  SET pValidacion = (
						SELECT 
							count(1) 
						FROM 
							prospectodocumentos
						WHERE
							IdEmpresa = pIdEmpresa
                            and IdProspecto = pIdProspecto
                            and IdDocumento = pIdDocumento
					);
                    
  if pValidacion = 0 then
  begin
	  INSERT INTO prospectodocumentos ( 
		IdProspecto, IdDocumento, Nombre, Url, Estatus, IdUsuarioCreacion, FechaCreacion,
		IdUsuarioModificacion, FechaModificacion, IdEmpresa
	  ) VALUES ( 
		pIdProspecto, pIdDocumento, pNombre, pUrl, pEstatus, PIdUsuarioLog, now(), 
		pIdUsuarioLog, now(), pIdEmpresa
	  ); 
  end;
  else
  begin
	UPDATE prospectodocumentos
	SET
		Nombre = pNombre
        , Url = pUrl
        , Estatus = pEstatus
        , IdUsuarioModificacion = PIdUsuarioLog
        , FechaModificacion = now()
	WHERE
		IdEmpresa = pIdEmpresa
		and IdProspecto = pIdProspecto
		and IdDocumento = pIdDocumento; 
  end;
  end if;

  set pId = 1; 
  SELECT null as ErrorMessage, pIdDocumento as Id; 
END$$

DELIMITER ;

DROP procedure IF EXISTS `InsDocsCliente`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsDocsCliente`(IN `pIdCliente` INT, IN `pIdDocumento` INT, IN `pNombre` VARCHAR(150), IN `pUrl` VARCHAR(250), IN `pEstatus` TINYINT, IN `pIdUsuarioLog` INT, IN `pIdEmpresa` INT)
BEGIN 
  DECLARE pId INT; 
  DECLARE pValidacion INT;
  
  SET pValidacion = (
						SELECT 
							count(1) 
						FROM 
							clientedocumentos
						WHERE
							IdEmpresa = pIdEmpresa
                            and IdCliente = pIdCliente
                            and IdDocumento = pIdDocumento
					);

  if pValidacion = 0 then
  begin
	  INSERT INTO clientedocumentos ( 
		IdCliente, IdDocumento, Nombre, Url, Estatus, IdUsuarioCreacion, FechaCreacion,
		IdUsuarioModificacion, FechaModificacion, IdEmpresa
	  ) VALUES ( 
		pIdCliente, pIdDocumento, pNombre, pUrl, pEstatus, PIdUsuarioLog, now(), 
		pIdUsuarioLog, now(), pIdEmpresa
	  ); 
  end;
  else
  begin
	UPDATE clientedocumentos
	SET
		Nombre = pNombre
        , Url = pUrl
        , Estatus = pEstatus
        , IdUsuarioModificacion = PIdUsuarioLog
        , FechaModificacion = now()
	WHERE
		IdEmpresa = pIdEmpresa
		and IdCliente = pIdCliente
		and IdDocumento = pIdDocumento; 
  end;
  end if;

  set pId = 1; 
  SELECT null as ErrorMessage, pIdDocumento as Id; 
END$$

DELIMITER ;

DROP TABLE IF EXISTS `tipocontrol`;
CREATE TABLE `reclutamiento`.`tipocontrol` (
  `IdTipoControl` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(50) NOT NULL,
  `Orden` SMALLINT(10) NOT NULL,
  `FormatoControl` VARCHAR(50) NULL,
  `NumeroDecimales` int NULL,
  `Requerido` tinyint(1) NOT NULL DEFAULT '1',
  
  UNIQUE INDEX `idTipoControl_UNIQUE` (`IdTipoControl` ASC),
  PRIMARY KEY (`IdTipoControl`));

INSERT INTO `reclutamiento`.`tipocontrol` (`Nombre`, `Orden`, `FormatoControl`) VALUES ('Fecha', '1', 'dd/MM/yyyy');
INSERT INTO `reclutamiento`.`tipocontrol` (`Nombre`, `Orden`) VALUES ('Título', '2');
INSERT INTO `reclutamiento`.`tipocontrol` (`Nombre`, `Orden`, `NumeroDecimales`) VALUES ('Entero', '3', 0);
INSERT INTO `reclutamiento`.`tipocontrol` (`Nombre`, `Orden`, `NumeroDecimales`) VALUES ('Moneda', '4', 2);
INSERT INTO `reclutamiento`.`tipocontrol` (`Nombre`, `Orden`) VALUES ('Dicotómico', '5');
INSERT INTO `reclutamiento`.`tipocontrol` (`Nombre`, `Orden`) VALUES ('Opcional', '6');
INSERT INTO `reclutamiento`.`tipocontrol` (`Nombre`, `Orden`) VALUES ('Párrafo', '7');



DROP procedure IF EXISTS `ProcedimientoTemporal`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcedimientoTemporal`()
BEGIN 
  
	IF NOT EXISTS (	SELECT 1 
					FROM 
						INFORMATION_SCHEMA.COLUMNS 
					WHERE 
						TABLE_NAME='caracteristicas' 
                        AND column_name='IdTipoControl') then
	BEGIN 
		ALTER TABLE `reclutamiento`.`caracteristicas` 
		ADD COLUMN `IdTipoControl` INT NOT NULL DEFAULT 1 AFTER `Descripcion`;
	END;
    END IF;
    
    IF EXISTS (	SELECT 1 
				FROM 
					INFORMATION_SCHEMA.COLUMNS 
				WHERE 
					TABLE_NAME='caracteristicas' 
					AND column_name='TipoCampo') then
	BEGIN 
		UPDATE caracteristicas
        SET
			IdTipoControl = CASE 
								WHEN TipoCampo = 'Dicotomico' then 5
                                WHEN TipoCampo = 'Opcional' then 6
                                WHEN TipoCampo = 'Titulo' then 1
                                WHEN TipoCampo = 'Parrafo' then 7
                                WHEN TipoCampo = 'Entero' then 2
                                WHEN TipoCampo = 'Moneda' then 3
							END
		WHERE 
			IdCaracteristica != 0;
		ALTER TABLE `reclutamiento`.`caracteristicas` DROP COLUMN TipoCampo;
	END;
    END IF;
  
END$$

DELIMITER ;

CALL ProcedimientoTemporal;
DROP procedure IF EXISTS `ProcedimientoTemporal`;


USE `reclutamiento`;
DROP procedure IF EXISTS `ActCaracteristicas`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCaracteristicas`(
  
  IN `pIdEmpresa` INT, 
  
  IN `pIdCaracteristica` INT, 
  
  IN `pNombre` VARCHAR(200), 
  
  IN `pDescripcion` VARCHAR(200), 
  
  IN `pIdTipoControl` INT, 
  
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

      IdTipoControl = pIdTipoControl,

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


USE `reclutamiento`;
DROP procedure IF EXISTS `InsCaracteristicas`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCaracteristicas`(IN `pIdEmpresa` INT, IN `pNombre` VARCHAR(200), IN `pDescripcion` VARCHAR(200), IN `pIdTipoControl` INT, IN `pAprobada` TINYINT(1), IN `pComentario` VARCHAR(250), IN `pIdUsuarioLog` INT, IN `pCodigoGenerado` VARCHAR(10), IN `pDetalles` VARCHAR(250))
BEGIN
	DECLARE pIdCaracteristica INT;
   
	/*Manejo error SQL Exception*/ 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN 
		SELECT 1 as error; 
	ROLLBACK; 
	END; 

	/*Manejo Warning SQL	*/ 
	DECLARE EXIT HANDLER FOR SQLWARNING 
	BEGIN 
		SELECT 1 as error; 
	ROLLBACK; 
	END; 

	START TRANSACTION;
    SET autocommit = 0;
    
		IF (SELECT COUNT(1)
			from caracteristicas 
			where	Nombre = pNombre 
					AND IdEmpresa = pIdEmpresa) != 0 THEN
			SELECT 'Error al insertar: La caracteristica ya esta siendo utilizado.' as ErrorMessage;
		ELSE
		
		INSERT INTO caracteristicas
		(
			Nombre,
			Descripcion,
			IdTipoControl,
			Aprobada,
			Comentario,
			IdUsuarioCreacion,
			FechaCreacion,
			IdUsuarioModificacion,
			FechaModificacion,
			IdEmpresa,
			EsActivo,
            CodigoGenerado
		)
		VALUES
		(
			pNombre,
			pDescripcion,
			pIdTipoControl,
			pAprobada,
			IFNULL(pComentario, ''),
			pIdUsuarioLog,
			now(),
			pIdUsuarioLog,
			now(),
			pIdEmpresa,
			1,
            pCodigoGenerado
		);
        
		set pIdCaracteristica = (SELECT MAX(IdCaracteristica) from caracteristicas);
		SELECT null as ErrorMessage, pIdCaracteristica as IdCaracteristica;
        
        /* Iniciar a insertar en tabla detalles  */
        set @sql = replace(pDetalles, 'idValor', pIdCaracteristica) ;
        
            prepare stmt1 from @sql;
            execute stmt1; 
        
		END IF;
    COMMIT;
END$$

DELIMITER ;




ALTER TABLE `reclutamiento`.`prospectocaracteristica` 
CHANGE COLUMN `IdCaracteristicaParticular` `IdCaracteristicaParticular` INT(11) NOT NULL AFTER `IdProspecto`,
CHANGE COLUMN `IdProspecto` `IdProspecto` INT(11) NOT NULL ,
CHANGE COLUMN `Valor` `Valor` VARCHAR(1024) NOT NULL ;




USE `reclutamiento`;
DROP procedure IF EXISTS `ObtCategorias`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCategorias`(IN `pNombre` VARCHAR(100), IN `pIdEmpresa` INT(11), IN `pEstatus` TINYINT)
BEGIN
	Declare pDesde tinyint;
	Declare pHasta tinyint;	
        
	if(pEstatus = -1) then
		SET pDesde = 0;
		SET pHasta = 1;
	else
		SET pDesde = pEstatus;
		SET pHasta = pEstatus;
	end if;

		SELECT 
				categoria.Idcategoria,
				categoria.Nombre,
				categoria.Estatus,
				categoria.FechaCreacion
		FROM 
				reclutamiento.categoria
		WHERE 
                ( categoria.Nombre like concat('%', IFNULL(pNombre, ''), '%')) 
				AND categoria.Estatus between pDesde and pHasta
                AND categoria.IdEmpresa = pIdEmpresa;
END$$

DELIMITER ;





USE `reclutamiento`;
DROP procedure IF EXISTS `ObtCaracteristicasPorCategoria`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasPorCategoria`
(
	pIdsCategorias varchar(8000)
    , pIdEmpresa INT
    , pIdProspecto INT
)
BEGIN 
  
	create temporary table pT_Categorias( IdCategoria int );
    
    if  IFNULL(pIdsCategorias, '') != '' then
    begin
		set @sql = concat("insert into pT_Categorias (IdCategoria) values ('", replace((pIdsCategorias), ",", "'),('"),"');");
		prepare stmt1 from @sql;
		execute stmt1;
        
        SELECT
			-- cat.IdCategoria,
			caract.IdCaracteristica as IdCaracteristicaParticular
			-- , cat.Nombre as Categoria
			, caract.Nombre as Caracteristica
			, tipControl.Nombre as Control
			, tipControl.FormatoControl
			, tipControl.NumeroDecimales
			, tipControl.Requerido
			, valor.Valor                
		FROM
			caracteristicas caract
			inner join 
				caracteristica_categoria carac_cat
			on
				carac_cat.idcaracteristica = caract.idcaracteristica
			inner join 
				categoria cat
			on
				cat.IdCategoria = carac_cat.IdCategoria
				and cat.IdEmpresa = pIdEmpresa
				and cat.Estatus = 1
			inner join 
				pT_Categorias caractFiltro
			on
				caractFiltro.IdCategoria = cat.IdCategoria
			inner join 
				tipocontrol tipControl
			on
				tipControl.IdTipoControl = caract.IdTipoControl
			left join 
				prospectocaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdProspecto= pIdProspecto
		WHERE
			caract.IdEmpresa = pIdEmpresa
			and caract.EsActivo = 1
			and caract.Aprobada = 1
		group by
			caract.IdCaracteristica
		ORDER BY
			 -- cat.Nombre
			 -- , 
             tipControl.Orden
			 , caract.Nombre;
        
    end;
    else
    begin
		SELECT
			-- cat.IdCategoria,
			caract.IdCaracteristica as IdCaracteristicaParticular
			-- , cat.Nombre as Categoria
			, caract.Nombre as Caracteristica
			, tipControl.Nombre as Control
			, tipControl.FormatoControl
			, tipControl.NumeroDecimales
			, tipControl.Requerido
			, valor.Valor                
		FROM
			caracteristicas caract
			inner join 
				caracteristica_categoria carac_cat
			on
				carac_cat.idcaracteristica = caract.idcaracteristica
			inner join 
				categoria cat
			on
				cat.IdCategoria = carac_cat.IdCategoria
				and cat.IdEmpresa = pIdEmpresa
				and cat.Estatus = 1
			inner join 
				tipocontrol tipControl
			on
				tipControl.IdTipoControl = caract.IdTipoControl
			left join 
				prospectocaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdProspecto= pIdProspecto
		WHERE
			caract.IdEmpresa = pIdEmpresa
			and caract.EsActivo = 1
			and caract.Aprobada = 1
		group by
			caract.IdCaracteristica
		ORDER BY
			 -- cat.Nombre
			 -- , 
             tipControl.Orden
			 , caract.Nombre;
    end;
    end if;
    
    DROP TEMPORARY TABLE pT_Categorias;
END$$

DELIMITER ;



USE `reclutamiento`;
DROP procedure IF EXISTS `ObtCatalogoCtrlCaracteristica`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCatalogoCtrlCaracteristica`
(
	`pIdCaracteristicaParticular` INT
    , `pIdEmpresa` INT
)
BEGIN
	
    select 'Nulo' as IdReferencia, 'Nulo' as Nombre 
    union
    select 'Mínimo' as IdReferencia, 'Mínimo' as Nombre 
    union
    select 'Regular' as IdReferencia, 'Regular' as Nombre 
    union
    select 'Alto' as IdReferencia, 'Alto' as Nombre 
    union
    select 'Avanzado' as IdReferencia, 'Avanzado' as Nombre;

    
END$$

DELIMITER ;




USE `reclutamiento`;
DROP procedure IF EXISTS `InsProspectoCaracteristica`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsProspectoCaracteristica`
(
	pIdProspecto INT
    , pIdCaracteristicaParticular INT
    , pValor varchar(1024)
)
BEGIN
	
    if not exists(
					select 1 
                    from 
						prospectocaracteristica 
					where 
						IdProspecto = pIdProspecto 
                        and IdCaracteristicaParticular = pIdCaracteristicaParticular
				 ) then
	begin    
		INSERT INTO prospectocaracteristica
				( IdProspecto
				 , IdCaracteristicaParticular
				 , Valor
				)
		VALUES  (
				 pIdProspecto
				 , pIdCaracteristicaParticular
				 , pValor
				);
	end;
    else
    begin
		UPDATE prospectocaracteristica
        SET Valor = pValor
        WHERE
			IdProspecto = pIdProspecto 
			and IdCaracteristicaParticular = pIdCaracteristicaParticular;
    end;
	end if;

    
END$$

DELIMITER ;





USE `reclutamiento`;
DROP procedure IF EXISTS `ObtCaracteristicasPorProspecto`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasPorProspecto`
(
    pIdEmpresa INT
    , pIdProspecto INT
)
BEGIN

		SELECT
			-- cat.IdCategoria,
			valor.IdProspectoCaracteristica
            ,caract.IdCaracteristica as IdCaracteristicaParticular
			-- , cat.Nombre as Categoria
			, caract.Nombre as Caracteristica
			, tipControl.Nombre as Control
			, tipControl.FormatoControl
			, tipControl.NumeroDecimales
			, tipControl.Requerido
            , valor.Valor
			, case 	when tipControl.Nombre = 'Dicotómico' and valor.Valor = 'true' then 'Si'
					when tipControl.Nombre = 'Dicotómico' and valor.Valor != 'true' then 'No'
					else valor.Valor
			  end as ValorColumna
		FROM
			caracteristicas caract
			inner join 
				caracteristica_categoria carac_cat
			on
				carac_cat.idcaracteristica = caract.idcaracteristica
			inner join 
				categoria cat
			on
				cat.IdCategoria = carac_cat.IdCategoria
				and cat.IdEmpresa = pIdEmpresa
				and cat.Estatus = 1
			inner join 
				tipocontrol tipControl
			on
				tipControl.IdTipoControl = caract.IdTipoControl
			inner join 
				prospectocaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdProspecto= pIdProspecto
		WHERE
			caract.IdEmpresa = pIdEmpresa
			and caract.EsActivo = 1
			and caract.Aprobada = 1
		group by
			caract.IdCaracteristica
		ORDER BY
			 -- cat.Nombre
			 -- , 
             tipControl.Orden
			 , caract.Nombre;
    
END$$

DELIMITER ;



USE `reclutamiento`;
DROP procedure IF EXISTS `EliProspectoCaracteristica`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliProspectoCaracteristica`
(
	`pIdProspectoCaracteristica` INT
)
BEGIN
	
    DELETE from prospectocaracteristica where IdProspectoCaracteristica = pIdProspectoCaracteristica;
    
END$$

DELIMITER ;