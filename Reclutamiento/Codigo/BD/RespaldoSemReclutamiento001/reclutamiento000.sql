-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 26-02-2018 a las 17:32:01
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
DROP PROCEDURE IF EXISTS `ActCartera`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCartera` (`pIdCartera` INT, `pIdEmpresa` INT, `pIdCliente` INT, `pClave` VARCHAR(16), `pNombre` VARCHAR(64), `pComentarios` VARCHAR(128), `pActivo` TINYINT(1), `pIdUsuarioLog` INT)  BEGIN

IF (SELECT COUNT(1)
 		from cliente 
 		where	IdCliente = pIdCliente
 				AND Activo = 0
                AND IdEmpresa = pIdEmpresa) != 0 THEN
		SELECT 'Error al actualizar: El Cliente que intenta guardar esta inactivo.' as ErrorMessage;
 	ELSE
		UPDATE `cartera`
		SET		
			`Clave` = pClave,
			`Nombre` = pNombre,
			`IdCliente` = pIdCliente,
			`Comentarios` = pComentarios,
			`Activo` = pActivo,
			`IdUsuarioCreacion` = pIdUsuarioLog,
			`FechaCreacion` = now(),
			`IdUsuarioUltimoModifico` = pIdUsuarioLog,
			`FechaModificacion` = now()
		WHERE `IdCartera` = pIdCartera
				AND `IdEmpresa` = pIdEmpresa;
        
        SELECT null as ErrorMessage;
        
	END IF;

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
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCliente` (IN `pIdCliente` INT, IN `pIdEmpresa` INT, IN `pRFC` VARCHAR(13), IN `pRazonSocial` VARCHAR(96), IN `pNombreComercial` VARCHAR(64), IN `pDireccion` VARCHAR(250), IN `pContacto_Nombre` VARCHAR(64), IN `pContacto_Email` VARCHAR(64), IN `pContacto_Telefono` VARCHAR(32), IN `pComentarios` VARCHAR(128), IN `pActivo` TINYINT(1), IN `pIdUsuarioLog` INT, IN `pEmpresaCorreo` VARCHAR(64), IN `pEmpresaTelefono` VARCHAR(64))  BEGIN

IF (SELECT COUNT(1)
 		from cliente 
 		where	RFC = pRFC 
				and IdCliente != pIdCliente
 				and Activo = 1
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
			Activo = pActivo,
			IdUsuarioUltimoModifico = pIdUsuarioLog,
			FechaModificacion = now()
		WHERE IdCliente = pIdCliente
			  and IdEmpresa = pIdEmpresa;
        
        SELECT null as ErrorMessage;
        
	END IF;

END$$

DROP PROCEDURE IF EXISTS `ActDeudorAsignacion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActDeudorAsignacion` (`pIdDeudor` INT, `pIdEmpresa` INT, `pIdAnalista` INT, `pIdUsuarioLog` INT)  BEGIN

	UPDATE deudor
    SET	IdUsuarioAsignado = pIdAnalista,
		IdUsuarioUltimoModifico = pIdUsuarioLog,
		FechaModificacion = now()
    WHERE IdDeudor = pIdDeudor
		and IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ActEmpresa`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActEmpresa` (`pIdEmpresa` INT(11), `pDominio` VARCHAR(64), `pProductKey` VARCHAR(256), `pAdministrador` VARCHAR(30), `pContraseña` VARCHAR(250), `pNombreComercial` VARCHAR(100), `pRutaLogo` VARCHAR(200))  BEGIN

	UPDATE empresa
	SET
		Dominio = pDominio,
		ProductKey = pProductKey,
		Administrador = pAdministrador,
		Contraseña = pContraseña,
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

DROP PROCEDURE IF EXISTS `ActSegmento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActSegmento` (`pIdSegmento` INT(11), `pIdEmpresa` INT(11), `pIdCartera` INT(11), `pSegmento` VARCHAR(64), `pArchivo` VARCHAR(200), `pEsActivo` TINYINT(1), `pIdUsuarioLog` INT)  BEGIN
	DECLARE pId INT;
    SET pId = 0;
    
    IF NOT EXISTS (	SELECT 1 
					FROM 
						segmento 
					WHERE 
						IdEmpresa = pIdEmpresa
                        AND IdCartera = pIdCartera
						AND Segmento = pSegmento
                        AND IdSegmento != pIdSegmento) THEN
                        
		UPDATE segmento
		SET
			IdCartera = pIdCartera,
			Segmento = pSegmento,
			Archivo = pArchivo,
			EsActivo = pEsActivo,
			IdUsuarioUltimoModifico = pIdUsuarioLog,
			FechaModificacion = now()
		WHERE IdSegmento = pIdSegmento
				and IdEmpresa = pIdEmpresa;
                
		SET pId = pIdSegmento;
        
	END IF;
        
    SELECT pId as Id;
    
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

DROP PROCEDURE IF EXISTS `EliColumnaSegmento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliColumnaSegmento` (`pIdSegmento` INT, `pIdEmpresa` INT)  BEGIN
		
	DELETE FROM mapeocolumnasegmento 
	WHERE 
		IdSegmento = pIdSegmento 
		AND IdEmpresa = pIdEmpresa;
	
	DELETE FROM columnasegmento 
	WHERE 
		IdSegmento = pIdSegmento 
		AND IdEmpresa = pIdEmpresa;
    
END$$

DROP PROCEDURE IF EXISTS `EliErrorImportarDeudores`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliErrorImportarDeudores` (`pIdSegmento` INT(11), `pIdEmpresa` INT)  BEGIN
	
   DELETE
   FROM deudordetalleerror
   WHERE
	IdEmpresa = pIdEmpresa
	AND IdSegmento = pIdSegmento;
   
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

DROP PROCEDURE IF EXISTS `Eli_DetalleCartera`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Eli_DetalleCartera` (`pIdCartera` INT)  BEGIN
	SET SQL_SAFE_UPDATES = 0;
	
    DELETE FROM estatuscartera WHERE IdCartera = pIdCartera;
	DELETE FROM deudordetalleerror WHERE IdSegmento IN (	SELECT s.IdSegmento 
															FROM segmento s
															where s.IdCartera = pIdCartera);
	DELETE FROM mapeocolumnasegmento WHERE IdSegmento IN (	SELECT s.IdSegmento 
															FROM segmento s
															where s.IdCartera = pIdCartera);
    DELETE FROM columnasegmento WHERE IdSegmento IN (	SELECT s.IdSegmento 
														FROM segmento s 
                                                        where s.IdCartera = pIdCartera);                                                        
    DELETE FROM columnasegmento WHERE IdSegmento IN (	SELECT s.IdSegmento 
														FROM segmento s 
                                                        where s.IdCartera = pIdCartera);
	DELETE FROM acuerdopago WHERE IdDeudor IN (	SELECT d.IdDeudor 
												FROM deudor d 
                                                INNER JOIN segmento s on s.IdSegmento = d.IdSegmento
                                                where s.IdCartera = pIdCartera);
	DELETE FROM agendarllamadadeudor WHERE IdDeudor IN (	SELECT d.IdDeudor 
															FROM deudor d 
															INNER JOIN segmento s on s.IdSegmento = d.IdSegmento
															where s.IdCartera = pIdCartera);
	DELETE FROM datoscontactodeudor WHERE IdDeudor IN (	SELECT d.IdDeudor 
														FROM deudor d 
														INNER JOIN segmento s on s.IdSegmento = d.IdSegmento
														where s.IdCartera = pIdCartera);
	DELETE FROM pagocomprobado WHERE IdDeudor IN (	SELECT d.IdDeudor 
													FROM deudor d 
													INNER JOIN segmento s on s.IdSegmento = d.IdSegmento
													where s.IdCartera = pIdCartera);
	DELETE FROM seguimientodeudor WHERE IdDeudor IN (	SELECT d.IdDeudor 
														FROM deudor d 
														INNER JOIN segmento s on s.IdSegmento = d.IdSegmento
														where s.IdCartera = pIdCartera);
	DELETE FROM deudor WHERE IdSegmento IN (	SELECT s.IdSegmento 
												FROM segmento s
												where s.IdCartera = pIdCartera);
	DELETE FROM segmento where IdCartera = pIdCartera;
	DELETE FROM cartera where IdCartera = pIdCartera;
    
    SET SQL_SAFE_UPDATES = 1;
    
END$$

DROP PROCEDURE IF EXISTS `InsAcuerdoPago`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsAcuerdoPago` (`pIdDeudor` INT, `pIdEmpresa` INT, `pIdEstatus` INT, `pFechaPago` DATETIME, `pCantidad` DECIMAL(20,2), `pComentarios` VARCHAR(200), `pIdUsuarioLog` INT, `pIdTipoGestion` INT, `pIdAnalista` INT, `pTelefonoMarcado` VARCHAR(32))  BEGIN

	DECLARE pFechaActual DATETIME;
    DECLARE pMontoPromesa DECIMAL(20,1);
    SET pFechaActual = NOW();
	
    INSERT INTO `acuerdopago`
	(
	`IdDeudor`,
	`IdEmpresa`,
    IdTipoGestion,
	`IdEstatus`,
	`FechaPago`,
	`Cantidad`,
	`Comentarios`,
	`IdUsuarioCreacion`,
	`FechaCreacion`,
	`IdUsuarioUltimoModifico`,
	`FechaModificacion`,
    `IdAnalista`,
    TelefonoMarcado)
	VALUES
	(
	pIdDeudor,
	pIdEmpresa,
    pIdTipoGestion,
	pIdEstatus,
	pFechaPago,
	pCantidad,
	pComentarios,
	pIdUsuarioLog,
	pFechaActual,
	pIdUsuarioLog,
	pFechaActual,
    pIdAnalista,
    pTelefonoMarcado);
	
    SET pMontoPromesa = IFNULL((SELECT SUM(Cantidad) from acuerdopago WHERE IdDeudor = pIdDeudor AND IdEmpresa = pIdEmpresa), 0); 
    
    UPDATE Deudor
    SET
		FechaUltimoContacto = pFechaActual,
        IdAnalistaUltimoContacto = pIdAnalista,
        IdTipoGestion = pIdTipoGestion,
        IdEstatus = pIdEstatus,
        MontoPromesa = pMontoPromesa,
		FechaMostrado = now(),
        TelefonoMarcado = pTelefonoMarcado
	WHERE
		IdDeudor = pIdDeudor
        AND IdEmpresa = pIdEmpresa;
	
    select pFechaActual as Fecha,
		pMontoPromesa as MontoPromesa;
    
END$$

DROP PROCEDURE IF EXISTS `InsAgendarLlamadaDeudor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsAgendarLlamadaDeudor` (`pIdDeudor` INT, `pIdEmpresa` INT, `pFechaAgenda` DATETIME, `pTelefono` VARCHAR(45), `pComentarios` VARCHAR(200), `pIdUsuarioLog` INT, `pIdAnalista` INT, `pTelefonoMarcado` VARCHAR(32))  BEGIN
	DECLARE pFechaActual 	DATETIME;
    DECLARE pIdTipoGestion 	INT;
    DECLARE pIdEstatus 		INT;
    
    SET pFechaActual = NOW();
    
    SET pIdTipoGestion = (	SELECT 
								IdTipoGestion 
							from deudor 
                            WHERE
							IdDeudor = pIdDeudor
							AND IdEmpresa = pIdEmpresa);
                            
    SET pIdEstatus = 	(	SELECT 
								IdEstatus 
							from deudor 
                            WHERE
							IdDeudor = pIdDeudor
							AND IdEmpresa = pIdEmpresa);
        
    INSERT INTO `agendarllamadadeudor`
	(
	`IdDeudor`,
	`IdEmpresa`,
	`FechaAgenda`,
	`Telefono`,
	`Comentarios`,
	`IdUsuarioCreacion`,
	`FechaCreacion`,
	`IdUsuarioUltimoModifico`,
	`FechaModificacion`,
	`Atendido`,
    `IdAnalista`,
    IdTipoGestion,
    IdEstatus,    
    TelefonoMarcado)
	VALUES
	(
	pIdDeudor,
	pIdEmpresa,
	pFechaAgenda,
	pTelefono,
	pComentarios,
	pIdUsuarioLog,
	pFechaActual,
	pIdUsuarioLog,
	pFechaActual,
	0,
    pIdAnalista,
    pIdTipoGestion,
    pIdEstatus,
    pTelefonoMarcado);
    
    UPDATE Deudor
    SET 
		FechaUltimoContacto = pFechaActual,
        IdAnalistaUltimoContacto = pIdAnalista,
		FechaMostrado = now(),
        TelefonoMarcado = pTelefonoMarcado
	WHERE
		IdDeudor = pIdDeudor
        AND IdEmpresa = pIdEmpresa;
	
    select pFechaActual as Fecha;
    
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

DROP PROCEDURE IF EXISTS `InsCartera`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCartera` (`pIdEmpresa` INT, `pIdCliente` INT, `pClave` VARCHAR(16), `pNombre` VARCHAR(64), `pComentarios` VARCHAR(128), `pActivo` TINYINT(1), `pIdUsuarioLog` INT)  BEGIN
	DECLARE pIdCartera INT;

	IF (SELECT COUNT(1)
 		from cliente 
 		where	IdCliente = pIdCliente
 				AND Activo = 0
                AND IdEmpresa = pIdEmpresa) != 0 THEN
		SELECT 'Error al insertar: El Cliente que intenta guardar esta inactivo.' as ErrorMessage;
 	ELSE
		INSERT INTO `cartera`
		(
		`IdEmpresa`,
		`Clave`,
		`Nombre`,
		`IdCliente`,
		`Comentarios`,
		`Activo`,
		`IdUsuarioCreacion`,
		`FechaCreacion`,
		`IdUsuarioUltimoModifico`,
		`FechaModificacion`)
		VALUES
		(
		pIdEmpresa,
		pClave,
		pNombre,
		pIdCliente,
		pComentarios,
		pActivo,
		pIdUsuarioLog,
		now(),
		pIdUsuarioLog,
		now());
        
        set pIdCartera = (SELECT MAX(IdCartera) from cartera);
        SELECT null as ErrorMessage, pIdCartera as IdCartera;
        
	END IF;

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

DROP PROCEDURE IF EXISTS `InsCliente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCliente` (IN `pIdEmpresa` INT, IN `pRFC` VARCHAR(13), IN `pRazonSocial` VARCHAR(96), IN `pNombreComercial` VARCHAR(64), IN `pDireccion` VARCHAR(250), IN `pContacto_Nombre` VARCHAR(64), IN `pContacto_Email` VARCHAR(64), IN `pContacto_Telefono` VARCHAR(32), IN `pComentarios` VARCHAR(128), IN `pActivo` TINYINT(1), IN `pIdUsuarioLog` INT, IN `pEmpresaCorreo` VARCHAR(64), IN `pEmpresaTelefono` VARCHAR(64))  BEGIN
    DECLARE pIdCliente INT;
    
 	IF (SELECT COUNT(1)
 		from cliente 
 		where	RFC = pRFC 
 				and Activo = 1
                AND IdEmpresa = pIdEmpresa) != 0 THEN
		SELECT 'Error al insertar: El RFC del cliente que intenta guardar ya esta siendo utilizado.' as ErrorMessage;
	    
 	ELSE
 		
        INSERT INTO empresa.cliente
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
		Activo,
		IdUsuarioCreacion,
		FechaCreacion,
		IdUsuarioUltimoModifico,
		FechaModificacion)
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
		pActivo,
		pIdUsuarioLog,
		now(),
		pIdUsuarioLog,
		now());
        
		set pIdCliente = (SELECT MAX(IdCliente) from cliente);
        SELECT null as ErrorMessage, pIdCliente as IdCliente;
        
	END IF;
    
END$$

DROP PROCEDURE IF EXISTS `InsColumnaSegmento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsColumnaSegmento` (`pIdSegmento` INT, `pIdEmpresa` INT, `pEncabezado` VARCHAR(60), `pColumna` VARCHAR(10))  BEGIN    
   
		INSERT INTO columnasegmento
		(
		IdSegmento,
		IdEmpresa,
		Encabezado,
        Columna)
		VALUES
		(
		pIdSegmento,
		pIdEmpresa,
		pEncabezado,
        pColumna);
    
END$$

