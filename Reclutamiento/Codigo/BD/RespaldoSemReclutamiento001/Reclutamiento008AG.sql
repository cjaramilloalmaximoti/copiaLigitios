/*Agregar campo de Nacionalidad a Estado*?
ALTER TABLE `estado` ADD `IdNacionalidad` INT NOT NULL AFTER `Estatus`; 

/* Insertar Pais */
INSERT INTO `nacionalidad`(`IdNacionalidad`, `Nombre`, `Clave`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Estatus`) 
VALUES (1,'M�xico','MX',1,now(),1,now(),1);

/*Insertar Estados*/
INSERT INTO `estado`(`Nombre`, `Clave`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Estatus`, `IdNacionalidad`) 
VALUES 
('Aguascalientes','AGS',1,now(),1,now(),1,1), ('Baja California','BCN',1,now(),1,now(),1,1), ('Baja California Sur','BCS',1,now(),1,now(),1,1), 
('Campeche','CAM',1,now(),1,now(),1,1), ('Chiapas','CHP',1,now(),1,now(),1,1), ('Chihuahua','CHI',1,now(),1,now(),1,1), 
('Ciudad de M�xico','DIF',1,now(),1,now(),1,1), ('Coahuila','COA',1,now(),1,now(),1,1), ('Colima','COL',1,now(),1,now(),1,1), 
('Durango','DUR',1,now(),1,now(),1,1), ('Guanajuato','GTO',1,now(),1,now(),1,1), ('Guerrero','GRO',1,now(),1,now(),1,1), 
('Hidalgo','HGO',1,now(),1,now(),1,1), ('Jalisco','JAL',1,now(),1,now(),1,1), ('M�xico','MEX',1,now(),1,now(),1,1), 
('Michoac�n','MIC',1,now(),1,now(),1,1), ('Morelos','MOR',1,now(),1,now(),1,1), ('Nayarit','NAY',1,now(),1,now(),1,1), 
('Nuevo Le�n','NLE',1,now(),1,now(),1,1), ('Oaxaca','OAX',1,now(),1,now(),1,1), ('Puebla','PUE',1,now(),1,now(),1,1), 
('Quer�taro','QRO',1,now(),1,now(),1,1), ('Quintana Roo','ROO',1,now(),1,now(),1,1), ('San Luis Potos�','SLP',1,now(),1,now(),1,1), 
('Sinaloa','SIN',1,now(),1,now(),1,1), ('Sonora','SON',1,now(),1,now(),1,1), ('Tabasco','TAB',1,now(),1,now(),1,1), 
('Tamaulipas','TAM',1,now(),1,now(),1,1), ('Tlaxcala','TLX',1,now(),1,now(),1,1), ('Veracruz','VER',1,now(),1,now(),1,1), 
('Yucat�n','YUC',1,now(),1,now(),1,1), ('Zacatecas','ZAC',1,now(),1,now(),1,1);

/*Procedimiento de ObtCiudades*/
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCiudades`(
  IN `pNombre` VARCHAR(100), 
  IN `pActivo` INT
)
BEGIN
	Declare pDesde tinyint;
	Declare pHasta tinyint;	
        
	if(pActivo = -1) then
		SET pDesde = 0;
		SET pHasta = 1;
	else
		SET pDesde = pActivo;
		SET pHasta = pActivo;
	end if;
	
	SELECT
	   IdCiudad,
	   Nombre,
	   Clave,
	   Estatus,
	   IdNacionalidad
	FROM Ciudad
	where Nombre like concat('%', IFNULL(pNombre, ''), '%')
			and Clave like concat('%', IFNULL(pNombre, ''), '%')
			and Estatus between pDesde and pHasta;

END$$
DELIMITER ;


INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (8,'Reclutamiento008AG','Alejandro Guti�rrez','20180103','Agregar IdNacionalidad a estados, Insertar Estados, procedimiento ObtCiudades');