USE RECLUTAMIENTO;

SET @idForma = (select IdForma from forma where ClaveCodigo = 'CodigoPostal');

DELETE FROM formarol WHERE IdForma = @idForma; 

DELETE FROM formapermiso WHERE IdForma = @idForma; 

DELETE FROM forma WHERE IdForma = @idForma; 

SET @idForma = (select max(IdForma) +1 from forma);

/*1.-Agregar Forma */
INSERT INTO `reclutamiento`.`forma` (`IdForma`, `ClaveCodigo`, `Nombre`, `EsOpcionMenu`, `Estatus`, `IdFormaPadre`, `TextoLink`, `Accion`, `Controlador`, `EsDropdown`, `Orden`, `IdUsuarioCreacion`, `IdUsuarioUltimoModifico`, `OrigenOperacion`, `IdEmpresa`, `EsSuperAdministrador`) 
VALUES (@idForma, 'CodigoPostal', 'Codigo Postal', '1', '1', '2', 'Carga Codigos Postales', 'CargaCodigoPostal', 'CodigoPostal', '0', '7', '1', '1', '1', '1', '0');



/*2.-Asignar Permisos*/
INSERT INTO `reclutamiento`.`formapermiso` (`IdForma`, `IdPermiso`, `IdUsuarioCreacion`, `IdUsuarioUltimoModifico`, `OrigenOperacion`, `IdEmpresa`, `NombrePermiso`) VALUES (@idForma, '1', '0', '0', '0', '1', 'Consultar');

INSERT INTO `reclutamiento`.`formapermiso` (`IdForma`, `IdPermiso`, `IdUsuarioCreacion`, `IdUsuarioUltimoModifico`, `OrigenOperacion`, `IdEmpresa`, `NombrePermiso`) VALUES (@idForma, '2', '0', '0', '0', '1', 'Agregar');

INSERT INTO `reclutamiento`.`formapermiso` (`IdForma`, `IdPermiso`, `IdUsuarioCreacion`, `IdUsuarioUltimoModifico`, `OrigenOperacion`, `IdEmpresa`, `NombrePermiso`) VALUES (@idForma, '3', '0', '0', '0', '1', 'Actualizar');



/*3.-Asignacion a rol*/
INSERT INTO `reclutamiento`.`formarol` (`IdForma`, `IdRol`, `Privilegios`, `IdUsuarioCreacion`, `IdUsuarioUltimoModifico`, `OrigenOperacion`, `IdEmpresa`) VALUES (@idForma, '2', '15', '1', '1', '1', '1');






DROP TABLE IF EXISTS TipoAsentamiento;
DROP TABLE IF EXISTS colonia;
DROP TABLE IF EXISTS ciudad;
DROP TABLE IF EXISTS estado;
DROP TABLE IF EXISTS pais;

CREATE TABLE IF NOT EXISTS `TipoAsentamiento` (
  `Clave_Asentamiento` varchar(10) NOT NULL,
  `Nombre` varchar(512) NOT NULL,
  `Clave_Pais` varchar(10) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `Estatus` TINYINT(4) NOT NULL DEFAULT 1,   
  PRIMARY KEY  (`Clave_Asentamiento`)
) ;

CREATE TABLE IF NOT EXISTS `pais` (
  `Clave_Pais` varchar(10) NOT NULL,
  `Nombre` varchar(512) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `Estatus` TINYINT(4) NOT NULL DEFAULT 1,   
  PRIMARY KEY  (`Clave_Pais`)
) ;

CREATE TABLE IF NOT EXISTS `estado` (
  `Clave_Estado` varchar(10) NOT NULL,
  `Nombre` varchar(512) NOT NULL,
  `Clave_Pais` varchar(10) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `Estatus` TINYINT(4) NOT NULL DEFAULT 1,   
  PRIMARY KEY  (`Clave_Estado`)
) ;


CREATE TABLE IF NOT EXISTS `ciudad` (
  `Clave_Ciudad` varchar(10) NOT NULL,
  `Nombre` varchar(512) NOT NULL,
  `Clave_Estado` varchar(10) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `Estatus` TINYINT(4) NOT NULL DEFAULT 1,   
  PRIMARY KEY  (`Clave_Ciudad`, `Clave_Estado`)
) ;

