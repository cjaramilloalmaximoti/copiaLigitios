DROP TABLE if EXISTS prospecto;

CREATE TABLE `reclutamiento`.`prospecto` (
  `IdProspecto` INT NOT NULL,
  `Nombre` VARCHAR(100) NULL,
  `Apellidos` VARCHAR(100) NULL,
  `FechaNacimiento` TIMESTAMP NULL,
  `RFC` VARCHAR(13) NULL,
  `Email` VARCHAR(100) NULL,
  `TelefonoMovil` VARCHAR(10) NULL,  
  `TelefonoOtro` VARCHAR(10) NULL,
  `IdSexo` TINYINT NULL,
  `Direccion` VARCHAR(250) NULL,
  `CV` VARCHAR(250),
  `Foto` VARCHAR(250),
  `Salario` DOUBLE NULL,
  `IdCiudad` INT NULL,
  `IdEstadoCivil` INT NULL,
  `IdProfesion` INT NULL,
  `IdUsuarioCreacion` INT NULL,
  `FechaCreacion` TIMESTAMP NULL,
  `IdUsuarioUltimoModifico` INT NULL,
  `FechaModificacion` TIMESTAMP NULL,
  `Estatus` TINYINT NULL,
  `IdEmpresa` INT NULL,
  PRIMARY KEY (`IdProspecto`),
  INDEX `IdProspecto` (`IdProspecto` ASC))
COMMENT = 'tabla para guarar prospectos';

DROP TABLE if EXISTS prospectocaracteristica;

CREATE TABLE `reclutamiento`.`prospectocaracteristica` (
  `IdProspectoCaracteristica` INT NOT NULL AUTO_INCREMENT,
  `IdProspecto` INT NULL,
  `Valor` VARCHAR(1024),
  `IdCaracteristicaParticular` INT NULL,
  PRIMARY KEY (`IdProspectoCaracteristica`),
  UNIQUE INDEX `IdProspectoCaracteristica_UNIQUE` (`IdProspectoCaracteristica` ASC),
  INDEX `FK_ProspectoCaracteristica_idx` (`IdProspecto` ASC),
  INDEX `FK_ProspectoCaracteristica_CaractParticular_idx` (`IdCaracteristicaParticular` ASC),
  CONSTRAINT `FK_ProspectoCaracteristica`
    FOREIGN KEY (`IdProspecto`)
    REFERENCES `reclutamiento`.`prospecto` (`IdProspecto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_ProspectoCaracteristica_CaractParticular`
    FOREIGN KEY (`IdCaracteristicaParticular`)
    REFERENCES `reclutamiento`.`caracteristicaparticular` (`IdCaracteristicaParticular`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `vacantecaracteristica` ADD `Valor` VARCHAR(1024) NOT NULL AFTER `IdVacanteCaracteristica`; 

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsProspecto`(
  IN `pIdProspecto` INT, 
  IN `pNombre` VARCHAR(100), 
  IN `pApellidos` VARCHAR(100), 
  IN `pFechaNacimiento` timestamp, 
  IN `pRFC` VARCHAR(13), 
  IN `pEmail` VARCHAR(100), 
  IN `pTelefonoMovil` VARCHAR(10), 
  IN `pTelefonoOtro` VARCHAR(10), 
  IN `pIdSexo` INT, 
  IN `pDireccion` VARCHAR(250), 
  IN `pCV` VARCHAR(250), 
  IN `pFoto` VARCHAR(250), 
  IN `pSalario` DOUBLE, 
  IN `pIdCiudad` INT, 
  IN `pIdEstadoCivil` INT, 
  IN `pIdProfesion` INT, 
  IN `pIdUsuarioLog` INT, 
  IN `pActivo` TINYINT(1), 
  IN `pIdEmpresa` INT
)
BEGIN	
        INSERT INTO prospecto
	(
	  IdProspecto,
	  Nombre,
	  Apellidos,
	  FechaNacimiento,
	  RFC,
	  Email,
	  TelefonoMovil, 
	  TelefonoOtro,
	  IdSexo,
	  Direccion,
	  CV,
	  Foto,
	  Salario,
	  IdCiudad,
	  IdEstadoCivil,
	  IdProfesion,
	  IdUsuarioCreacion,
	  FechaCreacion,
	  IdUsuarioUltimoModifico,
	  FechaModificacion,
	  Estatus,
	  IdEmpresa
	)
	VALUES
	(
	  pIdProspecto,
	  pNombre,
	  pApellidos,
	  pFechaNacimiento,
	  pRFC,
	  pEmail,
	  pTelefonoMovil,
	  pTelefonoOtro,
	  pIdSexo,
	  pDireccion,
	  pCV,
	  pFoto,
	  pSalario,
	  pIdCiudad,
	  pIdEstadoCivil,
	  pIdProfesion,
	  pIdUsuarioLog,
	  now(),
	  pActivo,
	  pIdEmpresa,
	  pIdUsuarioLog,
	  now());
END$$
DELIMITER ;

INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (3,'Reclutamiento003AG','Alejandro Gutierrez','20180227','Creacion de Prospecto, union entre prospecto y caracteristicas. agregar campo valor a Vacante');