-- ============================================= 	
 -- Nombre: SP [Reclutamiento 020AH] 
 -- Fecha de Creación: 16/03/2018
 -- Objetivo: Permisos y altas de formas para Caracteristicas Generales
 -- Desarrollador: Armando Herrera
 -- ============================================= 
 
-- Forma

set @forma = 'CaracteristicasGenerales';
set @formaLink = 'Caracteristicas Generales';
set @formaAccion = 'CaracteristicasGenerales_Index';
set @formaControlador = 'CaracteristicasGenerales';
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
	, 0, 4, 1, now(), 1, now(), 1, '(Administracion) Forma correspondiente a Caracteristicas Generalws', 1, 0
	);

 
 INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (20,'Reclutamiento020AH','Armando Herrera',CURDATE() ,'Permisos y registro de formas para Caracteristicas Generales');