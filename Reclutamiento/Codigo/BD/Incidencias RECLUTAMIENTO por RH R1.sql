use directma_reclutamiento;
ALTER TABLE `prospecto` 
CHANGE COLUMN `Clave_Colonia` `Clave_Colonia` VARCHAR(10) NULL DEFAULT NULL ,
CHANGE COLUMN `CP` `CP` VARCHAR(10) NULL DEFAULT NULL ,
CHANGE COLUMN `Calle` `Calle` VARCHAR(100) NULL DEFAULT NULL ;