ALTER TABLE ciudad ADD INDEX `R_24` (`Clave_Estado` ASC);
ALTER TABLE ciudad ADD CONSTRAINT `R_24` FOREIGN KEY (`Clave_Estado`) REFERENCES estado (`Clave_Estado`);

CREATE TABLE IF NOT EXISTS `colonia` (
  `Clave_Colonia` varchar(10) NOT NULL,  
  `Nombre` varchar(512) NOT NULL,
  `CodigoPostal` varchar(10) NOT NULL,
  `Clave_Estado` varchar(10) NOT NULL,
  `Clave_Ciudad` varchar(10) NOT NULL,
  `Clave_Asentamiento` varchar(10) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `Estatus` TINYINT(4) NOT NULL DEFAULT 1,   
  PRIMARY KEY  (`Clave_Colonia` , `Clave_Ciudad`, `Clave_Estado` )
) ;

ALTER TABLE colonia ADD INDEX `R_25` (`Clave_Ciudad` ASC);
ALTER TABLE colonia ADD CONSTRAINT `R_25` FOREIGN KEY (`Clave_Ciudad`) REFERENCES ciudad (`Clave_Ciudad`);

/*INSERTA PAIS*/
INSERT INTO pais (Clave_Pais, Nombre, IdUsuarioCreacion, IdUsuarioUltimoModifico) VALUES('01','Mexico',1,1);


DROP procedure IF EXISTS `ObtPaises`;

DELIMITER $$
USE `reclutamiento`$$
CREATE PROCEDURE `ObtPaises` (IN `pNombre` VARCHAR(512),IN `pActivo` INT)
BEGIN
SELECT Clave_Pais
      ,Nombre
FROM pais 
WHERE Nombre like concat('%', IFNULL(pNombre, ''), '%')
AND Estatus = pActivo;
END$$



DELIMITER ;
USE `reclutamiento`;
DROP procedure IF EXISTS `TruTablesCP`;

DELIMITER $$
USE `reclutamiento`$$
CREATE PROCEDURE `TruTablesCP` (IN `pPais` VARCHAR(10))
BEGIN

SET SQL_SAFE_UPDATES = 0;

DELETE C.* FROM colonia C
INNER JOIN ciudad CI ON C.Clave_Ciudad = CI.Clave_Ciudad
INNER JOIN estado E ON CI.Clave_Estado = E.Clave_Estado
WHERE (E.Clave_Pais = pPais);

DELETE C.* FROM ciudad C
INNER JOIN estado E ON C.Clave_Estado = E.Clave_Estado
WHERE (E.Clave_Pais = pPais);


DELETE E.* FROM estado E
WHERE (E.Clave_Pais = pPais);

DELETE A.* FROM TipoAsentamiento A
WHERE (A.Clave_Pais = pPais);


END$$

DELIMITER ;


USE `reclutamiento`;
DROP procedure IF EXISTS `InsEstados`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsEstados`( IN `pEstados` TEXT)
BEGIN

declare cnt int;
declare ptr int;
declare rowPtr varchar(1024);

set cnt = (extractValue(pEstados, 'count(/ArrayOfEEstados/EEstados)'));
set ptr = 0;

while ptr < cnt do
    SET ptr = ptr + 1;
    SET rowPtr = concat('/ArrayOfEEstados/EEstados[', ptr, ']');
    INSERT INTO estado (Clave_Estado, Nombre,Clave_Pais, IdUsuarioCreacion,IdUsuarioUltimoModifico)
    values (extractValue(pEstados, concat(rowPtr, '/Clave_Estado')),
			extractValue(pEstados, concat(rowPtr, '/Nombre')),
            extractValue(pEstados, concat(rowPtr, '/Clave_Pais')),
            extractValue(pEstados, concat(rowPtr, '/IdUsuarioCreacion')),
			extractValue(pEstados, concat(rowPtr, '/IdUsuarioCreacion'))
    );

end while;  


END$$

DELIMITER ;


USE `reclutamiento`;
DROP procedure IF EXISTS `InsCiudades`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCiudades`( IN `pCiudades` MEDIUMTEXT)
BEGIN

