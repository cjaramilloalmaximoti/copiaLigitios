-- ============================================= 	
 -- Nombre: SP InsVacante,actVacantes, buscarVAcantes,obtContratosTipo, ObtJornadasTipo 
 -- Fecha de Creación: 12/03/2018
 -- Objetivo: Insertar el registro de usuarios. 
 -- Desarrollador: Armando Herrera
 -- ============================================= 
 

-- Insert -- 
USE `reclutamiento`;
DROP procedure IF EXISTS `InsVacante`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante`(


IN `pTitulo`  VARCHAR(100),
IN `pDescripcion` VARCHAR(1024),
IN `pFechaContratacion` TIMESTAMP,
IN `pNumeroVacantes` INT(11),
IN `pSalario` DOUBLE,
IN `pIdTipoContrato` INT(11),
IN `pIdTipoJornada` INT(11),
IN `pIdCiudad` INT(11),
IN `pIdUsuarioCreacion` INT(11),
IN `pIdUsuarioUltimoModifico` INT(11),
IN `pEstatus` TINYINT(4),
IN `pIdEmpresa` INT(11),
IN `pFase`  VARCHAR(900),
IN `pFechaEntrega`  DATETIME
	)
BEGIN

DECLARE pIdVacante int;
		INSERT INTO reclutamiento.vacante 
		(
			vacante.Titulo,
			vacante.Descripcion,
			vacante.FechaContratacion,
			vacante.NumeroVacantes,
			vacante.Salario, 
			vacante.IdTipoContrato,
			vacante.IdTipoJornada, 
			vacante.IdCiudad, 
			vacante.IdUsuarioCreacion,
			vacante.FechaCreacion,
			vacante.IdUsuarioUltimoModifico,
			vacante.FechaModificacion,
			vacante.Estatus, 
			vacante.IdEmpresa, 
			vacante.Fase,
			vacante.FechaEntrega
		)
			values
		(
			pTitulo,
			pDescripcion,
			pFechaContratacion,
			pNumeroVacantes,
			pSalario, 
			pIdTipoContrato,
			pIdTipoJornada, 
			pIdCiudad, 
			pIdUsuarioCreacion,
			NOW(),
			pIdUsuarioUltimoModifico,
			NOW(),
			pEstatus, 
			pIdEmpresa,
			pFase, 
			pFechaEntrega
		);
	SET pIdVacante= (SELECT MAX(IdVacante) FROM reclutamiento.vacante);
	SELECT NULL AS ErrorMessage, pIdVacante as IdVacante;
END$$

DELIMITER ;

-- 
-- Actualizar 
USE `reclutamiento`;
DROP procedure IF EXISTS `ActVacante`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActVacante`(
IN `pIdVacante` INT,
IN `pTitulo`  VARCHAR(100),
IN `pDescripcion` VARCHAR(100),
IN `pFechaContratacion` DATE,
IN `pNumeroVacantes` INT(11),
IN `pSalario` DOUBLE,
IN `pIdTipoContrato` INT(11),
IN `pIdTipoJornada` INT(11),
IN `pIdCiudad` INT(11),
IN `pIdUsuarioUltimoModifico` INT(11),
IN `pEstatus` TINYINT(4),
IN `pIdEmpresa` INT (11),
IN `pFase`  VARCHAR(90),
IN `pFechaEntrega`  DATE
)
BEGIN

	IF(
			SELECT COUNT(1)
			FROM reclutamiento.vacante
			WHERE vacante.Titulo= pTitulo
			AND vacante.descripcion=pDescripcion
			AND vacante.FechaContratacion= pFechaContratacion
			AND vacante.NumeroVacantes=pNumeroVacantes
			AND vacante.Salario=pSalario
			AND vacante.IdTipoContrato=pIdTipoContrato
			AND vacante.IdTipoJornada=pIdTipoJornada
			AND vacante.IdCiudad=pIdCiudad
			AND vacante.FechaEntrega=pFechaEntrega
			AND vacante.idEmpresa =pIdEmpresa
			AND vacante.Estatus=pEstatus)!=0 
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
				vacante.Fase= pFase, 
				vacante.FechaEntrega=pFechaEntrega
			WHERE 
				IdVacante=pIdVacante
			AND 
				IdEmpresa=pIdEmpresa;

	SELECT NULL AS ErrorMessage;

END IF;

END$$

DELIMITER ;

--
-- Obtener Vacantes


