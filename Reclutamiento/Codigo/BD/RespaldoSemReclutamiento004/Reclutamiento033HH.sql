USE `reclutamiento`;


DROP procedure IF EXISTS `ProcedimientoTemporal`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcedimientoTemporal`()
BEGIN 
  
	IF EXISTS (	SELECT 1 
					FROM 
						INFORMATION_SCHEMA.COLUMNS 
					WHERE 
						TABLE_NAME='vacantecaracteristica' 
                        AND column_name='Comentario') then
	BEGIN 
		ALTER TABLE `reclutamiento`.`vacantecaracteristica` 
		DROP COLUMN `Activo`,
		DROP COLUMN `Comentario`,
		CHANGE COLUMN `Valor` `Valor` VARCHAR(1024) NOT NULL AFTER `IdCaracteristicaParticular`;
	END;
    END IF;
    
    IF NOT EXISTS (	SELECT 1 
					FROM 
						INFORMATION_SCHEMA.COLUMNS 
					WHERE 
						TABLE_NAME='clientedocumentos' 
                        AND column_name='NombreOriginal') then
	BEGIN 
		ALTER TABLE `reclutamiento`.`clientedocumentos` 
		ADD COLUMN `NombreOriginal` VARCHAR(150) NULL DEFAULT NULL AFTER `Idempresa`;
        
		ALTER TABLE `reclutamiento`.`prospectodocumentos` 
		ADD COLUMN `NombreOriginal` VARCHAR(150) NULL DEFAULT NULL AFTER `Idempresa`;

	END;
    END IF;
  
END$$

DELIMITER ;

CALL ProcedimientoTemporal;
DROP procedure IF EXISTS `ProcedimientoTemporal`;



USE `reclutamiento`;
DROP procedure IF EXISTS `ObtCaracteristicasVacantePorCategoria`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasVacantePorCategoria`
(
	pIdsCategorias varchar(8000)
    , pIdEmpresa INT
    , pIdVacante INT
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
				-- and cat.IdEmpresa = pIdEmpresa
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
				vacantecaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdVacante= pIdVacante
		WHERE
			-- caract.IdEmpresa = pIdEmpresa
			caract.EsActivo = 1
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
				-- and cat.IdEmpresa = pIdEmpresa
				and cat.Estatus = 1
			inner join 
				tipocontrol tipControl
			on
				tipControl.IdTipoControl = caract.IdTipoControl
			left join 
				vacantecaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdVacante= pIdVacante
		WHERE
			-- caract.IdEmpresa = pIdEmpresa
			caract.EsActivo = 1
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
DROP procedure IF EXISTS `InsVacanteCaracteristica`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacanteCaracteristica`
(
	pIdVacante INT
    , pIdCaracteristicaParticular INT
    , pValor varchar(1024)
)
BEGIN
	
    if not exists(
					select 1 
                    from 
						vacantecaracteristica 
					where 
						IdVacante = pIdVacante 
                        and IdCaracteristicaParticular = pIdCaracteristicaParticular
				 ) then
	begin    
		INSERT INTO vacantecaracteristica
				( IdVacante
				 , IdCaracteristicaParticular
				 , Valor
				)
		VALUES  (
				 pIdVacante
				 , pIdCaracteristicaParticular
				 , pValor
				);
	end;
    else
    begin
		UPDATE vacantecaracteristica
        SET Valor = pValor
        WHERE
			IdVacante = pIdVacante 
			and IdCaracteristicaParticular = pIdCaracteristicaParticular;
    end;
	end if;

    
END$$

DELIMITER ;




USE `reclutamiento`;
DROP procedure IF EXISTS `ObtCaracteristicasPorVacante`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasPorVacante`
(
    pIdEmpresa INT
    , pIdVacante INT
)
BEGIN

		SELECT
			-- cat.IdCategoria,
			valor.IdVacanteCaracteristica as IdProspectoCaracteristica
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
				-- and cat.IdEmpresa = pIdEmpresa
				and cat.Estatus = 1
			inner join 
				tipocontrol tipControl
			on
				tipControl.IdTipoControl = caract.IdTipoControl
			inner join 
				vacantecaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdVacante= pIdVacante
		WHERE
			-- caract.IdEmpresa = pIdEmpresa
			caract.EsActivo = 1
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
DROP procedure IF EXISTS `EliVacanteCaracteristica`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliVacanteCaracteristica`
(
	`pIdVacanteCaracteristica` INT
)
BEGIN
	
    DELETE from vacantecaracteristica where IdVacanteCaracteristica = pIdVacanteCaracteristica;
    
END$$

DELIMITER ;


USE `reclutamiento`;
DROP procedure IF EXISTS `InsDocsCliente`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsDocsCliente`(IN `pIdCliente` INT, IN `pIdDocumento` INT, IN `pNombre` VARCHAR(150), IN `pUrl` VARCHAR(250), IN `pEstatus` TINYINT, IN `pIdUsuarioLog` INT, IN `pIdEmpresa` INT, IN `pNombreOriginal` VARCHAR(150))
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
		IdUsuarioModificacion, FechaModificacion, IdEmpresa, NombreOriginal
	  ) VALUES ( 
		pIdCliente, pIdDocumento, pNombre, pUrl, pEstatus, PIdUsuarioLog, now(), 
		pIdUsuarioLog, now(), pIdEmpresa, pNombreOriginal
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
        , NombreOriginal = pNombreOriginal
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


USE `reclutamiento`;
DROP procedure IF EXISTS `InsDocsProspecto`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsDocsProspecto`(IN `pIdProspecto` INT, IN `pIdDocumento` INT, IN `pNombre` VARCHAR(150), IN `pUrl` VARCHAR(250), IN `pEstatus` TINYINT, IN `pIdUsuarioLog` INT, IN `pIdEmpresa` INT, IN `pNombreOriginal` VARCHAR(150))
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
		IdUsuarioModificacion, FechaModificacion, IdEmpresa, NombreOriginal
	  ) VALUES ( 
		pIdProspecto, pIdDocumento, pNombre, pUrl, pEstatus, PIdUsuarioLog, now(), 
		pIdUsuarioLog, now(), pIdEmpresa, pNombreOriginal
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
        , NombreOriginal = pNombreOriginal
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

USE `reclutamiento`;
DROP procedure IF EXISTS `ObtDocsCliente`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDocsCliente`(IN `pIdCliente` INT, IN `pIdEmpresa` INT)
BEGIN	
	SELECT
	   c.IdCliente as IdCliente,
	   c.IdDocumento as IdDocumento,
	   c.Nombre as Nombre,
	   c.Url as Url,
	   c.IdEmpresa as Idempresa,
	   cat.Nombre as DescDocumento,
	   c.Id,
       c.NombreOriginal
	FROM clientedocumentos c, catalogo cat
	where (c.IdDocumento = cat.IdCatalogo) 
	  AND
	  c.IdCliente = pIdCliente AND c.IdEmpresa = pIdEmpresa;

END$$

DELIMITER ;


USE `reclutamiento`;
DROP procedure IF EXISTS `ObtDocsProspecto`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDocsProspecto`(IN `pIdProspecto` INT, IN `pIdEmpresa` INT)
BEGIN	
	SELECT
	   p.IdProspecto as IdProspecto,
	   p.IdDocumento as IdDocumento,
	   p.Nombre as Nombre,
	   p.Url as Url,
	   p.IdEmpresa as Idempresa,
	   cat.Nombre as DescDocumento,
	   p.Id,
       p.NombreOriginal
	FROM prospectodocumentos p, catalogo cat
	where (p.IdDocumento = cat.IdCatalogo) 
	  AND
	  p.IdProspecto = pIdProspecto AND p.IdEmpresa = pIdEmpresa;

END$$

DELIMITER ;

