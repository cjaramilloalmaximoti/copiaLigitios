-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 17-03-2018 a las 00:01:01
-- Versión del servidor: 5.7.19
-- Versión de PHP: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `reclutamiento`
--

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `ActCaracteristicaParticular`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCaracteristicaParticular` (IN `pIdCaracteristicaParticular` VARCHAR(10), IN `pClave` VARCHAR(10), IN `pNombre` VARCHAR(100), IN `pIdTipoCampo` INT(11), IN `pIdUsuarioCreacion` INT(11), IN `pIdUsuarioUltimoModifico` INT(11), IN `pFechaModificacion` TIMESTAMP, IN `pEstatus` TINYINT(4), IN `pIdEmpresa` INT(11))  BEGIN
	UPDATE
		reclutamiento.caracteristicaparticular
	SET
		caracteristicaparticular.Clave =pClave,
		caracteristicaparticular.Nombre =pNombre,
		caracteristicaparticular.IdTipoCampo = pIdTipoCampo, 
		caracteristicaparticular.IdUsuarioCreacion= pIdUsuarioCreacion,
		caracteristicaparticular.IdUsuarioUltimoModifico = pIdUsuarioUltimoModifico,
		caracteristicaparticular.FechaModificacion=NOW(),
		caracteristicaparticular.Estatus= pEstatuS,
		caracteristicaparticular.IdEmpresa = pIdEmpresa
	WHERE 
		caracteristicaparticular.IdCaracteristicaParticular= pIdCaracteristicaParticular;

	SELECt NULL AS ErrorMessage;
END$$

DROP PROCEDURE IF EXISTS `ActCatalogo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCatalogo` (`pClave` VARCHAR(12), `pIdUsuarioLog` INT, `pIdCatalogo` INT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(256), `pIdTipoCatalogo` SMALLINT, `pEsActivo` TINYINT, `pIdEmpresa` INT)  BEGIN
	UPDATE Catalogo
	SET
		Clave = pClave
		,Nombre = pNombre
		,Descripcion = pDescripcion
		,IdTipoCatalogo = pIdTipoCatalogo
		,EsActivo = pEsActivo
		,FechaModificacion = now()
		,IdUsuarioUltimoModifico = pIdUsuarioLog
	WHERE
	IdCatalogo = pIdCatalogo
    and IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ActCliente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCliente` (IN `pIdCliente` INT, IN `pIdEmpresa` INT, IN `pRFC` VARCHAR(13), IN `pRazonSocial` VARCHAR(96), IN `pNombreComercial` VARCHAR(64), IN `pDireccion` VARCHAR(250), IN `pContacto_Nombre` VARCHAR(64), IN `pContacto_Email` VARCHAR(64), IN `pContacto_Telefono` VARCHAR(32), IN `pComentarios` VARCHAR(128), IN `pEstatus` TINYINT(1), IN `pIdUsuarioLog` INT, IN `pEmpresaCorreo` VARCHAR(64), IN `pEmpresaTelefono` VARCHAR(64))  BEGIN

IF (SELECT COUNT(1)
 		from cliente 
 		where	RFC = pRFC 
				and IdCliente != pIdCliente
 				and Estatus = 1
                AND IdEmpresa = pIdEmpresa) != 0 THEN
		SELECT 'Error al actualizar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
 	ELSE
		UPDATE cliente
		SET
			RFC = pRFC,
			RazonSocial = pRazonSocial,
			NombreComercial = pNombreComercial,
			Direccion = pDireccion,
            EmpresaCorreo = pEmpresaCorreo,
            EmpresaTelefono = pEmpresaTelefono,
            Contacto_Nombre = pContacto_Nombre,
			Contacto_Email = pContacto_Email,
			Contacto_Telefono = pContacto_Telefono,
			Comentarios = pComentarios,
			Estatus = pEstatus,
			IdUsuarioUltimoModifico = pIdUsuarioLog,
			FechaModificacion = now()
		WHERE IdCliente = pIdCliente
			  and IdEmpresa = pIdEmpresa;
        
        SELECT null as ErrorMessage;
        
	END IF;
END$$

DROP PROCEDURE IF EXISTS `ActEmpresa`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActEmpresa` (IN `pIdEmpresa` INT(11), IN `pDominio` VARCHAR(64), IN `pProductKey` VARCHAR(256), IN `pAdministrador` VARCHAR(30), IN `pContrasenia` VARCHAR(250), IN `pNombreComercial` VARCHAR(100), IN `pRutaLogo` VARCHAR(200))  BEGIN

	UPDATE empresa
	SET
		Dominio = pDominio,
		ProductKey = pProductKey,
		Administrador = pAdministrador,
		Contrasenia = pContrasenia,
        NombreComercial = pNombreComercial,
        RutaLogo = pRutaLogo
	WHERE IdEmpresa = pIdEmpresa;
END$$

DROP PROCEDURE IF EXISTS `ActFormaPermiso`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActFormaPermiso` (`pIdForma` INT(11), `pIdPermiso` INT(11), `pIdEmpresa` INT(11), `pIdUsuarioLog` INT(11), `pNombrePermiso` VARCHAR(50))  BEGIN
	
    UPDATE formapermiso
    SET NombrePermiso = pNombrePermiso   
        , IdUsuarioUltimoModifico = pIdUsuarioLog
        , FechaModificacion = NOW()
    WHERE 
		IdForma = pIdForma
        AND IdPermiso = pIdPermiso
        ANd IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ActParametro`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActParametro` (`pIdParametro` SMALLINT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(10000), `pValor` VARCHAR(10000), `pEsActivo` BIT, `pEsSensitivo` BIT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pIdEmpresa` INT)  BEGIN

	UPDATE Parametro
	   SET Nombre = pNombre
		  ,Descripcion = pDescripcion
		  ,Valor = pValor
		  ,EsActivo = pEsActivo
		  ,EsSensitivo = pEsSensitivo
		  ,FechaModificacion = now()
		  ,IdUsuarioUltimoModifico = pIdUsuarioLog
		  ,OrigenOperacion = pOrigenOperacion
	 WHERE IdParametro = pIdParametro
			AND IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ActParametroEmpresa`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActParametroEmpresa` (`pIdParametro` SMALLINT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(10000), `pValor` VARCHAR(10000), `pEsActivo` BIT, `pEsSensitivo` BIT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT)  BEGIN

	UPDATE parametroempresa
	   SET Nombre = pNombre
		  ,Descripcion = pDescripcion
		  ,Valor = pValor
		  ,EsActivo = pEsActivo
		  ,EsSensitivo = pEsSensitivo
		  ,FechaModificacion = now()
		  ,IdUsuarioUltimoModifico = pIdUsuarioLog
		  ,OrigenOperacion = pOrigenOperacion
	 WHERE IdParametro = pIdParametro;

END$$

DROP PROCEDURE IF EXISTS `ActProspecto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActProspecto` (IN `pIdProspecto` INT, IN `pNombre` VARCHAR(100), IN `pApellidos` VARCHAR(100), IN `pFechaNacimiento` TIMESTAMP, IN `pRFC` VARCHAR(13), IN `pEmail` VARCHAR(100), IN `pTelefonoMovil` VARCHAR(10), IN `pTelefonoOtro` VARCHAR(10), IN `pIdSexo` INT, IN `pDireccion` VARCHAR(250), IN `pSalario` DOUBLE, IN `pIdCiudad` INT, IN `pIdEstadoCivil` INT, IN `pIdEscolaridad` INT, IN `pIdUsuarioLog` INT, IN `pEstatus` TINYINT(1), IN `pIdEmpresa` INT)  BEGIN 

	UPDATE prospecto
	SET
	  Nombre = pNombre,
	  Apellidos = pApellidos,
	  FechaNacimiento = pFechaNacimiento,
	  RFC = pRFC,
	  Email = pEmail,
	  TelefonoMovil = pTelefonoMovil, 
	  TelefonoOtro = pTelefonoOtro,
	  IdSexo = pIdSexo,
	  Direccion = pDireccion,
	  Salario = pSalario,
	  IdCiudad = pIdCiudad,
	  IdEstadoCivil = pIdEstadoCivil,
	  IdEscolaridad = pIdEscolaridad,
	  IdUsuarioUltimoModifico = pIdUsuarioLog,
	  FechaModificacion = now(),
	  Estatus = pEstatus
	WHERE IdProspecto = pIdProspecto
		  and IdEmpresa = pIdEmpresa;
        
        SELECT null as ErrorMessage;
END$$

DROP PROCEDURE IF EXISTS `ActReferenciaLaboral`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActReferenciaLaboral` (IN `pIdreferencia` INT, IN `pIdProspecto` INT, IN `pEmpresa` VARCHAR(150), IN `pDomicilio` VARCHAR(150), IN `pContacto` VARCHAR(100), IN `pContacto_Email` VARCHAR(64), IN `pContacto_Telefono` VARCHAR(32), IN `pMotivoSeparacion` VARCHAR(150), IN `pPuesto` VARCHAR(150), IN `pTiempoLaborado` VARCHAR(128), IN `pComentario` VARCHAR(128), IN `pEstatus` TINYINT(1), IN `pIdUsuarioLog` INT, IN `pIdEmpresa` INT, IN `pEliminar` INT)  BEGIN
  DECLARE pId INT;
  
  IF pEliminar = 0 THEN
  BEGIN
	UPDATE referencialaboral SET 
		IdProspecto = IdProspecto,
		Empresa = pEmpresa,
		Domicilio = pDomicilio,
        Contacto = pContacto,
		Contacto_Email = pContacto_Email,
		Contacto_Telefono = pContacto_Telefono,
		MotivoSeparacion = pMotivoSeparacion,
		Puesto = pPuesto,
		TiempoLaborado = pTiempoLaborado,
		Comentario = pComentario,
		Estatus = pEstatus,
		IdUsuarioUltimoModifico = pIdUsuarioLog,
		FechaModificacion = now(),
		IdEmpresa = pIdEmpresa
	WHERE
		IdReferencia = pIdReferencia;
        
	set pId = pIdReferencia;
    SELECT null as ErrorMessage, pId as Id;
  END;
  
  ELSE
  BEGIN
	UPDATE referencialaboral SET Estatus = 0,
		IdUsuarioUltimoModifico = pIdUsuarioLog,
		FechaModificacion = now()
	WHERE
		IdReferencia = pIdReferencia;
        
	set pId = pIdReferencia;
        SELECT null as ErrorMessage, pId as Id;
  END;
END IF;
        
END$$

DROP PROCEDURE IF EXISTS `ActRol`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActRol` (`pIdRol` INT, `pNombreRol` VARCHAR(50), `pEstatus` INT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pIdEmpresa` INT)  BEGIN

	UPDATE Roles
		SET NombreRol = pNombreRol
			, Estatus = pEstatus
			, FechaModificacion = now()
			, IdUsuarioUltimoModifico = pIdUsuarioLog
			, OrigenOperacion = pOrigenOperacion
		WHERE IdRol = pIdRol
        AND IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ActSubCatalogo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActSubCatalogo` (`pClave` VARCHAR(12), `pIdUsuarioLog` INT, `pIdSubCatalogo` INT, `pIdCatalogo` INT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(256), `pIdTipoCatalogo` SMALLINT, `pIdEmpresa` INT, `pEsActivo` TINYINT(1))  BEGIN
	
    DECLARE pId INT;
    SET pId = 0;
    
    IF NOT EXISTS (	SELECT 1 
					FROM 
						SubCatalogo 
					WHERE 
						IdEmpresa = pIdEmpresa
                        AND IdSubCatalogo != pIdSubCatalogo
                        AND IdCatalogo = pIdCatalogo
						AND IdTipoCatalogo = pidTipoCatalogo 
						AND Clave = pClave
						AND EsActivo = 1) THEN
	UPDATE SubCatalogo
		SET
			IdCatalogo=pIdCatalogo
			,Clave = pClave
			,Nombre = pNombre
			,Descripcion = pDescripcion
			,IdTipoCatalogo = pIdTipoCatalogo
			,EsActivo = pEsActivo
			,FechaModificacion = now()
			,IdUsuarioUltimoModifico = pIdUsuarioLog
        WHERE
			IdSubCatalogo = pIdSubCatalogo
            AND IdEmpresa = pIdEmpresa;
            
        SET pId = pIdSubCatalogo;
	END IF;
    
    SELECT pId as Id;
END$$

DROP PROCEDURE IF EXISTS `ActUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActUsuario` (`pIdUsuario` INT, `pLogin` VARCHAR(250), `pNombreCompleto` VARCHAR(250), `pCorreoElectronico` VARCHAR(250), `pContrasenia` VARCHAR(100), `pActivo` INT, `pComentarios` VARCHAR(512), `pUltimoModifico` INT, `pIdInstitucion` INT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pIdEmpresa` INT, `pDomicilio` VARCHAR(250), `pTelefono` VARCHAR(32), `pReferencia` VARCHAR(100), `pReferenciaTelefono` VARCHAR(32), `pFechaNacimiento` DATE)  BEGIN

IF (SELECT COUNT(1)
 		from Usuario 
 		where	Login = pLogin 
				and IdUsuario != pIdUsuario
 				and Activo = 1
                AND IdEmpresa = pIdEmpresa) != 0 THEN
		SELECT 'Error al insertar: El nombre de usuario que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
	    
 	ELSEIF (SELECT COUNT(1)
 		from Usuario 
 		where	CorreoElectronico = pCorreoElectronico 
				and IdUsuario != pIdUsuario
 				and Activo = 1 
                AND IdEmpresa = pIdEmpresa) != 0 THEN
 		SELECT 'Error al insertar: El correo electrónico que intenta guardar ya esta siendo utilizado.' as ErrorMessage;        
        
 	ELSE
		UPDATE Usuario
 		SET   
 		   Login				= pLogin
 		  ,NombreCompleto		= pNombreCompleto
 		  ,CorreoElectronico	= pCorreoElectronico
 		  ,Contrasenia			= pContrasenia
 		  ,Activo				= pActivo
 		  ,UltimoModifico		= pUltimoModifico
 		  ,Comentarios			= pComentarios
 		  ,IdInstitucion		= case when pIdInstitucion = 0 then null else pIdInstitucion end
 		  ,FechaModificacion 	= now()
 	      ,IdUsuarioUltimoModifico = pIdUsuarioLog
 		  ,OrigenOperacion 		= pOrigenOperacion          
			,Domicilio 			= pDomicilio
			,Telefono 			= pTelefono
			,Referencia 		= pReferencia
			,ReferenciaTelefono = pReferenciaTelefono
			,FechaNacimiento 	= pFechaNacimiento
 		WHERE IdUsuario = pIdUsuario
				AND IdEmpresa = pIdEmpresa;
        
        SELECT null as ErrorMessage;
        
	END IF;

END$$

DROP PROCEDURE IF EXISTS `ActUsuarioConstrasenia`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActUsuarioConstrasenia` (`pIdUsuario` INT, `pContrasenia` NVARCHAR(64), `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pIdEmpresa` INT)  BEGIN
	
    if pIdUsuario = 0 and pIdEmpresa !=0 then
		update empresa
        set Contraseña = pContrasenia
        WHERE IdEmpresa = pIdEmpresa;
    else     
		UPDATE  Usuario	  
		SET		Contrasenia = pContrasenia		  
			   ,CodigoRecuperaContrasenia = null
			   ,UltimoModifico = 1 -- El propio usuario modifico su contraseña
			   ,FechaModificacion = now()
			   ,IdUsuarioUltimoModifico = pIdUsuarioLog
			   ,OrigenOperacion = pOrigenOperacion
		WHERE IdUsuario = pIdUsuario
		AND IdEmpresa = pIdEmpresa;
	end if;
	
	IF(ROW_COUNT() > 0) THEN
			SELECT 1 ;
	ELSE
			SELECT 0;
	end if;

END$$

DROP PROCEDURE IF EXISTS `ActUsuarioRecuperarContrasenia`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActUsuarioRecuperarContrasenia` (`peMail` VARCHAR(64), `pCodigoRecuperacion` VARCHAR(32), `pOrigenOperacion` INT, `pIdEmpresa` INT)  BEGIN

	Declare pNumeroRegistros int;
    
	create TEMPORARY TABLE ptblUsuario
    (IdUsuario INT, Login VARCHAR(32), CodigoRecuperaContrasenia VARCHAR(32));	

    -- Insert statements for procedure here
	INSERT INTO ptblUsuario
	SELECT Usuario.IdUsuario, Usuario.Login, pCodigoRecuperacion
	FROM Usuario
	WHERE CorreoElectronico = peMail 
			and Usuario.Activo = 1
            AND IdEmpresa = pIdEmpresa;

	SET pNumeroRegistros = (select count(*) From ptblUsuario);
    
    
	IF (pNumeroRegistros = 1) then
			Update Usuario 
			Set CodigoRecuperaContrasenia 	= pCodigoRecuperacion  
				,FechaModificacion 			= now()
				,IdUsuarioUltimoModifico 	= IdUsuario
				,OrigenOperacion 			= pOrigenOperacion
			WHERE
				EXISTS (SELECT 1 FROM ptblUsuario WHERE Usuario.IdUsuario = tblUsuario.Idusuario and Usuario.Login = tblUsuario.Login)
                AND IdEmpresa = pIdEmpresa;            
	End IF;    
    
	Select * From ptblUsuario;
    
END$$

DROP PROCEDURE IF EXISTS `ActVacante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActVacante` (IN `pIdVacante` INT, IN `pTitulo` VARCHAR(100), IN `pDescripcion` VARCHAR(100), IN `pFechaContratacion` DATE, IN `pNumeroVacantes` INT(11), IN `pSalario` DOUBLE, IN `pIdTipoContrato` INT(11), IN `pIdTipoJornada` INT(11), IN `pIdCiudad` VARCHAR(10), IN `pIdUsuarioUltimoModifico` INT(11), IN `pEstatus` TINYINT(4), IN `pComentarios` VARCHAR(300), IN `pIdEmpresa` INT(11), IN `pFase` VARCHAR(90), IN `pFechaEntrega` DATE)  BEGIN

	IF(
			SELECT COUNT(1)
			FROM reclutamiento.vacante
			WHERE vacante.Titulo= pTitulo
			AND vacante.descripcion=pDescripcion
			AND vacante.FechaContratacion= pFechaContratacion
			AND vacante.NumeroVacantes=pNumeroVacantes
			AND vacante.Salario=pSalario
			AND vacante.IdTipoContrato=pIdTipoContrato
			AND vacante.IdTipoJornada=pIdTipoJornada
			AND vacante.IdCiudad=pIdCiudad
			AND vacante.FechaEntrega=pFechaEntrega
			AND vacante.idEmpresa =pIdEmpresa
			AND vacante.Estatus=pEstatus)!=0 
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
				IdVacante=pIdVacante
			AND 
				IdEmpresa=pIdEmpresa;

	SELECT NULL AS ErrorMessage;

END IF;

END$$

DROP PROCEDURE IF EXISTS `ActVacanteCaracteristica`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActVacanteCaracteristica` (IN `pIdVacanteCaracteristica` INT(11), IN `pIdVacante` INT(11), IN `pIdCaracteristicaParticular` INT(11), IN `pValor` VARCHAR(100), IN `pComentario` VARCHAR(200))  BEGIN
	
	IF( SELECT COUNT(1)
			FROM reclutamiento.vacantecaracteristica
			WHERE 
				vacantecaracteristica.IdVacante= pIdVacante
			AND vacantecaracteristica.IdCaracteristicaParticular= pIdCaracteristicaParticular
			AND vacantecaracteristica.Valor= pValor) !=0 
	THEN 
		SELECT 'Error al insertar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
	ELSE

		UPDATE 
				reclutamiento.vacantecaracteristica
		SET
			
				vacantecaracteristica.IdVacante= pIdVacante,
				vacantecaracteristica.IdCaracteristicaParticular= pIdCaracteristicaParticular,
				vacantecaracteristica.Valor= pValor,
				vacantecaracteristica.Comentarios= PCommentario,
				vacantecaracteristica.Activo= pActivo
		WHERE 
				vacantecaracteristica.IdVacanteCaracteristica= pIdVacanteCaracteristica;

	SELECT NULL AS ErrorMessage;
END IF ;

END$$

DROP PROCEDURE IF EXISTS `EliDocsCliente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliDocsCliente` (IN `pId` INT)  BEGIN	
	declare pIdCD INT;
    
	DELETE FROM clientedocumentos
	WHERE ( Id = pId ) ;
	
    set pIdCD = 1;
    SELECT null as ErrorMessage;
END$$

DROP PROCEDURE IF EXISTS `EliDocsProspecto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliDocsProspecto` (IN `pId` INT)  BEGIN	
	declare pIdCD INT;
    
	DELETE FROM prospectodocumentos
	WHERE ( Id = pId ) ;
	
    set pIdCD = 1;
    SELECT null as ErrorMessage;
END$$

DROP PROCEDURE IF EXISTS `EliRol`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliRol` (`pIdRol` INT, `pIdEmpresa` INT)  BEGIN

	IF not exists (select 1 from FormaRol where IdRol = pIdRol AND IdEmpresa = pIdEmpresa) THEN
		DELETE from Roles where IdRol = pIdRol AND IdEmpresa = pIdEmpresa;
		SELECT 0 as IdRol;
	ELSE
 		UPDATE Roles
		set Estatus = 0
 		where IdRol = pIdRol        
        AND IdEmpresa = pIdEmpres;
        
 		SELECT pIdRol as IdRol;
	END if;

END$$

DROP PROCEDURE IF EXISTS `EliRolUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliRolUsuario` (`pIdUsuario` INT, `pIdRol` INT, `pIdEmpresa` INT)  BEGIN

	delete from RolUsuario
	where IdUsuario = pIdUsuario
		  AND IdRol = pIdRol
          AND IdEmpresa = pIdEmpresa; 					
    
END$$

DROP PROCEDURE IF EXISTS `EliUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliUsuario` (`pIdUsuario` INT, `pIdEmpresa` INT)  BEGIN

	DELETE from Usuario where IdUsuario = pIdUsuario AND IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `InsAliasEstatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsAliasEstatus` (`pIdEmpresa` INT, `pIdCartera` INT, `pIdTipoGestion` INT, `pIdEstatus` INT, `pAlias` VARCHAR(64), `pIdUsuarioLog` INT)  BEGIN

	IF pAlias is null or pAlias = '' THEN
    
		DELETE 
        FROM 
			estatuscartera
		WHERE
			IdEstatus         = pIdEstatus
			and IdEmpresa     = pIdEmpresa 
			and IdCartera     = pIdCartera
			and IdTipoGestion = pIdTipoGestion;
            
 	ELSEIF EXISTS (SELECT 1
					FROM 
						estatuscartera
					WHERE
						IdEstatus         = pIdEstatus
						and IdEmpresa     = pIdEmpresa 
						and IdCartera     = pIdCartera
						and IdTipoGestion = pIdTipoGestion) then
		
        UPDATE estatuscartera
		SET
		IdUsuarioUltimoModifico = pIdUsuarioLog,
		FechaModificacion = now(),
		Alias = pAlias
		WHERE
			IdEstatus         = pIdEstatus
			and IdEmpresa     = pIdEmpresa 
			and IdCartera     = pIdCartera
			and IdTipoGestion = pIdTipoGestion;
            
	ELSE
    
		INSERT INTO estatuscartera
		(
		IdEmpresa,
		IdCartera,
		IdTipoGestion,
		IdEstatus,
		IdUsuarioCreacion,
		FechaCreacion,
		IdUsuarioUltimoModifico,
		FechaModificacion,
		Alias)
		VALUES
		(
        pIdEmpresa,
		pIdCartera,
		pIdTipoGestion,
		pIdEstatus,
		pIdUsuarioLog,
		now(),
		pIdUsuarioLog,
		now(),
		pAlias);
        
	END IF;

END$$

DROP PROCEDURE IF EXISTS `InsBitacora`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsBitacora` (IN `pIdProspecto` INT, IN `pComentario` VARCHAR(250), IN `pIdUsuarioLog` INT)  BEGIN
    DECLARE pIdBitacora INT;

    INSERT INTO bitacora
	(
		IdProspecto,
		Comentario,
		IdUsuarioCreacion,
		FechaCreacion
	)
	VALUES
	(
		pIdProspecto,
		pComentario,
		pIdUsuarioLog,
		now()
	);
        
	set pIdBitacora = (SELECT MAX(IdBitacora) from bitacora);
        SELECT null as ErrorMessage, pIdBitacora as IdBitacora;
        
END$$

DROP PROCEDURE IF EXISTS `InsCaracteristicaParticular`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCaracteristicaParticular` (IN `pClave` VARCHAR(10), IN `pNombre` VARCHAR(100), IN `pIdTipoCampo` INT(11), IN `pIdUsuarioCreacion` INT(11), IN `pIdUsuarioUltimoModifico` INT(11), IN `pFechaModificacion` TIMESTAMP, IN `pEstatus` TINYINT(4), IN `pIdEmpresa` INT(11))  BEGIN
	DECLARE IdCaracteristicaParticular INT(11);
	IF (SELECT COUNT(1)
			FROM reclutamiento.caracteristicaparticular
			WHERE 
					caracteristicaparticular.Clave=pClave 
				AND  caracteristicaparticular.Nombre=pNombre
				AND caracteristicaparticular.IdTipoCampo = pIdTipoCampo 
				AND caracteristicaparticular.IdEmpresa= pIdEmpresa
				AND caracteristicaparticular.Estatus=pEstatus
		)!=0 THEN 
			SELECT 'Error al insertar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;	
	ELSE 
		INSERT INTO reclutamiento.caracteristicaparticular
			(
				caracteristicaparticular.Clave,
				caracteristicaparticular.Nombre,
				caracteristicaparticular.IdTipoCampo,
				caracteristicaparticular.IdUsuarioCreacion,
				caracteristicaparticular.IdUsuarioUltimoModifico,
				caracteristicaparticular.FechaModificacion,
				caracteristicaparticular.Estatus,
				caracteristicaparticular.IdEmpresa
			)	
			VALUES 
			(
				pClave,
				pNombre,
				pIdTipoCampo, 
				pIdUsuarioCreacion,
				pIdUsuarioUltimoModifico, 
				NOW(),
				pEstatus, 
				pIdEmpresa
			);
			SET IdCaracteristicaParticular= (SELECT MAX(IdCaracteristicaParticular) FROM reclutamiento.caracteristicaparticular);
			SELECT  NULL AS ErrorMessage, IdCaracteristicaParticular as IdCaracteristicaParticular;
		END IF ;
END$$

DROP PROCEDURE IF EXISTS `InsCatalogo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCatalogo` (`pClave` VARCHAR(12), `pIdUsuarioLog` INT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(256), `pIdTipoCatalogo` SMALLINT, `pIdEmpresa` INT)  BEGIN
	DECLARE pIdCatalogo INT;
    
	INSERT INTO Catalogo
		(
			Clave
			,Nombre
			,Descripcion
			,IdTipoCatalogo
			,IdUsuarioCreacion
			,IdUsuarioUltimoModifico
			,FechaCreacion
			,FechaModificacion
            ,IdEmpresa
		)
		VALUES
		(
			pClave
			,pNombre
			,pDescripcion
			,pIdTipoCatalogo
			,pIdUsuarioLog
			,pIdUsuarioLog
			,now()
			,now()
            ,pIdEmpresa
		);
        
        SELECT MAX(IdCatalogo) from Catalogo;
END$$

DROP PROCEDURE IF EXISTS `InsCiudades`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCiudades` (IN `pCiudades` MEDIUMTEXT)  BEGIN

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

DROP PROCEDURE IF EXISTS `InsCliente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCliente` (IN `pIdEmpresa` INT, IN `pRFC` VARCHAR(13), IN `pRazonSocial` VARCHAR(96), IN `pNombreComercial` VARCHAR(64), IN `pDireccion` VARCHAR(250), IN `pContacto_Nombre` VARCHAR(64), IN `pContacto_Email` VARCHAR(64), IN `pContacto_Telefono` VARCHAR(32), IN `pComentarios` VARCHAR(128), IN `pEstatus` TINYINT(1), IN `pIdUsuarioLog` INT, IN `pEmpresaCorreo` VARCHAR(64), IN `pEmpresaTelefono` VARCHAR(64))  BEGIN
    DECLARE pIdCliente INT;
    
 	IF (SELECT COUNT(1)
 		from cliente 
 		where	RFC = pRFC 
                AND IdEmpresa = pIdEmpresa) != 0 THEN
		SELECT 'Error al insertar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
	    
 	ELSE
 		
        INSERT INTO cliente
	(
		IdEmpresa,
		RFC,
		RazonSocial,
		NombreComercial,
		Direccion,
        	EmpresaCorreo,
        	EmpresaTelefono,
        	Contacto_Nombre,
		Contacto_Email,
		Contacto_Telefono,
		Comentarios,
		Estatus,
		IdUsuarioCreacion,
		FechaCreacion,
		IdUsuarioUltimoModifico,
		FechaModificacion
	)
	VALUES
	(
		pIdEmpresa,
		pRFC,
		pRazonSocial,
		pNombreComercial,
		pDireccion,
        	pEmpresaCorreo,
                pEmpresaTelefono,
		pContacto_Nombre,
		pContacto_Email,
		pContacto_Telefono,
		pComentarios,
		pEstatus,
		pIdUsuarioLog,
		now(),
		pIdUsuarioLog,
		now()
	);
        
	set pIdCliente = (SELECT MAX(IdCliente) from cliente);
        SELECT null as ErrorMessage, pIdCliente as IdCliente;
        
	END IF;
END$$

DROP PROCEDURE IF EXISTS `InsColonias`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsColonias` (IN `pColonias` LONGTEXT)  BEGIN

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

DROP PROCEDURE IF EXISTS `InsDocsCliente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsDocsCliente` (IN `pIdCliente` INT, IN `pIdDocumento` INT, IN `pNombre` VARCHAR(150), IN `pUrl` VARCHAR(250), IN `pEstatus` TINYINT, IN `pIdUsuarioLog` INT, IN `pIdEmpresa` INT)  BEGIN 
  DECLARE pId INT; 

  INSERT INTO clientedocumentos ( 
    IdCliente, IdDocumento, Nombre, Url, Estatus, IdUsuarioCreacion, FechaCreacion,
    IdUsuarioModificacion, FechaModificacion, IdEmpresa
  ) VALUES ( 
    pIdCliente, pIdDocumento, pNombre, pUrl, pEstatus, PIdUsuarioLog, now(), 
    pIdUsuarioLog, now(), pIdEmpresa
  ); 

  set pId = 1; 
  SELECT null as ErrorMessage, pIdDocumento as Id; 
END$$

DROP PROCEDURE IF EXISTS `InsDocsProspecto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsDocsProspecto` (IN `pIdProspecto` INT, IN `pIdDocumento` INT, IN `pNombre` VARCHAR(150), IN `pUrl` VARCHAR(250), IN `pEstatus` TINYINT, IN `pIdUsuarioLog` INT, IN `pIdEmpresa` INT)  BEGIN 
  DECLARE pId INT; 

  INSERT INTO prospectodocumentos ( 
    IdProspecto, IdDocumento, Nombre, Url, Estatus, IdUsuarioCreacion, FechaCreacion,
    IdUsuarioModificacion, FechaModificacion, IdEmpresa
  ) VALUES ( 
    pIdProspecto, pIdDocumento, pNombre, pUrl, pEstatus, PIdUsuarioLog, now(), 
    pIdUsuarioLog, now(), pIdEmpresa
  ); 

  set pId = 1; 
  SELECT null as ErrorMessage, pIdDocumento as Id; 
END$$

DROP PROCEDURE IF EXISTS `InsEliRolUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsEliRolUsuario` (`pIdRol` INT, `pIdUsuario` INT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pEstatus` INT, `pIdEmpresa` INT)  BEGIN

	IF pEstatus = 1 THEN
		IF NOT EXISTS (SELECT 1 FROM RolUsuario WHERE IdUsuario = pIdUsuario and IdRol = pIdRol AND IdEmpresa = pIdEmpresa) THEN
			INSERT INTO RolUsuario ( IdUsuario, IdRol, IdUsuarioCreacion ,IdUsuarioUltimoModifico, FechaCreacion, FechaModificacion, OrigenOperacion, IdEmpresa)
            VALUES
            (pIdUsuario, pIdRol, pIdUsuarioLog, pIdUsuarioLog, NOW(), NOW(), pOrigenOperacion, pIdEmpresa); 
		END IF;
    ELSE
		DELETE FROM RolUsuario WHERE IdUsuario = pIdUsuario and IdRol = pIdRol AND IdEmpresa = pIdEmpresa;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `InsEstados`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsEstados` (IN `pEstados` TEXT)  BEGIN

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

DROP PROCEDURE IF EXISTS `InsFormaRol`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsFormaRol` (`pIdForma` INT, `pIdRol` INT, `pPrivilegio` INT, `pIdEmpresa` INT)  BEGIN

	if pPrivilegio = 0 THEN
 		delete from FormaRol 
 		where	IdRol = pIdRol
 				and IdForma = pIdForma
                AND IdEmpresa = pIdEmpresa;
 	elseif EXISTS (SELECT 1 FROM FormaRol WHERE IdRol = pIdRol AND IdForma = pIdForma AND IdEmpresa = pIdEmpresa) THEN
 			update FormaRol
 			set Privilegios = pPrivilegio
 			where	IdRol = pIdRol
 					and IdForma = pIdForma
                    AND IdEmpresa = pIdEmpresa;
	else
 		insert FormaRol (IdForma, IdRol, Privilegios, IdEmpresa) values
 			(pIdForma, pIdRol, pPrivilegio, pIdEmpresa);
 	end if;

END$$

DROP PROCEDURE IF EXISTS `InsProspecto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsProspecto` (IN `pIdProspecto` INT, IN `pNombre` VARCHAR(100), IN `pApellidos` VARCHAR(100), IN `pFechaNacimiento` TIMESTAMP, IN `pRFC` VARCHAR(13), IN `pEmail` VARCHAR(100), IN `pTelefonoMovil` VARCHAR(10), IN `pTelefonoOtro` VARCHAR(10), IN `pIdSexo` INT, IN `pDireccion` VARCHAR(250), IN `pSalario` DOUBLE, IN `pIdCiudad` INT, IN `pIdEstadoCivil` INT, IN `pIdEscolaridad` INT, IN `pIdUsuarioLog` INT, IN `pEstatus` TINYINT(1), IN `pIdEmpresa` INT)  BEGIN 
  INSERT INTO prospecto
	(
	  Nombre,
	  Apellidos,
	  FechaNacimiento,
	  RFC,
	  Email,
	  TelefonoMovil, 
	  TelefonoOtro,
	  IdSexo,
	  Direccion,
	  Salario,
	  IdCiudad,
	  IdEstadoCivil,
	  IdEscolaridad,
	  IdUsuarioCreacion,
	  FechaCreacion,
	  IdUsuarioUltimoModifico,
	  FechaModificacion,
	  Estatus,
	  IdEmpresa
	)
	VALUES
	(
	  pNombre,
	  pApellidos,
	  pFechaNacimiento,
	  pRFC,
	  pEmail,
	  pTelefonoMovil,
	  pTelefonoOtro,
	  pIdSexo,
	  pDireccion,
	  pSalario,
	  pIdCiudad,
	  pIdEstadoCivil,
	  pIdEscolaridad,
	  pIdUsuarioLog,
	  now(),
      pIdUsuarioLog,
	  now(),
	  pEstatus,
	  pIdEmpresa
      );
      
      set pIdProspecto = (SELECT MAX(IdProspecto) from prospecto);
        SELECT null as ErrorMessage, pIdProspecto as IdProspecto;
END$$

DROP PROCEDURE IF EXISTS `InsReferenciaLaboral`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsReferenciaLaboral` (IN `pIdProspecto` INT, IN `pEmpresa` VARCHAR(150), IN `pDomicilio` VARCHAR(150), IN `pContacto` VARCHAR(100), IN `pContacto_Email` VARCHAR(64), IN `pContacto_Telefono` VARCHAR(32), IN `pMotivoSeparacion` VARCHAR(150), IN `pPuesto` VARCHAR(150), IN `pTiempoLaborado` VARCHAR(128), IN `pComentario` VARCHAR(128), IN `pEstatus` TINYINT(1), IN `pIdUsuarioLog` INT, IN `pIdEmpresa` INT)  BEGIN
    DECLARE pIdReferencia INT;

    INSERT INTO referencialaboral
	(
		IdProspecto,
		Empresa,
		Domicilio,
        	Contacto,
		Contacto_Email,
		Contacto_Telefono,
		MotivoSeparacion,
		Puesto,
		TiempoLaborado,
		Comentario,
		Estatus,
		IdUsuarioCreacion,
		FechaCreacion,
		IdUsuarioUltimoModifico,
		FechaModificacion,
		IdEmpresa
	)
	VALUES
	(
		pIdProspecto,
		pEmpresa,
		pDomicilio,
        	pContacto,
		pContacto_Email,
		pContacto_Telefono,
		pMotivoSeparacion,
		pPuesto,
		pTiempoLaborado,
		pComentario,
		pEstatus,
		pIdUsuarioLog,
		now(),
		pIdUsuarioLog,
		now(),
		pIdEmpresa
	);
        
	set pIdReferencia = (SELECT MAX(IdReferencia) from referencialaboral);
        SELECT null as ErrorMessage, pIdReferencia as IdReferencia;
        
END$$

DROP PROCEDURE IF EXISTS `InsRol`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsRol` (`pNombreRol` VARCHAR(50), `pIdUsuarioLog` INT, `pOrigenOperacion` TINYINT(3), `pIdEmpresa` INT)  BEGIN
	
	declare pIdRol int(11);
	declare pFormaInicio int;
	
    INSERT INTO roles
			   (NombreRol
			    ,Estatus
				,IdUsuarioCreacion
				,IdUsuarioUltimoModifico
				,FechaCreacion
				,FechaModificacion
				,OrigenOperacion
                ,IdEmpresa)
	 VALUES
		   (pNombreRol
			,1
			,pIdUsuarioLog
			,pIdUsuarioLog
			,now()
			,now()
			,pOrigenOperacion
            ,pIdEmpresa
			);
            
	SET  pIdRol = (SELECT MAX(IdRol) from Roles);
	SET pFormaInicio = 1;
    		
	INSERT INTO FormaRol 
	(
	IdForma,
	IdRol,
	Privilegios,
	IdUsuarioCreacion,
	FechaCreacion,
	IdUsuarioUltimoModifico,
	FechaModificacion,
	OrigenOperacion,
    IdEmpresa)
	VALUES
	(
	pFormaInicio,
	pIdRol, 
	1, 
	1, 
	now(),
	1,
	now(),
	1
    ,pIdEmpresa
	);
	
	select pIdRol as IdRol;
                
        
END$$

DROP PROCEDURE IF EXISTS `InsRolUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsRolUsuario` (`pIdUsuario` INT, `pIdRol` INT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pIdEmpresa` INT)  BEGIN

	if not exists(select 1 from RolUsuario where IdUsuario = pIdUsuario and IdRol = pIdRol AND IdEmpresa = pIdEmpresa) then
 			INSERT INTO RolUsuario
 			        ( IdUsuario
                     ,IdRol
                      ,IdUsuarioCreacion
 					 ,IdUsuarioUltimoModifico
 					 ,FechaCreacion
 					 ,FechaModificacion
 					 ,OrigenOperacion
                     ,IdEmpresa
 			        )
 			VALUES  (
 					pIdUsuario,
 					pIdRol
 					,pIdUsuarioLog
 					,pIdUsuarioLog
 					,now()
 					,now()
 					,pOrigenOperacion
                    ,pIdEmpresa
 			        );
	end if;

END$$

DROP PROCEDURE IF EXISTS `InsSubCatalogo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsSubCatalogo` (`pClave` VARCHAR(12), `pIdUsuarioLog` INT, `pIdCatalogo` INT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(256), `pIdTipoCatalogo` SMALLINT, `pIdEmpresa` INT)  BEGIN
	DECLARE pId INT;
    SET pId = 0;
    
    IF NOT EXISTS (	SELECT 1 
					FROM 
						SubCatalogo 
					WHERE 
						IdEmpresa = pIdEmpresa
                        AND IdCatalogo = pIdCatalogo
						AND IdTipoCatalogo = pidTipoCatalogo 
						AND Clave = pClave
						AND EsActivo = 1) THEN
	INSERT INTO SubCatalogo
		(
			IdCatalogo
            ,IdEmpresa
			,Clave
			,Nombre
			,Descripcion
			,IdTipoCatalogo
			,EsActivo
			,IdUsuarioCreacion
			,IdUsuarioUltimoModifico
			,FechaCreacion
			,FechaModificacion
		)
		VALUES
		(
			pIdCatalogo
            ,pIdEmpresa
			,pClave
			,pNombre
			,pDescripcion
			,pIdTipoCatalogo
			,1
			,pIdUsuarioLog
			,pIdUsuarioLog
			,now()
			,now()
		);
        SET pId = (SELECT MAX(IdSubCatalogo) FROM subcatalogo);
	END IF;
    
    SELECT pId as Id;
    
END$$

DROP PROCEDURE IF EXISTS `InsTipoAsentamientos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsTipoAsentamientos` (IN `pTipoAsentamiento` MEDIUMTEXT)  BEGIN

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

DROP PROCEDURE IF EXISTS `InsUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsUsuario` (`pLogin` VARCHAR(250), `pNombreCompleto` VARCHAR(250), `pCorreoElectronico` VARCHAR(250), `pContrasenia` VARCHAR(100), `pActivo` INT, `pComentarios` VARCHAR(512), `pUltimoModifico` INT, `pIdInstitucion` INT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pIdEmpresa` INT, `pDomicilio` VARCHAR(250), `pTelefono` VARCHAR(32), `pReferencia` VARCHAR(100), `pReferenciaTelefono` VARCHAR(32), `pFechaNacimiento` DATE)  BEGIN
    DECLARE pIdUsuario INT;
    
 	IF (SELECT COUNT(1)
 		from Usuario 
 		where	Login = pLogin 
 				and Activo = 1
                AND IdEmpresa = pIdEmpresa) != 0 THEN
		SELECT 'Error al insertar: El nombre de usuario que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
	    
 	ELSEIF (SELECT COUNT(1)
 		from Usuario 
 		where	CorreoElectronico = pCorreoElectronico 
 				and Activo = 1
                AND IdEmpresa = pIdEmpresa) != 0 THEN
 		SELECT 'Error al insertar: El correo electrónico que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
        
 	ELSE
 		INSERT INTO Usuario
 			   (Login
 			   ,NombreCompleto
 			   ,CorreoElectronico
 			   ,Contrasenia
 			   ,Activo
 			   ,UltimoModifico
 			   ,Comentarios
 			   ,IdInstitucion
			   ,IdUsuarioCreacion
			   ,IdUsuarioUltimoModifico
			   ,FechaCreacion
			   ,FechaModificacion
			   ,OrigenOperacion
               ,IdEmpresa               
				,Domicilio
				,Telefono
				,Referencia
				,ReferenciaTelefono
				,FechaNacimiento)
 		 VALUES
 			   (pLogin
 			   ,pNombreCompleto
 			   ,pCorreoElectronico
 			   ,pContrasenia
 			   ,pActivo
 			   ,pUltimoModifico
 			   ,pComentarios
 			   ,case when pIdInstitucion = 0 then null else pIdInstitucion end
 				,pIdUsuarioLog
 				,pIdUsuarioLog
 				,now()
 				,now()
 				,pOrigenOperacion
                ,pIdEmpresa
                ,pDomicilio
				,pTelefono
				,pReferencia
				,pReferenciaTelefono
				,pFechaNacimiento);                
                
		set pIdUsuario = (SELECT MAX(IdUsuario) from Usuario);
        SELECT null as ErrorMessage, pIdUsuario as IdUsuario;
        
	END IF;
    
END$$

DROP PROCEDURE IF EXISTS `InsVacante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante` (IN `pTitulo` VARCHAR(100), IN `pDescripcion` VARCHAR(100), IN `pFechaContratacion` TIMESTAMP, IN `pNumeroVacantes` INT(11), IN `pSalario` DOUBLE, IN `pIdTipoContrato` INT(11), IN `pIdTipoJornada` INT(11), IN `pIdCiudad` VARCHAR(10), IN `pIdUsuarioCreacion` INT(11), IN `pIdUsuarioUltimoModifico` INT(11), IN `pEstatus` TINYINT(4), IN `pComentarios` VARCHAR(300), IN `pIdEmpresa` INT(11), IN `pFase` INT(11), IN `pFechaEntrega` DATETIME)  BEGIN

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

DROP PROCEDURE IF EXISTS `InsVacanteCaracteristica`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacanteCaracteristica` (IN `pIdVacante` INT(11), IN `pIdCaracteristicaParticular` INT(11), IN `pValor` VARCHAR(100), IN `pComentario` VARCHAR(200), IN `pActivo` TINYINT)  BEGIN

DECLARE pIdVacanteCaracteristica INT(11);

	IF( SELECT COUNT(1)
			FROM reclutamiento.vacantecaracteristica
			WHERE 
				vacantecaracteristica.IdVacante= pIdVacante
			AND vacantecaracteristica.IdCaracteristicaParticular= pIdCaracteristicaParticular
			AND vacantecaracteristica.Valor= pValor) !=0 
	THEN 
		SELECT 'Error al insertar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
	ELSE 
		INSERT INTO 
				reclutamiento.vacantecaracteristica (
				vacantecaracteristica.IdVacante ,
				vacantecaracteristica.IdCaracteristicaParticular,
				vacantecaracteristica.Valor,
				vacantecaracteristica.Comentario,
				vacantecaracteristica.Activo

			)
		VALUES (
				pIdVacante,
				pIdCaracteristicaParticular,
				pValor,
				pComentario, 
				pActivo
				);

			SET pIdVacanteCaracteristica= (SELECT MAX(vacantecaracteristica.IdVacanteCaracteristica) 
											FROM
												reclutamiento.vacantecaracteristica);
			
			SELECT NULL AS ErrorMessage, pIdVacanteCaracteristica as pIdVacanteCaracteristica;
	END IF ;

END$$

DROP PROCEDURE IF EXISTS `ObtBitacora`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtBitacora` (IN `pIdProspecto` INT)  BEGIN
  SELECT
    b.IdBitacora as IdBitacora,
	
    b.IdProspecto as Idprospecto, 
	
    b.FechaCreacion as FechaCreacion,
    b.Comentario as Comentario,	
	
    case b.IdUsuarioCreacion 
		
	when 0 then 'Administrador'
	else (
	   select NombreCompleto From Usuario 
            
           where IdUsuario = b.IdUsuarioCreacion
		
    ) end as Quienagrego

  FROM 
	bitacora b
  WHERE
	IdProspecto = 1;
        
END$$

DROP PROCEDURE IF EXISTS `ObtCaracteristicaParticular`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicaParticular` (IN `pIdEmpresa` INT(11), IN `pEstatus` TINYINT(4))  BEGIN
		SELECT 
				caracteristicaparticular.IdCaracteristicaParticular,
				caracteristicaparticular.Clave,
				caracteristicaparticular.Nombre,
				caracteristicaparticular.IdTipoCampo,
				caracteristicaparticular.IdUsuarioCreacion,
				caracteristicaparticular.IdUsuarioUltimoModifico,
				caracteristicaparticular.FechaModificacion,
				caracteristicaparticular.Estatus,
				caracteristicaparticular.IdEmpresa
		FROM 
				reclutamiento.caracteristicaparticular
		WHERE 
				caracteristicaparticular.IdEmpresa = pIdEmpresa
		AND 
				caracteristicaparticular.Estatus= pEstatus;
END$$

DROP PROCEDURE IF EXISTS `ObtCatalogo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCatalogo` (`pidTipoCatalogo` INT, `pNombreCatalogo` VARCHAR(64), `pEsActivo` INT, `pIdEmpresa` INT)  BEGIN
	Declare pDesde tinyint;
	Declare pHasta tinyint;	
        
	if(pEsActivo = -1) then
		SET pDesde = 0;
		SET pHasta = 1;
	else
		SET pDesde = pEsActivo;
		SET pHasta = pEsActivo;
	end if;
	
    SELECT IdCatalogo
		,IdTipoCatalogo
		,Nombre
		,Descripcion
		,EsActivo
		,Clave
	FROM Catalogo
	WHERE 
		IdTipoCatalogo = pidTipoCatalogo 
        AND NOMBRE like concat('%', IFNULL(pNombreCatalogo, ''), '%')
	    AND EsActivo between pDesde AND pHasta
        AND IdEmpresa = pIdEmpresa ;
END$$

DROP PROCEDURE IF EXISTS `ObtCatalogoDelSubCatalogo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCatalogoDelSubCatalogo` (`pIdCatalogo` INT, `pIdEmpresa` INT)  BEGIN
	
    IF EXISTS (SELECT 1 FROM TipoCatalogo WHERE IdTipoCatalogo = pIdCatalogo AND TipoSubCatalogo = 0) THEN
		SELECT 
			cat.IdCatalogo
			, cat.Nombre
			, cat.EsActivo
		FROM Catalogo cat
		where 
			cat.IdTipoCatalogo = pIdCatalogo        
			AND cat.IdEmpresa = pIdEmpresa;
	ELSE
		SELECT 
			cat.IdSubCatalogo as IdCatalogo
			, cat.Nombre
			, cat.EsActivo
		FROM SubCatalogo cat
		where 
			cat.IdTipoCatalogo = pIdCatalogo            
			AND cat.IdEmpresa = pIdEmpresa;
	END IF;
    
END$$

DROP PROCEDURE IF EXISTS `ObtCatalogoPorNombre`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCatalogoPorNombre` (`pCatalogo` VARCHAR(100), `pIdEmpresa` INT)  BEGIN
	SELECT 
		cat.IdCatalogo
		, cat.Nombre
		, cat.EsActivo
	FROM Catalogo cat
	inner join TipoCatalogo tipo on tipo.IdTipoCatalogo = cat.IdTipoCatalogo 
	where tipo.Nombre = replace(pCatalogo, '_', ' ')
		and cat.IdEmpresa = pIdEmpresa;
END$$

DROP PROCEDURE IF EXISTS `ObtCatalogosDelSubCatalogo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCatalogosDelSubCatalogo` (`pIdCatalogo` INT)  BEGIN

	DECLARE pIdSubCatalogo int;
    DECLARE pIdCatalogoTemp int;
    
    CREATE TEMPORARY TABLE pTabla (
								Id int NOT NULL AUTO_INCREMENT PRIMARY KEY
								, IdCatalogo int
								, NombreLabel varchar(200)
								, NombreControl varchar(200) 
								, NombreControlPadre varchar(200)
							);

	
	SET pIdSubCatalogo = ifnull((select ifnull(IdTipoCatalogo_SubCatalogo, 0) from TipoCatalogo where IdTipoCatalogo = pIdCatalogo), 0);

	while(pIdSubCatalogo!=0) do
		
		insert pTabla(IdCatalogo, NombreLabel, NombreControl, NombreControlPadre)
		select
			Catalogo.IdTipoCatalogo_SubCatalogo
			, Catalogo.NombreSingular
			, concat('cmb', replace(Catalogo.NombreSingular, ' ', ''))
			, ifnull((	select 
							ifnull(replace(concat('cmb', temp.NombreSingular), ' ', ''), '') 
						from TipoCatalogo temp 
						where temp.IdTipoCatalogo = Catalogo.IdTipoCatalogo_SubCatalogo), '')
		from TipoCatalogo Catalogo
		where Catalogo.IdTipoCatalogo = pIdCatalogo ;
		
        SET pIdCatalogoTemp = (
								select 
									CatalogoSiguiente.IdTipoCatalogo_SubCatalogo									
								from TipoCatalogo CatalogoSiguiente
								where IdTipoCatalogo = pIdCatalogo
							  );
		SET pIdSubCatalogo = (
								select 
									ifnull((	select 
													ifnull(IdTipoCatalogo_SubCatalogo, 0) 
												from TipoCatalogo temp 
												where temp.IdTipoCatalogo = CatalogoSiguiente.IdTipoCatalogo_SubCatalogo), 0)									
								from TipoCatalogo CatalogoSiguiente
								where IdTipoCatalogo = pIdCatalogo
							  );
		SET pIdCatalogo = pIdCatalogoTemp;

	end while;    
	
	select *
	from pTabla;
    
    DROP TEMPORARY TABLE pTabla;

END$$

DROP PROCEDURE IF EXISTS `ObtCiudades`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCiudades` (IN `pClaveEstado` VARCHAR(512), IN `pNombre` VARCHAR(512), IN `pActivo` INT)  BEGIN
SELECT Clave_Ciudad
      ,Nombre
FROM ciudad
WHERE Nombre like concat('%', IFNULL(pNombre, ''), '%') 
	AND Clave_Estado = pClaveEstado
	AND Estatus = pActivo
ORDER BY Nombre ASC;
END$$

DROP PROCEDURE IF EXISTS `ObtCiudadTexto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCiudadTexto` (IN `pClaveCiudad` VARCHAR(3), IN `pClaveEstado` VARCHAR(3))  BEGIN

		SELECT 
			ciudad.nombre
		FROM 
			reclutamiento.ciudad
		WHERE 
			ciudad.Clave_Ciudad= pClaveCiudad AND ciudad.Clave_Estado= pClaveEstado;

END$$

DROP PROCEDURE IF EXISTS `ObtClienteId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClienteId` (IN `pIdCliente` INT)  BEGIN
	SELECT
	   IdCliente,
	   IdEmpresa,
	   RFC,
	   RazonSocial,
	   NombreComercial,
	   Direccion,
       EmpresaCorreo,
       EmpresaTelefono,
	   Contacto_Nombre,
	   Contacto_Email,
	   Contacto_Telefono,
	   Comentarios,
	   Estatus
	FROM cliente
	where 
		IdCliente = pIdCliente;

END$$

DROP PROCEDURE IF EXISTS `ObtClientes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClientes` (IN `pRazonSocial` VARCHAR(96), IN `pEstatus` TINYINT, IN `pIdEmpresa` INT)  BEGIN

	Declare pDesde tinyint;
	Declare pHasta tinyint;	
        
	if(pEstatus = -1) then
		SET pDesde = 0;
		SET pHasta = 1;
	else
		SET pDesde = pEstatus;
		SET pHasta = pEstatus;
	end if;
	
	SELECT
	   IdCliente,
	   IdEmpresa,
	   RFC,
	   RazonSocial,
	   NombreComercial,
	   Direccion,
       EmpresaCorreo,
       EmpresaTelefono,
	   Contacto_Nombre,
	   Contacto_Email,
	   Contacto_Telefono,
	   Comentarios,
	   Estatus
	FROM cliente
	where RazonSocial like concat('%', IFNULL(pRazonSocial, ''), '%')
			and Estatus between pDesde and pHasta
			AND IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtColonias`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtColonias` (IN `pClaveCiudad` VARCHAR(512), IN `pNombre` VARCHAR(512), IN `pActivo` INT)  BEGIN
SELECT Clave_Colonia
      , Nombre
      , CodigoPostal
FROM ciudad
WHERE Nombre like concat('%', IFNULL(pNombre, ''), '%') 
	AND Clave_Colonia = pClaveColonia
	AND Estatus = pActivo
ORDER BY Nombre ASC;
END$$

DROP PROCEDURE IF EXISTS `ObtContratosTipo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtContratosTipo` (IN `pIdEmpresa` INT(11), IN `pIdTipoCatalogo` INT(11))  BEGIN
	
SELECT 
		 catalogo.IdCatalogo, catalogo.Nombre
 FROM 	reclutamiento.catalogo
WHERE  			catalogo.IdEmpresa=pIdEmpresa
		AND 	catalogo.IdTipocatalogo=pIdTipocatalogo
		AND 	catalogo.EsActivo=1;

END$$

DROP PROCEDURE IF EXISTS `ObtDetallesCatalogo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDetallesCatalogo` (IN `pNombreCatalogo` VARCHAR(100), IN `pIdEmpresa` INT)  BEGIN
SELECT 
	*
FROM 
	catalogo

WHERE 
	IdTipoCatalogo = (Select IdTipoCatalogo From TipoCatalogo Where NombreSingular = pNombreCatalogo)
	AND IdEmpresa = pIdEmpresa AND EsActivo = 1;
END$$

DROP PROCEDURE IF EXISTS `ObtDocsCliente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDocsCliente` (IN `pIdCliente` INT, IN `pIdEmpresa` INT)  BEGIN	
	SELECT
	   c.IdCliente as IdCliente,
	   c.IdDocumento as IdDocumento,
	   c.Nombre as Nombre,
	   c.Url as Url,
	   c.IdEmpresa as Idempresa,
	   cat.Nombre as DescDocumento,
	   c.Id
	FROM clientedocumentos c, catalogo cat
	where (c.IdDocumento = cat.IdCatalogo) 
	  AND
	  c.IdCliente = pIdCliente AND c.IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtDocsProspecto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDocsProspecto` (IN `pIdProspecto` INT, IN `pIdEmpresa` INT)  BEGIN	
	SELECT
	   p.IdProspecto as IdProspecto,
	   p.IdDocumento as IdDocumento,
	   p.Nombre as Nombre,
	   p.Url as Url,
	   p.IdEmpresa as Idempresa,
	   cat.Nombre as DescDocumento,
	   p.Id
	FROM prospectodocumentos p, catalogo cat
	where (p.IdDocumento = cat.IdCatalogo) 
	  AND
	  p.IdProspecto = pIdProspecto AND p.IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtEmpresas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtEmpresas` ()  BEGIN
	SELECT 
		IdEmpresa,
        Dominio,
        ProductKey,
        Administrador,
        Contrasenia,
        NombreComercial,
        RutaLogo
    FROM empresa;
END$$

DROP PROCEDURE IF EXISTS `ObtenerParametros`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerParametros` ()  BEGIN
    
    SELECT
		IdParametro
		, Nombre
		, Descripcion
		, Valor
        , IdEmpresa
    FROM Parametro
    WHERE 
		EsActivo = 1
	UNION
    SELECT
		IdParametro
		, Nombre
		, Descripcion
		, Valor
        , null as IdEmpresa
    FROM parametroempresa
    WHERE 
		EsActivo = 1;

END$$

DROP PROCEDURE IF EXISTS `ObtEstados`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtEstados` (IN `pClavePais` VARCHAR(512), IN `pActivo` INT)  BEGIN
SELECT Clave_Estado
      ,Nombre
FROM estado
WHERE Clave_Pais = pClavePais
	AND Estatus = pActivo
ORDER BY Nombre ASC;
END$$

DROP PROCEDURE IF EXISTS `ObtFormas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtFormas` (IN `pIdEmpresa` INT)  BEGIN
	
    SELECT
		IdForma
        , TextoLink
        , Descripcion
	FROM Forma
    WHERE 
		IdEmpresa = 1
		AND Estatus = 1
        AND EsSuperAdministrador = 0;    
    
END$$

DROP PROCEDURE IF EXISTS `ObtFormasRolesPrivilegiosPorAdministrador`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtFormasRolesPrivilegiosPorAdministrador` (IN `pIdEmpresa` INT, IN `pEsSuperAdministrador` TINYINT(1))  BEGIN
	DECLARE pIdFormaCatalogo int;
	DECLARE pEsOpcionMenu int;
	DECLARE pCuantos int;
	DECLARE pIndice int;
	DECLARE pIdForma int;
	DECLARE pPrivilegio int;
	DECLARE pSumaPrivilegios int;
    
    SET pSumaPrivilegios = 0;
    
	CREATE TEMPORARY TABLE pT_Menu_Privilegios (     
							Id int NOT NULL AUTO_INCREMENT PRIMARY KEY
                            ,Privilegio INT
							);
                            
	INSERT INTO pT_Menu_Privilegios (Privilegio)
    SELECT
		Privilegio
	FROM permiso
    WHERE /* IdEmpresa = pIdEmpresa
		AND */ Estatus = 1;
    
    SET pCuantos = (select count(1) from pT_Menu_Privilegios);
	SET pIndice = 1;
    
    while pIndice <= pCuantos do
		SET pSumaPrivilegios = pSumaPrivilegios | (SELECT Privilegio FROM pT_Menu_Privilegios WHERE Id = pIndice);
        SET pIndice = pIndice + 1;
    end while;
    
    CREATE TEMPORARY TABLE pT_Menu_Final (
							IdFormaOrdenada int NOT NULL AUTO_INCREMENT PRIMARY KEY
							, IdForma int
							, ClaveCodigo varchar(50)
							, Nombre varchar(100)
							, EsOpcionMenu tinyint(1)
							, Estatus tinyint(1)
							, IdFormaPadre int 
							, TextoLink varchar(50) 
							, Accion varchar(250) 
							, Controlador varchar(250) 
							, EsDropdown tinyint(1)
							, Privilegios bigint(20)  
							, Principal int 
							, Orden int
							, IdTipoCatalogo int 
							, Catalogo varchar(50) 
							, SubCatalogo varchar(50) 
	                    );

	CREATE TEMPORARY TABLE pT_Menu (
							IdFormaOrdenada int NOT NULL AUTO_INCREMENT PRIMARY KEY
							, IdForma int
							, ClaveCodigo varchar(50)
							, Nombre varchar(100)
							, EsOpcionMenu tinyint(1)
							, Estatus tinyint(1)
							, IdFormaPadre int 
							, TextoLink varchar(50) 
							, Accion varchar(250) 
							, Controlador varchar(250) 
							, EsDropdown tinyint(1)
							, Privilegios bigint(20)  
							, Principal int 
							, Orden int
							, IdTipoCatalogo int 
							, Catalogo varchar(50) 
							, SubCatalogo varchar(50) 
	                    );
	CREATE TEMPORARY TABLE pT_MenuTemp (
							IdFormaOrdenada int NOT NULL AUTO_INCREMENT PRIMARY KEY
							, IdForma int
							, ClaveCodigo varchar(50)
							, Nombre varchar(100)
							, EsOpcionMenu tinyint(1)
							, Estatus tinyint(1)
							, IdFormaPadre int 
							, TextoLink varchar(50) 
							, Accion varchar(250) 
							, Controlador varchar(250) 
							, EsDropdown tinyint(1)
							, Privilegios bigint(20)  
							, Principal int 
							, Orden int
							, IdTipoCatalogo int 
							, Catalogo varchar(50) 
							, SubCatalogo varchar(50) 
	                    );

	SET pIdFormaCatalogo = (
    SELECT 
		Forma.IdForma 
	from Forma 
	where Forma.ClaveCodigo = 'Catalogos'
    -- AND IdEmpresa = pIdEmpresa
    AND Estatus = 1);
    
    SET pEsOpcionMenu = (
    SELECT 
		EsOpcionMenu 
	from Forma 
	where Forma.ClaveCodigo = 'Catalogos'
    -- AND IdEmpresa = pIdEmpresa
    AND Estatus = 1);
	
	insert into pT_MenuTemp(	IdForma
							, ClaveCodigo
							, Nombre
							, EsOpcionMenu
							, Estatus
							, IdFormaPadre
							, TextoLink
							, Accion
							, Controlador
							, EsDropdown
							, Privilegios
							, Principal
							, Orden
							, IdTipoCatalogo
							, Catalogo
							, SubCatalogo) 		
		Select distinct
			Forma.IdForma
			, Forma.ClaveCodigo
			, Forma.Nombre
			, Forma.EsOpcionMenu
			, Forma.Estatus
			, IFNULL(Forma.IdFormaPadre, 0) as IdFormaPadre
			, Forma.TextoLink
			, Forma.Accion
			, Forma.Controlador
			, Forma.EsDropdown
			, pSumaPrivilegios
			, 1 as Principal
			, Forma.Orden
			, 0
			, ''
			, ''
		from Forma	
		where 
			Forma.Estatus = 1 	
            /* AND Forma.IdEmpresa = pIdEmpresa */
            AND (case 	when pEsSuperAdministrador = 1 then 1
						else case when EsSuperAdministrador = 0 then 1 else 0 end
				 end) = 1	
		order by 
			6
			, Orden;
		
		insert into pT_MenuTemp(	IdForma
							, ClaveCodigo
							, Nombre
							, EsOpcionMenu
							, Estatus
							, IdFormaPadre
							, TextoLink
							, Accion
							, Controlador
							, EsDropdown
							, Privilegios
							, Principal
							, Orden
							, IdTipoCatalogo
							, Catalogo
							, SubCatalogo)
		Select distinct
			 100000 + TipoCatalogo.IdTipoCatalogo
			, Forma.ClaveCodigo
			, Forma.Nombre
			, Forma.EsOpcionMenu
			, Forma.Estatus
			, Forma.IdForma as IdFormaPadre
			, TipoCatalogo.Nombre as TextoLink
			, CONCAT(Forma.Accion, '/', CAST(TipoCatalogo.IdTipoCatalogo as char(300))) as Accion
			, Forma.Controlador
			, 0 as EsDropdown
			, pSumaPrivilegios
			, 0 as Principal
			, Forma.Orden
			, TipoCatalogo.IdTipoCatalogo
			, TipoCatalogo.Nombre			
			,''
		from Forma		
		inner join TipoCatalogo on (TipoSubCatalogo = 0 and TipoCatalogo.Visible = 1)
		where 
			Forma.Estatus = 1 
			and Forma.ClaveCodigo = 'Catalogos'
            /* AND Forma.IdEmpresa = pIdEmpresa */
            AND (case 	when pEsSuperAdministrador = 1 then 1
						else case when forma.EsSuperAdministrador = 0 then 1 else 0 end
				 end) = 1
		union
        
		Select distinct
			 100000 + TipoCatalogo.IdTipoCatalogo
			, Forma.ClaveCodigo
			, Forma.Nombre
			, pEsOpcionMenu as EsOpcionMenu
			, Forma.Estatus
			, pIdFormaCatalogo as IdFormaPadre
			, TipoCatalogo.Nombre as TextoLink
			, CONCAT(Forma.Accion, '/', CAST(TipoCatalogo.IdTipoCatalogo as char(300)), '/' , CAST(TipoCatalogo.IdTipoCatalogo_SubCatalogo as char(300))) as Accion
			, Forma.Controlador
			, 0 as EsDropdown
			, 0 as Privilegios
			, 0 as Principal
			, Forma.Orden
			, TipoCatalogo.IdTipoCatalogo
			, TipoCatalogo.Nombre
			, TipoCatalogo.NombreSingular
		from Forma	
		inner join TipoCatalogo on (TipoSubCatalogo = 1 and TipoCatalogo.Visible = 1)
		where 
			Forma.Estatus = 1 
			and Forma.ClaveCodigo = 'SubCatalogos'
            /* AND Forma.IdEmpresa = pIdEmpresa */
			AND (case 	when pEsSuperAdministrador = 1 then 1
						else case when EsSuperAdministrador = 0 then 1 else 0 end
				 end) = 1
		order by 6,7;
		
    insert into pT_Menu(	IdForma
							, ClaveCodigo
							, Nombre
							, EsOpcionMenu
							, Estatus
							, IdFormaPadre
							, TextoLink
							, Accion
							, Controlador
							, EsDropdown
							, Privilegios
							, Principal
							, Orden
							, IdTipoCatalogo
							, Catalogo
							, SubCatalogo)
    SELECT	
		IdForma
		, ClaveCodigo
		, Nombre
		, EsOpcionMenu
		, Estatus
		, IdFormaPadre
		, TextoLink
		, Accion
		, Controlador
		, EsDropdown
		, Privilegios
		, Principal
		, Orden
		, IdTipoCatalogo
		, Catalogo
		, SubCatalogo
	FROM pT_MenuTemp;
            
	SET pCuantos = (select count(1) from pT_Menu);
	SET pIndice = 1;

	select * from pT_Menu;
	while pIndice <= pCuantos do
		SET pIdForma = (select IdForma from pT_Menu where IdFormaOrdenada = pIndice);
		SET pPrivilegio =  (select Privilegios from pT_Menu where IdFormaOrdenada = pIndice);

		if not exists (select 1 from pT_Menu_Final where IdForma = pIdForma) then
			insert into pT_Menu_Final(	IdForma
							, ClaveCodigo
							, Nombre
							, EsOpcionMenu
							, Estatus
							, IdFormaPadre
							, TextoLink
							, Accion
							, Controlador
							, EsDropdown
							, Privilegios
							, Principal
							, Orden
							, IdTipoCatalogo
							, Catalogo
							, SubCatalogo) 
			SELECT	
				IdForma
				, ClaveCodigo
				, Nombre
				, EsOpcionMenu
				, Estatus
				, IdFormaPadre
				, TextoLink
				, Accion
				, Controlador
				, EsDropdown
				, Privilegios
				, Principal
				, Orden
				, IdTipoCatalogo
				, Catalogo
				, SubCatalogo
			FROM pT_Menu
			where IdFormaOrdenada = pIndice;		
		else
			UPDATE pT_Menu_Final
			set Privilegios = Privilegios | pPrivilegio
			WHERE IdForma = pIdForma;
		end if;

		SET pIndice = pIndice + 1;
	end while;

	SELECT	
		IdFormaOrdenada
		, IdForma
		, ClaveCodigo
		, Nombre
		, EsOpcionMenu
		, Estatus
		, IdFormaPadre
		, TextoLink
		, Accion
		, Controlador
		, EsDropdown
		, CAST(Privilegios as SIGNED) as Privilegios
		, Principal
		, Orden
		, IdTipoCatalogo
		, Catalogo
		, SubCatalogo
	FROM pT_Menu_Final
	order by IdFormaOrdenada;
    
    DROP TEMPORARY TABLE pT_Menu_Privilegios;
    DROP TEMPORARY TABLE pT_Menu_Final;
    DROP TEMPORARY TABLE pT_MenuTemp;
    DROP TEMPORARY TABLE pT_Menu;
END$$

DROP PROCEDURE IF EXISTS `ObtFormasRolesPrivilegiosPorRol`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtFormasRolesPrivilegiosPorRol` (`pNombreForma` VARCHAR(50), `pIdRol` INT, `pIdEmpresa` INT)  BEGIN

	Select 
 			 Forma.IdForma
 			, Forma.ClaveCodigo
 			, Forma.Nombre
 			, Forma.EsOpcionMenu
 			, Forma.Estatus
 			, Forma.IdFormaPadre
 			, Forma.TextoLink
 			, Forma.Accion
 			, Forma.Controlador
 			, Forma.EsDropdown
 			, Forma.Descripcion
 			, CAST(SUM(FormaRol.Privilegios) as SIGNED) as Privilegios
 		from Forma			
 		left join FormaRol on (FormaRol.IdForma =  Forma.IdForma and FormaRol.IdRol = pIdRol AND FormaRol.IdEmpresa = pIdEmpresa)
 		where 
 			Forma.Estatus = 1 
 			and (	Forma.Nombre like concat('%', ifnull(pNombreForma, ''), '%') 
					OR Forma.Descripcion like concat('%', ifnull(pNombreForma, ''), '%') 
				)
			AND Forma.IdEmpresa = pIdEmpresa
            AND EsSuperAdministrador = 0
 		group by
 			Forma.IdForma
 			, Forma.ClaveCodigo
 			, Forma.Nombre
 			, Forma.EsOpcionMenu
 			, Forma.Estatus
 			, Forma.IdFormaPadre
 			, Forma.TextoLink
 			, Forma.Accion
 			, Forma.Controlador
 			, Forma.EsDropdown
 			, Forma.Descripcion
 		order by 
 			Forma.IdFormaPadre
 			, Forma.IdForma;
END$$

DROP PROCEDURE IF EXISTS `ObtFormasRolesPrivilegiosPorUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtFormasRolesPrivilegiosPorUsuario` (IN `pIdUsuario` INT, IN `pIdEmpresa` INT)  BEGIN

	DECLARE pIdFormaCatalogo int;
	DECLARE pEsOpcionMenu int;
	DECLARE pCuantos int;
	DECLARE pIndice int;
	DECLARE pIdForma int;
	DECLARE pPrivilegio int;
    
    CREATE TEMPORARY TABLE pT_Menu_Final (
							IdFormaOrdenada int NOT NULL AUTO_INCREMENT PRIMARY KEY
							, IdForma int
							, ClaveCodigo varchar(50)
							, Nombre varchar(100)
							, EsOpcionMenu tinyint(1)
							, Estatus tinyint(1)
							, IdFormaPadre int 
							, TextoLink varchar(50) 
							, Accion varchar(250) 
							, Controlador varchar(250) 
							, EsDropdown tinyint(1)
							, Privilegios bigint(20) 
							, Principal int 
							, Orden int
							, IdTipoCatalogo int 
							, Catalogo varchar(50) 
							, SubCatalogo varchar(50) 
	                    );

	CREATE TEMPORARY TABLE pT_Menu (
							IdFormaOrdenada int NOT NULL AUTO_INCREMENT PRIMARY KEY
							, IdForma int
							, ClaveCodigo varchar(50)
							, Nombre varchar(100)
							, EsOpcionMenu tinyint(1)
							, Estatus tinyint(1)
							, IdFormaPadre int 
							, TextoLink varchar(50) 
							, Accion varchar(250) 
							, Controlador varchar(250) 
							, EsDropdown tinyint(1)
							, Privilegios bigint(20)  
							, Principal int 
							, Orden int
							, IdTipoCatalogo int 
							, Catalogo varchar(50) 
							, SubCatalogo varchar(50) 
	                    );
	
	CREATE TEMPORARY TABLE pT_MenuTemp (
							IdFormaOrdenada int NOT NULL AUTO_INCREMENT PRIMARY KEY
							, IdForma int
							, ClaveCodigo varchar(50)
							, Nombre varchar(100)
							, EsOpcionMenu tinyint(1)
							, Estatus tinyint(1)
							, IdFormaPadre int 
							, TextoLink varchar(50) 
							, Accion varchar(250) 
							, Controlador varchar(250) 
							, EsDropdown tinyint(1)
							, Privilegios bigint(20)  
							, Principal int 
							, Orden int
							, IdTipoCatalogo int 
							, Catalogo varchar(50) 
							, SubCatalogo varchar(50) 
	                    );


	SET pIdFormaCatalogo = (
    SELECT 
		Forma.IdForma 
	from Forma 
	where Forma.ClaveCodigo = 'Catalogos'
    -- AND IdEmpresa = pIdEmpresa
    AND Estatus = 1);
    
    SET pEsOpcionMenu = (
    SELECT 
		EsOpcionMenu 
	from Forma 
	where Forma.ClaveCodigo = 'Catalogos'
    -- AND IdEmpresa = pIdEmpresa
    AND Estatus = 1);
	
	insert into pT_MenuTemp(	IdForma
							, ClaveCodigo
							, Nombre
							, EsOpcionMenu
							, Estatus
							, IdFormaPadre
							, TextoLink
							, Accion
							, Controlador
							, EsDropdown
							, Privilegios
							, Principal
							, Orden
							, IdTipoCatalogo
							, Catalogo
							, SubCatalogo) 		
		Select
			Forma.IdForma
			, Forma.ClaveCodigo
			, Forma.Nombre
			, Forma.EsOpcionMenu
			, Forma.Estatus
			, IFNULL(Forma.IdFormaPadre, 0) as IdFormaPadre
			, Forma.TextoLink
			, Forma.Accion
			, Forma.Controlador
			, Forma.EsDropdown
			, FormaRol.Privilegios
			, 1 as Principal
			, Forma.Orden
			, 0
			, ''
			, ''
		from Usuario
		inner join RolUsuario on (RolUsuario.IdUsuario = Usuario.IdUsuario /* AND RolUsuario.IdEmpresa = pIdEmpresa */)		
		inner join FormaRol on (FormaRol.IdRol =  RolUsuario.IdRol /* AND FormaRol.IdEmpresa = pIdEmpresa */)
		inner join Forma on (Forma.IdForma = FormaRol.IdForma /* AND Forma.IdEmpresa = pIdEmpresa */ AND Forma.Estatus = 1)		
		inner join Roles on (Roles.IdRol = FormaRol.IdRol /* AND Roles.IdEmpresa = pIdEmpresa */ AND Roles.Estatus = 1)
		where 
			Roles.Estatus = 1
			and Forma.Estatus = 1 
			and ((usuario.idusuario = pIdUsuario and Usuario.Activo = 1))	
            -- AND Usuario.IdEmpresa = pIdEmpresa
            AND EsSuperAdministrador = 0
		order by 
			6
			, Orden;
		
		insert into pT_MenuTemp(	IdForma
							, ClaveCodigo
							, Nombre
							, EsOpcionMenu
							, Estatus
							, IdFormaPadre
							, TextoLink
							, Accion
							, Controlador
							, EsDropdown
							, Privilegios
							, Principal
							, Orden
							, IdTipoCatalogo
							, Catalogo
							, SubCatalogo) 
		Select 
			 100000 + TipoCatalogo.IdTipoCatalogo
			, Forma.ClaveCodigo
			, Forma.Nombre
			, Forma.EsOpcionMenu
			, Forma.Estatus
			, Forma.IdForma as IdFormaPadre
			, TipoCatalogo.Nombre as TextoLink
			, CONCAT(Forma.Accion, '/', CAST(TipoCatalogo.IdTipoCatalogo as char(300))) as Accion
			, Forma.Controlador
			, 0 as EsDropdown
			, 0 as Privilegios
			, 0 as Principal
			, Forma.Orden
			, TipoCatalogo.IdTipoCatalogo
			, TipoCatalogo.Nombre			
			,''
		from Usuario
		inner join RolUsuario on (RolUsuario.IdUsuario = Usuario.IdUsuario /* AND RolUsuario.IdEmpresa = pIdEmpresa */)		
		inner join FormaRol on (FormaRol.IdRol =  RolUsuario.IdRol /* AND FormaRol.IdEmpresa = pIdEmpresa */)
		inner join Forma on (Forma.IdForma = FormaRol.IdForma /* AND Forma.IdEmpresa = pIdEmpresa */)		
		inner join Roles on (Roles.IdRol = FormaRol.IdRol /* AND Roles.IdEmpresa = pIdEmpresa */)
		inner join TipoCatalogo on (TipoSubCatalogo = 0 and TipoCatalogo.Visible = 1)
		where 
			Roles.Estatus = 1
			and Forma.Estatus = 1 
			and ((usuario.idusuario = pIdUsuario and Usuario.Activo = 1))
			and Forma.ClaveCodigo = 'Catalogos'
			and FormaRol.Privilegios & 1 != 0
            -- AND Usuario.IdEmpresa = pIdEmpresa            
            AND Forma.EsSuperAdministrador = 0
            
		union

		Select 
			 100000 + TipoCatalogo.IdTipoCatalogo
			, Forma.ClaveCodigo
			, Forma.Nombre
			, pEsOpcionMenu as EsOpcionMenu
			, Forma.Estatus
			, pIdFormaCatalogo as IdFormaPadre
			, TipoCatalogo.Nombre as TextoLink
			, CONCAT(Forma.Accion, '/', CAST(TipoCatalogo.IdTipoCatalogo as char(300)), '/' , CAST(TipoCatalogo.IdTipoCatalogo_SubCatalogo as char(300))) as Accion
			, Forma.Controlador
			, 0 as EsDropdown
			, 0 as Privilegios
			, 0 as Principal
			, Forma.Orden
			, TipoCatalogo.IdTipoCatalogo
			, TipoCatalogo.Nombre
			, TipoCatalogo.NombreSingular
		from Usuario
		inner join RolUsuario on (RolUsuario.IdUsuario = Usuario.IdUsuario /* AND RolUsuario.IdEmpresa = pIdEmpresa */)		
		inner join FormaRol on (FormaRol.IdRol =  RolUsuario.IdRol /* AND FormaRol.IdEmpresa = pIdEmpresa */)
		inner join Forma on (Forma.IdForma = FormaRol.IdForma /* AND Forma.IdEmpresa = pIdEmpresa */)		
		inner join Roles on (Roles.IdRol = FormaRol.IdRol /* AND Roles.IdEmpresa = pIdEmpresa */)
		inner join TipoCatalogo on (TipoSubCatalogo = 1 and TipoCatalogo.Visible = 1)
		where 
			Roles.Estatus = 1
			and Forma.Estatus = 1 
			and ((usuario.idusuario = pIdUsuario and Usuario.Activo = 1))
			and Forma.ClaveCodigo = 'SubCatalogos'
			and FormaRol.Privilegios & 1 != 0
            -- AND Usuario.IdEmpresa = pIdEmpresa           
            AND Forma.EsSuperAdministrador = 0

		order by 6,7;
	
	insert into pT_Menu(	IdForma
							, ClaveCodigo
							, Nombre
							, EsOpcionMenu
							, Estatus
							, IdFormaPadre
							, TextoLink
							, Accion
							, Controlador
							, EsDropdown
							, Privilegios
							, Principal
							, Orden
							, IdTipoCatalogo
							, Catalogo
							, SubCatalogo)
    SELECT	
		IdForma
		, ClaveCodigo
		, Nombre
		, EsOpcionMenu
		, Estatus
		, IdFormaPadre
		, TextoLink
		, Accion
		, Controlador
		, EsDropdown
		, Privilegios
		, Principal
		, Orden
		, IdTipoCatalogo
		, Catalogo
		, SubCatalogo
	FROM pT_MenuTemp;

	SET pCuantos = (select count(1) from pT_Menu);
	SET pIndice = 1;

	while pIndice <= pCuantos do
		SET pIdForma = (select IdForma from pT_Menu where IdFormaOrdenada = pIndice);
		SET pPrivilegio =  (select Privilegios from pT_Menu where IdFormaOrdenada = pIndice);

		if not exists (select 1 from pT_Menu_Final where IdForma = pIdForma) then
			insert into pT_Menu_Final(	IdForma
							, ClaveCodigo
							, Nombre
							, EsOpcionMenu
							, Estatus
							, IdFormaPadre
							, TextoLink
							, Accion
							, Controlador
							, EsDropdown
							, Privilegios
							, Principal
							, Orden
							, IdTipoCatalogo
							, Catalogo
							, SubCatalogo) 
			SELECT	
				IdForma
				, ClaveCodigo
				, Nombre
				, EsOpcionMenu
				, Estatus
				, IdFormaPadre
				, TextoLink
				, Accion
				, Controlador
				, EsDropdown
				, Privilegios
				, Principal
				, Orden
				, IdTipoCatalogo
				, Catalogo
				, SubCatalogo
			FROM pT_Menu
			where IdFormaOrdenada = pIndice;
		
		else
			UPDATE pT_Menu_Final
			set Privilegios = Privilegios | pPrivilegio
			WHERE IdForma = pIdForma;
		end if;

		SET pIndice = pIndice + 1;
	end while;

	SELECT	
		IdFormaOrdenada
		, IdForma
		, ClaveCodigo
		, Nombre
		, EsOpcionMenu
		, Estatus
		, IdFormaPadre
		, TextoLink
		, Accion
		, Controlador
		, EsDropdown
		, CAST(Privilegios as SIGNED) as Privilegios
		, Principal
		, Orden
		, IdTipoCatalogo
		, Catalogo
		, SubCatalogo
	FROM pT_Menu_Final
	order by IdFormaOrdenada;
    
    DROP TEMPORARY TABLE pT_Menu_Final;
    DROP TEMPORARY TABLE pT_MenuTemp;
    DROP TEMPORARY TABLE pT_Menu;

END$$

DROP PROCEDURE IF EXISTS `ObtIdsCatalogosDelSubCatalogo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtIdsCatalogosDelSubCatalogo` (`pIdSubCatalogo` INT, `pIdEmpresa` INT)  BEGIN    
                            
	Declare pIdTipoCatalogo int;
	Declare pIdTipoCatalogoPadre int;
	Declare pIdSubCatalogoPadre int;
	Declare pIdCatalogoPadre int;	
	Declare pPadreEsSubCatalogo bit;
    
	CREATE TEMPORARY TABLE pTabla (
								Id int NOT NULL AUTO_INCREMENT PRIMARY KEY
								, IdCatalogo int
								, IdSeleccion int
								, IdTipoCatalogo int
							);
    
    SET pPadreEsSubCatalogo = 1;	

	SET pIdSubCatalogoPadre = pIdSubCatalogo;
	
	while (pPadreEsSubCatalogo = 1) do
				
    SET pIdTipoCatalogo= (SELECT IdTipoCatalogo FROM SubCatalogo WHERE IdSubCatalogo=pIdSubCatalogoPadre AND IdEmpresa = pIdEmpresa); -- tipo de catalogo
	
	SET  pIdTipoCatalogoPadre = (SELECT IdTipoCatalogo_SubCatalogo FROM TipoCatalogo WHERE IdTipoCatalogo=pIdTipoCatalogo); -- tipo de catalogo del padre

	SET pIdSubCatalogoPadre = IFNULL((select c.IdCatalogo	from SubCatalogo c where c.IdSubCatalogo = pIdSubCatalogoPadre AND IdEmpresa = pIdEmpresa), 0); -- idsubcatalogo o catalogo del padre

	SET pIdCatalogoPadre = IFNULL((select c.IdCatalogo	from SubCatalogo c where c.IdSubCatalogo = pIdSubCatalogoPadre AND IdEmpresa = pIdEmpresa), 0); -- idsubcatalogo del padre

	SET pPadreEsSubCatalogo = (SELECT TipoSubCatalogo FROM TipoCatalogo WHERE IdTipoCatalogo=pIdTipoCatalogoPadre);


	insert pTabla(IdCatalogo, IdSeleccion, IdTipoCatalogo) values (pIdCatalogoPadre, pIdSubCatalogoPadre, pIdTipoCatalogoPadre);
			
	end  while;
	
	select *
	from pTabla;
    
	DROP TEMPORARY TABLE pTabla;
    
END$$

DROP PROCEDURE IF EXISTS `ObtInfoSubCatalogoPorIdPadre`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtInfoSubCatalogoPorIdPadre` (`pIdCatalogo` INT, `pIdTipoCatalogo` INT, `pIdEmpresa` INT)  BEGIN

	SELECT 
		cat.IdSubCatalogo as IdCatalogo
		, cat.Nombre
		, cat.EsActivo
	FROM SubCatalogo cat
	where	cat.IdCatalogo = pIdCatalogo
			and cat.IdTipoCatalogo = pIdTipoCatalogo
            and cat.IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtInfoSubCatalogoPorNombrePadre`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtInfoSubCatalogoPorNombrePadre` (`pIdCatalogo` INT, `pCatalogo` VARCHAR(100), `pIdEmpresa` INT)  BEGIN

	SELECT 
		cat.IdSubCatalogo as IdCatalogo
		, cat.Nombre
		, cat.EsActivo
	FROM SubCatalogo cat
	inner join TipoCatalogo tipo on tipo.IdTipoCatalogo = cat.IdTipoCatalogo 
	where	cat.IdCatalogo = pIdCatalogo
			and tipo.Nombre = replace(pCatalogo, '_', ' ')
            and cat.IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtJornadasTipo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtJornadasTipo` (IN `pIdEmpresa` INT(11), IN `pIdTipoCatalogo` INT(11))  BEGIN

SELECT 
		 catalogo.IdCatalogo, catalogo.Nombre
 FROM 	reclutamiento.catalogo
WHERE  			catalogo.IdEmpresa=pIdEmpresa
		AND 	catalogo.IdTipocatalogo=pIdTipoCatalogo
		AND 	catalogo.EsActivo=1;

END$$

DROP PROCEDURE IF EXISTS `ObtPaises`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtPaises` (IN `pNombre` VARCHAR(512), IN `pActivo` INT)  BEGIN
SELECT Clave_Pais
      ,Nombre
FROM pais 
WHERE Nombre like concat('%', IFNULL(pNombre, ''), '%')
AND Estatus = pActivo;
END$$

DROP PROCEDURE IF EXISTS `ObtParametros`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtParametros` (`pNombre` VARCHAR(64), `pDescripcion` VARCHAR(64), `pIdEmpresa` INT)  BEGIN

	SELECT IdParametro, Nombre, Descripcion, Valor, EsActivo, EsSensitivo, IdEmpresa 
 	FROM Parametro
 	WHERE 
		Nombre LIKE CONCAT('%', pNombre, '%')
        AND Descripcion LIKE CONCAT('%', pDescripcion, '%')
        AND IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtParametrosEmpresa`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtParametrosEmpresa` (`pNombre` VARCHAR(64), `pDescripcion` VARCHAR(64))  BEGIN

	SELECT IdParametro, Nombre, Descripcion, Valor, EsActivo, EsSensitivo
 	FROM parametroempresa
 	WHERE 
		Nombre LIKE CONCAT('%', pNombre, '%')
        AND Descripcion LIKE CONCAT('%', pDescripcion, '%');

END$$

DROP PROCEDURE IF EXISTS `ObtPermisosForma`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtPermisosForma` (`pIdForma` INT, `pIdEmpresa` INT)  BEGIN

	SELECT 
 		FormaPermiso.IdForma
        , FormaPermiso.IdPermiso
        , FormaPermiso.IdEmpresa
        , Permiso.Permiso
        , FormaPermiso.NombrePermiso
        , CASE WHEN IFNULL(FormaPermiso.NombrePermiso, '') != '' then FormaPermiso.NombrePermiso
				ELSE Permiso.Permiso 
		  END as Nombre
 		, Permiso.Privilegio
 	FROM FormaPermiso
 	INNER JOIN Permiso on Permiso.IdPermiso = FormaPermiso.IdPermiso AND Permiso.IdEmpresa = pIdEmpresa
 	where Permiso.Estatus = 1
 			and FormaPermiso.IdForma = pIdForma
            AND FormaPermiso.IdEmpresa = pIdEmpresa;
            
END$$

DROP PROCEDURE IF EXISTS `ObtProspectoId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectoId` (IN `pIdProspecto` INT)  BEGIN	
	SELECT
	   p.IdProspecto as IdProspecto,
	   p.Nombre as Nombre,
	   p.Apellidos as Apellidos,
           p.FechaNacimiento as FechaNacimiento,
	   p.RFC as RFC,
	   p.Email as Email,
           p.TelefonoMovil as TelefonoMovil,
	   p.TelefonoOtro as TelefonoOtro,
	   p.Direccion as Direccion,
	   p.Salario as Salario,
	   p.IdSexo as IdSexo, 
       cSexo.Nombre as NombreSexo,
	   p.IdCiudad as IdCiudad,
	   p.IdEstadoCivil as IdEstadoCivil,
       cEC.Nombre as NombreEstadoCivil,
	   p.IdEscolaridad as IdEscolaridad,   
       cEsco.Nombre as NombreEscolaridad,
	   p.Estatus as Estatus
	FROM prospecto p left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
    	  left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
          left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo
	where 
		p.IdProspecto = pIdProspecto;

END$$

DROP PROCEDURE IF EXISTS `ObtProspectos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectos` (IN `pNombre` VARCHAR(100), IN `pActivo` INT, IN `pIdEmpresa` INT)  BEGIN
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
	   p.IdProspecto as IdProspecto,
	   p.Nombre as Nombre,
	   p.Apellidos as Apellidos,
           p.FechaNacimiento as FechaNacimiento,
	   p.RFC as RFC,
	   p.Email as Email,
           p.TelefonoMovil as TelefonoMovil,
	   p.TelefonoOtro as TelefonoOtro,
	   p.Direccion as Direccion,
	   p.Salario as Salario,
	   p.IdSexo as IdSexo, 
       cSexo.Nombre as NombreSexo,
	   p.IdCiudad as IdCiudad,
	   p.IdEstadoCivil as IdEstadoCivil,
       cEC.Nombre as NombreEstadoCivil,
	   p.IdEscolaridad as IdEscolaridad,   
       cEsco.Nombre as NombreEscolaridad,
	   p.Estatus as Estatus
	FROM prospecto p left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
    	  left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
          left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo
	where (p.Nombre like concat('%', IFNULL(pNombre, ''), '%')
		OR p.Apellidos like concat('%', IFNULL(pNombre, ''), '%')	)
		AND p.Estatus between pDesde and pHasta
		AND p.IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtReferenciaLaboralIdProspecto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtReferenciaLaboralIdProspecto` (IN `pIdProspecto` INT, IN `pEstatus` TINYINT(1), IN `pIdEmpresa` INT)  BEGIN
SELECT 
	IdReferencia,
	IdProspecto,
	Empresa,
	Domicilio,
       	Contacto,
	Contacto_Email,
	Contacto_Telefono,
	MotivoSeparacion,
	Puesto,
	TiempoLaborado,
	Comentario
FROM 
	referencialaboral
WHERE
	IdProspecto = pIdProspecto
	AND IdEmpresa = pIdEmpresa
	AND Estatus = pEstatus;
        
END$$

DROP PROCEDURE IF EXISTS `ObtRoles`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtRoles` (`pNombreRol` VARCHAR(50), `pIdEmpresa` INT)  BEGIN
	DECLARE pBool tinyint(1);

 	SELECT IdRol
 		,NombreRol
 		,Estatus
        ,IdEmpresa
 	FROM Roles
 	where NombreRol like concat('%', ifnull(pNombreRol, ''), '%')
    AND IdEmpresa = pIdEmpresa;


END$$

DROP PROCEDURE IF EXISTS `ObtRolUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtRolUsuario` (`pidUsuario` INT, `pIdEmpresa` INT)  BEGIN

 	SELECT 
 		R.IdRol
 		, R.NombreRol
 		, CASE when ru.IdRolUsuario is null then 0 else 1 end as Seleccionado
        , R.IdEmpresa
 	FROM Roles R
 	left join RolUsuario RU on ru.IdRol = r.IdRol and ru.IdUsuario = pidUsuario and ru.IdEmpresa = pIdEmpresa
 	WHERE r.Estatus = 1
    AND R.IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtSubCatalogoPorIdCatalogo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtSubCatalogoPorIdCatalogo` (`pIdCatalogo` INT, `pIdEmpresa` INT)  BEGIN
	
    SELECT SubCatalogo.IdSubCatalogo
		  ,SubCatalogo.Nombre
		  ,SubCatalogo.EsActivo
	 FROM SubCatalogo
	 WHERE SubCatalogo.IdCatalogo = pIdCatalogo
		AND SubCatalogo.IdEmpresa = pIdEmpresa;
    
END$$

DROP PROCEDURE IF EXISTS `ObtSubCatalogos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtSubCatalogos` (`pidTipoCatalogo` INT, `pNombreCatalogo` VARCHAR(64), `pEsActivo` INT, `pIdEmpresa` INT)  BEGIN
	
    Declare pDesde tinyint;
	Declare pHasta tinyint;	
        
	if(pEsActivo = -1) then
		SET pDesde = 0;
		SET pHasta = 1;
	else
		SET pDesde = pEsActivo;
		SET pHasta = pEsActivo;
	end if;
	

    -- Insert statements for procedure here
	SELECT SubCatalogo.IdSubCatalogo
		,SubCatalogo.IdCatalogo
		,SubCatalogo.IdTipoCatalogo
		,SubCatalogo.Nombre
		,SubCatalogo.Descripcion
		,SubCatalogo.EsActivo
		,SubCatalogo.Clave
		,IFNULL(Catalogo.Nombre, SubCatalogoPadre.Nombre) as Catalogo
	FROM TipoCatalogo 
	INNER JOIN SubCatalogo on SubCatalogo.IdTipoCatalogo = TipoCatalogo.IdTipoCatalogo
	INNER JOIN TipoCatalogo TipoCatalogoPadre on TipoCatalogoPadre.IdTipoCatalogo = TipoCatalogo.IdTipoCatalogo_SubCatalogo
	LEFT join Catalogo on Catalogo.IdCatalogo = SubCatalogo.IdCatalogo and TipoCatalogoPadre.TipoSubCatalogo = 0
	LEFT join SubCatalogo SubCatalogoPadre on SubCatalogoPadre.IdSubCatalogo = SubCatalogo.IdCatalogo and TipoCatalogoPadre.TipoSubCatalogo != 0
	WHERE	TipoCatalogo.IdTipoCatalogo = pidTipoCatalogo 
			AND SubCatalogo.Nombre like concat('%', ifnull(pNombreCatalogo,''), '%') 
			AND SubCatalogo.EsActivo between pDesde and pHasta
            AND SubCatalogo.IdEmpresa = pIdEmpresa;
    
END$$

DROP PROCEDURE IF EXISTS `ObtUsuarioPorId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuarioPorId` (`pIdUsuario` INT(11), `pIdEmpresa` INT)  BEGIN

 	SELECT 
 		 usu.IdUsuario
 		,usu.Login
 		,usu.Activo
 		,usu.CodigoRecuperaContrasenia
 		,usu.UsuarioId
 		,usu.NombreCompleto as Nombre 
 		,usu.CorreoElectronico as CorreoElectronico	
        ,usu.IdEmpresa
	FROM Usuario usu
 		WHERE	usu.idUsuario = pIdUsuario
        AND IdEmpresa = pIdEmpresa;		

END$$

DROP PROCEDURE IF EXISTS `ObtUsuarios`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuarios` (`pNombreCompleto` VARCHAR(250), `pActivo` TINYINT, `pIdEmpresa` INT)  BEGIN

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
	   u.IdUsuario
      ,u.Login
      ,u.NombreCompleto
	  ,u.CorreoElectronico
      ,u.Contrasenia
	  ,u.Activo
	  ,u.Comentarios
      ,u.IdEmpresa
	  ,u.Domicilio
	  ,u.Telefono
	  ,u.Referencia
	  ,u.ReferenciaTelefono
	  ,u.FechaNacimiento
	FROM Usuario u
	where NombreCompleto like concat('%', IFNULL(pNombreCompleto, ''), '%')
			and u.Activo between pDesde and pHasta
			AND IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtUsuariosAnalistas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuariosAnalistas` (`pNombreCompleto` VARCHAR(250), `pIdEmpresa` INT)  BEGIN
	
    DECLARE pIdRol int(11);
    SET pIdRol = (SELECT IdRol FROM Roles where NombreRol = (	SELECT  valor 
																from parametro 
                                                                WHERE 
																	Nombre = 'Rol Analista'
															)
				 );
	SELECT 
	   CAST(u.IdUsuario as char(200)) as id
      ,  CAST(u.NombreCompleto as char(200)) as text
	FROM Usuario u
    INNER JOIN RolUsuario RU on Ru.IdUsuario = U.IdUsuario and RU.IdEmpresa = u.IdEmpresa
	where u.NombreCompleto like concat('%', IFNULL(pNombreCompleto, ''), '%')
			AND u.IdEmpresa = pIdEmpresa
            AND RU.IdRol = pIdRol;

END$$

DROP PROCEDURE IF EXISTS `ObtUsuarioValidacionCorreo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuarioValidacionCorreo` (`pIdUsuario` INT, `pCorreoElectronico` VARCHAR(50), `pIdEmpresa` INT)  BEGIN

 	SELECT
 	   (	CASE WHEN EXISTS (	select 1 
								from Usuario 
                                where 
									CorreoElectronico 	= pCorreoElectronico 
                                    and IdUsuario 		!= pIdUsuario 
                                    and Activo = 1                                    
									AND IdEmpresa = pIdEmpresa) then 0
 				 ELSE 1
 			END
 	   );

END$$

DROP PROCEDURE IF EXISTS `ObtUsuarioValidacionLogin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuarioValidacionLogin` (`pIdUsuario` INT, `pLogin` VARCHAR(50), `pIdEmpresa` INT)  BEGIN

 	SELECT
 	   (	CASE WHEN EXISTS (select 1 from Usuario where Login = pLogin and IdUsuario != pIdUsuario AND IdEmpresa = pIdEmpresa) then 0
 				 ELSE 1
 			END
 	   );

END$$

DROP PROCEDURE IF EXISTS `ObtUsuarioValidar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuarioValidar` (IN `pIdEmpresa` INT(11), IN `pLogin` VARCHAR(50), IN `pContrasenia` VARCHAR(100))  BEGIN
    DECLARE pCeroEntero INT(11);
    DECLARE pTrue tinyint(1);    
    DECLARE pFalse tinyint(1);
    
    SET pCeroEntero = 0;
    SET pTrue = 1;
    SET pFalse = 0;

	if exists ( select 1 
	            from empresa 
                    where 
			IdEmpresa = pIdEmpresa 
                        and Administrador = pLogin
                        and Contrasenia    = pContrasenia) then		
		select
			pCeroEntero as IdUsuario,
            IdEmpresa,
            Administrador as Login,
            Administrador as NombreCompleto,
            concat(Administrador, dominio) as CorreoElectronico,
            pTrue as Activo,
            pFalse as EsSuperAdministrador,
            pTrue as EsAdministrador
		from empresa 
        where 
	    IdEmpresa = pIdEmpresa 
            and Administrador = pLogin
            and Contrasenia    = pContrasenia;
	ELSE
		SELECT 
 		  usu.IdUsuario
          ,usu.IdEmpresa
 		  , usu.Login
 		  , usu.Activo
 		  , usu.CodigoRecuperaContrasenia
 		  , usu.UsuarioId
 		  , usu.NombreCompleto
 		  , usu.CorreoElectronico
          , pFalse as EsSuperAdministrador
          , pFalse as EsAdministrador
 		FROM Usuario usu
 		WHERE	usu.IdEmpresa 	= pIdEmpresa
				AND usu.Login	= pLogin
 				AND Contrasenia = pContrasenia
 				AND Activo		= 1;
	END IF;
END$$

DROP PROCEDURE IF EXISTS `ObtVacanteCaracteristica`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtVacanteCaracteristica` (IN `pActivo` TINYINT)  BEGIN
	SELECT 
			vacantecaracteristica.IdVacanteCaracteristica,
			vacantecaracteristica.IdVacante ,
			vacantecaracteristica.IdCaracteristicaParticular,
			vacantecaracteristica.Valor,
			vacantecaracteristica.Comentario,
			vacantecaracteristica.Activo
	FROM 
		reclutamiento.vacantecaracteristica 
	WHERE 
		vacantecaracteristica.Activo=pActivo;

END$$

DROP PROCEDURE IF EXISTS `ObtVacantes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtVacantes` (IN `pIdEmpresa` INT, IN `pEstatus` TINYINT, IN `pTitulo` VARCHAR(100), IN `pIdTipoContrato` TINYINT, IN `pIdTipoJornada` TINYINT)  BEGIN
	IF pTitulo is not null and  pEstatus >= 0 and pIdTipoContrato > 0 and pIdTipoJornada > 0  THEN 
			  SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
				AND vacante.Estatus=pEstatus
				AND 	vacante.Titulo LIKE CONCAT('%', pTitulo, '%')
				AND vacante.IdTipoContrato= pIdTipoContrato
				AND vacante.IdTipoJornada=pIdTipoJornada;

ELSEIF pTitulo is not null AND pEstatus < 0 and pIdTipoContrato < 0 and pIdTipoJornada < 0   THEN 

	SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Titulo LIKE CONCAT('%', pTitulo, '%');		


ELSEIF pTitulo is not null AND pEstatus < 0 and pIdTipoContrato < 0 and pIdTipoJornada > 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Titulo LIKE CONCAT('%', pTitulo, '%')
			AND 	vacante.IdTipoJornada = pIdTipoJornada;


 ELSEIF  pTitulo is not null  AND pEstatus < 0 and pIdTipoContrato > 0 and pIdTipoJornada > 0  THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Titulo=pTitulo
			AND  	vacante.IdTipoContrato=pIdTipoContrato
			AND 	vacante.IdTipoJornada = pIdTipoJornada;



 ELSEIF  pTitulo is not null AND pEstatus >= 0 and pIdTipoContrato < 0 and pIdTipoJornada < 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Titulo LIKE CONCAT('%', pTitulo, '%')
			AND		vacante.Estatus=pEstatus;							

ELSEIF  pTitulo is not null AND pEstatus >= 0 and pIdTipoContrato < 0 and pIdTipoJornada > 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Titulo LIKE CONCAT('%', pTitulo, '%')
			AND		vacante.Estatus=pEstatus
			AND  	vacante.IdTipoJornada=pIdTipoJornada;

						
ELSEIF  pTitulo is not null AND pEstatus >= 0 and pIdTipoContrato > 0 and pIdTipoJornada < 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Titulo=pTitulo
			AND 	vacante.Titulo LIKE CONCAT('%', pTitulo, '%')
			AND  	vacante.IdTipoContrato=pIdTipoContrato;

ELSEIF  pTitulo is null AND  pEstatus < 0 and pIdTipoContrato < 0 and pIdTipoJornada > 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND  	vacante.IdTipoJornada=pIdTipoJornada;
								
				
ELSEIF  pTitulo is null AND  pEstatus < 0 and pIdTipoContrato > 0 and pIdTipoJornada > 0 THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND		vacante.IdTipoContrato=pIdTipoContrato
			AND  	vacante.IdTipoJornada=pIdTipoJornada; 



ELSEIF  pTitulo is null AND  pEstatus >= 0 and pIdTipoContrato > 0 and pIdTipoJornada > 0  THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Estatus=pEstatus
			AND		vacante.IdTipoContrato=pIdTipoContrato
			AND  	vacante.IdTipoJornada=pIdTipoJornada; 

	
ELSEIF  pTitulo is null AND  pEstatus >= 0 and pIdTipoContrato < 0 and pIdTipoJornada < 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE
					vacante.IdEmpresa = pIdEmpresa
			AND 	vacante.Estatus=pEstatuS;


ELSEIF pTitulo is null AND  pEstatus < 0 and pIdTipoContrato > 0 and pIdTipoJornada < 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa
			AND		vacante.IdTipoContrato=pIdTipoContrato;
			

ELSEIF 	pTitulo is null AND  pEstatus < 0 and pIdTipoContrato < 0 and pIdTipoJornada < 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa;

ELSEIF 	pIdEmpresa > 0   THEN 
			SELECT 
					vacante.IdVacante,
					vacante.Titulo,
					vacante.Descripcion,
					vacante.FechaContratacion,
					vacante.NumeroVacantes,
					vacante.Salario,
					vacante.IdTipoContrato,
					vacante.IdTipoJornada, 
					vacante.idCiudad,
					vacante.Estatus,
					vacante.IdEmpresa,
					vacante.Fase,
					vacante.FechaEntrega
			FROM 
					reclutamiento.vacante
			WHERE 
					vacante.IdEmpresa = pIdEmpresa;
	END IF;
			
END$$

DROP PROCEDURE IF EXISTS `ReemplazarMVC`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReemplazarMVC` ()  BEGIN

	SELECT
		IdRemplazarMVC 
		, RealMVC
		, Reemplazar
    from reemplazarmvc;
    
END$$

DROP PROCEDURE IF EXISTS `ReiniciarAutoIncrementable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReiniciarAutoIncrementable` ()  BEGIN	
        
    DELETE FROM pagocomprobado WHERE IdPagoComprobado != 0;
	ALTER TABLE pagocomprobado AUTO_INCREMENT = 0;
    
    DELETE FROM seguimientodeudor WHERE IdSeguimientoDeudor != 0;
	ALTER TABLE seguimientodeudor AUTO_INCREMENT = 0;
    
    DELETE FROM datoscontactodeudor WHERE IdDatosContactoDeudor != 0;
	ALTER TABLE datoscontactodeudor AUTO_INCREMENT = 0;
    
    DELETE FROM agendarllamadadeudor WHERE IdAgendarLlamadaDeudor != 0;
	ALTER TABLE agendarllamadadeudor AUTO_INCREMENT = 0;
    
	DELETE FROM acuerdopago WHERE IdAcuerdoPago != 0;
	ALTER TABLE acuerdopago AUTO_INCREMENT = 0;
    
    DELETE FROM rolusuario WHERE IdRolUsuario != 0;
    ALTER TABLE rolusuario AUTO_INCREMENT = 0;
    
    DELETE FROM deudordetalleerror WHERE IdDeudorDetalleError != 0;
    ALTER TABLE deudordetalleerror AUTO_INCREMENT = 0;
    
    DELETE FROM deudor WHERE iddeudor != 0;
    ALTER TABLE deudor AUTO_INCREMENT = 0;
        
    DELETE FROM usuario WHERE idusuario != 0;
    ALTER TABLE usuario AUTO_INCREMENT = 0;
    
    DELETE FROM subcatalogo WHERE IdSubCatalogo != 0;
	ALTER TABLE subcatalogo AUTO_INCREMENT = 0;
    
	DELETE FROM catalogo WHERE IdCatalogo != 0;
	ALTER TABLE catalogo AUTO_INCREMENT = 0;
    
    DELETE FROM mapeocolumnasegmento WHERE idmapeocolumnasegmento != 0;
    ALTER TABLE mapeocolumnasegmento AUTO_INCREMENT = 0;
    
    DELETE FROM columnasegmento WHERE idcolumnasegmento != 0;
    ALTER TABLE columnasegmento AUTO_INCREMENT = 0;
    
    DELETE FROM segmento WHERE idsegmento != 0;
    ALTER TABLE segmento AUTO_INCREMENT = 0;
    
    DELETE FROM cartera WHERE idcartera != 0;
    ALTER TABLE cartera AUTO_INCREMENT = 0;
    
    DELETE FROM cliente WHERE idcliente != 0;
    ALTER TABLE cliente AUTO_INCREMENT = 0;
END$$

DROP PROCEDURE IF EXISTS `TruTablesCP`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `TruTablesCP` (IN `pPais` VARCHAR(10))  BEGIN

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacora`
--

DROP TABLE IF EXISTS `bitacora`;
CREATE TABLE IF NOT EXISTS `bitacora` (
  `IdBitacora` int(11) NOT NULL AUTO_INCREMENT,
  `IdProspecto` int(11) NOT NULL COMMENT 'Id del prospecto',
  `Comentario` varchar(250) NOT NULL COMMENT 'Cmentarios',
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IdBitacora`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `caracteristicaparticular`
--

DROP TABLE IF EXISTS `caracteristicaparticular`;
CREATE TABLE IF NOT EXISTS `caracteristicaparticular` (
  `IdCaracteristicaParticular` int(11) NOT NULL AUTO_INCREMENT,
  `Clave` varchar(10) DEFAULT NULL,
  `Nombre` varchar(100) DEFAULT NULL,
  `IdTipoCampo` int(11) DEFAULT NULL,
  `IdUsuarioCreacion` int(11) DEFAULT NULL,
  `IdUsuarioUltimoModifico` int(11) DEFAULT NULL,
  `FechaModificacion` timestamp NULL DEFAULT NULL,
  `Estatus` tinyint(4) DEFAULT NULL,
  `IdEmpresa` int(11) DEFAULT NULL,
  PRIMARY KEY (`IdCaracteristicaParticular`),
  UNIQUE KEY `IdCaracteristicaParticular_UNIQUE` (`IdCaracteristicaParticular`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='CaracteristicaParticular';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `catalogo`
--

DROP TABLE IF EXISTS `catalogo`;
CREATE TABLE IF NOT EXISTS `catalogo` (
  `IdCatalogo` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(64) NOT NULL,
  `Descripcion` varchar(256) DEFAULT NULL,
  `IdTipoCatalogo` smallint(6) NOT NULL,
  `EsActivo` tinyint(1) DEFAULT '1',
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Clave` varchar(12) NOT NULL,
  `IdEmpresa` int(11) NOT NULL,
  PRIMARY KEY (`IdCatalogo`),
  KEY `_dta_index_Catalogo_7_2098106515__K1_2` (`IdCatalogo`,`Nombre`),
  KEY `_dta_index_Catalogo_7_2098106515__K1_15` (`IdCatalogo`,`Clave`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `catalogo`
--

INSERT INTO `catalogo` (`IdCatalogo`, `Nombre`, `Descripcion`, `IdTipoCatalogo`, `EsActivo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Clave`, `IdEmpresa`) VALUES
(4, 'Hombre', 'Hombre', 2, 1, 4, '2018-02-26 20:08:49', 4, '2018-02-26 20:08:49', 'H', 1),
(5, 'Mujer', 'Mujer', 2, 1, 4, '2018-02-26 20:09:08', 4, '2018-02-26 20:09:08', 'M', 1),
(6, 'Soltero', 'Soltero', 1, 1, 4, '2018-02-26 20:09:39', 4, '2018-02-26 20:09:39', 'SOL', 1),
(7, 'Viudo', 'Viudo', 1, 1, 4, '2018-02-26 20:10:00', 4, '2018-02-26 20:10:00', 'VIU', 1),
(8, 'Casado', 'Casado', 1, 1, 4, '2018-02-26 20:10:16', 4, '2018-02-26 20:10:16', 'CAS', 1),
(9, 'INE/IFE', 'Identificacioon Nacional de Elector', 4, 1, 4, '2018-02-26 20:31:01', 4, '2018-02-26 20:31:01', 'INE', 1),
(10, 'Acta Nacimiento', 'Acta de Nacimiento', 4, 1, 4, '2018-02-26 20:31:33', 4, '2018-02-26 20:31:33', 'ACT-NAC', 1),
(11, 'Preescolar', 'Preescolar', 3, 1, 4, '2018-02-26 20:32:10', 4, '2018-02-26 20:32:10', 'Preescolar', 1),
(12, 'Primaria', 'Primaria', 3, 1, 4, '2018-02-26 20:32:26', 4, '2018-02-26 20:32:26', 'Primaria', 1),
(13, 'Secundaria', 'Secundaria', 3, 1, 4, '2018-02-26 20:32:49', 4, '2018-02-26 20:32:49', 'Secundaria', 1),
(14, 'Preparatoria', 'Preparatoria', 3, 1, 4, '2018-02-26 20:33:05', 4, '2018-02-26 20:33:05', 'Preparatoria', 1),
(15, 'Licenciatura', 'Licenciatura', 3, 1, 4, '2018-02-26 20:33:22', 4, '2018-02-26 20:33:22', 'Licenciatura', 1),
(16, 'Maestria', 'Maestria', 3, 1, 4, '2018-02-26 20:33:39', 4, '2018-02-26 20:33:39', 'Maestria', 1),
(17, 'Doctorado', 'Doctorado', 3, 1, 4, '2018-02-26 20:33:55', 4, '2018-02-26 20:33:55', 'Doctorado', 1),
(18, 'Post-Grado', 'Post-Grado', 3, 1, 4, '2018-02-26 20:34:12', 4, '2018-02-26 20:34:12', 'PostGrado', 1),
(19, 'Otro', 'Otro', 2, 1, 4, '2018-02-28 21:05:10', 4, '2018-02-28 21:05:23', 'O', 1),
(20, 'ererer', 'erere', 2, 0, 4, '2018-02-28 21:29:34', 11, '2018-03-10 20:37:58', 'erererer', 1),
(22, 'Pasaporte', 'Pasaporte', 4, 1, 11, '2018-03-07 17:32:42', 11, '2018-03-07 17:32:42', 'PAS', 1),
(23, 'Cartilla Militar', 'Cartilla Militar del Servicio Nacional de Defensa', 4, 1, 11, '2018-03-07 17:33:13', 11, '2018-03-07 17:33:13', 'CMI', 1),
(24, 'Honorarios', 'Contrato por honorarios', 5, 1, 1, '2018-03-09 22:47:39', 1, '2018-03-09 22:47:39', 'Contrato', 1),
(25, 'Nómina', 'Contrato por nomina', 5, 1, 1, '2018-03-09 22:47:39', 1, '2018-03-09 22:47:39', 'Contrato', 1),
(26, 'Asimilado al Salario', 'Contrato Asimilado al Salario', 5, 1, 1, '2018-03-09 22:47:39', 1, '2018-03-09 22:47:39', 'Contrato', 1),
(27, 'Mensual', 'Jornada Mensual', 6, 1, 1, '2018-03-09 22:47:40', 1, '2018-03-09 22:47:40', 'Jornada', 1),
(28, 'Semanal', 'Jornada Semanal', 6, 1, 1, '2018-03-09 22:47:40', 1, '2018-03-09 22:47:40', 'Jornada', 1),
(29, 'Quincenal', 'Jornada Quincenal', 6, 1, 1, '2018-03-09 22:47:40', 1, '2018-03-09 22:47:40', 'Jornada', 1),
(30, 'En proceso', 'Fase de vacante en proceso', 7, 1, 1, '2018-03-09 22:47:40', 0, '2018-03-13 17:59:18', 'Fase', 1),
(31, 'Ocupada', 'Fase de vacante ocupada', 7, 1, 1, '2018-03-09 22:47:40', 1, '2018-03-09 22:47:40', 'Fase', 1),
(32, 'Abierta', 'Fase de vacante abierta', 7, 1, 1, '2018-03-09 22:47:40', 1, '2018-03-09 22:47:40', 'Fase', 1),
(33, 'Indefinido', 'Contrato Indefinido', 5, 1, 1, '2018-03-09 22:48:26', 0, '2018-03-13 17:55:41', 'Contrato', 1),
(34, 'Temporal', 'Contrato Temporal', 5, 1, 1, '2018-03-09 22:48:26', 0, '2018-03-13 17:56:53', 'Contrato', 1),
(35, 'Eventual', 'Contrato Eventual', 5, 1, 1, '2018-03-09 22:48:26', 0, '2018-03-13 17:58:28', 'Contrato', 1),
(36, 'Catorcenal', 'Jornada Catorcenal', 6, 1, 1, '2018-03-09 22:48:26', 0, '2018-03-13 17:52:41', 'Jornada', 1),
(37, 'Por Horas', 'Jornada por Horas', 6, 1, 1, '2018-03-09 22:48:26', 0, '2018-03-13 17:53:01', 'Jornada', 1),
(38, 'Honorarios', 'Jornada por Honorarios', 6, 1, 1, '2018-03-09 22:48:26', 0, '2018-03-13 17:53:52', 'Jornada', 1),
(39, 'Cancelada', 'Fase de vacante cancelada', 7, 1, 1, '2018-03-09 22:48:26', 0, '2018-03-13 17:59:36', 'Fase', 1),
(40, 'Pospuesta', 'Fase de vacante pospuesta', 7, 1, 1, '2018-03-09 22:48:26', 0, '2018-03-13 18:00:00', 'Fase', 1),
(41, 'Finalizada', 'Fase de vacante finalizada', 7, 1, 1, '2018-03-09 22:48:26', 0, '2018-03-13 18:00:22', 'Fase', 1),
(44, 'Soltero', NULL, 1, 1, 0, '2018-03-11 19:10:44', 0, '2018-03-11 19:10:44', 'S', 3),
(45, 'Casado', NULL, 1, 1, 0, '2018-03-11 19:10:56', 0, '2018-03-11 19:10:56', 'C', 3),
(46, 'Primaria', NULL, 3, 1, 0, '2018-03-11 19:11:18', 0, '2018-03-11 19:11:18', 'PRI', 3),
(47, 'Secundaria', NULL, 3, 1, 0, '2018-03-11 19:11:29', 0, '2018-03-11 19:11:29', 'SEC', 3),
(48, 'Identificacion INE', 'Identificacion INE', 4, 1, 0, '2018-03-11 19:12:23', 0, '2018-03-11 19:12:23', 'INE', 3),
(49, 'Masculino', 'Masculino/Hombre', 2, 1, 0, '2018-03-11 19:16:15', 0, '2018-03-11 19:16:15', 'M', 3),
(50, 'Femenino', 'Femenino/Mujer', 2, 1, 0, '2018-03-11 19:16:30', 0, '2018-03-11 19:16:30', 'F', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ciudad`
--

DROP TABLE IF EXISTS `ciudad`;
CREATE TABLE IF NOT EXISTS `ciudad` (
  `Clave_Ciudad` varchar(10) NOT NULL,
  `Nombre` varchar(512) NOT NULL,
  `Clave_Estado` varchar(10) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Clave_Ciudad`,`Clave_Estado`),
  KEY `R_24` (`Clave_Estado`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `ciudad`
--

INSERT INTO `ciudad` (`Clave_Ciudad`, `Nombre`, `Clave_Estado`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Estatus`) VALUES
('033', 'Moyahua de Estrada', '32', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('023', 'Juchipila', '32', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('001', 'Apozol', '32', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('002', 'Apulco', '32', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('034', 'Nochistlán de Mejía', '32', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('028', 'Mezquital del Oro', '32', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('011', 'Trinidad García de la Cadena', '32', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('047', 'Teúl de González Ortega', '32', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('058', 'Santa María de la Paz', '32', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('004', 'Benito Juárez', '32', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('030', 'Momax', '32', 0, '2018-03-13 17:55:20', 0, '2018-03-13 17:55:20', 1),
('003', 'Atolinga', '32', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('045', 'Tepechitlán', '32', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('048', 'Tlaltenango de Sánchez Román', '32', 0, '2018-03-13 17:55:20', 0, '2018-03-13 17:55:20', 1),
('018', 'Huanusco', '32', 0, '2018-03-13 17:55:20', 0, '2018-03-13 17:55:20', 1),
('044', 'Tabasco', '32', 0, '2018-03-13 17:55:20', 0, '2018-03-13 17:55:20', 1),
('031', 'Monte Escobedo', '32', 0, '2018-03-13 17:55:20', 0, '2018-03-13 17:55:20', 1),
('019', 'Jalpa', '32', 0, '2018-03-13 17:55:20', 0, '2018-03-13 17:55:20', 1),
('015', 'El Plateado de Joaquín Amaro', '32', 0, '2018-03-13 17:55:20', 0, '2018-03-13 17:55:20', 1),
('046', 'Tepetongo', '32', 0, '2018-03-13 17:55:20', 0, '2018-03-13 17:55:20', 1),
('055', 'Villanueva', '32', 0, '2018-03-13 17:55:20', 0, '2018-03-13 17:55:20', 1),
('043', 'Susticacán', '32', 0, '2018-03-13 17:55:20', 0, '2018-03-13 17:55:20', 1),
('020', 'Jerez', '32', 0, '2018-03-13 17:55:20', 0, '2018-03-13 17:55:20', 1),
('021', 'Jiménez del Teul', '32', 0, '2018-03-13 17:55:20', 0, '2018-03-13 17:55:20', 1),
('009', 'Chalchihuites', '32', 0, '2018-03-13 17:55:20', 0, '2018-03-13 17:55:20', 1),
('049', 'Valparaíso', '32', 0, '2018-03-13 17:55:19', 0, '2018-03-13 17:55:19', 1),
('040', 'Sain Alto', '32', 0, '2018-03-13 17:55:19', 0, '2018-03-13 17:55:19', 1),
('042', 'Sombrerete', '32', 0, '2018-03-13 17:55:19', 0, '2018-03-13 17:55:19', 1),
('010', 'Fresnillo', '32', 0, '2018-03-13 17:55:19', 0, '2018-03-13 17:55:19', 1),
('035', 'Noria de Ángeles', '32', 0, '2018-03-13 17:55:19', 0, '2018-03-13 17:55:19', 1),
('052', 'Villa García', '32', 0, '2018-03-13 17:55:19', 0, '2018-03-13 17:55:19', 1),
('038', 'Pinos', '32', 0, '2018-03-13 17:55:19', 0, '2018-03-13 17:55:19', 1),
('054', 'Villa Hidalgo', '32', 0, '2018-03-13 17:55:19', 0, '2018-03-13 17:55:19', 1),
('053', 'Villa González Ortega', '32', 0, '2018-03-13 17:55:19', 0, '2018-03-13 17:55:19', 1),
('024', 'Loreto', '32', 0, '2018-03-13 17:55:19', 0, '2018-03-13 17:55:19', 1),
('025', 'Luis Moya', '32', 0, '2018-03-13 17:55:19', 0, '2018-03-13 17:55:19', 1),
('016', 'General Pánfilo Natera', '32', 0, '2018-03-13 17:55:19', 0, '2018-03-13 17:55:19', 1),
('036', 'Ojocaliente', '32', 0, '2018-03-13 17:55:18', 0, '2018-03-13 17:55:18', 1),
('008', 'Cuauhtémoc', '32', 0, '2018-03-13 17:55:18', 0, '2018-03-13 17:55:18', 1),
('012', 'Genaro Codina', '32', 0, '2018-03-13 17:55:18', 0, '2018-03-13 17:55:18', 1),
('057', 'Trancoso', '32', 0, '2018-03-13 17:55:18', 0, '2018-03-13 17:55:18', 1),
('017', 'Guadalupe', '32', 0, '2018-03-13 17:55:18', 0, '2018-03-13 17:55:18', 1),
('013', 'General Enrique Estrada', '32', 0, '2018-03-13 17:55:18', 0, '2018-03-13 17:55:18', 1),
('037', 'Pánuco', '32', 0, '2018-03-13 17:55:18', 0, '2018-03-13 17:55:18', 1),
('005', 'Calera', '32', 0, '2018-03-13 17:55:18', 0, '2018-03-13 17:55:18', 1),
('014', 'General Francisco R. Murguía', '32', 0, '2018-03-13 17:55:18', 0, '2018-03-13 17:55:18', 1),
('006', 'Cañitas de Felipe Pescador', '32', 0, '2018-03-13 17:55:18', 0, '2018-03-13 17:55:18', 1),
('051', 'Villa de Cos', '32', 0, '2018-03-13 17:55:18', 0, '2018-03-13 17:55:18', 1),
('039', 'Río Grande', '32', 0, '2018-03-13 17:55:18', 0, '2018-03-13 17:55:18', 1),
('029', 'Miguel Auza', '32', 0, '2018-03-13 17:55:18', 0, '2018-03-13 17:55:18', 1),
('022', 'Juan Aldama', '32', 0, '2018-03-13 17:55:17', 0, '2018-03-13 17:55:17', 1),
('041', 'El Salvador', '32', 0, '2018-03-13 17:55:17', 0, '2018-03-13 17:55:17', 1),
('026', 'Mazapil', '32', 0, '2018-03-13 17:55:17', 0, '2018-03-13 17:55:17', 1),
('027', 'Melchor Ocampo', '32', 0, '2018-03-13 17:55:17', 0, '2018-03-13 17:55:17', 1),
('007', 'Concepción del Oro', '32', 0, '2018-03-13 17:55:17', 0, '2018-03-13 17:55:17', 1),
('050', 'Vetagrande', '32', 0, '2018-03-13 17:55:17', 0, '2018-03-13 17:55:17', 1),
('032', 'Morelos', '32', 0, '2018-03-13 17:55:17', 0, '2018-03-13 17:55:17', 1),
('056', 'Zacatecas', '32', 0, '2018-03-13 17:55:17', 0, '2018-03-13 17:55:17', 1),
('003', 'Akil', '31', 0, '2018-03-13 17:55:17', 0, '2018-03-13 17:55:17', 1),
('079', 'Tekax', '31', 0, '2018-03-13 17:55:17', 0, '2018-03-13 17:55:17', 1),
('098', 'Tzucacab', '31', 0, '2018-03-13 17:55:17', 0, '2018-03-13 17:55:17', 1),
('016', 'Chacsinkín', '31', 0, '2018-03-13 17:55:17', 0, '2018-03-13 17:55:17', 1),
('094', 'Tixmehuac', '31', 0, '2018-03-13 17:55:17', 0, '2018-03-13 17:55:17', 1),
('073', 'Tahdziú', '31', 0, '2018-03-13 17:55:16', 0, '2018-03-13 17:55:16', 1),
('022', 'Chikindzonot', '31', 0, '2018-03-13 17:55:16', 0, '2018-03-13 17:55:16', 1),
('058', 'Peto', '31', 0, '2018-03-13 17:55:16', 0, '2018-03-13 17:55:16', 1),
('104', 'Yaxcabá', '31', 0, '2018-03-13 17:55:16', 0, '2018-03-13 17:55:16', 1),
('010', 'Cantamayec', '31', 0, '2018-03-13 17:55:16', 0, '2018-03-13 17:55:16', 1),
('075', 'Teabo', '31', 0, '2018-03-13 17:55:16', 0, '2018-03-13 17:55:16', 1),
('049', 'Mayapán', '31', 0, '2018-03-13 17:55:16', 0, '2018-03-13 17:55:16', 1),
('024', 'Chumayel', '31', 0, '2018-03-13 17:55:16', 0, '2018-03-13 17:55:16', 1),
('046', 'Mama', '31', 0, '2018-03-13 17:55:16', 0, '2018-03-13 17:55:16', 1),
('066', 'Santa Elena', '31', 0, '2018-03-13 17:55:16', 0, '2018-03-13 17:55:16', 1),
('056', 'Oxkutzcab', '31', 0, '2018-03-13 17:55:16', 0, '2018-03-13 17:55:16', 1),
('089', 'Ticul', '31', 0, '2018-03-13 17:55:16', 0, '2018-03-13 17:55:16', 1),
('018', 'Chapab', '31', 0, '2018-03-13 17:55:16', 0, '2018-03-13 17:55:16', 1),
('025', 'Dzán', '31', 0, '2018-03-13 17:55:15', 0, '2018-03-13 17:55:15', 1),
('047', 'Maní', '31', 0, '2018-03-13 17:55:15', 0, '2018-03-13 17:55:15', 1),
('062', 'Sacalum', '31', 0, '2018-03-13 17:55:15', 0, '2018-03-13 17:55:15', 1),
('053', 'Muna', '31', 0, '2018-03-13 17:55:15', 0, '2018-03-13 17:55:15', 1),
('033', 'Halachó', '31', 0, '2018-03-13 17:55:15', 0, '2018-03-13 17:55:15', 1),
('001', 'Abalá', '31', 0, '2018-03-13 17:55:15', 0, '2018-03-13 17:55:15', 1),
('076', 'Tecoh', '31', 0, '2018-03-13 17:55:15', 0, '2018-03-13 17:55:15', 1),
('045', 'Kopomá', '31', 0, '2018-03-13 17:55:15', 0, '2018-03-13 17:55:15', 1),
('023', 'Chocholá', '31', 0, '2018-03-13 17:55:15', 0, '2018-03-13 17:55:15', 1),
('055', 'Opichén', '31', 0, '2018-03-13 17:55:15', 0, '2018-03-13 17:55:15', 1),
('063', 'Samahil', '31', 0, '2018-03-13 17:55:15', 0, '2018-03-13 17:55:15', 1),
('048', 'Maxcanú', '31', 0, '2018-03-13 17:55:15', 0, '2018-03-13 17:55:15', 1),
('099', 'Uayma', '31', 0, '2018-03-13 17:55:15', 0, '2018-03-13 17:55:15', 1),
('102', 'Valladolid', '31', 0, '2018-03-13 17:55:14', 0, '2018-03-13 17:55:14', 1),
('019', 'Chemax', '31', 0, '2018-03-13 17:55:14', 0, '2018-03-13 17:55:14', 1),
('081', 'Tekom', '31', 0, '2018-03-13 17:55:14', 0, '2018-03-13 17:55:14', 1),
('014', 'Cuncunul', '31', 0, '2018-03-13 17:55:14', 0, '2018-03-13 17:55:14', 1),
('043', 'Kaua', '31', 0, '2018-03-13 17:55:14', 0, '2018-03-13 17:55:14', 1),
('092', 'Tixcacalcupul', '31', 0, '2018-03-13 17:55:14', 0, '2018-03-13 17:55:14', 1),
('021', 'Chichimilá', '31', 0, '2018-03-13 17:55:14', 0, '2018-03-13 17:55:14', 1),
('017', 'Chankom', '31', 0, '2018-03-13 17:55:14', 0, '2018-03-13 17:55:14', 1),
('091', 'Tinum', '31', 0, '2018-03-13 17:55:14', 0, '2018-03-13 17:55:14', 1),
('008', 'Calotmul', '31', 0, '2018-03-13 17:55:14', 0, '2018-03-13 17:55:14', 1),
('085', 'Temozón', '31', 0, '2018-03-13 17:55:14', 0, '2018-03-13 17:55:14', 1),
('032', 'Espita', '31', 0, '2018-03-13 17:55:14', 0, '2018-03-13 17:55:14', 1),
('061', 'Río Lagartos', '31', 0, '2018-03-13 17:55:13', 0, '2018-03-13 17:55:13', 1),
('096', 'Tizimín', '31', 0, '2018-03-13 17:55:13', 0, '2018-03-13 17:55:13', 1),
('069', 'Sotuta', '31', 0, '2018-03-13 17:55:13', 0, '2018-03-13 17:55:13', 1),
('080', 'Tekit', '31', 0, '2018-03-13 17:55:13', 0, '2018-03-13 17:55:13', 1),
('071', 'Sudzal', '31', 0, '2018-03-13 17:55:13', 0, '2018-03-13 17:55:13', 1),
('042', 'Kantunil', '31', 0, '2018-03-13 17:55:13', 0, '2018-03-13 17:55:13', 1),
('030', 'Dzitás', '31', 0, '2018-03-13 17:55:13', 0, '2018-03-13 17:55:13', 1),
('060', 'Quintana Roo', '31', 0, '2018-03-13 17:55:13', 0, '2018-03-13 17:55:13', 1),
('097', 'Tunkás', '31', 0, '2018-03-13 17:55:13', 0, '2018-03-13 17:55:13', 1),
('031', 'Dzoncauich', '31', 0, '2018-03-13 17:55:13', 0, '2018-03-13 17:55:13', 1),
('012', 'Cenotillo', '31', 0, '2018-03-13 17:55:13', 0, '2018-03-13 17:55:13', 1),
('070', 'Sucilá', '31', 0, '2018-03-13 17:55:13', 0, '2018-03-13 17:55:13', 1),
('006', 'Buctzotz', '31', 0, '2018-03-13 17:55:13', 0, '2018-03-13 17:55:13', 1),
('057', 'Panabá', '31', 0, '2018-03-13 17:55:12', 0, '2018-03-13 17:55:12', 1),
('065', 'San Felipe', '31', 0, '2018-03-13 17:55:12', 0, '2018-03-13 17:55:12', 1),
('028', 'Dzilam de Bravo', '31', 0, '2018-03-13 17:55:12', 0, '2018-03-13 17:55:12', 1),
('029', 'Dzilam González', '31', 0, '2018-03-13 17:55:12', 0, '2018-03-13 17:55:12', 1),
('037', 'Huhí', '31', 0, '2018-03-13 17:55:12', 0, '2018-03-13 17:55:12', 1),
('064', 'Sanahcat', '31', 0, '2018-03-13 17:55:12', 0, '2018-03-13 17:55:12', 1),
('036', 'Homún', '31', 0, '2018-03-13 17:55:12', 0, '2018-03-13 17:55:12', 1),
('015', 'Cuzamá', '31', 0, '2018-03-13 17:55:12', 0, '2018-03-13 17:55:12', 1),
('067', 'Seyé', '31', 0, '2018-03-13 17:55:12', 0, '2018-03-13 17:55:12', 1),
('103', 'Xocchel', '31', 0, '2018-03-13 17:55:12', 0, '2018-03-13 17:55:12', 1),
('034', 'Hocabá', '31', 0, '2018-03-13 17:55:12', 0, '2018-03-13 17:55:12', 1),
('040', 'Izamal', '31', 0, '2018-03-13 17:55:12', 0, '2018-03-13 17:55:12', 1),
('086', 'Tepakán', '31', 0, '2018-03-13 17:55:11', 0, '2018-03-13 17:55:11', 1),
('077', 'Tekal de Venegas', '31', 0, '2018-03-13 17:55:12', 0, '2018-03-13 17:55:12', 1),
('072', 'Suma', '31', 0, '2018-03-13 17:55:11', 0, '2018-03-13 17:55:11', 1),
('088', 'Teya', '31', 0, '2018-03-13 17:55:11', 0, '2018-03-13 17:55:11', 1),
('078', 'Tekantó', '31', 0, '2018-03-13 17:55:11', 0, '2018-03-13 17:55:11', 1),
('084', 'Temax', '31', 0, '2018-03-13 17:55:11', 0, '2018-03-13 17:55:11', 1),
('027', 'Dzidzantún', '31', 0, '2018-03-13 17:55:11', 0, '2018-03-13 17:55:11', 1),
('074', 'Tahmek', '31', 0, '2018-03-13 17:55:11', 0, '2018-03-13 17:55:11', 1),
('035', 'Hoctún', '31', 0, '2018-03-13 17:55:11', 0, '2018-03-13 17:55:11', 1),
('093', 'Tixkokob', '31', 0, '2018-03-13 17:55:11', 0, '2018-03-13 17:55:11', 1),
('005', 'Bokobá', '31', 0, '2018-03-13 17:55:11', 0, '2018-03-13 17:55:11', 1),
('007', 'Cacalchén', '31', 0, '2018-03-13 17:55:11', 0, '2018-03-13 17:55:11', 1),
('054', 'Muxupip', '31', 0, '2018-03-13 17:55:11', 0, '2018-03-13 17:55:11', 1),
('051', 'Mocochá', '31', 0, '2018-03-13 17:55:11', 0, '2018-03-13 17:55:11', 1),
('004', 'Baca', '31', 0, '2018-03-13 17:55:10', 0, '2018-03-13 17:55:10', 1),
('052', 'Motul', '31', 0, '2018-03-13 17:55:10', 0, '2018-03-13 17:55:10', 1),
('106', 'Yobaín', '31', 0, '2018-03-13 17:55:10', 0, '2018-03-13 17:55:10', 1),
('068', 'Sinanché', '31', 0, '2018-03-13 17:55:10', 0, '2018-03-13 17:55:10', 1),
('009', 'Cansahcab', '31', 0, '2018-03-13 17:55:10', 0, '2018-03-13 17:55:10', 1),
('083', 'Telchac Puerto', '31', 0, '2018-03-13 17:55:10', 0, '2018-03-13 17:55:10', 1),
('026', 'Dzemul', '31', 0, '2018-03-13 17:55:10', 0, '2018-03-13 17:55:10', 1),
('082', 'Telchac Pueblo', '31', 0, '2018-03-13 17:55:10', 0, '2018-03-13 17:55:10', 1),
('101', 'Umán', '31', 0, '2018-03-13 17:55:10', 0, '2018-03-13 17:55:10', 1),
('095', 'Tixpéhual', '31', 0, '2018-03-13 17:55:10', 0, '2018-03-13 17:55:10', 1),
('002', 'Acanceh', '31', 0, '2018-03-13 17:55:10', 0, '2018-03-13 17:55:10', 1),
('090', 'Timucuy', '31', 0, '2018-03-13 17:55:10', 0, '2018-03-13 17:55:10', 1),
('041', 'Kanasín', '31', 0, '2018-03-13 17:55:09', 0, '2018-03-13 17:55:09', 1),
('011', 'Celestún', '31', 0, '2018-03-13 17:55:09', 0, '2018-03-13 17:55:09', 1),
('087', 'Tetiz', '31', 0, '2018-03-13 17:55:09', 0, '2018-03-13 17:55:09', 1),
('100', 'Ucú', '31', 0, '2018-03-13 17:55:09', 0, '2018-03-13 17:55:09', 1),
('044', 'Kinchil', '31', 0, '2018-03-13 17:55:09', 0, '2018-03-13 17:55:09', 1),
('038', 'Hunucmá', '31', 0, '2018-03-13 17:55:09', 0, '2018-03-13 17:55:09', 1),
('105', 'Yaxkukul', '31', 0, '2018-03-13 17:55:09', 0, '2018-03-13 17:55:09', 1),
('013', 'Conkal', '31', 0, '2018-03-13 17:55:09', 0, '2018-03-13 17:55:09', 1),
('039', 'Ixil', '31', 0, '2018-03-13 17:55:09', 0, '2018-03-13 17:55:09', 1),
('020', 'Chicxulub Pueblo', '31', 0, '2018-03-13 17:55:09', 0, '2018-03-13 17:55:09', 1),
('210', 'Uxpanapa', '30', 0, '2018-03-13 17:55:08', 0, '2018-03-13 17:55:08', 1),
('050', 'Mérida', '31', 0, '2018-03-13 17:55:09', 0, '2018-03-13 17:55:09', 1),
('059', 'Progreso', '31', 0, '2018-03-13 17:55:09', 0, '2018-03-13 17:55:09', 1),
('061', 'Las Choapas', '30', 0, '2018-03-13 17:55:08', 0, '2018-03-13 17:55:08', 1),
('091', 'Jesús Carranza', '30', 0, '2018-03-13 17:55:08', 0, '2018-03-13 17:55:08', 1),
('070', 'Hidalgotitlán', '30', 0, '2018-03-13 17:55:08', 0, '2018-03-13 17:55:08', 1),
('108', 'Minatitlán', '30', 0, '2018-03-13 17:55:08', 0, '2018-03-13 17:55:08', 1),
('204', 'Agua Dulce', '30', 0, '2018-03-13 17:55:08', 0, '2018-03-13 17:55:08', 1),
('039', 'Coatzacoalcos', '30', 0, '2018-03-13 17:55:08', 0, '2018-03-13 17:55:08', 1),
('111', 'Moloacán', '30', 0, '2018-03-13 17:55:08', 0, '2018-03-13 17:55:08', 1),
('082', 'Ixhuatlán del Sureste', '30', 0, '2018-03-13 17:55:08', 0, '2018-03-13 17:55:08', 1),
('089', 'Jáltipan', '30', 0, '2018-03-13 17:55:07', 0, '2018-03-13 17:55:07', 1),
('199', 'Zaragoza', '30', 0, '2018-03-13 17:55:07', 0, '2018-03-13 17:55:07', 1),
('120', 'Oteapan', '30', 0, '2018-03-13 17:55:08', 0, '2018-03-13 17:55:08', 1),
('048', 'Cosoleacaque', '30', 0, '2018-03-13 17:55:08', 0, '2018-03-13 17:55:08', 1),
('206', 'Nanchital de Lázaro Cárdenas del Río', '30', 0, '2018-03-13 17:55:08', 0, '2018-03-13 17:55:08', 1),
('172', 'Texistepec', '30', 0, '2018-03-13 17:55:07', 0, '2018-03-13 17:55:07', 1),
('145', 'Soconusco', '30', 0, '2018-03-13 17:55:07', 0, '2018-03-13 17:55:07', 1),
('116', 'Oluta', '30', 0, '2018-03-13 17:55:07', 0, '2018-03-13 17:55:07', 1),
('144', 'Sayula de Alemán', '30', 0, '2018-03-13 17:55:07', 0, '2018-03-13 17:55:07', 1),
('142', 'San Juan Evangelista', '30', 0, '2018-03-13 17:55:07', 0, '2018-03-13 17:55:07', 1),
('003', 'Acayucan', '30', 0, '2018-03-13 17:55:07', 0, '2018-03-13 17:55:07', 1),
('122', 'Pajapan', '30', 0, '2018-03-13 17:55:07', 0, '2018-03-13 17:55:07', 1),
('059', 'Chinameca', '30', 0, '2018-03-13 17:55:07', 0, '2018-03-13 17:55:07', 1),
('209', 'Tatahuicapan de Juárez', '30', 0, '2018-03-13 17:55:07', 0, '2018-03-13 17:55:07', 1),
('104', 'Mecayapan', '30', 0, '2018-03-13 17:55:06', 0, '2018-03-13 17:55:06', 1),
('149', 'Soteapan', '30', 0, '2018-03-13 17:55:06', 0, '2018-03-13 17:55:06', 1),
('032', 'Catemaco', '30', 0, '2018-03-13 17:55:06', 0, '2018-03-13 17:55:06', 1),
('073', 'Hueyapan de Ocampo', '30', 0, '2018-03-13 17:55:06', 0, '2018-03-13 17:55:06', 1),
('015', 'Angel R. Cabada', '30', 0, '2018-03-13 17:55:06', 0, '2018-03-13 17:55:06', 1),
('143', 'Santiago Tuxtla', '30', 0, '2018-03-13 17:55:06', 0, '2018-03-13 17:55:06', 1),
('141', 'San Andrés Tuxtla', '30', 0, '2018-03-13 17:55:06', 0, '2018-03-13 17:55:06', 1),
('094', 'Juan Rodríguez Clara', '30', 0, '2018-03-13 17:55:06', 0, '2018-03-13 17:55:06', 1),
('077', 'Isla', '30', 0, '2018-03-13 17:55:06', 0, '2018-03-13 17:55:06', 1),
('212', 'Santiago Sochiapan', '30', 0, '2018-03-13 17:55:05', 0, '2018-03-13 17:55:05', 1),
('130', 'Playa Vicente', '30', 0, '2018-03-13 17:55:05', 0, '2018-03-13 17:55:05', 1),
('169', 'José Azueta', '30', 0, '2018-03-13 17:55:05', 0, '2018-03-13 17:55:05', 1),
('054', 'Chacaltianguis', '30', 0, '2018-03-13 17:55:05', 0, '2018-03-13 17:55:05', 1),
('119', 'Otatitlán', '30', 0, '2018-03-13 17:55:05', 0, '2018-03-13 17:55:05', 1),
('176', 'Tlacojalpan', '30', 0, '2018-03-13 17:55:05', 0, '2018-03-13 17:55:05', 1),
('190', 'Tuxtilla', '30', 0, '2018-03-13 17:55:05', 0, '2018-03-13 17:55:05', 1),
('139', 'Saltabarranca', '30', 0, '2018-03-13 17:55:05', 0, '2018-03-13 17:55:05', 1),
('178', 'Tlacotalpan', '30', 0, '2018-03-13 17:55:05', 0, '2018-03-13 17:55:05', 1),
('005', 'Acula', '30', 0, '2018-03-13 17:55:05', 0, '2018-03-13 17:55:05', 1),
('012', 'Amatitlán', '30', 0, '2018-03-13 17:55:05', 0, '2018-03-13 17:55:05', 1),
('084', 'Ixmatlahuacan', '30', 0, '2018-03-13 17:55:04', 0, '2018-03-13 17:55:04', 1),
('045', 'Cosamaloapan de Carpio', '30', 0, '2018-03-13 17:55:04', 0, '2018-03-13 17:55:04', 1),
('208', 'Carlos A. Carrillo', '30', 0, '2018-03-13 17:55:04', 0, '2018-03-13 17:55:04', 1),
('207', 'Tres Valles', '30', 0, '2018-03-13 17:55:04', 0, '2018-03-13 17:55:04', 1),
('097', 'Lerdo de Tejada', '30', 0, '2018-03-13 17:55:04', 0, '2018-03-13 17:55:04', 1),
('011', 'Alvarado', '30', 0, '2018-03-13 17:55:04', 0, '2018-03-13 17:55:04', 1),
('075', 'Ignacio de la Llave', '30', 0, '2018-03-13 17:55:04', 0, '2018-03-13 17:55:04', 1),
('181', 'Tlalixcoyan', '30', 0, '2018-03-13 17:55:04', 0, '2018-03-13 17:55:04', 1),
('174', 'Tierra Blanca', '30', 0, '2018-03-13 17:55:04', 0, '2018-03-13 17:55:04', 1),
('173', 'Tezonapa', '30', 0, '2018-03-13 17:55:04', 0, '2018-03-13 17:55:04', 1),
('171', 'Texhuacán', '30', 0, '2018-03-13 17:55:04', 0, '2018-03-13 17:55:04', 1),
('137', 'Los Reyes', '30', 0, '2018-03-13 17:55:04', 0, '2018-03-13 17:55:04', 1),
('110', 'Mixtla de Altamirano', '30', 0, '2018-03-13 17:55:04', 0, '2018-03-13 17:55:04', 1),
('159', 'Tehuipango', '30', 0, '2018-03-13 17:55:03', 0, '2018-03-13 17:55:03', 1),
('201', 'Zongolica', '30', 0, '2018-03-13 17:55:03', 0, '2018-03-13 17:55:03', 1),
('049', 'Cotaxtla', '30', 0, '2018-03-13 17:55:03', 0, '2018-03-13 17:55:03', 1),
('031', 'Carrillo Puerto', '30', 0, '2018-03-13 17:55:03', 0, '2018-03-13 17:55:03', 1),
('125', 'Paso del Macho', '30', 0, '2018-03-13 17:55:03', 0, '2018-03-13 17:55:03', 1),
('021', 'Atoyac', '30', 0, '2018-03-13 17:55:03', 0, '2018-03-13 17:55:03', 1),
('014', 'Amatlán de los Reyes', '30', 0, '2018-03-13 17:55:03', 0, '2018-03-13 17:55:03', 1),
('196', 'Yanga', '30', 0, '2018-03-13 17:55:03', 0, '2018-03-13 17:55:03', 1),
('052', 'Cuichapa', '30', 0, '2018-03-13 17:55:03', 0, '2018-03-13 17:55:03', 1),
('053', 'Cuitláhuac', '30', 0, '2018-03-13 17:55:03', 0, '2018-03-13 17:55:03', 1),
('041', 'Coetzala', '30', 0, '2018-03-13 17:55:03', 0, '2018-03-13 17:55:03', 1),
('117', 'Omealca', '30', 0, '2018-03-13 17:55:03', 0, '2018-03-13 17:55:03', 1),
('113', 'Naranjal', '30', 0, '2018-03-13 17:55:03', 0, '2018-03-13 17:55:03', 1),
('098', 'Magdalena', '30', 0, '2018-03-13 17:55:02', 0, '2018-03-13 17:55:02', 1),
('185', 'Tlilapan', '30', 0, '2018-03-13 17:55:02', 0, '2018-03-13 17:55:02', 1),
('140', 'San Andrés Tenejapan', '30', 0, '2018-03-13 17:55:02', 0, '2018-03-13 17:55:02', 1),
('168', 'Tequila', '30', 0, '2018-03-13 17:55:02', 0, '2018-03-13 17:55:02', 1),
('020', 'Atlahuilco', '30', 0, '2018-03-13 17:55:02', 0, '2018-03-13 17:55:02', 1),
('195', 'Xoxocotla', '30', 0, '2018-03-13 17:55:02', 0, '2018-03-13 17:55:02', 1),
('074', 'Huiloapan de Cuauhtémoc', '30', 0, '2018-03-13 17:55:02', 0, '2018-03-13 17:55:02', 1),
('019', 'Astacinga', '30', 0, '2018-03-13 17:55:02', 0, '2018-03-13 17:55:02', 1),
('184', 'Tlaquilpa', '30', 0, '2018-03-13 17:55:02', 0, '2018-03-13 17:55:02', 1),
('147', 'Soledad Atzompa', '30', 0, '2018-03-13 17:55:02', 0, '2018-03-13 17:55:02', 1),
('006', 'Acultzingo', '30', 0, '2018-03-13 17:55:02', 0, '2018-03-13 17:55:02', 1),
('018', 'Aquila', '30', 0, '2018-03-13 17:55:02', 0, '2018-03-13 17:55:02', 1),
('030', 'Camerino Z. Mendoza', '30', 0, '2018-03-13 17:55:02', 0, '2018-03-13 17:55:02', 1),
('115', 'Nogales', '30', 0, '2018-03-13 17:55:01', 0, '2018-03-13 17:55:01', 1),
('138', 'Río Blanco', '30', 0, '2018-03-13 17:55:01', 0, '2018-03-13 17:55:01', 1),
('044', 'Córdoba', '30', 0, '2018-03-13 17:55:01', 0, '2018-03-13 17:55:01', 1),
('099', 'Maltrata', '30', 0, '2018-03-13 17:55:01', 0, '2018-03-13 17:55:01', 1),
('068', 'Fortín', '30', 0, '2018-03-13 17:55:01', 0, '2018-03-13 17:55:01', 1),
('085', 'Ixtaczoquitlán', '30', 0, '2018-03-13 17:55:01', 0, '2018-03-13 17:55:01', 1),
('081', 'Ixhuatlancillo', '30', 0, '2018-03-13 17:55:01', 0, '2018-03-13 17:55:01', 1),
('022', 'Atzacan', '30', 0, '2018-03-13 17:55:01', 0, '2018-03-13 17:55:01', 1),
('101', 'Mariano Escobedo', '30', 0, '2018-03-13 17:55:01', 0, '2018-03-13 17:55:01', 1),
('135', 'Rafael Delgado', '30', 0, '2018-03-13 17:55:01', 0, '2018-03-13 17:55:01', 1),
('118', 'Orizaba', '30', 0, '2018-03-13 17:55:01', 0, '2018-03-13 17:55:01', 1),
('028', 'Boca del Río', '30', 0, '2018-03-13 17:55:01', 0, '2018-03-13 17:55:01', 1),
('090', 'Jamapa', '30', 0, '2018-03-13 17:55:00', 0, '2018-03-13 17:55:00', 1),
('105', 'Medellín de Bravo', '30', 0, '2018-03-13 17:55:01', 0, '2018-03-13 17:55:01', 1),
('100', 'Manlio Fabio Altamirano', '30', 0, '2018-03-13 17:55:00', 0, '2018-03-13 17:55:00', 1),
('148', 'Soledad de Doblado', '30', 0, '2018-03-13 17:55:00', 0, '2018-03-13 17:55:00', 1),
('007', 'Camarón de Tejeda', '30', 0, '2018-03-13 17:55:00', 0, '2018-03-13 17:55:00', 1),
('165', 'Tepatlaxco', '30', 0, '2018-03-13 17:55:00', 0, '2018-03-13 17:55:00', 1),
('043', 'Comapa', '30', 0, '2018-03-13 17:55:00', 0, '2018-03-13 17:55:00', 1),
('200', 'Zentla', '30', 0, '2018-03-13 17:55:00', 0, '2018-03-13 17:55:00', 1),
('062', 'Chocamán', '30', 0, '2018-03-13 17:55:00', 0, '2018-03-13 17:55:00', 1),
('186', 'Tomatlán', '30', 0, '2018-03-13 17:55:00', 0, '2018-03-13 17:55:00', 1),
('080', 'Ixhuatlán del Café', '30', 0, '2018-03-13 17:55:00', 0, '2018-03-13 17:55:00', 1),
('127', 'La Perla', '30', 0, '2018-03-13 17:55:00', 0, '2018-03-13 17:55:00', 1),
('047', 'Coscomatepec', '30', 0, '2018-03-13 17:55:00', 0, '2018-03-13 17:55:00', 1),
('008', 'Alpatláhuac', '30', 0, '2018-03-13 17:55:00', 0, '2018-03-13 17:55:00', 1),
('029', 'Calcahualco', '30', 0, '2018-03-13 17:54:59', 0, '2018-03-13 17:54:59', 1),
('071', 'Huatusco', '30', 0, '2018-03-13 17:54:59', 0, '2018-03-13 17:54:59', 1),
('179', 'Tlacotepec de Mejía', '30', 0, '2018-03-13 17:54:59', 0, '2018-03-13 17:54:59', 1),
('146', 'Sochiapa', '30', 0, '2018-03-13 17:54:59', 0, '2018-03-13 17:54:59', 1),
('188', 'Totutla', '30', 0, '2018-03-13 17:54:59', 0, '2018-03-13 17:54:59', 1),
('162', 'Tenampa', '30', 0, '2018-03-13 17:54:59', 0, '2018-03-13 17:54:59', 1),
('024', 'Tlaltetela', '30', 0, '2018-03-13 17:54:59', 0, '2018-03-13 17:54:59', 1),
('088', 'Jalcomulco', '30', 0, '2018-03-13 17:54:59', 0, '2018-03-13 17:54:59', 1),
('192', 'Vega de Alatorre', '30', 0, '2018-03-13 17:54:59', 0, '2018-03-13 17:54:59', 1),
('042', 'Colipa', '30', 0, '2018-03-13 17:54:59', 0, '2018-03-13 17:54:59', 1),
('197', 'Yecuatla', '30', 0, '2018-03-13 17:54:59', 0, '2018-03-13 17:54:59', 1),
('057', 'Chiconquiaco', '30', 0, '2018-03-13 17:54:59', 0, '2018-03-13 17:54:59', 1),
('096', 'Landero y Coss', '30', 0, '2018-03-13 17:54:59', 0, '2018-03-13 17:54:59', 1),
('109', 'Misantla', '30', 0, '2018-03-13 17:54:58', 0, '2018-03-13 17:54:58', 1),
('114', 'Nautla', '30', 0, '2018-03-13 17:54:58', 0, '2018-03-13 17:54:58', 1),
('163', 'Tenochtitlán', '30', 0, '2018-03-13 17:54:58', 0, '2018-03-13 17:54:58', 1),
('156', 'Tatatila', '30', 0, '2018-03-13 17:54:58', 0, '2018-03-13 17:54:58', 1),
('010', 'Altotonga', '30', 0, '2018-03-13 17:54:58', 0, '2018-03-13 17:54:58', 1),
('107', 'Las Minas', '30', 0, '2018-03-13 17:54:58', 0, '2018-03-13 17:54:58', 1),
('023', 'Atzalan', '30', 0, '2018-03-13 17:54:58', 0, '2018-03-13 17:54:58', 1),
('086', 'Jalacingo', '30', 0, '2018-03-13 17:54:58', 0, '2018-03-13 17:54:58', 1),
('183', 'Tlapacoyan', '30', 0, '2018-03-13 17:54:58', 0, '2018-03-13 17:54:58', 1),
('211', 'San Rafael', '30', 0, '2018-03-13 17:54:58', 0, '2018-03-13 17:54:58', 1),
('102', 'Martínez de la Torre', '30', 0, '2018-03-13 17:54:58', 0, '2018-03-13 17:54:58', 1),
('158', 'Tecolutla', '30', 0, '2018-03-13 17:54:58', 0, '2018-03-13 17:54:58', 1),
('069', 'Gutiérrez Zamora', '30', 0, '2018-03-13 17:54:58', 0, '2018-03-13 17:54:58', 1),
('124', 'Papantla', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('131', 'Poza Rica de Hidalgo', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('066', 'Espinal', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('040', 'Coatzintla', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('051', 'Coyutla', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('037', 'Coahuitlán', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('067', 'Filomeno Mata', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('103', 'Mecatlán', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('064', 'Chumatlán', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('050', 'Coxquihui', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('157', 'Castillo de Teayo', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('203', 'Zozocolco de Hidalgo', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('033', 'Cazones de Herrera', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('175', 'Tihuatlán', '30', 0, '2018-03-13 17:54:57', 0, '2018-03-13 17:54:57', 1),
('189', 'Tuxpan', '30', 0, '2018-03-13 17:54:56', 0, '2018-03-13 17:54:56', 1),
('058', 'Chicontepec', '30', 0, '2018-03-13 17:54:56', 0, '2018-03-13 17:54:56', 1),
('160', 'Álamo Temapache', '30', 0, '2018-03-13 17:54:56', 0, '2018-03-13 17:54:56', 1),
('083', 'Ixhuatlán de Madero', '30', 0, '2018-03-13 17:54:56', 0, '2018-03-13 17:54:56', 1),
('180', 'Tlachichilco', '30', 0, '2018-03-13 17:54:56', 0, '2018-03-13 17:54:56', 1),
('170', 'Texcatepec', '30', 0, '2018-03-13 17:54:56', 0, '2018-03-13 17:54:56', 1),
('198', 'Zacualpan', '30', 0, '2018-03-13 17:54:56', 0, '2018-03-13 17:54:56', 1),
('027', 'Benito Juárez', '30', 0, '2018-03-13 17:54:56', 0, '2018-03-13 17:54:56', 1),
('202', 'Zontecomatlán de López y Fuentes', '30', 0, '2018-03-13 17:54:56', 0, '2018-03-13 17:54:56', 1),
('151', 'Tamiahua', '30', 0, '2018-03-13 17:54:56', 0, '2018-03-13 17:54:56', 1),
('072', 'Huayacocotla', '30', 0, '2018-03-13 17:54:56', 0, '2018-03-13 17:54:56', 1),
('076', 'Ilamatlán', '30', 0, '2018-03-13 17:54:56', 0, '2018-03-13 17:54:56', 1),
('153', 'Tancoco', '30', 0, '2018-03-13 17:54:56', 0, '2018-03-13 17:54:56', 1),
('167', 'Tepetzintla', '30', 0, '2018-03-13 17:54:55', 0, '2018-03-13 17:54:55', 1),
('034', 'Cerro Azul', '30', 0, '2018-03-13 17:54:55', 0, '2018-03-13 17:54:55', 1),
('154', 'Tantima', '30', 0, '2018-03-13 17:54:55', 0, '2018-03-13 17:54:55', 1),
('150', 'Tamalín', '30', 0, '2018-03-13 17:54:55', 0, '2018-03-13 17:54:55', 1),
('060', 'Chinampa de Gorostiza', '30', 0, '2018-03-13 17:54:55', 0, '2018-03-13 17:54:55', 1),
('205', 'El Higo', '30', 0, '2018-03-13 17:54:55', 0, '2018-03-13 17:54:55', 1),
('013', 'Naranjos Amatlán', '30', 0, '2018-03-13 17:54:55', 0, '2018-03-13 17:54:55', 1),
('078', 'Ixcatepec', '30', 0, '2018-03-13 17:54:55', 0, '2018-03-13 17:54:55', 1),
('063', 'Chontla', '30', 0, '2018-03-13 17:54:55', 0, '2018-03-13 17:54:55', 1),
('035', 'Citlaltépetl', '30', 0, '2018-03-13 17:54:55', 0, '2018-03-13 17:54:55', 1),
('055', 'Chalma', '30', 0, '2018-03-13 17:54:55', 0, '2018-03-13 17:54:55', 1),
('056', 'Chiconamel', '30', 0, '2018-03-13 17:54:55', 0, '2018-03-13 17:54:55', 1),
('155', 'Tantoyuca', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('129', 'Platón Sánchez', '30', 0, '2018-03-13 17:54:55', 0, '2018-03-13 17:54:55', 1),
('121', 'Ozuluama de Mascareñas', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('161', 'Tempoal', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('152', 'Tampico Alto', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('133', 'Pueblo Viejo', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('126', 'Paso de Ovejas', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('123', 'Pánuco', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('193', 'Veracruz', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('016', 'La Antigua', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('017', 'Apazapan', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('134', 'Puente Nacional', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('191', 'Ursulo Galván', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('004', 'Actopan', '30', 0, '2018-03-13 17:54:53', 0, '2018-03-13 17:54:53', 1),
('038', 'Coatepec', '30', 0, '2018-03-13 17:54:53', 0, '2018-03-13 17:54:53', 1),
('164', 'Teocelo', '30', 0, '2018-03-13 17:54:53', 0, '2018-03-13 17:54:53', 1),
('046', 'Cosautlán de Carvajal', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('065', 'Emiliano Zapata', '30', 0, '2018-03-13 17:54:54', 0, '2018-03-13 17:54:54', 1),
('009', 'Alto Lucero de Gutiérrez Barrios', '30', 0, '2018-03-13 17:54:53', 0, '2018-03-13 17:54:53', 1),
('002', 'Acatlán', '30', 0, '2018-03-13 17:54:53', 0, '2018-03-13 17:54:53', 1),
('166', 'Tepetlán', '30', 0, '2018-03-13 17:54:53', 0, '2018-03-13 17:54:53', 1),
('095', 'Juchique de Ferrer', '30', 0, '2018-03-13 17:54:53', 0, '2018-03-13 17:54:53', 1),
('106', 'Miahuatlán', '30', 0, '2018-03-13 17:54:53', 0, '2018-03-13 17:54:53', 1),
('112', 'Naolinco', '30', 0, '2018-03-13 17:54:53', 0, '2018-03-13 17:54:53', 1),
('093', 'Jilotepec', '30', 0, '2018-03-13 17:54:53', 0, '2018-03-13 17:54:53', 1),
('187', 'Tonayán', '30', 0, '2018-03-13 17:54:53', 0, '2018-03-13 17:54:53', 1),
('036', 'Coacoatzintla', '30', 0, '2018-03-13 17:54:53', 0, '2018-03-13 17:54:53', 1),
('177', 'Tlacolulan', '30', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('194', 'Villa Aldama', '30', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('132', 'Las Vigas de Ramírez', '30', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('026', 'Banderilla', '30', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('136', 'Rafael Lucio', '30', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('001', 'Acajete', '30', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('128', 'Perote', '30', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('025', 'Ayahualulco', '30', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('079', 'Ixhuacán de los Reyes', '30', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('092', 'Xico', '30', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('182', 'Tlalnelhuayocan', '30', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('087', 'Xalapa', '30', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('025', 'San Pablo del Monte', '29', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('027', 'Tenancingo', '29', 0, '2018-03-13 17:54:52', 0, '2018-03-13 17:54:52', 1),
('017', 'Mazatecochco de José María Morelos', '29', 0, '2018-03-13 17:54:51', 0, '2018-03-13 17:54:51', 1),
('059', 'Santa Cruz Quilehtla', '29', 0, '2018-03-13 17:54:51', 0, '2018-03-13 17:54:51', 1),
('050', 'San Francisco Tetlanohcan', '29', 0, '2018-03-13 17:54:51', 0, '2018-03-13 17:54:51', 1),
('022', 'Acuamanala de Miguel Hidalgo', '29', 0, '2018-03-13 17:54:51', 0, '2018-03-13 17:54:51', 1),
('028', 'Teolocholco', '29', 0, '2018-03-13 17:54:51', 0, '2018-03-13 17:54:51', 1),
('048', 'La Magdalena Tlaltelulco', '29', 0, '2018-03-13 17:54:51', 0, '2018-03-13 17:54:51', 1),
('010', 'Chiautempan', '29', 0, '2018-03-13 17:54:51', 0, '2018-03-13 17:54:51', 1),
('042', 'Xicohtzinco', '29', 0, '2018-03-13 17:54:51', 0, '2018-03-13 17:54:51', 1),
('041', 'Papalotla de Xicohténcatl', '29', 0, '2018-03-13 17:54:51', 0, '2018-03-13 17:54:51', 1),
('058', 'Santa Catarina Ayometla', '29', 0, '2018-03-13 17:54:51', 0, '2018-03-13 17:54:51', 1),
('051', 'San Jerónimo Zacualpan', '29', 0, '2018-03-13 17:54:51', 0, '2018-03-13 17:54:51', 1),
('054', 'San Lorenzo Axocomanitla', '29', 0, '2018-03-13 17:54:51', 0, '2018-03-13 17:54:51', 1),
('044', 'Zacatelco', '29', 0, '2018-03-13 17:54:51', 0, '2018-03-13 17:54:51', 1),
('032', 'Tetlatlahuca', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('049', 'San Damián Texóloc', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('057', 'Santa Apolonia Teacalco', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('023', 'Natívitas', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('019', 'Tepetitla de Lardizábal', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('018', 'Contla de Juan Cuamatzi', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('009', 'Cuaxomulco', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('026', 'Santa Cruz Tlaxcala', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('002', 'Apetatitlán de Antonio Carvajal', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('001', 'Amaxac de Guerrero', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('008', 'Cuapiaxtla', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('007', 'El Carmen Tequexquitla', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('016', 'Ixtenco', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('037', 'Ziltlaltépec de Trinidad Sánchez Santos', '29', 0, '2018-03-13 17:54:50', 0, '2018-03-13 17:54:50', 1),
('004', 'Atltzayanca', '29', 0, '2018-03-13 17:54:49', 0, '2018-03-13 17:54:49', 1),
('047', 'Lázaro Cárdenas', '29', 0, '2018-03-13 17:54:49', 0, '2018-03-13 17:54:49', 1),
('046', 'Emiliano Zapata', '29', 0, '2018-03-13 17:54:49', 0, '2018-03-13 17:54:49', 1),
('013', 'Huamantla', '29', 0, '2018-03-13 17:54:49', 0, '2018-03-13 17:54:49', 1),
('030', 'Terrenate', '29', 0, '2018-03-13 17:54:49', 0, '2018-03-13 17:54:49', 1),
('052', 'San José Teacalco', '29', 0, '2018-03-13 17:54:49', 0, '2018-03-13 17:54:49', 1),
('035', 'Tocatlán', '29', 0, '2018-03-13 17:54:49', 0, '2018-03-13 17:54:49', 1),
('038', 'Tzompantepec', '29', 0, '2018-03-13 17:54:49', 0, '2018-03-13 17:54:49', 1),
('039', 'Xaloztoc', '29', 0, '2018-03-13 17:54:49', 0, '2018-03-13 17:54:49', 1),
('043', 'Yauhquemehcan', '29', 0, '2018-03-13 17:54:49', 0, '2018-03-13 17:54:49', 1),
('040', 'Xaltocan', '29', 0, '2018-03-13 17:54:49', 0, '2018-03-13 17:54:49', 1),
('055', 'San Lucas Tecopilco', '29', 0, '2018-03-13 17:54:49', 0, '2018-03-13 17:54:49', 1),
('031', 'Tetla de la Solidaridad', '29', 0, '2018-03-13 17:54:49', 0, '2018-03-13 17:54:49', 1),
('011', 'Muñoz de Domingo Arenas', '29', 0, '2018-03-13 17:54:48', 0, '2018-03-13 17:54:48', 1),
('003', 'Atlangatepec', '29', 0, '2018-03-13 17:54:48', 0, '2018-03-13 17:54:48', 1),
('012', 'Españita', '29', 0, '2018-03-13 17:54:48', 0, '2018-03-13 17:54:48', 1),
('005', 'Apizaco', '29', 0, '2018-03-13 17:54:48', 0, '2018-03-13 17:54:48', 1),
('021', 'Nanacamilpa de Mariano Arista', '29', 0, '2018-03-13 17:54:48', 0, '2018-03-13 17:54:48', 1),
('034', 'Tlaxco', '29', 0, '2018-03-13 17:54:48', 0, '2018-03-13 17:54:48', 1),
('045', 'Benito Juárez', '29', 0, '2018-03-13 17:54:48', 0, '2018-03-13 17:54:48', 1),
('014', 'Hueyotlipan', '29', 0, '2018-03-13 17:54:48', 0, '2018-03-13 17:54:48', 1),
('020', 'Sanctórum de Lázaro Cárdenas', '29', 0, '2018-03-13 17:54:48', 0, '2018-03-13 17:54:48', 1),
('006', 'Calpulalpan', '29', 0, '2018-03-13 17:54:48', 0, '2018-03-13 17:54:48', 1),
('053', 'San Juan Huactzinco', '29', 0, '2018-03-13 17:54:48', 0, '2018-03-13 17:54:48', 1),
('060', 'Santa Isabel Xiloxoxtla', '29', 0, '2018-03-13 17:54:48', 0, '2018-03-13 17:54:48', 1),
('029', 'Tepeyanco', '29', 0, '2018-03-13 17:54:48', 0, '2018-03-13 17:54:48', 1),
('024', 'Panotla', '29', 0, '2018-03-13 17:54:47', 0, '2018-03-13 17:54:47', 1),
('036', 'Totolac', '29', 0, '2018-03-13 17:54:47', 0, '2018-03-13 17:54:47', 1),
('056', 'Santa Ana Nopalucan', '29', 0, '2018-03-13 17:54:47', 0, '2018-03-13 17:54:47', 1),
('004', 'Antiguo Morelos', '28', 0, '2018-03-13 17:54:47', 0, '2018-03-13 17:54:47', 1),
('028', 'Nuevo Morelos', '28', 0, '2018-03-13 17:54:47', 0, '2018-03-13 17:54:47', 1),
('033', 'Tlaxcala', '29', 0, '2018-03-13 17:54:47', 0, '2018-03-13 17:54:47', 1),
('015', 'Ixtacuixtla de Mariano Matamoros', '29', 0, '2018-03-13 17:54:47', 0, '2018-03-13 17:54:47', 1),
('003', 'Altamira', '28', 0, '2018-03-13 17:54:47', 0, '2018-03-13 17:54:47', 1),
('002', 'Aldama', '28', 0, '2018-03-13 17:54:47', 0, '2018-03-13 17:54:47', 1),
('012', 'González', '28', 0, '2018-03-13 17:54:47', 0, '2018-03-13 17:54:47', 1),
('043', 'Xicoténcatl', '28', 0, '2018-03-13 17:54:47', 0, '2018-03-13 17:54:47', 1),
('011', 'Gómez Farías', '28', 0, '2018-03-13 17:54:47', 0, '2018-03-13 17:54:47', 1),
('021', 'El Mante', '28', 0, '2018-03-13 17:54:47', 0, '2018-03-13 17:54:47', 1),
('038', 'Tampico', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('009', 'Ciudad Madero', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('005', 'Burgos', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('023', 'Méndez', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('033', 'Río Bravo', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('032', 'Reynosa', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('007', 'Camargo', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('015', 'Gustavo Díaz Ordaz', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('024', 'Mier', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('014', 'Guerrero', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('025', 'Miguel Alemán', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('027', 'Nuevo Laredo', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('029', 'Ocampo', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('031', 'Palmillas', '28', 0, '2018-03-13 17:54:46', 0, '2018-03-13 17:54:46', 1),
('006', 'Bustamante', '28', 0, '2018-03-13 17:54:45', 0, '2018-03-13 17:54:45', 1),
('026', 'Miquihuana', '28', 0, '2018-03-13 17:54:45', 0, '2018-03-13 17:54:45', 1),
('017', 'Jaumave', '28', 0, '2018-03-13 17:54:45', 0, '2018-03-13 17:54:45', 1),
('039', 'Tula', '28', 0, '2018-03-13 17:54:45', 0, '2018-03-13 17:54:45', 1),
('042', 'Villagrán', '28', 0, '2018-03-13 17:54:45', 0, '2018-03-13 17:54:45', 1),
('020', 'Mainero', '28', 0, '2018-03-13 17:54:45', 0, '2018-03-13 17:54:45', 1),
('016', 'Hidalgo', '28', 0, '2018-03-13 17:54:45', 0, '2018-03-13 17:54:45', 1),
('030', 'Padilla', '28', 0, '2018-03-13 17:54:45', 0, '2018-03-13 17:54:45', 1),
('001', 'Abasolo', '28', 0, '2018-03-13 17:54:45', 0, '2018-03-13 17:54:45', 1),
('034', 'San Carlos', '28', 0, '2018-03-13 17:54:45', 0, '2018-03-13 17:54:45', 1),
('018', 'Jiménez', '28', 0, '2018-03-13 17:54:45', 0, '2018-03-13 17:54:45', 1),
('037', 'Soto la Marina', '28', 0, '2018-03-13 17:54:45', 0, '2018-03-13 17:54:45', 1),
('036', 'San Nicolás', '28', 0, '2018-03-13 17:54:45', 0, '2018-03-13 17:54:45', 1),
('010', 'Cruillas', '28', 0, '2018-03-13 17:54:44', 0, '2018-03-13 17:54:44', 1),
('035', 'San Fernando', '28', 0, '2018-03-13 17:54:44', 0, '2018-03-13 17:54:44', 1),
('040', 'Valle Hermoso', '28', 0, '2018-03-13 17:54:44', 0, '2018-03-13 17:54:44', 1),
('022', 'Matamoros', '28', 0, '2018-03-13 17:54:44', 0, '2018-03-13 17:54:44', 1),
('008', 'Casas', '28', 0, '2018-03-13 17:54:44', 0, '2018-03-13 17:54:44', 1),
('013', 'Güémez', '28', 0, '2018-03-13 17:54:44', 0, '2018-03-13 17:54:44', 1),
('019', 'Llera', '28', 0, '2018-03-13 17:54:44', 0, '2018-03-13 17:54:44', 1),
('041', 'Victoria', '28', 0, '2018-03-13 17:54:44', 0, '2018-03-13 17:54:44', 1),
('007', 'Emiliano Zapata', '27', 0, '2018-03-13 17:54:44', 0, '2018-03-13 17:54:44', 1),
('001', 'Balancán', '27', 0, '2018-03-13 17:54:44', 0, '2018-03-13 17:54:44', 1),
('017', 'Tenosique', '27', 0, '2018-03-13 17:54:44', 0, '2018-03-13 17:54:44', 1),
('015', 'Tacotalpa', '27', 0, '2018-03-13 17:54:44', 0, '2018-03-13 17:54:44', 1),
('009', 'Jalapa', '27', 0, '2018-03-13 17:54:44', 0, '2018-03-13 17:54:44', 1),
('016', 'Teapa', '27', 0, '2018-03-13 17:54:43', 0, '2018-03-13 17:54:43', 1),
('011', 'Jonuta', '27', 0, '2018-03-13 17:54:43', 0, '2018-03-13 17:54:43', 1),
('003', 'Centla', '27', 0, '2018-03-13 17:54:43', 0, '2018-03-13 17:54:43', 1),
('012', 'Macuspana', '27', 0, '2018-03-13 17:54:43', 0, '2018-03-13 17:54:43', 1),
('006', 'Cunduacán', '27', 0, '2018-03-13 17:54:43', 0, '2018-03-13 17:54:43', 1),
('014', 'Paraíso', '27', 0, '2018-03-13 17:54:43', 0, '2018-03-13 17:54:43', 1),
('002', 'Cárdenas', '27', 0, '2018-03-13 17:54:43', 0, '2018-03-13 17:54:43', 1),
('008', 'Huimanguillo', '27', 0, '2018-03-13 17:54:43', 0, '2018-03-13 17:54:43', 1),
('005', 'Comalcalco', '27', 0, '2018-03-13 17:54:43', 0, '2018-03-13 17:54:43', 1),
('013', 'Nacajuca', '27', 0, '2018-03-13 17:54:43', 0, '2018-03-13 17:54:43', 1),
('010', 'Jalpa de Méndez', '27', 0, '2018-03-13 17:54:43', 0, '2018-03-13 17:54:43', 1),
('004', 'Centro', '27', 0, '2018-03-13 17:54:43', 0, '2018-03-13 17:54:43', 1),
('069', 'Yécora', '26', 0, '2018-03-13 17:54:43', 0, '2018-03-13 17:54:43', 1),
('003', 'Alamos', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('044', 'Onavas', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('049', 'Quiriego', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('051', 'Rosario', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('005', 'Arivechi', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('009', 'Bacanora', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('061', 'Soyopa', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('054', 'San Javier', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('052', 'Sahuaripa', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('062', 'Suaqui Grande', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('037', 'Mazatán', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('021', 'La Colorada', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('072', 'San Ignacio Río Muerto', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('029', 'Guaymas', '26', 0, '2018-03-13 17:54:42', 0, '2018-03-13 17:54:42', 1),
('025', 'Empalme', '26', 0, '2018-03-13 17:54:41', 0, '2018-03-13 17:54:41', 1),
('071', 'Benito Juárez', '26', 0, '2018-03-13 17:54:41', 0, '2018-03-13 17:54:41', 1),
('026', 'Etchojoa', '26', 0, '2018-03-13 17:54:41', 0, '2018-03-13 17:54:41', 1),
('012', 'Bácum', '26', 0, '2018-03-13 17:54:41', 0, '2018-03-13 17:54:41', 1),
('033', 'Huatabampo', '26', 0, '2018-03-13 17:54:41', 0, '2018-03-13 17:54:41', 1),
('042', 'Navojoa', '26', 0, '2018-03-13 17:54:41', 0, '2018-03-13 17:54:41', 1),
('018', 'Cajeme', '26', 0, '2018-03-13 17:54:41', 0, '2018-03-13 17:54:41', 1),
('050', 'Rayón', '26', 0, '2018-03-13 17:54:41', 0, '2018-03-13 17:54:41', 1),
('053', 'San Felipe de Jesús', '26', 0, '2018-03-13 17:54:41', 0, '2018-03-13 17:54:41', 1),
('014', 'Baviácora', '26', 0, '2018-03-13 17:54:41', 0, '2018-03-13 17:54:41', 1),
('001', 'Aconchi', '26', 0, '2018-03-13 17:54:41', 0, '2018-03-13 17:54:41', 1),
('066', 'Ures', '26', 0, '2018-03-13 17:54:41', 0, '2018-03-13 17:54:41', 1),
('013', 'Banámichi', '26', 0, '2018-03-13 17:54:41', 0, '2018-03-13 17:54:41', 1),
('034', 'Huépac', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('045', 'Opodepe', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('068', 'Villa Pesqueira', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('063', 'Tepache', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('024', 'Divisaderos', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('057', 'San Pedro de la Cueva', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('011', 'Bacoachi', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('022', 'Cucurpe', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('006', 'Arizpe', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('019', 'Cananea', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('058', 'Santa Ana', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('067', 'Villa Hidalgo', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('038', 'Moctezuma', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('032', 'Huásabas', '26', 0, '2018-03-13 17:54:40', 0, '2018-03-13 17:54:40', 1),
('023', 'Cumpas', '26', 0, '2018-03-13 17:54:39', 0, '2018-03-13 17:54:39', 1),
('008', 'Bacadéhuachi', '26', 0, '2018-03-13 17:54:39', 0, '2018-03-13 17:54:39', 1),
('028', 'Granados', '26', 0, '2018-03-13 17:54:39', 0, '2018-03-13 17:54:39', 1),
('040', 'Nácori Chico', '26', 0, '2018-03-13 17:54:39', 0, '2018-03-13 17:54:39', 1),
('031', 'Huachinera', '26', 0, '2018-03-13 17:54:39', 0, '2018-03-13 17:54:39', 1),
('010', 'Bacerac', '26', 0, '2018-03-13 17:54:39', 0, '2018-03-13 17:54:39', 1),
('015', 'Bavispe', '26', 0, '2018-03-13 17:54:39', 0, '2018-03-13 17:54:39', 1),
('041', 'Nacozari de García', '26', 0, '2018-03-13 17:54:39', 0, '2018-03-13 17:54:39', 1),
('027', 'Fronteras', '26', 0, '2018-03-13 17:54:39', 0, '2018-03-13 17:54:39', 1),
('002', 'Agua Prieta', '26', 0, '2018-03-13 17:54:39', 0, '2018-03-13 17:54:39', 1),
('039', 'Naco', '26', 0, '2018-03-13 17:54:39', 0, '2018-03-13 17:54:39', 1),
('036', 'Magdalena', '26', 0, '2018-03-13 17:54:39', 0, '2018-03-13 17:54:39', 1),
('059', 'Santa Cruz', '26', 0, '2018-03-13 17:54:39', 0, '2018-03-13 17:54:39', 1),
('035', 'Imuris', '26', 0, '2018-03-13 17:54:38', 0, '2018-03-13 17:54:38', 1),
('043', 'Nogales', '26', 0, '2018-03-13 17:54:38', 0, '2018-03-13 17:54:38', 1),
('047', 'Pitiquito', '26', 0, '2018-03-13 17:54:38', 0, '2018-03-13 17:54:38', 1),
('064', 'Trincheras', '26', 0, '2018-03-13 17:54:38', 0, '2018-03-13 17:54:38', 1),
('016', 'Benjamín Hill', '26', 0, '2018-03-13 17:54:38', 0, '2018-03-13 17:54:38', 1),
('060', 'Sáric', '26', 0, '2018-03-13 17:54:38', 0, '2018-03-13 17:54:38', 1),
('046', 'Oquitoa', '26', 0, '2018-03-13 17:54:38', 0, '2018-03-13 17:54:38', 1),
('007', 'Atil', '26', 0, '2018-03-13 17:54:38', 0, '2018-03-13 17:54:38', 1),
('065', 'Tubutama', '26', 0, '2018-03-13 17:54:38', 0, '2018-03-13 17:54:38', 1),
('004', 'Altar', '26', 0, '2018-03-13 17:54:38', 0, '2018-03-13 17:54:38', 1),
('017', 'Caborca', '26', 0, '2018-03-13 17:54:38', 0, '2018-03-13 17:54:38', 1),
('070', 'General Plutarco Elías Calles', '26', 0, '2018-03-13 17:54:38', 0, '2018-03-13 17:54:38', 1),
('048', 'Puerto Peñasco', '26', 0, '2018-03-13 17:54:37', 0, '2018-03-13 17:54:37', 1),
('055', 'San Luis Río Colorado', '26', 0, '2018-03-13 17:54:37', 0, '2018-03-13 17:54:37', 1),
('020', 'Carbó', '26', 0, '2018-03-13 17:54:37', 0, '2018-03-13 17:54:37', 1),
('056', 'San Miguel de Horcasitas', '26', 0, '2018-03-13 17:54:37', 0, '2018-03-13 17:54:37', 1),
('030', 'Hermosillo', '26', 0, '2018-03-13 17:54:37', 0, '2018-03-13 17:54:37', 1),
('016', 'San Ignacio', '25', 0, '2018-03-13 17:54:37', 0, '2018-03-13 17:54:37', 1),
('014', 'Rosario', '25', 0, '2018-03-13 17:54:37', 0, '2018-03-13 17:54:37', 1),
('010', 'El Fuerte', '25', 0, '2018-03-13 17:54:37', 0, '2018-03-13 17:54:37', 1),
('017', 'Sinaloa', '25', 0, '2018-03-13 17:54:37', 0, '2018-03-13 17:54:37', 1),
('012', 'Mazatlán', '25', 0, '2018-03-13 17:54:37', 0, '2018-03-13 17:54:37', 1),
('009', 'Escuinapa', '25', 0, '2018-03-13 17:54:37', 0, '2018-03-13 17:54:37', 1),
('008', 'Elota', '25', 0, '2018-03-13 17:54:37', 0, '2018-03-13 17:54:37', 1),
('004', 'Concordia', '25', 0, '2018-03-13 17:54:37', 0, '2018-03-13 17:54:37', 1),
('007', 'Choix', '25', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('002', 'Angostura', '25', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('015', 'Salvador Alvarado', '25', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('001', 'Ahome', '25', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('011', 'Guasave', '25', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('013', 'Mocorito', '25', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('005', 'Cosalá', '25', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('003', 'Badiraguato', '25', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('018', 'Navolato', '25', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('006', 'Culiacán', '25', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('057', 'Matlapa', '24', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('037', 'Tamazunchale', '24', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('029', 'San Martín Chalchicuautla', '24', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('038', 'Tampacán', '24', 0, '2018-03-13 17:54:36', 0, '2018-03-13 17:54:36', 1),
('053', 'Axtla de Terrazas', '24', 0, '2018-03-13 17:54:35', 0, '2018-03-13 17:54:35', 1),
('054', 'Xilitla', '24', 0, '2018-03-13 17:54:35', 0, '2018-03-13 17:54:35', 1),
('018', 'Huehuetlán', '24', 0, '2018-03-13 17:54:35', 0, '2018-03-13 17:54:35', 1),
('014', 'Coxcatlán', '24', 0, '2018-03-13 17:54:35', 0, '2018-03-13 17:54:35', 1),
('039', 'Tampamolón Corona', '24', 0, '2018-03-13 17:54:35', 0, '2018-03-13 17:54:35', 1),
('042', 'Tanquián de Escobedo', '24', 0, '2018-03-13 17:54:35', 0, '2018-03-13 17:54:35', 1),
('026', 'San Antonio', '24', 0, '2018-03-13 17:54:35', 0, '2018-03-13 17:54:35', 1),
('034', 'San Vicente Tancuayalab', '24', 0, '2018-03-13 17:54:35', 0, '2018-03-13 17:54:35', 1),
('041', 'Tanlajás', '24', 0, '2018-03-13 17:54:35', 0, '2018-03-13 17:54:35', 1),
('012', 'Tancanhuitz', '24', 0, '2018-03-13 17:54:35', 0, '2018-03-13 17:54:35', 1),
('031', 'Santa Catarina', '24', 0, '2018-03-13 17:54:35', 0, '2018-03-13 17:54:35', 1);
INSERT INTO `ciudad` (`Clave_Ciudad`, `Nombre`, `Clave_Estado`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Estatus`) VALUES
('019', 'Lagunillas', '24', 0, '2018-03-13 17:54:35', 0, '2018-03-13 17:54:35', 1),
('003', 'Aquismón', '24', 0, '2018-03-13 17:54:35', 0, '2018-03-13 17:54:35', 1),
('023', 'Rayón', '24', 0, '2018-03-13 17:54:34', 0, '2018-03-13 17:54:34', 1),
('036', 'Tamasopo', '24', 0, '2018-03-13 17:54:34', 0, '2018-03-13 17:54:34', 1),
('027', 'San Ciro de Acosta', '24', 0, '2018-03-13 17:54:34', 0, '2018-03-13 17:54:34', 1),
('011', 'Ciudad Fernández', '24', 0, '2018-03-13 17:54:34', 0, '2018-03-13 17:54:34', 1),
('024', 'Rioverde', '24', 0, '2018-03-13 17:54:34', 0, '2018-03-13 17:54:34', 1),
('043', 'Tierra Nueva', '24', 0, '2018-03-13 17:54:34', 0, '2018-03-13 17:54:34', 1),
('032', 'Santa María del Río', '24', 0, '2018-03-13 17:54:34', 0, '2018-03-13 17:54:34', 1),
('055', 'Zaragoza', '24', 0, '2018-03-13 17:54:34', 0, '2018-03-13 17:54:34', 1),
('050', 'Villa de Reyes', '24', 0, '2018-03-13 17:54:34', 0, '2018-03-13 17:54:34', 1),
('030', 'San Nicolás Tolentino', '24', 0, '2018-03-13 17:54:34', 0, '2018-03-13 17:54:34', 1),
('052', 'Villa Juárez', '24', 0, '2018-03-13 17:54:34', 0, '2018-03-13 17:54:34', 1),
('008', 'Cerritos', '24', 0, '2018-03-13 17:54:34', 0, '2018-03-13 17:54:34', 1),
('005', 'Cárdenas', '24', 0, '2018-03-13 17:54:34', 0, '2018-03-13 17:54:34', 1),
('010', 'Ciudad del Maíz', '24', 0, '2018-03-13 17:54:33', 0, '2018-03-13 17:54:33', 1),
('002', 'Alaquines', '24', 0, '2018-03-13 17:54:33', 0, '2018-03-13 17:54:33', 1),
('058', 'El Naranjo', '24', 0, '2018-03-13 17:54:33', 0, '2018-03-13 17:54:33', 1),
('040', 'Tamuín', '24', 0, '2018-03-13 17:54:33', 0, '2018-03-13 17:54:33', 1),
('016', 'Ebano', '24', 0, '2018-03-13 17:54:33', 0, '2018-03-13 17:54:33', 1),
('013', 'Ciudad Valles', '24', 0, '2018-03-13 17:54:33', 0, '2018-03-13 17:54:33', 1),
('004', 'Armadillo de los Infante', '24', 0, '2018-03-13 17:54:33', 0, '2018-03-13 17:54:33', 1),
('051', 'Villa Hidalgo', '24', 0, '2018-03-13 17:54:33', 0, '2018-03-13 17:54:33', 1),
('056', 'Villa de Arista', '24', 0, '2018-03-13 17:54:33', 0, '2018-03-13 17:54:33', 1),
('045', 'Venado', '24', 0, '2018-03-13 17:54:33', 0, '2018-03-13 17:54:33', 1),
('022', 'Moctezuma', '24', 0, '2018-03-13 17:54:33', 0, '2018-03-13 17:54:33', 1),
('017', 'Guadalcázar', '24', 0, '2018-03-13 17:54:33', 0, '2018-03-13 17:54:33', 1),
('047', 'Villa de Guadalupe', '24', 0, '2018-03-13 17:54:32', 0, '2018-03-13 17:54:32', 1),
('048', 'Villa de la Paz', '24', 0, '2018-03-13 17:54:32', 0, '2018-03-13 17:54:32', 1),
('020', 'Matehuala', '24', 0, '2018-03-13 17:54:32', 0, '2018-03-13 17:54:32', 1),
('049', 'Villa de Ramos', '24', 0, '2018-03-13 17:54:32', 0, '2018-03-13 17:54:32', 1),
('033', 'Santo Domingo', '24', 0, '2018-03-13 17:54:32', 0, '2018-03-13 17:54:32', 1),
('025', 'Salinas', '24', 0, '2018-03-13 17:54:32', 0, '2018-03-13 17:54:32', 1),
('015', 'Charcas', '24', 0, '2018-03-13 17:54:32', 0, '2018-03-13 17:54:32', 1),
('006', 'Catorce', '24', 0, '2018-03-13 17:54:32', 0, '2018-03-13 17:54:32', 1),
('007', 'Cedral', '24', 0, '2018-03-13 17:54:32', 0, '2018-03-13 17:54:32', 1),
('044', 'Vanegas', '24', 0, '2018-03-13 17:54:32', 0, '2018-03-13 17:54:32', 1),
('046', 'Villa de Arriaga', '24', 0, '2018-03-13 17:54:32', 0, '2018-03-13 17:54:32', 1),
('021', 'Mexquitic de Carmona', '24', 0, '2018-03-13 17:54:32', 0, '2018-03-13 17:54:32', 1),
('001', 'Ahualulco', '24', 0, '2018-03-13 17:54:32', 0, '2018-03-13 17:54:32', 1),
('009', 'Cerro de San Pedro', '24', 0, '2018-03-13 17:54:31', 0, '2018-03-13 17:54:31', 1),
('035', 'Soledad de Graciano Sánchez', '24', 0, '2018-03-13 17:54:31', 0, '2018-03-13 17:54:31', 1),
('028', 'San Luis Potosí', '24', 0, '2018-03-13 17:54:31', 0, '2018-03-13 17:54:31', 1),
('010', 'Bacalar', '23', 0, '2018-03-13 17:54:31', 0, '2018-03-13 17:54:31', 1),
('006', 'José María Morelos', '23', 0, '2018-03-13 17:54:31', 0, '2018-03-13 17:54:31', 1),
('009', 'Tulum', '23', 0, '2018-03-13 17:54:31', 0, '2018-03-13 17:54:31', 1),
('008', 'Solidaridad', '23', 0, '2018-03-13 17:54:31', 0, '2018-03-13 17:54:31', 1),
('001', 'Cozumel', '23', 0, '2018-03-13 17:54:31', 0, '2018-03-13 17:54:31', 1),
('011', 'Puerto Morelos', '23', 0, '2018-03-13 17:54:31', 0, '2018-03-13 17:54:31', 1),
('005', 'Benito Juárez', '23', 0, '2018-03-13 17:54:31', 0, '2018-03-13 17:54:31', 1),
('003', 'Isla Mujeres', '23', 0, '2018-03-13 17:54:31', 0, '2018-03-13 17:54:31', 1),
('007', 'Lázaro Cárdenas', '23', 0, '2018-03-13 17:54:31', 0, '2018-03-13 17:54:31', 1),
('002', 'Felipe Carrillo Puerto', '23', 0, '2018-03-13 17:54:31', 0, '2018-03-13 17:54:31', 1),
('004', 'Othón P. Blanco', '23', 0, '2018-03-13 17:54:30', 0, '2018-03-13 17:54:30', 1),
('008', 'Huimilpan', '22', 0, '2018-03-13 17:54:30', 0, '2018-03-13 17:54:30', 1),
('006', 'Corregidora', '22', 0, '2018-03-13 17:54:30', 0, '2018-03-13 17:54:30', 1),
('001', 'Amealco de Bonfil', '22', 0, '2018-03-13 17:54:30', 0, '2018-03-13 17:54:30', 1),
('016', 'San Juan del Río', '22', 0, '2018-03-13 17:54:30', 0, '2018-03-13 17:54:30', 1),
('017', 'Tequisquiapan', '22', 0, '2018-03-13 17:54:30', 0, '2018-03-13 17:54:30', 1),
('012', 'Pedro Escobedo', '22', 0, '2018-03-13 17:54:30', 0, '2018-03-13 17:54:30', 1),
('007', 'Ezequiel Montes', '22', 0, '2018-03-13 17:54:30', 0, '2018-03-13 17:54:30', 1),
('018', 'Tolimán', '22', 0, '2018-03-13 17:54:30', 0, '2018-03-13 17:54:30', 1),
('015', 'San Joaquín', '22', 0, '2018-03-13 17:54:30', 0, '2018-03-13 17:54:30', 1),
('004', 'Cadereyta de Montes', '22', 0, '2018-03-13 17:54:30', 0, '2018-03-13 17:54:30', 1),
('013', 'Peñamiller', '22', 0, '2018-03-13 17:54:30', 0, '2018-03-13 17:54:30', 1),
('003', 'Arroyo Seco', '22', 0, '2018-03-13 17:54:30', 0, '2018-03-13 17:54:30', 1),
('010', 'Landa de Matamoros', '22', 0, '2018-03-13 17:54:29', 0, '2018-03-13 17:54:29', 1),
('009', 'Jalpan de Serra', '22', 0, '2018-03-13 17:54:29', 0, '2018-03-13 17:54:29', 1),
('002', 'Pinal de Amoles', '22', 0, '2018-03-13 17:54:29', 0, '2018-03-13 17:54:29', 1),
('005', 'Colón', '22', 0, '2018-03-13 17:54:29', 0, '2018-03-13 17:54:29', 1),
('011', 'El Marqués', '22', 0, '2018-03-13 17:54:29', 0, '2018-03-13 17:54:29', 1),
('014', 'Querétaro', '22', 0, '2018-03-13 17:54:29', 0, '2018-03-13 17:54:29', 1),
('036', 'Coyomeapan', '21', 0, '2018-03-13 17:54:29', 0, '2018-03-13 17:54:29', 1),
('035', 'Coxcatlán', '21', 0, '2018-03-13 17:54:29', 0, '2018-03-13 17:54:29', 1),
('129', 'San José Miahuatlán', '21', 0, '2018-03-13 17:54:29', 0, '2018-03-13 17:54:29', 1),
('214', 'Zinacatepec', '21', 0, '2018-03-13 17:54:29', 0, '2018-03-13 17:54:29', 1),
('013', 'Altepexi', '21', 0, '2018-03-13 17:54:29', 0, '2018-03-13 17:54:29', 1),
('145', 'San Sebastián Tlacotepec', '21', 0, '2018-03-13 17:54:29', 0, '2018-03-13 17:54:29', 1),
('217', 'Zoquitlán', '21', 0, '2018-03-13 17:54:29', 0, '2018-03-13 17:54:29', 1),
('061', 'Eloxochitlán', '21', 0, '2018-03-13 17:54:28', 0, '2018-03-13 17:54:28', 1),
('010', 'Ajalpan', '21', 0, '2018-03-13 17:54:28', 0, '2018-03-13 17:54:28', 1),
('195', 'Vicente Guerrero', '21', 0, '2018-03-13 17:54:28', 0, '2018-03-13 17:54:28', 1),
('027', 'Caltepec', '21', 0, '2018-03-13 17:54:28', 0, '2018-03-13 17:54:28', 1),
('124', 'San Gabriel Chilac', '21', 0, '2018-03-13 17:54:28', 0, '2018-03-13 17:54:28', 1),
('209', 'Zapotitlán', '21', 0, '2018-03-13 17:54:28', 0, '2018-03-13 17:54:28', 1),
('120', 'San Antonio Cañada', '21', 0, '2018-03-13 17:54:28', 0, '2018-03-13 17:54:28', 1),
('018', 'Atexcal', '21', 0, '2018-03-13 17:54:28', 0, '2018-03-13 17:54:28', 1),
('103', 'Nicolás Bravo', '21', 0, '2018-03-13 17:54:28', 0, '2018-03-13 17:54:28', 1),
('149', 'Santiago Miahuatlán', '21', 0, '2018-03-13 17:54:28', 0, '2018-03-13 17:54:28', 1),
('046', 'Chapulco', '21', 0, '2018-03-13 17:54:28', 0, '2018-03-13 17:54:28', 1),
('161', 'Tepanco de López', '21', 0, '2018-03-13 17:54:28', 0, '2018-03-13 17:54:28', 1),
('156', 'Tehuacán', '21', 0, '2018-03-13 17:54:28', 0, '2018-03-13 17:54:28', 1),
('092', 'Juan N. Méndez', '21', 0, '2018-03-13 17:54:27', 0, '2018-03-13 17:54:27', 1),
('177', 'Tlacotepec de Benito Juárez', '21', 0, '2018-03-13 17:54:27', 0, '2018-03-13 17:54:27', 1),
('205', 'Yehualtepec', '21', 0, '2018-03-13 17:54:27', 0, '2018-03-13 17:54:27', 1),
('203', 'Xochitlán Todos Santos', '21', 0, '2018-03-13 17:54:27', 0, '2018-03-13 17:54:27', 1),
('098', 'Molcaxac', '21', 0, '2018-03-13 17:54:27', 0, '2018-03-13 17:54:27', 1),
('079', 'Huitziltepec', '21', 0, '2018-03-13 17:54:27', 0, '2018-03-13 17:54:27', 1),
('171', 'Tepeyahualco de Cuauhtémoc', '21', 0, '2018-03-13 17:54:27', 0, '2018-03-13 17:54:27', 1),
('020', 'Atoyatempan', '21', 0, '2018-03-13 17:54:27', 0, '2018-03-13 17:54:27', 1),
('189', 'Tochtepec', '21', 0, '2018-03-13 17:54:27', 0, '2018-03-13 17:54:27', 1),
('182', 'Tlanepantla', '21', 0, '2018-03-13 17:54:27', 0, '2018-03-13 17:54:27', 1),
('099', 'Cañada Morelos', '21', 0, '2018-03-13 17:54:27', 0, '2018-03-13 17:54:27', 1),
('110', 'Palmar de Bravo', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('045', 'Chalchicomula de Sesma', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('023', 'Atzitzintla', '21', 0, '2018-03-13 17:54:27', 0, '2018-03-13 17:54:27', 1),
('063', 'Esperanza', '21', 0, '2018-03-13 17:54:27', 0, '2018-03-13 17:54:27', 1),
('154', 'Tecamachalco', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('115', 'Quecholac', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('118', 'Los Reyes de Juárez', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('038', 'Cuapiaxtla de Madero', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('144', 'San Salvador Huixcolotla', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('070', 'Huatlatlauca', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('131', 'San Juan Atzompa', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('095', 'La Magdalena Tlatlauquitepec', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('150', 'Huehuetlán el Grande', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('193', 'Tzicatlacoyan', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('151', 'Santo Tomás Hueyotlipan', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('097', 'Mixtla', '21', 0, '2018-03-13 17:54:26', 0, '2018-03-13 17:54:26', 1),
('153', 'Tecali de Herrera', '21', 0, '2018-03-13 17:54:25', 0, '2018-03-13 17:54:25', 1),
('040', 'Cuautinchán', '21', 0, '2018-03-13 17:54:25', 0, '2018-03-13 17:54:25', 1),
('164', 'Tepeaca', '21', 0, '2018-03-13 17:54:25', 0, '2018-03-13 17:54:25', 1),
('012', 'Aljojuca', '21', 0, '2018-03-13 17:54:25', 0, '2018-03-13 17:54:25', 1),
('130', 'San Juan Atenco', '21', 0, '2018-03-13 17:54:25', 0, '2018-03-13 17:54:25', 1),
('152', 'Soltepec', '21', 0, '2018-03-13 17:54:25', 0, '2018-03-13 17:54:25', 1),
('004', 'Acatzingo', '21', 0, '2018-03-13 17:54:25', 0, '2018-03-13 17:54:25', 1),
('142', 'San Salvador el Seco', '21', 0, '2018-03-13 17:54:25', 0, '2018-03-13 17:54:25', 1),
('065', 'General Felipe Ángeles', '21', 0, '2018-03-13 17:54:25', 0, '2018-03-13 17:54:25', 1),
('096', 'Mazapiltepec de Juárez', '21', 0, '2018-03-13 17:54:25', 0, '2018-03-13 17:54:25', 1),
('104', 'Nopalucan', '21', 0, '2018-03-13 17:54:25', 0, '2018-03-13 17:54:25', 1),
('001', 'Acajete', '21', 0, '2018-03-13 17:54:25', 0, '2018-03-13 17:54:25', 1),
('163', 'Tepatlaxco de Hidalgo', '21', 0, '2018-03-13 17:54:25', 0, '2018-03-13 17:54:25', 1),
('050', 'Chichiquila', '21', 0, '2018-03-13 17:54:24', 0, '2018-03-13 17:54:24', 1),
('116', 'Quimixtlán', '21', 0, '2018-03-13 17:54:24', 0, '2018-03-13 17:54:24', 1),
('058', 'Chilchotla', '21', 0, '2018-03-13 17:54:24', 0, '2018-03-13 17:54:24', 1),
('093', 'Lafragua', '21', 0, '2018-03-13 17:54:24', 0, '2018-03-13 17:54:24', 1),
('179', 'Tlachichuca', '21', 0, '2018-03-13 17:54:24', 0, '2018-03-13 17:54:24', 1),
('067', 'Guadalupe Victoria', '21', 0, '2018-03-13 17:54:24', 0, '2018-03-13 17:54:24', 1),
('137', 'San Nicolás Buenos Aires', '21', 0, '2018-03-13 17:54:24', 0, '2018-03-13 17:54:24', 1),
('108', 'Oriental', '21', 0, '2018-03-13 17:54:24', 0, '2018-03-13 17:54:24', 1),
('128', 'San José Chiapa', '21', 0, '2018-03-13 17:54:24', 0, '2018-03-13 17:54:24', 1),
('117', 'Rafael Lara Grajales', '21', 0, '2018-03-13 17:54:24', 0, '2018-03-13 17:54:24', 1),
('055', 'Chila', '21', 0, '2018-03-13 17:54:24', 0, '2018-03-13 17:54:24', 1),
('135', 'San Miguel Ixitlán', '21', 0, '2018-03-13 17:54:24', 0, '2018-03-13 17:54:24', 1),
('112', 'Petlalcingo', '21', 0, '2018-03-13 17:54:24', 0, '2018-03-13 17:54:24', 1),
('141', 'San Pedro Yeloixtlahuaca', '21', 0, '2018-03-13 17:54:23', 0, '2018-03-13 17:54:23', 1),
('127', 'San Jerónimo Xayacatlán', '21', 0, '2018-03-13 17:54:23', 0, '2018-03-13 17:54:23', 1),
('003', 'Acatlán', '21', 0, '2018-03-13 17:54:23', 0, '2018-03-13 17:54:23', 1),
('190', 'Totoltepec de Guerrero', '21', 0, '2018-03-13 17:54:23', 0, '2018-03-13 17:54:23', 1),
('196', 'Xayacatlán de Bravo', '21', 0, '2018-03-13 17:54:23', 0, '2018-03-13 17:54:23', 1),
('037', 'Coyotepec', '21', 0, '2018-03-13 17:54:23', 0, '2018-03-13 17:54:23', 1),
('082', 'Ixcaquixtla', '21', 0, '2018-03-13 17:54:23', 0, '2018-03-13 17:54:23', 1),
('066', 'Guadalupe', '21', 0, '2018-03-13 17:54:23', 0, '2018-03-13 17:54:23', 1),
('113', 'Piaxtla', '21', 0, '2018-03-13 17:54:23', 0, '2018-03-13 17:54:23', 1),
('155', 'Tecomatlán', '21', 0, '2018-03-13 17:54:23', 0, '2018-03-13 17:54:23', 1),
('139', 'San Pablo Anicano', '21', 0, '2018-03-13 17:54:23', 0, '2018-03-13 17:54:23', 1),
('009', 'Ahuehuetitla', '21', 0, '2018-03-13 17:54:23', 0, '2018-03-13 17:54:23', 1),
('059', 'Chinantla', '21', 0, '2018-03-13 17:54:23', 0, '2018-03-13 17:54:23', 1),
('024', 'Axutla', '21', 0, '2018-03-13 17:54:22', 0, '2018-03-13 17:54:22', 1),
('147', 'Santa Inés Ahuatempan', '21', 0, '2018-03-13 17:54:22', 0, '2018-03-13 17:54:22', 1),
('042', 'Cuayuca de Andrade', '21', 0, '2018-03-13 17:54:22', 0, '2018-03-13 17:54:22', 1),
('157', 'Tehuitzingo', '21', 0, '2018-03-13 17:54:22', 0, '2018-03-13 17:54:22', 1),
('191', 'Tulcingo', '21', 0, '2018-03-13 17:54:22', 0, '2018-03-13 17:54:22', 1),
('011', 'Albino Zertuche', '21', 0, '2018-03-13 17:54:22', 0, '2018-03-13 17:54:22', 1),
('081', 'Ixcamilpa de Guerrero', '21', 0, '2018-03-13 17:54:22', 0, '2018-03-13 17:54:22', 1),
('056', 'Chila de la Sal', '21', 0, '2018-03-13 17:54:22', 0, '2018-03-13 17:54:22', 1),
('198', 'Xicotlán', '21', 0, '2018-03-13 17:54:22', 0, '2018-03-13 17:54:22', 1),
('032', 'Cohetzala', '21', 0, '2018-03-13 17:54:22', 0, '2018-03-13 17:54:22', 1),
('047', 'Chiautla', '21', 0, '2018-03-13 17:54:22', 0, '2018-03-13 17:54:22', 1),
('073', 'Huehuetlán el Chico', '21', 0, '2018-03-13 17:54:22', 0, '2018-03-13 17:54:22', 1),
('087', 'Jolalpan', '21', 0, '2018-03-13 17:54:22', 0, '2018-03-13 17:54:22', 1),
('160', 'Teotlalco', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('169', 'Tepexi de Rodríguez', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('206', 'Zacapala', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('052', 'Chigmecatitlán', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('146', 'Santa Catarina Tlaltempan', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('031', 'Coatzingo', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('007', 'Ahuatlán', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('062', 'Epatlán', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('201', 'Xochiltepec', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('133', 'San Martín Totoltepec', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('159', 'Teopantlán', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('021', 'Atzala', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('051', 'Chietla', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('176', 'Tilapa', '21', 0, '2018-03-13 17:54:21', 0, '2018-03-13 17:54:21', 1),
('168', 'Tepexco', '21', 0, '2018-03-13 17:54:20', 0, '2018-03-13 17:54:20', 1),
('185', 'Tlapanalá', '21', 0, '2018-03-13 17:54:20', 0, '2018-03-13 17:54:20', 1),
('165', 'Tepemaxalco', '21', 0, '2018-03-13 17:54:20', 0, '2018-03-13 17:54:20', 1),
('033', 'Cohuecan', '21', 0, '2018-03-13 17:54:20', 0, '2018-03-13 17:54:20', 1),
('005', 'Acteopan', '21', 0, '2018-03-13 17:54:20', 0, '2018-03-13 17:54:20', 1),
('022', 'Atzitzihuacán', '21', 0, '2018-03-13 17:54:20', 0, '2018-03-13 17:54:20', 1),
('085', 'Izúcar de Matamoros', '21', 0, '2018-03-13 17:54:20', 0, '2018-03-13 17:54:20', 1),
('166', 'Tepeojuma', '21', 0, '2018-03-13 17:54:20', 0, '2018-03-13 17:54:20', 1),
('121', 'San Diego la Mesa Tochimiltzingo', '21', 0, '2018-03-13 17:54:20', 0, '2018-03-13 17:54:20', 1),
('069', 'Huaquechula', '21', 0, '2018-03-13 17:54:20', 0, '2018-03-13 17:54:20', 1),
('148', 'Santa Isabel Cholula', '21', 0, '2018-03-13 17:54:20', 0, '2018-03-13 17:54:20', 1),
('175', 'Tianguismanalco', '21', 0, '2018-03-13 17:54:20', 0, '2018-03-13 17:54:20', 1),
('188', 'Tochimilco', '21', 0, '2018-03-13 17:54:20', 0, '2018-03-13 17:54:20', 1),
('125', 'San Gregorio Atzompa', '21', 0, '2018-03-13 17:54:19', 0, '2018-03-13 17:54:19', 1),
('126', 'San Jerónimo Tecuanipan', '21', 0, '2018-03-13 17:54:19', 0, '2018-03-13 17:54:19', 1),
('102', 'Nealtican', '21', 0, '2018-03-13 17:54:19', 0, '2018-03-13 17:54:19', 1),
('019', 'Atlixco', '21', 0, '2018-03-13 17:54:19', 0, '2018-03-13 17:54:19', 1),
('138', 'San Nicolás de los Ranchos', '21', 0, '2018-03-13 17:54:19', 0, '2018-03-13 17:54:19', 1),
('026', 'Calpan', '21', 0, '2018-03-13 17:54:19', 0, '2018-03-13 17:54:19', 1),
('060', 'Domingo Arenas', '21', 0, '2018-03-13 17:54:19', 0, '2018-03-13 17:54:19', 1),
('074', 'Huejotzingo', '21', 0, '2018-03-13 17:54:19', 0, '2018-03-13 17:54:19', 1),
('048', 'Chiautzingo', '21', 0, '2018-03-13 17:54:19', 0, '2018-03-13 17:54:19', 1),
('180', 'Tlahuapan', '21', 0, '2018-03-13 17:54:19', 0, '2018-03-13 17:54:19', 1),
('134', 'San Matías Tlalancaleca', '21', 0, '2018-03-13 17:54:19', 0, '2018-03-13 17:54:19', 1),
('143', 'San Salvador el Verde', '21', 0, '2018-03-13 17:54:19', 0, '2018-03-13 17:54:19', 1),
('122', 'San Felipe Teotlalcingo', '21', 0, '2018-03-13 17:54:19', 0, '2018-03-13 17:54:19', 1),
('132', 'San Martín Texmelucan', '21', 0, '2018-03-13 17:54:18', 0, '2018-03-13 17:54:18', 1),
('170', 'Tepeyahualco', '21', 0, '2018-03-13 17:54:18', 0, '2018-03-13 17:54:18', 1),
('044', 'Cuyoaco', '21', 0, '2018-03-13 17:54:18', 0, '2018-03-13 17:54:18', 1),
('199', 'Xiutetelco', '21', 0, '2018-03-13 17:54:18', 0, '2018-03-13 17:54:18', 1),
('054', 'Chignautla', '21', 0, '2018-03-13 17:54:18', 0, '2018-03-13 17:54:18', 1),
('017', 'Atempan', '21', 0, '2018-03-13 17:54:18', 0, '2018-03-13 17:54:18', 1),
('204', 'Yaonáhuac', '21', 0, '2018-03-13 17:54:18', 0, '2018-03-13 17:54:18', 1),
('075', 'Hueyapan', '21', 0, '2018-03-13 17:54:18', 0, '2018-03-13 17:54:18', 1),
('173', 'Teteles de Avila Castillo', '21', 0, '2018-03-13 17:54:18', 0, '2018-03-13 17:54:18', 1),
('186', 'Tlatlauquitepec', '21', 0, '2018-03-13 17:54:18', 0, '2018-03-13 17:54:18', 1),
('174', 'Teziutlán', '21', 0, '2018-03-13 17:54:18', 0, '2018-03-13 17:54:18', 1),
('094', 'Libres', '21', 0, '2018-03-13 17:54:18', 0, '2018-03-13 17:54:18', 1),
('105', 'Ocotepec', '21', 0, '2018-03-13 17:54:18', 0, '2018-03-13 17:54:18', 1),
('212', 'Zautla', '21', 0, '2018-03-13 17:54:17', 0, '2018-03-13 17:54:17', 1),
('083', 'Ixtacamaxtitlán', '21', 0, '2018-03-13 17:54:17', 0, '2018-03-13 17:54:17', 1),
('211', 'Zaragoza', '21', 0, '2018-03-13 17:54:17', 0, '2018-03-13 17:54:17', 1),
('207', 'Zacapoaxtla', '21', 0, '2018-03-13 17:54:17', 0, '2018-03-13 17:54:17', 1),
('200', 'Xochiapulco', '21', 0, '2018-03-13 17:54:17', 0, '2018-03-13 17:54:17', 1),
('172', 'Tetela de Ocampo', '21', 0, '2018-03-13 17:54:17', 0, '2018-03-13 17:54:17', 1),
('016', 'Aquixtla', '21', 0, '2018-03-13 17:54:17', 0, '2018-03-13 17:54:17', 1),
('039', 'Cuautempan', '21', 0, '2018-03-13 17:54:17', 0, '2018-03-13 17:54:17', 1),
('002', 'Acateno', '21', 0, '2018-03-13 17:54:17', 0, '2018-03-13 17:54:17', 1),
('076', 'Hueytamalco', '21', 0, '2018-03-13 17:54:17', 0, '2018-03-13 17:54:17', 1),
('025', 'Ayotoxco de Guerrero', '21', 0, '2018-03-13 17:54:17', 0, '2018-03-13 17:54:17', 1),
('043', 'Cuetzalan del Progreso', '21', 0, '2018-03-13 17:54:17', 0, '2018-03-13 17:54:17', 1),
('101', 'Nauzontla', '21', 0, '2018-03-13 17:54:17', 0, '2018-03-13 17:54:17', 1),
('216', 'Zoquiapan', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('088', 'Jonotla', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('029', 'Caxhuacan', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('192', 'Tuzamapan de Galeana', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('158', 'Tenampulco', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('080', 'Atlequizayan', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('202', 'Xochitlán de Vicente Suárez', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('072', 'Huehuetla', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('084', 'Ixtepec', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('078', 'Huitzilan de Serdán', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('210', 'Zapotitlán de Méndez', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('077', 'Hueytlalpan', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('028', 'Camocuautla', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('030', 'Coatepec', '21', 0, '2018-03-13 17:54:16', 0, '2018-03-13 17:54:16', 1),
('107', 'Olintla', '21', 0, '2018-03-13 17:54:15', 0, '2018-03-13 17:54:15', 1),
('068', 'Hermenegildo Galeana', '21', 0, '2018-03-13 17:54:15', 0, '2018-03-13 17:54:15', 1),
('215', 'Zongozotla', '21', 0, '2018-03-13 17:54:15', 0, '2018-03-13 17:54:15', 1),
('162', 'Tepango de Rodríguez', '21', 0, '2018-03-13 17:54:15', 0, '2018-03-13 17:54:15', 1),
('014', 'Amixtlán', '21', 0, '2018-03-13 17:54:15', 0, '2018-03-13 17:54:15', 1),
('123', 'San Felipe Tepatlán', '21', 0, '2018-03-13 17:54:15', 0, '2018-03-13 17:54:15', 1),
('167', 'Tepetzintla', '21', 0, '2018-03-13 17:54:15', 0, '2018-03-13 17:54:15', 1),
('006', 'Ahuacatlán', '21', 0, '2018-03-13 17:54:15', 0, '2018-03-13 17:54:15', 1),
('049', 'Chiconcuautla', '21', 0, '2018-03-13 17:54:15', 0, '2018-03-13 17:54:15', 1),
('208', 'Zacatlán', '21', 0, '2018-03-13 17:54:15', 0, '2018-03-13 17:54:15', 1),
('053', 'Chignahuapan', '21', 0, '2018-03-13 17:54:15', 0, '2018-03-13 17:54:15', 1),
('184', 'Tlapacoya', '21', 0, '2018-03-13 17:54:15', 0, '2018-03-13 17:54:15', 1),
('089', 'Jopala', '21', 0, '2018-03-13 17:54:15', 0, '2018-03-13 17:54:15', 1),
('213', 'Zihuateutla', '21', 0, '2018-03-13 17:54:14', 0, '2018-03-13 17:54:14', 1),
('183', 'Tlaola', '21', 0, '2018-03-13 17:54:14', 0, '2018-03-13 17:54:14', 1),
('091', 'Juan Galindo', '21', 0, '2018-03-13 17:54:14', 0, '2018-03-13 17:54:14', 1),
('008', 'Ahuazotepec', '21', 0, '2018-03-13 17:54:14', 0, '2018-03-13 17:54:14', 1),
('071', 'Huauchinango', '21', 0, '2018-03-13 17:54:14', 0, '2018-03-13 17:54:14', 1),
('100', 'Naupan', '21', 0, '2018-03-13 17:54:14', 0, '2018-03-13 17:54:14', 1),
('057', 'Honey', '21', 0, '2018-03-13 17:54:14', 0, '2018-03-13 17:54:14', 1),
('109', 'Pahuatlán', '21', 0, '2018-03-13 17:54:14', 0, '2018-03-13 17:54:14', 1),
('197', 'Xicotepec', '21', 0, '2018-03-13 17:54:14', 0, '2018-03-13 17:54:14', 1),
('178', 'Tlacuilotepec', '21', 0, '2018-03-13 17:54:14', 0, '2018-03-13 17:54:14', 1),
('187', 'Tlaxco', '21', 0, '2018-03-13 17:54:14', 0, '2018-03-13 17:54:14', 1),
('086', 'Jalpan', '21', 0, '2018-03-13 17:54:14', 0, '2018-03-13 17:54:14', 1),
('194', 'Venustiano Carranza', '21', 0, '2018-03-13 17:54:14', 0, '2018-03-13 17:54:14', 1),
('111', 'Pantepec', '21', 0, '2018-03-13 17:54:13', 0, '2018-03-13 17:54:13', 1),
('064', 'Francisco Z. Mena', '21', 0, '2018-03-13 17:54:13', 0, '2018-03-13 17:54:13', 1),
('015', 'Amozoc', '21', 0, '2018-03-13 17:54:13', 0, '2018-03-13 17:54:13', 1),
('106', 'Ocoyucan', '21', 0, '2018-03-13 17:54:13', 0, '2018-03-13 17:54:13', 1),
('119', 'San Andrés Cholula', '21', 0, '2018-03-13 17:54:13', 0, '2018-03-13 17:54:13', 1),
('140', 'San Pedro Cholula', '21', 0, '2018-03-13 17:54:13', 0, '2018-03-13 17:54:13', 1),
('041', 'Cuautlancingo', '21', 0, '2018-03-13 17:54:13', 0, '2018-03-13 17:54:13', 1),
('034', 'Coronango', '21', 0, '2018-03-13 17:54:13', 0, '2018-03-13 17:54:13', 1),
('090', 'Juan C. Bonilla', '21', 0, '2018-03-13 17:54:13', 0, '2018-03-13 17:54:13', 1),
('136', 'San Miguel Xoxtla', '21', 0, '2018-03-13 17:54:13', 0, '2018-03-13 17:54:13', 1),
('181', 'Tlaltenango', '21', 0, '2018-03-13 17:54:13', 0, '2018-03-13 17:54:13', 1),
('114', 'Puebla', '21', 0, '2018-03-13 17:54:13', 0, '2018-03-13 17:54:13', 1),
('318', 'San Pedro Mixtepec -Dto. 22 -', '20', 0, '2018-03-13 17:54:13', 0, '2018-03-13 17:54:13', 1),
('153', 'San Gabriel Mixtepec', '20', 0, '2018-03-13 17:54:12', 0, '2018-03-13 17:54:12', 1),
('526', 'Santos Reyes Nopala', '20', 0, '2018-03-13 17:54:12', 0, '2018-03-13 17:54:12', 1),
('433', 'Santa María Temaxcaltepec', '20', 0, '2018-03-13 17:54:12', 0, '2018-03-13 17:54:12', 1),
('202', 'San Juan Lachao', '20', 0, '2018-03-13 17:54:12', 0, '2018-03-13 17:54:12', 1),
('497', 'Santiago Yaitepec', '20', 0, '2018-03-13 17:54:12', 0, '2018-03-13 17:54:12', 1),
('314', 'San Pedro Juchatengo', '20', 0, '2018-03-13 17:54:12', 0, '2018-03-13 17:54:12', 1),
('364', 'Santa Catarina Juquila', '20', 0, '2018-03-13 17:54:12', 0, '2018-03-13 17:54:12', 1),
('543', 'Tataltepec de Valdés', '20', 0, '2018-03-13 17:54:12', 0, '2018-03-13 17:54:12', 1),
('213', 'San Juan Quiahije', '20', 0, '2018-03-13 17:54:12', 0, '2018-03-13 17:54:12', 1),
('272', 'San Miguel Panixtlahuaca', '20', 0, '2018-03-13 17:54:12', 0, '2018-03-13 17:54:12', 1),
('334', 'Villa de Tututepec de Melchor Ocampo', '20', 0, '2018-03-13 17:54:12', 0, '2018-03-13 17:54:12', 1),
('414', 'Santa María Huazolotitlán', '20', 0, '2018-03-13 17:54:12', 0, '2018-03-13 17:54:12', 1),
('090', 'San Andrés Huaxpaltepec', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('367', 'Santa Catarina Mechoacán', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('489', 'Santiago Tetepec', '20', 0, '2018-03-13 17:54:12', 0, '2018-03-13 17:54:12', 1),
('082', 'San Agustín Chayuco', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('225', 'San Lorenzo', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('070', 'Pinotepa de Don Luis', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('188', 'San Juan Colorado', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('466', 'Santiago Ixtayutla', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('312', 'San Pedro Jicayán', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('302', 'San Pedro Atoyac', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('467', 'Santiago Jamiltepec', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('507', 'Santo Domingo Armenta', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('168', 'San José Estancia Grande', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('485', 'Santiago Tapextla', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('285', 'San Miguel Tlacamama', '20', 0, '2018-03-13 17:54:11', 0, '2018-03-13 17:54:11', 1),
('474', 'Santiago Llano Grande', '20', 0, '2018-03-13 17:54:10', 0, '2018-03-13 17:54:10', 1),
('402', 'Santa María Cortijo', '20', 0, '2018-03-13 17:54:10', 0, '2018-03-13 17:54:10', 1),
('111', 'San Antonio Tepetlapa', '20', 0, '2018-03-13 17:54:10', 0, '2018-03-13 17:54:10', 1),
('056', 'Mártires de Tacubaya', '20', 0, '2018-03-13 17:54:10', 0, '2018-03-13 17:54:10', 1),
('345', 'San Sebastián Ixcapa', '20', 0, '2018-03-13 17:54:10', 0, '2018-03-13 17:54:10', 1),
('180', 'San Juan Bautista Lo de Soto', '20', 0, '2018-03-13 17:54:10', 0, '2018-03-13 17:54:10', 1),
('185', 'San Juan Cacahuatepec', '20', 0, '2018-03-13 17:54:10', 0, '2018-03-13 17:54:10', 1),
('482', 'Santiago Pinotepa Nacional', '20', 0, '2018-03-13 17:54:10', 0, '2018-03-13 17:54:10', 1),
('534', 'San Vicente Coatlán', '20', 0, '2018-03-13 17:54:10', 0, '2018-03-13 17:54:10', 1),
('542', 'Taniche', '20', 0, '2018-03-13 17:54:10', 0, '2018-03-13 17:54:10', 1),
('268', 'San Miguel Ejutla', '20', 0, '2018-03-13 17:54:10', 0, '2018-03-13 17:54:10', 1),
('563', 'Yogana', '20', 0, '2018-03-13 17:54:10', 0, '2018-03-13 17:54:10', 1),
('203', 'San Juan Lachigalla', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('080', 'San Agustín Amatengo', '20', 0, '2018-03-13 17:54:10', 0, '2018-03-13 17:54:10', 1),
('015', 'Coatecas Altas', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('017', 'La Compañía', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('069', 'La Pe', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('241', 'San Martín Lachilá', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('238', 'San Martín de los Cansecos', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('328', 'San Pedro Taviche', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('561', 'Yaxe', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('072', 'San José del Progreso', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('101', 'San Andrés Zabache', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('162', 'San Jerónimo Taviche', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('393', 'Santa Lucía Ocotlán', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('301', 'San Pedro Apóstol', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('112', 'San Baltazar Chichicápam', '20', 0, '2018-03-13 17:54:09', 0, '2018-03-13 17:54:09', 1),
('368', 'Santa Catarina Minas', '20', 0, '2018-03-13 17:54:08', 0, '2018-03-13 17:54:08', 1),
('284', 'San Miguel Tilquiápam', '20', 0, '2018-03-13 17:54:08', 0, '2018-03-13 17:54:08', 1),
('049', 'Magdalena Ocotlán', '20', 0, '2018-03-13 17:54:08', 0, '2018-03-13 17:54:08', 1),
('315', 'San Pedro Mártir', '20', 0, '2018-03-13 17:54:08', 0, '2018-03-13 17:54:08', 1),
('132', 'San Dionisio Ocotlán', '20', 0, '2018-03-13 17:54:08', 0, '2018-03-13 17:54:08', 1),
('007', 'Asunción Ocotlán', '20', 0, '2018-03-13 17:54:08', 0, '2018-03-13 17:54:08', 1),
('103', 'San Antonino Castillo Velasco', '20', 0, '2018-03-13 17:54:08', 0, '2018-03-13 17:54:08', 1),
('452', 'Santiago Apóstol', '20', 0, '2018-03-13 17:54:08', 0, '2018-03-13 17:54:08', 1),
('360', 'Santa Ana Zegache', '20', 0, '2018-03-13 17:54:08', 0, '2018-03-13 17:54:08', 1),
('068', 'Ocotlán de Morelos', '20', 0, '2018-03-13 17:54:08', 0, '2018-03-13 17:54:08', 1),
('192', 'San Juan Chilateca', '20', 0, '2018-03-13 17:54:08', 0, '2018-03-13 17:54:08', 1),
('530', 'Santo Tomás Jalieza', '20', 0, '2018-03-13 17:54:08', 0, '2018-03-13 17:54:08', 1),
('243', 'San Martín Tilcajete', '20', 0, '2018-03-13 17:54:07', 0, '2018-03-13 17:54:07', 1),
('477', 'Santiago Minas', '20', 0, '2018-03-13 17:54:07', 0, '2018-03-13 17:54:07', 1),
('028', 'Heroica Ciudad de Ejutla de Crespo', '20', 0, '2018-03-13 17:54:07', 0, '2018-03-13 17:54:07', 1),
('155', 'San Ildefonso Sola', '20', 0, '2018-03-13 17:54:07', 0, '2018-03-13 17:54:07', 1),
('149', 'San Francisco Sola', '20', 0, '2018-03-13 17:54:07', 0, '2018-03-13 17:54:07', 1),
('429', 'Santa María Sola', '20', 0, '2018-03-13 17:54:07', 0, '2018-03-13 17:54:07', 1),
('277', 'Villa Sola de Vega', '20', 0, '2018-03-13 17:54:07', 0, '2018-03-13 17:54:07', 1),
('420', 'Santa María Lachixío', '20', 0, '2018-03-13 17:54:07', 0, '2018-03-13 17:54:07', 1),
('535', 'San Vicente Lachixío', '20', 0, '2018-03-13 17:54:07', 0, '2018-03-13 17:54:07', 1),
('229', 'San Lorenzo Texmelúcan', '20', 0, '2018-03-13 17:54:07', 0, '2018-03-13 17:54:07', 1),
('023', 'Cuilápam de Guerrero', '20', 0, '2018-03-13 17:54:07', 0, '2018-03-13 17:54:07', 1),
('516', 'Santo Domingo Teojomulco', '20', 0, '2018-03-13 17:54:07', 0, '2018-03-13 17:54:07', 1),
('448', 'Santa María Zaniza', '20', 0, '2018-03-13 17:54:07', 0, '2018-03-13 17:54:07', 1),
('450', 'Santiago Amoltepec', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('491', 'Santiago Textitlán', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('566', 'San Mateo Yucutindoo', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('137', 'San Francisco Cahuacuá', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('386', 'Santa Cruz Zenzontepec', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('358', 'Santa Ana Tlapacoyan', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('398', 'Ayoquezco de Aldama', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('369', 'Santa Catarina Quiané', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('048', 'Magdalena Mixtepec', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('104', 'San Antonino el Alto', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('387', 'Santa Gertrudis', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('388', 'Santa Inés del Monte', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('292', 'San Pablo Cuatro Venados', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('273', 'San Miguel Peras', '20', 0, '2018-03-13 17:54:06', 0, '2018-03-13 17:54:06', 1),
('350', 'San Sebastián Tutla', '20', 0, '2018-03-13 17:54:05', 0, '2018-03-13 17:54:05', 1),
('565', 'Villa de Zaachila', '20', 0, '2018-03-13 17:54:05', 0, '2018-03-13 17:54:05', 1),
('108', 'San Antonio Huitepec', '20', 0, '2018-03-13 17:54:05', 0, '2018-03-13 17:54:05', 1),
('013', 'Ciénega de Zimatlán', '20', 0, '2018-03-13 17:54:05', 0, '2018-03-13 17:54:05', 1),
('389', 'Santa Inés Yatzeche', '20', 0, '2018-03-13 17:54:05', 0, '2018-03-13 17:54:05', 1),
('403', 'Santa María Coyotepec', '20', 0, '2018-03-13 17:54:05', 0, '2018-03-13 17:54:05', 1),
('115', 'San Bartolo Coyotepec', '20', 0, '2018-03-13 17:54:05', 0, '2018-03-13 17:54:05', 1),
('555', 'Trinidad Zaachila', '20', 0, '2018-03-13 17:54:05', 0, '2018-03-13 17:54:05', 1),
('342', 'San Raymundo Jalpan', '20', 0, '2018-03-13 17:54:05', 0, '2018-03-13 17:54:05', 1),
('158', 'San Jacinto Tlacotepec', '20', 0, '2018-03-13 17:54:05', 0, '2018-03-13 17:54:05', 1),
('174', 'Ánimas Trujano', '20', 0, '2018-03-13 17:54:05', 0, '2018-03-13 17:54:05', 1),
('295', 'San Pablo Huixtepec', '20', 0, '2018-03-13 17:54:05', 0, '2018-03-13 17:54:05', 1),
('083', 'San Agustín de las Juntas', '20', 0, '2018-03-13 17:54:05', 0, '2018-03-13 17:54:05', 1),
('107', 'San Antonio de la Cal', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('310', 'San Pedro Ixtlahuaca', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('385', 'Santa Cruz Xoxocotlán', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('390', 'Santa Lucía del Camino', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('092', 'San Andrés Ixtlahuaca', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('375', 'Santa Cruz Amilpas', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('378', 'Santa Cruz Mixtepec', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('271', 'San Miguel Mixtepec', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('399', 'Santa María Atzompa', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('123', 'San Bernardo Mixtepec', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('570', 'Zimatlán de Álvarez', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('377', 'Santa Cruz Itundujia', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('500', 'Santiago Yosondúa', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('444', 'Santa María Yolotepec', '20', 0, '2018-03-13 17:54:04', 0, '2018-03-13 17:54:04', 1),
('392', 'Santa Lucía Monteverde', '20', 0, '2018-03-13 17:54:03', 0, '2018-03-13 17:54:03', 1),
('088', 'San Andrés Cabecera Nueva', '20', 0, '2018-03-13 17:54:03', 0, '2018-03-13 17:54:03', 1),
('269', 'San Miguel el Grande', '20', 0, '2018-03-13 17:54:03', 0, '2018-03-13 17:54:03', 1),
('510', 'Santo Domingo Ixcatlán', '20', 0, '2018-03-13 17:54:03', 0, '2018-03-13 17:54:03', 1),
('297', 'San Pablo Tijaltepec', '20', 0, '2018-03-13 17:54:03', 0, '2018-03-13 17:54:03', 1),
('382', 'Santa Cruz Tacahua', '20', 0, '2018-03-13 17:54:03', 0, '2018-03-13 17:54:03', 1),
('372', 'Santa Catarina Yosonotú', '20', 0, '2018-03-13 17:54:03', 0, '2018-03-13 17:54:03', 1),
('481', 'Santiago Nuyoó', '20', 0, '2018-03-13 17:54:03', 0, '2018-03-13 17:54:03', 1),
('371', 'Santa Catarina Ticuá', '20', 0, '2018-03-13 17:54:03', 0, '2018-03-13 17:54:03', 1),
('133', 'San Esteban Atatlahuca', '20', 0, '2018-03-13 17:54:03', 0, '2018-03-13 17:54:03', 1),
('446', 'Santa María Yucuhiti', '20', 0, '2018-03-13 17:54:03', 0, '2018-03-13 17:54:03', 1),
('026', 'Chalcatongo de Hidalgo', '20', 0, '2018-03-13 17:54:03', 0, '2018-03-13 17:54:03', 1),
('415', 'Santa María Ipalapa', '20', 0, '2018-03-13 17:54:03', 0, '2018-03-13 17:54:03', 1),
('076', 'La Reforma', '20', 0, '2018-03-13 17:54:02', 0, '2018-03-13 17:54:02', 1),
('300', 'San Pedro Amuzgos', '20', 0, '2018-03-13 17:54:02', 0, '2018-03-13 17:54:02', 1),
('447', 'Santa María Zacatepec', '20', 0, '2018-03-13 17:54:02', 0, '2018-03-13 17:54:02', 1),
('037', 'Mesones Hidalgo', '20', 0, '2018-03-13 17:54:02', 0, '2018-03-13 17:54:02', 1),
('020', 'Constancia del Rosario', '20', 0, '2018-03-13 17:54:02', 0, '2018-03-13 17:54:02', 1),
('073', 'Putla Villa de Guerrero', '20', 0, '2018-03-13 17:54:02', 0, '2018-03-13 17:54:02', 1),
('266', 'San Miguel del Puerto', '20', 0, '2018-03-13 17:54:02', 0, '2018-03-13 17:54:02', 1),
('253', 'San Mateo Piñas', '20', 0, '2018-03-13 17:54:02', 0, '2018-03-13 17:54:02', 1),
('413', 'Santa María Huatulco', '20', 0, '2018-03-13 17:54:02', 0, '2018-03-13 17:54:02', 1),
('306', 'San Pedro el Alto', '20', 0, '2018-03-13 17:54:02', 0, '2018-03-13 17:54:02', 1),
('071', 'Pluma Hidalgo', '20', 0, '2018-03-13 17:54:02', 0, '2018-03-13 17:54:02', 1),
('012', 'Candelaria Loxicha', '20', 0, '2018-03-13 17:54:02', 0, '2018-03-13 17:54:02', 1),
('117', 'San Bartolomé Loxicha', '20', 0, '2018-03-13 17:54:01', 0, '2018-03-13 17:54:01', 1),
('439', 'Santa María Tonameca', '20', 0, '2018-03-13 17:54:02', 0, '2018-03-13 17:54:02', 1),
('401', 'Santa María Colotepec', '20', 0, '2018-03-13 17:54:01', 0, '2018-03-13 17:54:01', 1),
('113', 'San Baltazar Loxicha', '20', 0, '2018-03-13 17:54:01', 0, '2018-03-13 17:54:01', 1),
('085', 'San Agustín Loxicha', '20', 0, '2018-03-13 17:54:01', 0, '2018-03-13 17:54:01', 1),
('324', 'San Pedro Pochutla', '20', 0, '2018-03-13 17:54:01', 0, '2018-03-13 17:54:01', 1),
('509', 'Santo Domingo de Morelos', '20', 0, '2018-03-13 17:54:01', 0, '2018-03-13 17:54:01', 1),
('366', 'Santa Catarina Loxicha', '20', 0, '2018-03-13 17:54:01', 0, '2018-03-13 17:54:01', 1),
('211', 'San Juan Ozolotepec', '20', 0, '2018-03-13 17:54:01', 0, '2018-03-13 17:54:01', 1),
('236', 'San Marcial Ozolotepec', '20', 0, '2018-03-13 17:54:01', 0, '2018-03-13 17:54:01', 1),
('148', 'San Francisco Ozolotepec', '20', 0, '2018-03-13 17:54:01', 0, '2018-03-13 17:54:01', 1),
('495', 'Santiago Xanica', '20', 0, '2018-03-13 17:54:01', 0, '2018-03-13 17:54:01', 1),
('512', 'Santo Domingo Ozolotepec', '20', 0, '2018-03-13 17:54:01', 0, '2018-03-13 17:54:01', 1),
('279', 'San Miguel Suchixtepec', '20', 0, '2018-03-13 17:54:01', 0, '2018-03-13 17:54:01', 1),
('347', 'San Sebastián Río Hondo', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('263', 'San Miguel Coatlán', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('424', 'Santa María Ozolotepec', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('095', 'San Andrés Paxtlán', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('291', 'San Pablo Coatlán', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('254', 'San Mateo Río Hondo', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('533', 'Santo Tomás Tamazulapan', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('344', 'San Sebastián Coatlán', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('159', 'San Jerónimo Coatlán', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('391', 'Santa Lucía Miahuatlán', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('319', 'San Pedro Mixtepec -Dto. 26 -', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('126', 'San Cristóbal Amatlán', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('209', 'San Juan Mixtepec -Dto. 26 -', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('167', 'San José del Peñasco', '20', 0, '2018-03-13 17:54:00', 0, '2018-03-13 17:54:00', 1),
('362', 'Santa Catarina Cuixtla', '20', 0, '2018-03-13 17:53:59', 0, '2018-03-13 17:53:59', 1),
('061', 'Monjas', '20', 0, '2018-03-13 17:53:59', 0, '2018-03-13 17:53:59', 1),
('154', 'San Ildefonso Amatlán', '20', 0, '2018-03-13 17:53:59', 0, '2018-03-13 17:53:59', 1),
('384', 'Santa Cruz Xitla', '20', 0, '2018-03-13 17:53:59', 0, '2018-03-13 17:53:59', 1),
('353', 'Santa Ana', '20', 0, '2018-03-13 17:53:59', 0, '2018-03-13 17:53:59', 1),
('146', 'San Francisco Logueche', '20', 0, '2018-03-13 17:53:59', 0, '2018-03-13 17:53:59', 1),
('538', 'Sitio de Xitlapehua', '20', 0, '2018-03-13 17:53:59', 0, '2018-03-13 17:53:59', 1),
('235', 'San Luis Amatlán', '20', 0, '2018-03-13 17:53:59', 0, '2018-03-13 17:53:59', 1),
('170', 'San José Lachiguiri', '20', 0, '2018-03-13 17:53:59', 0, '2018-03-13 17:53:59', 1),
('289', 'San Nicolás', '20', 0, '2018-03-13 17:53:59', 0, '2018-03-13 17:53:59', 1),
('351', 'San Simón Almolongas', '20', 0, '2018-03-13 17:53:59', 0, '2018-03-13 17:53:59', 1),
('453', 'Santiago Astata', '20', 0, '2018-03-13 17:53:58', 0, '2018-03-13 17:53:58', 1),
('282', 'San Miguel Tenango', '20', 0, '2018-03-13 17:53:59', 0, '2018-03-13 17:53:59', 1),
('059', 'Miahuatlán de Porfirio Díaz', '20', 0, '2018-03-13 17:53:59', 0, '2018-03-13 17:53:59', 1),
('124', 'San Blas Atempa', '20', 0, '2018-03-13 17:53:58', 0, '2018-03-13 17:53:58', 1),
('248', 'San Mateo del Mar', '20', 0, '2018-03-13 17:53:58', 0, '2018-03-13 17:53:58', 1),
('308', 'San Pedro Huilotepec', '20', 0, '2018-03-13 17:53:58', 0, '2018-03-13 17:53:58', 1),
('515', 'Santo Domingo Tehuantepec', '20', 0, '2018-03-13 17:53:58', 0, '2018-03-13 17:53:58', 1),
('307', 'San Pedro Huamelula', '20', 0, '2018-03-13 17:53:58', 0, '2018-03-13 17:53:58', 1),
('305', 'San Pedro Comitancillo', '20', 0, '2018-03-13 17:53:58', 0, '2018-03-13 17:53:58', 1),
('421', 'Santa María Mixtequilla', '20', 0, '2018-03-13 17:53:58', 0, '2018-03-13 17:53:58', 1),
('053', 'Magdalena Tlacotepec', '20', 0, '2018-03-13 17:53:58', 0, '2018-03-13 17:53:58', 1),
('052', 'Magdalena Tequisistlán', '20', 0, '2018-03-13 17:53:58', 0, '2018-03-13 17:53:58', 1),
('412', 'Santa María Guienagati', '20', 0, '2018-03-13 17:53:58', 0, '2018-03-13 17:53:58', 1),
('508', 'Santo Domingo Chihuitán', '20', 0, '2018-03-13 17:53:58', 0, '2018-03-13 17:53:58', 1),
('036', 'Guevea de Humboldt', '20', 0, '2018-03-13 17:53:58', 0, '2018-03-13 17:53:58', 1),
('472', 'Santiago Laollaga', '20', 0, '2018-03-13 17:53:57', 0, '2018-03-13 17:53:57', 1),
('440', 'Santa María Totolapilla', '20', 0, '2018-03-13 17:53:57', 0, '2018-03-13 17:53:57', 1),
('418', 'Santa María Jalapa del Marqués', '20', 0, '2018-03-13 17:53:57', 0, '2018-03-13 17:53:57', 1),
('470', 'Santiago Lachiguiri', '20', 0, '2018-03-13 17:53:57', 0, '2018-03-13 17:53:57', 1),
('079', 'Salina Cruz', '20', 0, '2018-03-13 17:53:57', 0, '2018-03-13 17:53:57', 1),
('361', 'Santa Catalina Quierí', '20', 0, '2018-03-13 17:53:57', 0, '2018-03-13 17:53:57', 1),
('428', 'Santa María Quiegolani', '20', 0, '2018-03-13 17:53:57', 0, '2018-03-13 17:53:57', 1),
('074', 'Santa Catarina Quioquitani', '20', 0, '2018-03-13 17:53:57', 0, '2018-03-13 17:53:57', 1),
('316', 'San Pedro Mártir Quiechapa', '20', 0, '2018-03-13 17:53:57', 0, '2018-03-13 17:53:57', 1),
('008', 'Asunción Tlacolulita', '20', 0, '2018-03-13 17:53:57', 0, '2018-03-13 17:53:57', 1),
('410', 'Santa María Ecatepec', '20', 0, '2018-03-13 17:53:57', 0, '2018-03-13 17:53:57', 1),
('204', 'San Juan Lajarcia', '20', 0, '2018-03-13 17:53:57', 0, '2018-03-13 17:53:57', 1),
('122', 'San Bartolo Yautepec', '20', 0, '2018-03-13 17:53:57', 0, '2018-03-13 17:53:57', 1),
('357', 'Santa Ana Tavela', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('064', 'Nejapa de Madero', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('200', 'San Juan Juquila Mixes', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('125', 'San Carlos Yautepec', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('131', 'San Dionisio Ocotepec', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('449', 'Santa María Zoquitlán', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('325', 'San Pedro Quiatoni', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('333', 'San Pedro Totolápam', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('226', 'San Lorenzo Albarradas', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('118', 'San Bartolomé Quialana', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('194', 'San Juan del Río', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('197', 'San Juan Guelavía', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('233', 'San Lucas Quiaviní', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('550', 'San Jerónimo Tlacochahuaya', '20', 0, '2018-03-13 17:53:56', 0, '2018-03-13 17:53:56', 1),
('380', 'Santa Cruz Papalutla', '20', 0, '2018-03-13 17:53:55', 0, '2018-03-13 17:53:55', 1),
('051', 'Magdalena Teitipac', '20', 0, '2018-03-13 17:53:55', 0, '2018-03-13 17:53:55', 1),
('219', 'San Juan Teitipac', '20', 0, '2018-03-13 17:53:55', 0, '2018-03-13 17:53:55', 1),
('078', 'Rojas de Cuauhtémoc', '20', 0, '2018-03-13 17:53:55', 0, '2018-03-13 17:53:55', 1),
('506', 'Santo Domingo Albarradas', '20', 0, '2018-03-13 17:53:55', 0, '2018-03-13 17:53:55', 1),
('475', 'Santiago Matatlán', '20', 0, '2018-03-13 17:53:55', 0, '2018-03-13 17:53:55', 1),
('356', 'Santa Ana del Valle', '20', 0, '2018-03-13 17:53:55', 0, '2018-03-13 17:53:55', 1),
('298', 'San Pablo Villa de Mitla', '20', 0, '2018-03-13 17:53:55', 0, '2018-03-13 17:53:55', 1),
('349', 'San Sebastián Teitipac', '20', 0, '2018-03-13 17:53:55', 0, '2018-03-13 17:53:55', 1),
('145', 'San Francisco Lachigoló', '20', 0, '2018-03-13 17:53:55', 0, '2018-03-13 17:53:55', 1),
('546', 'Teotitlán del Valle', '20', 0, '2018-03-13 17:53:55', 0, '2018-03-13 17:53:55', 1),
('411', 'Santa María Guelacé', '20', 0, '2018-03-13 17:53:55', 0, '2018-03-13 17:53:55', 1),
('560', 'Villa Díaz Ordaz', '20', 0, '2018-03-13 17:53:55', 0, '2018-03-13 17:53:55', 1),
('343', 'San Sebastián Abasolo', '20', 0, '2018-03-13 17:53:54', 0, '2018-03-13 17:53:54', 1),
('551', 'Tlacolula de Matamoros', '20', 0, '2018-03-13 17:53:54', 0, '2018-03-13 17:53:54', 1),
('010', 'El Barrio de la Soledad', '20', 0, '2018-03-13 17:53:54', 0, '2018-03-13 17:53:54', 1),
('427', 'Santa María Petapa', '20', 0, '2018-03-13 17:53:54', 0, '2018-03-13 17:53:54', 1),
('407', 'Santa María Chimalapa', '20', 0, '2018-03-13 17:53:54', 0, '2018-03-13 17:53:54', 1),
('513', 'Santo Domingo Petapa', '20', 0, '2018-03-13 17:53:54', 0, '2018-03-13 17:53:54', 1),
('057', 'Matías Romero Avendaño', '20', 0, '2018-03-13 17:53:54', 0, '2018-03-13 17:53:54', 1),
('198', 'San Juan Guichicovi', '20', 0, '2018-03-13 17:53:54', 0, '2018-03-13 17:53:54', 1),
('465', 'Santiago Ixcuintepec', '20', 0, '2018-03-13 17:53:54', 0, '2018-03-13 17:53:54', 1),
('231', 'San Lucas Camotlán', '20', 0, '2018-03-13 17:53:54', 0, '2018-03-13 17:53:54', 1),
('323', 'San Pedro Ocotepec', '20', 0, '2018-03-13 17:53:54', 0, '2018-03-13 17:53:54', 1),
('003', 'Asunción Cacalotepec', '20', 0, '2018-03-13 17:53:54', 0, '2018-03-13 17:53:54', 1),
('275', 'San Miguel Quetzaltepec', '20', 0, '2018-03-13 17:53:54', 0, '2018-03-13 17:53:54', 1),
('435', 'Santa María Tepantlali', '20', 0, '2018-03-13 17:53:53', 0, '2018-03-13 17:53:53', 1),
('337', 'San Pedro y San Pablo Ayutla', '20', 0, '2018-03-13 17:53:53', 0, '2018-03-13 17:53:53', 1),
('454', 'Santiago Atitlán', '20', 0, '2018-03-13 17:53:53', 0, '2018-03-13 17:53:53', 1),
('031', 'Tamazulápam del Espíritu Santo', '20', 0, '2018-03-13 17:53:53', 0, '2018-03-13 17:53:53', 1),
('437', 'Santa María Tlahuitoltepec', '20', 0, '2018-03-13 17:53:53', 0, '2018-03-13 17:53:53', 1),
('394', 'Santa María Alotepec', '20', 0, '2018-03-13 17:53:53', 0, '2018-03-13 17:53:53', 1),
('554', 'Totontepec Villa de Morelos', '20', 0, '2018-03-13 17:53:53', 0, '2018-03-13 17:53:53', 1),
('060', 'Mixistlán de la Reforma', '20', 0, '2018-03-13 17:53:53', 0, '2018-03-13 17:53:53', 1),
('207', 'San Juan Mazatlán', '20', 0, '2018-03-13 17:53:53', 0, '2018-03-13 17:53:53', 1),
('025', 'Chahuites', '20', 0, '2018-03-13 17:53:53', 0, '2018-03-13 17:53:53', 1),
('502', 'Santiago Zacatepec', '20', 0, '2018-03-13 17:53:53', 0, '2018-03-13 17:53:53', 1),
('517', 'Santo Domingo Tepuxtepec', '20', 0, '2018-03-13 17:53:53', 0, '2018-03-13 17:53:53', 1),
('190', 'San Juan Cotzocón', '20', 0, '2018-03-13 17:53:53', 0, '2018-03-13 17:53:53', 1),
('327', 'San Pedro Tapanatepec', '20', 0, '2018-03-13 17:53:52', 0, '2018-03-13 17:53:52', 1),
('143', 'San Francisco Ixhuatán', '20', 0, '2018-03-13 17:53:52', 0, '2018-03-13 17:53:52', 1),
('075', 'Reforma de Pineda', '20', 0, '2018-03-13 17:53:52', 0, '2018-03-13 17:53:52', 1),
('525', 'Santo Domingo Zanatepec', '20', 0, '2018-03-13 17:53:52', 0, '2018-03-13 17:53:52', 1),
('265', 'San Miguel Chimalapa', '20', 0, '2018-03-13 17:53:52', 0, '2018-03-13 17:53:52', 1),
('557', 'Unión Hidalgo', '20', 0, '2018-03-13 17:53:52', 0, '2018-03-13 17:53:52', 1),
('141', 'San Francisco del Mar', '20', 0, '2018-03-13 17:53:52', 0, '2018-03-13 17:53:52', 1),
('005', 'Asunción Ixtaltepec', '20', 0, '2018-03-13 17:53:52', 0, '2018-03-13 17:53:52', 1),
('130', 'San Dionisio del Mar', '20', 0, '2018-03-13 17:53:52', 0, '2018-03-13 17:53:52', 1),
('066', 'Santiago Niltepec', '20', 0, '2018-03-13 17:53:52', 0, '2018-03-13 17:53:52', 1);
INSERT INTO `ciudad` (`Clave_Ciudad`, `Nombre`, `Clave_Estado`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Estatus`) VALUES
('441', 'Santa María Xadani', '20', 0, '2018-03-13 17:53:52', 0, '2018-03-13 17:53:52', 1),
('505', 'Santo Domingo Ingenio', '20', 0, '2018-03-13 17:53:52', 0, '2018-03-13 17:53:52', 1),
('030', 'El Espinal', '20', 0, '2018-03-13 17:53:52', 0, '2018-03-13 17:53:52', 1),
('255', 'San Mateo Sindihui', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('043', 'Heroica Ciudad de Juchitán de Zaragoza', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('014', 'Ciudad Ixtepec', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('564', 'Yutanduchi de Guerrero', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('329', 'San Pedro Teozacoalco', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('274', 'San Miguel Piedras', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('511', 'Santo Domingo Nuxaá', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('217', 'San Juan Tamazola', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('094', 'San Andrés Nuxiño', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('195', 'San Juan Diuxi', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('492', 'Santiago Tilantongo', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('144', 'San Francisco Jaltepetongo', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('331', 'San Pedro Tidaá', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('147', 'San Francisco Nuxaño', '20', 0, '2018-03-13 17:53:51', 0, '2018-03-13 17:53:51', 1),
('281', 'San Miguel Tecomatlán', '20', 0, '2018-03-13 17:53:50', 0, '2018-03-13 17:53:50', 1),
('054', 'Magdalena Zahuatlán', '20', 0, '2018-03-13 17:53:50', 0, '2018-03-13 17:53:50', 1),
('562', 'Magdalena Yodocono de Porfirio Díaz', '20', 0, '2018-03-13 17:53:50', 0, '2018-03-13 17:53:50', 1),
('046', 'Magdalena Jaltepec', '20', 0, '2018-03-13 17:53:50', 0, '2018-03-13 17:53:50', 1),
('218', 'San Juan Teita', '20', 0, '2018-03-13 17:53:50', 0, '2018-03-13 17:53:50', 1),
('445', 'Santa María Yosoyúa', '20', 0, '2018-03-13 17:53:50', 0, '2018-03-13 17:53:50', 1),
('320', 'San Pedro Molinos', '20', 0, '2018-03-13 17:53:50', 0, '2018-03-13 17:53:50', 1),
('430', 'Santa María Tataltepec', '20', 0, '2018-03-13 17:53:50', 0, '2018-03-13 17:53:50', 1),
('252', 'San Mateo Peñasco', '20', 0, '2018-03-13 17:53:50', 0, '2018-03-13 17:53:50', 1),
('110', 'San Antonio Sinicahua', '20', 0, '2018-03-13 17:53:50', 0, '2018-03-13 17:53:50', 1),
('086', 'San Agustín Tlacotepec', '20', 0, '2018-03-13 17:53:50', 0, '2018-03-13 17:53:50', 1),
('532', 'Santo Tomás Ocotepec', '20', 0, '2018-03-13 17:53:50', 0, '2018-03-13 17:53:50', 1),
('379', 'Santa Cruz Nundaco', '20', 0, '2018-03-13 17:53:50', 0, '2018-03-13 17:53:50', 1),
('119', 'San Bartolomé Yucuañe', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('050', 'Magdalena Peñasco', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('258', 'San Miguel Achiutla', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('240', 'San Martín Itunyoso', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('127', 'San Cristóbal Amoltepec', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('370', 'Santa Catarina Tayata', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('172', 'San Juan Achiutla', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('408', 'Santa María del Rosario', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('480', 'Santiago Nundiche', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('383', 'Santa Cruz Tayata', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('239', 'San Martín Huamelúlpam', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('317', 'San Pedro Mártir Yucuxaco', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('210', 'San Juan Ñumí', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('397', 'Heroica Ciudad de Tlaxiaco', '20', 0, '2018-03-13 17:53:49', 0, '2018-03-13 17:53:49', 1),
('016', 'Coicoyán de las Flores', '20', 0, '2018-03-13 17:53:48', 0, '2018-03-13 17:53:48', 1),
('528', 'Santos Reyes Tepejillo', '20', 0, '2018-03-13 17:53:48', 0, '2018-03-13 17:53:48', 1),
('208', 'San Juan Mixtepec -Dto. 08 -', '20', 0, '2018-03-13 17:53:48', 0, '2018-03-13 17:53:48', 1),
('242', 'San Martín Peras', '20', 0, '2018-03-13 17:53:48', 0, '2018-03-13 17:53:48', 1),
('348', 'San Sebastián Tecomaxtlahuaca', '20', 0, '2018-03-13 17:53:48', 0, '2018-03-13 17:53:48', 1),
('286', 'San Miguel Tlacotepec', '20', 0, '2018-03-13 17:53:48', 0, '2018-03-13 17:53:48', 1),
('469', 'Santiago Juxtlahuaca', '20', 0, '2018-03-13 17:53:48', 0, '2018-03-13 17:53:48', 1),
('250', 'San Mateo Etlatongo', '20', 0, '2018-03-13 17:53:48', 0, '2018-03-13 17:53:48', 1),
('569', 'Santa Inés de Zaragoza', '20', 0, '2018-03-13 17:53:48', 0, '2018-03-13 17:53:48', 1),
('140', 'San Francisco Chindúa', '20', 0, '2018-03-13 17:53:48', 0, '2018-03-13 17:53:48', 1),
('493', 'Santiago Tillo', '20', 0, '2018-03-13 17:53:48', 0, '2018-03-13 17:53:48', 1),
('215', 'San Juan Sayultepec', '20', 0, '2018-03-13 17:53:48', 0, '2018-03-13 17:53:48', 1),
('224', 'San Juan Yucuita', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('096', 'San Andrés Sinaxtla', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('523', 'Santo Domingo Yanhuitlán', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('463', 'Santiago Huauclilla', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('304', 'San Pedro Coxcaltepec Cántaros', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('451', 'Santiago Apoala', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('404', 'Santa María Chachoápam', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('264', 'San Miguel Chicahua', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('395', 'Santa María Apazco', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('270', 'San Miguel Huautla', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('006', 'Asunción Nochixtlán', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('479', 'Santiago Nejapilla', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('536', 'San Vicente Nuñú', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('332', 'San Pedro Topiltepec', '20', 0, '2018-03-13 17:53:47', 0, '2018-03-13 17:53:47', 1),
('423', 'Santa María Nduayaco', '20', 0, '2018-03-13 17:53:46', 0, '2018-03-13 17:53:46', 1),
('346', 'San Sebastián Nicananduta', '20', 0, '2018-03-13 17:53:46', 0, '2018-03-13 17:53:46', 1),
('518', 'Santo Domingo Tlatayápam', '20', 0, '2018-03-13 17:53:46', 0, '2018-03-13 17:53:46', 1),
('499', 'Santiago Yolomécatl', '20', 0, '2018-03-13 17:53:46', 0, '2018-03-13 17:53:46', 1),
('121', 'San Bartolo Soyaltepec', '20', 0, '2018-03-13 17:53:46', 0, '2018-03-13 17:53:46', 1),
('221', 'San Juan Teposcolula', '20', 0, '2018-03-13 17:53:46', 0, '2018-03-13 17:53:46', 1),
('341', 'San Pedro Yucunama', '20', 0, '2018-03-13 17:53:46', 0, '2018-03-13 17:53:46', 1),
('093', 'San Andrés Lagunas', '20', 0, '2018-03-13 17:53:46', 0, '2018-03-13 17:53:46', 1),
('105', 'San Antonino Monte Verde', '20', 0, '2018-03-13 17:53:46', 0, '2018-03-13 17:53:46', 1),
('405', 'Villa de Chilapa de Díaz', '20', 0, '2018-03-13 17:53:46', 0, '2018-03-13 17:53:46', 1),
('521', 'Santo Domingo Tonaltepec', '20', 0, '2018-03-13 17:53:46', 0, '2018-03-13 17:53:46', 1),
('486', 'Villa Tejúpam de la Unión', '20', 0, '2018-03-13 17:53:46', 0, '2018-03-13 17:53:46', 1),
('106', 'San Antonio Acutla', '20', 0, '2018-03-13 17:53:46', 0, '2018-03-13 17:53:46', 1),
('547', 'Teotongo', '20', 0, '2018-03-13 17:53:45', 0, '2018-03-13 17:53:45', 1),
('321', 'San Pedro Nopala', '20', 0, '2018-03-13 17:53:45', 0, '2018-03-13 17:53:45', 1),
('556', 'La Trinidad Vista Hermosa', '20', 0, '2018-03-13 17:53:45', 0, '2018-03-13 17:53:45', 1),
('540', 'Villa de Tamazulápam del Progreso', '20', 0, '2018-03-13 17:53:45', 0, '2018-03-13 17:53:45', 1),
('152', 'San Francisco Tlapancingo', '20', 0, '2018-03-13 17:53:45', 0, '2018-03-13 17:53:45', 1),
('461', 'Santiago del Río', '20', 0, '2018-03-13 17:53:45', 0, '2018-03-13 17:53:45', 1),
('339', 'San Pedro y San Pablo Teposcolula', '20', 0, '2018-03-13 17:53:45', 0, '2018-03-13 17:53:45', 1),
('065', 'Ixpantepec Nieves', '20', 0, '2018-03-13 17:53:45', 0, '2018-03-13 17:53:45', 1),
('011', 'Calihualá', '20', 0, '2018-03-13 17:53:45', 0, '2018-03-13 17:53:45', 1),
('376', 'Santa Cruz de Bravo', '20', 0, '2018-03-13 17:53:45', 0, '2018-03-13 17:53:45', 1),
('081', 'San Agustín Atenango', '20', 0, '2018-03-13 17:53:45', 0, '2018-03-13 17:53:45', 1),
('230', 'San Lorenzo Victoria', '20', 0, '2018-03-13 17:53:45', 0, '2018-03-13 17:53:45', 1),
('501', 'Santiago Yucuyachi', '20', 0, '2018-03-13 17:53:45', 0, '2018-03-13 17:53:45', 1),
('537', 'Silacayoápam', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('422', 'Santa María Nativitas', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('129', 'San Cristóbal Suchixtlahuaca', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('488', 'Santiago Tepetlapa', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('287', 'San Miguel Tulancingo', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('283', 'San Miguel Tequixtepec', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('256', 'San Mateo Tlapiltepec', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('047', 'Santa Magdalena Jicotlán', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('151', 'San Francisco Teopan', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('552', 'Tlacotepec Plumas', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('464', 'Santiago Ihuitlán Plumas', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('018', 'Concepción Buenavista', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('548', 'Tepelmeme Villa de Morelos', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('176', 'San Juan Bautista Coixtlahuaca', '20', 0, '2018-03-13 17:53:44', 0, '2018-03-13 17:53:44', 1),
('524', 'Santo Domingo Yodohino', '20', 0, '2018-03-13 17:53:43', 0, '2018-03-13 17:53:43', 1),
('520', 'Santo Domingo Tonalá', '20', 0, '2018-03-13 17:53:43', 0, '2018-03-13 17:53:43', 1),
('529', 'Santos Reyes Yucuná', '20', 0, '2018-03-13 17:53:43', 0, '2018-03-13 17:53:43', 1),
('164', 'San Jorge Nuchita', '20', 0, '2018-03-13 17:53:43', 0, '2018-03-13 17:53:43', 1),
('352', 'San Simón Zahuatlán', '20', 0, '2018-03-13 17:53:43', 0, '2018-03-13 17:53:43', 1),
('237', 'San Marcos Arteaga', '20', 0, '2018-03-13 17:53:43', 0, '2018-03-13 17:53:43', 1),
('381', 'Santa Cruz Tacache de Mina', '20', 0, '2018-03-13 17:53:43', 0, '2018-03-13 17:53:43', 1),
('055', 'Mariscala de Juárez', '20', 0, '2018-03-13 17:53:43', 0, '2018-03-13 17:53:43', 1),
('261', 'San Miguel Amatitlán', '20', 0, '2018-03-13 17:53:43', 0, '2018-03-13 17:53:43', 1),
('245', 'San Martín Zacatepec', '20', 0, '2018-03-13 17:53:43', 0, '2018-03-13 17:53:43', 1),
('165', 'San José Ayuquila', '20', 0, '2018-03-13 17:53:43', 0, '2018-03-13 17:53:43', 1),
('455', 'Santiago Ayuquililla', '20', 0, '2018-03-13 17:53:43', 0, '2018-03-13 17:53:43', 1),
('032', 'Fresnillo de Trujano', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('549', 'Tezoatlán de Segura y Luna', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('183', 'San Juan Bautista Tlachichilco', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('251', 'San Mateo Nejápam', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('259', 'San Miguel Ahuehuetitlán', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('099', 'San Andrés Tepetlapa', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('034', 'Guadalupe de Ramírez', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('199', 'San Juan Ihualtepec', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('290', 'San Nicolás Hidalgo', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('186', 'San Juan Cieneguilla', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('567', 'Zapotitlán Lagunas', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('484', 'Santiago Tamazola', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('462', 'Santiago Huajolotitlán', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('400', 'Santa María Camotlán', '20', 0, '2018-03-13 17:53:42', 0, '2018-03-13 17:53:42', 1),
('004', 'Asunción Cuyotepeji', '20', 0, '2018-03-13 17:53:41', 0, '2018-03-13 17:53:41', 1),
('568', 'Zapotitlán Palmas', '20', 0, '2018-03-13 17:53:41', 0, '2018-03-13 17:53:41', 1),
('089', 'San Andrés Dinicuiti', '20', 0, '2018-03-13 17:53:41', 0, '2018-03-13 17:53:41', 1),
('456', 'Santiago Cacaloxtepec', '20', 0, '2018-03-13 17:53:41', 0, '2018-03-13 17:53:41', 1),
('160', 'San Jerónimo Silacayoapilla', '20', 0, '2018-03-13 17:53:41', 0, '2018-03-13 17:53:41', 1),
('373', 'Santa Catarina Zapoquila', '20', 0, '2018-03-13 17:53:41', 0, '2018-03-13 17:53:41', 1),
('476', 'Santiago Miltepec', '20', 0, '2018-03-13 17:53:41', 0, '2018-03-13 17:53:41', 1),
('181', 'San Juan Bautista Suchitepec', '20', 0, '2018-03-13 17:53:41', 0, '2018-03-13 17:53:41', 1),
('340', 'San Pedro y San Pablo Tequixtepec', '20', 0, '2018-03-13 17:53:41', 0, '2018-03-13 17:53:41', 1),
('459', 'Santiago Chazumba', '20', 0, '2018-03-13 17:53:41', 0, '2018-03-13 17:53:41', 1),
('022', 'Cosoltepec', '20', 0, '2018-03-13 17:53:41', 0, '2018-03-13 17:53:41', 1),
('189', 'San Juan Comaltepec', '20', 0, '2018-03-13 17:53:41', 0, '2018-03-13 17:53:41', 1),
('039', 'Heroica Ciudad de Huajuapan de León', '20', 0, '2018-03-13 17:53:41', 0, '2018-03-13 17:53:41', 1),
('212', 'San Juan Petlapa', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('498', 'Santiago Yaveo', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('205', 'San Juan Lalana', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('468', 'Santiago Jocotepec', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('460', 'Santiago Choápam', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('299', 'San Pablo Yaganiza', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('522', 'Santo Domingo Xagacía', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('303', 'San Pedro Cajonos', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('246', 'San Mateo Cajonos', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('138', 'San Francisco Cajonos', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('038', 'Villa Hidalgo', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('503', 'Santiago Zoochila', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('114', 'San Baltazar Yatzachi el Bajo', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('120', 'San Bartolomé Zoogocho', '20', 0, '2018-03-13 17:53:40', 0, '2018-03-13 17:53:40', 1),
('097', 'San Andrés Solaga', '20', 0, '2018-03-13 17:53:39', 0, '2018-03-13 17:53:39', 1),
('100', 'San Andrés Yaá', '20', 0, '2018-03-13 17:53:39', 0, '2018-03-13 17:53:39', 1),
('257', 'San Melchor Betaza', '20', 0, '2018-03-13 17:53:39', 0, '2018-03-13 17:53:39', 1),
('216', 'San Juan Tabaá', '20', 0, '2018-03-13 17:53:39', 0, '2018-03-13 17:53:39', 1),
('442', 'Santa María Yalina', '20', 0, '2018-03-13 17:53:39', 0, '2018-03-13 17:53:39', 1),
('514', 'Santo Domingo Roayaga', '20', 0, '2018-03-13 17:53:39', 0, '2018-03-13 17:53:39', 1),
('432', 'Santa María Temaxcalapa', '20', 0, '2018-03-13 17:53:39', 0, '2018-03-13 17:53:39', 1),
('201', 'San Juan Juquila Vijanos', '20', 0, '2018-03-13 17:53:39', 0, '2018-03-13 17:53:39', 1),
('128', 'San Cristóbal Lachirioag', '20', 0, '2018-03-13 17:53:39', 0, '2018-03-13 17:53:39', 1),
('541', 'Tanetze de Zaragoza', '20', 0, '2018-03-13 17:53:39', 0, '2018-03-13 17:53:39', 1),
('223', 'San Juan Yatzona', '20', 0, '2018-03-13 17:53:39', 0, '2018-03-13 17:53:39', 1),
('280', 'Villa Talea de Castro', '20', 0, '2018-03-13 17:53:39', 0, '2018-03-13 17:53:39', 1),
('457', 'Santiago Camotlán', '20', 0, '2018-03-13 17:53:38', 0, '2018-03-13 17:53:38', 1),
('471', 'Santiago Lalopa', '20', 0, '2018-03-13 17:53:39', 0, '2018-03-13 17:53:39', 1),
('222', 'San Juan Yaeé', '20', 0, '2018-03-13 17:53:38', 0, '2018-03-13 17:53:38', 1),
('473', 'Santiago Laxopa', '20', 0, '2018-03-13 17:53:38', 0, '2018-03-13 17:53:38', 1),
('156', 'San Ildefonso Villa Alta', '20', 0, '2018-03-13 17:53:38', 0, '2018-03-13 17:53:38', 1),
('443', 'Santa María Yavesía', '20', 0, '2018-03-13 17:53:38', 0, '2018-03-13 17:53:38', 1),
('262', 'San Miguel Amatlán', '20', 0, '2018-03-13 17:53:38', 0, '2018-03-13 17:53:38', 1),
('365', 'Santa Catarina Lachatao', '20', 0, '2018-03-13 17:53:38', 0, '2018-03-13 17:53:38', 1),
('288', 'San Miguel Yotao', '20', 0, '2018-03-13 17:53:38', 0, '2018-03-13 17:53:38', 1),
('363', 'Santa Catarina Ixtepeji', '20', 0, '2018-03-13 17:53:38', 0, '2018-03-13 17:53:38', 1),
('504', 'Nuevo Zoquiápam', '20', 0, '2018-03-13 17:53:38', 0, '2018-03-13 17:53:38', 1),
('496', 'Santiago Xiacuí', '20', 0, '2018-03-13 17:53:38', 0, '2018-03-13 17:53:38', 1),
('035', 'Guelatao de Juárez', '20', 0, '2018-03-13 17:53:38', 0, '2018-03-13 17:53:38', 1),
('247', 'Capulálpam de Méndez', '20', 0, '2018-03-13 17:53:38', 0, '2018-03-13 17:53:38', 1),
('191', 'San Juan Chicomezúchil', '20', 0, '2018-03-13 17:53:37', 0, '2018-03-13 17:53:37', 1),
('267', 'San Miguel del Río', '20', 0, '2018-03-13 17:53:37', 0, '2018-03-13 17:53:37', 1),
('419', 'Santa María Jaltianguis', '20', 0, '2018-03-13 17:53:37', 0, '2018-03-13 17:53:37', 1),
('359', 'Santa Ana Yareni', '20', 0, '2018-03-13 17:53:37', 0, '2018-03-13 17:53:37', 1),
('196', 'San Juan Evangelista Analco', '20', 0, '2018-03-13 17:53:37', 0, '2018-03-13 17:53:37', 1),
('335', 'San Pedro Yaneri', '20', 0, '2018-03-13 17:53:37', 0, '2018-03-13 17:53:37', 1),
('544', 'Teococuilco de Marcos Pérez', '20', 0, '2018-03-13 17:53:37', 0, '2018-03-13 17:53:37', 1),
('260', 'San Miguel Aloápam', '20', 0, '2018-03-13 17:53:37', 0, '2018-03-13 17:53:37', 1),
('042', 'Ixtlán de Juárez', '20', 0, '2018-03-13 17:53:37', 0, '2018-03-13 17:53:37', 1),
('173', 'San Juan Atepec', '20', 0, '2018-03-13 17:53:37', 0, '2018-03-13 17:53:37', 1),
('458', 'Santiago Comaltepec', '20', 0, '2018-03-13 17:53:37', 0, '2018-03-13 17:53:37', 1),
('001', 'Abejones', '20', 0, '2018-03-13 17:53:37', 0, '2018-03-13 17:53:37', 1),
('296', 'San Pablo Macuiltianguis', '20', 0, '2018-03-13 17:53:37', 0, '2018-03-13 17:53:37', 1),
('336', 'San Pedro Yólox', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('214', 'San Juan Quiotepec', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('062', 'Natividad', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('478', 'Santiago Nacaltepec', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('311', 'San Pedro Jaltepetongo', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('436', 'Santa María Texcatitlán', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('313', 'San Pedro Jocotipac', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('558', 'Valerio Trujano', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('326', 'San Pedro Sochiápam', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('220', 'San Juan Tepeuxila', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('425', 'Santa María Pápalo', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('182', 'San Juan Bautista Tlacoatzintepec', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('527', 'Santos Reyes Pápalo', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('139', 'San Francisco Chapulapa', '20', 0, '2018-03-13 17:53:35', 0, '2018-03-13 17:53:35', 1),
('019', 'Concepción Pápalo', '20', 0, '2018-03-13 17:53:36', 0, '2018-03-13 17:53:36', 1),
('098', 'San Andrés Teotilálpam', '20', 0, '2018-03-13 17:53:35', 0, '2018-03-13 17:53:35', 1),
('276', 'San Miguel Santa Flor', '20', 0, '2018-03-13 17:53:35', 0, '2018-03-13 17:53:35', 1),
('438', 'Santa María Tlalixtac', '20', 0, '2018-03-13 17:53:35', 0, '2018-03-13 17:53:35', 1),
('330', 'San Pedro Teutila', '20', 0, '2018-03-13 17:53:35', 0, '2018-03-13 17:53:35', 1),
('027', 'Chiquihuitlán de Benito Juárez', '20', 0, '2018-03-13 17:53:35', 0, '2018-03-13 17:53:35', 1),
('024', 'Cuyamecalco Villa de Zaragoza', '20', 0, '2018-03-13 17:53:35', 0, '2018-03-13 17:53:35', 1),
('355', 'Santa Ana Cuauhtémoc', '20', 0, '2018-03-13 17:53:35', 0, '2018-03-13 17:53:35', 1),
('177', 'San Juan Bautista Cuicatlán', '20', 0, '2018-03-13 17:53:35', 0, '2018-03-13 17:53:35', 1),
('416', 'Santa María Ixcatlán', '20', 0, '2018-03-13 17:53:35', 0, '2018-03-13 17:53:35', 1),
('431', 'Santa María Tecomavaca', '20', 0, '2018-03-13 17:53:35', 0, '2018-03-13 17:53:35', 1),
('206', 'San Juan de los Cués', '20', 0, '2018-03-13 17:53:35', 0, '2018-03-13 17:53:35', 1),
('058', 'Mazatlán Villa de Flores', '20', 0, '2018-03-13 17:53:35', 0, '2018-03-13 17:53:35', 1),
('116', 'San Bartolomé Ayautla', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('249', 'San Mateo Yoloxochitlán', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('171', 'San José Tenango', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('109', 'San Antonio Nanahuatípam', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('234', 'San Lucas Zoquiápam', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('040', 'Huautepec', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('187', 'San Juan Coatzóspam', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('163', 'San Jerónimo Tecóatl', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('396', 'Santa María la Asunción', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('244', 'San Martín Toxpalan', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('490', 'Santiago Texcalcingo', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('545', 'Teotitlán de Flores Magón', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('434', 'Santa María Teopoxco', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('029', 'Eloxochitlán de Flores Magón', '20', 0, '2018-03-13 17:53:34', 0, '2018-03-13 17:53:34', 1),
('374', 'Santa Cruz Acatepec', '20', 0, '2018-03-13 17:53:33', 0, '2018-03-13 17:53:33', 1),
('322', 'San Pedro Ocopetatillo', '20', 0, '2018-03-13 17:53:33', 0, '2018-03-13 17:53:33', 1),
('142', 'San Francisco Huehuetlán', '20', 0, '2018-03-13 17:53:33', 0, '2018-03-13 17:53:33', 1),
('228', 'San Lorenzo Cuaunecuiltitla', '20', 0, '2018-03-13 17:53:33', 0, '2018-03-13 17:53:33', 1),
('354', 'Santa Ana Ateixtlahuaca', '20', 0, '2018-03-13 17:53:33', 0, '2018-03-13 17:53:33', 1),
('041', 'Huautla de Jiménez', '20', 0, '2018-03-13 17:53:33', 0, '2018-03-13 17:53:33', 1),
('406', 'Santa María Chilchotla', '20', 0, '2018-03-13 17:53:33', 0, '2018-03-13 17:53:33', 1),
('136', 'San Felipe Usila', '20', 0, '2018-03-13 17:53:33', 0, '2018-03-13 17:53:33', 1),
('559', 'San Juan Bautista Valle Nacional', '20', 0, '2018-03-13 17:53:33', 0, '2018-03-13 17:53:33', 1),
('232', 'San Lucas Ojitlán', '20', 0, '2018-03-13 17:53:33', 0, '2018-03-13 17:53:33', 1),
('417', 'Santa María Jacatepec', '20', 0, '2018-03-13 17:53:33', 0, '2018-03-13 17:53:33', 1),
('166', 'San José Chiltepec', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('134', 'San Felipe Jalapa de Díaz', '20', 0, '2018-03-13 17:53:33', 0, '2018-03-13 17:53:33', 1),
('309', 'San Pedro Ixcatlán', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('009', 'Ayotzintepec', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('002', 'Acatlán de Pérez Figueroa', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('278', 'San Miguel Soyaltepec', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('021', 'Cosolapa', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('044', 'Loma Bonita', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('169', 'San José Independencia', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('409', 'Santa María del Tule', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('184', 'San Juan Bautista Tuxtepec', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('519', 'Santo Domingo Tomaltepec', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('087', 'San Agustín Yatareni', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('091', 'San Andrés Huayápam', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('157', 'San Jacinto Amilpas', '20', 0, '2018-03-13 17:53:32', 0, '2018-03-13 17:53:32', 1),
('553', 'Tlalixtac de Cabrera', '20', 0, '2018-03-13 17:53:31', 0, '2018-03-13 17:53:31', 1),
('426', 'Santa María Peñoles', '20', 0, '2018-03-13 17:53:31', 0, '2018-03-13 17:53:31', 1),
('494', 'Santiago Tlazoyaltepec', '20', 0, '2018-03-13 17:53:31', 0, '2018-03-13 17:53:31', 1),
('227', 'San Lorenzo Cacaotepec', '20', 0, '2018-03-13 17:53:31', 0, '2018-03-13 17:53:31', 1),
('033', 'Guadalupe Etla', '20', 0, '2018-03-13 17:53:31', 0, '2018-03-13 17:53:31', 1),
('135', 'San Felipe Tejalápam', '20', 0, '2018-03-13 17:53:31', 0, '2018-03-13 17:53:31', 1),
('293', 'San Pablo Etla', '20', 0, '2018-03-13 17:53:31', 0, '2018-03-13 17:53:31', 1),
('531', 'Santo Tomás Mazaltepec', '20', 0, '2018-03-13 17:53:31', 0, '2018-03-13 17:53:31', 1),
('084', 'San Agustín Etla', '20', 0, '2018-03-13 17:53:31', 0, '2018-03-13 17:53:31', 1),
('539', 'Soledad Etla', '20', 0, '2018-03-13 17:53:31', 0, '2018-03-13 17:53:31', 1),
('063', 'Nazareno Etla', '20', 0, '2018-03-13 17:53:31', 0, '2018-03-13 17:53:31', 1),
('102', 'San Andrés Zautla', '20', 0, '2018-03-13 17:53:31', 0, '2018-03-13 17:53:31', 1),
('077', 'Reyes Etla', '20', 0, '2018-03-13 17:53:31', 0, '2018-03-13 17:53:31', 1),
('178', 'San Juan Bautista Guelache', '20', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('483', 'Santiago Suchilquitongo', '20', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('193', 'San Juan del Estado', '20', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('045', 'Magdalena Apasco', '20', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('294', 'San Pablo Huitzo', '20', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('487', 'Santiago Tenango', '20', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('179', 'San Juan Bautista Jayacatlán', '20', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('150', 'San Francisco Telixtlahuaca', '20', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('161', 'San Jerónimo Sosola', '20', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('175', 'San Juan Bautista Atatlahuca', '20', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('338', 'Villa de Etla', '20', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('067', 'Oaxaca de Juárez', '20', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('036', 'Mier y Noriega', '19', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('024', 'General Zaragoza', '19', 0, '2018-03-13 17:53:30', 0, '2018-03-13 17:53:30', 1),
('007', 'Aramberri', '19', 0, '2018-03-13 17:53:29', 0, '2018-03-13 17:53:29', 1),
('029', 'Hualahuises', '19', 0, '2018-03-13 17:53:29', 0, '2018-03-13 17:53:29', 1),
('014', 'Doctor Arroyo', '19', 0, '2018-03-13 17:53:29', 0, '2018-03-13 17:53:29', 1),
('017', 'Galeana', '19', 0, '2018-03-13 17:53:29', 0, '2018-03-13 17:53:29', 1),
('030', 'Iturbide', '19', 0, '2018-03-13 17:53:29', 0, '2018-03-13 17:53:29', 1),
('033', 'Linares', '19', 0, '2018-03-13 17:53:29', 0, '2018-03-13 17:53:29', 1),
('043', 'Rayones', '19', 0, '2018-03-13 17:53:29', 0, '2018-03-13 17:53:29', 1),
('038', 'Montemorelos', '19', 0, '2018-03-13 17:53:29', 0, '2018-03-13 17:53:29', 1),
('009', 'Cadereyta Jiménez', '19', 0, '2018-03-13 17:53:29', 0, '2018-03-13 17:53:29', 1),
('022', 'General Terán', '19', 0, '2018-03-13 17:53:29', 0, '2018-03-13 17:53:29', 1),
('004', 'Allende', '19', 0, '2018-03-13 17:53:29', 0, '2018-03-13 17:53:29', 1),
('049', 'Santiago', '19', 0, '2018-03-13 17:53:29', 0, '2018-03-13 17:53:29', 1),
('031', 'Juárez', '19', 0, '2018-03-13 17:53:29', 0, '2018-03-13 17:53:29', 1),
('026', 'Guadalupe', '19', 0, '2018-03-13 17:53:28', 0, '2018-03-13 17:53:28', 1),
('013', 'China', '19', 0, '2018-03-13 17:53:28', 0, '2018-03-13 17:53:28', 1),
('020', 'General Bravo', '19', 0, '2018-03-13 17:53:28', 0, '2018-03-13 17:53:28', 1),
('015', 'Doctor Coss', '19', 0, '2018-03-13 17:53:28', 0, '2018-03-13 17:53:28', 1),
('003', 'Los Aldamas', '19', 0, '2018-03-13 17:53:28', 0, '2018-03-13 17:53:28', 1),
('027', 'Los Herreras', '19', 0, '2018-03-13 17:53:28', 0, '2018-03-13 17:53:28', 1),
('042', 'Los Ramones', '19', 0, '2018-03-13 17:53:28', 0, '2018-03-13 17:53:28', 1),
('016', 'Doctor González', '19', 0, '2018-03-13 17:53:28', 0, '2018-03-13 17:53:28', 1),
('034', 'Marín', '19', 0, '2018-03-13 17:53:28', 0, '2018-03-13 17:53:28', 1),
('041', 'Pesquería', '19', 0, '2018-03-13 17:53:28', 0, '2018-03-13 17:53:28', 1),
('006', 'Apodaca', '19', 0, '2018-03-13 17:53:28', 0, '2018-03-13 17:53:28', 1),
('010', 'El Carmen', '19', 0, '2018-03-13 17:53:28', 0, '2018-03-13 17:53:28', 1),
('046', 'San Nicolás de los Garza', '19', 0, '2018-03-13 17:53:27', 0, '2018-03-13 17:53:27', 1),
('019', 'San Pedro Garza García', '19', 0, '2018-03-13 17:53:27', 0, '2018-03-13 17:53:27', 1),
('018', 'García', '19', 0, '2018-03-13 17:53:27', 0, '2018-03-13 17:53:27', 1),
('021', 'General Escobedo', '19', 0, '2018-03-13 17:53:27', 0, '2018-03-13 17:53:27', 1),
('048', 'Santa Catarina', '19', 0, '2018-03-13 17:53:27', 0, '2018-03-13 17:53:27', 1),
('035', 'Melchor Ocampo', '19', 0, '2018-03-13 17:53:27', 0, '2018-03-13 17:53:27', 1),
('011', 'Cerralvo', '19', 0, '2018-03-13 17:53:27', 0, '2018-03-13 17:53:27', 1),
('023', 'General Treviño', '19', 0, '2018-03-13 17:53:27', 0, '2018-03-13 17:53:27', 1),
('002', 'Agualeguas', '19', 0, '2018-03-13 17:53:27', 0, '2018-03-13 17:53:27', 1),
('025', 'General Zuazua', '19', 0, '2018-03-13 17:53:27', 0, '2018-03-13 17:53:27', 1),
('028', 'Higueras', '19', 0, '2018-03-13 17:53:27', 0, '2018-03-13 17:53:27', 1),
('001', 'Abasolo', '19', 0, '2018-03-13 17:53:27', 0, '2018-03-13 17:53:27', 1),
('047', 'Hidalgo', '19', 0, '2018-03-13 17:53:27', 0, '2018-03-13 17:53:27', 1),
('012', 'Ciénega de Flores', '19', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('045', 'Salinas Victoria', '19', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('040', 'Parás', '19', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('050', 'Vallecillo', '19', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('051', 'Villaldama', '19', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('044', 'Sabinas Hidalgo', '19', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('008', 'Bustamante', '19', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('037', 'Mina', '19', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('032', 'Lampazos de Naranjo', '19', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('005', 'Anáhuac', '19', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('039', 'Monterrey', '19', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('003', 'Amatlán de Cañas', '18', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('006', 'Ixtlán del Río', '18', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('002', 'Ahuacatlán', '18', 0, '2018-03-13 17:53:26', 0, '2018-03-13 17:53:26', 1),
('007', 'Jala', '18', 0, '2018-03-13 17:53:25', 0, '2018-03-13 17:53:25', 1),
('014', 'Santa María del Oro', '18', 0, '2018-03-13 17:53:25', 0, '2018-03-13 17:53:25', 1),
('013', 'San Pedro Lagunillas', '18', 0, '2018-03-13 17:53:25', 0, '2018-03-13 17:53:25', 1),
('008', 'Xalisco', '18', 0, '2018-03-13 17:53:25', 0, '2018-03-13 17:53:25', 1),
('012', 'San Blas', '18', 0, '2018-03-13 17:53:25', 0, '2018-03-13 17:53:25', 1),
('020', 'Bahía de Banderas', '18', 0, '2018-03-13 17:53:25', 0, '2018-03-13 17:53:25', 1),
('004', 'Compostela', '18', 0, '2018-03-13 17:53:25', 0, '2018-03-13 17:53:25', 1),
('010', 'Rosamorada', '18', 0, '2018-03-13 17:53:25', 0, '2018-03-13 17:53:25', 1),
('011', 'Ruíz', '18', 0, '2018-03-13 17:53:25', 0, '2018-03-13 17:53:25', 1),
('019', 'La Yesca', '18', 0, '2018-03-13 17:53:25', 0, '2018-03-13 17:53:25', 1),
('009', 'Del Nayar', '18', 0, '2018-03-13 17:53:25', 0, '2018-03-13 17:53:25', 1),
('005', 'Huajicori', '18', 0, '2018-03-13 17:53:25', 0, '2018-03-13 17:53:25', 1),
('016', 'Tecuala', '18', 0, '2018-03-13 17:53:25', 0, '2018-03-13 17:53:25', 1),
('001', 'Acaponeta', '18', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('015', 'Santiago Ixcuintla', '18', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('018', 'Tuxpan', '18', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('017', 'Tepic', '18', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('025', 'Tlaquiltenango', '17', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('010', 'Jantetelco', '17', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('003', 'Axochiapan', '17', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('013', 'Jonacatepec de Leandro Valle', '17', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('019', 'Tepalcingo', '17', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('012', 'Jojutla', '17', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('032', 'Zacualpan de Amilpas', '17', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('033', 'Temoac', '17', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('016', 'Ocuituco', '17', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('002', 'Atlatlahucan', '17', 0, '2018-03-13 17:53:24', 0, '2018-03-13 17:53:24', 1),
('027', 'Totolapan', '17', 0, '2018-03-13 17:53:23', 0, '2018-03-13 17:53:23', 1),
('030', 'Yecapixtla', '17', 0, '2018-03-13 17:53:23', 0, '2018-03-13 17:53:23', 1),
('022', 'Tetela del Volcán', '17', 0, '2018-03-13 17:53:23', 0, '2018-03-13 17:53:23', 1),
('031', 'Zacatepec', '17', 0, '2018-03-13 17:53:23', 0, '2018-03-13 17:53:23', 1),
('028', 'Xochitepec', '17', 0, '2018-03-13 17:53:23', 0, '2018-03-13 17:53:23', 1),
('024', 'Tlaltizapán de Zapata', '17', 0, '2018-03-13 17:53:23', 0, '2018-03-13 17:53:23', 1),
('008', 'Emiliano Zapata', '17', 0, '2018-03-13 17:53:23', 0, '2018-03-13 17:53:23', 1),
('006', 'Cuautla', '17', 0, '2018-03-13 17:53:23', 0, '2018-03-13 17:53:23', 1),
('029', 'Yautepec', '17', 0, '2018-03-13 17:53:23', 0, '2018-03-13 17:53:23', 1),
('004', 'Ayala', '17', 0, '2018-03-13 17:53:23', 0, '2018-03-13 17:53:23', 1),
('017', 'Puente de Ixtla', '17', 0, '2018-03-13 17:53:23', 0, '2018-03-13 17:53:23', 1),
('014', 'Mazatepec', '17', 0, '2018-03-13 17:53:23', 0, '2018-03-13 17:53:23', 1),
('001', 'Amacuzac', '17', 0, '2018-03-13 17:53:23', 0, '2018-03-13 17:53:23', 1),
('021', 'Tetecala', '17', 0, '2018-03-13 17:53:22', 0, '2018-03-13 17:53:22', 1),
('005', 'Coatlán del Río', '17', 0, '2018-03-13 17:53:22', 0, '2018-03-13 17:53:22', 1),
('015', 'Miacatlán', '17', 0, '2018-03-13 17:53:22', 0, '2018-03-13 17:53:22', 1),
('011', 'Jiutepec', '17', 0, '2018-03-13 17:53:22', 0, '2018-03-13 17:53:22', 1),
('018', 'Temixco', '17', 0, '2018-03-13 17:53:22', 0, '2018-03-13 17:53:22', 1),
('026', 'Tlayacapan', '17', 0, '2018-03-13 17:53:22', 0, '2018-03-13 17:53:22', 1),
('023', 'Tlalnepantla', '17', 0, '2018-03-13 17:53:22', 0, '2018-03-13 17:53:22', 1),
('020', 'Tepoztlán', '17', 0, '2018-03-13 17:53:22', 0, '2018-03-13 17:53:22', 1),
('009', 'Huitzilac', '17', 0, '2018-03-13 17:53:22', 0, '2018-03-13 17:53:22', 1),
('007', 'Cuernavaca', '17', 0, '2018-03-13 17:53:22', 0, '2018-03-13 17:53:22', 1),
('077', 'San Lucas', '16', 0, '2018-03-13 17:53:22', 0, '2018-03-13 17:53:22', 1),
('038', 'Huetamo', '16', 0, '2018-03-13 17:53:22', 0, '2018-03-13 17:53:22', 1),
('013', 'Carácuaro', '16', 0, '2018-03-13 17:53:22', 0, '2018-03-13 17:53:22', 1),
('057', 'Nocupétaro', '16', 0, '2018-03-13 17:53:21', 0, '2018-03-13 17:53:21', 1),
('029', 'Churumuco', '16', 0, '2018-03-13 17:53:21', 0, '2018-03-13 17:53:21', 1),
('035', 'La Huacana', '16', 0, '2018-03-13 17:53:21', 0, '2018-03-13 17:53:21', 1),
('009', 'Ario', '16', 0, '2018-03-13 17:53:21', 0, '2018-03-13 17:53:21', 1),
('079', 'Salvador Escalante', '16', 0, '2018-03-13 17:53:21', 0, '2018-03-13 17:53:21', 1),
('033', 'Gabriel Zamora', '16', 0, '2018-03-13 17:53:21', 0, '2018-03-13 17:53:21', 1),
('055', 'Múgica', '16', 0, '2018-03-13 17:53:21', 0, '2018-03-13 17:53:21', 1),
('059', 'Nuevo Urecho', '16', 0, '2018-03-13 17:53:21', 0, '2018-03-13 17:53:21', 1),
('087', 'Taretan', '16', 0, '2018-03-13 17:53:21', 0, '2018-03-13 17:53:21', 1),
('111', 'Ziracuaretiro', '16', 0, '2018-03-13 17:53:21', 0, '2018-03-13 17:53:21', 1),
('097', 'Turicato', '16', 0, '2018-03-13 17:53:21', 0, '2018-03-13 17:53:21', 1),
('082', 'Tacámbaro', '16', 0, '2018-03-13 17:53:21', 0, '2018-03-13 17:53:21', 1),
('039', 'Huiramba', '16', 0, '2018-03-13 17:53:21', 0, '2018-03-13 17:53:21', 1),
('032', 'Erongarícuaro', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('066', 'Pátzcuaro', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('081', 'Susupuato', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('046', 'Juárez', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('099', 'Tuzantla', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('112', 'Zitácuaro', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('047', 'Jungapeo', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('061', 'Ocampo', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('098', 'Tuxpan', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('005', 'Angangueo', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('007', 'Aporo', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('080', 'Senguio', '16', 0, '2018-03-13 17:53:19', 0, '2018-03-13 17:53:19', 1),
('022', 'Charo', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('101', 'Tzitzio', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('092', 'Tiquicheo de Nicolás Romero', '16', 0, '2018-03-13 17:53:20', 0, '2018-03-13 17:53:20', 1),
('041', 'Irimbo', '16', 0, '2018-03-13 17:53:19', 0, '2018-03-13 17:53:19', 1),
('050', 'Maravatío', '16', 0, '2018-03-13 17:53:19', 0, '2018-03-13 17:53:19', 1),
('034', 'Hidalgo', '16', 0, '2018-03-13 17:53:19', 0, '2018-03-13 17:53:19', 1),
('093', 'Tlalpujahua', '16', 0, '2018-03-13 17:53:19', 0, '2018-03-13 17:53:19', 1),
('017', 'Contepec', '16', 0, '2018-03-13 17:53:19', 0, '2018-03-13 17:53:19', 1),
('031', 'Epitacio Huerta', '16', 0, '2018-03-13 17:53:19', 0, '2018-03-13 17:53:19', 1),
('052', 'Lázaro Cárdenas', '16', 0, '2018-03-13 17:53:19', 0, '2018-03-13 17:53:19', 1),
('010', 'Arteaga', '16', 0, '2018-03-13 17:53:19', 0, '2018-03-13 17:53:19', 1),
('096', 'Tumbiscatío', '16', 0, '2018-03-13 17:53:19', 0, '2018-03-13 17:53:19', 1),
('008', 'Aquila', '16', 0, '2018-03-13 17:53:19', 0, '2018-03-13 17:53:19', 1),
('015', 'Coalcomán de Vázquez Pallares', '16', 0, '2018-03-13 17:53:19', 0, '2018-03-13 17:53:19', 1),
('026', 'Chinicuila', '16', 0, '2018-03-13 17:53:19', 0, '2018-03-13 17:53:19', 1),
('014', 'Coahuayana', '16', 0, '2018-03-13 17:53:18', 0, '2018-03-13 17:53:18', 1),
('064', 'Parácuaro', '16', 0, '2018-03-13 17:53:18', 0, '2018-03-13 17:53:18', 1),
('006', 'Apatzingán', '16', 0, '2018-03-13 17:53:18', 0, '2018-03-13 17:53:18', 1),
('002', 'Aguililla', '16', 0, '2018-03-13 17:53:18', 0, '2018-03-13 17:53:18', 1),
('089', 'Tepalcatepec', '16', 0, '2018-03-13 17:53:18', 0, '2018-03-13 17:53:18', 1),
('012', 'Buenavista', '16', 0, '2018-03-13 17:53:18', 0, '2018-03-13 17:53:18', 1),
('083', 'Tancítaro', '16', 0, '2018-03-13 17:53:18', 0, '2018-03-13 17:53:18', 1),
('058', 'Nuevo Parangaricutiro', '16', 0, '2018-03-13 17:53:18', 0, '2018-03-13 17:53:18', 1),
('068', 'Peribán', '16', 0, '2018-03-13 17:53:18', 0, '2018-03-13 17:53:18', 1),
('075', 'Los Reyes', '16', 0, '2018-03-13 17:53:18', 0, '2018-03-13 17:53:18', 1),
('090', 'Tingambato', '16', 0, '2018-03-13 17:53:18', 0, '2018-03-13 17:53:18', 1),
('056', 'Nahuatzen', '16', 0, '2018-03-13 17:53:18', 0, '2018-03-13 17:53:18', 1),
('024', 'Cherán', '16', 0, '2018-03-13 17:53:18', 0, '2018-03-13 17:53:18', 1),
('065', 'Paracho', '16', 0, '2018-03-13 17:53:17', 0, '2018-03-13 17:53:17', 1),
('021', 'Charapan', '16', 0, '2018-03-13 17:53:17', 0, '2018-03-13 17:53:17', 1),
('102', 'Uruapan', '16', 0, '2018-03-13 17:53:17', 0, '2018-03-13 17:53:17', 1),
('091', 'Tingüindín', '16', 0, '2018-03-13 17:53:17', 0, '2018-03-13 17:53:17', 1),
('095', 'Tocumbo', '16', 0, '2018-03-13 17:53:17', 0, '2018-03-13 17:53:17', 1),
('019', 'Cotija', '16', 0, '2018-03-13 17:53:17', 0, '2018-03-13 17:53:17', 1),
('084', 'Tangamandapio', '16', 0, '2018-03-13 17:53:17', 0, '2018-03-13 17:53:17', 1),
('043', 'Jacona', '16', 0, '2018-03-13 17:53:17', 0, '2018-03-13 17:53:17', 1),
('025', 'Chilchota', '16', 0, '2018-03-13 17:53:17', 0, '2018-03-13 17:53:17', 1),
('085', 'Tangancícuaro', '16', 0, '2018-03-13 17:53:17', 0, '2018-03-13 17:53:17', 1),
('030', 'Ecuandureo', '16', 0, '2018-03-13 17:53:17', 0, '2018-03-13 17:53:17', 1),
('108', 'Zamora', '16', 0, '2018-03-13 17:53:17', 0, '2018-03-13 17:53:17', 1),
('023', 'Chavinda', '16', 0, '2018-03-13 17:53:17', 0, '2018-03-13 17:53:17', 1),
('104', 'Villamar', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('045', 'Jiquilpan', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('109', 'Zináparo', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('067', 'Penjamillo', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('051', 'Marcos Castellanos', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('028', 'Churintzio', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('060', 'Numarán', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('069', 'La Piedad', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('042', 'Ixtlán', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('106', 'Yurécuaro', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('086', 'Tanhuato', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('105', 'Vista Hermosa', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('062', 'Pajacuarán', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('103', 'Venustiano Carranza', '16', 0, '2018-03-13 17:53:16', 0, '2018-03-13 17:53:16', 1),
('074', 'Cojumatlán de Régules', '16', 0, '2018-03-13 17:53:15', 0, '2018-03-13 17:53:15', 1),
('011', 'Briseñas', '16', 0, '2018-03-13 17:53:15', 0, '2018-03-13 17:53:15', 1),
('076', 'Sahuayo', '16', 0, '2018-03-13 17:53:15', 0, '2018-03-13 17:53:15', 1),
('072', 'Queréndaro', '16', 0, '2018-03-13 17:53:15', 0, '2018-03-13 17:53:15', 1),
('040', 'Indaparapeo', '16', 0, '2018-03-13 17:53:15', 0, '2018-03-13 17:53:15', 1),
('110', 'Zinapécuaro', '16', 0, '2018-03-13 17:53:15', 0, '2018-03-13 17:53:15', 1),
('003', 'Álvaro Obregón', '16', 0, '2018-03-13 17:53:15', 0, '2018-03-13 17:53:15', 1),
('078', 'Santa Ana Maya', '16', 0, '2018-03-13 17:53:15', 0, '2018-03-13 17:53:15', 1),
('088', 'Tarímbaro', '16', 0, '2018-03-13 17:53:15', 0, '2018-03-13 17:53:15', 1),
('018', 'Copándaro', '16', 0, '2018-03-13 17:53:15', 0, '2018-03-13 17:53:15', 1),
('027', 'Chucándiro', '16', 0, '2018-03-13 17:53:15', 0, '2018-03-13 17:53:15', 1),
('020', 'Cuitzeo', '16', 0, '2018-03-13 17:53:15', 0, '2018-03-13 17:53:15', 1),
('036', 'Huandacareo', '16', 0, '2018-03-13 17:53:15', 0, '2018-03-13 17:53:15', 1),
('054', 'Morelos', '16', 0, '2018-03-13 17:53:14', 0, '2018-03-13 17:53:14', 1),
('044', 'Jiménez', '16', 0, '2018-03-13 17:53:14', 0, '2018-03-13 17:53:14', 1),
('070', 'Purépero', '16', 0, '2018-03-13 17:53:14', 0, '2018-03-13 17:53:14', 1),
('094', 'Tlazazalca', '16', 0, '2018-03-13 17:53:14', 0, '2018-03-13 17:53:14', 1),
('107', 'Zacapu', '16', 0, '2018-03-13 17:53:14', 0, '2018-03-13 17:53:14', 1),
('063', 'Panindícuaro', '16', 0, '2018-03-13 17:53:14', 0, '2018-03-13 17:53:14', 1),
('004', 'Angamacutiro', '16', 0, '2018-03-13 17:53:14', 0, '2018-03-13 17:53:14', 1),
('113', 'José Sixto Verduzco', '16', 0, '2018-03-13 17:53:14', 0, '2018-03-13 17:53:14', 1),
('071', 'Puruándiro', '16', 0, '2018-03-13 17:53:14', 0, '2018-03-13 17:53:14', 1),
('049', 'Madero', '16', 0, '2018-03-13 17:53:14', 0, '2018-03-13 17:53:14', 1),
('001', 'Acuitzio', '16', 0, '2018-03-13 17:53:14', 0, '2018-03-13 17:53:14', 1),
('048', 'Lagunillas', '16', 0, '2018-03-13 17:53:14', 0, '2018-03-13 17:53:14', 1),
('100', 'Tzintzuntzan', '16', 0, '2018-03-13 17:53:14', 0, '2018-03-13 17:53:14', 1),
('073', 'Quiroga', '16', 0, '2018-03-13 17:53:13', 0, '2018-03-13 17:53:13', 1),
('016', 'Coeneo', '16', 0, '2018-03-13 17:53:13', 0, '2018-03-13 17:53:13', 1),
('037', 'Huaniqueo', '16', 0, '2018-03-13 17:53:13', 0, '2018-03-13 17:53:13', 1),
('053', 'Morelia', '16', 0, '2018-03-13 17:53:13', 0, '2018-03-13 17:53:13', 1),
('058', 'Nezahualcóyotl', '15', 0, '2018-03-13 17:53:13', 0, '2018-03-13 17:53:13', 1),
('034', 'Ecatzingo', '15', 0, '2018-03-13 17:53:13', 0, '2018-03-13 17:53:13', 1),
('015', 'Atlautla', '15', 0, '2018-03-13 17:53:13', 0, '2018-03-13 17:53:13', 1),
('009', 'Amecameca', '15', 0, '2018-03-13 17:53:13', 0, '2018-03-13 17:53:13', 1),
('094', 'Tepetlixpa', '15', 0, '2018-03-13 17:53:13', 0, '2018-03-13 17:53:13', 1),
('068', 'Ozumba', '15', 0, '2018-03-13 17:53:13', 0, '2018-03-13 17:53:13', 1),
('050', 'Juchitepec', '15', 0, '2018-03-13 17:53:13', 0, '2018-03-13 17:53:13', 1),
('089', 'Tenango del Aire', '15', 0, '2018-03-13 17:53:13', 0, '2018-03-13 17:53:13', 1),
('017', 'Ayapango', '15', 0, '2018-03-13 17:53:13', 0, '2018-03-13 17:53:13', 1),
('103', 'Tlalmanalco', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('022', 'Cocotitlán', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('083', 'Temamatla', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('122', 'Valle de Chalco Solidaridad', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('070', 'La Paz', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('039', 'Ixtapaluca', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('025', 'Chalco', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('029', 'Chicoloapan', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('031', 'Chimalhuacán', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('011', 'Atenco', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('030', 'Chiconcuac', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('099', 'Texcoco', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('093', 'Tepetlaoxtoc', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('069', 'Papalotla', '15', 0, '2018-03-13 17:53:12', 0, '2018-03-13 17:53:12', 1),
('028', 'Chiautla', '15', 0, '2018-03-13 17:53:11', 0, '2018-03-13 17:53:11', 1),
('100', 'Tezoyuca', '15', 0, '2018-03-13 17:53:11', 0, '2018-03-13 17:53:11', 1),
('084', 'Temascalapa', '15', 0, '2018-03-13 17:53:11', 0, '2018-03-13 17:53:11', 1),
('061', 'Nopaltepec', '15', 0, '2018-03-13 17:53:11', 0, '2018-03-13 17:53:11', 1),
('016', 'Axapusco', '15', 0, '2018-03-13 17:53:11', 0, '2018-03-13 17:53:11', 1),
('065', 'Otumba', '15', 0, '2018-03-13 17:53:11', 0, '2018-03-13 17:53:11', 1),
('002', 'Acolman', '15', 0, '2018-03-13 17:53:11', 0, '2018-03-13 17:53:11', 1),
('075', 'San Martín de las Pirámides', '15', 0, '2018-03-13 17:53:11', 0, '2018-03-13 17:53:11', 1),
('092', 'Teotihuacán', '15', 0, '2018-03-13 17:53:11', 0, '2018-03-13 17:53:11', 1),
('059', 'Nextlalpan', '15', 0, '2018-03-13 17:53:11', 0, '2018-03-13 17:53:11', 1),
('125', 'Tonanitla', '15', 0, '2018-03-13 17:53:11', 0, '2018-03-13 17:53:11', 1),
('044', 'Jaltenco', '15', 0, '2018-03-13 17:53:11', 0, '2018-03-13 17:53:11', 1),
('081', 'Tecámac', '15', 0, '2018-03-13 17:53:11', 0, '2018-03-13 17:53:11', 1),
('020', 'Coacalco de Berriozábal', '15', 0, '2018-03-13 17:53:10', 0, '2018-03-13 17:53:10', 1),
('096', 'Tequixquiac', '15', 0, '2018-03-13 17:53:10', 0, '2018-03-13 17:53:10', 1),
('036', 'Hueypoxtla', '15', 0, '2018-03-13 17:53:10', 0, '2018-03-13 17:53:10', 1),
('010', 'Apaxco', '15', 0, '2018-03-13 17:53:10', 0, '2018-03-13 17:53:10', 1),
('120', 'Zumpango', '15', 0, '2018-03-13 17:53:10', 0, '2018-03-13 17:53:10', 1),
('033', 'Ecatepec de Morelos', '15', 0, '2018-03-13 17:53:10', 0, '2018-03-13 17:53:10', 1),
('108', 'Tultepec', '15', 0, '2018-03-13 17:53:10', 0, '2018-03-13 17:53:10', 1),
('109', 'Tultitlán', '15', 0, '2018-03-13 17:53:10', 0, '2018-03-13 17:53:10', 1),
('053', 'Melchor Ocampo', '15', 0, '2018-03-13 17:53:10', 0, '2018-03-13 17:53:10', 1),
('024', 'Cuautitlán', '15', 0, '2018-03-13 17:53:10', 0, '2018-03-13 17:53:10', 1),
('091', 'Teoloyucan', '15', 0, '2018-03-13 17:53:10', 0, '2018-03-13 17:53:10', 1),
('121', 'Cuautitlán Izcalli', '15', 0, '2018-03-13 17:53:10', 0, '2018-03-13 17:53:10', 1),
('023', 'Coyotepec', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1),
('035', 'Huehuetoca', '15', 0, '2018-03-13 17:53:10', 0, '2018-03-13 17:53:10', 1),
('095', 'Tepotzotlán', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1),
('046', 'Jilotzingo', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1),
('038', 'Isidro Fabela', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1),
('060', 'Nicolás Romero', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1),
('026', 'Chapa de Mota', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1),
('079', 'Soyaniquilpan de Juárez', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1),
('112', 'Villa del Carbón', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1),
('045', 'Jilotepec', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1),
('071', 'Polotitlán', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1);
INSERT INTO `ciudad` (`Clave_Ciudad`, `Nombre`, `Clave_Estado`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Estatus`) VALUES
('104', 'Tlalnepantla de Baz', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1),
('057', 'Naucalpan de Juárez', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1),
('013', 'Atizapán de Zaragoza', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1),
('037', 'Huixquilucan', '15', 0, '2018-03-13 17:53:09', 0, '2018-03-13 17:53:09', 1),
('062', 'Ocoyoacac', '15', 0, '2018-03-13 17:53:08', 0, '2018-03-13 17:53:08', 1),
('019', 'Capulhuac', '15', 0, '2018-03-13 17:53:08', 0, '2018-03-13 17:53:08', 1),
('043', 'Xalatlaco', '15', 0, '2018-03-13 17:53:08', 0, '2018-03-13 17:53:08', 1),
('101', 'Tianguistenco', '15', 0, '2018-03-13 17:53:08', 0, '2018-03-13 17:53:08', 1),
('098', 'Texcalyacac', '15', 0, '2018-03-13 17:53:08', 0, '2018-03-13 17:53:08', 1),
('006', 'Almoloya del Río', '15', 0, '2018-03-13 17:53:08', 0, '2018-03-13 17:53:08', 1),
('012', 'Atizapán', '15', 0, '2018-03-13 17:53:08', 0, '2018-03-13 17:53:08', 1),
('063', 'Ocuilan', '15', 0, '2018-03-13 17:53:08', 0, '2018-03-13 17:53:08', 1),
('052', 'Malinalco', '15', 0, '2018-03-13 17:53:08', 0, '2018-03-13 17:53:08', 1),
('088', 'Tenancingo', '15', 0, '2018-03-13 17:53:08', 0, '2018-03-13 17:53:08', 1),
('049', 'Joquicingo', '15', 0, '2018-03-13 17:53:08', 0, '2018-03-13 17:53:08', 1),
('072', 'Rayón', '15', 0, '2018-03-13 17:53:08', 0, '2018-03-13 17:53:08', 1),
('090', 'Tenango del Valle', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('073', 'San Antonio la Isla', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('027', 'Chapultepec', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('018', 'Calimaya', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('055', 'Mexicaltzingo', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('054', 'Metepec', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('076', 'San Mateo Atenco', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('067', 'Otzolotepec', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('115', 'Xonacatlán', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('051', 'Lerma', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('119', 'Zumpahuacán', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('107', 'Tonatico', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('040', 'Ixtapan de la Sal', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('004', 'Almoloya de Alquisiras', '15', 0, '2018-03-13 17:53:07', 0, '2018-03-13 17:53:07', 1),
('117', 'Zacualpan', '15', 0, '2018-03-13 17:53:06', 0, '2018-03-13 17:53:06', 1),
('021', 'Coatepec Harinas', '15', 0, '2018-03-13 17:53:06', 0, '2018-03-13 17:53:06', 1),
('113', 'Villa Guerrero', '15', 0, '2018-03-13 17:53:06', 0, '2018-03-13 17:53:06', 1),
('097', 'Texcaltitlán', '15', 0, '2018-03-13 17:53:06', 0, '2018-03-13 17:53:06', 1),
('080', 'Sultepec', '15', 0, '2018-03-13 17:53:06', 0, '2018-03-13 17:53:06', 1),
('105', 'Tlatlaya', '15', 0, '2018-03-13 17:53:06', 0, '2018-03-13 17:53:06', 1),
('008', 'Amatepec', '15', 0, '2018-03-13 17:53:06', 0, '2018-03-13 17:53:06', 1),
('077', 'San Simón de Guerrero', '15', 0, '2018-03-13 17:53:06', 0, '2018-03-13 17:53:06', 1),
('123', 'Luvianos', '15', 0, '2018-03-13 17:53:06', 0, '2018-03-13 17:53:06', 1),
('082', 'Tejupilco', '15', 0, '2018-03-13 17:53:06', 0, '2018-03-13 17:53:06', 1),
('118', 'Zinacantepec', '15', 0, '2018-03-13 17:53:06', 0, '2018-03-13 17:53:06', 1),
('086', 'Temascaltepec', '15', 0, '2018-03-13 17:53:06', 0, '2018-03-13 17:53:06', 1),
('007', 'Amanalco', '15', 0, '2018-03-13 17:53:06', 0, '2018-03-13 17:53:06', 1),
('110', 'Valle de Bravo', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('116', 'Zacazonapan', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('066', 'Otzoloapan', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('078', 'Santo Tomás', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('041', 'Ixtapan del Oro', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('032', 'Donato Guerra', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('111', 'Villa de Allende', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('114', 'Villa Victoria', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('005', 'Almoloya de Juárez', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('087', 'Temoaya', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('047', 'Jiquipilco', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('042', 'Ixtlahuaca', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('048', 'Jocotitlán', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('124', 'San José del Rincón', '15', 0, '2018-03-13 17:53:05', 0, '2018-03-13 17:53:05', 1),
('074', 'San Felipe del Progreso', '15', 0, '2018-03-13 17:53:04', 0, '2018-03-13 17:53:04', 1),
('064', 'El Oro', '15', 0, '2018-03-13 17:53:04', 0, '2018-03-13 17:53:04', 1),
('056', 'Morelos', '15', 0, '2018-03-13 17:53:04', 0, '2018-03-13 17:53:04', 1),
('102', 'Timilpan', '15', 0, '2018-03-13 17:53:04', 0, '2018-03-13 17:53:04', 1),
('014', 'Atlacomulco', '15', 0, '2018-03-13 17:53:04', 0, '2018-03-13 17:53:04', 1),
('085', 'Temascalcingo', '15', 0, '2018-03-13 17:53:04', 0, '2018-03-13 17:53:04', 1),
('003', 'Aculco', '15', 0, '2018-03-13 17:53:04', 0, '2018-03-13 17:53:04', 1),
('106', 'Toluca', '15', 0, '2018-03-13 17:53:04', 0, '2018-03-13 17:53:04', 1),
('001', 'Acambay de Ruíz Castañeda', '15', 0, '2018-03-13 17:53:04', 0, '2018-03-13 17:53:04', 1),
('056', 'Santa María del Oro', '14', 0, '2018-03-13 17:53:04', 0, '2018-03-13 17:53:04', 1),
('087', 'Tecalitlán', '14', 0, '2018-03-13 17:53:04', 0, '2018-03-13 17:53:04', 1),
('049', 'Jilotlán de los Dolores', '14', 0, '2018-03-13 17:53:04', 0, '2018-03-13 17:53:04', 1),
('065', 'Pihuamo', '14', 0, '2018-03-13 17:53:04', 0, '2018-03-13 17:53:04', 1),
('103', 'Tonila', '14', 0, '2018-03-13 17:53:03', 0, '2018-03-13 17:53:03', 1),
('108', 'Tuxpan', '14', 0, '2018-03-13 17:53:03', 0, '2018-03-13 17:53:03', 1),
('122', 'Zapotitlán de Vadillo', '14', 0, '2018-03-13 17:53:03', 0, '2018-03-13 17:53:03', 1),
('099', 'Tolimán', '14', 0, '2018-03-13 17:53:03', 0, '2018-03-13 17:53:03', 1),
('113', 'San Gabriel', '14', 0, '2018-03-13 17:53:03', 0, '2018-03-13 17:53:03', 1),
('085', 'Tamazula de Gordiano', '14', 0, '2018-03-13 17:53:03', 0, '2018-03-13 17:53:03', 1),
('121', 'Zapotiltic', '14', 0, '2018-03-13 17:53:03', 0, '2018-03-13 17:53:03', 1),
('069', 'Quitupan', '14', 0, '2018-03-13 17:53:03', 0, '2018-03-13 17:53:03', 1),
('112', 'Valle de Juárez', '14', 0, '2018-03-13 17:53:03', 0, '2018-03-13 17:53:03', 1),
('059', 'Mazamitla', '14', 0, '2018-03-13 17:53:03', 0, '2018-03-13 17:53:03', 1),
('107', 'Tuxcueca', '14', 0, '2018-03-13 17:53:03', 0, '2018-03-13 17:53:03', 1),
('057', 'La Manzanilla de la Paz', '14', 0, '2018-03-13 17:53:03', 0, '2018-03-13 17:53:03', 1),
('096', 'Tizapán el Alto', '14', 0, '2018-03-13 17:53:03', 0, '2018-03-13 17:53:03', 1),
('004', 'Amacueca', '14', 0, '2018-03-13 17:53:02', 0, '2018-03-13 17:53:02', 1),
('086', 'Tapalpa', '14', 0, '2018-03-13 17:53:02', 0, '2018-03-13 17:53:02', 1),
('082', 'Sayula', '14', 0, '2018-03-13 17:53:02', 0, '2018-03-13 17:53:02', 1),
('092', 'Teocuitatlán de Corona', '14', 0, '2018-03-13 17:53:02', 0, '2018-03-13 17:53:02', 1),
('026', 'Concepción de Buenos Aires', '14', 0, '2018-03-13 17:53:02', 0, '2018-03-13 17:53:02', 1),
('089', 'Techaluta de Montenegro', '14', 0, '2018-03-13 17:53:02', 0, '2018-03-13 17:53:02', 1),
('014', 'Atoyac', '14', 0, '2018-03-13 17:53:02', 0, '2018-03-13 17:53:02', 1),
('023', 'Zapotlán el Grande', '14', 0, '2018-03-13 17:53:02', 0, '2018-03-13 17:53:02', 1),
('079', 'Gómez Farías', '14', 0, '2018-03-13 17:53:02', 0, '2018-03-13 17:53:02', 1),
('022', 'Cihuatlán', '14', 0, '2018-03-13 17:53:02', 0, '2018-03-13 17:53:02', 1),
('015', 'Autlán de Navarro', '14', 0, '2018-03-13 17:53:02', 0, '2018-03-13 17:53:02', 1),
('021', 'Casimiro Castillo', '14', 0, '2018-03-13 17:53:02', 0, '2018-03-13 17:53:02', 1),
('027', 'Cuautitlán de García Barragán', '14', 0, '2018-03-13 17:53:02', 0, '2018-03-13 17:53:02', 1),
('043', 'La Huerta', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('068', 'Villa Purificación', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('106', 'Tuxcacuesco', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('102', 'Tonaya', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('037', 'El Grullo', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('054', 'El Limón', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('034', 'Ejutla', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('032', 'Chiquilistlán', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('052', 'Juchitlán', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('090', 'Tenamaxtlán', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('088', 'Tecolotlán', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('024', 'Cocula', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('100', 'Tomatlán', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('020', 'Cabo Corrientes', '14', 0, '2018-03-13 17:53:01', 0, '2018-03-13 17:53:01', 1),
('067', 'Puerto Vallarta', '14', 0, '2018-03-13 17:53:00', 0, '2018-03-13 17:53:00', 1),
('084', 'Talpa de Allende', '14', 0, '2018-03-13 17:53:00', 0, '2018-03-13 17:53:00', 1),
('011', 'Atengo', '14', 0, '2018-03-13 17:53:00', 0, '2018-03-13 17:53:00', 1),
('028', 'Cuautla', '14', 0, '2018-03-13 17:53:00', 0, '2018-03-13 17:53:00', 1),
('012', 'Atenguillo', '14', 0, '2018-03-13 17:53:00', 0, '2018-03-13 17:53:00', 1),
('017', 'Ayutla', '14', 0, '2018-03-13 17:53:00', 0, '2018-03-13 17:53:00', 1),
('110', 'Unión de Tula', '14', 0, '2018-03-13 17:53:00', 0, '2018-03-13 17:53:00', 1),
('033', 'Degollado', '14', 0, '2018-03-13 17:53:00', 0, '2018-03-13 17:53:00', 1),
('048', 'Jesús María', '14', 0, '2018-03-13 17:53:00', 0, '2018-03-13 17:53:00', 1),
('016', 'Ayotlán', '14', 0, '2018-03-13 17:53:00', 0, '2018-03-13 17:53:00', 1),
('018', 'La Barca', '14', 0, '2018-03-13 17:53:00', 0, '2018-03-13 17:53:00', 1),
('047', 'Jamay', '14', 0, '2018-03-13 17:53:00', 0, '2018-03-13 17:53:00', 1),
('063', 'Ocotlán', '14', 0, '2018-03-13 17:53:00', 0, '2018-03-13 17:53:00', 1),
('013', 'Atotonilco el Alto', '14', 0, '2018-03-13 17:52:59', 0, '2018-03-13 17:52:59', 1),
('105', 'Tototlán', '14', 0, '2018-03-13 17:52:59', 0, '2018-03-13 17:52:59', 1),
('093', 'Tepatitlán de Morelos', '14', 0, '2018-03-13 17:52:59', 0, '2018-03-13 17:52:59', 1),
('109', 'Unión de San Antonio', '14', 0, '2018-03-13 17:52:59', 0, '2018-03-13 17:52:59', 1),
('072', 'San Diego de Alejandría', '14', 0, '2018-03-13 17:52:59', 0, '2018-03-13 17:52:59', 1),
('064', 'Ojuelos de Jalisco', '14', 0, '2018-03-13 17:52:59', 0, '2018-03-13 17:52:59', 1),
('053', 'Lagos de Moreno', '14', 0, '2018-03-13 17:52:59', 0, '2018-03-13 17:52:59', 1),
('111', 'Valle de Guadalupe', '14', 0, '2018-03-13 17:52:59', 0, '2018-03-13 17:52:59', 1),
('117', 'Cañadas de Obregón', '14', 0, '2018-03-13 17:52:59', 0, '2018-03-13 17:52:59', 1),
('060', 'Mexticacán', '14', 0, '2018-03-13 17:52:59', 0, '2018-03-13 17:52:59', 1),
('118', 'Yahualica de González Gallo', '14', 0, '2018-03-13 17:52:59', 0, '2018-03-13 17:52:59', 1),
('035', 'Encarnación de Díaz', '14', 0, '2018-03-13 17:52:59', 0, '2018-03-13 17:52:59', 1),
('116', 'Villa Hidalgo', '14', 0, '2018-03-13 17:52:59', 0, '2018-03-13 17:52:59', 1),
('091', 'Teocaltiche', '14', 0, '2018-03-13 17:52:58', 0, '2018-03-13 17:52:58', 1),
('125', 'San Ignacio Cerro Gordo', '14', 0, '2018-03-13 17:52:58', 0, '2018-03-13 17:52:58', 1),
('008', 'Arandas', '14', 0, '2018-03-13 17:52:58', 0, '2018-03-13 17:52:58', 1),
('074', 'San Julián', '14', 0, '2018-03-13 17:52:58', 0, '2018-03-13 17:52:58', 1),
('046', 'Jalostotitlán', '14', 0, '2018-03-13 17:52:58', 0, '2018-03-13 17:52:58', 1),
('078', 'San Miguel el Alto', '14', 0, '2018-03-13 17:52:58', 0, '2018-03-13 17:52:58', 1),
('073', 'San Juan de los Lagos', '14', 0, '2018-03-13 17:52:58', 0, '2018-03-13 17:52:58', 1),
('080', 'San Sebastián del Oeste', '14', 0, '2018-03-13 17:52:58', 0, '2018-03-13 17:52:58', 1),
('058', 'Mascota', '14', 0, '2018-03-13 17:52:58', 0, '2018-03-13 17:52:58', 1),
('062', 'Mixtlán', '14', 0, '2018-03-13 17:52:58', 0, '2018-03-13 17:52:58', 1),
('038', 'Guachinango', '14', 0, '2018-03-13 17:52:58', 0, '2018-03-13 17:52:58', 1),
('095', 'Teuchitlán', '14', 0, '2018-03-13 17:52:58', 0, '2018-03-13 17:52:58', 1),
('077', 'San Martín Hidalgo', '14', 0, '2018-03-13 17:52:58', 0, '2018-03-13 17:52:58', 1),
('006', 'Ameca', '14', 0, '2018-03-13 17:52:57', 0, '2018-03-13 17:52:57', 1),
('003', 'Ahualulco de Mercado', '14', 0, '2018-03-13 17:52:57', 0, '2018-03-13 17:52:57', 1),
('007', 'San Juanito de Escobedo', '14', 0, '2018-03-13 17:52:57', 0, '2018-03-13 17:52:57', 1),
('075', 'San Marcos', '14', 0, '2018-03-13 17:52:57', 0, '2018-03-13 17:52:57', 1),
('036', 'Etzatlán', '14', 0, '2018-03-13 17:52:57', 0, '2018-03-13 17:52:57', 1),
('055', 'Magdalena', '14', 0, '2018-03-13 17:52:57', 0, '2018-03-13 17:52:57', 1),
('094', 'Tequila', '14', 0, '2018-03-13 17:52:57', 0, '2018-03-13 17:52:57', 1),
('040', 'Hostotipaquillo', '14', 0, '2018-03-13 17:52:57', 0, '2018-03-13 17:52:57', 1),
('076', 'San Martín de Bolaños', '14', 0, '2018-03-13 17:52:57', 0, '2018-03-13 17:52:57', 1),
('041', 'Huejúcar', '14', 0, '2018-03-13 17:52:57', 0, '2018-03-13 17:52:57', 1),
('031', 'Chimaltitán', '14', 0, '2018-03-13 17:52:57', 0, '2018-03-13 17:52:57', 1),
('081', 'Santa María de los Ángeles', '14', 0, '2018-03-13 17:52:57', 0, '2018-03-13 17:52:57', 1),
('025', 'Colotlán', '14', 0, '2018-03-13 17:52:57', 0, '2018-03-13 17:52:57', 1),
('104', 'Totatiche', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('019', 'Bolaños', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('115', 'Villa Guerrero', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('061', 'Mezquitic', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('042', 'Huejuquilla el Alto', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('123', 'Zapotlán del Rey', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('066', 'Poncitlán', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('051', 'Juanacatlán', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('030', 'Chapala', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('050', 'Jocotepec', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('044', 'Ixtlahuacán de los Membrillos', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('119', 'Zacoalco de Torres', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('010', 'Atemajac de Brizuela', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('114', 'Villa Corona', '14', 0, '2018-03-13 17:52:56', 0, '2018-03-13 17:52:56', 1),
('070', 'El Salto', '14', 0, '2018-03-13 17:52:55', 0, '2018-03-13 17:52:55', 1),
('002', 'Acatlán de Juárez', '14', 0, '2018-03-13 17:52:55', 0, '2018-03-13 17:52:55', 1),
('097', 'Tlajomulco de Zúñiga', '14', 0, '2018-03-13 17:52:55', 0, '2018-03-13 17:52:55', 1),
('098', 'San Pedro Tlaquepaque', '14', 0, '2018-03-13 17:52:55', 0, '2018-03-13 17:52:55', 1),
('029', 'Cuquío', '14', 0, '2018-03-13 17:52:55', 0, '2018-03-13 17:52:55', 1),
('001', 'Acatic', '14', 0, '2018-03-13 17:52:55', 0, '2018-03-13 17:52:55', 1),
('124', 'Zapotlanejo', '14', 0, '2018-03-13 17:52:55', 0, '2018-03-13 17:52:55', 1),
('101', 'Tonalá', '14', 0, '2018-03-13 17:52:55', 0, '2018-03-13 17:52:55', 1),
('005', 'Amatitán', '14', 0, '2018-03-13 17:52:55', 0, '2018-03-13 17:52:55', 1),
('009', 'El Arenal', '14', 0, '2018-03-13 17:52:55', 0, '2018-03-13 17:52:55', 1),
('083', 'Tala', '14', 0, '2018-03-13 17:52:55', 0, '2018-03-13 17:52:55', 1),
('045', 'Ixtlahuacán del Río', '14', 0, '2018-03-13 17:52:55', 0, '2018-03-13 17:52:55', 1),
('071', 'San Cristóbal de la Barranca', '14', 0, '2018-03-13 17:52:55', 0, '2018-03-13 17:52:55', 1),
('120', 'Zapopan', '14', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('039', 'Guadalajara', '14', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('061', 'Tepeapulco', '13', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('021', 'Emiliano Zapata', '13', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('007', 'Almoloya', '13', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('072', 'Tlanalapa', '13', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('008', 'Apan', '13', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('066', 'Villa de Tezontepec', '13', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('075', 'Tolcayuca', '13', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('069', 'Tizayuca', '13', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('083', 'Zempoala', '13', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('057', 'Singuilucan', '13', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('016', 'Cuautepec de Hinojosa', '13', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('056', 'Santiago Tulantepec de Lugo Guerrero', '13', 0, '2018-03-13 17:52:54', 0, '2018-03-13 17:52:54', 1),
('002', 'Acaxochitlán', '13', 0, '2018-03-13 17:52:53', 0, '2018-03-13 17:52:53', 1),
('077', 'Tulancingo de Bravo', '13', 0, '2018-03-13 17:52:53', 0, '2018-03-13 17:52:53', 1),
('022', 'Epazoyucan', '13', 0, '2018-03-13 17:52:53', 0, '2018-03-13 17:52:53', 1),
('045', 'Omitlán de Juárez', '13', 0, '2018-03-13 17:52:53', 0, '2018-03-13 17:52:53', 1),
('060', 'Tenango de Doria', '13', 0, '2018-03-13 17:52:53', 0, '2018-03-13 17:52:53', 1),
('024', 'Huasca de Ocampo', '13', 0, '2018-03-13 17:52:53', 0, '2018-03-13 17:52:53', 1),
('001', 'Acatlán', '13', 0, '2018-03-13 17:52:53', 0, '2018-03-13 17:52:53', 1),
('053', 'San Bartolo Tutotepec', '13', 0, '2018-03-13 17:52:53', 0, '2018-03-13 17:52:53', 1),
('004', 'Agua Blanca de Iturbide', '13', 0, '2018-03-13 17:52:53', 0, '2018-03-13 17:52:53', 1),
('035', 'Metepec', '13', 0, '2018-03-13 17:52:53', 0, '2018-03-13 17:52:53', 1),
('027', 'Huehuetla', '13', 0, '2018-03-13 17:52:53', 0, '2018-03-13 17:52:53', 1),
('037', 'Metztitlán', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('036', 'San Agustín Metzquititlán', '13', 0, '2018-03-13 17:52:53', 0, '2018-03-13 17:52:53', 1),
('020', 'Eloxochitlán', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('012', 'Atotonilco el Grande', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('068', 'Tianguistengo', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('079', 'Xochicoatlán', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('014', 'Calnali', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('081', 'Zacualtipán de Ángeles', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('033', 'Juárez Hidalgo', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('071', 'Tlahuiltepa', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('073', 'Tlanchinol', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('034', 'Lolotla', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('062', 'Tepehuacán de Guerrero', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('042', 'Molango de Escamilla', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('078', 'Xochiatipan', '13', 0, '2018-03-13 17:52:52', 0, '2018-03-13 17:52:52', 1),
('080', 'Yahualica', '13', 0, '2018-03-13 17:52:51', 0, '2018-03-13 17:52:51', 1),
('026', 'Huazalingo', '13', 0, '2018-03-13 17:52:51', 0, '2018-03-13 17:52:51', 1),
('011', 'Atlapexco', '13', 0, '2018-03-13 17:52:51', 0, '2018-03-13 17:52:51', 1),
('025', 'Huautla', '13', 0, '2018-03-13 17:52:51', 0, '2018-03-13 17:52:51', 1),
('032', 'Jaltocán', '13', 0, '2018-03-13 17:52:51', 0, '2018-03-13 17:52:51', 1),
('028', 'Huejutla de Reyes', '13', 0, '2018-03-13 17:52:51', 0, '2018-03-13 17:52:51', 1),
('046', 'San Felipe Orizatlán', '13', 0, '2018-03-13 17:52:51', 0, '2018-03-13 17:52:51', 1),
('010', 'Atitalaquia', '13', 0, '2018-03-13 17:52:51', 0, '2018-03-13 17:52:51', 1),
('013', 'Atotonilco de Tula', '13', 0, '2018-03-13 17:52:51', 0, '2018-03-13 17:52:51', 1),
('074', 'Tlaxcoapan', '13', 0, '2018-03-13 17:52:51', 0, '2018-03-13 17:52:51', 1),
('065', 'Tetepango', '13', 0, '2018-03-13 17:52:51', 0, '2018-03-13 17:52:51', 1),
('064', 'Tepetitlán', '13', 0, '2018-03-13 17:52:51', 0, '2018-03-13 17:52:51', 1),
('017', 'Chapantongo', '13', 0, '2018-03-13 17:52:51', 0, '2018-03-13 17:52:51', 1),
('063', 'Tepeji del Río de Ocampo', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('076', 'Tula de Allende', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('070', 'Tlahuelilpan', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('067', 'Tezontepec de Aldama', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('019', 'Chilcuautla', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('050', 'Progreso de Obregón', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('009', 'El Arenal', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('041', 'Mixquiahuala de Juárez', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('023', 'Francisco I. Madero', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('054', 'San Salvador', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('003', 'Actopan', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('055', 'Santiago de Anaya', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('059', 'Tecozautla', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('044', 'Nopala de Villagrán', '13', 0, '2018-03-13 17:52:50', 0, '2018-03-13 17:52:50', 1),
('029', 'Huichapan', '13', 0, '2018-03-13 17:52:49', 0, '2018-03-13 17:52:49', 1),
('006', 'Alfajayucan', '13', 0, '2018-03-13 17:52:49', 0, '2018-03-13 17:52:49', 1),
('058', 'Tasquillo', '13', 0, '2018-03-13 17:52:49', 0, '2018-03-13 17:52:49', 1),
('015', 'Cardonal', '13', 0, '2018-03-13 17:52:49', 0, '2018-03-13 17:52:49', 1),
('043', 'Nicolás Flores', '13', 0, '2018-03-13 17:52:49', 0, '2018-03-13 17:52:49', 1),
('084', 'Zimapán', '13', 0, '2018-03-13 17:52:49', 0, '2018-03-13 17:52:49', 1),
('030', 'Ixmiquilpan', '13', 0, '2018-03-13 17:52:49', 0, '2018-03-13 17:52:49', 1),
('018', 'Chapulhuacán', '13', 0, '2018-03-13 17:52:49', 0, '2018-03-13 17:52:49', 1),
('040', 'La Misión', '13', 0, '2018-03-13 17:52:49', 0, '2018-03-13 17:52:49', 1),
('047', 'Pacula', '13', 0, '2018-03-13 17:52:49', 0, '2018-03-13 17:52:49', 1),
('049', 'Pisaflores', '13', 0, '2018-03-13 17:52:49', 0, '2018-03-13 17:52:49', 1),
('031', 'Jacala de Ledezma', '13', 0, '2018-03-13 17:52:49', 0, '2018-03-13 17:52:49', 1),
('082', 'Zapotlán de Juárez', '13', 0, '2018-03-13 17:52:49', 0, '2018-03-13 17:52:49', 1),
('051', 'Mineral de la Reforma', '13', 0, '2018-03-13 17:52:48', 0, '2018-03-13 17:52:48', 1),
('052', 'San Agustín Tlaxiaca', '13', 0, '2018-03-13 17:52:48', 0, '2018-03-13 17:52:48', 1),
('039', 'Mineral del Monte', '13', 0, '2018-03-13 17:52:48', 0, '2018-03-13 17:52:48', 1),
('005', 'Ajacuba', '13', 0, '2018-03-13 17:52:48', 0, '2018-03-13 17:52:48', 1),
('038', 'Mineral del Chico', '13', 0, '2018-03-13 17:52:48', 0, '2018-03-13 17:52:48', 1),
('048', 'Pachuca de Soto', '13', 0, '2018-03-13 17:52:48', 0, '2018-03-13 17:52:48', 1),
('036', 'Igualapa', '12', 0, '2018-03-13 17:52:48', 0, '2018-03-13 17:52:48', 1),
('023', 'Cuajinicuilapa', '12', 0, '2018-03-13 17:52:48', 0, '2018-03-13 17:52:48', 1),
('077', 'Marquelia', '12', 0, '2018-03-13 17:52:48', 0, '2018-03-13 17:52:48', 1),
('013', 'Azoyú', '12', 0, '2018-03-13 17:52:48', 0, '2018-03-13 17:52:48', 1),
('080', 'Juchitán', '12', 0, '2018-03-13 17:52:48', 0, '2018-03-13 17:52:48', 1),
('018', 'Copala', '12', 0, '2018-03-13 17:52:48', 0, '2018-03-13 17:52:48', 1),
('025', 'Cuautepec', '12', 0, '2018-03-13 17:52:48', 0, '2018-03-13 17:52:48', 1),
('030', 'Florencio Villarreal', '12', 0, '2018-03-13 17:52:47', 0, '2018-03-13 17:52:47', 1),
('071', 'Xochistlahuaca', '12', 0, '2018-03-13 17:52:47', 0, '2018-03-13 17:52:47', 1),
('046', 'Ometepec', '12', 0, '2018-03-13 17:52:47', 0, '2018-03-13 17:52:47', 1),
('062', 'Tlacoachistlahuaca', '12', 0, '2018-03-13 17:52:47', 0, '2018-03-13 17:52:47', 1),
('004', 'Alcozauca de Guerrero', '12', 0, '2018-03-13 17:52:47', 0, '2018-03-13 17:52:47', 1),
('078', 'Cochoapa el Grande', '12', 0, '2018-03-13 17:52:47', 0, '2018-03-13 17:52:47', 1),
('043', 'Metlatónoc', '12', 0, '2018-03-13 17:52:47', 0, '2018-03-13 17:52:47', 1),
('052', 'San Luis Acatlán', '12', 0, '2018-03-13 17:52:47', 0, '2018-03-13 17:52:47', 1),
('009', 'Atlamajalcingo del Monte', '12', 0, '2018-03-13 17:52:47', 0, '2018-03-13 17:52:47', 1),
('063', 'Tlacoapa', '12', 0, '2018-03-13 17:52:47', 0, '2018-03-13 17:52:47', 1),
('020', 'Copanatoyac', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('041', 'Malinaltepec', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('081', 'Iliatenco', '12', 0, '2018-03-13 17:52:47', 0, '2018-03-13 17:52:47', 1),
('010', 'Atlixtac', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('076', 'Acatepec', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('072', 'Zapotitlán Tablas', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('069', 'Xalpatláhuac', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('065', 'Tlalixtaquilla de Maldonado', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('005', 'Alpoyeca', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('066', 'Tlapa de Comonfort', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('033', 'Huamuxtitlán', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('070', 'Xochihuehuetlán', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('074', 'Zitlala', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('042', 'Mártir de Cuilapan', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('002', 'Ahuacuotzingo', '12', 0, '2018-03-13 17:52:46', 0, '2018-03-13 17:52:46', 1),
('079', 'José Joaquín de Herrera', '12', 0, '2018-03-13 17:52:45', 0, '2018-03-13 17:52:45', 1),
('028', 'Chilapa de Álvarez', '12', 0, '2018-03-13 17:52:45', 0, '2018-03-13 17:52:45', 1),
('024', 'Cualác', '12', 0, '2018-03-13 17:52:45', 0, '2018-03-13 17:52:45', 1),
('019', 'Copalillo', '12', 0, '2018-03-13 17:52:45', 0, '2018-03-13 17:52:45', 1),
('008', 'Atenango del Río', '12', 0, '2018-03-13 17:52:45', 0, '2018-03-13 17:52:45', 1),
('045', 'Olinalá', '12', 0, '2018-03-13 17:52:45', 0, '2018-03-13 17:52:45', 1),
('021', 'Coyuca de Benítez', '12', 0, '2018-03-13 17:52:45', 0, '2018-03-13 17:52:45', 1),
('014', 'Benito Juárez', '12', 0, '2018-03-13 17:52:45', 0, '2018-03-13 17:52:45', 1),
('011', 'Atoyac de Álvarez', '12', 0, '2018-03-13 17:52:45', 0, '2018-03-13 17:52:45', 1),
('057', 'Técpan de Galeana', '12', 0, '2018-03-13 17:52:45', 0, '2018-03-13 17:52:45', 1),
('038', 'Zihuatanejo de Azueta', '12', 0, '2018-03-13 17:52:45', 0, '2018-03-13 17:52:45', 1),
('016', 'Coahuayutla de José María Izazaga', '12', 0, '2018-03-13 17:52:45', 0, '2018-03-13 17:52:45', 1),
('048', 'Petatlán', '12', 0, '2018-03-13 17:52:45', 0, '2018-03-13 17:52:45', 1),
('068', 'La Unión de Isidoro Montes de Oca', '12', 0, '2018-03-13 17:52:44', 0, '2018-03-13 17:52:44', 1),
('073', 'Zirándaro', '12', 0, '2018-03-13 17:52:44', 0, '2018-03-13 17:52:44', 1),
('054', 'San Miguel Totolapan', '12', 0, '2018-03-13 17:52:44', 0, '2018-03-13 17:52:44', 1),
('003', 'Ajuchitlán del Progreso', '12', 0, '2018-03-13 17:52:44', 0, '2018-03-13 17:52:44', 1),
('022', 'Coyuca de Catalán', '12', 0, '2018-03-13 17:52:44', 0, '2018-03-13 17:52:44', 1),
('064', 'Tlalchapa', '12', 0, '2018-03-13 17:52:44', 0, '2018-03-13 17:52:44', 1),
('050', 'Pungarabato', '12', 0, '2018-03-13 17:52:44', 0, '2018-03-13 17:52:44', 1),
('027', 'Cutzamala de Pinzón', '12', 0, '2018-03-13 17:52:44', 0, '2018-03-13 17:52:44', 1),
('067', 'Tlapehuala', '12', 0, '2018-03-13 17:52:44', 0, '2018-03-13 17:52:44', 1),
('017', 'Cocula', '12', 0, '2018-03-13 17:52:44', 0, '2018-03-13 17:52:44', 1),
('006', 'Apaxtla', '12', 0, '2018-03-13 17:52:44', 0, '2018-03-13 17:52:44', 1),
('026', 'Cuetzala del Progreso', '12', 0, '2018-03-13 17:52:44', 0, '2018-03-13 17:52:44', 1),
('007', 'Arcelia', '12', 0, '2018-03-13 17:52:43', 0, '2018-03-13 17:52:43', 1),
('031', 'General Canuto A. Neri', '12', 0, '2018-03-13 17:52:43', 0, '2018-03-13 17:52:43', 1),
('047', 'Pedro Ascencio Alquisiras', '12', 0, '2018-03-13 17:52:43', 0, '2018-03-13 17:52:43', 1),
('049', 'Pilcaya', '12', 0, '2018-03-13 17:52:43', 0, '2018-03-13 17:52:43', 1),
('037', 'Ixcateopan de Cuauhtémoc', '12', 0, '2018-03-13 17:52:43', 0, '2018-03-13 17:52:43', 1),
('058', 'Teloloapan', '12', 0, '2018-03-13 17:52:43', 0, '2018-03-13 17:52:43', 1),
('060', 'Tetipac', '12', 0, '2018-03-13 17:52:43', 0, '2018-03-13 17:52:43', 1),
('055', 'Taxco de Alarcón', '12', 0, '2018-03-13 17:52:43', 0, '2018-03-13 17:52:43', 1),
('015', 'Buenavista de Cuéllar', '12', 0, '2018-03-13 17:52:43', 0, '2018-03-13 17:52:43', 1),
('075', 'Eduardo Neri', '12', 0, '2018-03-13 17:52:43', 0, '2018-03-13 17:52:43', 1),
('059', 'Tepecoacuilco de Trujano', '12', 0, '2018-03-13 17:52:43', 0, '2018-03-13 17:52:43', 1),
('034', 'Huitzuco de los Figueroa', '12', 0, '2018-03-13 17:52:43', 0, '2018-03-13 17:52:43', 1),
('035', 'Iguala de la Independencia', '12', 0, '2018-03-13 17:52:43', 0, '2018-03-13 17:52:43', 1),
('053', 'San Marcos', '12', 0, '2018-03-13 17:52:42', 0, '2018-03-13 17:52:42', 1),
('039', 'Juan R. Escudero', '12', 0, '2018-03-13 17:52:42', 0, '2018-03-13 17:52:42', 1),
('001', 'Acapulco de Juárez', '12', 0, '2018-03-13 17:52:42', 0, '2018-03-13 17:52:42', 1),
('056', 'Tecoanapa', '12', 0, '2018-03-13 17:52:42', 0, '2018-03-13 17:52:42', 1),
('051', 'Quechultenango', '12', 0, '2018-03-13 17:52:42', 0, '2018-03-13 17:52:42', 1),
('044', 'Mochitlán', '12', 0, '2018-03-13 17:52:42', 0, '2018-03-13 17:52:42', 1),
('012', 'Ayutla de los Libres', '12', 0, '2018-03-13 17:52:42', 0, '2018-03-13 17:52:42', 1),
('061', 'Tixtla de Guerrero', '12', 0, '2018-03-13 17:52:42', 0, '2018-03-13 17:52:42', 1),
('040', 'Leonardo Bravo', '12', 0, '2018-03-13 17:52:42', 0, '2018-03-13 17:52:42', 1),
('032', 'General Heliodoro Castillo', '12', 0, '2018-03-13 17:52:42', 0, '2018-03-13 17:52:42', 1),
('041', 'Uriangato', '11', 0, '2018-03-13 17:52:42', 0, '2018-03-13 17:52:42', 1),
('029', 'Chilpancingo de los Bravo', '12', 0, '2018-03-13 17:52:42', 0, '2018-03-13 17:52:42', 1),
('036', 'Santiago Maravatío', '11', 0, '2018-03-13 17:52:42', 0, '2018-03-13 17:52:42', 1),
('046', 'Yuriria', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('028', 'Salvatierra', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('021', 'Moroleón', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('038', 'Tarandacuao', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('039', 'Tarimoro', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('002', 'Acámbaro', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('010', 'Coroneo', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('019', 'Jerécuaro', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('004', 'Apaseo el Alto', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('018', 'Jaral del Progreso', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('042', 'Valle de Santiago', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('011', 'Cortazar', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('044', 'Villagrán', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('009', 'Comonfort', '11', 0, '2018-03-13 17:52:40', 0, '2018-03-13 17:52:40', 1),
('035', 'Santa Cruz de Juventino Rosas', '11', 0, '2018-03-13 17:52:41', 0, '2018-03-13 17:52:41', 1),
('007', 'Celaya', '11', 0, '2018-03-13 17:52:40', 0, '2018-03-13 17:52:40', 1),
('005', 'Apaseo el Grande', '11', 0, '2018-03-13 17:52:40', 0, '2018-03-13 17:52:40', 1),
('040', 'Tierra Blanca', '11', 0, '2018-03-13 17:52:40', 0, '2018-03-13 17:52:40', 1),
('032', 'San José Iturbide', '11', 0, '2018-03-13 17:52:40', 0, '2018-03-13 17:52:40', 1),
('013', 'Doctor Mora', '11', 0, '2018-03-13 17:52:40', 0, '2018-03-13 17:52:40', 1),
('034', 'Santa Catarina', '11', 0, '2018-03-13 17:52:40', 0, '2018-03-13 17:52:40', 1),
('006', 'Atarjea', '11', 0, '2018-03-13 17:52:40', 0, '2018-03-13 17:52:40', 1),
('045', 'Xichú', '11', 0, '2018-03-13 17:52:40', 0, '2018-03-13 17:52:40', 1),
('043', 'Victoria', '11', 0, '2018-03-13 17:52:40', 0, '2018-03-13 17:52:40', 1),
('029', 'San Diego de la Unión', '11', 0, '2018-03-13 17:52:40', 0, '2018-03-13 17:52:40', 1),
('033', 'San Luis de la Paz', '11', 0, '2018-03-13 17:52:40', 0, '2018-03-13 17:52:40', 1),
('003', 'San Miguel de Allende', '11', 0, '2018-03-13 17:52:39', 0, '2018-03-13 17:52:39', 1),
('014', 'Dolores Hidalgo Cuna de la Independencia Nacional', '11', 0, '2018-03-13 17:52:40', 0, '2018-03-13 17:52:40', 1),
('022', 'Ocampo', '11', 0, '2018-03-13 17:52:39', 0, '2018-03-13 17:52:39', 1),
('030', 'San Felipe', '11', 0, '2018-03-13 17:52:39', 0, '2018-03-13 17:52:39', 1),
('020', 'León', '11', 0, '2018-03-13 17:52:39', 0, '2018-03-13 17:52:39', 1),
('016', 'Huanímaro', '11', 0, '2018-03-13 17:52:39', 0, '2018-03-13 17:52:39', 1),
('001', 'Abasolo', '11', 0, '2018-03-13 17:52:39', 0, '2018-03-13 17:52:39', 1),
('012', 'Cuerámaro', '11', 0, '2018-03-13 17:52:39', 0, '2018-03-13 17:52:39', 1),
('023', 'Pénjamo', '11', 0, '2018-03-13 17:52:39', 0, '2018-03-13 17:52:39', 1),
('024', 'Pueblo Nuevo', '11', 0, '2018-03-13 17:52:39', 0, '2018-03-13 17:52:39', 1),
('027', 'Salamanca', '11', 0, '2018-03-13 17:52:39', 0, '2018-03-13 17:52:39', 1),
('017', 'Irapuato', '11', 0, '2018-03-13 17:52:39', 0, '2018-03-13 17:52:39', 1),
('008', 'Manuel Doblado', '11', 0, '2018-03-13 17:52:39', 0, '2018-03-13 17:52:39', 1),
('031', 'San Francisco del Rincón', '11', 0, '2018-03-13 17:52:38', 0, '2018-03-13 17:52:38', 1),
('025', 'Purísima del Rincón', '11', 0, '2018-03-13 17:52:39', 0, '2018-03-13 17:52:39', 1),
('026', 'Romita', '11', 0, '2018-03-13 17:52:38', 0, '2018-03-13 17:52:38', 1),
('037', 'Silao de la Victoria', '11', 0, '2018-03-13 17:52:38', 0, '2018-03-13 17:52:38', 1),
('015', 'Guanajuato', '11', 0, '2018-03-13 17:52:38', 0, '2018-03-13 17:52:38', 1),
('006', 'General Simón Bolívar', '10', 0, '2018-03-13 17:52:38', 0, '2018-03-13 17:52:38', 1),
('027', 'San Juan de Guadalupe', '10', 0, '2018-03-13 17:52:38', 0, '2018-03-13 17:52:38', 1),
('031', 'Santa Clara', '10', 0, '2018-03-13 17:52:38', 0, '2018-03-13 17:52:38', 1),
('004', 'Cuencamé', '10', 0, '2018-03-13 17:52:38', 0, '2018-03-13 17:52:38', 1),
('024', 'Rodeo', '10', 0, '2018-03-13 17:52:38', 0, '2018-03-13 17:52:38', 1),
('029', 'San Luis del Cordero', '10', 0, '2018-03-13 17:52:38', 0, '2018-03-13 17:52:38', 1),
('015', 'Nazas', '10', 0, '2018-03-13 17:52:38', 0, '2018-03-13 17:52:38', 1),
('018', 'El Oro', '10', 0, '2018-03-13 17:52:38', 0, '2018-03-13 17:52:38', 1),
('035', 'Tepehuanes', '10', 0, '2018-03-13 17:52:38', 0, '2018-03-13 17:52:38', 1),
('030', 'San Pedro del Gallo', '10', 0, '2018-03-13 17:52:37', 0, '2018-03-13 17:52:37', 1),
('011', 'Indé', '10', 0, '2018-03-13 17:52:37', 0, '2018-03-13 17:52:37', 1),
('025', 'San Bernardo', '10', 0, '2018-03-13 17:52:37', 0, '2018-03-13 17:52:37', 1),
('009', 'Guanaceví', '10', 0, '2018-03-13 17:52:37', 0, '2018-03-13 17:52:37', 1),
('017', 'Ocampo', '10', 0, '2018-03-13 17:52:37', 0, '2018-03-13 17:52:37', 1),
('010', 'Hidalgo', '10', 0, '2018-03-13 17:52:37', 0, '2018-03-13 17:52:37', 1),
('036', 'Tlahualilo', '10', 0, '2018-03-13 17:52:37', 0, '2018-03-13 17:52:37', 1),
('013', 'Mapimí', '10', 0, '2018-03-13 17:52:37', 0, '2018-03-13 17:52:37', 1),
('012', 'Lerdo', '10', 0, '2018-03-13 17:52:37', 0, '2018-03-13 17:52:37', 1),
('023', 'Pueblo Nuevo', '10', 0, '2018-03-13 17:52:37', 0, '2018-03-13 17:52:37', 1),
('014', 'Mezquital', '10', 0, '2018-03-13 17:52:37', 0, '2018-03-13 17:52:37', 1),
('007', 'Gómez Palacio', '10', 0, '2018-03-13 17:52:37', 0, '2018-03-13 17:52:37', 1),
('033', 'Súchil', '10', 0, '2018-03-13 17:52:37', 0, '2018-03-13 17:52:37', 1),
('038', 'Vicente Guerrero', '10', 0, '2018-03-13 17:52:36', 0, '2018-03-13 17:52:36', 1),
('016', 'Nombre de Dios', '10', 0, '2018-03-13 17:52:36', 0, '2018-03-13 17:52:36', 1),
('022', 'Poanas', '10', 0, '2018-03-13 17:52:36', 0, '2018-03-13 17:52:36', 1),
('020', 'Pánuco de Coronado', '10', 0, '2018-03-13 17:52:36', 0, '2018-03-13 17:52:36', 1),
('026', 'San Dimas', '10', 0, '2018-03-13 17:52:36', 0, '2018-03-13 17:52:36', 1),
('008', 'Guadalupe Victoria', '10', 0, '2018-03-13 17:52:36', 0, '2018-03-13 17:52:36', 1),
('021', 'Peñón Blanco', '10', 0, '2018-03-13 17:52:36', 0, '2018-03-13 17:52:36', 1),
('019', 'Otáez', '10', 0, '2018-03-13 17:52:36', 0, '2018-03-13 17:52:36', 1),
('032', 'Santiago Papasquiaro', '10', 0, '2018-03-13 17:52:36', 0, '2018-03-13 17:52:36', 1),
('034', 'Tamazula', '10', 0, '2018-03-13 17:52:36', 0, '2018-03-13 17:52:36', 1),
('037', 'Topia', '10', 0, '2018-03-13 17:52:36', 0, '2018-03-13 17:52:36', 1),
('002', 'Canelas', '10', 0, '2018-03-13 17:52:36', 0, '2018-03-13 17:52:36', 1),
('028', 'San Juan del Río', '10', 0, '2018-03-13 17:52:36', 0, '2018-03-13 17:52:36', 1),
('003', 'Coneto de Comonfort', '10', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('039', 'Nuevo Ideal', '10', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('001', 'Canatlán', '10', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('005', 'Durango', '10', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('014', 'Coronado', '08', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('036', 'Jiménez', '08', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('044', 'Matamoros', '08', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('039', 'López', '08', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('003', 'Allende', '08', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('032', 'Hidalgo del Parral', '08', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('058', 'San Francisco de Conchos', '08', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('016', 'La Cruz', '08', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('067', 'Valle de Zaragoza', '08', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('062', 'Saucillo', '08', 0, '2018-03-13 17:52:35', 0, '2018-03-13 17:52:35', 1),
('011', 'Camargo', '08', 0, '2018-03-13 17:52:34', 0, '2018-03-13 17:52:34', 1),
('060', 'Santa Bárbara', '08', 0, '2018-03-13 17:52:34', 0, '2018-03-13 17:52:34', 1),
('007', 'Balleza', '08', 0, '2018-03-13 17:52:34', 0, '2018-03-13 17:52:34', 1),
('064', 'El Tule', '08', 0, '2018-03-13 17:52:34', 0, '2018-03-13 17:52:34', 1),
('033', 'Huejotitán', '08', 0, '2018-03-13 17:52:34', 0, '2018-03-13 17:52:34', 1),
('056', 'Rosario', '08', 0, '2018-03-13 17:52:34', 0, '2018-03-13 17:52:34', 1),
('059', 'San Francisco del Oro', '08', 0, '2018-03-13 17:52:34', 0, '2018-03-13 17:52:34', 1),
('029', 'Guadalupe y Calvo', '08', 0, '2018-03-13 17:52:34', 0, '2018-03-13 17:52:34', 1),
('046', 'Morelos', '08', 0, '2018-03-13 17:52:34', 0, '2018-03-13 17:52:34', 1),
('065', 'Urique', '08', 0, '2018-03-13 17:52:34', 0, '2018-03-13 17:52:34', 1),
('008', 'Batopilas de Manuel Gómez Morín', '08', 0, '2018-03-13 17:52:34', 0, '2018-03-13 17:52:34', 1),
('030', 'Guazapares', '08', 0, '2018-03-13 17:52:34', 0, '2018-03-13 17:52:34', 1),
('041', 'Maguarichi', '08', 0, '2018-03-13 17:52:34', 0, '2018-03-13 17:52:34', 1),
('020', 'Chínipas', '08', 0, '2018-03-13 17:52:33', 0, '2018-03-13 17:52:33', 1),
('047', 'Moris', '08', 0, '2018-03-13 17:52:33', 0, '2018-03-13 17:52:33', 1),
('051', 'Ocampo', '08', 0, '2018-03-13 17:52:33', 0, '2018-03-13 17:52:33', 1),
('066', 'Uruachi', '08', 0, '2018-03-13 17:52:33', 0, '2018-03-13 17:52:33', 1),
('012', 'Carichí', '08', 0, '2018-03-13 17:52:33', 0, '2018-03-13 17:52:33', 1),
('024', 'Santa Isabel', '08', 0, '2018-03-13 17:52:33', 0, '2018-03-13 17:52:33', 1),
('026', 'Gran Morelos', '08', 0, '2018-03-13 17:52:33', 0, '2018-03-13 17:52:33', 1),
('018', 'Cusihuiriachi', '08', 0, '2018-03-13 17:52:33', 0, '2018-03-13 17:52:33', 1),
('009', 'Bocoyna', '08', 0, '2018-03-13 17:52:33', 0, '2018-03-13 17:52:33', 1),
('027', 'Guachochi', '08', 0, '2018-03-13 17:52:33', 0, '2018-03-13 17:52:33', 1),
('049', 'Nonoava', '08', 0, '2018-03-13 17:52:33', 0, '2018-03-13 17:52:33', 1),
('057', 'San Francisco de Borja', '08', 0, '2018-03-13 17:52:33', 0, '2018-03-13 17:52:33', 1),
('061', 'Satevó', '08', 0, '2018-03-13 17:52:33', 0, '2018-03-13 17:52:33', 1),
('022', 'Dr. Belisario Domínguez', '08', 0, '2018-03-13 17:52:32', 0, '2018-03-13 17:52:32', 1),
('045', 'Meoqui', '08', 0, '2018-03-13 17:52:32', 0, '2018-03-13 17:52:32', 1),
('055', 'Rosales', '08', 0, '2018-03-13 17:52:32', 0, '2018-03-13 17:52:32', 1),
('021', 'Delicias', '08', 0, '2018-03-13 17:52:32', 0, '2018-03-13 17:52:32', 1),
('042', 'Manuel Benavides', '08', 0, '2018-03-13 17:52:32', 0, '2018-03-13 17:52:32', 1),
('038', 'Julimes', '08', 0, '2018-03-13 17:52:32', 0, '2018-03-13 17:52:32', 1),
('002', 'Aldama', '08', 0, '2018-03-13 17:52:32', 0, '2018-03-13 17:52:32', 1),
('052', 'Ojinaga', '08', 0, '2018-03-13 17:52:32', 0, '2018-03-13 17:52:32', 1),
('015', 'Coyame del Sotol', '08', 0, '2018-03-13 17:52:32', 0, '2018-03-13 17:52:32', 1),
('001', 'Ahumada', '08', 0, '2018-03-13 17:52:32', 0, '2018-03-13 17:52:32', 1),
('053', 'Praxedis G. Guerrero', '08', 0, '2018-03-13 17:52:32', 0, '2018-03-13 17:52:32', 1),
('028', 'Guadalupe', '08', 0, '2018-03-13 17:52:32', 0, '2018-03-13 17:52:32', 1),
('037', 'Juárez', '08', 0, '2018-03-13 17:52:32', 0, '2018-03-13 17:52:32', 1),
('043', 'Matachí', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('063', 'Temósachic', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('048', 'Namiquipa', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('040', 'Madera', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('034', 'Ignacio Zaragoza', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('025', 'Gómez Farías', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('010', 'Buenaventura', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('023', 'Galeana', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('013', 'Casas Grandes', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('035', 'Janos', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('005', 'Ascensión', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('050', 'Nuevo Casas Grandes', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('031', 'Guerrero', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('006', 'Bachíniva', '08', 0, '2018-03-13 17:52:31', 0, '2018-03-13 17:52:31', 1),
('004', 'Aquiles Serdán', '08', 0, '2018-03-13 17:52:30', 0, '2018-03-13 17:52:30', 1),
('054', 'Riva Palacio', '08', 0, '2018-03-13 17:52:30', 0, '2018-03-13 17:52:30', 1),
('017', 'Cuauhtémoc', '08', 0, '2018-03-13 17:52:30', 0, '2018-03-13 17:52:30', 1),
('019', 'Chihuahua', '08', 0, '2018-03-13 17:52:30', 0, '2018-03-13 17:52:30', 1),
('080', 'Siltepec', '07', 0, '2018-03-13 17:52:30', 0, '2018-03-13 17:52:30', 1),
('070', 'El Porvenir', '07', 0, '2018-03-13 17:52:30', 0, '2018-03-13 17:52:30', 1),
('036', 'La Grandeza', '07', 0, '2018-03-13 17:52:30', 0, '2018-03-13 17:52:30', 1),
('010', 'Bejucal de Ocampo', '07', 0, '2018-03-13 17:52:30', 0, '2018-03-13 17:52:30', 1),
('006', 'Amatenango de la Frontera', '07', 0, '2018-03-13 17:52:30', 0, '2018-03-13 17:52:30', 1),
('053', 'Mazapa de Madero', '07', 0, '2018-03-13 17:52:30', 0, '2018-03-13 17:52:30', 1),
('057', 'Motozintla', '07', 0, '2018-03-13 17:52:30', 0, '2018-03-13 17:52:30', 1),
('015', 'Cacahoatán', '07', 0, '2018-03-13 17:52:30', 0, '2018-03-13 17:52:30', 1),
('105', 'Unión Juárez', '07', 0, '2018-03-13 17:52:30', 0, '2018-03-13 17:52:30', 1),
('102', 'Tuxtla Chico', '07', 0, '2018-03-13 17:52:29', 0, '2018-03-13 17:52:29', 1),
('055', 'Metapa', '07', 0, '2018-03-13 17:52:29', 0, '2018-03-13 17:52:29', 1),
('035', 'Frontera Hidalgo', '07', 0, '2018-03-13 17:52:29', 0, '2018-03-13 17:52:29', 1),
('087', 'Suchiate', '07', 0, '2018-03-13 17:52:29', 0, '2018-03-13 17:52:29', 1),
('089', 'Tapachula', '07', 0, '2018-03-13 17:52:29', 0, '2018-03-13 17:52:29', 1),
('103', 'Tuzantán', '07', 0, '2018-03-13 17:52:29', 0, '2018-03-13 17:52:29', 1),
('037', 'Huehuetán', '07', 0, '2018-03-13 17:52:29', 0, '2018-03-13 17:52:29', 1),
('054', 'Mazatán', '07', 0, '2018-03-13 17:52:29', 0, '2018-03-13 17:52:29', 1),
('040', 'Huixtla', '07', 0, '2018-03-13 17:52:29', 0, '2018-03-13 17:52:29', 1),
('071', 'Villa Comaltitlán', '07', 0, '2018-03-13 17:52:29', 0, '2018-03-13 17:52:29', 1),
('032', 'Escuintla', '07', 0, '2018-03-13 17:52:29', 0, '2018-03-13 17:52:29', 1),
('001', 'Acacoyagua', '07', 0, '2018-03-13 17:52:29', 0, '2018-03-13 17:52:29', 1),
('003', 'Acapetahua', '07', 0, '2018-03-13 17:52:29', 0, '2018-03-13 17:52:29', 1),
('051', 'Mapastepec', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('069', 'Pijijiapan', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('107', 'Villa Corzo', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('097', 'Tonalá', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('108', 'Villaflores', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('009', 'Arriaga', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('046', 'Jiquipilas', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('017', 'Cintalapa', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('083', 'Socoltenango', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('117', 'Montecristo de Guerrero', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('008', 'Angel Albino Corzo', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('020', 'La Concordia', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('075', 'Las Rosas', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('058', 'Nicolás Ruíz', '07', 0, '2018-03-13 17:52:28', 0, '2018-03-13 17:52:28', 1),
('098', 'Totolapa', '07', 0, '2018-03-13 17:52:27', 0, '2018-03-13 17:52:27', 1),
('106', 'Venustiano Carranza', '07', 0, '2018-03-13 17:52:27', 0, '2018-03-13 17:52:27', 1),
('004', 'Altamirano', '07', 0, '2018-03-13 17:52:27', 0, '2018-03-13 17:52:27', 1),
('052', 'Las Margaritas', '07', 0, '2018-03-13 17:52:27', 0, '2018-03-13 17:52:27', 1),
('115', 'Maravilla Tenejapa', '07', 0, '2018-03-13 17:52:27', 0, '2018-03-13 17:52:27', 1),
('041', 'La Independencia', '07', 0, '2018-03-13 17:52:27', 0, '2018-03-13 17:52:27', 1),
('034', 'Frontera Comalapa', '07', 0, '2018-03-13 17:52:27', 0, '2018-03-13 17:52:27', 1),
('099', 'La Trinitaria', '07', 0, '2018-03-13 17:52:27', 0, '2018-03-13 17:52:27', 1),
('011', 'Bella Vista', '07', 0, '2018-03-13 17:52:27', 0, '2018-03-13 17:52:27', 1),
('030', 'Chicomuselo', '07', 0, '2018-03-13 17:52:27', 0, '2018-03-13 17:52:27', 1),
('104', 'Tzimol', '07', 0, '2018-03-13 17:52:27', 0, '2018-03-13 17:52:27', 1),
('019', 'Comitán de Domínguez', '07', 0, '2018-03-13 17:52:27', 0, '2018-03-13 17:52:27', 1),
('016', 'Catazajá', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('050', 'La Libertad', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('065', 'Palenque', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('116', 'Marqués de Comillas', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('114', 'Benemérito de las Américas', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('031', 'Chilón', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('059', 'Ocosingo', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('109', 'Yajalón', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('100', 'Tumbalá', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('096', 'Tila', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('077', 'Salto de Agua', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('082', 'Sitalá', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('066', 'Pantelhó', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('113', 'Aldama', '07', 0, '2018-03-13 17:52:26', 0, '2018-03-13 17:52:26', 1),
('026', 'Chenalhó', '07', 0, '2018-03-13 17:52:25', 0, '2018-03-13 17:52:25', 1),
('119', 'Santiago el Pinar', '07', 0, '2018-03-13 17:52:25', 0, '2018-03-13 17:52:25', 1),
('049', 'Larráinzar', '07', 0, '2018-03-13 17:52:25', 0, '2018-03-13 17:52:25', 1),
('022', 'Chalchihuitán', '07', 0, '2018-03-13 17:52:25', 0, '2018-03-13 17:52:25', 1),
('014', 'El Bosque', '07', 0, '2018-03-13 17:52:25', 0, '2018-03-13 17:52:25', 1),
('118', 'San Andrés Duraznal', '07', 0, '2018-03-13 17:52:25', 0, '2018-03-13 17:52:25', 1),
('081', 'Simojovel', '07', 0, '2018-03-13 17:52:25', 0, '2018-03-13 17:52:25', 1),
('076', 'Sabanilla', '07', 0, '2018-03-13 17:52:25', 0, '2018-03-13 17:52:25', 1),
('112', 'San Juan Cancuc', '07', 0, '2018-03-13 17:52:25', 0, '2018-03-13 17:52:25', 1),
('085', 'Soyaló', '07', 0, '2018-03-13 17:52:25', 0, '2018-03-13 17:52:25', 1),
('013', 'Bochil', '07', 0, '2018-03-13 17:52:25', 0, '2018-03-13 17:52:25', 1),
('047', 'Jitotol', '07', 0, '2018-03-13 17:52:25', 0, '2018-03-13 17:52:25', 1),
('072', 'Pueblo Nuevo Solistahuacán', '07', 0, '2018-03-13 17:52:25', 0, '2018-03-13 17:52:25', 1),
('073', 'Rayón', '07', 0, '2018-03-13 17:52:24', 0, '2018-03-13 17:52:24', 1),
('091', 'Tapilula', '07', 0, '2018-03-13 17:52:24', 0, '2018-03-13 17:52:24', 1),
('042', 'Ixhuatán', '07', 0, '2018-03-13 17:52:24', 0, '2018-03-13 17:52:24', 1),
('039', 'Huitiupán', '07', 0, '2018-03-13 17:52:24', 0, '2018-03-13 17:52:24', 1),
('005', 'Amatán', '07', 0, '2018-03-13 17:52:24', 0, '2018-03-13 17:52:24', 1),
('025', 'Chapultenango', '07', 0, '2018-03-13 17:52:24', 0, '2018-03-13 17:52:24', 1);
INSERT INTO `ciudad` (`Clave_Ciudad`, `Nombre`, `Clave_Estado`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Estatus`) VALUES
('060', 'Ocotepec', '07', 0, '2018-03-13 17:52:24', 0, '2018-03-13 17:52:24', 1),
('090', 'Tapalapa', '07', 0, '2018-03-13 17:52:24', 0, '2018-03-13 17:52:24', 1),
('067', 'Pantepec', '07', 0, '2018-03-13 17:52:24', 0, '2018-03-13 17:52:24', 1),
('018', 'Coapilla', '07', 0, '2018-03-13 17:52:24', 0, '2018-03-13 17:52:24', 1),
('029', 'Chicoasén', '07', 0, '2018-03-13 17:52:24', 0, '2018-03-13 17:52:24', 1),
('021', 'Copainalá', '07', 0, '2018-03-13 17:52:24', 0, '2018-03-13 17:52:24', 1),
('092', 'Tecpatán', '07', 0, '2018-03-13 17:52:24', 0, '2018-03-13 17:52:24', 1),
('045', 'Ixtapangajoya', '07', 0, '2018-03-13 17:52:23', 0, '2018-03-13 17:52:23', 1),
('084', 'Solosuchiapa', '07', 0, '2018-03-13 17:52:23', 0, '2018-03-13 17:52:23', 1),
('043', 'Ixtacomitán', '07', 0, '2018-03-13 17:52:23', 0, '2018-03-13 17:52:23', 1),
('033', 'Francisco León', '07', 0, '2018-03-13 17:52:23', 0, '2018-03-13 17:52:23', 1),
('062', 'Ostuacán', '07', 0, '2018-03-13 17:52:23', 0, '2018-03-13 17:52:23', 1),
('088', 'Sunuapa', '07', 0, '2018-03-13 17:52:23', 0, '2018-03-13 17:52:23', 1),
('068', 'Pichucalco', '07', 0, '2018-03-13 17:52:23', 0, '2018-03-13 17:52:23', 1),
('048', 'Juárez', '07', 0, '2018-03-13 17:52:23', 0, '2018-03-13 17:52:23', 1),
('074', 'Reforma', '07', 0, '2018-03-13 17:52:23', 0, '2018-03-13 17:52:23', 1),
('056', 'Mitontic', '07', 0, '2018-03-13 17:52:23', 0, '2018-03-13 17:52:23', 1),
('093', 'Tenejapa', '07', 0, '2018-03-13 17:52:23', 0, '2018-03-13 17:52:23', 1),
('038', 'Huixtán', '07', 0, '2018-03-13 17:52:23', 0, '2018-03-13 17:52:23', 1),
('064', 'Oxchuc', '07', 0, '2018-03-13 17:52:23', 0, '2018-03-13 17:52:23', 1),
('024', 'Chanal', '07', 0, '2018-03-13 17:52:22', 0, '2018-03-13 17:52:22', 1),
('007', 'Amatenango del Valle', '07', 0, '2018-03-13 17:52:22', 0, '2018-03-13 17:52:22', 1),
('094', 'Teopisca', '07', 0, '2018-03-13 17:52:22', 0, '2018-03-13 17:52:22', 1),
('110', 'San Lucas', '07', 0, '2018-03-13 17:52:22', 0, '2018-03-13 17:52:22', 1),
('028', 'Chiapilla', '07', 0, '2018-03-13 17:52:22', 0, '2018-03-13 17:52:22', 1),
('002', 'Acala', '07', 0, '2018-03-13 17:52:22', 0, '2018-03-13 17:52:22', 1),
('111', 'Zinacantán', '07', 0, '2018-03-13 17:52:22', 0, '2018-03-13 17:52:22', 1),
('044', 'Ixtapa', '07', 0, '2018-03-13 17:52:22', 0, '2018-03-13 17:52:22', 1),
('023', 'Chamula', '07', 0, '2018-03-13 17:52:22', 0, '2018-03-13 17:52:22', 1),
('078', 'San Cristóbal de las Casas', '07', 0, '2018-03-13 17:52:22', 0, '2018-03-13 17:52:22', 1),
('063', 'Osumacinta', '07', 0, '2018-03-13 17:52:22', 0, '2018-03-13 17:52:22', 1),
('027', 'Chiapa de Corzo', '07', 0, '2018-03-13 17:52:22', 0, '2018-03-13 17:52:22', 1),
('086', 'Suchiapa', '07', 0, '2018-03-13 17:52:21', 0, '2018-03-13 17:52:21', 1),
('061', 'Ocozocoautla de Espinosa', '07', 0, '2018-03-13 17:52:21', 0, '2018-03-13 17:52:21', 1),
('012', 'Berriozábal', '07', 0, '2018-03-13 17:52:21', 0, '2018-03-13 17:52:21', 1),
('079', 'San Fernando', '07', 0, '2018-03-13 17:52:21', 0, '2018-03-13 17:52:21', 1),
('101', 'Tuxtla Gutiérrez', '07', 0, '2018-03-13 17:52:21', 0, '2018-03-13 17:52:21', 1),
('010', 'Villa de Álvarez', '06', 0, '2018-03-13 17:52:21', 0, '2018-03-13 17:52:21', 1),
('008', 'Minatitlán', '06', 0, '2018-03-13 17:52:21', 0, '2018-03-13 17:52:21', 1),
('006', 'Ixtlahuacán', '06', 0, '2018-03-13 17:52:21', 0, '2018-03-13 17:52:21', 1),
('005', 'Cuauhtémoc', '06', 0, '2018-03-13 17:52:21', 0, '2018-03-13 17:52:21', 1),
('003', 'Comala', '06', 0, '2018-03-13 17:52:21', 0, '2018-03-13 17:52:21', 1),
('004', 'Coquimatlán', '06', 0, '2018-03-13 17:52:21', 0, '2018-03-13 17:52:21', 1),
('001', 'Armería', '06', 0, '2018-03-13 17:52:21', 0, '2018-03-13 17:52:21', 1),
('007', 'Manzanillo', '06', 0, '2018-03-13 17:52:20', 0, '2018-03-13 17:52:20', 1),
('009', 'Tecomán', '06', 0, '2018-03-13 17:52:20', 0, '2018-03-13 17:52:20', 1),
('002', 'Colima', '06', 0, '2018-03-13 17:52:20', 0, '2018-03-13 17:52:20', 1),
('024', 'Parras', '05', 0, '2018-03-13 17:52:20', 0, '2018-03-13 17:52:20', 1),
('009', 'Francisco I. Madero', '05', 0, '2018-03-13 17:52:20', 0, '2018-03-13 17:52:20', 1),
('033', 'San Pedro', '05', 0, '2018-03-13 17:52:20', 0, '2018-03-13 17:52:20', 1),
('029', 'Sacramento', '05', 0, '2018-03-13 17:52:20', 0, '2018-03-13 17:52:20', 1),
('016', 'Lamadrid', '05', 0, '2018-03-13 17:52:20', 0, '2018-03-13 17:52:20', 1),
('007', 'Cuatro Ciénegas', '05', 0, '2018-03-13 17:52:20', 0, '2018-03-13 17:52:20', 1),
('034', 'Sierra Mojada', '05', 0, '2018-03-13 17:52:20', 0, '2018-03-13 17:52:20', 1),
('021', 'Nadadores', '05', 0, '2018-03-13 17:52:20', 0, '2018-03-13 17:52:20', 1),
('023', 'Ocampo', '05', 0, '2018-03-13 17:52:20', 0, '2018-03-13 17:52:20', 1),
('036', 'Viesca', '05', 0, '2018-03-13 17:52:20', 0, '2018-03-13 17:52:20', 1),
('017', 'Matamoros', '05', 0, '2018-03-13 17:52:19', 0, '2018-03-13 17:52:19', 1),
('035', 'Torreón', '05', 0, '2018-03-13 17:52:19', 0, '2018-03-13 17:52:19', 1),
('032', 'San Juan de Sabinas', '05', 0, '2018-03-13 17:52:19', 0, '2018-03-13 17:52:19', 1),
('028', 'Sabinas', '05', 0, '2018-03-13 17:52:19', 0, '2018-03-13 17:52:19', 1),
('013', 'Hidalgo', '05', 0, '2018-03-13 17:52:19', 0, '2018-03-13 17:52:19', 1),
('012', 'Guerrero', '05', 0, '2018-03-13 17:52:19', 0, '2018-03-13 17:52:19', 1),
('037', 'Villa Unión', '05', 0, '2018-03-13 17:52:19', 0, '2018-03-13 17:52:19', 1),
('003', 'Allende', '05', 0, '2018-03-13 17:52:19', 0, '2018-03-13 17:52:19', 1),
('019', 'Morelos', '05', 0, '2018-03-13 17:52:19', 0, '2018-03-13 17:52:19', 1),
('038', 'Zaragoza', '05', 0, '2018-03-13 17:52:19', 0, '2018-03-13 17:52:19', 1),
('014', 'Jiménez', '05', 0, '2018-03-13 17:52:19', 0, '2018-03-13 17:52:19', 1),
('020', 'Múzquiz', '05', 0, '2018-03-13 17:52:19', 0, '2018-03-13 17:52:19', 1),
('002', 'Acuña', '05', 0, '2018-03-13 17:52:18', 0, '2018-03-13 17:52:18', 1),
('022', 'Nava', '05', 0, '2018-03-13 17:52:18', 0, '2018-03-13 17:52:18', 1),
('025', 'Piedras Negras', '05', 0, '2018-03-13 17:52:18', 0, '2018-03-13 17:52:18', 1),
('011', 'General Cepeda', '05', 0, '2018-03-13 17:52:18', 0, '2018-03-13 17:52:18', 1),
('027', 'Ramos Arizpe', '05', 0, '2018-03-13 17:52:18', 0, '2018-03-13 17:52:18', 1),
('006', 'Castaños', '05', 0, '2018-03-13 17:52:18', 0, '2018-03-13 17:52:18', 1),
('018', 'Monclova', '05', 0, '2018-03-13 17:52:18', 0, '2018-03-13 17:52:18', 1),
('010', 'Frontera', '05', 0, '2018-03-13 17:52:18', 0, '2018-03-13 17:52:18', 1),
('005', 'Candela', '05', 0, '2018-03-13 17:52:18', 0, '2018-03-13 17:52:18', 1),
('001', 'Abasolo', '05', 0, '2018-03-13 17:52:18', 0, '2018-03-13 17:52:18', 1),
('031', 'San Buenaventura', '05', 0, '2018-03-13 17:52:18', 0, '2018-03-13 17:52:18', 1),
('008', 'Escobedo', '05', 0, '2018-03-13 17:52:18', 0, '2018-03-13 17:52:18', 1),
('026', 'Progreso', '05', 0, '2018-03-13 17:52:18', 0, '2018-03-13 17:52:18', 1),
('015', 'Juárez', '05', 0, '2018-03-13 17:52:17', 0, '2018-03-13 17:52:17', 1),
('004', 'Arteaga', '05', 0, '2018-03-13 17:52:17', 0, '2018-03-13 17:52:17', 1),
('030', 'Saltillo', '05', 0, '2018-03-13 17:52:17', 0, '2018-03-13 17:52:17', 1),
('001', 'Calkiní', '04', 0, '2018-03-13 17:52:17', 0, '2018-03-13 17:52:17', 1),
('005', 'Hecelchakán', '04', 0, '2018-03-13 17:52:17', 0, '2018-03-13 17:52:17', 1),
('008', 'Tenabo', '04', 0, '2018-03-13 17:52:17', 0, '2018-03-13 17:52:17', 1),
('010', 'Calakmul', '04', 0, '2018-03-13 17:52:17', 0, '2018-03-13 17:52:17', 1),
('006', 'Hopelchén', '04', 0, '2018-03-13 17:52:17', 0, '2018-03-13 17:52:17', 1),
('004', 'Champotón', '04', 0, '2018-03-13 17:52:17', 0, '2018-03-13 17:52:17', 1),
('009', 'Escárcega', '04', 0, '2018-03-13 17:52:17', 0, '2018-03-13 17:52:17', 1),
('011', 'Candelaria', '04', 0, '2018-03-13 17:52:17', 0, '2018-03-13 17:52:17', 1),
('007', 'Palizada', '04', 0, '2018-03-13 17:52:16', 0, '2018-03-13 17:52:16', 1),
('003', 'Carmen', '04', 0, '2018-03-13 17:52:16', 0, '2018-03-13 17:52:16', 1),
('002', 'Campeche', '04', 0, '2018-03-13 17:52:16', 0, '2018-03-13 17:52:16', 1),
('002', 'Mulegé', '03', 0, '2018-03-13 17:52:16', 0, '2018-03-13 17:52:16', 1),
('009', 'Loreto', '03', 0, '2018-03-13 17:52:16', 0, '2018-03-13 17:52:16', 1),
('001', 'Comondú', '03', 0, '2018-03-13 17:52:16', 0, '2018-03-13 17:52:16', 1),
('008', 'Los Cabos', '03', 0, '2018-03-13 17:52:16', 0, '2018-03-13 17:52:16', 1),
('003', 'La Paz', '03', 0, '2018-03-13 17:52:16', 0, '2018-03-13 17:52:16', 1),
('001', 'Ensenada', '02', 0, '2018-03-13 17:52:16', 0, '2018-03-13 17:52:16', 1),
('005', 'Playas de Rosarito', '02', 0, '2018-03-13 17:52:16', 0, '2018-03-13 17:52:16', 1),
('004', 'Tijuana', '02', 0, '2018-03-13 17:52:15', 0, '2018-03-13 17:52:15', 1),
('003', 'Tecate', '02', 0, '2018-03-13 17:52:15', 0, '2018-03-13 17:52:15', 1),
('002', 'Mexicali', '02', 0, '2018-03-13 17:52:15', 0, '2018-03-13 17:52:15', 1),
('005', 'Jesús María', '01', 0, '2018-03-13 17:52:15', 0, '2018-03-13 17:52:15', 1),
('003', 'Calvillo', '01', 0, '2018-03-13 17:52:15', 0, '2018-03-13 17:52:15', 1),
('002', 'Asientos', '01', 0, '2018-03-13 17:52:15', 0, '2018-03-13 17:52:15', 1),
('006', 'Pabellón de Arteaga', '01', 0, '2018-03-13 17:52:15', 0, '2018-03-13 17:52:15', 1),
('009', 'Tepezalá', '01', 0, '2018-03-13 17:52:15', 0, '2018-03-13 17:52:15', 1),
('008', 'San José de Gracia', '01', 0, '2018-03-13 17:52:15', 0, '2018-03-13 17:52:15', 1),
('004', 'Cosío', '01', 0, '2018-03-13 17:52:15', 0, '2018-03-13 17:52:15', 1),
('007', 'Rincón de Romos', '01', 0, '2018-03-13 17:52:15', 0, '2018-03-13 17:52:15', 1),
('010', 'El Llano', '01', 0, '2018-03-13 17:52:14', 0, '2018-03-13 17:52:14', 1),
('011', 'San Francisco de los Romo', '01', 0, '2018-03-13 17:52:14', 0, '2018-03-13 17:52:14', 1),
('001', 'Aguascalientes', '01', 0, '2018-03-13 17:52:14', 0, '2018-03-13 17:52:14', 1),
('013', 'Xochimilco', '09', 0, '2018-03-13 17:52:14', 0, '2018-03-13 17:52:14', 1),
('017', 'Venustiano Carranza', '09', 0, '2018-03-13 17:52:14', 0, '2018-03-13 17:52:14', 1),
('012', 'Tlalpan', '09', 0, '2018-03-13 17:52:14', 0, '2018-03-13 17:52:14', 1),
('011', 'Tláhuac', '09', 0, '2018-03-13 17:52:14', 0, '2018-03-13 17:52:14', 1),
('009', 'Milpa Alta', '09', 0, '2018-03-13 17:52:14', 0, '2018-03-13 17:52:14', 1),
('016', 'Miguel Hidalgo', '09', 0, '2018-03-13 17:52:14', 0, '2018-03-13 17:52:14', 1),
('008', 'La Magdalena Contreras', '09', 0, '2018-03-13 17:52:14', 0, '2018-03-13 17:52:14', 1),
('007', 'Iztapalapa', '09', 0, '2018-03-13 17:52:13', 0, '2018-03-13 17:52:13', 1),
('006', 'Iztacalco', '09', 0, '2018-03-13 17:52:13', 0, '2018-03-13 17:52:13', 1),
('005', 'Gustavo A. Madero', '09', 0, '2018-03-13 17:52:13', 0, '2018-03-13 17:52:13', 1),
('015', 'Cuauhtémoc', '09', 0, '2018-03-13 17:52:13', 0, '2018-03-13 17:52:13', 1),
('004', 'Cuajimalpa de Morelos', '09', 0, '2018-03-13 17:52:13', 0, '2018-03-13 17:52:13', 1),
('003', 'Coyoacán', '09', 0, '2018-03-13 17:52:13', 0, '2018-03-13 17:52:13', 1),
('014', 'Benito Juárez', '09', 0, '2018-03-13 17:52:13', 0, '2018-03-13 17:52:13', 1),
('002', 'Azcapotzalco', '09', 0, '2018-03-13 17:52:13', 0, '2018-03-13 17:52:13', 1),
('010', 'Álvaro Obregón', '09', 0, '2018-03-13 17:52:13', 0, '2018-03-13 17:52:13', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

DROP TABLE IF EXISTS `cliente`;
CREATE TABLE IF NOT EXISTS `cliente` (
  `IdCliente` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave primaria de la tabla, autoincrementable',
  `IdEmpresa` int(11) NOT NULL COMMENT 'Identificador de la empresa a la que pertenece el resgistro',
  `RFC` varchar(13) NOT NULL COMMENT ': Registro Federal de Contribuyente del Cliente, sirve como clave del cliente.',
  `RazonSocial` varchar(96) NOT NULL COMMENT 'Nombre formal del cliente',
  `NombreComercial` varchar(64) DEFAULT NULL COMMENT 'Nombre con el que se identifica claramente al cliente sin ser tan largo o formal como la Razón Social pero más descriptivo que el RFC',
  `Direccion` varchar(250) DEFAULT NULL COMMENT 'Dirección del cliente',
  `EmpresaCorreo` varchar(64) NOT NULL,
  `EmpresaTelefono` varchar(64) NOT NULL,
  `Contacto_Nombre` varchar(64) NOT NULL COMMENT 'Nombre de la persona que fungirá como contacto',
  `Contacto_Email` varchar(64) NOT NULL COMMENT 'Cuenta de correo del contacto',
  `Contacto_Telefono` varchar(32) NOT NULL COMMENT 'Teléfono fijo del contacto',
  `Comentarios` varchar(128) DEFAULT NULL COMMENT 'Comentarios',
  `Estatus` tinyint(1) NOT NULL DEFAULT '1',
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IdCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`IdCliente`, `IdEmpresa`, `RFC`, `RazonSocial`, `NombreComercial`, `Direccion`, `EmpresaCorreo`, `EmpresaTelefono`, `Contacto_Nombre`, `Contacto_Email`, `Contacto_Telefono`, `Comentarios`, `Estatus`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`) VALUES
(1, 1, 'ALM140707T56', 'Almaximo Consultoria TI S.C.', 'AlMaximo', 'Nueva Galica España 7045-1\nColonia. Vista Hermosa', '', '', 'JAIME CELAYA H', 'jcelaya@almaximot.com', '4775772721', 'Ninguno', 0, 0, '2017-10-13 19:41:20', 0, '2017-11-14 22:22:20'),
(2, 1, 'Lib980102AVC', 'Departamentales Liberpool de Mexico SA de CV', 'Liberpool', 'Ninguna', '', '', 'Juan Amezcua Robles', 'jcelaya@yahoo.com', '4775772721', 'Comentarios X', 1, 3, '2017-11-06 00:39:02', 3, '2017-11-06 00:39:22'),
(3, 1, 'FGL1234W6800', 'FIGLOSNTE13', 'DAFI', 'HFGFJGJGKG', '', '', 'ANDRES MENDOZA', 'DAFI@FIGLOSNTE.COM', '3457689890', NULL, 1, 3, '2017-11-07 05:48:52', 3, '2017-11-18 00:34:41'),
(4, 1, 'CPM700101PLM', 'Caja Popular Mexicana RL AS', 'Caja', 'adafdadsfdsf', '', '', 'Jose Cendeas', 'jdsafasf@yahoo.com', '147852336', 'asdfdsafdsaf', 0, 3, '2017-11-08 22:12:11', 0, '2017-11-14 22:22:28'),
(5, 1, 'TCR0508105L5', 'TE CREEMOS SA DE CV SFP', 'TE CREEMOS', 'AV XOLA #324 COLONIA DEL VALLE DELEGACION BENITO JUAREZ CIUDAD DE MEXICO CP. 03103', '', '', 'JORGE GONZALEZ', 'jdominguez@tecreemos.com', '5543564378', NULL, 1, 3, '2017-11-10 06:46:14', 3, '2017-11-10 06:46:21'),
(6, 1, 'FCL101009KLJ', 'FINCLUSION SA DE CV SFP', 'FINCLUSION SA DE CV', 'AV XOLA 324 COLONIA DEL VALLE DELEGACION BENITO JUAREZ CIUDAD DE MEXICO CP 03103', '', '', 'JORGE DOMINGUEZ', 'jdominguez@tecreemos.com', '5543564378', NULL, 1, 3, '2017-11-10 06:53:46', 3, '2017-11-10 06:53:46'),
(7, 1, 'FFI090512H13', 'TCRFIN SA DE CV SOFOM ENR', 'FINANCIERA FINCA', 'AV XOLA 324 COLONIA DEL VALLE DELEGACION BENITO JUAREZ CIUDAD DE MEXICO CP 03103', '', '', 'JORGE DOMINGUEZ', 'jdominguez@tecreemos.com', '5543564378', NULL, 1, 3, '2017-11-10 06:58:29', 3, '2017-11-10 06:58:29'),
(8, 1, 'SME5503113Z4', 'STANHOME DE MEXICO SA DE CV', 'STANHOME', 'PONIENTE 146 INT 624 COLONIA INDUSTRIAL VALLEJO DELEGACION AZCAPOTZALCO CIUDAD DE MEXICO CP 02300', '', '', 'JAIME RODRIGUEZ ', 'jaime.rodriguez@yrnet.com', '5534344892', NULL, 1, 3, '2017-11-10 07:02:43', 3, '2017-11-10 07:02:43'),
(9, 1, 'FEC050520AA2', 'FIANCIERA EQUIPATE SA DE CV SOFOM ENRFEC', 'FINANCIERA EQUIPAT', 'PASEO DE LA REFORMA #300 PISO 7 OFICINA 702 COLONIA JUAREZ CIUDAD DE MEXICO', 'alex@gmail.com', '123456', 'ADOLFO HOLGUIN', 'jaolguin@equipat.com.mx', '55 4991 3504', NULL, 1, 3, '2017-11-10 07:07:23', 4, '2018-03-05 04:30:07'),
(10, 1, 'FGS110530IY7', 'FIGLOSNTE 13', 'DAFI MAGISTERIAL', 'CARRETERA ESTATAL LIBRE GUANAJUATO JUVENTINO ROSAS KM 7.5 COLONIA YERBABUENA GUANAJUATO GUANAJUATO CP 36250', 'a@a.com', '2342342', 'ANDRES MENDOZA', 'amendoza@dafi.com.mx', '477 449 00 92', NULL, 1, 3, '2017-11-10 07:15:38', 4, '2018-03-05 16:48:44'),
(11, 1, 'SCR050912JL5', 'SIEMPRE CRECIENDO SA DE CV SOFOM ENR', 'FINANCIERA SIEMPRE CRECIENDO', 'CALZADA GRAL MARIANO ESCOBEDO 550 PISO 4 COLONIA ANZUREZ DELEGACION MIGUEL HIDALGO CIUDAD DE MEXICO CP 11590', '', '', 'RAUL  LOPEZ', 'cord_cobranza@creciendo.com.mx', '55 2702 6345', NULL, 1, 3, '2017-11-10 07:19:36', 3, '2017-11-10 07:19:36'),
(12, 1, 'GURL', 'Alex', 'Alex Desconocido', NULL, 'alex@gmail.com', '1234', 'Rogelio', 'alex@gmail.com', '1234', NULL, 1, 4, '2018-02-26 22:31:15', 0, '2018-03-14 16:03:33'),
(13, 1, 'rytrytrytr', 'rytrytrytr', 'trytrytr', 'jhgjhgjhg', 'a@g.com', '6576576', '678687', 'a@gmail.com', '8768687', 'jhgjhgjh', 1, 11, '2018-03-07 20:50:20', 11, '2018-03-07 20:50:20'),
(14, 1, 'AJDJJEUDJEDLL', 'Telemarketing', 'Telemarketing', 'Independencia 110 Col. Centro ', 'telemark@gmail.com', 'FFFDFDFDF', 'Rosa Alvarez', 'rosa@gmail.com', '7100098', 'ninguno', 1, 0, '2018-03-12 19:04:19', 0, '2018-03-12 19:08:23'),
(15, 3, 'gur850319fg7', 'jjjjjjjjjjjjjjjjjjjjjjjjjjjjj', 'jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj', NULL, 'a@a.c', '1234567', 'a', 'a@c.c', '1234567', NULL, 1, 0, '2018-03-12 23:16:50', 0, '2018-03-12 23:16:50'),
(16, 1, 'LASDÑ', 'XDXDXDX', 'XDXD', NULL, 'con@hotmail.com', '1234567', 'Juan', 'con@hotmail.com', '1234567', '123', 1, 0, '2018-03-13 18:13:14', 0, '2018-03-14 16:04:52'),
(17, 1, 'GURL850319FG7', 'Alex', 'Bordados', NULL, 'alex@gmail.com', '12345', 'Carlos', 'alex@gmail.com', '1234', NULL, 1, 0, '2018-03-15 04:06:02', 0, '2018-03-15 04:06:02'),
(18, 3, 'JSJJSJ', 'La Tiendita', 'La Tiendita', '11111', 'c@jmail.com', '7150098', 'Rosa', 'c@jmail.com', '7150098', '1111', 1, 0, '2018-03-15 18:07:04', 0, '2018-03-15 18:07:04');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientedocumentos`
--

DROP TABLE IF EXISTS `clientedocumentos`;
CREATE TABLE IF NOT EXISTS `clientedocumentos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IdCliente` int(11) NOT NULL,
  `IdDocumento` int(11) NOT NULL,
  `Nombre` varchar(150) NOT NULL,
  `Url` varchar(150) NOT NULL,
  `Estatus` tinyint(4) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL,
  `IdUsuarioModificacion` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL,
  `Idempresa` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `clientedocumentos`
--

INSERT INTO `clientedocumentos` (`Id`, `IdCliente`, `IdDocumento`, `Nombre`, `Url`, `Estatus`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioModificacion`, `FechaModificacion`, `Idempresa`) VALUES
(3, 4, 22, 'jhjhjgjghj', 'C:\\Users\\Alejandro Gutiérrez\\Desktop\\Crear Menu.txt', 1, 11, '2018-03-09 23:09:47', 11, '2018-03-09 23:09:47', 1),
(6, 14, 9, 'aaaaaaaaaaaaaaa', 'C:\\Users\\Alejandro Gutiérrez\\Desktop\\IMG-20151201-WA0012.jpg', 1, 0, '2018-03-12 23:38:52', 0, '2018-03-12 23:38:52', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `colonia`
--

DROP TABLE IF EXISTS `colonia`;
CREATE TABLE IF NOT EXISTS `colonia` (
  `Clave_Colonia` varchar(10) NOT NULL,
  `Nombre` varchar(512) NOT NULL,
  `CodigoPostal` varchar(10) NOT NULL,
  `Clave_Estado` varchar(10) NOT NULL,
  `Clave_Ciudad` varchar(10) NOT NULL,
  `Clave_Asentamiento` varchar(10) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Clave_Colonia`,`Clave_Ciudad`,`Clave_Estado`),
  KEY `R_25` (`Clave_Ciudad`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresa`
--

DROP TABLE IF EXISTS `empresa`;
CREATE TABLE IF NOT EXISTS `empresa` (
  `IdEmpresa` int(11) NOT NULL COMMENT 'Llave primaria de la tabla, autoincrementable',
  `Dominio` varchar(64) NOT NULL COMMENT 'Es el dominio de la empresa, servirá para distinguir a un usuario de otras empresas. Este dominio deberá ser único',
  `ProductKey` varchar(256) NOT NULL COMMENT 'Razón social de la empresa o cliente',
  `Administrador` varchar(30) NOT NULL,
  `Contrasenia` varchar(250) NOT NULL,
  `NombreComercial` varchar(100) NOT NULL,
  `RutaLogo` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`IdEmpresa`),
  UNIQUE KEY `IX_Empresa` (`Dominio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='La entidad Empresa representa a cada uno de nuestros clientes';

--
-- Volcado de datos para la tabla `empresa`
--

INSERT INTO `empresa` (`IdEmpresa`, `Dominio`, `ProductKey`, `Administrador`, `Contrasenia`, `NombreComercial`, `RutaLogo`) VALUES
(1, '@HumanFactory.com', '8UF3lmtQxIeFnY1HCLv68jPPUaGMbGxoHgDC2HiLlAY=', 'Administrador', '+8gNci97Kp/Rex0XrtGLlg==', 'Human Factory', 'untitled.png'),
(3, '@Alex.com', 'fHu4uGAorJ8DHkt4nJq22f7i8QXd3diN', 'Administrador', '+8gNci97Kp/Rex0XrtGLlg==', 'Alex Corporation', 'images.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

DROP TABLE IF EXISTS `estado`;
CREATE TABLE IF NOT EXISTS `estado` (
  `Clave_Estado` varchar(10) NOT NULL,
  `Nombre` varchar(512) NOT NULL,
  `Clave_Pais` varchar(10) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Clave_Estado`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `estado`
--

INSERT INTO `estado` (`Clave_Estado`, `Nombre`, `Clave_Pais`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Estatus`) VALUES
('31', 'Yucatán', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('32', 'Zacatecas', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('30', 'Veracruz de Ignacio de la Llave', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('29', 'Tlaxcala', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('28', 'Tamaulipas', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('27', 'Tabasco', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('26', 'Sonora', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('25', 'Sinaloa', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('24', 'San Luis Potosí', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('23', 'Quintana Roo', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('22', 'Querétaro', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('21', 'Puebla', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('20', 'Oaxaca', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('19', 'Nuevo León', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('18', 'Nayarit', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('17', 'Morelos', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('16', 'Michoacán de Ocampo', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('15', 'México', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('14', 'Jalisco', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('13', 'Hidalgo', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('12', 'Guerrero', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('11', 'Guanajuato', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('10', 'Durango', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('08', 'Chihuahua', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('07', 'Chiapas', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('04', 'Campeche', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('05', 'Coahuila de Zaragoza', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('06', 'Colima', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('03', 'Baja California Sur', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('02', 'Baja California', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('01', 'Aguascalientes', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1),
('09', 'Ciudad de México', '01', 0, '2018-03-13 17:52:12', 0, '2018-03-13 17:52:12', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `forma`
--

DROP TABLE IF EXISTS `forma`;
CREATE TABLE IF NOT EXISTS `forma` (
  `IdForma` int(11) NOT NULL AUTO_INCREMENT,
  `ClaveCodigo` varchar(50) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `EsOpcionMenu` tinyint(1) NOT NULL,
  `Estatus` tinyint(1) NOT NULL,
  `IdFormaPadre` int(11) DEFAULT '0',
  `TextoLink` varchar(100) DEFAULT NULL,
  `Accion` varchar(100) DEFAULT NULL,
  `Controlador` varchar(100) DEFAULT NULL,
  `EsDropdown` tinyint(1) NOT NULL,
  `Orden` int(11) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `OrigenOperacion` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  `Descripcion` varchar(256) CHARACTER SET utf8mb4 DEFAULT NULL,
  `IdEmpresa` int(11) NOT NULL,
  `EsSuperAdministrador` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdForma`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `forma`
--

INSERT INTO `forma` (`IdForma`, `ClaveCodigo`, `Nombre`, `EsOpcionMenu`, `Estatus`, `IdFormaPadre`, `TextoLink`, `Accion`, `Controlador`, `EsDropdown`, `Orden`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`, `Descripcion`, `IdEmpresa`, `EsSuperAdministrador`) VALUES
(1, 'Inicio', 'Inicio', 1, 1, NULL, 'Inicio', 'Index', 'Menu', 0, 1, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Inicio) Forma correspondiente a Pantalla de Inicio', 1, 0),
(2, 'Administracion', 'Administración', 1, 1, NULL, 'Administración', NULL, NULL, 1, 3, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración) Opción desplegable de menú Administración', 1, 0),
(3, 'Parametros', 'Parámetros', 1, 1, 2, 'Parámetros', 'Parametro_Index', 'Configuracion', 0, 8, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración) Forma correspondiente a Parámetros del Sistema', 1, 0),
(4, 'Usuarios', 'Usuarios', 1, 1, 6, 'Usuarios', 'Usuario_Index', 'Configuracion', 0, 2, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración > Usuarios) Forma correspondiente a Gestión de Usuarios', 1, 0),
(5, 'Roles', 'Roles', 1, 1, 6, 'Roles', 'Rol_Index', 'Configuracion', 0, 1, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración > Usuarios) Forma correspondiente a Gestión de Roles', 1, 0),
(6, 'MenuUsuario', 'MenuUsuario', 1, 1, 2, 'Usuarios', NULL, NULL, 1, 7, 1, '2017-06-12 13:57:27', 1, '2017-06-12 13:57:27', 1, '(Administración > Usuarios) Grupo de menú para Usuarios y Roles', 1, 0),
(7, 'FormaPermiso', 'Nombrar Permisos por Forma', 0, 1, 2, 'Nombrar Permisos por Forma', 'FormaPermiso_Index', 'Configuracion', 0, 1, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración) Forma correspondiente a Gestión de Nombre de permisos por Forma', 1, 0),
(8, 'SuperUsuario', 'SuperUsuario', 1, 1, 2, 'Super Usuario', NULL, NULL, 1, 9, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración > SuperUsuario) Forma correspondiente a Gestión de Empresas', 1, 1),
(9, 'Parametros', 'Parametros', 1, 1, 8, 'Parámetros de la aplicación', 'Parametro_S_Index', 'Configuracion', 0, 1, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración) Forma correspondiente a Parámetros Configuración', 1, 1),
(10, 'Empresa', 'Empresa', 1, 1, 8, 'Empresa', 'Empresa_Index', 'Configuracion', 0, 2, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración) Forma correspondiente a Gestión de la Empresa', 1, 1),
(11, 'Clientes', 'Clientes', 1, 1, 2, 'Clientes', 'Cliente_Index', 'Clientes', 0, 4, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración) Forma correspondiente a Gestión de Clientes', 1, 0),
(16, 'Catalogos', 'Catálogos', 1, 1, 2, 'Catálogos Estatus', 'Catalogo_Index', 'Configuracion', 1, 6, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración > Catálogos) Grupo de menú para Catálogos', 1, 0),
(17, 'SubCatalogos', 'SubCatálogos', 0, 1, 2, 'SubCatálogos', 'SubCatalogo_Index', 'SubCatalogo', 0, 4, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración > Catálogos) Forma complementaria para la Gestión de Catálogos', 1, 0),
(18, 'Reportes', 'Reportes', 1, 1, 0, 'Reportes', NULL, NULL, 1, 4, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración) Opción desplegable de menú Reportes', 1, 0),
(21, 'BitacoraErrorDeudor', 'Bitácora de errores al importar datos deudor', 1, 1, 2, 'Bitácora de Errores', 'BitacoraErrorDeudor_Index', 'BitacoraErrorDeudor', 0, 5, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración) Forma correspondiente a Bitácora de errores al importar datos deudor', 1, 0),
(46, 'Prospecto', 'Prospecto', 1, 1, 2, 'Prospectos', 'Prospecto_Index', 'Prospectos', 0, 4, 1, '2018-03-09 23:02:14', 1, '2018-03-09 23:02:14', 1, '(Administracion) Forma correspondiente a Vacantes', 1, 0),
(48, 'CodigoPostal', 'CodigoPostal', 1, 1, 2, 'CodigoPostal', 'CodigoPostal_Index', 'CodigoPostal', 0, 4, 1, '2018-03-09 23:02:15', 1, '2018-03-09 23:02:15', 1, '(Administracion) Forma correspondiente a Vacantes', 1, 0),
(49, 'Vacante', 'Vacante', 1, 1, 2, 'Vacante', 'Vacante_Index', 'Vacantes', 0, 4, 1, '2018-03-09 23:06:06', 1, '2018-03-09 23:06:06', 1, '(Administracion) Forma correspondiente a Vacantes', 1, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formapermiso`
--

DROP TABLE IF EXISTS `formapermiso`;
CREATE TABLE IF NOT EXISTS `formapermiso` (
  `IdFormaPermiso` int(11) NOT NULL AUTO_INCREMENT,
  `IdForma` int(11) NOT NULL,
  `IdPermiso` int(11) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `OrigenOperacion` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  `IdEmpresa` int(11) NOT NULL,
  `NombrePermiso` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IdFormaPermiso`),
  KEY `FK_FormaPermiso_Forma` (`IdForma`),
  KEY `FK_FormaPermiso_Permiso` (`IdPermiso`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `formapermiso`
--

INSERT INTO `formapermiso` (`IdFormaPermiso`, `IdForma`, `IdPermiso`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`, `IdEmpresa`, `NombrePermiso`) VALUES
(1, 1, 1, 0, '2017-09-13 09:24:18', 0, '2017-09-15 07:21:11', 0, 1, 'Consultar'),
(2, 3, 1, 0, '2017-09-13 09:25:01', 0, '2017-09-14 09:33:49', 0, 1, 'Consultar'),
(3, 3, 2, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Agregar'),
(4, 3, 3, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Actualizar'),
(5, 3, 4, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Eliminar'),
(6, 4, 1, 0, '2017-09-13 09:25:01', 0, '2017-09-13 09:25:01', 0, 1, 'Consultar'),
(7, 4, 2, 0, '2017-09-13 09:26:33', 0, '2017-09-13 09:26:33', 0, 1, 'Agregar'),
(8, 4, 3, 0, '2017-09-13 09:26:33', 0, '2017-09-13 09:26:33', 0, 1, 'Actualizar'),
(9, 4, 4, 0, '2017-09-13 09:26:33', 0, '2017-09-13 09:26:33', 0, 1, 'Eliminar'),
(10, 5, 1, 0, '2017-09-13 09:25:01', 0, '2017-09-13 09:25:01', 0, 1, 'Consultar'),
(11, 5, 2, 0, '2017-09-13 09:26:33', 0, '2017-09-13 09:26:33', 0, 1, 'Agregar'),
(12, 5, 3, 0, '2017-09-13 09:26:33', 0, '2017-09-13 09:26:33', 0, 1, 'Actualizar'),
(13, 5, 4, 0, '2017-09-13 09:26:33', 0, '2017-09-13 09:26:33', 0, 1, 'Eliminar'),
(14, 2, 1, 0, '2017-09-13 09:24:18', 0, '2017-09-13 09:24:18', 0, 1, 'Consultar'),
(15, 6, 1, 0, '2017-09-13 09:25:01', 0, '2017-09-13 09:25:01', 0, 1, 'Consultar'),
(16, 7, 1, 0, '2017-09-13 09:25:01', 0, '2017-09-13 09:25:01', 0, 1, 'Consultar'),
(17, 8, 1, 0, '2017-09-13 09:25:01', 0, '2017-09-14 09:33:49', 0, 1, 'Consultar'),
(18, 9, 1, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Consultar'),
(19, 9, 2, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Agregar'),
(20, 9, 3, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Actualizar'),
(21, 9, 4, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Eliminar'),
(22, 10, 1, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Consultar'),
(23, 10, 2, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Agregar'),
(24, 10, 3, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Actualizar'),
(26, 11, 1, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Consultar'),
(27, 11, 2, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Agregar'),
(28, 11, 3, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Actualizar'),
(29, 11, 4, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Eliminar'),
(46, 16, 1, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Consultar'),
(47, 16, 2, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Agregar'),
(48, 16, 3, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Actualizar'),
(49, 16, 4, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Eliminar'),
(50, 18, 1, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Consultar'),
(54, 21, 1, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Consultar'),
(55, 21, 2, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Eliminar'),
(114, 46, 1, 0, '2018-03-09 23:02:14', 1, '2018-03-09 23:02:14', 1, 1, 'Consultar'),
(115, 46, 2, 0, '2018-03-09 23:02:14', 1, '2018-03-09 23:02:14', 1, 1, 'Agregar'),
(116, 46, 3, 0, '2018-03-09 23:02:14', 1, '2018-03-09 23:02:14', 1, 1, 'Actualizar'),
(117, 46, 4, 0, '2018-03-09 23:02:14', 1, '2018-03-09 23:02:14', 1, 1, 'Eliminar'),
(122, 48, 1, 0, '2018-03-09 23:02:15', 0, '2018-03-09 23:02:15', 1, 1, 'Consultar'),
(123, 48, 2, 0, '2018-03-09 23:02:15', 0, '2018-03-09 23:02:15', 1, 1, 'Agregar'),
(124, 48, 3, 0, '2018-03-09 23:02:15', 0, '2018-03-09 23:02:15', 1, 1, 'Actualizar'),
(125, 48, 4, 0, '2018-03-09 23:02:15', 0, '2018-03-09 23:02:15', 1, 1, 'Eliminar'),
(126, 49, 1, 0, '2018-03-09 23:06:06', 0, '2018-03-09 23:06:06', 1, 1, 'Consultar'),
(127, 49, 2, 0, '2018-03-09 23:06:06', 0, '2018-03-09 23:06:06', 1, 1, 'Agregar'),
(128, 49, 3, 0, '2018-03-09 23:06:06', 0, '2018-03-09 23:06:06', 1, 1, 'Actualizar'),
(129, 49, 4, 0, '2018-03-09 23:06:06', 0, '2018-03-09 23:06:06', 1, 1, 'Eliminar');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formarol`
--

DROP TABLE IF EXISTS `formarol`;
CREATE TABLE IF NOT EXISTS `formarol` (
  `IdFormaRol` int(11) NOT NULL AUTO_INCREMENT,
  `IdForma` int(11) NOT NULL,
  `IdRol` int(11) NOT NULL,
  `Privilegios` bigint(20) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `OrigenOperacion` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  `IdEmpresa` int(11) NOT NULL,
  PRIMARY KEY (`IdFormaRol`),
  KEY `FK_FormaRol_Forma` (`IdForma`),
  KEY `FK_FormaRol_Roles` (`IdRol`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `formarol`
--

INSERT INTO `formarol` (`IdFormaRol`, `IdForma`, `IdRol`, `Privilegios`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`, `IdEmpresa`) VALUES
(1, 1, 1, 1, 1, '2018-03-15 17:16:09', 1, '2018-03-15 17:16:09', 1, 1),
(2, 11, 1, 3, 1, '2018-03-15 17:16:21', 1, '2018-03-15 17:16:21', 1, 1),
(3, 46, 1, 3, 1, '2018-03-15 17:16:34', 1, '2018-03-15 17:16:34', 1, 1),
(4, 49, 1, 3, 1, '2018-03-15 17:17:09', 1, '2018-03-15 17:17:09', 1, 1),
(5, 48, 1, 3, 1, '2018-03-15 17:19:54', 1, '2018-03-15 17:19:54', 1, 1),
(6, 2, 1, 1, 1, '2018-03-15 17:21:36', 1, '2018-03-15 17:21:36', 1, 1),
(7, 18, 1, 1, 1, '2018-03-15 17:21:53', 1, '2018-03-15 17:21:53', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nacionalidad`
--

DROP TABLE IF EXISTS `nacionalidad`;
CREATE TABLE IF NOT EXISTS `nacionalidad` (
  `IdNacionalidad` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Clave` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` timestamp NULL DEFAULT NULL,
  `Estatus` tinyint(4) DEFAULT NULL,
  `IdTipoCatalogo` int(11) NOT NULL,
  PRIMARY KEY (`IdNacionalidad`) USING BTREE,
  KEY `R_54` (`IdUsuarioCreacion`) USING BTREE,
  KEY `R_60` (`IdUsuarioUltimoModifico`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `nacionalidad`
--

INSERT INTO `nacionalidad` (`IdNacionalidad`, `Nombre`, `Clave`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Estatus`, `IdTipoCatalogo`) VALUES
(1, 'México', 'MX', 1, '2018-03-01 16:56:39', 1, '2018-03-01 16:56:39', 1, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pais`
--

DROP TABLE IF EXISTS `pais`;
CREATE TABLE IF NOT EXISTS `pais` (
  `Clave_Pais` varchar(10) NOT NULL,
  `Nombre` varchar(512) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Clave_Pais`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `pais`
--

INSERT INTO `pais` (`Clave_Pais`, `Nombre`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Estatus`) VALUES
('01', 'Mexico', 1, '2018-03-08 21:56:39', 1, '2018-03-08 21:56:39', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parametro`
--

DROP TABLE IF EXISTS `parametro`;
CREATE TABLE IF NOT EXISTS `parametro` (
  `IdParametro` smallint(6) NOT NULL AUTO_INCREMENT COMMENT 'Identificador unico de la tabla parametro',
  `Nombre` varchar(64) NOT NULL COMMENT 'campo para darle un nombre al parametro agregado',
  `Descripcion` varchar(10000) DEFAULT NULL COMMENT 'Campo que nos explica de que trata el parametro ',
  `Valor` varchar(10000) NOT NULL COMMENT 'Campo que contiene la cualidad del parametro.',
  `EsActivo` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'campo que nos dice un parametro esta activo o no activo',
  `EsSensitivo` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Campo que nos dice si es legible a simple vista o debe estar oculto',
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `OrigenOperacion` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  `IdEmpresa` int(11) NOT NULL,
  PRIMARY KEY (`IdParametro`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `parametro`
--

INSERT INTO `parametro` (`IdParametro`, `Nombre`, `Descripcion`, `Valor`, `EsActivo`, `EsSensitivo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`, `IdEmpresa`) VALUES
(1, 'SMTP', 'Servidor con servicio SMTP para envio de correos eléctronicos', 'smtp.gmail.com', 1, 0, 1, '2017-04-10 20:05:13', 0, '2017-09-20 05:24:09', 1, 1),
(2, 'Puerto', 'Puerto para el envio de correos s', '587', 1, 0, 1, '2017-04-10 20:05:13', 1, '2017-04-10 20:05:13', 1, 1),
(3, 'Remitente', 'Remitente del email', 'ALMCorreoAutomatico@gmail.com', 1, 0, 1, '2017-04-10 20:05:13', 1, '2017-04-10 20:05:13', 1, 1),
(4, 'Contrasenia', 'Contraseña del Correo', 'EnvioCorreo123$', 1, 0, 1, '2017-04-10 20:05:13', 1, '2017-04-10 20:05:13', 1, 1),
(6, 'MinCallBack', 'Valor minimo CallBack (minutos)', '35', 1, 0, 1, '2017-10-01 18:39:00', 4, '2018-03-05 17:54:48', 1, 1),
(7, 'MaxCallBack', 'Valor máximo CallBack (minutos)', '4320', 1, 0, 1, '2017-10-01 18:39:00', 1, '2017-10-01 18:39:00', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parametroempresa`
--

DROP TABLE IF EXISTS `parametroempresa`;
CREATE TABLE IF NOT EXISTS `parametroempresa` (
  `IdParametro` smallint(6) NOT NULL AUTO_INCREMENT COMMENT 'Identificador unico de la tabla parametro',
  `Nombre` varchar(64) NOT NULL COMMENT 'campo para darle un nombre al parametro agregado',
  `Descripcion` varchar(10000) DEFAULT NULL COMMENT 'Campo que nos explica de que trata el parametro ',
  `Valor` varchar(10000) NOT NULL COMMENT 'Campo que contiene la cualidad del parametro.',
  `EsActivo` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'campo que nos dice un parametro esta activo o no activo',
  `EsSensitivo` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Campo que nos dice si es legible a simple vista o debe estar oculto',
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `OrigenOperacion` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  PRIMARY KEY (`IdParametro`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `parametroempresa`
--

INSERT INTO `parametroempresa` (`IdParametro`, `Nombre`, `Descripcion`, `Valor`, `EsActivo`, `EsSensitivo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`) VALUES
(1, 'URLServicio', 'URL Servicio', 'http://localhost:81/', 1, 0, 1, '2017-04-11 01:05:13', 0, '2017-09-20 10:40:26', 1),
(2, 'Empresa', 'Empresa', 'api/v1/Inicio/Empresa/', 1, 0, 1, '2017-04-11 01:05:13', 1, '2017-04-11 01:05:13', 1),
(3, 'SuperUsuario', 'SuperUsuario', 'api/v1/Inicio/SuperUsuario/', 1, 0, 1, '2017-04-11 01:05:13', 1, '2017-04-11 01:05:13', 1),
(4, 'LimpiarEmpresa', 'LimpiarEmpresa', 'api/v1/Inicio/LimpiarEmpresa/', 1, 0, 1, '2017-04-11 01:05:13', 1, '2017-04-11 01:05:13', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parametroscaracteresinvalidos`
--

DROP TABLE IF EXISTS `parametroscaracteresinvalidos`;
CREATE TABLE IF NOT EXISTS `parametroscaracteresinvalidos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CaracterInvalido` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `parametroscaracteresinvalidos`
--

INSERT INTO `parametroscaracteresinvalidos` (`Id`, `CaracterInvalido`) VALUES
(1, 0),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 11),
(10, 12),
(11, 14),
(12, 15),
(13, 16),
(14, 17),
(15, 18),
(16, 19),
(17, 20),
(18, 21),
(19, 26),
(20, 27),
(21, 28),
(22, 29),
(23, 30),
(24, 31),
(25, 22),
(26, 23),
(27, 24),
(28, 25),
(29, 127),
(30, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parametrostiposdefault`
--

DROP TABLE IF EXISTS `parametrostiposdefault`;
CREATE TABLE IF NOT EXISTS `parametrostiposdefault` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `DataType` varchar(100) NOT NULL,
  `IdTipoCelda` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_TB_BI_Reportes_TiposDefault_TB_BI_Reportes_TiposCelda` (`IdTipoCelda`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `parametrostiposdefault`
--

INSERT INTO `parametrostiposdefault` (`Id`, `DataType`, `IdTipoCelda`) VALUES
(1, 'DateTime', 2),
(2, 'time', 14),
(3, 'Int16', 3),
(4, 'Int32', 3),
(5, 'Int64', 3),
(6, 'Decimal', 5),
(7, 'Double', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parametrotiposcelda`
--

DROP TABLE IF EXISTS `parametrotiposcelda`;
CREATE TABLE IF NOT EXISTS `parametrotiposcelda` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `EsFecha` tinyint(1) NOT NULL DEFAULT '0',
  `EsNumero` tinyint(1) NOT NULL DEFAULT '0',
  `EsPorcentaje` tinyint(1) NOT NULL DEFAULT '0',
  `SeparacionMiles` tinyint(1) NOT NULL DEFAULT '0',
  `CuantosDecimales` int(11) NOT NULL,
  `FormatCode` varchar(50) CHARACTER SET utf8mb4 DEFAULT '',
  `FormatCodeAntes` varchar(50) CHARACTER SET utf8mb4 DEFAULT '',
  `FormatCodeDespues` varchar(50) CHARACTER SET utf8mb4 DEFAULT '',
  `FormatCodeFinal` varchar(50) CHARACTER SET utf8mb4 DEFAULT '',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `parametrotiposcelda`
--

INSERT INTO `parametrotiposcelda` (`Id`, `Nombre`, `EsFecha`, `EsNumero`, `EsPorcentaje`, `SeparacionMiles`, `CuantosDecimales`, `FormatCode`, `FormatCodeAntes`, `FormatCodeDespues`, `FormatCodeFinal`) VALUES
(1, 'Cadena carácteres', 0, 0, 0, 0, 0, '', '', '', ''),
(2, 'Fecha con hora', 1, 0, 0, 0, 0, 'dd/mm/yyyy hh:mm:ss AM/PM', '', '', ';@'),
(3, 'Entero sin separación miles', 0, 1, 0, 0, 0, '_-0_-;-0_-;_-* \"-\"??_-;_-@_-', '', '', ''),
(4, 'Entero separación miles', 0, 1, 0, 1, 0, '_-#,##0_-;-#,##0_-;_-* \"-\"??_-;_-@_-', '', '', ''),
(5, 'Decimal separación miles 2 decimales', 0, 1, 0, 1, 2, '#,##0.;-#,##0.', '_-', '_-', ';_-* \"-\"??_-;_-@_-'),
(6, 'Decimal separación miles 4 decimales', 0, 1, 0, 1, 4, '#,##0.;-#,##0.', '_-', '_-', ';_-* \"-\"??_-;_-@_-'),
(7, 'Decimal separación miles 6 decimales', 0, 1, 0, 1, 6, '#,##0.;-#,##0.', '_-', '_-', ';_-* \"-\"??_-;_-@_-'),
(8, 'Decimal separación miles 17 decimales', 0, 1, 0, 1, 17, '#,##0.;-#,##0.', '_-', '_-', ';_-* \"-\"??_-;_-@_-'),
(9, 'Decimal separación miles 18 decimales', 0, 1, 0, 1, 18, '#,##0.;-#,##0.', '_-', '_-', ';_-* \"-\"??_-;_-@_-'),
(10, 'Decimal separación miles 3 decimales', 0, 1, 0, 1, 3, '#,##0.;-#,##0.', '_-', '_-', ';_-* \"-\"??_-;_-@_-'),
(11, 'Porcentaje', 0, 0, 1, 0, 0, '0.00%', '', '', ''),
(12, 'Fecha sin hora', 1, 0, 0, 0, 0, 'dd/MM/yyyy', '', '', ';@'),
(14, 'Hora ', 1, 0, 0, 0, 0, 'hh:mm:ss AM/PM', '', '', ';@'),
(16, 'Boleano', 0, 1, 0, 0, 0, '\"Sí\";\"Sí\";\"No\"', '', '', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permiso`
--

DROP TABLE IF EXISTS `permiso`;
CREATE TABLE IF NOT EXISTS `permiso` (
  `IdPermiso` int(11) NOT NULL AUTO_INCREMENT,
  `Permiso` varchar(16) NOT NULL,
  `Privilegio` bigint(20) NOT NULL,
  `Estatus` tinyint(1) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `OrigenOperacion` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  `IdEmpresa` int(11) NOT NULL,
  PRIMARY KEY (`IdPermiso`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `permiso`
--

INSERT INTO `permiso` (`IdPermiso`, `Permiso`, `Privilegio`, `Estatus`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`, `IdEmpresa`) VALUES
(1, 'Privilegio1', 1, 1, 0, '2017-04-10 20:05:13', 0, '2017-04-10 20:05:13', 1, 1),
(2, 'Privilegio2', 2, 1, 0, '2017-04-10 20:05:13', 0, '2017-04-10 20:05:13', 1, 1),
(3, 'Privilegio3', 4, 1, 0, '2017-04-10 20:05:13', 0, '2017-04-10 20:05:13', 1, 1),
(4, 'Privilegio4', 8, 1, 0, '2017-04-10 20:05:13', 0, '2017-04-10 20:05:13', 1, 1),
(5, 'Privilegio5', 16, 1, 0, '2017-04-10 20:05:13', 0, '2017-04-10 20:05:13', 1, 1),
(6, 'Privilegio6', 32, 1, 0, '2017-04-10 20:05:13', 0, '2017-04-10 20:05:13', 1, 1),
(7, 'Privilegio7', 64, 1, 0, '2017-04-10 20:05:13', 0, '2017-04-10 20:05:13', 1, 1),
(8, 'Privilegio8', 128, 1, 0, '2017-04-10 20:05:13', 0, '2017-04-10 20:05:13', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prospecto`
--

DROP TABLE IF EXISTS `prospecto`;
CREATE TABLE IF NOT EXISTS `prospecto` (
  `IdProspecto` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) DEFAULT NULL,
  `Apellidos` varchar(100) DEFAULT NULL,
  `FechaNacimiento` timestamp NULL DEFAULT NULL,
  `RFC` varchar(13) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `TelefonoMovil` varchar(15) DEFAULT NULL,
  `TelefonoOtro` varchar(15) DEFAULT NULL,
  `IdSexo` int(11) DEFAULT NULL,
  `Direccion` varchar(250) DEFAULT NULL,
  `Salario` float DEFAULT NULL,
  `IdCiudad` int(11) DEFAULT NULL,
  `IdEstadoCivil` int(11) DEFAULT NULL,
  `IdEscolaridad` int(11) DEFAULT NULL,
  `IdUsuarioCreacion` int(11) DEFAULT NULL,
  `FechaCreacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioUltimoModifico` int(11) DEFAULT NULL,
  `FechaModificacion` timestamp NULL DEFAULT NULL,
  `Estatus` tinyint(1) DEFAULT '1',
  `IdEmpresa` int(11) DEFAULT NULL,
  PRIMARY KEY (`IdProspecto`),
  KEY `IdProspecto` (`IdProspecto`)
) ENGINE=MyISAM AUTO_INCREMENT=39 DEFAULT CHARSET=latin1 COMMENT='tabla para guarar prospectos';

--
-- Volcado de datos para la tabla `prospecto`
--

INSERT INTO `prospecto` (`IdProspecto`, `Nombre`, `Apellidos`, `FechaNacimiento`, `RFC`, `Email`, `TelefonoMovil`, `TelefonoOtro`, `IdSexo`, `Direccion`, `Salario`, `IdCiudad`, `IdEstadoCivil`, `IdEscolaridad`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Estatus`, `IdEmpresa`) VALUES
(1, 'Alejandro', 'Gutierrez', '2018-03-19 06:00:00', 'GURL', 'alex1985jose@gmail.com', '4775646424', '4775646424', 4, 'Cometa 121', 1234, 1, 6, 15, 1, NULL, 4, '2018-03-05 16:46:44', 1, 1),
(2, 'Daniel', 'Daniel', '2018-03-03 06:00:00', NULL, 'alex@gmail.com', '1234', '1234', 4, 'León', 123, 1, 6, 11, 4, '2018-03-03 18:03:38', 4, '2018-03-05 16:46:32', 1, 1),
(6, 'Rolando', 'Roalndo', '2018-03-18 06:00:00', 'ROLA', 'Rolando@miamor.com', '12234', '1234', 4, 'Santa', 12345, 1, 6, 0, 4, '2018-03-04 19:21:55', 11, '2018-03-05 19:11:38', 1, 1),
(8, 'memo', 'memo', '2018-03-11 06:00:00', 'memo', 'memo@memo.com', '1234', '1234', 4, 'Desconocido', 1234, 1, 6, 11, 4, '2018-03-04 19:29:12', 4, '2018-03-05 15:58:34', 1, 1),
(18, 'carlos', 'rangel', '2018-04-01 06:00:00', 'CARLOS', 'carlos@gmail.com', '1234', '1234', 4, 'desconocido', 1234460, 2, 7, 18, 4, '2018-03-04 23:53:22', 4, '2018-03-04 23:53:22', 1, 1),
(10, 'Maribel', 'Gutierrez', '2007-03-07 06:00:00', 'MARI', 'mari@mari.com', '4775646424', '1234', 5, 'Cometa 121', 1234, 2, 8, 13, 4, '2018-03-04 20:03:20', 4, '2018-03-05 18:02:52', 1, 1),
(27, 'pablo', 'pablo', '2018-03-17 06:00:00', 'pablo', 'pablo@pablo.com', '1234', '1234', 4, '1234', 1234, 1, 6, 11, 11, '2018-03-10 19:55:26', 11, '2018-03-10 19:55:26', 1, 1),
(26, 'paco', 'paco', '2018-03-17 06:00:00', '1234', 'paco@gmail.com', '1234', '1234', 4, 'paco', 1234, 1, 6, 0, 11, '2018-03-10 19:47:47', 11, '2018-03-10 19:47:47', 1, 1),
(21, 'Juan', 'Zepeda', '2018-03-10 06:00:00', 'adsfdsafdsaf', 'jcelayah@yahoo.com', '4775772721', '1458855222', 5, 'asdfasf', 12222, 1, 7, 0, 11, '2018-03-09 23:43:29', 11, '2018-03-09 23:43:29', 1, 1),
(22, 'Lorenzo', 'Macias', '2018-03-14 06:00:00', 'acadsfasdf', 'jcelayah@yahoo.com', '2345678765', '234234324', 19, 'fdgsdfgdg', 2222, 2, 7, 0, 11, '2018-03-09 23:44:41', 11, '2018-03-09 23:44:41', 1, 1),
(25, 'pedro', 'pedro', '2018-03-24 06:00:00', 'pedro', 'pedro@gmail.com', '1234', '1234', 5, 'pedro', 12243, 2, 7, 0, 11, '2018-03-10 19:45:02', 0, '2018-03-13 06:21:12', 1, 1),
(24, 'Roger', 'Rangel', '2018-03-24 06:00:00', 'ROFR', 'alex@gmail.com', '12345', '12234', 4, 'alel', 1234, 1, 6, 0, 11, '2018-03-10 19:37:38', 11, '2018-03-10 19:37:38', 1, 1),
(28, 'gaby', 'gaby', '2018-03-17 06:00:00', 'gaby', 'gaby@gaby.com', '12345', '4343242', 5, '41324', 12423, 1, 6, 0, 11, '2018-03-10 20:14:27', 11, '2018-03-10 20:14:27', 1, 1),
(29, 'casas', 'casa', '2018-03-17 06:00:00', 'casa', 'casa#casas.com', '323233', '68', 4, '76768', 6876, 1, 6, 0, 11, '2018-03-10 20:15:55', 11, '2018-03-10 20:15:55', 1, 1),
(30, 'Ceci', 'Ceci', '2018-03-26 06:00:00', 'CECI', 'ceci@ceci.com', '1234566', '6879879', 5, '79879879', 798, 1, 6, 0, 0, '2018-03-12 16:25:34', 0, '2018-03-12 16:25:34', 1, 1),
(31, 'Juan Carlos', 'Torres Gonzalez', '1980-01-02 06:00:00', 'ASDJEDEEDwewe', 'CECE', '33EEEEEE', 'EEEEEE', 4, 'XXXXX', 1234, 1, 7, 13, 0, '2018-03-12 19:20:54', 0, '2018-03-12 19:22:28', 1, 1),
(32, 'Ana', 'lopez', '2008-10-10 05:00:00', 'SDFFSFSFS', 'ana@gmail.com', '7101534', '222222', 5, 'sdasdasd', 123, 1, 6, 13, 0, '2018-03-12 20:32:24', 0, '2018-03-13 06:20:00', 1, 1),
(33, 'kjhkjhkjhk', 'kjhkjhk', '2018-03-20 06:00:00', 'jhkjh', 'a@s.com', '576656757', '987897987', 49, 'hgjhgjhgj', 578687, 1, 44, 13, 0, '2018-03-12 22:56:06', 0, '2018-03-12 22:56:06', 1, 3),
(34, 'nadie', 'nadie', '2018-03-19 06:00:00', 'nadie', 'a@c.a', '1111111', '123', 49, 'a', 12, 1, 44, 11, 0, '2018-03-12 23:18:03', 0, '2018-03-12 23:18:03', 1, 3),
(35, 'Ruth', 'Estrada', '1989-05-10 05:00:00', 'RUTHKDK99', 'r@mail.com', '1776778899', '7101566', 5, 'dddd', 12345, 1, 6, 11, 0, '2018-03-14 22:30:06', 0, '2018-03-14 22:30:06', 1, 1),
(36, 'judith', 'perez', '1989-02-02 06:00:00', 'DFFWAEFWE', 'aad@df.d', '12345', '12345', 5, 'qqqq', 12345, 1, 6, 11, 0, '2018-03-14 22:36:33', 0, '2018-03-14 22:36:33', 1, 1),
(37, 'Juan Jose', 'Rangel', '2018-03-07 06:00:00', 'GURL', 'alex@gmail.com', '1234', '1234', 4, 'aaaaaaaa', 1234, 1, 6, 11, 0, '2018-03-16 00:03:24', 0, '2018-03-16 00:03:24', 1, 1),
(38, 'q', 'q', '2018-03-23 06:00:00', 'q', 'q@g.com', '1', '1', 4, '1', 1, 1, 6, 11, 0, '2018-03-16 17:54:14', 0, '2018-03-16 17:54:14', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prospectocaracteristica`
--

DROP TABLE IF EXISTS `prospectocaracteristica`;
CREATE TABLE IF NOT EXISTS `prospectocaracteristica` (
  `IdProspectoCaracteristica` int(11) NOT NULL AUTO_INCREMENT,
  `IdProspecto` int(11) DEFAULT NULL,
  `Valor` varchar(1024) DEFAULT NULL,
  `IdCaracteristicaParticular` int(11) DEFAULT NULL,
  PRIMARY KEY (`IdProspectoCaracteristica`),
  UNIQUE KEY `IdProspectoCaracteristica_UNIQUE` (`IdProspectoCaracteristica`),
  KEY `FK_ProspectoCaracteristica_idx` (`IdProspecto`),
  KEY `FK_ProspectoCaracteristica_CaractParticular_idx` (`IdCaracteristicaParticular`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prospectodocumentos`
--

DROP TABLE IF EXISTS `prospectodocumentos`;
CREATE TABLE IF NOT EXISTS `prospectodocumentos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IdProspecto` int(11) NOT NULL,
  `IdDocumento` int(11) NOT NULL,
  `Nombre` varchar(150) NOT NULL,
  `Url` varchar(150) NOT NULL,
  `Estatus` tinyint(4) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL,
  `IdUsuarioModificacion` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL,
  `Idempresa` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `prospectodocumentos`
--

INSERT INTO `prospectodocumentos` (`Id`, `IdProspecto`, `IdDocumento`, `Nombre`, `Url`, `Estatus`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioModificacion`, `FechaModificacion`, `Idempresa`) VALUES
(1, 20, 10, 'aasaSASD', 'C:\\Users\\Alejandro Gutiérrez\\Desktop\\macrosVisualBasicParaExcel.pdf', 1, 11, '2018-03-09 23:11:26', 11, '2018-03-09 23:11:26', 1),
(6, 1, 9, 'aaa', 'C:\\fakepath\\CV Vitae Alex.docx', 1, 0, '2018-03-13 05:54:58', 0, '2018-03-13 05:54:58', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reemplazarmvc`
--

DROP TABLE IF EXISTS `reemplazarmvc`;
CREATE TABLE IF NOT EXISTS `reemplazarmvc` (
  `IdRemplazarMVC` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Campo autoincrementable',
  `RealMVC` varchar(45) NOT NULL COMMENT 'Caracter original no permitido en URL de MVC',
  `Reemplazar` varchar(45) NOT NULL COMMENT 'Caracter a reemplazar',
  PRIMARY KEY (`IdRemplazarMVC`),
  UNIQUE KEY `IdRemplazarMVC_UNIQUE` (`IdRemplazarMVC`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Tabla que contiene informacion de caráceres especiales no permitidos en URL de MVC, y se reemplaza por el configurado';

--
-- Volcado de datos para la tabla `reemplazarmvc`
--

INSERT INTO `reemplazarmvc` (`IdRemplazarMVC`, `RealMVC`, `Reemplazar`) VALUES
(1, '+', '@M@'),
(2, '/', '@D@');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `referencialaboral`
--

DROP TABLE IF EXISTS `referencialaboral`;
CREATE TABLE IF NOT EXISTS `referencialaboral` (
  `IdReferencia` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave primaria de la tabla, autoincrementable',
  `IdProspecto` int(11) NOT NULL COMMENT 'Id del prospecto',
  `Empresa` varchar(150) NOT NULL COMMENT 'Nombre empresa',
  `Domicilio` varchar(150) NOT NULL COMMENT 'Domicilio empresa',
  `Contacto` varchar(100) NOT NULL COMMENT 'Nombre contacto',
  `Contacto_Email` varchar(64) NOT NULL COMMENT 'email contacto',
  `Contacto_Telefono` varchar(64) DEFAULT NULL COMMENT 'Telefono contacto',
  `MotivoSeparacion` varchar(150) NOT NULL COMMENT 'Motivo de la separacion',
  `Puesto` varchar(150) NOT NULL COMMENT 'Puesto Ocupado',
  `TiempoLaborado` varchar(64) NOT NULL COMMENT 'tiempo laborado en la empresa',
  `Comentario` varchar(250) NOT NULL COMMENT 'Cmentarios',
  `Estatus` tinyint(1) NOT NULL DEFAULT '1',
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdEmpresa` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`IdReferencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registroscript`
--

DROP TABLE IF EXISTS `registroscript`;
CREATE TABLE IF NOT EXISTS `registroscript` (
  `IdRegistroScript` int(11) NOT NULL AUTO_INCREMENT,
  `NumeroScript` int(11) NOT NULL,
  `NombreScript` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `NombreQuienRealizo` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Fecha` timestamp NOT NULL,
  `DescripcionScript` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`IdRegistroScript`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `registroscript`
--

INSERT INTO `registroscript` (`IdRegistroScript`, `NumeroScript`, `NombreScript`, `NombreQuienRealizo`, `Fecha`, `DescripcionScript`) VALUES
(1, 1, 'Reclutamiento001AG', 'Alejandro Gutiérrez', '2018-02-26 06:00:00', 'alta lista catalogos agregar campo descripcion a -registroScript-'),
(2, 2, 'Reclutamiento002AH', 'Armando Herrera', '2018-02-26 06:00:00', 'Creacion de Vacante, caracteristicas particulares, union entre ambas'),
(3, 3, 'Reclutamiento003AG', 'Alejandro Gutierrez', '2018-02-27 06:00:00', 'Creacion de Prospecto, union entre prospecto y caracteristicas. agregar campo valor a Vacante'),
(4, 4, 'Reclutamiento004AG', 'Alejandro Gutierrez', '2018-02-27 06:00:00', 'Procedimiento ObtProspecto, Agregar Menu Prospecto.'),
(5, 5, 'Reclutamiento005AH', 'Armando Herrera', '2018-02-28 06:00:00', ''),
(6, 6, 'Reclutamiento006AG', 'Alejandro Gutiérrez', '2018-02-28 06:00:00', 'Alta de Tipos Catalogos, Procedimiento ObtProspectos'),
(7, 7, 'Reclutamiento007AH', 'Armando Herrera', '2018-01-03 06:00:00', ''),
(8, 8, 'Reclutamiento008AG', 'Alejandro Gutiérrez', '2018-01-03 06:00:00', 'Agregar IdNacionalidad a estados, Insertar Estados, procedimiento ObtCiudades'),
(9, 9, 'Reclutamiento009AH', 'Armando Herrera', '2018-01-03 06:00:00', ''),
(10, 10, 'Reclutamiento010AG', 'Alejandro Gutiérrez', '2018-01-05 06:00:00', 'Modificar unas tablas de prospectos, agregar porcedimeitnos de prospectos'),
(11, 11, 'Reclutamiento011AG', 'Alejandro Gutiérrez', '2018-01-05 06:00:00', 'Quitar campos CV, Foto a Prospecto, modificar Ins, Act, Obt de Prospectos. cambiar IdProefesion por IdEscolaridad'),
(12, 13, 'Reclutamiento013AG', 'Alejandro Gutiérrez', '2018-01-09 06:00:00', ''),
(13, 13, 'Reclutamiento013AG', 'Alejandro Gutiérrez', '2018-01-09 06:00:00', ''),
(14, 13, 'Reclutamiento013AH', 'Armando Herrera', '2018-12-03 06:00:00', 'Modificar unas tablas de vacantes , agregar porcedimientos de vacantes'),
(15, 17, 'Reclutamiento017AH', 'Armando Herrera', '2018-03-14 06:00:00', 'Modificar la columna de IdCiudad'),
(16, 18, 'Reclutamiento018AH', 'Alejandro Gutiérrez', '2018-03-15 14:47:10', 'Bitacora, Referencias Laborales (tablas y procedimientos)'),
(17, 18, 'Reclutamiento019AH', 'Armando Herrera', '2018-03-16 23:11:06', 'Requerimiento Comentarios y Ciudad Estado Pais');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `IdRol` int(11) NOT NULL AUTO_INCREMENT,
  `NombreRol` varchar(50) DEFAULT NULL,
  `Estatus` tinyint(1) NOT NULL DEFAULT '0',
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `OrigenOperacion` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  `IdEmpresa` int(11) NOT NULL,
  PRIMARY KEY (`IdRol`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`IdRol`, `NombreRol`, `Estatus`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`, `IdEmpresa`) VALUES
(1, 'Capturista', 1, 0, '2018-03-15 17:16:09', 0, '2018-03-15 17:16:09', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rolusuario`
--

DROP TABLE IF EXISTS `rolusuario`;
CREATE TABLE IF NOT EXISTS `rolusuario` (
  `IdRolUsuario` int(11) NOT NULL AUTO_INCREMENT,
  `IdUsuario` int(11) DEFAULT NULL,
  `IdRol` int(11) DEFAULT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `OrigenOperacion` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  `IdEmpresa` int(11) NOT NULL,
  PRIMARY KEY (`IdRolUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `rolusuario`
--

INSERT INTO `rolusuario` (`IdRolUsuario`, `IdUsuario`, `IdRol`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`, `IdEmpresa`) VALUES
(1, 11, 1, 0, '2018-03-15 17:20:20', 0, '2018-03-15 17:20:20', 1, 1),
(2, 12, 1, 0, '2018-03-15 17:20:33', 0, '2018-03-15 17:20:33', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subcatalogo`
--

DROP TABLE IF EXISTS `subcatalogo`;
CREATE TABLE IF NOT EXISTS `subcatalogo` (
  `IdSubCatalogo` int(11) NOT NULL AUTO_INCREMENT,
  `IdCatalogo` int(11) NOT NULL,
  `IdEmpresa` int(11) NOT NULL,
  `Clave` varchar(12) NOT NULL,
  `Nombre` varchar(64) NOT NULL,
  `Descripcion` varchar(256) DEFAULT NULL,
  `IdTipoCatalogo` int(11) NOT NULL,
  `EsActivo` tinyint(1) DEFAULT '1',
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IdSubCatalogo`),
  KEY `_dta_index_SubCatalogo_7_1326627769__K2_K1_3` (`IdCatalogo`,`IdSubCatalogo`,`Nombre`),
  KEY `_dta_index_SubCatalogo_7_1326627769__K1_3` (`IdSubCatalogo`,`Nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoasentamiento`
--

DROP TABLE IF EXISTS `tipoasentamiento`;
CREATE TABLE IF NOT EXISTS `tipoasentamiento` (
  `Clave_Asentamiento` varchar(10) NOT NULL,
  `Nombre` varchar(512) NOT NULL,
  `Clave_Pais` varchar(10) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Clave_Asentamiento`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tipoasentamiento`
--

INSERT INTO `tipoasentamiento` (`Clave_Asentamiento`, `Nombre`, `Clave_Pais`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Estatus`) VALUES
('46', 'Zona naval', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('08', 'Ciudad', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('20', 'Finca', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('47', 'Zona militar', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('18', 'Exhacienda', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('32', 'Villa', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('40', 'Puerto', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('25', 'Ingenio', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('39', 'Club de golf', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('38', 'Ampliación', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('24', 'Hacienda', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('16', 'Estación', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('37', 'Zona industrial', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('45', 'Paraje', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('34', 'Zona federal', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('11', 'Congregación', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('27', 'Poblado comunal', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('23', 'Granja', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('15', 'Ejido', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('26', 'Parque industrial', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('29', 'Ranchería', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('48', 'Rancho', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('33', 'Zona comercial', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('01', 'Aeropuerto', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('22', 'Gran usuario', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('30', 'Residencial', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('10', 'Condominio', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('12', 'Conjunto habitacional', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('17', 'Equipamiento', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('04', 'Campamento', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('21', 'Fraccionamiento', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('02', 'Barrio', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('31', 'Unidad habitacional', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('28', 'Pueblo', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1),
('09', 'Colonia', '01', 0, '2018-03-13 17:55:21', 0, '2018-03-13 17:55:21', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipocatalogo`
--

DROP TABLE IF EXISTS `tipocatalogo`;
CREATE TABLE IF NOT EXISTS `tipocatalogo` (
  `IdEmpresa` int(11) NOT NULL,
  `IdTipoCatalogo` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `NombreSingular` varchar(100) DEFAULT NULL,
  `TipoSubCatalogo` int(11) DEFAULT '0',
  `IdTipoCatalogo_SubCatalogo` int(11) DEFAULT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Visible` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdTipoCatalogo`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipocatalogo`
--

INSERT INTO `tipocatalogo` (`IdEmpresa`, `IdTipoCatalogo`, `Nombre`, `NombreSingular`, `TipoSubCatalogo`, `IdTipoCatalogo_SubCatalogo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Visible`) VALUES
(1, 1, 'Estado Civil', 'EstadoCivil', 0, 16, 1, '2018-02-06 06:00:00', 1, '2018-02-06 06:00:00', 1),
(1, 2, 'Generos', 'Generos', 0, 16, 1, '2018-02-06 06:00:00', 1, '2018-02-06 06:00:00', 1),
(1, 3, 'Escolaridad', 'Escolaridad', 0, 16, 1, '2018-02-06 06:00:00', 1, '2018-02-06 06:00:00', 1),
(1, 4, 'Documentos', 'Documentos', 0, 16, 1, '2018-02-06 06:00:00', 1, '2018-02-06 06:00:00', 1),
(1, 5, 'Tipo Contrato', 'TipoContrato', 0, 16, 1, '2018-02-28 21:16:58', 1, '2018-02-28 21:16:58', 1),
(1, 6, 'Tipo Jornada', 'TipoJornada', 0, 16, 1, '2018-02-28 21:16:58', 1, '2018-02-28 21:16:58', 1),
(1, 7, 'Tipo Fase', 'TipoFase', 0, 16, 1, '2018-02-28 21:37:20', 1, '2018-02-28 21:37:20', 1),
(1, 8, 'Pais', 'Pais', 0, 16, 1, '2018-03-02 23:05:59', 1, '2018-03-02 23:05:59', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE IF NOT EXISTS `usuario` (
  `IdUsuario` int(11) NOT NULL AUTO_INCREMENT,
  `IdEmpresa` int(11) NOT NULL,
  `Login` varchar(250) NOT NULL,
  `NombreCompleto` varchar(250) DEFAULT NULL,
  `CorreoElectronico` varchar(250) DEFAULT NULL,
  `Contrasenia` varchar(100) NOT NULL,
  `Activo` tinyint(1) NOT NULL DEFAULT '1',
  `CodigoRecuperaContrasenia` varchar(20) DEFAULT NULL,
  `UsuarioId` int(11) DEFAULT '0',
  `UltimoModifico` int(11) NOT NULL DEFAULT '0',
  `Comentarios` varchar(512) DEFAULT NULL,
  `IdInstitucion` int(11) DEFAULT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `OrigenOperacion` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  `Domicilio` varchar(250) DEFAULT NULL,
  `Telefono` varchar(32) DEFAULT '',
  `Referencia` varchar(100) DEFAULT NULL,
  `ReferenciaTelefono` varchar(32) DEFAULT NULL,
  `FechaNacimiento` date DEFAULT NULL,
  PRIMARY KEY (`IdUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`IdUsuario`, `IdEmpresa`, `Login`, `NombreCompleto`, `CorreoElectronico`, `Contrasenia`, `Activo`, `CodigoRecuperaContrasenia`, `UsuarioId`, `UltimoModifico`, `Comentarios`, `IdInstitucion`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`, `Domicilio`, `Telefono`, `Referencia`, `ReferenciaTelefono`, `FechaNacimiento`) VALUES
(1, 1, 'jessica', 'Jessica Robles Martinez', 'jcelayah@gmail.com', 'aCjB6zZI4Qmgwr6c2j5GpA==', 1, NULL, 0, 3, 'Comentarios', NULL, 0, '2017-10-13 19:47:55', 3, '2017-11-06 00:33:37', 1, 'Calle Irack 125\nSan Felipe de Jesus', '477 577 2821', 'Ninguna', 'Ninguna', '2017-10-13'),
(11, 1, 'alex', 'Alejandro Gutierrez', 'alex@HumanFactory.com', '+8gNci97Kp/Rex0XrtGLlg==', 1, NULL, 0, 0, NULL, NULL, 4, '2018-03-05 18:20:27', 0, '2018-03-15 17:20:20', 1, 'Cometa 121', '4775646424', NULL, NULL, '1985-03-09'),
(12, 1, 'cmedina', 'Cecilia Medina', 'cmedina@HumanFactory.com', '+8gNci97Kp/Rex0XrtGLlg==', 1, NULL, 0, 0, NULL, NULL, 11, '2018-03-05 21:53:08', 0, '2018-03-15 17:20:33', 1, 'Federico Baena 316', '4776027802', NULL, NULL, '1993-04-29'),
(13, 3, 'ceci', 'Ceci', 'ceci@Alex.com', '+8gNci97Kp/Rex0XrtGLlg==', 1, NULL, 0, 0, NULL, NULL, 0, '2018-03-11 03:11:03', 0, '2018-03-11 03:11:03', 1, NULL, '1234567', NULL, NULL, '2018-03-10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vacante`
--

DROP TABLE IF EXISTS `vacante`;
CREATE TABLE IF NOT EXISTS `vacante` (
  `IdVacante` int(11) NOT NULL AUTO_INCREMENT,
  `Titulo` varchar(100) DEFAULT NULL,
  `Descripcion` varchar(100) DEFAULT NULL,
  `FechaContratacion` date DEFAULT NULL,
  `NumeroVacantes` int(11) DEFAULT NULL,
  `Salario` double DEFAULT NULL,
  `IdTipoContrato` int(11) DEFAULT NULL,
  `IdTipoJornada` int(11) DEFAULT NULL,
  `IdCiudad` varchar(10) DEFAULT NULL,
  `IdUsuarioCreacion` int(11) DEFAULT NULL,
  `FechaCreacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioUltimoModifico` int(11) DEFAULT NULL,
  `FechaModificacion` timestamp NULL DEFAULT NULL,
  `Estatus` tinyint(4) DEFAULT NULL,
  `IdEmpresa` int(11) DEFAULT NULL,
  `Comentarios` varchar(300) DEFAULT NULL,
  `Fase` int(11) DEFAULT '0',
  `FechaEntrega` date DEFAULT NULL,
  PRIMARY KEY (`IdVacante`),
  KEY `IdVacante` (`IdVacante`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='tabla para guarar vacantes									';

--
-- Volcado de datos para la tabla `vacante`
--

INSERT INTO `vacante` (`IdVacante`, `Titulo`, `Descripcion`, `FechaContratacion`, `NumeroVacantes`, `Salario`, `IdTipoContrato`, `IdTipoJornada`, `IdCiudad`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Estatus`, `IdEmpresa`, `Comentarios`, `Fase`, `FechaEntrega`) VALUES
(1, 'Guardia de Seguridad', 'Guardia de Seguridad', '2018-06-01', 5, 6666, 33, 37, '01,01,011', 11, '2018-03-09 23:20:13', 0, '2018-03-13 19:44:30', 1, 1, NULL, 32, '2018-03-30'),
(2, 'Tester', 'tester', '2018-05-01', 1, 123, 25, 28, '01,04,011', 0, '2018-03-12 19:35:04', 0, '2018-03-12 23:25:20', 1, 1, NULL, 32, '2018-03-12'),
(3, 'Abogado', 'Derecho penal', '2018-03-31', 1, 123, -1, -1, '01,01,011', 0, '2018-03-12 19:35:05', 0, '2018-03-13 21:53:36', 0, 1, NULL, -1, '2018-03-15'),
(4, 'Compras', 'Administracion', '2018-03-12', 1, 123, 24, 28, '01,04,011', 0, '2018-03-12 19:35:06', 0, '2018-03-12 23:16:36', 1, 1, NULL, 32, '2018-03-08'),
(5, 'Analista', 'desarrollador', '2018-03-12', 3, 123, -1, -1, '01,01,011', 0, '2018-03-12 19:35:06', 0, '2018-03-12 19:40:33', 0, 1, NULL, -1, '2018-03-08'),
(6, 'Capturista', 'Informatica', '2018-03-12', 1, 123, -1, -1, '01,01,011', 0, '2018-03-12 19:35:07', 0, '2018-03-12 19:41:06', 0, 1, NULL, -1, '2018-03-08'),
(7, 'Doctor', 'Pediatra', '2018-03-07', 1, 123, 25, 37, '01,01,011', 0, '2018-03-12 19:35:08', 0, '2018-03-12 23:17:44', 1, 1, NULL, 32, '2018-03-02'),
(8, 'Cortador', 'n/a', '2018-03-12', 3, 123, -1, -1, '01,01,011', 0, '2018-03-12 19:35:08', 0, '2018-03-12 19:42:17', 0, 1, NULL, -1, '2018-03-08'),
(9, 'Publicista', 'ninguna', '2018-03-12', 1, 123, -1, -1, '01,01,011', 0, '2018-03-12 19:35:09', 0, '2018-03-12 19:42:41', 0, 1, NULL, -1, '2018-03-08'),
(10, 'contador', 'contadorx', '2018-03-12', 1, 123, -1, -1, '01,01,011', 0, '2018-03-12 19:35:10', 0, '2018-03-12 19:35:10', 0, 1, NULL, -1, '2018-03-08'),
(11, 'Coordinador de Proyectos', 'Ingeniero Industrial', '2018-03-12', 2, 123, -1, -1, '01,01,011', 0, '2018-03-12 19:35:11', 0, '2018-03-12 19:43:28', 0, 1, NULL, -1, '2018-03-08'),
(12, 'Secretaria', 'Secretaria', '2018-03-12', 1, 123, -1, -1, '01,01,011', 0, '2018-03-12 19:35:12', 0, '2018-03-12 19:38:46', 0, 1, NULL, -1, '2018-03-08'),
(13, 'Administrador', 'Administrador de empresas', '2018-03-12', 1, 123, 24, 29, '01,01,011', 0, '2018-03-12 19:35:13', 0, '2018-03-13 18:01:05', 1, 1, NULL, 32, '2018-03-08'),
(14, 'desarrollador', 'desarrollador jr', '2018-03-12', 1, 123, -1, -1, '01,01,011', 0, '2018-03-12 19:35:14', 0, '2018-03-12 19:37:25', 1, 1, NULL, -1, '2018-03-08'),
(15, 'QWEDD', 'DER', '2018-03-10', 1, 123, -1, -1, '01,01,011', 0, '2018-03-12 22:26:07', 0, '2018-03-12 22:29:32', 1, 1, NULL, -1, '2018-03-08'),
(16, 'Desarrollador JR', 'Informatica', '2018-04-07', 1, 12345, 24, 28, '01,01,011', 0, '2018-03-12 23:35:02', 0, '2018-03-12 23:35:02', 0, 1, NULL, 32, '2018-03-08'),
(17, 'Arquitecto', 'Licenciado en Arquitectura', '2018-02-12', 1, 12345, 33, 29, '01,01,011', 0, '2018-03-13 18:04:00', 0, '2018-03-13 18:04:00', 0, 1, NULL, 32, '2018-04-01'),
(18, 'Diseñador de Interiores', 'Licenciado en Diseño', '2018-04-12', 2, 11111, 25, 28, '01,01,011', 0, '2018-03-13 18:04:10', 0, '2018-03-13 18:07:09', 1, 1, NULL, 30, '2018-04-01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vacantecaracteristica`
--

DROP TABLE IF EXISTS `vacantecaracteristica`;
CREATE TABLE IF NOT EXISTS `vacantecaracteristica` (
  `IdVacanteCaracteristica` int(11) NOT NULL AUTO_INCREMENT,
  `Valor` varchar(1024) NOT NULL,
  `IdVacante` int(11) DEFAULT NULL,
  `IdCaracteristicaParticular` int(11) DEFAULT NULL,
  `Comentario` varchar(255) NOT NULL,
  `Activo` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`IdVacanteCaracteristica`),
  UNIQUE KEY `IdVacanteCaracteristica_UNIQUE` (`IdVacanteCaracteristica`),
  KEY `FK_VacanteCaracteristica_idx` (`IdVacante`),
  KEY `FK_VacanteCaracteristica_CaractParticular_idx` (`IdCaracteristicaParticular`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `formapermiso`
--
ALTER TABLE `formapermiso`
  ADD CONSTRAINT `FK_FormaPermiso_Forma` FOREIGN KEY (`IdForma`) REFERENCES `forma` (`IdForma`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_FormaPermiso_Permiso` FOREIGN KEY (`IdPermiso`) REFERENCES `permiso` (`IdPermiso`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `formarol`
--
ALTER TABLE `formarol`
  ADD CONSTRAINT `FK_FormaRol_Forma` FOREIGN KEY (`IdForma`) REFERENCES `forma` (`IdForma`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_FormaRol_Roles` FOREIGN KEY (`IdRol`) REFERENCES `roles` (`IdRol`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `nacionalidad`
--
ALTER TABLE `nacionalidad`
  ADD CONSTRAINT `R_54` FOREIGN KEY (`IdUsuarioCreacion`) REFERENCES `usuario` (`IdUsuario`),
  ADD CONSTRAINT `R_60` FOREIGN KEY (`IdUsuarioUltimoModifico`) REFERENCES `usuario` (`IdUsuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