DROP PROCEDURE IF EXISTS `InsContactoDeudor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsContactoDeudor` (`pIdDeudor` INT, `pIdEmpresa` INT, `pValidado` TINYINT(1), `pTelefono` VARCHAR(32), `pCorreoElectronico` VARCHAR(250), `pCalleNum` VARCHAR(150), `pColonia` VARCHAR(50), `pCiudad` VARCHAR(50), `pEstado` VARCHAR(50), `pComentarios` VARCHAR(512), `pIdUsuarioLog` INT, `pConsecutivo` INT)  BEGIN
    
    if not exists (	SELECT 1 
					FROM 
						datoscontactodeudor 
					WHERE 
						IdEmpresa = pIdEmpresa
                        and IdDeudor = pIdDeudor
                        and Consecutivo = pConsecutivo) THEN
		INSERT INTO datoscontactodeudor
		(
		IdEmpresa,
		IdDeudor,
		Validado,
		Telefono,
		CorreoElectronico,
		CalleNum,
		Colonia,
		Ciudad,
		Estado,
		Comentarios,
		IdUsuarioCreacion,
		FechaCreacion,
		IdUsuarioUltimoModifico,
		FechaModificacion,
		Consecutivo)
		VALUES
		(
		pIdEmpresa,
		pIdDeudor,
		pValidado,
		pTelefono,
		pCorreoElectronico,
		pCalleNum,
		pColonia,
		pCiudad,
		pEstado,
		pComentarios,
		pIdUsuarioLog,
		now(),
		pIdUsuarioLog,
		now(),
		pConsecutivo);
    ELSE
		UPDATE datoscontactodeudor
		SET
		Validado = pValidado,
		Telefono = pTelefono,
		CorreoElectronico = pCorreoElectronico,
		CalleNum = pCalleNum,
		Colonia = pColonia,
		Ciudad = pCiudad,
		Estado = pEstado,
		Comentarios = pComentarios,
		IdUsuarioUltimoModifico = pIdUsuarioLog,
		FechaModificacion = now()
		WHERE 
			IdEmpresa = pIdEmpresa
			AND IdDeudor = pIdDeudor
			AND Consecutivo = pConsecutivo;

    END IF;
    
END$$

DROP PROCEDURE IF EXISTS `InsDeudor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsDeudor` (`pIdEmpresa` INT(11), `pIdSegmento` INT(11), `pCredito` VARCHAR(16), `pNombre` VARCHAR(64), `pRFC` VARCHAR(16), `pCalleNumero` VARCHAR(64), `pCP` VARCHAR(6), `pColonia` VARCHAR(64), `pCiudad` VARCHAR(64), `pEstado` VARCHAR(32), `pTelFijo` VARCHAR(32), `pTelCelular` VARCHAR(16), `pTelAdicional1` VARCHAR(32), `pTelAdicional2` VARCHAR(32), `pTelAdicional3` VARCHAR(32), `pImporteDeuda` DECIMAL(15,2), `pPorcentajeDescuento` DECIMAL(5,2), `pDiasdeMora` INT(11), `pPagoDescuento1` DECIMAL(15,2), `pPagoDescuento2` DECIMAL(15,2), `pMontoPrestamo` DECIMAL(15,2), `pFechaAsignacion` TIMESTAMP, `pFechaVencimiento` TIMESTAMP, `pFechaOtorgamiento` TIMESTAMP, `pSaldoActual` DECIMAL(15,2), `pTipoPrestamo` VARCHAR(32), `pNombreGrupo` VARCHAR(32), `pNumeroGrupo` VARCHAR(32), `pBanco` VARCHAR(64), `pReferencia` VARCHAR(64), `pConvenioPago` VARCHAR(64), `pEstatus` TINYINT(1), `pAdicionalTexto1` VARCHAR(64), `pAdicionalTexto2` VARCHAR(64), `pAdicionalTexto3` VARCHAR(64), `pAdicionalTexto4` VARCHAR(64), `pAdicionalTexto5` VARCHAR(64), `pAdicionalFecha` TIMESTAMP, `pAdicionalMoneda` DECIMAL(15,2), `pAdicionalEntero` INT(11), `pAdicionalEstatus` TINYINT(1), `pEsActivo` TINYINT(1), `pIdUsuarioLog` INT, `pRowIndex` INT)  BEGIN
	
    INSERT INTO deudor
	(
	IdEmpresa,
	IdSegmento,
	Credito,
	Nombre,
	RFC,
	CalleNumero,
	CP,
	Colonia,
	Ciudad,
	Estado,
	TelFijo,
	TelCelular,
	TelAdicional1,
	TelAdicional2,
	TelAdicional3,
	ImporteDeuda,
	PorcentajeDescuento,
	DiasdeMora,
	PagoDescuento1,
	PagoDescuento2,
	MontoPrestamo,
	FechaAsignacion,
	FechaVencimiento,
	FechaOtorgamiento,
	SaldoActual,
	TipoPrestamo,
	NombreGrupo,
	NumeroGrupo,
	Banco,
	Referencia,
	ConvenioPago,
	Estatus,
	AdicionalTexto1,
	AdicionalTexto2,
	AdicionalTexto3,
	AdicionalTexto4,
	AdicionalTexto5,
	AdicionalFecha,
	AdicionalMoneda,
	AdicionalEntero,
	AdicionalEstatus,
	EsActivo,
	IdUsuarioCreacion,
	FechaCreacion,
	IdUsuarioUltimoModifico,
	FechaModificacion,
    RowIndex)
	VALUES
	(
	pIdEmpresa,
	pIdSegmento,
	pCredito,
	pNombre,
	pRFC,
	pCalleNumero,
	pCP,
	pColonia,
	pCiudad,
	pEstado,
	pTelFijo,
	pTelCelular,
	pTelAdicional1,
	pTelAdicional2,
	pTelAdicional3,
	pImporteDeuda,
	pPorcentajeDescuento,
	pDiasdeMora,
	pPagoDescuento1,
	pPagoDescuento2,
	pMontoPrestamo,
	pFechaAsignacion,
	pFechaVencimiento,
	pFechaOtorgamiento,
	pSaldoActual,
	pTipoPrestamo,
	pNombreGrupo,
	pNumeroGrupo,
	pBanco,
	pReferencia,
	pConvenioPago,
	pEstatus,
	pAdicionalTexto1,
	pAdicionalTexto2,
	pAdicionalTexto3,
	pAdicionalTexto4,
	pAdicionalTexto5,
	pAdicionalFecha,
	pAdicionalMoneda,
	pAdicionalEntero,
	pAdicionalEstatus,
	true,
	pIdUsuarioLog,
	now(),
	pIdUsuarioLog,
	now(),
    pRowIndex);
	
	UPDATE segmento
    SET TotalRegistros = (SELECT COUNT(1) FROM deudor WHERE IdEmpresa = pIdEmpresa AND IdSegmento = pIdSegmento)
    WHERE
		IdEmpresa = pIdEmpresa
		AND IdSegmento = pIdSegmento;
END$$

DROP PROCEDURE IF EXISTS `InsDeudorDetalleError`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsDeudorDetalleError` (`pIdEmpresa` INT(11), `pIdSegmento` INT(11), `pRowIndex` INT(11), `pError` VARCHAR(8000))  BEGIN
	
    DECLARE pArchivo VARCHAR(200);
    SET pArchivo = (	SELECT Archivo 
						FROM segmento 
                        where 
							IdSegmento = pIdSegmento 
							and IdEmpresa = pIdEmpresa);
    
	INSERT INTO deudordetalleerror
	(
	IdEmpresa,
	IdSegmento,
	RowIndex,
	Archivo,
	Error,
    FechaError)
	VALUES
	(
	pIdEmpresa,
	pIdSegmento,
	pRowIndex,
	pArchivo,
	pError,
    now());

	
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

DROP PROCEDURE IF EXISTS `InsMapeoSegmento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsMapeoSegmento` (`pIdSegmento` INT, `pIdEmpresa` INT, `pIdColumnaDefaultSegmento` INT, `pIdColumnaSegmento` INT)  BEGIN
    	
	if not exists (	select 1 
					from mapeocolumnasegmento 
					where 
						IdSegmento = pIdSegmento 
						AND IdEmpresa = pIdEmpresa
						AND IdColumnaDefaultSegmento = pIdColumnaDefaultSegmento
				  ) then
		if pIdColumnaSegmento is not null then
			INSERT INTO mapeocolumnasegmento
			(
			IdSegmento,
			IdEmpresa,
			IdColumnaDefaultSegmento,
			IdColumnaSegmento)
			VALUES
			(
			pIdSegmento,
			pIdEmpresa,
			pIdColumnaDefaultSegmento,
			pIdColumnaSegmento);
		end if;
	else
		if pIdColumnaSegmento is not null then
			UPDATE mapeocolumnasegmento
			SET IdColumnaSegmento = pIdColumnaSegmento
			where 
				IdSegmento = pIdSegmento 
				AND IdEmpresa = pIdEmpresa
				AND IdColumnaDefaultSegmento = pIdColumnaDefaultSegmento;
		else
			DELETE from mapeocolumnasegmento
			where 
				IdSegmento = pIdSegmento 
				AND IdEmpresa = pIdEmpresa
				AND IdColumnaDefaultSegmento = pIdColumnaDefaultSegmento;
		end if;
	END IF;
END$$

DROP PROCEDURE IF EXISTS `InsPagoComprobado`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsPagoComprobado` (`pIdDeudor` INT, `pIdEmpresa` INT, `pIdEstatus` INT, `pFechaPago` DATETIME, `pCantidad` DECIMAL(20,2), `pComentarios` VARCHAR(200), `pIdUsuarioLog` INT, `pIdTipoGestion` INT, `pIdAnalista` INT, `pTelefonoMarcado` VARCHAR(32))  BEGIN

	DECLARE pFechaActual DATETIME;
    DECLARE pMontoComprobado DECIMAL(20,1);
    SET pFechaActual = NOW();
	
    INSERT INTO `pagocomprobado`
	(
	`IdDeudor`,
	`IdEmpresa`,
    IdTipoGestion,
	`IdEstatus`,
	`FechaPago`,
	`Cantidad`,
	`Comentarios`,
	`IdUsuarioCreacion`,
	`FechaCreacion`,
	`IdUsuarioUltimoModifico`,
	`FechaModificacion`,
    `IdAnalista`,
    TelefonoMarcado)
	VALUES
	(
	pIdDeudor,
	pIdEmpresa,
    pIdTipoGestion,
	pIdEstatus,
	pFechaPago,
	pCantidad,
	pComentarios,
	pIdUsuarioLog,
	pFechaActual,
	pIdUsuarioLog,
	pFechaActual,
    pIdAnalista,
    pTelefonoMarcado);
	
    SET pMontoComprobado = IFNULL((SELECT SUM(Cantidad) from pagocomprobado WHERE IdDeudor = pIdDeudor AND IdEmpresa = pIdEmpresa), 0); 
    
    UPDATE Deudor
    SET 
		FechaUltimoContacto = pFechaActual,
        IdAnalistaUltimoContacto = pIdAnalista,
        IdTipoGestion = pIdTipoGestion,
        IdEstatus = pIdEstatus,
        MontoComprobado = pMontoComprobado,
		FechaMostrado = now(),
        TelefonoMarcado = pTelefonoMarcado
	WHERE
		IdDeudor = pIdDeudor
        AND IdEmpresa = pIdEmpresa;
	
    select pFechaActual as Fecha,
		pMontoComprobado as MontoComprobado;
    
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

DROP PROCEDURE IF EXISTS `InsSegmento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsSegmento` (`pIdEmpresa` INT(11), `pIdCartera` INT(11), `pSegmento` VARCHAR(64), `pArchivo` VARCHAR(200), `pEsActivo` TINYINT(1), `pFecha` TIMESTAMP, `pIdUsuarioLog` INT)  BEGIN
	DECLARE pIdSegmento INT;
    
    SET pIdSegmento = 0;
    
    IF NOT EXISTS (	SELECT 1 
					FROM 
						segmento 
					WHERE 
						IdEmpresa = pIdEmpresa
                        AND IdCartera = pIdCartera
						AND Segmento = pSegmento) THEN
		
		INSERT INTO segmento
		(
		IdCartera,
		IdEmpresa,
		Segmento,
		Fecha,
		Archivo,
		EsActivo,
		IdUsuarioCreacion,
		FechaCreacion,
		IdUsuarioUltimoModifico,
		FechaModificacion)
		VALUES
		(
		pIdCartera,
		pIdEmpresa,
		pSegmento,
		pFecha,
		pArchivo,
		pEsActivo,
		pIdUsuarioLog,
		now(),
		pIdUsuarioLog,
		now());
		
        SET pIdSegmento = (SELECT MAX(IdSegmento) as pIdSegmento from segmento);
        
    END IF;
    
    SELECT pIdSegmento as Id;
    
END$$

DROP PROCEDURE IF EXISTS `InsSeguimientoDeudor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsSeguimientoDeudor` (`pIdDeudor` INT, `pIdEmpresa` INT, `pIdEstatus` INT, `pComentarios` VARCHAR(200), `pIdUsuarioLog` INT, `pIdTipoGestion` INT, `pIdAnalista` INT, `pTelefonoMarcado` VARCHAR(32))  BEGIN

	DECLARE pFechaActual DATETIME;
    SET pFechaActual = NOW();
    
    INSERT INTO `seguimientodeudor`
	(
	`IdDeudor`,
	`IdEmpresa`,
    IdTipoGestion,
	`IdEstatus`,
	`Comentarios`,
	`IdUsuarioCreacion`,
	`FechaCreacion`,
	`IdUsuarioUltimoModifico`,
	`FechaModificacion`,
    `IdAnalista`,
    TelefonoMarcado)
	VALUES
	(
	pIdDeudor,
	pIdEmpresa,
    pIdTipoGestion,
	pIdEstatus,
	pComentarios,
	pIdUsuarioLog,
	pFechaActual,
	pIdUsuarioLog,
	pFechaActual,
    pIdAnalista,
    pTelefonoMarcado);

    UPDATE Deudor
    SET 
		FechaUltimoContacto = pFechaActual,
        IdAnalistaUltimoContacto = pIdAnalista,
        IdTipoGestion = pIdTipoGestion,
        IdEstatus = pIdEstatus,
		FechaMostrado = now(),
        TelefonoMarcado = pTelefonoMarcado
	WHERE
		IdDeudor = pIdDeudor
        AND IdEmpresa = pIdEmpresa;
	
    select pFechaActual as Fecha;
		
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

DROP PROCEDURE IF EXISTS `ObtCarteras`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCarteras` (`pNombre` VARCHAR(96), `pActivo` TINYINT, `pIdEmpresa` INT)  BEGIN

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
        c.IdCartera,
		c.IdEmpresa,
		c.Clave,
		c.Nombre,
		c.IdCliente,
		c.Comentarios,
		c.Activo,
        cl.NombreComercial
	FROM cartera c
    inner join cliente cl on c.IdCliente = cl.IdCliente
	where c.Nombre like concat('%', IFNULL(pNombre, ''), '%')
			and c.Activo between pDesde and pHasta
			AND c.IdEmpresa = pIdEmpresa;

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

DROP PROCEDURE IF EXISTS `ObtClientes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClientes` (`pRazonSocial` VARCHAR(96), `pActivo` TINYINT, `pIdEmpresa` INT)  BEGIN

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
	   IdCliente,
	   IdEmpresa,
	   RFC,
	   RazonSocial,
	   NombreComercial,
	   Direccion,
	   Contacto_Nombre,
	   Contacto_Email,
	   Contacto_Telefono,
	   Comentarios,
	   Activo
	FROM cliente
	where RazonSocial like concat('%', IFNULL(pRazonSocial, ''), '%')
			and Activo between pDesde and pHasta
			AND IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtClientesCartera`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClientesCartera` (`pNombreComercial` VARCHAR(64), `pIdEmpresa` INT)  BEGIN

	SELECT
	   IdCliente,
	   NombreComercial
	FROM cliente
	where NombreComercial like concat('%', IFNULL(pNombreComercial, ''), '%')
			and Activo = 1
			AND IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtClientesCarteras`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClientesCarteras` (`pNombre` VARCHAR(200), `pIdEmpresa` INT)  BEGIN

	SELECT 
        c.IdCartera,
		concat(cl.NombreComercial, ' - ', c.Nombre) as Nombre     
	FROM cartera c
    inner join cliente cl on c.IdCliente = cl.IdCliente
	where 	(
				c.Nombre like concat('%', IFNULL(pNombre, ''), '%')
                OR
                cl.NombreComercial like concat('%', IFNULL(pNombre, ''), '%')
			)
			AND c.IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtClientesCarteraTodos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClientesCarteraTodos` (`pNombreComercial` VARCHAR(64), `pIdEmpresa` INT)  BEGIN

	SELECT
	   IdCliente,
	   NombreComercial
	FROM cliente
	where NombreComercial like concat('%', IFNULL(pNombreComercial, ''), '%')
			AND IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtColumnasSegmento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtColumnasSegmento` (`pIdSegmento` INT, `pIdEmpresa` INT)  BEGIN

	SELECT
		IdColumnaSegmento
        , Encabezado
        , Columna
    FROM columnasegmento
    WHERE 
		IdSegmento = pIdSegmento
		AND IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtConfiguracionReportes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtConfiguracionReportes` ()  BEGIN
	
    SELECT
		Id
        , CaracterInvalido
    FROM
		parametroscaracteresinvalidos;
        
	SELECT 
		Id,
		Nombre,
		EsFecha,
		EsNumero,
		EsPorcentaje,
		SeparacionMiles,
		CuantosDecimales,
		FormatCode,
		FormatCodeAntes,
		FormatCodeDespues,
		FormatCodeFinal
	FROM parametrotiposcelda;
    
    SELECT 
		Id,
		DataType,
		IdTipoCelda
	FROM parametrostiposdefault;
    
