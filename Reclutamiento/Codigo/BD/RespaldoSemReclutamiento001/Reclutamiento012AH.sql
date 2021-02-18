
-- ============================================= 	
 -- Nombre: Actualiza Vacante 
--			Fases . Contratos Jornadas
 -- Fecha de Creación: 09/03/2018
 -- Objetivo: Insertar el registro de usuarios. 
 -- Desarrollador: Armando Herrera
 -- Fecha Ult. Modificación: 09/03/2018 
 -- Test:  
 -- ============================================= 


--  1  Nuew procs 

USE `reclutamiento`;
DROP procedure IF EXISTS `ObtContratosTipo`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtContratosTipo`(
IN `pIdEmpresa` INT(11),
IN `pClave` varchar(60)
)
BEGIN
	
SELECT 
		 catalogo.IdCatalogo, catalogo.Nombre
 FROM 	reclutamiento.catalogo
WHERE  			catalogo.IdEmpresa=pIdEmpresa
		AND 	catalogo.Clave=pClave
		AND 	catalogo.EsActivo=1;

END$$

DELIMITER ;


--- 2 

USE `reclutamiento`;
DROP procedure IF EXISTS `ObtJornadasTipo`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtJornadasTipo`(
IN `pIdEmpresa` INT(11),
IN `pClave` VARCHAR (60)

)
BEGIN

SELECT 
		 catalogo.IdCatalogo, catalogo.Nombre
 FROM 	reclutamiento.catalogo
WHERE  			catalogo.IdEmpresa=pIdEmpresa
		AND 	catalogo.Clave=pClave
		AND 	catalogo.EsActivo=1;

END$$

DELIMITER ;
-- Tipo Catalogo --

-- 3 Insert TipoContrato
INSERT INTO `reclutamiento`.`tipocatalogo` 
	(
	`IdEmpresa`, 
	`IdTipoCatalogo`,
	`Nombre`, 
	`NombreSingular`, 
	`TipoSubCatalogo`, 
	`IdTipoCatalogo_SubCatalogo`, 
	`IdUsuarioCreacion`, 
	`IdUsuarioUltimoModifico`,
	`Visible`
)
VALUES 
('1', '8', 'TipoContrato', 'TipoContrato', '0', '0', '1', '1', '1');


-- 4 Insert Tipo Jornada

INSERT INTO `reclutamiento`.`tipocatalogo` 
	(
	`IdEmpresa`, 
	`IdTipoCatalogo`,
	`Nombre`, 
	`NombreSingular`, 
	`TipoSubCatalogo`, 
	`IdTipoCatalogo_SubCatalogo`, 
	`IdUsuarioCreacion`, 
	`IdUsuarioUltimoModifico`,
	`Visible`)
VALUES 
('1', '9', 'TipoJornada', 'TipoJornada', '0', '0', '1', '1', '1');

-- 5 Insert Fases 
INSERT INTO `reclutamiento`.`tipocatalogo` 
	(
	`IdEmpresa`, 
	`IdTipoCatalogo`,
	`Nombre`, 
	`NombreSingular`, 
	`TipoSubCatalogo`, 
	`IdTipoCatalogo_SubCatalogo`, 
	`IdUsuarioCreacion`, 
	`IdUsuarioUltimoModifico`,
	`Visible`)
VALUES 
('1', '10', 'Fase', 'Fase', '0', '0', '1', '1', '1');


-- Insert a catalogo 

--  6 Contratos 

IINSERT INTO `reclutamiento`.`catalogo` 
(
	`Nombre`, 
	`Descripcion`,
	`IdTipoCatalogo`,
	`EsActivo`,
	`IdUsuarioCreacion`,
	`IdUsuarioUltimoModifico`,
	`Clave`,
	`IdEmpresa`)

	VALUES 
	('Honorarios', 'Contrato por honorarios', '8', '1', '1', '1', 'Contrato', '1'),
	('Nómina', 'Contrato por nomina', '8', '1', '1', '1', 'Contrato', '1'),
	('Asimilado al Salario', 'Contrato Asimilado al Salario', '8', '1', '1', '1', 'Contrato', '1');


--  7 Jornadas

INSERT INTO `reclutamiento`.`catalogo` 
(
	`Nombre`, 
	`Descripcion`,
	`IdTipoCatalogo`,
	`EsActivo`,
	`IdUsuarioCreacion`,
	`IdUsuarioUltimoModifico`,
	`Clave`,
	`IdEmpresa`)
	VALUES 
	('Mensual', 'Jornada Mensual', '9', '1', '1', '1', 'Jornada', '1'),
	('Semanal', 'Jornada Semanal', '9', '1', '1', '1', 'Jornada', '1'),
	('Quincenal', 'Jornada Quincenal', '9', '1', '1', '1', 'Jornada', '1');

--8  Fases


INSERT INTO `reclutamiento`.`catalogo` 
(
	`Nombre`, 
	`Descripcion`,
	`IdTipoCatalogo`,
	`EsActivo`,
	`IdUsuarioCreacion`,
	`IdUsuarioUltimoModifico`,
	`Clave`,
	`IdEmpresa`)
	VALUES 
	('En procesol', 'Fase de vacante en proceso', '10', '1', '1', '1', 'Fase', '1'),
	('Ocupada', 'Fase de vacante ocupada', '10', '1', '1', '1', 'Fase', '1'),
	('Abierta', 'Fase de vacante abierta', '10', '1', '1', '1', 'Fase', '1');

	