declare cnt int;
declare ptr int;
declare rowPtr MEDIUMTEXT;

set cnt = (extractValue(pCiudades, 'count(/ArrayOfECiudad/ECiudad)'));
set ptr = 0;

while ptr < cnt do
    SET ptr = ptr + 1;
    SET rowPtr = concat('/ArrayOfECiudad/ECiudad[', ptr, ']');
    INSERT INTO ciudad (Clave_Ciudad, Nombre,Clave_Estado, IdUsuarioCreacion,IdUsuarioUltimoModifico)
    values (extractValue(pCiudades, concat(rowPtr, '/Clave_Ciudad')),    
			extractValue(pCiudades, concat(rowPtr, '/Nombre')),
            extractValue(pCiudades, concat(rowPtr, '/Clave_Estado')),
            extractValue(pCiudades, concat(rowPtr, '/IdUsuarioCreacion')),
			extractValue(pCiudades, concat(rowPtr, '/IdUsuarioCreacion'))
    );

end while;  


END$$

DELIMITER ;


USE `reclutamiento`;
DROP procedure IF EXISTS `InsTipoAsentamientos`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsTipoAsentamientos`( IN `pTipoAsentamiento` MEDIUMTEXT)
BEGIN

declare cnt int;
declare ptr int;
declare rowPtr MEDIUMTEXT;

set cnt = (extractValue(pTipoAsentamiento, 'count(/ArrayOfETipoAsentamiento/ETipoAsentamiento)'));
set ptr = 0;

while ptr < cnt do
    SET ptr = ptr + 1;
    SET rowPtr = concat('/ArrayOfETipoAsentamiento/ETipoAsentamiento[', ptr, ']');
    INSERT INTO tipoasentamiento (Clave_Asentamiento, Nombre,Clave_Pais, IdUsuarioCreacion,IdUsuarioUltimoModifico)
    values (extractValue(pTipoAsentamiento, concat(rowPtr, '/Clave_Asentamiento')),    
			extractValue(pTipoAsentamiento, concat(rowPtr, '/Nombre')),
            extractValue(pTipoAsentamiento, concat(rowPtr, '/Clave_Pais')),
            extractValue(pTipoAsentamiento, concat(rowPtr, '/IdUsuarioCreacion')),
			extractValue(pTipoAsentamiento, concat(rowPtr, '/IdUsuarioCreacion'))
    );

end while;  


END$$

DELIMITER ;


USE `reclutamiento`;
DROP procedure IF EXISTS `InsColonias`;

DELIMITER $$
USE `reclutamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsColonias`( IN `pColonias` LONGTEXT )
BEGIN

declare cnt int;
declare ptr int;
declare rowPtr LONGTEXT ;

set cnt = (extractValue(pColonias, 'count(/ArrayOfEColonia/EColonia)'));
set ptr = 0;

while ptr < cnt do
    SET ptr = ptr + 1;
    SET rowPtr = concat('/ArrayOfEColonia/EColonia[', ptr, ']');
    INSERT INTO colonia (Clave_Colonia, Nombre, CodigoPostal,Clave_Estado, Clave_Ciudad, IdUsuarioCreacion,IdUsuarioUltimoModifico)
    values (extractValue(pColonias, concat(rowPtr, '/Clave_Colonia')),    
			extractValue(pColonias, concat(rowPtr, '/Nombre')),
            extractValue(pColonias, concat(rowPtr, '/CodigoPostal')),
            extractValue(pColonias, concat(rowPtr, '/Clave_Estado')),
            extractValue(pColonias, concat(rowPtr, '/Clave_Ciudad')),
            extractValue(pColonias, concat(rowPtr, '/IdUsuarioCreacion')),
			extractValue(pColonias, concat(rowPtr, '/IdUsuarioCreacion'))
    );

end while;  


END$$

DELIMITER ;



INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (14,'Reclutamiento014AG','Martin Sosa','20180312','Codigos Postales');