END$$

DROP PROCEDURE IF EXISTS `ObtContactoDeudor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtContactoDeudor` (`pIdDeudor` INT, `pIdEmpresa` INT, `pConsecutivo` INT)  BEGIN
	
    SELECT 
		IdDatosContactoDeudor,
		IdEmpresa,
		IdDeudor,
		Validado,
		Telefono,
		CorreoElectronico,
		CalleNum,
		Colonia,
		Ciudad,
		Estado,
		Comentarios
	FROM datoscontactodeudor
    WHERE 
		IdEmpresa = pIdEmpresa
		and IdDeudor = pIdDeudor
		and Consecutivo = pConsecutivo;
    
END$$

DROP PROCEDURE IF EXISTS `ObtDeudores`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDeudores` (`pIdCartera` INT(11), `pIdUsuario` INT(11), `pIdSegmento` INT(11), `pIdEmpresa` INT)  BEGIN

	SELECT 
        d.IdDeudor,
		d.IdEmpresa,
		d.IdSegmento,
		d.Credito,
		d.Nombre,
		d.RFC,
		d.CalleNumero,
		d.CP,
		d.Colonia,
		d.Ciudad,
		d.Estado,
		d.TelFijo,
		d.TelCelular,
		d.TelAdicional1,
		d.TelAdicional2,
		d.TelAdicional3,
		d.ImporteDeuda,
		d.PorcentajeDescuento,
		d.DiasdeMora,
		d.PagoDescuento1,
		d.PagoDescuento2,
		d.MontoPrestamo,
		d.FechaAsignacion,
		d.FechaVencimiento,
		d.FechaOtorgamiento,
		d.SaldoActual,
		d.TipoPrestamo,
		d.NombreGrupo,
		d.NumeroGrupo,
		d.Banco,
		d.Referencia,
		d.ConvenioPago,
		d.Estatus,
		d.FechaUltimoContacto,
		d.IdAnalistaUltimoContacto,
		d.AdicionalTexto1,
		d.AdicionalTexto2,
		d.AdicionalTexto3,
		d.AdicionalTexto4,
		d.AdicionalTexto5,
		d.AdicionalFecha,
		d.AdicionalMoneda,
		d.AdicionalEntero,
		d.AdicionalEstatus,
		d.EsActivo,
		d.IdUsuarioCreacion,
		d.FechaCreacion,
		d.IdUsuarioUltimoModifico,
		d.FechaModificacion,
		d.RowIndex,
		d.IdUsuarioAsignado,
        concat(cli.NombreComercial, ' - ', car.Nombre) as ClienteCartera,
        seg.Segmento,
        usu.NombreCompleto as AnalistaNombre
	FROM deudor d
    INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
    INNER JOIN Cartera car on car.IdCartera = seg.IdCartera and car.IdEmpresa = d.IdEmpresa
    INNER JOIN Cliente cli on cli.IdCliente = car.IdCliente and cli.IdEmpresa = d.IdEmpresa
    LEFT JOIN Usuario usu on usu.IdUsuario = d.IdUsuarioAsignado and usu.IdEmpresa = d.IdEmpresa
    WHERE
		d.IdEmpresa = pIdEmpresa
        AND
        (
			seg.IdCartera = IFNULL(pIdCartera, seg.IdCartera)
            AND 
            d.IdSegmento = IFNULL(pIdSegmento, d.IdSegmento)
			AND 
            IFNULL(d.IdUsuarioAsignado, 0) = IFNULL(pIdusuario, IFNULL(d.IdUsuarioAsignado, 0))
        )
    order by d.IdDeudor;


END$$

DROP PROCEDURE IF EXISTS `ObtDeudoresAnalista`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDeudoresAnalista` (`pIdUsuario` INT(11), `pIdEmpresa` INT, `pNombre` VARCHAR(64), `pGlobal` TINYINT(1))  BEGIN
	
    DECLARE pIdUsuarioTemp	int(11);
    DECLARE pEsPropia	bigint;
    DECLARE pEsNoPropia	bigint;
    
    SET pEsPropia = 1;
    SET pEsNoPropia = 0;
    
    if pGlobal =  0 then
		SET pIdUsuarioTemp = pIdUsuario;
	end if;
    
	SELECT 
        d.IdDeudor,
		d.IdEmpresa,
		d.IdSegmento,
		d.Credito,
		d.Nombre,
		d.RFC,
		d.CalleNumero,
		d.CP,
		d.Colonia,
		d.Ciudad,
		d.Estado,
		d.TelFijo,
		d.TelCelular,
		d.TelAdicional1,
		d.TelAdicional2,
		d.TelAdicional3,
		d.ImporteDeuda,
		d.PorcentajeDescuento,
		d.DiasdeMora,
		d.PagoDescuento1,
		d.PagoDescuento2,
		d.MontoPrestamo,
		d.FechaAsignacion,
		d.FechaVencimiento,
		d.FechaOtorgamiento,
		d.SaldoActual,
		d.TipoPrestamo,
		d.NombreGrupo,
		d.NumeroGrupo,
		d.Banco,
		d.Referencia,
		d.ConvenioPago,
		d.Estatus,
		d.FechaUltimoContacto,
		d.IdAnalistaUltimoContacto,
		d.AdicionalTexto1,
		d.AdicionalTexto2,
		d.AdicionalTexto3,
		d.AdicionalTexto4,
		d.AdicionalTexto5,
		d.AdicionalFecha,
		d.AdicionalMoneda,
		d.AdicionalEntero,
		d.AdicionalEstatus,
		d.EsActivo,
		d.IdUsuarioCreacion,
		d.FechaCreacion,
		d.IdUsuarioUltimoModifico,
		d.FechaModificacion,
		d.RowIndex,
		d.IdUsuarioAsignado,
        concat(cli.NombreComercial, ' - ', car.Nombre) as ClienteCartera,
        seg.Segmento,
        usu.NombreCompleto as AnalistaNombre,
        CASE WHEN IFNULL(d.IdUsuarioAsignado, 0) = pIdUsuario THEN pEsPropia ELSE pEsNoPropia END as Propia
	FROM deudor d
    INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa AND seg.EsActivo = 1
    INNER JOIN Cartera car on car.IdCartera = seg.IdCartera and car.IdEmpresa = d.IdEmpresa AND car.Activo = 1
    INNER JOIN Cliente cli on cli.IdCliente = car.IdCliente and cli.IdEmpresa = d.IdEmpresa AND cli.Activo = 1
    INNER JOIN Usuario usu on usu.IdUsuario = d.IdUsuarioAsignado and usu.IdEmpresa = d.IdEmpresa
    WHERE
		d.IdEmpresa = pIdEmpresa
        AND IFNULL(d.IdUsuarioAsignado, 0) = IFNULL(pIdUsuarioTemp, d.IdUsuarioAsignado)
		AND IFNULL(d.IdUsuarioAsignado, 0) != 0
        AND (d.Nombre like concat('%', IFNULL(pNombre, ''), '%')
			 OR d.Credito like concat('%', IFNULL(pNombre, ''), '%')
			)
    order by d.IdDeudor;


END$$

DROP PROCEDURE IF EXISTS `ObtDeudoresAnalistaSeguimiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDeudoresAnalistaSeguimiento` (`pIdUsuario` INT(11), `pIdEmpresa` INT, `pIdSegmento` INT, `pIdDeudor` INT, `pIdDeudorIncrementar` INT)  BEGIN
	
    DECLARE pAgendado tinyint(1);
    DECLARE pIdAgendarLlamadaDeudor int;
    DECLARE pIdDeudorSeleccionar int;
    
    SET pAgendado  = 1;
    SET pIdAgendarLlamadaDeudor = IFNULL((	select 
												IdAgendarLlamadaDeudor
											from agendarllamadadeudor 
											where 
												IdEmpresa = pIdEmpresa
												and Atendido = 0
												and IdAnalista = pIdUsuario
                                                and FechaAgenda <= now()
                                                ORDER BY IdAgendarLlamadaDeudor asc
											LIMIT 1), 0);
    
   
	create temporary table pT_EstatusClave( Clave varchar(100) );
	set @sql = concat("insert into pT_EstatusClave (Clave) values ('", replace(( select group_concat(distinct Valor) as data from parametro where Nombre='EstatusNoNavegar'), ",", "'),('"),"');");
	prepare stmt1 from @sql;
	execute stmt1;
	
    CREATE TEMPORARY TABLE pT_EstatusID 
    (
    select distinct
		sc.IdSubCatalogo as IdEstatus
	from 
		tipocatalogo tc
	inner join 
		subcatalogo sc  
    on 
		sc.IdTipoCatalogo = tc.IdTipoCatalogo 
        and sc.IdEmpresa  = pIdEmpresa
	inner join 
		pT_EstatusClave tmpEstatus
	on
		tmpEstatus.Clave = sc.Clave
    where 
		tc.Nombre = 'Estatus Tipo Gestion'
	);
    
    create temporary table pT_EstatusClave2( Clave varchar(100) );
	set @sql = concat("insert into pT_EstatusClave2 (Clave) values ('", replace(( select group_concat(distinct Valor) as data from parametro where Nombre='EstatusNoSeguimiento'), ",", "'),('"),"');");
	prepare stmt1 from @sql;
	execute stmt1;
	
    CREATE TEMPORARY TABLE pT_EstatusID2 
    (
    select distinct
		sc.IdSubCatalogo as IdEstatus
	from 
		tipocatalogo tc
	inner join 
		subcatalogo sc  
    on 
		sc.IdTipoCatalogo = tc.IdTipoCatalogo 
        and sc.IdEmpresa  = pIdEmpresa
	inner join 
		pT_EstatusClave2 tmpEstatus
	on
		tmpEstatus.Clave = sc.Clave
    where 
		tc.Nombre = 'Estatus Tipo Gestion'
	);
    
    if pIdAgendarLlamadaDeudor != 0 then
        SELECT 
			d.IdDeudor,
			d.IdEmpresa,
			d.IdSegmento,
			d.Credito,
			d.Nombre,
			d.RFC,
			d.CalleNumero,
			d.CP,
			d.Colonia,
			d.Ciudad,
			d.Estado,
			d.TelFijo,
			d.TelCelular,
			d.TelAdicional1,
			d.TelAdicional2,
			d.TelAdicional3,
			d.ImporteDeuda,
			d.PorcentajeDescuento,
			d.DiasdeMora,
			d.PagoDescuento1,
			d.PagoDescuento2,
			d.MontoPrestamo,
			d.FechaAsignacion,
			d.FechaVencimiento,
			d.FechaOtorgamiento,
			d.SaldoActual,
			d.TipoPrestamo,
			d.NombreGrupo,
			d.NumeroGrupo,
			d.Banco,
			d.Referencia,
			d.ConvenioPago,
			d.Estatus,
			d.FechaUltimoContacto,
			d.IdAnalistaUltimoContacto,
			d.AdicionalTexto1,
			d.AdicionalTexto2,
			d.AdicionalTexto3,
			d.AdicionalTexto4,
			d.AdicionalTexto5,
			d.AdicionalFecha,
			d.AdicionalMoneda,
			d.AdicionalEntero,
			d.AdicionalEstatus,
			d.EsActivo,
			d.IdUsuarioCreacion,
			d.FechaCreacion,
			d.IdUsuarioUltimoModifico,
			d.FechaModificacion,
			d.RowIndex,
			d.IdUsuarioAsignado,
			concat(cli.NombreComercial, ' - ', car.Nombre) as ClienteCartera,
			seg.Segmento,
			usu.NombreCompleto as AnalistaNombre,
            pAgendado as Agendado,
            usu2.NombreCompleto as AnalistaUltimoContacto,
            tipGestion.Nombre as UltimoTipoGestion,
            estatus.Nombre as UltimoEstatus,
            d.MontoPromesa,
            d.MontoComprobado,
            CASE WHEN EXISTS (	SELECT 1 
								FROM 
									datoscontactodeudor dt 
                                WHERE 
									dt.IdEmpresa = d.IdEmpresa
                                    and dt.IdDeudor = d.IdDeudor
                                    and Consecutivo = 1) THEN 1 ELSE 0
            END as Contacto1,
            CASE WHEN EXISTS (	SELECT 1 
								FROM 
									datoscontactodeudor dt 
                                WHERE 
									dt.IdEmpresa = d.IdEmpresa
                                    and dt.IdDeudor = d.IdDeudor
                                    and Consecutivo = 2) THEN 1 ELSE 0
            END as Contacto2,
            d.IdEstatus,
            d.IdTipoGestion,
            d.TelefonoMarcado,
            estatus2.IdEstatus as IdEstatusNoSeguimiento
		FROM deudor d
		INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
		INNER JOIN Cartera car on car.IdCartera = seg.IdCartera and car.IdEmpresa = d.IdEmpresa
		INNER JOIN Cliente cli on cli.IdCliente = car.IdCliente and cli.IdEmpresa = d.IdEmpresa
		INNER JOIN Usuario usu on usu.IdUsuario = d.IdUsuarioAsignado and usu.IdEmpresa = d.IdEmpresa
        LEFT JOIN Usuario usu2 on usu2.IdUsuario = d.IdAnalistaUltimoContacto and usu2.IdEmpresa = d.IdEmpresa
        LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = d.IdTipoGestion and tipGestion.IdEmpresa = d.IdEmpresa
        LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = d.IdEstatus and estatus.IdEmpresa = d.IdEmpresa
        INNER JOIN agendarllamadadeudor agenda on 
									agenda.IdAgendarLlamadaDeudor = pIdAgendarLlamadaDeudor
                                    and agenda.IdDeudor = d.IdDeudor        
		LEFT JOIN pT_EstatusID2 estatus2 ON d.IdEstatus = estatus2.IdEstatus 
        WHERE
			d.IdEmpresa = pIdEmpresa
			AND IFNULL(d.IdUsuarioAsignado, 0) = pIdusuario;
        
        UPDATE agendarllamadadeudor 
        SET Atendido = 1
		where 
			IdEmpresa = pIdEmpresa
            and IdAnalista = pIdUsuario
            and IdAgendarLlamadaDeudor = pIdAgendarLlamadaDeudor;
    else
		
        SET pIdDeudorSeleccionar = 	(
										SELECT
											IdDeudor
                                        FROM deudor d
                                        LEFT JOIN
											pT_EstatusID estatus
										ON
											d.IdEstatus = estatus.IdEstatus
										LEFT JOIN
											pT_EstatusID2 estatus2
										ON
											d.IdEstatus = estatus2.IdEstatus
                                        WHERE
											d.IdEmpresa = pIdEmpresa
											AND IFNULL(d.IdUsuarioAsignado, 0) = pIdusuario
											AND d.IdSegmento = pIdSegmento
											AND ( CASE WHEN pIdDeudor is not null then CASE WHEN d.IdDeudor = pIdDeudor then 1 else 0 END
													   ELSE CASE WHEN estatus.IdEstatus is null and estatus2.IdEstatus is null then 1 
																 ELSE 0
															END
												  END
												) = 1
										 order by 
											d.FechaUltimoContacto asc
											, d.FechaMostrado asc
                                            , d.IdDeudor asc
										 LIMIT 1
									);
        
		SELECT 
			d.IdDeudor,
			d.IdEmpresa,
			d.IdSegmento,
			d.Credito,
			d.Nombre,
			d.RFC,
			d.CalleNumero,
			d.CP,
			d.Colonia,
			d.Ciudad,
			d.Estado,
			d.TelFijo,
			d.TelCelular,
			d.TelAdicional1,
			d.TelAdicional2,
			d.TelAdicional3,
			d.ImporteDeuda,
			d.PorcentajeDescuento,
			d.DiasdeMora,
			d.PagoDescuento1,
			d.PagoDescuento2,
			d.MontoPrestamo,
			d.FechaAsignacion,
			d.FechaVencimiento,
			d.FechaOtorgamiento,
			d.SaldoActual,
			d.TipoPrestamo,
			d.NombreGrupo,
			d.NumeroGrupo,
			d.Banco,
			d.Referencia,
			d.ConvenioPago,
			d.Estatus,
			d.FechaUltimoContacto,
			d.IdAnalistaUltimoContacto,
			d.AdicionalTexto1,
			d.AdicionalTexto2,
			d.AdicionalTexto3,
			d.AdicionalTexto4,
			d.AdicionalTexto5,
			d.AdicionalFecha,
			d.AdicionalMoneda,
			d.AdicionalEntero,
			d.AdicionalEstatus,
			d.EsActivo,
			d.IdUsuarioCreacion,
			d.FechaCreacion,
			d.IdUsuarioUltimoModifico,
			d.FechaModificacion,
			d.RowIndex,
			d.IdUsuarioAsignado,
			concat(cli.NombreComercial, ' - ', car.Nombre) as ClienteCartera,
			seg.Segmento,
			usu.NombreCompleto as AnalistaNombre,
            usu2.NombreCompleto as AnalistaUltimoContacto,
            tipGestion.Nombre as UltimoTipoGestion,
            estatus.Nombre as UltimoEstatus,
            d.MontoPromesa,
            d.MontoComprobado,
            CASE WHEN EXISTS (	SELECT 1 
								FROM 
									datoscontactodeudor dt 
                                WHERE 
									dt.IdEmpresa = d.IdEmpresa
                                    and dt.IdDeudor = d.IdDeudor
                                    and Consecutivo = 1) THEN 1 ELSE 0
            END as Contacto1,
            CASE WHEN EXISTS (	SELECT 1 
								FROM 
									datoscontactodeudor dt 
                                WHERE 
									dt.IdEmpresa = d.IdEmpresa
                                    and dt.IdDeudor = d.IdDeudor
                                    and Consecutivo = 2) THEN 1 ELSE 0
            END as Contacto2,
            d.IdEstatus,
            d.IdTipoGestion,
            d.TelefonoMarcado,
            estatus2.IdEstatus as IdEstatusNoSeguimiento
		FROM deudor d
		INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
		INNER JOIN Cartera car on car.IdCartera = seg.IdCartera and car.IdEmpresa = d.IdEmpresa
		INNER JOIN Cliente cli on cli.IdCliente = car.IdCliente and cli.IdEmpresa = d.IdEmpresa
		INNER JOIN Usuario usu on usu.IdUsuario = d.IdUsuarioAsignado and usu.IdEmpresa = d.IdEmpresa
        LEFT JOIN Usuario usu2 on usu2.IdUsuario = d.IdAnalistaUltimoContacto and usu2.IdEmpresa = d.IdEmpresa
        LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = d.IdTipoGestion and tipGestion.IdEmpresa = d.IdEmpresa
        LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = d.IdEstatus and estatus.IdEmpresa = d.IdEmpresa
		LEFT JOIN pT_EstatusID2 estatus2 ON d.IdEstatus = estatus2.IdEstatus 
		WHERE
			d.IdEmpresa = pIdEmpresa
			AND IFNULL(d.IdUsuarioAsignado, 0) = pIdusuario
			AND d.IdSegmento = pIdSegmento
			AND d.IdDeudor = pIdDeudorSeleccionar;
    END IF;
    
	 DROP TEMPORARY TABLE pT_EstatusClave;
     DROP TEMPORARY TABLE pT_EstatusID;
     DROP TEMPORARY TABLE pT_EstatusClave2;
     DROP TEMPORARY TABLE pT_EstatusID2;
