DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectos`(
  IN `pNombre` VARCHAR(100),
  IN `pApellido` VARCHAR(100),
  IN `pActivo` INT,
  IN `pIdEmpresa` INT
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
	   IdProspecto,
	   Nombre,
	   Apellidos,
	   FechaNacimiento,
	   RFC,
	   Email,
           TelefonoMovil,
	   TelefonoOtro,
	   Direccion,
	   CV,
	   Foto,
	   Salario,
	   IdSexo,
	   IdCiudad,
	   IdEstadoCivil,
	   IdProfesion,   
	   Activo
	FROM prospecto
	where Nombre like concat('%', IFNULL(pNombre, ''), '%')
			and Apellido like concat('%', IFNULL(pApellido, ''), '%')
			and Activo between pDesde and pHasta
			AND IdEmpresa = pIdEmpresa;

END$$
DELIMITER ;

insert into Forma(ClaveCodigo, Nombre, EsOpcionMenu, Estatus, IdFormaPadre, TextoLink, Accion, Controlador
	, EsDropdown, Orden, IdUsuarioCreacion,FechaCreacion, IdUsuarioUltimoModifico,FechaModificacion
	, OrigenOperacion, Descripcion, IdEmpresa, EsSuperAdministrador
)
values(
	'Prospecto'
	, 'Prospecto'
	, 1, 1
	, 2
	, 'Prospectos'
	, 'Prospecto_Index'
	, 'Prospecto'
	, 0, 4, 1, now(), 1, now(), 1, '(Administracion) Forma correspondiente a Prospectos', 1, 0
	);

SET @id_forma = (select idForma from Forma where(ClaveCodigo='Prospecto'));

insert into FormaRol(
  IdForma, IdRol, Privilegios, IdUsuarioCreacion, FechaCreacion, IdUsuarioUltimoModifico, 
  FechaModificacion, OrigenOperacion, IdEmpresa 
)
values( @id_forma, 2, 15, 1, now(), 1, now(), 1 , 1);

insert into FormaPermiso( 
  IdForma , IdPermiso, IdUsuarioCreacion, FechaCreacion, IdUsuarioUltimoModifico, FechaModificacion, OrigenOperacion, 
  IdEmpresa, NombrePermiso
)
values( @id_forma, 1, 1, now(), 1,now(), 1, 1, 'Consultar' ),( @id_forma, 2, 1, now(), 1,now(), 1, 1, 'Agregar' ),
 ( @id_forma, 3, 1, now(), 1,now(), 1, 1, 'Actualizar' ),( @id_forma, 4, 1, now(), 1,now(), 1, 1, 'Eliminar' );





INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (4,'Reclutamiento004AG','Alejandro Gutierrez','20180227','Procedimiento ObtProspecto, Agregar Menu Prospecto.');
