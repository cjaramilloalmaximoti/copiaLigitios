-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 28-04-2018 a las 15:07:51
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
-- Base de datos: `servicioadminempresa`
--
CREATE DATABASE IF NOT EXISTS `servicioadminempresa` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `servicioadminempresa`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `ActualizarCodigoSuperAdministrador`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarCodigoSuperAdministrador` (`pCodigoSuperAdministrador` VARCHAR(64), `pDominio` VARCHAR(64), `pRFC` VARCHAR(13))  BEGIN

	UPDATE empresa
    SET CodigoSuperAdministrador = CASE WHEN pCodigoSuperAdministrador= '' then null else pCodigoSuperAdministrador end
    WHERE Dominio 				= pDominio
			AND IFNULL(RFC, '') = pRFC;		
    
END$$

DROP PROCEDURE IF EXISTS `LimpiarCodigoSuperAdministrador`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `LimpiarCodigoSuperAdministrador` (`pCodigoSuperAdministrador` VARCHAR(64), `pDominio` VARCHAR(64), `pRFC` VARCHAR(13))  BEGIN
	
    IF EXISTS (
				select 1
                from	empresa
				WHERE Dominio 				= pDominio
						AND IFNULL(RFC, '') = pRFC
						AND CodigoSuperAdministrador = pCodigoSuperAdministrador
			  ) then
		UPDATE empresa
		SET CodigoSuperAdministrador = null
		WHERE Dominio 				= pDominio
				AND IFNULL(RFC, '') = pRFC
				AND CodigoSuperAdministrador = pCodigoSuperAdministrador;	
		SELECT 1 as Resultado;
    ELSE
		SELECT 0 as Resultado;
	END IF;
    
END$$

DROP PROCEDURE IF EXISTS `ObtenerParametros`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerParametros` ()  BEGIN
	
    SELECT
		IdParametro
		, Nombre
		, Descripcion
		, Valor
		, EsActivo
		, EsSensitivo
    FROM Parametro;

END$$

DROP PROCEDURE IF EXISTS `ReemplazarMVC`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReemplazarMVC` ()  BEGIN

	SELECT
		IdRemplazarMVC 
		, RealMVC
		, Reemplazar
    from reemplazarmvc;
    
END$$

DROP PROCEDURE IF EXISTS `ValidarEmpresa`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ValidarEmpresa` (`pDominio` VARCHAR(64), `pRFC` VARCHAR(13), `pOrigen` SMALLINT(6), `pUsuarios` SMALLINT(6), `pClientes` SMALLINT(6), `pNumeroRegistros` BIGINT(20))  BEGIN
    
    IF EXISTS (
		SELECT 
			1
        FROM 
			empresa
        WHERE 
			IFNULL(RFC, '')	= IFNULL(pRFC, '')
			AND Dominio 	= pDominio
            AND EsActivo 	= 1
            AND EsVigente 	= 1
            AND (
					(NumeroUsuarios >= pUsuarios)
                    AND
					(NumeroClientes >= pClientes)
                    AND
					(NumeroRegistros >= pNumeroRegistros)
				)
	) THEN
		SELECT
			CONCAT(Dominio, '|', IFNULL(RFC, ''), '|', '1-0', '|') as Valor  
            , 1 as Valido
        FROM 
			empresa 			
        WHERE 
			Dominio 	 	= pDominio
            AND EsActivo 	= 1
            AND EsVigente 	= 1;
    ELSE
		SELECT 
			IFNULL((
						SELECT
							CASE	WHEN EsActivo = 0 THEN '10'
									WHEN EsVigente = 0 THEN '20'
                                    WHEN NumeroUsuarios < pUsuarios THEN '30'
									WHEN NumeroClientes < pClientes THEN '40'
									WHEN NumeroRegistros < pNumeroRegistros THEN '50'
							END
						FROM 
							empresa
						WHERE 
							RFC 			= pRFC
							AND Dominio 	= pDominio
				  ), 'Otro') as Valor
			, 0 as Valido;
	END IF;
    
END$$

DROP PROCEDURE IF EXISTS `ValidarEmpresaSuperUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ValidarEmpresaSuperUsuario` (`pDominio` VARCHAR(64), `pRFC` VARCHAR(13))  BEGIN
    
	SELECT 
		CONCAT(Dominio, '|', IFNULL(RFC, ''), '|', '1-0', '|') as Valor  
	FROM 
		empresa
	WHERE 
		IFNULL(RFC, '')	= IFNULL(pRFC, '')
		AND Dominio 	= pDominio;
    