END$$

DROP PROCEDURE IF EXISTS `ObtEmpresas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtEmpresas` ()  BEGIN
	SELECT 
		IdEmpresa,
        Dominio,
        ProductKey,
        Administrador,
        Contraseña,
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

DROP PROCEDURE IF EXISTS `ObtErrorImportarDeudores`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtErrorImportarDeudores` (`pIdCartera` INT(11), `pIdSegmento` INT(11), `pIdEmpresa` INT)  BEGIN
	
   SELECT
    d.IdDeudorDetalleError,
	d.RowIndex,
    d.Archivo,
    d.FechaError,
    d.Error
   FROM deudordetalleerror d
   INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
   WHERE
	d.IdEmpresa = pIdEmpresa
	AND seg.IdCartera = IFNULL(pIdCartera, seg.IdCartera)
	AND d.IdSegmento = IFNULL(pIdSegmento, d.IdSegmento)
	order by d.IdDeudorDetalleError;
   
END$$

DROP PROCEDURE IF EXISTS `ObtEstatusCartera`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtEstatusCartera` (`pIdEmpresa` INT, `pIdCartera` INT, `pIdTipoGestion` INT)  BEGIN

	select 
		sc.IdSubCatalogo as IdEstatus
        , sc.Nombre
        , ec.Alias
	from 
		tipocatalogo tc
    inner join 
		subcatalogo sc  
    on 
		sc.IdTipoCatalogo = tc.IdTipoCatalogo 
        and sc.IdEmpresa  = pIdEmpresa
    left join 
		estatuscartera ec 
    on 
		ec.IdEstatus         = sc.IdSubCatalogo 
        and ec.IdEmpresa     = pIdEmpresa 
        and ec.IdCartera     = pIdCartera
        and ec.IdTipoGestion = pIdTipoGestion
    where 
		tc.Nombre = 'Estatus Tipo Gestion'
        and sc.IdCatalogo = pIdTipoGestion;

END$$

DROP PROCEDURE IF EXISTS `ObtEstatusNoSeguimiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtEstatusNoSeguimiento` (`pIdEmpresa` INT)  BEGIN

	create temporary table pT_EstatusClave( Clave varchar(100) );
	set @sql = concat("insert into pT_EstatusClave (Clave) values ('", replace(( select group_concat(distinct Valor) as data from parametro where Nombre='EstatusNoSeguimiento'), ",", "'),('"),"');");
	prepare stmt1 from @sql;
	execute stmt1;
    
    CREATE TEMPORARY TABLE pT_EstatusID 
    (
    select distinct
		sc.IdSubCatalogo as IdEstatus
	from 
		tipocatalogo tc
	inner join 
		subcatalogo sc  
    on 
		sc.IdTipoCatalogo = tc.IdTipoCatalogo 
        and sc.IdEmpresa  = pIdEmpresa
	inner join 
		pT_EstatusClave tmpEstatus
	on
		tmpEstatus.Clave = sc.Clave
    where 
		tc.Nombre = 'Estatus Tipo Gestion'
	);
	
    select IdEstatus from pT_EstatusID;
    
    DROP TEMPORARY TABLE pT_EstatusClave;
	DROP TEMPORARY TABLE pT_EstatusID;
END$$