-- 9

/*  Eliminar  FK vacanteCaract - vacante */

ALTER TABLE `reclutamiento`.`vacantecaracteristica` 
DROP FOREIGN KEY `FK_VacanteCaracteristica_Vacante`;


/*  Eliminar y crear nuevamente tabla vacantes */

--- Tablas -- 

DROP TABLE IF EXISTS `vacante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vacante` (
  `IdVacante` int(11) NOT NULL AUTO_INCREMENT,
  `Titulo` varchar(100) DEFAULT NULL,
  `Descripcion` varchar(100) DEFAULT NULL,
  `FechaContratacion` date DEFAULT NULL,
  `NumeroVacantes` int(11) DEFAULT NULL,
  `Salario` double DEFAULT NULL,
  `IdTipoContrato` int(11) DEFAULT NULL,
  `IdTipoJornada` int(11) DEFAULT NULL,
  `IdCiudad` int(11) DEFAULT NULL,
  `IdUsuarioCreacion` int(11) DEFAULT NULL,
  `FechaCreacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioUltimoModifico` int(11) DEFAULT NULL,
  `FechaModificacion` timestamp NULL DEFAULT NULL,
  `Estatus` tinyint(4) DEFAULT NULL,
  `IdEmpresa` int(11) DEFAULT NULL,
  `Fase` int(11) DEFAULT '0',
  `FechaEntrega` date DEFAULT NULL,
  PRIMARY KEY (`IdVacante`),
  KEY `IdVacante` (`IdVacante`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COMMENT='tabla para guarar vacantes									';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vacante`
--

LOCK TABLES `vacante` WRITE;
/*!40000 ALTER TABLE `vacante` DISABLE KEYS */;
INSERT INTO `vacante` VALUES (7,'tt','ddd','2017-11-05',1,1,1,1,1,1,'2017-11-06 00:33:37',4,'2017-11-06 00:33:37',1,1,1,'2017-11-05'),(12,'Titulo vacante','Descripcion vacante','2018-03-08',1,12000,4,7,1,4,'2018-03-08 19:36:37',4,'2018-03-08 19:36:37',1,1,0,'2018-04-11'),(13,'Titulo vacante','Desc','2018-03-08',3,12500,5,7,1,4,'2018-03-08 19:49:37',4,'2018-03-08 19:49:37',1,1,0,'2018-04-06'),(14,'Titulo vacante','Descripcion vacante','2018-05-10',4,13520,4,7,1,4,'2018-03-08 19:52:37',4,'2018-03-08 19:52:37',1,1,0,'2018-03-08'),(15,'Titulo vacante','Descripcion vacante','2018-03-10',4,1200000,4,7,3,4,'2018-03-08 20:08:45',4,'2018-03-08 20:08:45',1,1,0,'2018-03-08'),(16,'Titulo vacante 2','Descripcion vacante','2018-03-29',3,13500,4,7,1,4,'2018-03-08 20:16:16',4,'2018-03-08 20:16:16',1,1,0,'2018-03-22'),(17,'nueva1','desd','2018-03-08',3,17000,4,7,1,4,'2018-03-08 21:33:30',4,'2018-03-08 21:33:30',1,1,0,'2018-03-08'),(18,'22','wqw','2018-03-08',2,22,5,7,1,4,'2018-03-08 22:39:22',4,'2018-03-08 22:39:22',1,1,0,'2018-03-08'),(19,'ff','22','2018-03-10',22,12,5,7,1,4,'2018-03-08 22:45:32',4,'2018-03-08 22:45:32',1,1,0,'2018-03-10');
/*!40000 ALTER TABLE `vacante` ENABLE KEYS */;
UNLOCK TABLES;



--- Procedures 

-- ActVacante 



 USE `reclutamiento`;
DROP procedure IF EXISTS `ActVacante`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActVacante`(
IN `pIdVacante` INT,
IN `pTitulo`  VARCHAR(100),
IN `pDescripcion` VARCHAR(1024),
IN `pFechaContratacion` TIMESTAMP,
IN `pNumeroVacantes` INT(11),
IN `pSalario` DOUBLE,
IN `pIdTipoContrato` INT(11),
IN `pIdTipoJornada` INT(11),
IN `pIdCiudad` INT(11),
IN `pIdUsuarioUltimoModifico` INT(11),
IN `pEstatus` TINYINT(4),
IN `pFase`  VARCHAR(90),
IN `pFechaEntrega`  VARCHAR(90)

)
BEGIN

	IF(
			SELECT COUNT(1)
			FROM reclutamiento.vacante
			WHERE vacante.descripcion=pDescripcion
			AND vacante.IdCliente= pIdCliente
			AND vacante.idEmpresa =pIdEmpresa

			AND vacante.Estatus=1)!=0 
	THEN 
			SELECT 'Error al actualizar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
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


---  Ins Vacante

DELIMITER ;

USE `reclutamiento`;
DROP procedure IF EXISTS `InsVacante`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante`(
-- Parametros -- 
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

IF (SELECT COUNT(1)
	FROM reclutamiento.vacante
	WHERE vacante.Descripcion 
	AND vacante.estatus =1 
	AND vacante.IdEmpresa= pIdEmpresa
     ) !=0 THEN 
		SELECT 'Error al insertar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
	else
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
end if;

END$$

DELIMITER ;


INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (10,'Reclutamiento012AH','Armadno Herrera','20180903','Modificar unas tablas de vacantes, agregar porcedimeitnos de vacantes');
