ALTER TABLE `vacante` CHANGE `IdCiudad` `IdCiudad` VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL; 

set @forma = 'CaracteristicasGenerales';
set @id = (select idForma from Forma Where ClaveCodigo = @forma);

delete from formapermiso where idForma = @id;
delete from formaRol where idForma = @id;
delete from forma where idforma = @id;


set @forma = 'BitacoraErrorDeudor';
set @id = (select idForma from Forma Where ClaveCodigo = @forma);

delete from formapermiso where idForma = @id;
delete from formaRol where idForma = @id;
delete from forma where idforma = @id;


DROP PROCEDURE IF EXISTS `ObtVacantes`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtVacantes`(
  
  IN `pVacantes` MEDIUMTEXT

)

BEGIN
 
  set @sql = pVacantes;



  prepare stmt1 from @sql;

  execute stmt1;

END$$
DELIMITER ;



DROP PROCEDURE IF EXISTS `ActVacante`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActVacante`(
  
  IN `pIdVacante` INT, 
  
  IN `pTitulo` VARCHAR(100), 
  
  IN `pDescripcion` VARCHAR(100), 
  
  IN `pFechaContratacion` DATE, 
  
  IN `pNumeroVacantes` INT(11), 
  
  IN `pSalario` DOUBLE, 
  
  IN `pIdTipoContrato` INT(11), 
  
  IN `pIdTipoJornada` INT(11), 
  
  IN `pIdCiudad` VARCHAR(20), 
  
  IN `pIdUsuarioUltimoModifico` INT(11), 
  
  IN `pEstatus` TINYINT(4), 
  
  IN `pComentarios` VARCHAR(300), 
  
  IN `pIdEmpresa` INT(11), 
  
  IN `pFase` VARCHAR(90), 
  
  IN `pFechaEntrega` DATE

)

BEGIN

	

  IF(
    SELECT COUNT(1)
 
    FROM reclutamiento.vacante
 
    WHERE vacante.Titulo= pTitulo
 
      AND vacante.descripcion=pDescripcion
 
      AND vacante.FechaContratacion = pFechaContratacion
 
      AND vacante.NumeroVacantes=pNumeroVacantes

      AND vacante.Salario=pSalario
			
      AND vacante.IdTipoContrato=pIdTipoContrato
			
      AND vacante.IdTipoJornada=pIdTipoJornada
			
      AND vacante.IdCiudad=pIdCiudad
			
      AND vacante.FechaEntrega=pFechaEntrega
			
      AND vacante.idEmpresa =pIdEmpresa
			
      AND vacante.Estatus=pEstatus
    )!=0 
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
	vacante.Comentarios=pComentarios,
	vacante.Fase= pFase,
	vacante.FechaEntrega=pFechaEntrega
      WHERE
        IdVacante=pIdVacante AND IdEmpresa=pIdEmpresa;



    SELECT NULL AS ErrorMessage;

  END IF;



END$$

DELIMITER ;



DROP PROCEDURE IF EXISTS `InsVacante`;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante`(
  IN `pTitulo` VARCHAR(100), 
  IN `pDescripcion` VARCHAR(100), 
  IN `pFechaContratacion` TIMESTAMP, 
  IN `pNumeroVacantes` INT(11), 
  IN `pSalario` DOUBLE, 
  IN `pIdTipoContrato` INT(11), 
  IN `pIdTipoJornada` INT(11), 
  IN `pIdCiudad` VARCHAR(20), 
  IN `pIdUsuarioCreacion` INT(11), 
  IN `pIdUsuarioUltimoModifico` INT(11), 
  IN `pEstatus` TINYINT(4), 
  IN `pComentarios` VARCHAR(300), 
  IN `pIdEmpresa` INT(11), 
  IN `pFase` INT(11), 
  IN `pFechaEntrega` DATETIME
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
			vacante.Comentarios,
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
			pComentarios,
			pIdEmpresa,
			pFase, 
			pFechaEntrega
		);
	SET pIdVacante= (SELECT MAX(IdVacante) FROM reclutamiento.vacante);
	SELECT NULL AS ErrorMessage, pIdVacante as IdVacante;
END$$
DELIMITER ;

set @forma = 'Caracteristicas';
set @formaLink = 'Características';
set @formaAccion = 'Caracteristicas_Index';
set @formaControlador = 'Caracteristicas';
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
	, 0, 4, 1, now(), 1, now(), 1, '(Administracion) Forma correspondiente a Vacantes', 1, 0
	);


INSERT INTO `registroScript`(`NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) 
VALUES (26,'Reclutamiento026AG','Alejandro Gutiérrez',CURDATE() ,'Modificacion de procedimientos sobre Vacante');