DROP PROCEDURE IF EXISTS `ObtFormas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtFormas` (`pIdEmpresa` INT)  BEGIN
	
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtFormasRolesPrivilegiosPorAdministrador` (`pIdEmpresa` INT, `pEsSuperAdministrador` TINYINT(1))  BEGIN
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
    WHERE IdEmpresa = pIdEmpresa
		AND Estatus = 1;
    
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
    AND IdEmpresa = pIdEmpresa
    AND Estatus = 1);
    
    SET pEsOpcionMenu = (
    SELECT 
		EsOpcionMenu 
	from Forma 
	where Forma.ClaveCodigo = 'Catalogos'
    AND IdEmpresa = pIdEmpresa
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
            AND Forma.IdEmpresa = pIdEmpresa
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
            AND Forma.IdEmpresa = pIdEmpresa
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
            AND Forma.IdEmpresa = pIdEmpresa
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtFormasRolesPrivilegiosPorUsuario` (`pIdUsuario` INT, `pIdEmpresa` INT)  BEGIN

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
    AND IdEmpresa = pIdEmpresa
    AND Estatus = 1);
    
    SET pEsOpcionMenu = (
    SELECT 
		EsOpcionMenu 
	from Forma 
	where Forma.ClaveCodigo = 'Catalogos'
    AND IdEmpresa = pIdEmpresa
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
		inner join RolUsuario on (RolUsuario.IdUsuario = Usuario.IdUsuario AND RolUsuario.IdEmpresa = pIdEmpresa)		
		inner join FormaRol on (FormaRol.IdRol =  RolUsuario.IdRol AND FormaRol.IdEmpresa = pIdEmpresa)
		inner join Forma on (Forma.IdForma = FormaRol.IdForma AND Forma.IdEmpresa = pIdEmpresa AND Forma.Estatus = 1)		
		inner join Roles on (Roles.IdRol = FormaRol.IdRol AND Roles.IdEmpresa = pIdEmpresa AND Roles.Estatus = 1)
		where 
			Roles.Estatus = 1
			and Forma.Estatus = 1 
			and ((usuario.idusuario = pIdUsuario and Usuario.Activo = 1))	
            AND Usuario.IdEmpresa = pIdEmpresa
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
		inner join RolUsuario on (RolUsuario.IdUsuario = Usuario.IdUsuario AND RolUsuario.IdEmpresa = pIdEmpresa)		
		inner join FormaRol on (FormaRol.IdRol =  RolUsuario.IdRol AND FormaRol.IdEmpresa = pIdEmpresa)
		inner join Forma on (Forma.IdForma = FormaRol.IdForma AND Forma.IdEmpresa = pIdEmpresa)		
		inner join Roles on (Roles.IdRol = FormaRol.IdRol AND Roles.IdEmpresa = pIdEmpresa)
		inner join TipoCatalogo on (TipoSubCatalogo = 0 and TipoCatalogo.Visible = 1)
		where 
			Roles.Estatus = 1
			and Forma.Estatus = 1 
			and ((usuario.idusuario = pIdUsuario and Usuario.Activo = 1))
			and Forma.ClaveCodigo = 'Catalogos'
			and FormaRol.Privilegios & 1 != 0
            AND Usuario.IdEmpresa = pIdEmpresa            
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
		inner join RolUsuario on (RolUsuario.IdUsuario = Usuario.IdUsuario AND RolUsuario.IdEmpresa = pIdEmpresa)		
		inner join FormaRol on (FormaRol.IdRol =  RolUsuario.IdRol AND FormaRol.IdEmpresa = pIdEmpresa)
		inner join Forma on (Forma.IdForma = FormaRol.IdForma AND Forma.IdEmpresa = pIdEmpresa)		
		inner join Roles on (Roles.IdRol = FormaRol.IdRol AND Roles.IdEmpresa = pIdEmpresa)
		inner join TipoCatalogo on (TipoSubCatalogo = 1 and TipoCatalogo.Visible = 1)
		where 
			Roles.Estatus = 1
			and Forma.Estatus = 1 
			and ((usuario.idusuario = pIdUsuario and Usuario.Activo = 1))
			and Forma.ClaveCodigo = 'SubCatalogos'
			and FormaRol.Privilegios & 1 != 0
            AND Usuario.IdEmpresa = pIdEmpresa           
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

DROP PROCEDURE IF EXISTS `ObtMapeoColumnasSegmento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtMapeoColumnasSegmento` (`pIdSegmento` INT, `pIdEmpresa` INT)  BEGIN

	SELECT
		col.Columna
        , def.Columna as Propiedad
    FROM mapeocolumnasegmento map
    INNER JOIN columnasegmento col 
    ON 
		col.IdSegmento = map.IdSegmento
		AND col.IdEmpresa = map.IdEmpresa
        AND col.IdColumnaSegmento = map.IdColumnaSegmento
	INNER JOIN columnadefaultsegmento def 
    ON 
		def.IdColumnaDefaultSegmento = map.IdColumnaDefaultSegmento
    WHERE 
		map.IdSegmento = pIdSegmento
		AND map.IdEmpresa = pIdEmpresa;

END$$

DROP PROCEDURE IF EXISTS `ObtMapeoSegmento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtMapeoSegmento` (`pIdSegmento` INT, `pIdEmpresa` INT)  BEGIN

	SELECT
		IdColumnaDefaultSegmento
        , IdColumnaSegmento
    FROM mapeocolumnasegmento
    WHERE 
		IdSegmento = pIdSegmento
		AND IdEmpresa = pIdEmpresa;

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

DROP PROCEDURE IF EXISTS `ObtRepResumen`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtRepResumen` (`pIdCartera` INT(11), `pIdUsuario` INT(11), `pIdSegmento` INT(11), `pIdEmpresa` INT, `pTipoEstatus` INT)  BEGIN
	
    CREATE TEMPORARY TABLE pT_Seguimiento 
    (
		select * from (
		Select
			d.IdDeudor as Seguimiento_IdDeudor,
			d.IdEmpresa as Seguimiento_IdEmpresa,
			a.Comentarios as Seguimiento_Comentarios,
			usu2.NombreCompleto as Seguimiento_Analista,
			tipGestion.Nombre as Seguimiento_Tipo_Gestión,
			CASE WHEN pTipoEstatus = 1 then estatus.Nombre 
				 ELSE alias.Alias 
			END as Seguimiento_Estatus,                
			'Acuerdo de Pago' as Tipo_Seguimiento,
			DATE_FORMAT(a.FechaPago, '%d/%m/%Y') as Acuerdo_Fecha,
			a.Cantidad as Acuerdo_Cantidad,
			null as Fecha_Comp_Pago,
			null as Pago_Comp_Cantidad,
			null as Fecha_Hora_Agendada,
			a.FechaCreacion as Fecha_Hora_de_Seguimiento,
			a.TelefonoMarcado as Seguimiento_Teléfono_Marcado
		FROM deudor d
		INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
		INNER JOIN acuerdopago a on a.IdDeudor = d.IdDeudor AND a.IdEmpresa = d.IdEmpresa
		LEFT JOIN Usuario usu2 on usu2.IdUsuario = a.IdAnalista and usu2.IdEmpresa = a.IdEmpresa
		LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = a.IdTipoGestion and tipGestion.IdEmpresa = a.IdEmpresa
		LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = a.IdEstatus and estatus.IdEmpresa = a.IdEmpresa
		LEFT JOIN estatuscartera alias on  
			alias.IdEmpresa 			= d.IdEmpresa
			and alias.IdCartera 		= seg.IdCartera
			and alias.IdTipoGestion 	= a.IdTipoGestion
			and alias.IdEstatus 		= a.IdEstatus
		WHERE
			d.IdEmpresa = pIdEmpresa
			AND
			(
				seg.IdCartera = IFNULL(pIdCartera, seg.IdCartera)
				AND 
				d.IdSegmento = IFNULL(pIdSegmento, d.IdSegmento)
				AND 
				IFNULL(d.IdUsuarioAsignado, 0) = IFNULL(pIdusuario, IFNULL(d.IdUsuarioAsignado, 0))
			)
		UNION
		Select
			d.IdDeudor as Seguimiento_IdDeudor,
			d.IdEmpresa as Seguimiento_IdEmpresa,
			a.Comentarios as Seguimiento_Comentarios,
			usu2.NombreCompleto as Seguimiento_Analista,
			tipGestion.Nombre as Seguimiento_Tipo_Gestión,
			CASE WHEN pTipoEstatus = 1 then estatus.Nombre 
				 ELSE alias.Alias 
			END as Seguimiento_Estatus,                
			'Comprobación de Pago' as Tipo_Seguimiento,
			null as Acuerdo_Fecha,
			null as Acuerdo_Cantidad,
			DATE_FORMAT(a.FechaPago, '%d/%m/%Y') as Fecha_Comp_Pago,
			a.Cantidad as Pago_Comp_Cantidad,
			null as Fecha_Hora_Agendada,
			a.FechaCreacion as Fecha_Hora_de_Seguimiento,
			a.TelefonoMarcado as Seguimiento_Teléfono_Marcado
		FROM deudor d
		INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
		INNER JOIN pagocomprobado a on a.IdDeudor = d.IdDeudor AND a.IdEmpresa = d.IdEmpresa
		LEFT JOIN Usuario usu2 on usu2.IdUsuario = a.IdAnalista and usu2.IdEmpresa = a.IdEmpresa
		LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = a.IdTipoGestion and tipGestion.IdEmpresa = a.IdEmpresa
		LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = a.IdEstatus and estatus.IdEmpresa = a.IdEmpresa
		LEFT JOIN estatuscartera alias on  
			alias.IdEmpresa 			= d.IdEmpresa
			and alias.IdCartera 		= seg.IdCartera
			and alias.IdTipoGestion 	= a.IdTipoGestion
			and alias.IdEstatus 		= a.IdEstatus
		WHERE
			d.IdEmpresa = pIdEmpresa
			AND
			(
				seg.IdCartera = IFNULL(pIdCartera, seg.IdCartera)
				AND 
				d.IdSegmento = IFNULL(pIdSegmento, d.IdSegmento)
				AND 
				IFNULL(d.IdUsuarioAsignado, 0) = IFNULL(pIdusuario, IFNULL(d.IdUsuarioAsignado, 0))
			)
		UNION
		Select
			d.IdDeudor as Seguimiento_IdDeudor,
			d.IdEmpresa as Seguimiento_IdEmpresa,
			a.Comentarios as Seguimiento_Comentarios,
			usu2.NombreCompleto as Seguimiento_Analista,
			tipGestion.Nombre as Seguimiento_Tipo_Gestión,
			CASE WHEN pTipoEstatus = 1 then estatus.Nombre 
				 ELSE alias.Alias 
			END as Seguimiento_Estatus,                
			'Registro Contacto' as Tipo_Seguimiento,
			null as Acuerdo_Fecha,
			null as Acuerdo_Cantidad,
			null as Fecha_Comp_Pago,
			null as Pago_Comp_Cantidad,
			null as Fecha_Hora_Agendada,
			a.FechaCreacion as Fecha_Hora_de_Seguimiento,
			a.TelefonoMarcado as Seguimiento_Teléfono_Marcado
		FROM deudor d
		INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
		INNER JOIN seguimientodeudor a on a.IdDeudor = d.IdDeudor AND a.IdEmpresa = d.IdEmpresa
		LEFT JOIN Usuario usu2 on usu2.IdUsuario = a.IdAnalista and usu2.IdEmpresa = a.IdEmpresa
		LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = a.IdTipoGestion and tipGestion.IdEmpresa = a.IdEmpresa
		LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = a.IdEstatus and estatus.IdEmpresa = a.IdEmpresa
		LEFT JOIN estatuscartera alias on  
			alias.IdEmpresa 			= d.IdEmpresa
			and alias.IdCartera 		= seg.IdCartera
			and alias.IdTipoGestion 	= a.IdTipoGestion
			and alias.IdEstatus 		= a.IdEstatus
		WHERE
			d.IdEmpresa = pIdEmpresa
			AND
			(
				seg.IdCartera = IFNULL(pIdCartera, seg.IdCartera)
				AND 
				d.IdSegmento = IFNULL(pIdSegmento, d.IdSegmento)
				AND 
				IFNULL(d.IdUsuarioAsignado, 0) = IFNULL(pIdusuario, IFNULL(d.IdUsuarioAsignado, 0))
			)
		UNION
		Select
			d.IdDeudor as Seguimiento_IdDeudor,
			d.IdEmpresa as Seguimiento_IdEmpresa,
			a.Comentarios as Seguimiento_Comentarios,
			usu2.NombreCompleto as Seguimiento_Analista,
			tipGestion.Nombre as Seguimiento_Tipo_Gestión,
			CASE WHEN pTipoEstatus = 1 then estatus.Nombre 
				 ELSE alias.Alias 
			END as Seguimiento_Estatus,                
			'Agenda Llamada' as Tipo_Seguimiento,
			null as Acuerdo_Fecha,
			null as Acuerdo_Cantidad,
			null as Fecha_Comp_Pago,
			null as Pago_Comp_Cantidad,
			DATE_FORMAT(a.FechaCreacion, '%d/%m/%Y %T') as Seguimiento_Fecha_Agendada,
			a.FechaCreacion as Fecha_Hora_de_Seguimiento,
			a.TelefonoMarcado as Seguimiento_Teléfono_Marcado
		FROM deudor d
		INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
		INNER JOIN agendarllamadadeudor a on a.IdDeudor = d.IdDeudor AND a.IdEmpresa = d.IdEmpresa
		LEFT JOIN Usuario usu2 on usu2.IdUsuario = a.IdAnalista and usu2.IdEmpresa = a.IdEmpresa
		LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = a.IdTipoGestion and tipGestion.IdEmpresa = a.IdEmpresa
		LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = a.IdEstatus and estatus.IdEmpresa = a.IdEmpresa
		LEFT JOIN estatuscartera alias on  
			alias.IdEmpresa 			= d.IdEmpresa
			and alias.IdCartera 		= seg.IdCartera
			and alias.IdTipoGestion 	= a.IdTipoGestion
			and alias.IdEstatus 		= a.IdEstatus
		WHERE
			d.IdEmpresa = pIdEmpresa
			AND
			(
				seg.IdCartera = IFNULL(pIdCartera, seg.IdCartera)
				AND 
				d.IdSegmento = IFNULL(pIdSegmento, d.IdSegmento)
				AND 
				IFNULL(d.IdUsuarioAsignado, 0) = IFNULL(pIdusuario, IFNULL(d.IdUsuarioAsignado, 0))
			)
		ORDER BY 1 asc, 13 desc
        ) t
	);
    
    CREATE TEMPORARY TABLE pT_Seguimiento1 ( SELECT * FROM pT_Seguimiento);
    CREATE TEMPORARY TABLE pT_Seguimiento2 ( SELECT * FROM pT_Seguimiento);
    CREATE TEMPORARY TABLE pT_Seguimiento3 ( SELECT * FROM pT_Seguimiento);
    CREATE TEMPORARY TABLE pT_Seguimiento4 ( SELECT * FROM pT_Seguimiento);
    CREATE TEMPORARY TABLE pT_Seguimiento5 ( SELECT * FROM pT_Seguimiento);
    CREATE TEMPORARY TABLE pT_Seguimiento6 ( SELECT * FROM pT_Seguimiento);
    CREATE TEMPORARY TABLE pT_Seguimiento7 ( SELECT * FROM pT_Seguimiento);
    CREATE TEMPORARY TABLE pT_Seguimiento8 ( SELECT * FROM pT_Seguimiento);
    CREATE TEMPORARY TABLE pT_Seguimiento9 ( SELECT * FROM pT_Seguimiento);
    CREATE TEMPORARY TABLE pT_Seguimiento10 ( SELECT * FROM pT_Seguimiento);
    
	SELECT 
		concat(cli.NombreComercial, ' - ', car.Nombre) as Cliente_Cartera,        
        seg.Segmento,
		d.Nombre,
		d.Credito as Crédito,
		d.RFC,
		d.CalleNumero as Calle_Número,
		d.CP,
		d.Colonia,
		d.Ciudad,
		d.Estado,
		d.TelFijo as Tel_Fijo,
		d.TelCelular as Tel_Celular,
		d.TelAdicional1 as Tel_Adicional_1,
		-- d.TelAdicional2,
		-- d.TelAdicional3,
		d.ImporteDeuda as Importe_Deuda,
		d.PorcentajeDescuento as Porcentaje_Descuento,
		d.DiasdeMora as Días_Mora,
		d.PagoDescuento1 as Pago_Descuento_1,
		d.PagoDescuento2 as Pago_Descuento_2,
		d.MontoPrestamo as Monto_Prestamo,
		d.FechaModificacion as Fecha_Asignación,
		d.FechaVencimiento as Fecha_Vencimiento,
		d.FechaOtorgamiento as Fecha_Otorgamiento,
		d.SaldoActual as Saldo_Actual,
		d.TipoPrestamo as Tipo_Prestamo,
		d.NombreGrupo as Nombre_Grupo,
		d.NumeroGrupo as Número_Grupo,
		d.Banco,
		d.Referencia,
		d.ConvenioPago as Convenio_Pago,
		-- d.Estatus,                
		d.AdicionalTexto1 as Adicional_Texto_1,
		d.AdicionalTexto2 as Adicional_Texto_2,
		d.AdicionalTexto3 as Adicional_Texto_3,
		-- d.AdicionalTexto4,
		-- d.AdicionalTexto5,
		d.AdicionalFecha as Adicional_Fecha,
		d.AdicionalMoneda as Adicional_Moneda,
		d.AdicionalEntero as Adicional_Entero, 
		-- d.AdicionalEstatus
        -- *************** Registros Seguimiento		
		(SELECT Seguimiento_Comentarios 	FROM pT_Seguimiento  where Seguimiento_IdDeudor = d.IdDeudor AND Seguimiento_IdEmpresa = d.IdEmpresa limit 1) as Último_Seguimiento_Comentarios,        
		(SELECT Seguimiento_Analista 		FROM pT_Seguimiento1 where Seguimiento_IdDeudor = d.IdDeudor AND Seguimiento_IdEmpresa = d.IdEmpresa limit 1) as Último_Seguimiento_Analista,
        (SELECT Fecha_Hora_de_Seguimiento 	FROM pT_Seguimiento2 where Seguimiento_IdDeudor = d.IdDeudor AND Seguimiento_IdEmpresa = d.IdEmpresa limit 1) as Última_Fecha_de_Seguimiento,
		(SELECT Seguimiento_Tipo_Gestión 	FROM pT_Seguimiento3 where Seguimiento_IdDeudor = d.IdDeudor AND Seguimiento_IdEmpresa = d.IdEmpresa limit 1) as Último_Seguimiento_Tipo_Gestión,
		(SELECT Seguimiento_Estatus 		FROM pT_Seguimiento4 where Seguimiento_IdDeudor = d.IdDeudor AND Seguimiento_IdEmpresa = d.IdEmpresa limit 1) as Último_Seguimiento_Estatus,
		(SELECT MAX(Acuerdo_Fecha) 			FROM pT_Seguimiento5 where Seguimiento_IdDeudor = d.IdDeudor AND Seguimiento_IdEmpresa = d.IdEmpresa and Acuerdo_Fecha is not null) as Última_Acuerdo_Fecha,
        (SELECT sum(Acuerdo_Cantidad) 		FROM pT_Seguimiento6 where Seguimiento_IdDeudor = d.IdDeudor AND Seguimiento_IdEmpresa = d.IdEmpresa and Acuerdo_Cantidad is not null) as Suma_Acuerdo_Cantidad,
		(SELECT MAX(Fecha_Comp_Pago) 		FROM pT_Seguimiento7 where Seguimiento_IdDeudor = d.IdDeudor AND Seguimiento_IdEmpresa = d.IdEmpresa and Fecha_Comp_Pago is not null) as Última_Fecha_Comp_Pago,
        (SELECT sum(Pago_Comp_Cantidad) 	FROM pT_Seguimiento8 where Seguimiento_IdDeudor = d.IdDeudor AND Seguimiento_IdEmpresa = d.IdEmpresa and Pago_Comp_Cantidad is not null) as Suma_Pago_Comp_Cantidad,
        (SELECT MAX(Fecha_Hora_Agendada) 	FROM pT_Seguimiento9 where Seguimiento_IdDeudor = d.IdDeudor AND Seguimiento_IdEmpresa = d.IdEmpresa and Fecha_Hora_Agendada is not null) as Última_Cita_Agendada,
        (SELECT Seguimiento_Teléfono_Marcado FROM pT_Seguimiento10 where Seguimiento_IdDeudor = d.IdDeudor AND Seguimiento_IdEmpresa = d.IdEmpresa limit 1) as Último_Seguimiento_Teléfono_Marcado,
        -- *************** Datos de contacto adicionales 1
        dcd1.Telefono as Dato_Contacto_1_Teléfono,
		dcd1.CorreoElectronico as Dato_Contacto_1_Correo_Electrónico,
		dcd1.CalleNum as Dato_Contacto_1_Dirección,
        -- *************** Datos de contacto adicionales 2
        dcd2.Telefono as Dato_Contacto_2_Teléfono,
		dcd2.CorreoElectronico as Dato_Contacto_2_Correo_Electrónico,
		dcd2.CalleNum as Dato_Contacto_2_Dirección
	FROM deudor d
    INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
    INNER JOIN Cartera car on car.IdCartera = seg.IdCartera and car.IdEmpresa = d.IdEmpresa
    INNER JOIN Cliente cli on cli.IdCliente = car.IdCliente and cli.IdEmpresa = d.IdEmpresa   
	LEFT JOIN datoscontactodeudor dcd1 on dcd1.IdDeudor = d.IdDeudor AND dcd1.IdEmpresa = d.IdEmpresa and dcd1.Consecutivo = 1
    LEFT JOIN datoscontactodeudor dcd2 on dcd2.IdDeudor = d.IdDeudor AND dcd2.IdEmpresa = d.IdEmpresa and dcd2.Consecutivo = 2
    WHERE
		d.IdEmpresa = pIdEmpresa
        AND
        (
			seg.IdCartera = IFNULL(pIdCartera, seg.IdCartera)
            AND 
            d.IdSegmento = IFNULL(pIdSegmento, d.IdSegmento)
			AND 
            IFNULL(d.IdUsuarioAsignado, 0) = IFNULL(pIdusuario, IFNULL(d.IdUsuarioAsignado, 0))
        )
    order by d.IdDeudor;
    
    DROP TEMPORARY TABLE pT_Seguimiento;
    DROP TEMPORARY TABLE pT_Seguimiento1;
    DROP TEMPORARY TABLE pT_Seguimiento2;
    DROP TEMPORARY TABLE pT_Seguimiento3;
    DROP TEMPORARY TABLE pT_Seguimiento4;
    DROP TEMPORARY TABLE pT_Seguimiento5;
    DROP TEMPORARY TABLE pT_Seguimiento6;
    DROP TEMPORARY TABLE pT_Seguimiento7;
    DROP TEMPORARY TABLE pT_Seguimiento8;
    DROP TEMPORARY TABLE pT_Seguimiento9;
    DROP TEMPORARY TABLE pT_Seguimiento10;
END$$

DROP PROCEDURE IF EXISTS `ObtRepSabana`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtRepSabana` (`pIdCartera` INT(11), `pIdUsuario` INT(11), `pIdSegmento` INT(11), `pIdEmpresa` INT, `pTipoEstatus` INT)  BEGIN

	SELECT 
		concat(cli.NombreComercial, ' - ', car.Nombre) as Cliente_Cartera,        
        seg.Segmento,
		d.Nombre,
		d.Credito as Crédito,
		d.RFC,
		d.CalleNumero as Calle_Número,
		d.CP,
		d.Colonia,
		d.Ciudad,
		d.Estado,
		d.TelFijo as Tel_Fijo,
		d.TelCelular as Tel_Celular,
		d.TelAdicional1 as Tel_Adicional_1,
		-- d.TelAdicional2,
		-- d.TelAdicional3,
		d.ImporteDeuda as Importe_Deuda,
		d.PorcentajeDescuento as Porcentaje_Descuento,
		d.DiasdeMora as Días_Mora,
		d.PagoDescuento1 as Pago_Descuento_1,
		d.PagoDescuento2 as Pago_Descuento_2,
		d.MontoPrestamo as Monto_Prestamo,
		d.FechaModificacion as Fecha_Asignación,
		d.FechaVencimiento as Fecha_Vencimiento,
		d.FechaOtorgamiento as Fecha_Otorgamiento,
		d.SaldoActual as Saldo_Actual,
		d.TipoPrestamo as Tipo_Prestamo,
		d.NombreGrupo as Nombre_Grupo,
		d.NumeroGrupo as Número_Grupo,
		d.Banco,
		d.Referencia,
		d.ConvenioPago as Convenio_Pago,
		-- d.Estatus,                
		d.AdicionalTexto1 as Adicional_Texto_1,
		d.AdicionalTexto2 as Adicional_Texto_2,
		d.AdicionalTexto3 as Adicional_Texto_3,
		-- d.AdicionalTexto4,
		-- d.AdicionalTexto5,
		d.AdicionalFecha as Adicional_Fecha,
		d.AdicionalMoneda as Adicional_Moneda,
		d.AdicionalEntero as Adicional_Entero,
		-- d.AdicionalEstatus,
		usu.NombreCompleto as Analista,
		usu2.NombreCompleto as Analista_U_Contacto,
		d.FechaUltimoContacto as Fecha_U_Contacto,
        tipGestion.Nombre as Último_Tipo_Gestión,
		CASE WHEN pTipoEstatus = 1 then estatus.Nombre 
             ELSE alias.Alias 
		END as Último_Estatus,        
        -- *************** Registros Seguimiento
		Seguimiento.Seguimiento_Comentarios,
		Seguimiento.Seguimiento_Analista,
        Seguimiento.Fecha_de_Seguimiento,
		Seguimiento.Seguimiento_Tipo_Gestión,
		Seguimiento.Seguimiento_Estatus,                
		Seguimiento.Tipo_Seguimiento,
		Seguimiento.Acuerdo_Fecha,
		Seguimiento.Acuerdo_Cantidad,
		Seguimiento.Fecha_Comp_Pago,
		Seguimiento.Pago_Comp_Cantidad,
        Seguimiento.Fecha_Hora_Agendada as Cita_Agendada,
        Seguimiento.Seguimiento_Teléfono_Marcado,
        -- *************** Datos de contacto adicionales 1
        dcd1.Telefono as Dato_Contacto_1_Teléfono,
		dcd1.CorreoElectronico as Dato_Contacto_1_Correo_Electrónico,
		dcd1.CalleNum as Dato_Contacto_1_Dirección,
        -- *************** Datos de contacto adicionales 2
        dcd2.Telefono as Dato_Contacto_2_Teléfono,
		dcd2.CorreoElectronico as Dato_Contacto_2_Correo_Electrónico,
		dcd2.CalleNum as Dato_Contacto_2_Dirección
	FROM deudor d
    INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
    INNER JOIN Cartera car on car.IdCartera = seg.IdCartera and car.IdEmpresa = d.IdEmpresa
    INNER JOIN Cliente cli on cli.IdCliente = car.IdCliente and cli.IdEmpresa = d.IdEmpresa
    LEFT JOIN Usuario usu on usu.IdUsuario = d.IdUsuarioAsignado and usu.IdEmpresa = d.IdEmpresa
    LEFT JOIN Usuario usu2 on usu2.IdUsuario = d.IdAnalistaUltimoContacto and usu2.IdEmpresa = d.IdEmpresa
    LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = d.IdTipoGestion and tipGestion.IdEmpresa = d.IdEmpresa
	LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = d.IdEstatus and estatus.IdEmpresa = d.IdEmpresa
    LEFT JOIN estatuscartera alias on  
        alias.IdEmpresa 		= d.IdEmpresa
        and alias.IdCartera 	= car.IdCartera
        and alias.IdTipoGestion = d.IdTipoGestion
        and alias.IdEstatus 	= d.IdEstatus
	LEFT JOIN datoscontactodeudor dcd1 on dcd1.IdDeudor = d.IdDeudor AND dcd1.IdEmpresa = d.IdEmpresa and dcd1.Consecutivo = 1
    LEFT JOIN datoscontactodeudor dcd2 on dcd2.IdDeudor = d.IdDeudor AND dcd2.IdEmpresa = d.IdEmpresa and dcd2.Consecutivo = 2
    LEFT JOIN
		(
			Select
				d.IdDeudor as Seguimiento_IdDeudor,
                d.IdEmpresa as Seguimiento_IdEmpresa,
				a.Comentarios as Seguimiento_Comentarios,
                usu2.NombreCompleto as Seguimiento_Analista,
                tipGestion.Nombre as Seguimiento_Tipo_Gestión,
                CASE WHEN pTipoEstatus = 1 then estatus.Nombre 
					 ELSE alias.Alias 
				END as Seguimiento_Estatus,                
				'Acuerdo de Pago' as Tipo_Seguimiento,
                DATE_FORMAT(a.FechaPago, '%d/%m/%Y') as Acuerdo_Fecha,
                a.Cantidad as Acuerdo_Cantidad,
                null as Fecha_Comp_Pago,
                null as Pago_Comp_Cantidad,
                null as Fecha_Hora_Agendada,
                a.FechaCreacion as Fecha_Hora_de_Seguimiento,
                a.TelefonoMarcado as Seguimiento_Teléfono_Marcado
			FROM deudor d
			INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
            INNER JOIN acuerdopago a on a.IdDeudor = d.IdDeudor AND a.IdEmpresa = d.IdEmpresa
			LEFT JOIN Usuario usu2 on usu2.IdUsuario = a.IdAnalista and usu2.IdEmpresa = a.IdEmpresa
			LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = a.IdTipoGestion and tipGestion.IdEmpresa = a.IdEmpresa
			LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = a.IdEstatus and estatus.IdEmpresa = a.IdEmpresa
			LEFT JOIN estatuscartera alias on  
				alias.IdEmpresa 			= d.IdEmpresa
				and alias.IdCartera 		= seg.IdCartera
				and alias.IdTipoGestion 	= a.IdTipoGestion
				and alias.IdEstatus 		= a.IdEstatus
            WHERE
				d.IdEmpresa = pIdEmpresa
				AND
				(
					seg.IdCartera = IFNULL(pIdCartera, seg.IdCartera)
					AND 
					d.IdSegmento = IFNULL(pIdSegmento, d.IdSegmento)
					AND 
					IFNULL(d.IdUsuarioAsignado, 0) = IFNULL(pIdusuario, IFNULL(d.IdUsuarioAsignado, 0))
				)
			UNION
			Select
				d.IdDeudor as Seguimiento_IdDeudor,
                d.IdEmpresa as Seguimiento_IdEmpresa,
				a.Comentarios as Seguimiento_Comentarios,
                usu2.NombreCompleto as Seguimiento_Analista,
                tipGestion.Nombre as Seguimiento_Tipo_Gestión,
                CASE WHEN pTipoEstatus = 1 then estatus.Nombre 
					 ELSE alias.Alias 
				END as Seguimiento_Estatus,                
				'Comprobación de Pago' as Tipo_Seguimiento,
                null as Acuerdo_Fecha,
                null as Acuerdo_Cantidad,
                DATE_FORMAT(a.FechaPago, '%d/%m/%Y') as Fecha_Comp_Pago,
                a.Cantidad as Pago_Comp_Cantidad,
                null as Fecha_Hora_Agendada,
                a.FechaCreacion as Fecha_Hora_de_Seguimiento,
                a.TelefonoMarcado as Seguimiento_Teléfono_Marcado
			FROM deudor d
			INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
            INNER JOIN pagocomprobado a on a.IdDeudor = d.IdDeudor AND a.IdEmpresa = d.IdEmpresa
			LEFT JOIN Usuario usu2 on usu2.IdUsuario = a.IdAnalista and usu2.IdEmpresa = a.IdEmpresa
			LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = a.IdTipoGestion and tipGestion.IdEmpresa = a.IdEmpresa
			LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = a.IdEstatus and estatus.IdEmpresa = a.IdEmpresa
			LEFT JOIN estatuscartera alias on  
				alias.IdEmpresa 			= d.IdEmpresa
				and alias.IdCartera 		= seg.IdCartera
				and alias.IdTipoGestion 	= a.IdTipoGestion
				and alias.IdEstatus 		= a.IdEstatus
            WHERE
				d.IdEmpresa = pIdEmpresa
				AND
				(
					seg.IdCartera = IFNULL(pIdCartera, seg.IdCartera)
					AND 
					d.IdSegmento = IFNULL(pIdSegmento, d.IdSegmento)
					AND 
					IFNULL(d.IdUsuarioAsignado, 0) = IFNULL(pIdusuario, IFNULL(d.IdUsuarioAsignado, 0))
				)
			UNION
			Select
				d.IdDeudor as Seguimiento_IdDeudor,
                d.IdEmpresa as Seguimiento_IdEmpresa,
				a.Comentarios as Seguimiento_Comentarios,
                usu2.NombreCompleto as Seguimiento_Analista,
                tipGestion.Nombre as Seguimiento_Tipo_Gestión,
                CASE WHEN pTipoEstatus = 1 then estatus.Nombre 
					 ELSE alias.Alias 
				END as Seguimiento_Estatus,                
				'Registro Contacto' as Tipo_Seguimiento,
                null as Acuerdo_Fecha,
                null as Acuerdo_Cantidad,
                null as Fecha_Comp_Pago,
                null as Pago_Comp_Cantidad,
                null as Fecha_Hora_Agendada,
                a.FechaCreacion as Fecha_Hora_de_Seguimiento,
                a.TelefonoMarcado as Seguimiento_Teléfono_Marcado
			FROM deudor d
			INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
            INNER JOIN seguimientodeudor a on a.IdDeudor = d.IdDeudor AND a.IdEmpresa = d.IdEmpresa
			LEFT JOIN Usuario usu2 on usu2.IdUsuario = a.IdAnalista and usu2.IdEmpresa = a.IdEmpresa
			LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = a.IdTipoGestion and tipGestion.IdEmpresa = a.IdEmpresa
			LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = a.IdEstatus and estatus.IdEmpresa = a.IdEmpresa
			LEFT JOIN estatuscartera alias on  
				alias.IdEmpresa 			= d.IdEmpresa
				and alias.IdCartera 		= seg.IdCartera
				and alias.IdTipoGestion 	= a.IdTipoGestion
				and alias.IdEstatus 		= a.IdEstatus
            WHERE
				d.IdEmpresa = pIdEmpresa
				AND
				(
					seg.IdCartera = IFNULL(pIdCartera, seg.IdCartera)
					AND 
					d.IdSegmento = IFNULL(pIdSegmento, d.IdSegmento)
					AND 
					IFNULL(d.IdUsuarioAsignado, 0) = IFNULL(pIdusuario, IFNULL(d.IdUsuarioAsignado, 0))
				)
			UNION
			Select
				d.IdDeudor as Seguimiento_IdDeudor,
                d.IdEmpresa as Seguimiento_IdEmpresa,
				a.Comentarios as Seguimiento_Comentarios,
                usu2.NombreCompleto as Seguimiento_Analista,
                tipGestion.Nombre as Seguimiento_Tipo_Gestión,
                CASE WHEN pTipoEstatus = 1 then estatus.Nombre 
					 ELSE alias.Alias 
				END as Seguimiento_Estatus,                
				'Agenda Llamada' as Tipo_Seguimiento,
                null as Acuerdo_Fecha,
                null as Acuerdo_Cantidad,
                null as Fecha_Comp_Pago,
                null as Pago_Comp_Cantidad,
                DATE_FORMAT(a.FechaCreacion, '%d/%m/%Y %T') as Seguimiento_Fecha_Agendada,
                a.FechaCreacion as Fecha_Hora_de_Seguimiento,
                a.TelefonoMarcado as Seguimiento_Teléfono_Marcado
			FROM deudor d
			INNER JOIN Segmento seg on seg.IdSegmento =  d.IdSegmento and seg.IdEmpresa = d.IdEmpresa
            INNER JOIN agendarllamadadeudor a on a.IdDeudor = d.IdDeudor AND a.IdEmpresa = d.IdEmpresa
			LEFT JOIN Usuario usu2 on usu2.IdUsuario = a.IdAnalista and usu2.IdEmpresa = a.IdEmpresa
			LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = a.IdTipoGestion and tipGestion.IdEmpresa = a.IdEmpresa
			LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = a.IdEstatus and estatus.IdEmpresa = a.IdEmpresa
			LEFT JOIN estatuscartera alias on  
				alias.IdEmpresa 			= d.IdEmpresa
				and alias.IdCartera 		= seg.IdCartera
				and alias.IdTipoGestion 	= a.IdTipoGestion
				and alias.IdEstatus 		= a.IdEstatus
            WHERE
				d.IdEmpresa = pIdEmpresa
				AND
				(
					seg.IdCartera = IFNULL(pIdCartera, seg.IdCartera)
					AND 
					d.IdSegmento = IFNULL(pIdSegmento, d.IdSegmento)
					AND 
					IFNULL(d.IdUsuarioAsignado, 0) = IFNULL(pIdusuario, IFNULL(d.IdUsuarioAsignado, 0))
				)
			ORDER BY 13 desc
		) Seguimiento ON Seguimiento.Seguimiento_IdDeudor = d.IdDeudor AND Seguimiento.Seguimiento_IdEmpresa = d.IdEmpresa
    WHERE
		d.IdEmpresa = pIdEmpresa
        AND
        (
			seg.IdCartera = IFNULL(pIdCartera, seg.IdCartera)
            AND 
            d.IdSegmento = IFNULL(pIdSegmento, d.IdSegmento)
			AND 
            IFNULL(d.IdUsuarioAsignado, 0) = IFNULL(pIdusuario, IFNULL(d.IdUsuarioAsignado, 0))
        )
    order by d.IdDeudor;

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

DROP PROCEDURE IF EXISTS `ObtSegmentos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtSegmentos` (`pIdCartera` INT(11), `pIdCliente` INT(11), `pIdEmpresa` INT)  BEGIN

	SELECT 
		seg.IdSegmento,
		seg.IdCartera,
		seg.IdEmpresa,
		seg.Segmento,
		seg.Fecha,
		seg.Archivo,
		seg.EsActivo,
		seg.TotalSegmento,
		seg.TotalRecuperado,
		seg.TotalRegistros,
		seg.FechaUltimaModificacion,
        car.Nombre as Cartera,
        cli.NombreComercial as Cliente,        
        CASE WHEN EXISTS(	SELECT 1 
							FROM mapeocolumnasegmento cl 
                            WHERE 
								cl.IdSegmento = seg.IdSegmento
                                AND cl.IdEmpresa = seg.IdEmpresa
						) THEN 1 ELSE 0 
		END as Mapeado
	FROM segmento seg
    INNER JOIN Cartera car on car.IdCartera = seg.IdCartera and car.IdEmpresa = seg.IdEmpresa
    INNER JOIN Cliente cli on cli.IdCliente = car.IdCliente and cli.IdEmpresa = seg.IdEmpresa
    WHERE
		seg.IdEmpresa = pIdEmpresa
        AND
        (
			seg.IdCartera = IFNULL(pIdCartera, car.IdCartera)
			AND 
            cli.IdCliente = IFNULL(pIdCliente, cli.IdCliente)
        );


END$$

DROP PROCEDURE IF EXISTS `ObtSegmentosBuscar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtSegmentosBuscar` (`pNombreCompleto` VARCHAR(250), `pIdEmpresa` INT)  BEGIN    
	SELECT 
		CAST(seg.IdSegmento as char(200))as id,
		CAST(seg.Segmento as char(200)) text
	FROM segmento seg
    WHERE
		seg.IdEmpresa = pIdEmpresa
        AND seg.Segmento like concat('%', IFNULL(pNombreCompleto, ''), '%');

END$$

DROP PROCEDURE IF EXISTS `ObtSegmentosPorAnalista`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtSegmentosPorAnalista` (`pIdUsuario` INT(11), `pIdEmpresa` INT)  BEGIN

	SELECT 
		seg.IdSegmento,
        cli.NombreComercial as Cliente,
        car.Nombre as Cartera,        
		seg.Segmento
	FROM segmento seg
    INNER JOIN Cartera car on car.IdCartera = seg.IdCartera and car.IdEmpresa = seg.IdEmpresa
    INNER JOIN Cliente cli on cli.IdCliente = car.IdCliente and cli.IdEmpresa = seg.IdEmpresa
    INNER JOIN
		(
			SELECT distinct
				d.IdSegmento
            FROM deudor d
            where 
				d.IdEmpresa = pIdEmpresa
				AND IFNULL(d.IdUsuarioAsignado, 0) = pIdUsuario
                AND d.EsActivo = 1
        ) deud on deud.IdSegmento = seg.IdSegmento
    WHERE
		seg.IdEmpresa = pIdEmpresa
        AND seg.EsActivo = 1
        AND car.Activo = 1
        AND cli.Activo = 1;
        
END$$

DROP PROCEDURE IF EXISTS `ObtSeguimientoDeudor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtSeguimientoDeudor` (`pIdDeudor` INT, `pIdEmpresa` INT)  BEGIN
	
    SELECT
		Seguimiento
        , Comentarios
        , TipoGestion
        , Estatus
        , Tipo
	FROM(
		Select
			a.FechaCreacion,
			concat(DATE_FORMAT(a.FechaCreacion, '%d/%m/%Y %T'), '- ', usu2.NombreCompleto) as Seguimiento,
			concat('Fecha de Pago: ', DATE_FORMAT(a.FechaPago, '%d/%m/%Y'), ' - Cantidad: ', a.Cantidad, IFNULL(CONCAT('\nComentarios: ', a.Comentarios), '')) as Comentarios,
            tipGestion.Nombre as TipoGestion,
            estatus.Nombre as Estatus,
			'Acuerdo de Pago' as Tipo
		from acuerdopago a
		LEFT JOIN Usuario usu2 on usu2.IdUsuario = a.IdAnalista and usu2.IdEmpresa = a.IdEmpresa
		LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = a.IdTipoGestion and tipGestion.IdEmpresa = a.IdEmpresa
        LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = a.IdEstatus and estatus.IdEmpresa = a.IdEmpresa
		where 
			a.IdDeudor = pIdDeudor
			AND a.IdEmpresa = pIdEmpresa
		UNION
        Select
			a.FechaCreacion,
			concat(DATE_FORMAT(a.FechaCreacion, '%d/%m/%Y %T'), '- ', usu2.NombreCompleto) as Seguimiento,
			concat('Fecha de Pago: ', DATE_FORMAT(a.FechaPago, '%d/%m/%Y'), ' - Cantidad: ', a.Cantidad, IFNULL(CONCAT('\nComentarios: ', a.Comentarios), '')) as Comentarios,
            tipGestion.Nombre as TipoGestion,
            estatus.Nombre as Estatus,
			'Comprobación de Pago' as Tipo
		from pagocomprobado a
		LEFT JOIN Usuario usu2 on usu2.IdUsuario = a.IdAnalista and usu2.IdEmpresa = a.IdEmpresa
		LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = a.IdTipoGestion and tipGestion.IdEmpresa = a.IdEmpresa
        LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = a.IdEstatus and estatus.IdEmpresa = a.IdEmpresa
		where 
			a.IdDeudor = pIdDeudor
			AND a.IdEmpresa = pIdEmpresa
		UNION
		Select
			a.FechaCreacion,
			concat(DATE_FORMAT(a.FechaCreacion, '%d/%m/%Y %T'), '- ', usu2.NombreCompleto) as Seguimiento,
			a.Comentarios,
			tipGestion.Nombre as TipoGestion,
            estatus.Nombre as Estatus,
			'Registro Contacto' as Tipo
		from seguimientodeudor a
		LEFT JOIN Usuario usu2 on usu2.IdUsuario = a.IdAnalista and usu2.IdEmpresa = a.IdEmpresa
		LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = a.IdTipoGestion and tipGestion.IdEmpresa = a.IdEmpresa
        LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = a.IdEstatus and estatus.IdEmpresa = a.IdEmpresa
		where 
			a.IdDeudor = pIdDeudor
			AND a.IdEmpresa = pIdEmpresa
		UNION
		Select
			a.FechaCreacion,
			concat(DATE_FORMAT(a.FechaCreacion, '%d/%m/%Y %T'), '- ', usu2.NombreCompleto) as Seguimiento,
            concat('Cita de Llamada: ', DATE_FORMAT(a.FechaAgenda, '%d/%m/%Y %T'), IFNULL(CONCAT('\nComentarios: ', a.Comentarios), '')) as Comentarios,			
			tipGestion.Nombre as TipoGestion,
            estatus.Nombre as Estatus,
			'Agenda Llamada' as Tipo
		from agendarllamadadeudor a
		LEFT JOIN Usuario usu2 on usu2.IdUsuario = a.IdAnalista and usu2.IdEmpresa = a.IdEmpresa
		LEFT JOIN Catalogo tipGestion on tipGestion.IdCatalogo = a.IdTipoGestion and tipGestion.IdEmpresa = a.IdEmpresa
        LEFT JOIN SubCatalogo estatus on estatus.IdSubCatalogo = a.IdEstatus and estatus.IdEmpresa = a.IdEmpresa
		where 
			a.IdDeudor = pIdDeudor
			AND a.IdEmpresa = pIdEmpresa
	) T
    ORder by FechaCreacion DESC;
		
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuarioValidar` (`pIdEmpresa` INT(11), `pLogin` VARCHAR(50), `pContrasenia` VARCHAR(100))  BEGIN
	DECLARE pCeroEntero INT(11);
    DECLARE pTrue tinyint(1);    
    DECLARE pFalse tinyint(1);
    
    SET pCeroEntero = 0;
    SET pTrue = 1;
    SET pFalse = 0;

	if exists (	select 1 
				from empresa 
                where 
					IdEmpresa 		  = pIdEmpresa 
                    and Administrador = pLogin
                    and Contraseña    = pContrasenia) then		
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
			IdEmpresa 		  = pIdEmpresa 
            and Administrador = pLogin
            and Contraseña    = pContrasenia;
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

DELIMITER ;

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `catalogo`
--

INSERT INTO `catalogo` (`IdCatalogo`, `Nombre`, `Descripcion`, `IdTipoCatalogo`, `EsActivo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Clave`, `IdEmpresa`) VALUES
(1, 'G. Telefónica', 'Gestión Telefonica', 1, 1, 0, '2017-10-13 19:49:20', 0, '2017-10-13 19:49:20', 'Telefonica', 1),
(2, 'G. Domiciliaria', 'Gestion Domiciliaria', 1, 1, 0, '2017-10-13 19:49:56', 3, '2017-11-11 01:37:03', 'Domiciliaria', 1),
(3, 'G. Otra', 'Otra', 1, 1, 0, '2017-10-13 19:50:17', 0, '2017-10-13 19:50:28', 'Otra', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ciudad`
--

DROP TABLE IF EXISTS `ciudad`;
CREATE TABLE IF NOT EXISTS `ciudad` (
  `IdCiudad` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IdEstado` int(11) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` timestamp NULL DEFAULT NULL,
  `Estatus` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`IdCiudad`) USING BTREE,
  KEY `R_24` (`IdEstado`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
  `Empresa_Correo` varchar(150) NOT NULL,
  `Empresa_Telefono` varchar(15) NOT NULL,
  `Contacto_Nombre` varchar(64) NOT NULL COMMENT 'Nombre de la persona que fungirá como contacto',
  `Contacto_Email` varchar(64) NOT NULL COMMENT 'Cuenta de correo del contacto',
  `Contacto_Telefono` varchar(32) NOT NULL COMMENT 'Teléfono fijo del contacto',
  `Comentarios` varchar(128) DEFAULT NULL COMMENT 'Comentarios',
  `Activo` tinyint(1) NOT NULL DEFAULT '1',
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IdCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`IdCliente`, `IdEmpresa`, `RFC`, `RazonSocial`, `NombreComercial`, `Direccion`, `Empresa_Correo`, `Empresa_Telefono`, `Contacto_Nombre`, `Contacto_Email`, `Contacto_Telefono`, `Comentarios`, `Activo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`) VALUES
(1, 1, 'ALM140707T56', 'Almaximo Consultoria TI S.C.', 'AlMaximo', 'Nueva Galica España 7045-1\nColonia. Vista Hermosa', '', '', 'JAIME CELAYA H', 'jcelaya@almaximot.com', '4775772721', 'Ninguno', 0, 0, '2017-10-13 19:41:20', 0, '2017-11-14 22:22:20'),
(2, 1, 'Lib980102AVC', 'Departamentales Liberpool de Mexico SA de CV', 'Liberpool', 'Ninguna', '', '', 'Juan Amezcua Robles', 'jcelaya@yahoo.com', '4775772721', 'Comentarios X', 1, 3, '2017-11-06 00:39:02', 3, '2017-11-06 00:39:22'),
(3, 1, 'FGL1234W6800', 'FIGLOSNTE13', 'DAFI', 'HFGFJGJGKG', '', '', 'ANDRES MENDOZA', 'DAFI@FIGLOSNTE.COM', '3457689890', NULL, 1, 3, '2017-11-07 05:48:52', 3, '2017-11-18 00:34:41'),
(4, 1, 'CPM700101PLM', 'Caja Popular Mexicana RL AS', 'Caja', 'adafdadsfdsf', '', '', 'Jose Cendeas', 'jdsafasf@yahoo.com', '147852336', 'asdfdsafdsaf', 0, 3, '2017-11-08 22:12:11', 0, '2017-11-14 22:22:28'),
(5, 1, 'TCR0508105L5', 'TE CREEMOS SA DE CV SFP', 'TE CREEMOS', 'AV XOLA #324 COLONIA DEL VALLE DELEGACION BENITO JUAREZ CIUDAD DE MEXICO CP. 03103', '', '', 'JORGE GONZALEZ', 'jdominguez@tecreemos.com', '5543564378', NULL, 1, 3, '2017-11-10 06:46:14', 3, '2017-11-10 06:46:21'),
(6, 1, 'FCL101009KLJ', 'FINCLUSION SA DE CV SFP', 'FINCLUSION SA DE CV', 'AV XOLA 324 COLONIA DEL VALLE DELEGACION BENITO JUAREZ CIUDAD DE MEXICO CP 03103', '', '', 'JORGE DOMINGUEZ', 'jdominguez@tecreemos.com', '5543564378', NULL, 1, 3, '2017-11-10 06:53:46', 3, '2017-11-10 06:53:46'),
(7, 1, 'FFI090512H13', 'TCRFIN SA DE CV SOFOM ENR', 'FINANCIERA FINCA', 'AV XOLA 324 COLONIA DEL VALLE DELEGACION BENITO JUAREZ CIUDAD DE MEXICO CP 03103', '', '', 'JORGE DOMINGUEZ', 'jdominguez@tecreemos.com', '5543564378', NULL, 1, 3, '2017-11-10 06:58:29', 3, '2017-11-10 06:58:29'),
(8, 1, 'SME5503113Z4', 'STANHOME DE MEXICO SA DE CV', 'STANHOME', 'PONIENTE 146 INT 624 COLONIA INDUSTRIAL VALLEJO DELEGACION AZCAPOTZALCO CIUDAD DE MEXICO CP 02300', '', '', 'JAIME RODRIGUEZ ', 'jaime.rodriguez@yrnet.com', '5534344892', NULL, 1, 3, '2017-11-10 07:02:43', 3, '2017-11-10 07:02:43'),
(9, 1, 'FEC050520AA2', 'FIANCIERA EQUIPATE SA DE CV SOFOM ENRFEC', 'FINANCIERA EQUIPAT', 'PASEO DE LA REFORMA #300 PISO 7 OFICINA 702 COLONIA JUAREZ CIUDAD DE MEXICO', '', '', 'ADOLFO HOLGUIN', 'jaolguin@equipat.com.mx', '55 4991 3504', NULL, 1, 3, '2017-11-10 07:07:23', 3, '2017-11-10 07:08:20'),
(10, 1, 'FGS110530IY7', 'FIGLOSNTE 13', 'DAFI MAGISTERIAL', 'CARRETERA ESTATAL LIBRE GUANAJUATO JUVENTINO ROSAS KM 7.5 COLONIA YERBABUENA GUANAJUATO GUANAJUATO CP 36250', '', '', 'ANDRES MENDOZA', 'amendoza@dafi.com.mx', '477 449 00 92', NULL, 1, 3, '2017-11-10 07:15:38', 3, '2017-11-10 07:15:42'),
(11, 1, 'SCR050912JL5', 'SIEMPRE CRECIENDO SA DE CV SOFOM ENR', 'FINANCIERA SIEMPRE CRECIENDO', 'CALZADA GRAL MARIANO ESCOBEDO 550 PISO 4 COLONIA ANZUREZ DELEGACION MIGUEL HIDALGO CIUDAD DE MEXICO CP 11590', '', '', 'RAUL  LOPEZ', 'cord_cobranza@creciendo.com.mx', '55 2702 6345', NULL, 1, 3, '2017-11-10 07:19:36', 3, '2017-11-10 07:19:36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `colonia`
--

DROP TABLE IF EXISTS `colonia`;
CREATE TABLE IF NOT EXISTS `colonia` (
  `IdColonia` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CP` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IdCiudad` int(11) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` timestamp NULL DEFAULT NULL,
  `Estatus` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`IdColonia`) USING BTREE,
  KEY `R_25` (`IdCiudad`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
  `Contraseña` varchar(250) NOT NULL,
  `NombreComercial` varchar(100) NOT NULL,
  `RutaLogo` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`IdEmpresa`),
  UNIQUE KEY `IX_Empresa` (`Dominio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='La entidad Empresa representa a cada uno de nuestros clientes';

--
-- Volcado de datos para la tabla `empresa`
--

INSERT INTO `empresa` (`IdEmpresa`, `Dominio`, `ProductKey`, `Administrador`, `Contraseña`, `NombreComercial`, `RutaLogo`) VALUES
(1, '@Cobexa.com', 'MA5SCzEnOOMy9GaY6Ww30UhTURMZT9JxmtrrW4tAHNM=', 'Administrador', '+8gNci97Kp/Rex0XrtGLlg==', 'CONSORCIO COBEXA & ASOCIADOS', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

DROP TABLE IF EXISTS `estado`;
CREATE TABLE IF NOT EXISTS `estado` (
  `IdEstado` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Clave` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` timestamp NULL DEFAULT NULL,
  `Estatus` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`IdEstado`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

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
(11, 'Clientes', 'Clientes', 1, 1, 2, 'Clientes', 'Cliente_Index', 'Configuracion', 0, 4, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración) Forma correspondiente a Gestión de Clientes', 1, 0),
(16, 'Catalogos', 'Catálogos', 1, 1, 2, 'Catálogos Estatus', 'Catalogo_Index', 'Configuracion', 1, 6, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración > Catálogos) Grupo de menú para Catálogos', 1, 0),
(17, 'SubCatalogos', 'SubCatálogos', 0, 1, 2, 'SubCatálogos', 'SubCatalogo_Index', 'SubCatalogo', 0, 4, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración > Catálogos) Forma complementaria para la Gestión de Catálogos', 1, 0),
(18, 'Reportes', 'Reportes', 1, 1, 0, 'Reportes', NULL, NULL, 1, 4, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración) Opción desplegable de menú Reportes', 1, 0),
(21, 'BitacoraErrorDeudor', 'Bitácora de errores al importar datos deudor', 1, 1, 2, 'Bitácora de Errores', 'BitacoraErrorDeudor_Index', 'BitacoraErrorDeudor', 0, 5, 1, '2017-04-10 20:05:12', 1, '2017-04-10 20:05:12', 1, '(Administración) Forma correspondiente a Bitácora de errores al importar datos deudor', 1, 0);

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
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;

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
(25, 10, 4, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Eliminar'),
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
(55, 21, 2, 0, '2017-09-13 09:26:33', 0, '2017-09-14 09:33:49', 0, 1, 'Eliminar');

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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `formarol`
--

INSERT INTO `formarol` (`IdFormaRol`, `IdForma`, `IdRol`, `Privilegios`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`, `IdEmpresa`) VALUES
(1, 1, 1, 1, 1, '2017-10-08 00:54:53', 1, '2017-10-08 00:54:53', 1, 1),
(3, 1, 2, 1, 1, '2017-11-06 00:27:33', 1, '2017-11-06 00:27:33', 1, 1),
(4, 2, 2, 1, 1, '2017-11-06 00:28:47', 1, '2017-11-06 00:28:47', 1, 1),
(5, 3, 2, 15, 1, '2017-11-06 00:28:59', 1, '2017-11-06 00:28:59', 1, 1),
(6, 4, 2, 15, 1, '2017-11-06 00:29:09', 1, '2017-11-06 00:29:09', 1, 1),
(7, 5, 2, 15, 1, '2017-11-06 00:29:19', 1, '2017-11-06 00:29:19', 1, 1),
(8, 6, 2, 1, 1, '2017-11-06 00:29:30', 1, '2017-11-06 00:29:30', 1, 1),
(9, 7, 2, 1, 1, '2017-11-06 00:29:39', 1, '2017-11-06 00:29:39', 1, 1),
(10, 11, 2, 15, 1, '2017-11-06 00:29:48', 1, '2017-11-06 00:29:48', 1, 1),
(15, 16, 2, 15, 1, '2017-11-06 00:30:44', 1, '2017-11-06 00:30:44', 1, 1),
(16, 17, 2, 15, 1, '2017-11-06 00:30:51', 1, '2017-11-06 00:30:51', 1, 1),
(17, 18, 2, 1, 1, '2017-11-06 00:30:57', 1, '2017-11-06 00:30:57', 1, 1);

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
  PRIMARY KEY (`IdNacionalidad`) USING BTREE,
  KEY `R_54` (`IdUsuarioCreacion`) USING BTREE,
  KEY `R_60` (`IdUsuarioUltimoModifico`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `parametro`
--

INSERT INTO `parametro` (`IdParametro`, `Nombre`, `Descripcion`, `Valor`, `EsActivo`, `EsSensitivo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`, `IdEmpresa`) VALUES
(1, 'SMTP', 'Servidor con servicio SMTP para envio de correos eléctronicos', 'smtp.gmail.com', 1, 0, 1, '2017-04-10 20:05:13', 0, '2017-09-20 05:24:09', 1, 1),
(2, 'Puerto', 'Puerto para el envio de correos s', '587', 1, 0, 1, '2017-04-10 20:05:13', 1, '2017-04-10 20:05:13', 1, 1),
(3, 'Remitente', 'Remitente del email', 'ALMCorreoAutomatico@gmail.com', 1, 0, 1, '2017-04-10 20:05:13', 1, '2017-04-10 20:05:13', 1, 1),
(4, 'Contrasenia', 'Contraseña del Correo', 'EnvioCorreo123$', 1, 0, 1, '2017-04-10 20:05:13', 1, '2017-04-10 20:05:13', 1, 1),
(5, 'Rol Analista', 'Análista', 'Análista', 1, 0, 1, '2017-10-01 18:39:00', 1, '2017-04-10 20:05:13', 1, 1),
(6, 'MinCallBack', 'Valor minimo CallBack (minutos)', '30', 1, 0, 1, '2017-10-01 18:39:00', 1, '2017-10-01 18:39:00', 1, 1),
(7, 'MaxCallBack', 'Valor máximo CallBack (minutos)', '4320', 1, 0, 1, '2017-10-01 18:39:00', 1, '2017-10-01 18:39:00', 1, 1),
(8, 'EstatusNoNavegar', 'Estatus para ignorar al navegar', '', 1, 0, 1, '2017-10-01 18:39:00', 1, '2017-10-01 18:39:00', 1, 1),
(9, 'EstatusNoSeguimiento', 'Estatus para no permitir dar de alta más seguimientos', '', 1, 0, 1, '2017-10-01 18:39:00', 1, '2017-10-01 18:39:00', 1, 1),
(10, 'CorreoCCImportarDeudores', 'Correo con copia a, al haber un error al importar deudores', '', 1, 0, 1, '2017-10-01 18:39:00', 1, '2017-10-01 18:39:00', 1, 1),
(11, 'EmailImportarDeudores', 'Cuerpo del correo que se envia al haber un error al importar deudores', '<!DOCTYPE html><html lang=\"en\" xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta charset=\"utf-8\" /><title>Sistema Integral de Cobranza</title></head><body style=\"color:rgb(56,87,157)\">    <h2>Sistema Integral de Cobranza</h2>    <hr style=\"color:rgb(56,87,157);background-color:rgb(56,87,157);border-color:rgb(56,87,157);border-width:0.5px;\"/>    <div id=\"content\" style=\"color:rgb(171,39,96)\">              <p style=\"color:rgb(171,39,96)\">Estimado Usuario:</p><p>           Hacemos de su conocimiento que hubo errores al importar deudores para el segmento: %%SEGMENTO%% <br /> Total de registros a importar: %%TOTAL%% <br /> Total de registros no importados: %%INCORRECTOS%%		   <br /><br />           Para poder obtener más información al respecto le sugerimos contactar al administrador del sistema o con el área informática.        </p>                <p>Atentamente:</p>        <p><b>Sistema Integral de Cobranza</span></b></p>        <hr style=\"color:rgb(56,87,157);background-color:rgb(56,87,157);border-color:rgb(56,87,157);border-width:0.5px;\"/>        <p style=\"font-size:80%\">Este correo es exclusivamente de carácter informativo, por favor no intente responder a este ya que este se originó de un proceso automatizado.</p>        <br>     </div></body></html>', 1, 0, 1, '2017-10-01 18:39:00', 1, '2017-10-01 18:39:00', 1, 1),
(12, 'TituloImportarDeudores', 'Título del correo  que se envía al haber un error al importar deudores', 'Notificación de Errores al importar Deudores', 1, 0, 1, '2017-10-01 18:39:00', 1, '2017-10-01 18:39:00', 1, 1);

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
(1, 'URLServicio', 'URL Servicio', 'http://localhost:82/', 1, 0, 1, '2017-04-11 01:05:13', 0, '2017-09-20 10:40:26', 1),
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
-- Estructura de tabla para la tabla `registroscript`
--

DROP TABLE IF EXISTS `registroscript`;
CREATE TABLE IF NOT EXISTS `registroscript` (
  `IdRegistroScript` int(11) NOT NULL AUTO_INCREMENT,
  `NumeroScript` int(11) NOT NULL,
  `NombreScript` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `NombreQuienRealizo` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Fecha` int(11) NOT NULL,
  PRIMARY KEY (`IdRegistroScript`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`IdRol`, `NombreRol`, `Estatus`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`, `IdEmpresa`) VALUES
(1, 'Análista', 1, 1, '2017-10-07 05:00:00', 1, '2017-10-07 05:00:00', 1, 1),
(2, 'Coordinador', 1, 0, '2017-11-06 00:27:33', 0, '2017-11-06 00:27:33', 1, 1);

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `rolusuario`
--

INSERT INTO `rolusuario` (`IdRolUsuario`, `IdUsuario`, `IdRol`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`, `IdEmpresa`) VALUES
(1, 1, 1, 0, '2017-10-13 19:47:55', 0, '2017-10-13 19:47:55', 1, 1),
(2, 2, 1, 0, '2017-10-23 20:37:45', 0, '2017-10-23 20:37:45', 1, 1),
(3, 3, 1, 0, '2017-11-06 00:27:00', 0, '2017-11-06 00:27:00', 1, 1),
(4, 3, 2, 0, '2017-11-06 00:27:57', 0, '2017-11-06 00:27:57', 1, 1),
(5, 4, 1, 3, '2017-11-07 05:46:18', 3, '2017-11-07 05:46:18', 1, 1),
(6, 5, 1, 3, '2017-11-10 06:20:12', 3, '2017-11-10 06:20:12', 1, 1),
(7, 6, 1, 3, '2017-11-10 06:24:38', 3, '2017-11-10 06:24:38', 1, 1),
(8, 7, 1, 3, '2017-11-10 06:27:42', 3, '2017-11-10 06:27:42', 1, 1),
(9, 8, 1, 3, '2017-11-10 06:33:57', 3, '2017-11-10 06:33:57', 1, 1),
(10, 9, 1, 3, '2017-11-10 06:36:53', 3, '2017-11-10 06:36:53', 1, 1),
(11, 4, 2, 3, '2017-11-10 06:38:18', 3, '2017-11-10 06:38:18', 1, 1),
(12, 10, 1, 3, '2017-11-13 06:45:42', 3, '2017-11-13 06:45:42', 1, 1);

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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `subcatalogo`
--

INSERT INTO `subcatalogo` (`IdSubCatalogo`, `IdCatalogo`, `IdEmpresa`, `Clave`, `Nombre`, `Descripcion`, `IdTipoCatalogo`, `EsActivo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`) VALUES
(1, 1, 1, 'G.T 001', 'G.T 001', 'G.T 001', 2, 0, 0, '2017-10-13 19:51:00', 3, '2017-11-11 07:40:26'),
(2, 1, 1, 'G.T 002', 'G.T 002', 'G.T 002', 2, 0, 0, '2017-10-13 19:51:16', 3, '2017-11-17 02:21:57'),
(3, 1, 1, 'G.T 0000003', 'G.T 003', 'G.T 003', 2, 0, 0, '2017-10-13 19:51:30', 3, '2017-11-11 07:40:46'),
(4, 1, 1, 'G.D. AAA', 'G.D. AAA', 'G.D. AAA', 2, 0, 0, '2017-10-13 19:51:51', 3, '2017-11-11 07:40:10'),
(5, 2, 1, 'G.D. BBB', 'G.D. BBB', 'G.D. BBB', 2, 0, 0, '2017-10-13 19:52:04', 3, '2017-11-17 02:22:13'),
(6, 3, 1, 'G.O. i', 'G.O. i', 'G.O. i', 2, 0, 0, '2017-10-13 19:52:23', 3, '2017-11-17 02:22:26'),
(7, 1, 1, '001', 'RECADO CON FAMILIAR', 'TYUIOL', 2, 0, 3, '2017-11-07 05:53:15', 3, '2017-11-17 02:23:21'),
(8, 1, 1, '003', 'ILOCALIZABLE', 'mag', 2, 1, 3, '2017-11-08 22:00:24', 3, '2017-11-17 02:24:03'),
(9, 2, 1, '0145', 'EstatusArmando', 'xxxxx', 2, 0, 3, '2017-11-08 22:09:47', 3, '2017-11-17 02:22:59'),
(10, 3, 1, 'TG0002', 'TG0002', 'TG0002', 2, 0, 3, '2017-11-08 22:16:14', 3, '2017-11-17 02:22:44'),
(11, 1, 1, 'RF', 'RECADO CON FAMILIAR', 'RF', 2, 1, 3, '2017-11-11 01:21:31', 3, '2017-11-11 01:31:36'),
(12, 1, 1, 'PP', 'PROMESA DE PAGO', 'PP', 2, 1, 3, '2017-11-11 01:30:48', 3, '2017-11-11 01:30:48'),
(13, 1, 1, 'NE', 'NUMERO EQUIVOCADO', 'NE', 2, 1, 3, '2017-11-11 01:38:11', 3, '2017-11-11 01:38:11'),
(14, 1, 1, 'RO', 'RECADO CON TERCEROS', 'RO', 2, 1, 3, '2017-11-11 01:39:02', 3, '2017-11-11 01:39:02'),
(15, 1, 1, 'DF', 'DEFUNCION', 'DF', 2, 1, 3, '2017-11-11 01:39:27', 3, '2017-11-11 01:39:27'),
(16, 1, 1, 'PP GRUPAL', 'PROMESA DE PAGO GRUPAL', 'PP GRUPAL', 2, 1, 3, '2017-11-11 01:40:35', 3, '2017-11-11 01:40:35'),
(17, 1, 1, 'BZ', 'BUZON DE VOZ', 'BZ', 2, 1, 3, '2017-11-11 01:41:02', 3, '2017-11-11 01:41:02'),
(18, 1, 1, 'NC', 'NO CONTESTA', 'NC', 2, 1, 3, '2017-11-11 01:41:22', 3, '2017-11-11 01:41:22'),
(19, 1, 1, 'FS', 'FUERA DE SERVICIO', 'FS', 2, 1, 3, '2017-11-11 01:41:53', 3, '2017-11-11 01:41:53'),
(20, 1, 1, 'AC', 'ACLARACION', 'AC', 2, 1, 3, '2017-11-11 01:42:56', 3, '2017-11-11 01:42:56'),
(21, 1, 1, 'PPPARCIAL', 'PAGO PARCIAL', 'PPPARCIAL', 2, 1, 3, '2017-11-11 01:44:22', 3, '2017-11-11 01:44:22'),
(22, 1, 1, 'NP', 'NEGATIVA DE PAGO', 'NP', 2, 1, 3, '2017-11-11 01:45:13', 3, '2017-11-11 01:45:13'),
(23, 1, 1, 'CTA LIQ MES', 'CUENTA LIQUIDADA', 'CTA LIQ MES', 2, 1, 3, '2017-11-11 01:46:04', 3, '2017-11-11 01:46:04'),
(24, 1, 1, 'IS', 'INSOLVENTE', 'IS', 2, 1, 3, '2017-11-11 01:46:53', 3, '2017-11-11 01:46:58'),
(25, 1, 1, 'CT', 'CONTACTO TITULAR', 'CT', 2, 1, 3, '2017-11-11 01:51:14', 3, '2017-11-11 01:51:14'),
(26, 1, 1, 'IT', 'ILOCALIZABLE TELEFONICAMENTE', NULL, 2, 1, 3, '2017-11-17 06:27:20', 3, '2017-11-17 06:27:20');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipocatalogo`
--

INSERT INTO `tipocatalogo` (`IdEmpresa`, `IdTipoCatalogo`, `Nombre`, `NombreSingular`, `TipoSubCatalogo`, `IdTipoCatalogo_SubCatalogo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `Visible`) VALUES
(1, 1, 'Tipo Gestion', NULL, 0, NULL, 1, '2017-10-08 05:00:00', 1, '2017-10-08 05:00:00', 1),
(1, 2, 'Estatus Tipo Gestion', 'Tipo Gestion', 1, 1, 1, '2017-10-08 05:00:00', 1, '2017-10-08 05:00:00', 1);

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`IdUsuario`, `IdEmpresa`, `Login`, `NombreCompleto`, `CorreoElectronico`, `Contrasenia`, `Activo`, `CodigoRecuperaContrasenia`, `UsuarioId`, `UltimoModifico`, `Comentarios`, `IdInstitucion`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`, `Domicilio`, `Telefono`, `Referencia`, `ReferenciaTelefono`, `FechaNacimiento`) VALUES
(1, 1, 'jessica', 'Jessica Robles Martinez', 'jcelayah@gmail.com', 'aCjB6zZI4Qmgwr6c2j5GpA==', 1, NULL, 0, 3, 'Comentarios', NULL, 0, '2017-10-13 19:47:55', 3, '2017-11-06 00:33:37', 1, 'Calle Irack 125\nSan Felipe de Jesus', '477 577 2821', 'Ninguna', 'Ninguna', '2017-10-13'),
(2, 1, 'mlopez', 'Mario Lopez R', 'contactoadm@almaximoti.com', 'aCjB6zZI4Qmgwr6c2j5GpA==', 1, NULL, 0, 3, 'sdfasdfadfsd', NULL, 0, '2017-10-23 20:37:45', 3, '2017-11-06 00:34:30', 1, 'sdfasdfasd sdf asdfasdf', '147852369', 'asd', 'asd', '2017-10-23'),
(3, 1, 'fcuevas', 'Gabriel Fabian Cuevas A.', 'contactorh@almaximoti.com', 'aCjB6zZI4Qmgwr6c2j5GpA==', 1, NULL, 0, 3, NULL, NULL, 0, '2017-11-06 00:27:00', 3, '2017-11-06 00:34:49', 1, 'Las Acacias Numero 25\nLas Flores del Campos', '4772772721', 'Ninguno', 'Ninguno', '2017-11-05'),
(4, 1, 'armandor', 'ARMANDO ROCHA', 'armandor@Cobexa.com', 'DrnYh12TzqoewXkdtWiDmg==', 1, NULL, 0, 3, NULL, NULL, 3, '2017-11-07 05:46:18', 3, '2017-11-10 06:38:23', 1, NULL, '477 165 70 52', NULL, NULL, '1988-11-02'),
(5, 1, 'TERESAD', 'TERESA DURAN', 'teresad@Cobexa.com', 'DrnYh12TzqoewXkdtWiDmg==', 1, NULL, 0, 3, NULL, NULL, 3, '2017-11-10 06:20:12', 3, '2017-11-10 06:20:49', 1, NULL, '477 353 90 04', NULL, NULL, '1977-11-03'),
(6, 1, 'LESLIEM', 'LESLIE MANRIQUEZ', 'LESLIEM@Cobexa.com', 'DrnYh12TzqoewXkdtWiDmg==', 1, NULL, 0, 3, NULL, NULL, 3, '2017-11-10 06:24:38', 3, '2017-11-10 06:26:09', 1, NULL, '477 551 90 88', NULL, NULL, '1999-09-24'),
(7, 1, 'JESSICAH', 'JESSICA HERNANDEZ', 'JESSICAH@Cobexa.com', 'DrnYh12TzqoewXkdtWiDmg==', 1, NULL, 0, 3, NULL, NULL, 3, '2017-11-10 06:27:42', 3, '2017-11-10 06:27:47', 1, NULL, '477 109 67 74', NULL, NULL, '2000-04-06'),
(8, 1, 'JONATHANM', 'JONATHAN MARTINEZ', 'JONATHANM@Cobexa.com', 'DrnYh12TzqoewXkdtWiDmg==', 1, NULL, 0, 3, NULL, NULL, 3, '2017-11-10 06:33:57', 3, '2017-11-10 06:34:40', 1, NULL, '477 475 55 63', NULL, NULL, '1996-06-11'),
(9, 1, 'GEORGINAC', 'GEORGINA CARRANCO', 'GEORGINAC@Cobexa.com', 'DrnYh12TzqoewXkdtWiDmg==', 1, NULL, 0, 3, NULL, NULL, 3, '2017-11-10 06:36:53', 3, '2017-11-10 06:36:53', 1, NULL, '477 629 31 64', NULL, NULL, '1976-05-19'),
(10, 1, 'jcelaya', 'Jaime Celaya H', 'jcelayah@yahoo.com', 'aCjB6zZI4Qmgwr6c2j5GpA==', 1, NULL, 0, 3, NULL, NULL, 3, '2017-11-13 06:45:42', 3, '2017-11-13 06:45:42', 1, 'fdsafdsaf', '12345654', 'Ninguna', 'Ninguna', '2017-11-12');

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ciudad`
--
ALTER TABLE `ciudad`
  ADD CONSTRAINT `R_24` FOREIGN KEY (`IdEstado`) REFERENCES `estado` (`IdEstado`);

--
-- Filtros para la tabla `colonia`
--
ALTER TABLE `colonia`
  ADD CONSTRAINT `R_25` FOREIGN KEY (`IdCiudad`) REFERENCES `ciudad` (`IdCiudad`);

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
