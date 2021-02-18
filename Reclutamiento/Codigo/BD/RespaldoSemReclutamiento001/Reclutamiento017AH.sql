-- ============================================= 	
 -- Nombre: SP [] 
 -- Fecha de Creación: dd/mm/yyyy
 -- Objetivo: Insertar el registro de usuarios. 
 -- Desarrollador: Armando Herrera
 -- Fecha Ult. Modificación: dd/mm/yyyy 
 -- Test: Exec InsUsuario ‘Usuario1’, 'TYh$tgHg845/*5d6P4=', 'Administrador',1
 -- ============================================= 

ALTER TABLE `reclutamiento`.`vacante` 
CHANGE COLUMN `IdCiudad` `IdCiudad` VARCHAR(10) NULL DEFAULT NULL ;


INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (17,'Reclutamiento017AH','Armando Herrera','20180314','Modificar la columna de IdCiudad');

