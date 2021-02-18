-- ============================================= 	
 -- Nombre: SP [Reclutamiento 022AH] 
 -- Fecha de Creación: 26/03/2018
 -- Objetivo: Sps insertar, actualizar y obtener Categorias
 -- Desarrollador: Armando Herrera
 -- ============================================= 
 
 
 
USE reclutamiento; 


DROP TABLE IF EXISTS `categoria`;

CREATE TABLE `categoria` (
  `IdCategoria` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) DEFAULT NULL,
  `FechaCreacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioCreacion` int(11) DEFAULT NULL,
  `FechaModificacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioUltimoModifico` int(11) DEFAULT NULL,
  `Estatus` tinyint(4) DEFAULT NULL,
  `IdEmpresa` int(11) DEFAULT NULL,
  PRIMARY KEY (`IdCategoria`),
  UNIQUE KEY `IdCategoria_UNIQUE` (`IdCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='IdCategoria';



-- Actualizar

USE `reclutamiento`;
DROP procedure IF EXISTS `ActCategoria`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCategoria`(
	IN pIdCategoria int(11),
	IN pNombre VARCHAR(100),
	IN pIdUsuarioUltimoModifico INT(11),
	IN pEstatus TINYINT(4),
	IN pIdEmpresa INT(11)
)
BEGIN
UPDATE categoria
SET 
		categoria.Nombre =pNombre,
		categoria.IdUsuarioUltimoModifico= pIdUsuarioUltimoModifico,
		categoria.Estatus = pEstatus,
		categoria.IdEmpresa = pIdEmpresa
WHERE 
		categoria.IdCategoria= pIdCategoria;

SELECT NULL AS ErrorMessage;

END$$

DELIMITER ;


 -- Insertar
 USE `reclutamiento`;
DROP procedure IF EXISTS `InsCategoria`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCategoria`(
	IN pNombre VARCHAR(100),
	IN pIdUsuarioCreacion INT(11),
	IN pEstatus TINYINT(4),
	IN pIdEmpresa INT(11)
)
BEGIN

	DECLARE pidCategoria INT(11);

	IF (SELECT COUNT(1)
			FROM reclutamiento.categoria
			WHERE 
				categoria.Nombre=pNombre
				AND categoria.IdEmpresa= pIdEmpresa
				AND categoria.Estatus=pEstatus
		)!=0 THEN 
			SELECT 'Error al insertar: La categoria que intenta guardar ya esta siendo utilizada o no tiene cambios .' as ErrorMessage;
		
	ELSE 
		INSERT INTO reclutamiento.categoria
			(
				categoria.Nombre,
				categoria.FechaCreacion,
				categoria.IdUsuarioCreacion,
				categoria.FechaModificacion,

				categoria.IdUsuarioUltimoModifico,
				categoria.Estatus,
				categoria.IdEmpresa
			)	
			VALUES 
			(
				pNombre,
				NOW(),
				pIdUsuarioCreacion,
				NOW(),
				pIdUsuarioCreacion,
				pEstatus, 
				pIdEmpresa
			);

			SET pidCategoria= (SELECT MAX(IdCategoria) FROM reclutamiento.categoria);
			SELECT  NULL AS ErrorMessage, pidCategoria as IdCategoria;

		END IF ;
END$$

DELIMITER ;

-- Obtener

USE `reclutamiento`;
DROP procedure IF EXISTS `ObtCategorias`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCategorias`(
IN 	`pNombre` varchar(100) ,
IN `pIdEmpresa` int (11),
IN `pEstatus` tinyInt 
)
BEGIN

IF pNombre IS NULL THEN SET pNombre=''; END IF;

IF pEstatus < 0 THEN
			SELECT 
				categoria.Idcategoria,
				categoria.Nombre,
				categoria.Estatus,
				categoria.FechaCreacion
			FROM 
				reclutamiento.categoria
			WHERE 
				categoria.idEmpresa= pIdEmpresa
			AND 
				categoria.Nombre LIKE CONCAT('%', pNombre, '%');
			
	ELSE 

		SELECT 
				categoria.Idcategoria,
				categoria.Nombre,
				categoria.Estatus,
				categoria.FechaCreacion
			FROM 
				reclutamiento.categoria
			WHERE 
				categoria.idEmpresa= pIdEmpresa
			AND 
				categoria.Nombre LIKE CONCAT('%', pNombre, '%')
			AND 
				categoria.Estatus = pEstatus;
END IF;
	
END$$

DELIMITER ;


-- Obtener CategoriasTipo

USE `reclutamiento`;
DROP procedure IF EXISTS `ObtCategoriasTipo`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCategoriasTipo`(
IN `pIdEmpresa` INT(11)
)
BEGIN
SELECT 
	categoria.IdCategoria,
	categoria.Nombre
FROM  
	reclutamiento.categoria
WHERE      
	categoria.IdEmpresa=pIdEmpresa
AND 
	categoria.Estatus=1;

END$$

DELIMITER ;

set @forma = 'Categorias';
set @formaLink = 'Categorias';
set @formaAccion = 'Categorias_Index';
set @formaControlador = 'Categorias';
set @id = (select idForma from Forma Where ClaveCodigo = @forma);

delete from formapermiso where idForma = @id;
delete from formaRol where idForma = @id;
delete from forma where idforma = @id;

insert into Forma(ClaveCodigo, Nombre, EsOpcionMenu, Estatus, IdFormaPadre, TextoLink, Accion, Controlador
	, EsDropdown, Orden, IdUsuarioCreacion,FechaCreacion, IdUsuarioUltimoModifico,FechaModificacion
	, OrigenOperacion, Descripcion, IdEmpresa, EsSuperAdministrador
)
values(
	@forma
	, @forma
	, 1, 1
	, 2
	, @formaLink
	, @formaAccion
	, @formaControlador
	, 0, 4, 1, now(), 1, now(), 1, '(Administracion) Forma correspondiente a Vacantes', 1, 0
	);

 
 
 
 
 INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (22,'Reclutamiento024AH','Armando Herrera',CURDATE() ,'Crea Tabla Categoria ');