USE `reclutamiento`;
DROP procedure IF EXISTS `ObtVacantes`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtVacantes`(
	IN `pIdEmpresa` int,
	IN `pEstatus` tinyInt ,
	IN 	`pTitulo` varchar(100) ,
	IN 	`pIdTipoContrato` tinyInt ,
	IN 	`pIdTipoJornada` tinyInt 
)
BEGIN
	IF pTitulo is not null and  pEstatus >= 0 and pIdTipoContrato > 0 and pIdTipoJornada > 0  THEN 
			  SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
				AND vacante.Estatus=pEstatus
				AND 	vacante.Titulo LIKE CONCAT('%', pTitulo, '%')
				AND vacante.IdTipoContrato= pIdTipoContrato
				AND vacante.IdTipoJornada=pIdTipoJornada;

ELSEIF pTitulo is not null AND pEstatus < 0 and pIdTipoContrato < 0 and pIdTipoJornada < 0   THEN 

	SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Titulo LIKE CONCAT('%', pTitulo, '%');		


ELSEIF pTitulo is not null AND pEstatus < 0 and pIdTipoContrato < 0 and pIdTipoJornada > 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Titulo LIKE CONCAT('%', pTitulo, '%')
			AND 	vacante.IdTipoJornada = pIdTipoJornada;


 ELSEIF  pTitulo is not null  AND pEstatus < 0 and pIdTipoContrato > 0 and pIdTipoJornada > 0  THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Titulo=pTitulo
			AND  	vacante.IdTipoContrato=pIdTipoContrato
			AND 	vacante.IdTipoJornada = pIdTipoJornada;



 ELSEIF  pTitulo is not null AND pEstatus >= 0 and pIdTipoContrato < 0 and pIdTipoJornada < 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Titulo LIKE CONCAT('%', pTitulo, '%')
			AND		vacante.Estatus=pEstatus;							

ELSEIF  pTitulo is not null AND pEstatus >= 0 and pIdTipoContrato < 0 and pIdTipoJornada > 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Titulo LIKE CONCAT('%', pTitulo, '%')
			AND		vacante.Estatus=pEstatus
			AND  	vacante.IdTipoJornada=pIdTipoJornada;

						
ELSEIF  pTitulo is not null AND pEstatus >= 0 and pIdTipoContrato > 0 and pIdTipoJornada < 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Titulo=pTitulo
			AND 	vacante.Titulo LIKE CONCAT('%', pTitulo, '%')
			AND  	vacante.IdTipoContrato=pIdTipoContrato;

ELSEIF  pTitulo is null AND  pEstatus < 0 and pIdTipoContrato < 0 and pIdTipoJornada > 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND  	vacante.IdTipoJornada=pIdTipoJornada;
								
				
ELSEIF  pTitulo is null AND  pEstatus < 0 and pIdTipoContrato > 0 and pIdTipoJornada > 0 THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND		vacante.IdTipoContrato=pIdTipoContrato
			AND  	vacante.IdTipoJornada=pIdTipoJornada; 



ELSEIF  pTitulo is null AND  pEstatus >= 0 and pIdTipoContrato > 0 and pIdTipoJornada > 0  THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Estatus=pEstatus
			AND		vacante.IdTipoContrato=pIdTipoContrato
			AND  	vacante.IdTipoJornada=pIdTipoJornada; 

	
ELSEIF  pTitulo is null AND  pEstatus >= 0 and pIdTipoContrato < 0 and pIdTipoJornada < 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Estatus=pEstatuS;


ELSEIF pTitulo is null AND  pEstatus < 0 and pIdTipoContrato > 0 and pIdTipoJornada < 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND		vacante.IdTipoContrato=pIdTipoContrato;
			

ELSEIF 	pTitulo is null AND  pEstatus < 0 and pIdTipoContrato < 0 and pIdTipoJornada < 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa;

ELSEIF 	pIdEmpresa > 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa;
	END IF;
			
END$$

DELIMITER ;



--
-- ObtenerContratosTipo
USE `reclutamiento`;
DROP procedure IF EXISTS `ObtContratosTipo`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtContratosTipo`(
IN `pIdEmpresa` INT(11),
IN `pIdTipoCatalogo` int(11)
)
BEGIN
	
SELECT 
		 catalogo.IdCatalogo, catalogo.Nombre
 FROM 	reclutamiento.catalogo
WHERE  			catalogo.IdEmpresa=pIdEmpresa
		AND 	catalogo.IdTipocatalogo=pIdTipocatalogo
		AND 	catalogo.EsActivo=1;

END$$

DELIMITER ;

--
-- ObtenerJornadasTipo
USE `reclutamiento`;
DROP procedure IF EXISTS `ObtJornadasTipo`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtJornadasTipo`(
IN `pIdEmpresa` INT(11),
IN `pIdTipoCatalogo`int(11)

)
BEGIN

SELECT 
		 catalogo.IdCatalogo, catalogo.Nombre
 FROM 	reclutamiento.catalogo
WHERE  			catalogo.IdEmpresa=pIdEmpresa
		AND 	catalogo.IdTipocatalogo=pIdTipoCatalogo
		AND 	catalogo.EsActivo=1;

END$$

DELIMITER ;



INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (10,'Reclutamiento013AH','Armando Herrera','20181203','Modificar unas tablas de vacantes , agregar porcedimientos de vacantes');