END$$

DROP PROCEDURE IF EXISTS `ValidarSuperUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ValidarSuperUsuario` (`pDominio` VARCHAR(64), `pLogin` VARCHAR(30), `pContrasenia` VARCHAR(250))  BEGIN

	SELECT (
		SELECT 
			Email
		FROM administrador
		WHERE
			Dominio 		= pDominio
			AND Login 		= pLogin
			AND Contraseña 	= pContrasenia) as Valor;
        
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `administrador`
--

DROP TABLE IF EXISTS `administrador`;
CREATE TABLE IF NOT EXISTS `administrador` (
  `IdAdministrador` int(11) NOT NULL AUTO_INCREMENT,
  `Dominio` varchar(64) NOT NULL,
  `Login` varchar(30) NOT NULL,
  `Contraseña` varchar(250) NOT NULL,
  `Email` varchar(64) NOT NULL,
  PRIMARY KEY (`IdAdministrador`),
  UNIQUE KEY `Login_UNIQUE` (`Login`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `administrador`
--

INSERT INTO `administrador` (`IdAdministrador`, `Dominio`, `Login`, `Contraseña`, `Email`) VALUES
(1, '@AlMaximoTI.com', 'SuperAdmin', '+8gNci97Kp/Rex0XrtGLlg==', 'alex1985jose@gmail.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresa`
--

DROP TABLE IF EXISTS `empresa`;
CREATE TABLE IF NOT EXISTS `empresa` (
  `IdEmpresa` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave primaria de la tabla, autoincrementable',
  `Dominio` varchar(64) NOT NULL COMMENT 'Es el dominio de la empresa, servirá para distinguir a un usuario de otras empresas. Este dominio deberá ser único',
  `RFC` varchar(13) DEFAULT NULL COMMENT 'Registro Federal de Contribuyentes',
  `Nombre` varchar(256) NOT NULL COMMENT 'Razón social de la empresa o cliente',
  `Representante_Nombre` varchar(64) NOT NULL COMMENT 'Nombre de la persona que fungirá como representante',
  `Representante_Email` varchar(64) NOT NULL COMMENT 'Cuenta de correo del representante',
  `Representante_Telefono` varchar(32) NOT NULL COMMENT 'Teléfono fijo del representante',
  `Representante_Movil` varchar(32) DEFAULT NULL COMMENT 'Teléfono celular del representante',
  `Observaciones` varchar(200) DEFAULT NULL COMMENT 'Información complementaria del representante, tal vez otro teléfono, otra cuenta de correo, información de su puesto, etc.',
  `OtroContacto_Nombre` varchar(64) NOT NULL COMMENT 'Nombre de la persona alterna al representante',
  `OtroContacto_Email` varchar(64) NOT NULL COMMENT 'Cuenta de correo de la persona alterna al representante',
  `OtroContacto_Telefono` varchar(32) NOT NULL COMMENT 'Teléfono fijo de la persona alterna al representante',
  `EsActivo` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Bandera que determina si la empresa se considera como un registro existente o como un registro borrado (lógicamente)',
  `EsVigente` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Bandera que determina si la empresa se considera vigente para usar la aplicación.',
  `NumeroUsuarios` smallint(6) NOT NULL COMMENT 'Numero de usuarios disponibles.',
  `NumeroClientes` smallint(6) NOT NULL COMMENT 'Numero de clientes disponibles.',
  `NumeroRegistros` bigint(20) NOT NULL DEFAULT '0',
  `CodigoSuperAdministrador` varchar(64) DEFAULT NULL,
  `ConexionRemota` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`IdEmpresa`),
  UNIQUE KEY `IX_Empresa` (`Dominio`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='La entidad Empresa representa a cada uno de nuestros clientes';

--
-- Volcado de datos para la tabla `empresa`
--

INSERT INTO `empresa` (`IdEmpresa`, `Dominio`, `RFC`, `Nombre`, `Representante_Nombre`, `Representante_Email`, `Representante_Telefono`, `Representante_Movil`, `Observaciones`, `OtroContacto_Nombre`, `OtroContacto_Email`, `OtroContacto_Telefono`, `EsActivo`, `EsVigente`, `NumeroUsuarios`, `NumeroClientes`, `NumeroRegistros`, `CodigoSuperAdministrador`, `ConexionRemota`) VALUES
(1, '@HumanFactor.com', 'RFCA010101', 'Human Factor SA', 'Jaime Celaya', 'jCelaya@gmail.com', '123', '', NULL, '1', '1', '1', 1, 1, 15, 15, 5, 'TQRL', NULL),
(2, '@gmail.com', 'RFCA010101ABC', 'Alex', 'Alejandro Gutierrez', 'alex@gmail.com', '123', '', NULL, '1', '1', '1', 1, 1, 15, 15, 5, NULL, NULL),
(3, '@Alex.com', 'GURL850319', 'Alex', 'Alejandro Gutierrez', 'alex@gmail.com', '123', '', NULL, '1', '1', '1', 1, 1, 15, 15, 5, NULL, NULL);

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
  `EsActivo` int(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'campo que nos dice un parametro esta activo o no activo',
  `EsSensitivo` int(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Campo que nos dice si es legible a simple vista o debe estar oculto',
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `OrigenOperacion` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  PRIMARY KEY (`IdParametro`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `parametro`
--

INSERT INTO `parametro` (`IdParametro`, `Nombre`, `Descripcion`, `Valor`, `EsActivo`, `EsSensitivo`, `IdUsuarioCreacion`, `FechaCreacion`, `IdUsuarioUltimoModifico`, `FechaModificacion`, `OrigenOperacion`) VALUES
(1, 'SMTP', 'Servidor con servicio SMTP para envio de correos eléctronicos', 'smtp.gmail.com', 1, 0, 1, '2017-04-10 20:05:13', 1, '2017-04-10 20:05:13', 1),
(2, 'Puerto', 'Puerto para el envio de correos s', '587', 1, 0, 1, '2017-04-10 20:05:13', 1, '2017-04-10 20:05:13', 1),
(3, 'Remitente', 'Remitente del email', 'ALMCorreoAutomatico@gmail.com', 1, 0, 1, '2017-04-10 20:05:13', 1, '2017-04-10 20:05:13', 1),
(4, 'Contrasenia', 'Contraseña del Correo', 'EnvioCorreo123$', 1, 0, 1, '2017-04-10 20:05:13', 1, '2017-04-10 20:05:13', 1),
(5, 'EmailCodigoSuperAdministrador', 'Cuerpo del correo que se envia al Generar CodigoSuperAdministrador', '<html xmlns:o><head></head><body>    <div align=\"center\">        <table height=\"90\" cellspacing=\"0\" cellpadding=\"0\" width=\"70%\" border=\"0\" id=\"tbTitulo\">  <tbody> <tr><td width=\"30%\" align=\"center\" height=\"90\"></td><td height=\"20\" width=\"430\"></td> </tr>  </tbody>        </table>        <table height=\"140\" cellspacing=\"0\" cellpadding=\"0\" width=\"70%\" border=\"0\" id=\"tbBody\" class=\"TxtContenido\">  <tbody> <tr><td valign=\"top\" width=\"*\" height=\"100\"><!--<FONT face=\"Arial\" size=\"2\"> <FONT color=\"#006699\" face=\"Arial\" size=\"2\">--><p class=\"MsoNormal\">    <br><span lang=\"ES-MX\" style=\"mso-ansi-language:ES-MX\"><o:p><b> Dominio:</b> %%Dominio%% </o:p></span></br>    <br><span lang=\"ES-MX\" style=\"mso-ansi-language:ES-MX\"><o:p><b> RFC:</b> %%RFC%%</o:p></span></br>    <br><span lang=\"ES-MX\" style=\"mso-ansi-language:ES-MX\"><o:p><b> CodigoSuperAdministrador:</b> %%Codigo%% </o:p></span></br></p><br><br></td> </tr>  </tbody>        </table>    </div></body></html>', 1, 0, 1, '2017-04-10 20:05:13', 1, '2017-04-10 20:05:13', 1),
(6, 'TituloCodigoSuperAdministrador', 'Es el titulo que lleva el correo que se envia cuando se asigna CodigoSuperAdministrador', 'Asignación Código Administrador', 1, 0, 1, '2017-04-10 20:05:13', 1, '2017-04-10 20:05:13', 1);

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
