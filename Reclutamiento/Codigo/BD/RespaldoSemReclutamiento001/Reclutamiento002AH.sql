CREATE TABLE `reclutamiento`.`vacante` (
  `IdVacante` INT NOT NULL,
  `Titulo` VARCHAR(100) NULL,
  `Descripcion` VARCHAR(1024) NULL,
  `FechaContratacion` TIMESTAMP NULL,
  `NumeroVacantes` INT NULL,
  `Salario` DOUBLE NULL,
  `IdTipoContrato` INT NULL,
  `IdTipoJornada` INT NULL,
  `IdCiudad` INT NULL,
  `IdUsuarioCreacion` INT NULL,
  `FechaCreacion` TIMESTAMP NULL,
  `IdUsuarioUltimoModifico` INT NULL,
  `FechaModificacion` TIMESTAMP NULL,
  `Estatus` TINYINT NULL,
  `IdEmpresa` INT NULL,
  PRIMARY KEY (`IdVacante`),
  INDEX `IdVacante` (`IdVacante` ASC))
COMMENT = 'tabla para guarar vacantes';

CREATE TABLE `reclutamiento`.`caracteristicaparticular` (
  `IdCaracteristicaParticular` INT NOT NULL AUTO_INCREMENT,
  `Clave` VARCHAR(10) NULL,
  `Nombre` VARCHAR(100) NULL,
  `IdTipoCampo` INT NULL,
  `IdUsuarioCreacion` INT NULL,
  `IdUsuarioUltimoModifico` INT NULL,
  `FechaModificacion` TIMESTAMP NULL,
  `Estatus` TINYINT NULL,
  `IdEmpresa` INT NULL,
  PRIMARY KEY (`IdCaracteristicaParticular`),
  UNIQUE INDEX `IdCaracteristicaParticular_UNIQUE` (`IdCaracteristicaParticular` ASC))
COMMENT = 'CaracteristicaParticular';

CREATE TABLE `reclutamiento`.`vacantecaracteristica` (
  `IdVacanteCaracteristica` INT NOT NULL AUTO_INCREMENT,
  `IdVacante` INT NULL,
  `IdCaracteristicaParticular` INT NULL,
  PRIMARY KEY (`IdVacanteCaracteristica`),
  UNIQUE INDEX `IdVacanteCaracteristica_UNIQUE` (`IdVacanteCaracteristica` ASC),
  INDEX `FK_VacanteCaracteristica_idx` (`IdVacante` ASC),
  INDEX `FK_VacanteCaracteristica_CaractParticular_idx` (`IdCaracteristicaParticular` ASC),
  CONSTRAINT `FK_VacanteCaracteristica`
    FOREIGN KEY (`IdVacante`)
    REFERENCES `reclutamiento`.`vacante` (`IdVacante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_VacanteCaracteristica_CaractParticular`
    FOREIGN KEY (`IdCaracteristicaParticular`)
    REFERENCES `reclutamiento`.`caracteristicaparticular` (`IdCaracteristicaParticular`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
	
INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (2,'Reclutamiento002AH','Armando Herrera','20180226','Creacion de Vacante, caracteristicas particulares, union entre ambas');