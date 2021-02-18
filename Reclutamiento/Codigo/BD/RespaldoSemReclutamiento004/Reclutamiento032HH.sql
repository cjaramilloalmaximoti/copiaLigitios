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
				AND categoria.Estatus between pDesde and pHasta;
                -- AND categoria.IdEmpresa = pIdEmpresa;
END$$

DELIMITER ;

USE `reclutamiento`;
DROP procedure IF EXISTS `ObtCaracteristicasPorProspecto`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasPorProspecto`(
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
				-- and cat.IdEmpresa = pIdEmpresa
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
DROP procedure IF EXISTS `ObtCaracteristicasPorCategoria`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasPorCategoria`(
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
				prospectocaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdProspecto= pIdProspecto
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
				prospectocaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdProspecto= pIdProspecto
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

