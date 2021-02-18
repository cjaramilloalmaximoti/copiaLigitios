/*
Navicat MySQL Data Transfer

Source Server         : Local
Source Server Version : 50722
Source Host           : localhost:3306
Source Database       : reclutamiento

Target Server Type    : MYSQL
Target Server Version : 50722
File Encoding         : 65001

Date: 2018-06-25 16:07:36
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for bitacora
-- ----------------------------
DROP TABLE IF EXISTS `bitacora`;
CREATE TABLE `bitacora` (
  `IdBitacora` int(11) NOT NULL AUTO_INCREMENT,
  `IdProspecto` int(11) NOT NULL COMMENT 'Id del prospecto',
  `Comentario` varchar(250) NOT NULL COMMENT 'Cmentarios',
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IdBitacora`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for caracteristicas
-- ----------------------------
DROP TABLE IF EXISTS `caracteristicas`;
CREATE TABLE `caracteristicas` (
  `IdCaracteristica` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(200) NOT NULL,
  `Descripcion` varchar(200) NOT NULL,
  `IdTipoControl` int(11) NOT NULL DEFAULT '1',
  `Aprobada` int(11) NOT NULL,
  `Comentario` varchar(250) NOT NULL DEFAULT ' ',
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `IdUsuarioModificacion` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `IdEmpresa` int(11) NOT NULL,
  `EsActivo` tinyint(1) NOT NULL,
  `codigoGenerado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`IdCaracteristica`)
) ENGINE=MyISAM AUTO_INCREMENT=208 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for caracteristica_categoria
-- ----------------------------
DROP TABLE IF EXISTS `caracteristica_categoria`;
CREATE TABLE `caracteristica_categoria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idcaracteristica` int(11) NOT NULL,
  `idcategoria` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idcaracteristica` (`idcaracteristica`),
  KEY `idcategoria` (`idcategoria`)
) ENGINE=MyISAM AUTO_INCREMENT=185 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for catalogo
-- ----------------------------
DROP TABLE IF EXISTS `catalogo`;
CREATE TABLE `catalogo` (
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
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for catalogosgenerales
-- ----------------------------
DROP TABLE IF EXISTS `catalogosgenerales`;
CREATE TABLE `catalogosgenerales` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(250) NOT NULL,
  `Descripcion` varchar(500) NOT NULL,
  `Estatus` tinyint(1) NOT NULL,
  `IdForma` int(11) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaUltimaModificacion` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Nombre` (`Nombre`,`IdForma`),
  KEY `IdForma` (`IdForma`),
  KEY `IdUsuarioCreacion` (`IdUsuarioCreacion`),
  KEY `IdUsuarioUltimoModifico` (`IdUsuarioUltimoModifico`),
  CONSTRAINT `catalogosgenerales_ibfk_1` FOREIGN KEY (`IdForma`) REFERENCES `formas` (`Id`),
  CONSTRAINT `catalogosgenerales_ibfk_2` FOREIGN KEY (`IdUsuarioCreacion`) REFERENCES `usuarios` (`Id`),
  CONSTRAINT `catalogosgenerales_ibfk_3` FOREIGN KEY (`IdUsuarioUltimoModifico`) REFERENCES `usuarios` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for categoria
-- ----------------------------
DROP TABLE IF EXISTS `categoria`;
CREATE TABLE `categoria` (
  `IdCategoria` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) DEFAULT NULL,
  `FechaCreacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioCreacion` int(11) DEFAULT NULL,
  `FechaModificacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioUltimoModifico` int(11) DEFAULT NULL,
  `Estatus` tinyint(4) DEFAULT NULL,
  `IdEmpresa` int(11) DEFAULT NULL,
  PRIMARY KEY (`IdCategoria`),
  UNIQUE KEY `IdCategoria_UNIQUE` (`IdCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=237 DEFAULT CHARSET=utf8 COMMENT='IdCategoria';

-- ----------------------------
-- Table structure for ciudad
-- ----------------------------
DROP TABLE IF EXISTS `ciudad`;
CREATE TABLE `ciudad` (
  `Clave_Ciudad` varchar(10) NOT NULL,
  `Nombre` varchar(512) NOT NULL,
  `Clave_Estado` varchar(10) NOT NULL,
  `Clave_Pais` varchar(10) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Clave_Ciudad`,`Clave_Estado`,`Clave_Pais`),
  KEY `R_24` (`Clave_Estado`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cliente
-- ----------------------------
DROP TABLE IF EXISTS `cliente`;
CREATE TABLE `cliente` (
  `IdCliente` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave primaria de la tabla, autoincrementable',
  `IdEmpresa` int(11) NOT NULL COMMENT 'Identificador de la empresa a la que pertenece el resgistro',
  `RFC` varchar(13) NOT NULL COMMENT ': Registro Federal de Contribuyente del Cliente, sirve como clave del cliente.',
  `RazonSocial` varchar(96) NOT NULL COMMENT 'Nombre formal del cliente',
  `NombreComercial` varchar(64) DEFAULT NULL COMMENT 'Nombre con el que se identifica claramente al cliente sin ser tan largo o formal como la Razón Social pero más descriptivo que el RFC',
  `Clave_Colonia` varchar(10) NOT NULL,
  `CP` varchar(10) NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for clientedocumentos
-- ----------------------------
DROP TABLE IF EXISTS `clientedocumentos`;
CREATE TABLE `clientedocumentos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IdCliente` int(11) NOT NULL,
  `IdDocumento` int(11) NOT NULL,
  `Nombre` varchar(150) NOT NULL,
  `Url` varchar(150) NOT NULL,
  `Estatus` tinyint(4) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `IdUsuarioModificacion` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Idempresa` int(11) NOT NULL,
  `NombreOriginal` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for colonia
-- ----------------------------
DROP TABLE IF EXISTS `colonia`;
CREATE TABLE `colonia` (
  `Clave_Colonia` varchar(10) NOT NULL,
  `Nombre` varchar(512) NOT NULL,
  `CodigoPostal` varchar(10) NOT NULL,
  `Clave_Pais` varchar(10) NOT NULL,
  `Clave_Estado` varchar(10) NOT NULL,
  `Clave_Ciudad` varchar(10) NOT NULL,
  `Clave_Asentamiento` varchar(10) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Clave_Colonia`,`Clave_Ciudad`,`Clave_Estado`,`Clave_Pais`),
  KEY `R_25` (`Clave_Ciudad`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for empresa
-- ----------------------------
DROP TABLE IF EXISTS `empresa`;
CREATE TABLE `empresa` (
  `IdEmpresa` int(11) NOT NULL COMMENT 'Llave primaria de la tabla, autoincrementable',
  `Dominio` varchar(64) NOT NULL COMMENT 'Es el dominio de la empresa, servirá para distinguir a un usuario de otras empresas. Este dominio deberá ser único',
  `ProductKey` varchar(256) NOT NULL COMMENT 'Razón social de la empresa o cliente',
  `Administrador` varchar(30) NOT NULL,
  `Contrasenia` varchar(250) NOT NULL,
  `NombreComercial` varchar(100) NOT NULL,
  `RutaLogo` varchar(200) DEFAULT NULL,
  `Email` varchar(200) NOT NULL,
  PRIMARY KEY (`IdEmpresa`),
  UNIQUE KEY `IX_Empresa` (`Dominio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='La entidad Empresa representa a cada uno de nuestros clientes';

-- ----------------------------
-- Table structure for estado
-- ----------------------------
DROP TABLE IF EXISTS `estado`;
CREATE TABLE `estado` (
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

-- ----------------------------
-- Table structure for forma
-- ----------------------------
DROP TABLE IF EXISTS `forma`;
CREATE TABLE `forma` (
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
  `OrigenOperacion` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Descripcion` varchar(256) CHARACTER SET utf8mb4 DEFAULT NULL,
  `IdEmpresa` int(11) NOT NULL,
  `EsSuperAdministrador` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdForma`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for formapermiso
-- ----------------------------
DROP TABLE IF EXISTS `formapermiso`;
CREATE TABLE `formapermiso` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IdForma` int(11) NOT NULL,
  `IdPermiso` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IdForma` (`IdForma`,`IdPermiso`),
  KEY `IdPermiso` (`IdPermiso`),
  KEY `IdUsuarioCreacion` (`IdUsuarioCreacion`),
  CONSTRAINT `formapermiso_ibfk_1` FOREIGN KEY (`IdForma`) REFERENCES `formas` (`Id`),
  CONSTRAINT `formapermiso_ibfk_2` FOREIGN KEY (`IdPermiso`) REFERENCES `permisos` (`Id`),
  CONSTRAINT `formapermiso_ibfk_3` FOREIGN KEY (`IdUsuarioCreacion`) REFERENCES `usuarios` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for historicocargacp
-- ----------------------------
DROP TABLE IF EXISTS `historicocargacp`;
CREATE TABLE `historicocargacp` (
  `idHistorico` int(11) NOT NULL AUTO_INCREMENT,
  `Clave_Pais` varchar(10) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idHistorico`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for nacionalidad
-- ----------------------------
DROP TABLE IF EXISTS `nacionalidad`;
CREATE TABLE `nacionalidad` (
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
  KEY `R_60` (`IdUsuarioUltimoModifico`) USING BTREE,
  CONSTRAINT `R_54` FOREIGN KEY (`IdUsuarioCreacion`) REFERENCES `usuario` (`IdUsuario`),
  CONSTRAINT `R_60` FOREIGN KEY (`IdUsuarioUltimoModifico`) REFERENCES `usuario` (`IdUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for pais
-- ----------------------------
DROP TABLE IF EXISTS `pais`;
CREATE TABLE `pais` (
  `Clave_Pais` varchar(10) NOT NULL,
  `Nombre` varchar(512) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Clave_Pais`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for parametro
-- ----------------------------
DROP TABLE IF EXISTS `parametro`;
CREATE TABLE `parametro` (
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
  `OrigenOperacion` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `IdEmpresa` int(11) NOT NULL,
  PRIMARY KEY (`IdParametro`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for parametroempresa
-- ----------------------------
DROP TABLE IF EXISTS `parametroempresa`;
CREATE TABLE `parametroempresa` (
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
  `OrigenOperacion` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`IdParametro`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for parametroscaracteresinvalidos
-- ----------------------------
DROP TABLE IF EXISTS `parametroscaracteresinvalidos`;
CREATE TABLE `parametroscaracteresinvalidos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CaracterInvalido` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for parametrostiposdefault
-- ----------------------------
DROP TABLE IF EXISTS `parametrostiposdefault`;
CREATE TABLE `parametrostiposdefault` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `DataType` varchar(100) NOT NULL,
  `IdTipoCelda` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_TB_BI_Reportes_TiposDefault_TB_BI_Reportes_TiposCelda` (`IdTipoCelda`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for parametrotiposcelda
-- ----------------------------
DROP TABLE IF EXISTS `parametrotiposcelda`;
CREATE TABLE `parametrotiposcelda` (
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

-- ----------------------------
-- Table structure for permiso
-- ----------------------------
DROP TABLE IF EXISTS `permiso`;
CREATE TABLE `permiso` (
  `IdPermiso` int(11) NOT NULL AUTO_INCREMENT,
  `Permiso` varchar(16) NOT NULL,
  `Privilegio` bigint(20) NOT NULL,
  `Estatus` tinyint(1) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `OrigenOperacion` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `IdEmpresa` int(11) NOT NULL,
  PRIMARY KEY (`IdPermiso`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for prospecto
-- ----------------------------
DROP TABLE IF EXISTS `prospecto`;
CREATE TABLE `prospecto` (
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
  `Clave_Colonia` varchar(10) NOT NULL,
  `CP` varchar(10) NOT NULL,
  `IdEstadoCivil` int(11) DEFAULT NULL,
  `IdEscolaridad` int(11) DEFAULT NULL,
  `IdUsuarioCreacion` int(11) DEFAULT NULL,
  `FechaCreacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioUltimoModifico` int(11) DEFAULT NULL,
  `FechaModificacion` timestamp NULL DEFAULT NULL,
  `Estatus` tinyint(1) DEFAULT '1',
  `Comentario` varchar(250) DEFAULT NULL,
  `NivelIngles` varchar(50) DEFAULT NULL,
  `IdEmpresa` int(11) DEFAULT NULL,
  `foto` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IdProspecto`),
  KEY `IdProspecto` (`IdProspecto`)
) ENGINE=MyISAM AUTO_INCREMENT=50 DEFAULT CHARSET=latin1 COMMENT='tabla para guarar prospectos';

-- ----------------------------
-- Table structure for prospectocaracteristica
-- ----------------------------
DROP TABLE IF EXISTS `prospectocaracteristica`;
CREATE TABLE `prospectocaracteristica` (
  `IdProspectoCaracteristica` int(11) NOT NULL AUTO_INCREMENT,
  `IdProspecto` int(11) NOT NULL,
  `IdCaracteristicaParticular` int(11) NOT NULL,
  `Valor` varchar(1024) NOT NULL,
  PRIMARY KEY (`IdProspectoCaracteristica`),
  UNIQUE KEY `IdProspectoCaracteristica_UNIQUE` (`IdProspectoCaracteristica`),
  KEY `FK_ProspectoCaracteristica_idx` (`IdProspecto`),
  KEY `FK_ProspectoCaracteristica_CaractParticular_idx` (`IdCaracteristicaParticular`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for prospectodocumentos
-- ----------------------------
DROP TABLE IF EXISTS `prospectodocumentos`;
CREATE TABLE `prospectodocumentos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IdProspecto` int(11) NOT NULL,
  `IdDocumento` int(11) NOT NULL,
  `Nombre` varchar(150) NOT NULL,
  `Url` varchar(150) NOT NULL,
  `Estatus` tinyint(4) NOT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `IdUsuarioModificacion` int(11) NOT NULL,
  `FechaModificacion` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Idempresa` int(11) NOT NULL,
  `NombreOriginal` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for reemplazarmvc
-- ----------------------------
DROP TABLE IF EXISTS `reemplazarmvc`;
CREATE TABLE `reemplazarmvc` (
  `IdRemplazarMVC` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Campo autoincrementable',
  `RealMVC` varchar(45) NOT NULL COMMENT 'Caracter original no permitido en URL de MVC',
  `Reemplazar` varchar(45) NOT NULL COMMENT 'Caracter a reemplazar',
  PRIMARY KEY (`IdRemplazarMVC`),
  UNIQUE KEY `IdRemplazarMVC_UNIQUE` (`IdRemplazarMVC`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Tabla que contiene informacion de caráceres especiales no permitidos en URL de MVC, y se reemplaza por el configurado';

-- ----------------------------
-- Table structure for referencialaboral
-- ----------------------------
DROP TABLE IF EXISTS `referencialaboral`;
CREATE TABLE `referencialaboral` (
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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for registroscript
-- ----------------------------
DROP TABLE IF EXISTS `registroscript`;
CREATE TABLE `registroscript` (
  `IdRegistroScript` int(11) NOT NULL AUTO_INCREMENT,
  `NumeroScript` int(11) NOT NULL,
  `NombreScript` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `NombreQuienRealizo` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `DescripcionScript` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`IdRegistroScript`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `IdRol` int(11) NOT NULL AUTO_INCREMENT,
  `NombreRol` varchar(50) DEFAULT NULL,
  `Estatus` tinyint(1) NOT NULL DEFAULT '0',
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `OrigenOperacion` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `IdEmpresa` int(11) NOT NULL,
  PRIMARY KEY (`IdRol`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for rolusuario
-- ----------------------------
DROP TABLE IF EXISTS `rolusuario`;
CREATE TABLE `rolusuario` (
  `IdRolUsuario` int(11) NOT NULL AUTO_INCREMENT,
  `IdUsuario` int(11) DEFAULT NULL,
  `IdRol` int(11) DEFAULT NULL,
  `IdUsuarioCreacion` int(11) NOT NULL DEFAULT '1',
  `FechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioUltimoModifico` int(11) NOT NULL DEFAULT '1',
  `FechaModificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `OrigenOperacion` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `IdEmpresa` int(11) NOT NULL,
  PRIMARY KEY (`IdRolUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for subcatalogo
-- ----------------------------
DROP TABLE IF EXISTS `subcatalogo`;
CREATE TABLE `subcatalogo` (
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

-- ----------------------------
-- Table structure for tipoasentamiento
-- ----------------------------
DROP TABLE IF EXISTS `tipoasentamiento`;
CREATE TABLE `tipoasentamiento` (
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

-- ----------------------------
-- Table structure for tipocatalogo
-- ----------------------------
DROP TABLE IF EXISTS `tipocatalogo`;
CREATE TABLE `tipocatalogo` (
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tipocontrol
-- ----------------------------
DROP TABLE IF EXISTS `tipocontrol`;
CREATE TABLE `tipocontrol` (
  `IdTipoControl` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `Orden` smallint(10) NOT NULL,
  `FormatoControl` varchar(50) DEFAULT NULL,
  `NumeroDecimales` int(11) DEFAULT NULL,
  `Requerido` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`IdTipoControl`),
  UNIQUE KEY `idTipoControl_UNIQUE` (`IdTipoControl`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for usuario
-- ----------------------------
DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario` (
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
  `OrigenOperacion` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Domicilio` varchar(250) DEFAULT NULL,
  `Telefono` varchar(32) DEFAULT '',
  `Referencia` varchar(100) DEFAULT NULL,
  `ReferenciaTelefono` varchar(32) DEFAULT NULL,
  `FechaNacimiento` date DEFAULT NULL,
  PRIMARY KEY (`IdUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for vacante
-- ----------------------------
DROP TABLE IF EXISTS `vacante`;
CREATE TABLE `vacante` (
  `IdVacante` int(11) NOT NULL AUTO_INCREMENT,
  `Titulo` varchar(100) DEFAULT NULL,
  `Descripcion` varchar(100) DEFAULT NULL,
  `FechaContratacion` date DEFAULT NULL,
  `NumeroVacantes` int(11) DEFAULT NULL,
  `Salario` double DEFAULT NULL,
  `IdTipoContrato` int(11) DEFAULT NULL,
  `IdTipoJornada` int(11) DEFAULT NULL,
  `IdCiudad` varchar(20) DEFAULT NULL,
  `IdUsuarioCreacion` int(11) DEFAULT NULL,
  `FechaCreacion` timestamp NULL DEFAULT NULL,
  `IdUsuarioUltimoModifico` int(11) DEFAULT NULL,
  `FechaModificacion` timestamp NULL DEFAULT NULL,
  `Estatus` tinyint(4) DEFAULT NULL,
  `IdEmpresa` int(11) DEFAULT NULL,
  `Comentarios` varchar(300) DEFAULT NULL,
  `Fase` int(11) DEFAULT '0',
  `FechaEntrega` date DEFAULT NULL,
  `SubTitulo` varchar(100) DEFAULT NULL,
  `IdCliente` int(11) DEFAULT NULL,
  `IdFuentePublicacion` int(11) DEFAULT NULL,
  PRIMARY KEY (`IdVacante`),
  KEY `IdVacante` (`IdVacante`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COMMENT='tabla para guarar vacantes									';

-- ----------------------------
-- Table structure for vacantecaracteristica
-- ----------------------------
DROP TABLE IF EXISTS `vacantecaracteristica`;
CREATE TABLE `vacantecaracteristica` (
  `IdVacanteCaracteristica` int(11) NOT NULL AUTO_INCREMENT,
  `IdVacante` int(11) DEFAULT NULL,
  `IdCaracteristicaParticular` int(11) DEFAULT NULL,
  `Valor` varchar(1024) NOT NULL,
  PRIMARY KEY (`IdVacanteCaracteristica`),
  UNIQUE KEY `IdVacanteCaracteristica_UNIQUE` (`IdVacanteCaracteristica`),
  KEY `FK_VacanteCaracteristica_idx` (`IdVacante`),
  KEY `FK_VacanteCaracteristica_CaractParticular_idx` (`IdCaracteristicaParticular`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for vacante_fuente
-- ----------------------------
DROP TABLE IF EXISTS `vacante_fuente`;
CREATE TABLE `vacante_fuente` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idvacante` int(11) NOT NULL,
  `idfuente` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idvacante` (`idvacante`),
  KEY `idfuente` (`idfuente`)
) ENGINE=MyISAM AUTO_INCREMENT=232 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for vacante_prospecto
-- ----------------------------
DROP TABLE IF EXISTS `vacante_prospecto`;
CREATE TABLE `vacante_prospecto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idvacante` int(11) NOT NULL,
  `idProspecto` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idvacante` (`idvacante`),
  KEY `idProspecto` (`idProspecto`)
) ENGINE=MyISAM AUTO_INCREMENT=272 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for x
-- ----------------------------
DROP TABLE IF EXISTS `x`;
CREATE TABLE `x` (
  `doc` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Procedure structure for ActCaracteristicas
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActCaracteristicas`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCaracteristicas`(
  
  IN `pIdEmpresa` INT, 
  
  IN `pIdCaracteristica` INT, 
  
  IN `pNombre` VARCHAR(200), 
  
  IN `pDescripcion` VARCHAR(200), 
  
  IN `pIdTipoControl` INT, 
  
  IN `pAprobada` TINYINT(1), 
  
  IN `pComentario` VARCHAR(250), 
 
  IN `pIdUsuarioLog` INT, 
  
  IN `pEsActivo` TINYINT(1),
  
  in `pDetalles` MEDIUMTEXT

)
BEGIN
  START TRANSACTION;

    SET autocommit = 0;

    UPDATE caracteristicas

    SET 
      Nombre = pNombre,

      Descripcion = pDescripcion,

      IdTipoControl = pIdTipoControl,

      Aprobada = pAprobada,

      Comentario = IFNULL(pComentario,''),

      IdUsuarioModificacion = pIdUsuarioLog,

      FechaModificacion = now(),

      EsActivo = pEsActivo

    WHERE 
      IdCaracteristica = pIdCaracteristica;
      -- and IdEmpresa = pIdEmpresa;


      /* Eliminar los registros Detalles*/

        delete from caracteristica_categoria where idCaracteristica = pIdCaracteristica;


      /* Iniciar a insertar en tabla detalles  */

      -- set @sql = replace(pDetalles, 'idValor', pIdCaracteristica) ;

      set @sql = pDetalles;

      prepare stmt1 from @sql;

      execute stmt1;

      SELECT null as ErrorMessage;
COMMIT;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActCatalogo
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActCatalogo`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCatalogo`(`pClave` VARCHAR(12), `pIdUsuarioLog` INT, `pIdCatalogo` INT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(256), `pIdTipoCatalogo` SMALLINT, `pEsActivo` TINYINT, `pIdEmpresa` INT)
BEGIN
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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActCategoria
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActCategoria`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCategoria`(IN `pIdCategoria` INT(11), IN `pNombre` VARCHAR(100), IN `pIdUsuarioUltimoModifico` INT(11), IN `pEstatus` TINYINT(4), IN `pIdEmpresa` INT(11))
BEGIN
UPDATE categoria
SET 
		categoria.Nombre =pNombre,
		categoria.IdUsuarioUltimoModifico= pIdUsuarioUltimoModifico,
		categoria.Estatus = pEstatus,
		categoria.IdEmpresa = pIdEmpresa
WHERE 
		categoria.IdCategoria= pIdCategoria;

SELECT NULL AS ErrorMessage;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActCliente
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActCliente`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActCliente`(IN `pIdCliente` INT, IN `pIdEmpresa` INT, IN `pRFC` VARCHAR(13), IN `pRazonSocial` VARCHAR(96), IN `pNombreComercial` VARCHAR(64), IN `pDireccion` VARCHAR(250), IN `pContacto_Nombre` VARCHAR(64), IN `pContacto_Email` VARCHAR(64), IN `pContacto_Telefono` VARCHAR(32), IN `pComentarios` VARCHAR(128), IN `pEstatus` TINYINT(1), IN `pIdUsuarioLog` INT, IN `pEmpresaCorreo` VARCHAR(64), IN `pEmpresaTelefono` VARCHAR(64), IN `pClaveColonia` VARCHAR(10), IN `pCP` VARCHAR(10))
BEGIN
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
            Clave_Colonia = pClaveColonia,
            CP = pCP,
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
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActEmpresa
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActEmpresa`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActEmpresa`(IN `pIdEmpresa` INT(11), IN `pDominio` VARCHAR(64), IN `pProductKey` VARCHAR(256), IN `pAdministrador` VARCHAR(30), IN `pContrasenia` VARCHAR(250), IN `pNombreComercial` VARCHAR(100), IN `pRutaLogo` VARCHAR(200))
BEGIN

	UPDATE empresa
	SET
		Dominio = pDominio,
		ProductKey = pProductKey,
		Administrador = pAdministrador,
		Contrasenia = pContrasenia,
        NombreComercial = pNombreComercial,
        RutaLogo = pRutaLogo
	WHERE IdEmpresa = pIdEmpresa;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActFormaPermiso
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActFormaPermiso`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActFormaPermiso`(`pIdForma` INT(11), `pIdPermiso` INT(11), `pIdEmpresa` INT(11), `pIdUsuarioLog` INT(11), `pNombrePermiso` VARCHAR(50))
BEGIN
	
    UPDATE formapermiso
    SET NombrePermiso = pNombrePermiso   
        , IdUsuarioUltimoModifico = pIdUsuarioLog
        , FechaModificacion = NOW()
    WHERE 
		IdForma = pIdForma
        AND IdPermiso = pIdPermiso
        ANd IdEmpresa = pIdEmpresa;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActParametro
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActParametro`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActParametro`(`pIdParametro` SMALLINT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(10000), `pValor` VARCHAR(10000), `pEsActivo` BIT, `pEsSensitivo` BIT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pIdEmpresa` INT)
BEGIN

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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActParametroEmpresa
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActParametroEmpresa`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActParametroEmpresa`(`pIdParametro` SMALLINT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(10000), `pValor` VARCHAR(10000), `pEsActivo` BIT, `pEsSensitivo` BIT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT)
BEGIN

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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActProspecto
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActProspecto`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActProspecto`(IN `pIdProspecto` INT, IN `pNombre` VARCHAR(100), IN `pApellidos` VARCHAR(100), IN `pFechaNacimiento` TIMESTAMP, IN `pRFC` VARCHAR(13), IN `pEmail` VARCHAR(100), IN `pTelefonoMovil` VARCHAR(10), IN `pTelefonoOtro` VARCHAR(10), IN `pIdSexo` INT, IN `pDireccion` VARCHAR(250), IN `pSalario` DOUBLE, IN `pIdEstadoCivil` INT, IN `pIdEscolaridad` INT, IN `pIdUsuarioLog` INT, IN `pEstatus` TINYINT(1), IN `pIdEmpresa` INT, IN `pClaveColonia` VARCHAR(10), IN `pCP` VARCHAR(10), IN `pComentario` VARCHAR(250), IN `pNivelIngles` VARCHAR(50), IN `pFoto` VARCHAR(50))
BEGIN 
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
      Clave_Colonia = pClaveColonia,
      CP = pCP,
	  Direccion = pDireccion,
	  Salario = pSalario,
	  IdEstadoCivil = pIdEstadoCivil,
	  IdEscolaridad = pIdEscolaridad,
	  IdUsuarioUltimoModifico = pIdUsuarioLog,
	  FechaModificacion = now(),
	  Estatus = pEstatus,
      NivelIngles = pNivelIngles,
	  Comentario = pComentario,
      foto = ifnull(concat(pFoto), '')
	WHERE IdProspecto = pIdProspecto
		  and IdEmpresa = pIdEmpresa;
        
        SELECT null as ErrorMessage;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActReferenciaLaboral
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActReferenciaLaboral`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActReferenciaLaboral`(IN `pIdreferencia` INT, IN `pIdProspecto` INT, IN `pEmpresa` VARCHAR(150), IN `pDomicilio` VARCHAR(150), IN `pContacto` VARCHAR(100), IN `pContacto_Email` VARCHAR(64), IN `pContacto_Telefono` VARCHAR(32), IN `pMotivoSeparacion` VARCHAR(150), IN `pPuesto` VARCHAR(150), IN `pTiempoLaborado` VARCHAR(128), IN `pComentario` VARCHAR(128), IN `pEstatus` TINYINT(1), IN `pIdUsuarioLog` INT, IN `pIdEmpresa` INT)
BEGIN
  DECLARE pId INT;
  
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
		Comentario = ifnull(pComentario, ''),
		Estatus = pEstatus,
		IdUsuarioUltimoModifico = pIdUsuarioLog,
		FechaModificacion = now(),
		IdEmpresa = pIdEmpresa
	WHERE
		IdReferencia = pIdReferencia;
        
	set pId = pIdReferencia;
    SELECT null as ErrorMessage, pId as Id;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActRol
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActRol`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActRol`(`pIdRol` INT, `pNombreRol` VARCHAR(50), `pEstatus` INT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pIdEmpresa` INT)
BEGIN

	UPDATE Roles
		SET NombreRol = pNombreRol
			, Estatus = pEstatus
			, FechaModificacion = now()
			, IdUsuarioUltimoModifico = pIdUsuarioLog
			, OrigenOperacion = pOrigenOperacion
		WHERE IdRol = pIdRol
        AND IdEmpresa = pIdEmpresa;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActSubCatalogo
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActSubCatalogo`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActSubCatalogo`(`pClave` VARCHAR(12), `pIdUsuarioLog` INT, `pIdSubCatalogo` INT, `pIdCatalogo` INT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(256), `pIdTipoCatalogo` SMALLINT, `pIdEmpresa` INT, `pEsActivo` TINYINT(1))
BEGIN
	
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
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActUsuario
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActUsuario`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActUsuario`(`pIdUsuario` INT, `pLogin` VARCHAR(250), `pNombreCompleto` VARCHAR(250), `pCorreoElectronico` VARCHAR(250), `pContrasenia` VARCHAR(100), `pActivo` INT, `pComentarios` VARCHAR(512), `pUltimoModifico` INT, `pIdInstitucion` INT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pIdEmpresa` INT, `pDomicilio` VARCHAR(250), `pTelefono` VARCHAR(32), `pReferencia` VARCHAR(100), `pReferenciaTelefono` VARCHAR(32), `pFechaNacimiento` DATE)
BEGIN

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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActUsuarioConstrasenia
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActUsuarioConstrasenia`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActUsuarioConstrasenia`(`pIdUsuario` INT, `pContrasenia` NVARCHAR(64), `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pIdEmpresa` INT)
BEGIN
	
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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActUsuarioRecuperarContrasenia
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActUsuarioRecuperarContrasenia`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActUsuarioRecuperarContrasenia`(`peMail` VARCHAR(64), `pCodigoRecuperacion` VARCHAR(32), `pOrigenOperacion` INT, `pIdEmpresa` INT)
BEGIN

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
    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ActVacante
-- ----------------------------
DROP PROCEDURE IF EXISTS `ActVacante`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActVacante`(IN `pIdVacante` INT, IN `pTitulo` VARCHAR(100),IN `pSubTitulo` VARCHAR(100), IN `pDescripcion` VARCHAR(100), IN `pFechaContratacion` DATE, IN `pNumeroVacantes` INT(11), IN `pSalario` DOUBLE, IN `pIdTipoContrato` INT(11), IN `pIdCliente` INT(11), IN `pIdTipoJornada` INT(11), IN `pIdCiudad` VARCHAR(20), IN `pIdUsuarioUltimoModifico` INT(11), IN `pEstatus` TINYINT(4), IN `pComentarios` VARCHAR(300), IN `pIdEmpresa` INT(11), IN `pFase` VARCHAR(90), IN `pFechaEntrega` DATE
, in `pDetalles` MEDIUMTEXT)
BEGIN
START TRANSACTION;
	

  IF(
    SELECT COUNT(1)
 
    FROM reclutamiento.vacante
 
    WHERE vacante.Titulo= pTitulo
 
      AND vacante.SubTitulo=pSubTitulo

			AND vacante.descripcion=pDescripcion
 
      AND vacante.FechaContratacion = pFechaContratacion
 
      AND vacante.NumeroVacantes=pNumeroVacantes

      AND vacante.Salario=pSalario
			
      AND vacante.IdTipoContrato=pIdTipoContrato

			AND vacante.IdCliente=pIdCliente
			
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
			  vacante.SubTitulo=pSubTitulo,
        vacante.Descripcion=pDescripcion,
	vacante.FechaContratacion=pFechaContratacion,
	vacante.NumeroVacantes=pNumeroVacantes,
	vacante.Salario=pSalario,
	vacante.IdTipoContrato=pIdTipoContrato,
	vacante.IdCliente=pIdCliente,
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

/* Eliminar los registros Detalles*/

        delete from vacante_fuente where idvacante = pIdVacante;


      /* Iniciar a insertar en tabla detalles  */

      -- set @sql = replace(pDetalles, 'idValor', pIdCaracteristica) ;

      set @sql = pDetalles;

      prepare stmt1 from @sql;

      execute stmt1;

      SELECT null as ErrorMessage;

COMMIT;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for AprobarRechazarCaracteristica
-- ----------------------------
DROP PROCEDURE IF EXISTS `AprobarRechazarCaracteristica`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AprobarRechazarCaracteristica`(IN `pAprobada` INT, IN `pComentario` VARCHAR(250), IN `pId` INT)
BEGIN
	UPDATE caracteristicas set Aprobada = pAprobada, codigoGenerado = '', Comentario = pComentario
	WHERE IdCaracteristica = pId;
    
    SELECT null as ErrorMessage;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for EliDocsCliente
-- ----------------------------
DROP PROCEDURE IF EXISTS `EliDocsCliente`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliDocsCliente`(IN `pId` INT)
BEGIN	
	declare pIdCD INT;
    
	DELETE FROM clientedocumentos
	WHERE ( Id = pId ) ;
	
    set pIdCD = 1;
    SELECT null as ErrorMessage;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for EliDocsProspecto
-- ----------------------------
DROP PROCEDURE IF EXISTS `EliDocsProspecto`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliDocsProspecto`(IN `pId` INT)
BEGIN	
	declare pIdCD INT;
    
	DELETE FROM prospectodocumentos
	WHERE ( Id = pId ) ;
	
    set pIdCD = 1;
    SELECT null as ErrorMessage;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for EliProspectoCaracteristica
-- ----------------------------
DROP PROCEDURE IF EXISTS `EliProspectoCaracteristica`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliProspectoCaracteristica`(
	`pIdProspectoCaracteristica` INT
)
BEGIN
	
    DELETE from prospectocaracteristica where IdProspectoCaracteristica = pIdProspectoCaracteristica;
    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for EliRol
-- ----------------------------
DROP PROCEDURE IF EXISTS `EliRol`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliRol`(`pIdRol` INT, `pIdEmpresa` INT)
BEGIN

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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for EliRolUsuario
-- ----------------------------
DROP PROCEDURE IF EXISTS `EliRolUsuario`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliRolUsuario`(`pIdUsuario` INT, `pIdRol` INT, `pIdEmpresa` INT)
BEGIN

	delete from RolUsuario
	where IdUsuario = pIdUsuario
		  AND IdRol = pIdRol
          AND IdEmpresa = pIdEmpresa; 					
    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for EliUsuario
-- ----------------------------
DROP PROCEDURE IF EXISTS `EliUsuario`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliUsuario`(`pIdUsuario` INT, `pIdEmpresa` INT)
BEGIN

	DELETE from Usuario where IdUsuario = pIdUsuario AND IdEmpresa = pIdEmpresa;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for EliVacanteCaracteristica
-- ----------------------------
DROP PROCEDURE IF EXISTS `EliVacanteCaracteristica`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliVacanteCaracteristica`(
	`pIdVacanteCaracteristica` INT
)
BEGIN
	
    DELETE from vacantecaracteristica where IdVacanteCaracteristica = pIdVacanteCaracteristica;
    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsAliasEstatus
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsAliasEstatus`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsAliasEstatus`(`pIdEmpresa` INT, `pIdCartera` INT, `pIdTipoGestion` INT, `pIdEstatus` INT, `pAlias` VARCHAR(64), `pIdUsuarioLog` INT)
BEGIN

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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsBitacora
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsBitacora`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsBitacora`(IN `pIdProspecto` INT, IN `pComentario` VARCHAR(250), IN `pIdUsuarioLog` INT)
BEGIN
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
        
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsCaracteristicas
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsCaracteristicas`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCaracteristicas`(IN `pIdEmpresa` INT, IN `pNombre` VARCHAR(200), IN `pDescripcion` VARCHAR(200), IN `pIdTipoControl` INT, IN `pAprobada` TINYINT(1), IN `pComentario` VARCHAR(250), IN `pIdUsuarioLog` INT, IN `pCodigoGenerado` VARCHAR(10), IN `pDetalles` VARCHAR(250))
BEGIN
	DECLARE pIdCaracteristica INT;
   
	/*Manejo error SQL Exception*/ 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN 
		SELECT 1 as error; 
	ROLLBACK; 
	END; 

	/*Manejo Warning SQL	*/ 
	DECLARE EXIT HANDLER FOR SQLWARNING 
	BEGIN 
		SELECT 1 as error; 
	ROLLBACK; 
	END; 

	START TRANSACTION;
    SET autocommit = 0;
    
		IF (SELECT COUNT(1)
			from caracteristicas 
			where	Nombre = pNombre 
					AND IdEmpresa = pIdEmpresa) != 0 THEN
			SELECT 'Error al insertar: La caracteristica ya esta siendo utilizado.' as ErrorMessage;
		ELSE
		
		INSERT INTO caracteristicas
		(
			Nombre,
			Descripcion,
			IdTipoControl,
			Aprobada,
			Comentario,
			IdUsuarioCreacion,
			FechaCreacion,
			IdUsuarioModificacion,
			FechaModificacion,
			IdEmpresa,
			EsActivo,
            CodigoGenerado
		)
		VALUES
		(
			pNombre,
			pDescripcion,
			pIdTipoControl,
			pAprobada,
			IFNULL(pComentario, ''),
			pIdUsuarioLog,
			now(),
			pIdUsuarioLog,
			now(),
			pIdEmpresa,
			1,
            pCodigoGenerado
		);
        
		set pIdCaracteristica = (SELECT MAX(IdCaracteristica) from caracteristicas);
		SELECT null as ErrorMessage, pIdCaracteristica as IdCaracteristica;
        
        /* Iniciar a insertar en tabla detalles  */
        set @sql = replace(pDetalles, 'idValor', pIdCaracteristica) ;
        
            prepare stmt1 from @sql;
            execute stmt1; 
        
		END IF;
    COMMIT;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsCatalogo
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsCatalogo`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCatalogo`(`pClave` VARCHAR(12), `pIdUsuarioLog` INT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(256), `pIdTipoCatalogo` SMALLINT, `pIdEmpresa` INT)
BEGIN
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
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsCategoria
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsCategoria`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCategoria`(IN `pNombre` VARCHAR(100), IN `pIdUsuarioCreacion` INT(11), IN `pEstatus` TINYINT(4), IN `pIdEmpresa` INT(11))
BEGIN

	DECLARE pidCategoria INT(11);

	IF (SELECT COUNT(1)
			FROM reclutamiento.categoria
			WHERE 
				categoria.Nombre=pNombre
				AND categoria.IdEmpresa= pIdEmpresa
				AND categoria.Estatus=pEstatus
		)!=0 THEN 
			SELECT 'Error al insertar: La categoria que intenta guardar ya esta siendo utilizada o no tiene cambios .' as ErrorMessage;
		
	ELSE 
		INSERT INTO reclutamiento.categoria
			(
				categoria.Nombre,
				categoria.FechaCreacion,
				categoria.IdUsuarioCreacion,
				categoria.FechaModificacion,

				categoria.IdUsuarioUltimoModifico,
				categoria.Estatus,
				categoria.IdEmpresa
			)	
			VALUES 
			(
				pNombre,
				NOW(),
				pIdUsuarioCreacion,
				NOW(),
				pIdUsuarioCreacion,
				pEstatus, 
				pIdEmpresa
			);

			SET pidCategoria= (SELECT MAX(IdCategoria) FROM reclutamiento.categoria);
			SELECT  NULL AS ErrorMessage, pidCategoria as IdCategoria;

		END IF ;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsCiudades
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsCiudades`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCiudades`(IN `pCiudades` MEDIUMTEXT)
BEGIN

 set @sql = pCiudades;
            prepare stmt1 from @sql;
            execute stmt1; 

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsCliente
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsCliente`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsCliente`(IN `pIdEmpresa` INT, IN `pRFC` VARCHAR(13), IN `pRazonSocial` VARCHAR(96), IN `pNombreComercial` VARCHAR(64), IN `pDireccion` VARCHAR(250), IN `pContacto_Nombre` VARCHAR(64), IN `pContacto_Email` VARCHAR(64), IN `pContacto_Telefono` VARCHAR(32), IN `pComentarios` VARCHAR(128), IN `pEstatus` TINYINT(1), IN `pIdUsuarioLog` INT, IN `pEmpresaCorreo` VARCHAR(64), IN `pEmpresaTelefono` VARCHAR(64), IN `pClaveColonia` VARCHAR(10), IN `pCP` VARCHAR(10))
BEGIN
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
        Clave_Colonia,
        CP,
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
        pClaveColonia,
        pCP,
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
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsColonias
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsColonias`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsColonias`(IN `pColonias` MEDIUMTEXT)
BEGIN
 set @sql = pColonias;
            prepare stmt1 from @sql;
            execute stmt1;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsDocsCliente
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsDocsCliente`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsDocsCliente`(IN `pIdCliente` INT, IN `pIdDocumento` INT, IN `pNombre` VARCHAR(150), IN `pUrl` VARCHAR(250), IN `pEstatus` TINYINT, IN `pIdUsuarioLog` INT, IN `pIdEmpresa` INT, IN `pNombreOriginal` VARCHAR(150))
BEGIN 
  DECLARE pId INT; 
  DECLARE pValidacion INT;
  
  SET pValidacion = (
						SELECT 
							count(1) 
						FROM 
							clientedocumentos
						WHERE
							IdEmpresa = pIdEmpresa
                            and IdCliente = pIdCliente
                            and IdDocumento = pIdDocumento
					);

  if pValidacion = 0 then
  begin
	  INSERT INTO clientedocumentos ( 
		IdCliente, IdDocumento, Nombre, Url, Estatus, IdUsuarioCreacion, FechaCreacion,
		IdUsuarioModificacion, FechaModificacion, IdEmpresa, NombreOriginal
	  ) VALUES ( 
		pIdCliente, pIdDocumento, pNombre, pUrl, pEstatus, PIdUsuarioLog, now(), 
		pIdUsuarioLog, now(), pIdEmpresa, pNombreOriginal
	  ); 
  end;
  else
  begin
	UPDATE clientedocumentos
	SET
		Nombre = pNombre
        , Url = pUrl
        , Estatus = pEstatus
        , IdUsuarioModificacion = PIdUsuarioLog
        , FechaModificacion = now()
        , NombreOriginal = pNombreOriginal
	WHERE
		IdEmpresa = pIdEmpresa
		and IdCliente = pIdCliente
		and IdDocumento = pIdDocumento; 
  end;
  end if;

  set pId = 1; 
  SELECT null as ErrorMessage, pIdDocumento as Id; 
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsDocsProspecto
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsDocsProspecto`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsDocsProspecto`(IN `pIdProspecto` INT, IN `pIdDocumento` INT, IN `pNombre` VARCHAR(150), IN `pUrl` VARCHAR(250), IN `pEstatus` TINYINT, IN `pIdUsuarioLog` INT, IN `pIdEmpresa` INT, IN `pNombreOriginal` VARCHAR(150))
BEGIN 
  DECLARE pId INT; 
  DECLARE pValidacion INT;
  
  SET pValidacion = (
						SELECT 
							count(1) 
						FROM 
							prospectodocumentos
						WHERE
							IdEmpresa = pIdEmpresa
                            and IdProspecto = pIdProspecto
                            and IdDocumento = pIdDocumento
					);
                    
  if pValidacion = 0 then
  begin
	  INSERT INTO prospectodocumentos ( 
		IdProspecto, IdDocumento, Nombre, Url, Estatus, IdUsuarioCreacion, FechaCreacion,
		IdUsuarioModificacion, FechaModificacion, IdEmpresa, NombreOriginal
	  ) VALUES ( 
		pIdProspecto, pIdDocumento, pNombre, pUrl, pEstatus, PIdUsuarioLog, now(), 
		pIdUsuarioLog, now(), pIdEmpresa, pNombreOriginal
	  ); 
  end;
  else
  begin
	UPDATE prospectodocumentos
	SET
		Nombre = pNombre
        , Url = pUrl
        , Estatus = pEstatus
        , IdUsuarioModificacion = PIdUsuarioLog
        , FechaModificacion = now()
        , NombreOriginal = pNombreOriginal
	WHERE
		IdEmpresa = pIdEmpresa
		and IdProspecto = pIdProspecto
		and IdDocumento = pIdDocumento; 
  end;
  end if;

  set pId = 1; 
  SELECT null as ErrorMessage, pIdDocumento as Id; 
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsEliRolUsuario
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsEliRolUsuario`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsEliRolUsuario`(`pIdRol` INT, `pIdUsuario` INT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pEstatus` INT, `pIdEmpresa` INT)
BEGIN

	IF pEstatus = 1 THEN
		IF NOT EXISTS (SELECT 1 FROM RolUsuario WHERE IdUsuario = pIdUsuario and IdRol = pIdRol AND IdEmpresa = pIdEmpresa) THEN
			INSERT INTO RolUsuario ( IdUsuario, IdRol, IdUsuarioCreacion ,IdUsuarioUltimoModifico, FechaCreacion, FechaModificacion, OrigenOperacion, IdEmpresa)
            VALUES
            (pIdUsuario, pIdRol, pIdUsuarioLog, pIdUsuarioLog, NOW(), NOW(), pOrigenOperacion, pIdEmpresa); 
		END IF;
    ELSE
		DELETE FROM RolUsuario WHERE IdUsuario = pIdUsuario and IdRol = pIdRol AND IdEmpresa = pIdEmpresa;
    END IF;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsEstados
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsEstados`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsEstados`(IN `pEstados` TEXT)
BEGIN
            set @sql = pEstados;
            prepare stmt1 from @sql;
            execute stmt1; 
     
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsFechaUltimaCarga
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsFechaUltimaCarga`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsFechaUltimaCarga`(IN `pPais` VARCHAR(10), IN `pIdUsuario` INT)
BEGIN
 
 insert into historicocargacp (Clave_Pais, IdUsuarioCreacion) values (pPais,pIdUsuario);

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsFormaRol
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsFormaRol`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsFormaRol`(`pIdForma` INT, `pIdRol` INT, `pPrivilegio` INT, `pIdEmpresa` INT)
BEGIN

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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsProspecto
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsProspecto`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsProspecto`(IN `pIdProspecto` INT, IN `pNombre` VARCHAR(100), IN `pApellidos` VARCHAR(100), IN `pFechaNacimiento` TIMESTAMP, IN `pRFC` VARCHAR(13), IN `pEmail` VARCHAR(100), IN `pTelefonoMovil` VARCHAR(10), IN `pTelefonoOtro` VARCHAR(10), IN `pIdSexo` INT, IN `pDireccion` VARCHAR(250), IN `pSalario` DOUBLE, IN `pIdEstadoCivil` INT, IN `pIdEscolaridad` INT, IN `pIdUsuarioLog` INT, IN `pEstatus` TINYINT(1), IN `pIdEmpresa` INT, IN `pClaveColonia` VARCHAR(10), IN `pCP` VARCHAR(10), IN `pComentario` VARCHAR(250), IN `pNivelIngles` VARCHAR(50), IN `pFoto` VARCHAR(50))
BEGIN 
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
      Clave_Colonia,
      CP,
	  Direccion,
	  Salario,
	  IdEstadoCivil,
	  IdEscolaridad,
	  IdUsuarioCreacion,
	  FechaCreacion,
	  IdUsuarioUltimoModifico,
	  FechaModificacion,
	  Estatus,
	  Comentario,
      NivelIngles,
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
      pClaveColonia,
      pCP,
	  pDireccion,
	  pSalario,
	  pIdEstadoCivil,
	  pIdEscolaridad,
	  pIdUsuarioLog,
	  now(),
      pIdUsuarioLog,
	  now(),
	  pEstatus,
	  pComentario,
      pNivelIngles,
	  pIdEmpresa
      );
      
      set pIdProspecto = (SELECT MAX(IdProspecto) from prospecto);
      
      update prospecto set foto = ifnull(concat(pIdProspecto, pFoto), '') where idProspecto = pIdProspecto;
      
      SELECT null as ErrorMessage, pIdProspecto as IdProspecto;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsProspectoCaracteristica
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsProspectoCaracteristica`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsProspectoCaracteristica`(
	pIdProspecto INT
    , pIdCaracteristicaParticular INT
    , pValor varchar(1024)
)
BEGIN
	
    if not exists(
					select 1 
                    from 
						prospectocaracteristica 
					where 
						IdProspecto = pIdProspecto 
                        and IdCaracteristicaParticular = pIdCaracteristicaParticular
				 ) then
	begin    
		INSERT INTO prospectocaracteristica
				( IdProspecto
				 , IdCaracteristicaParticular
				 , Valor
				)
		VALUES  (
				 pIdProspecto
				 , pIdCaracteristicaParticular
				 , pValor
				);
	end;
    else
    begin
		UPDATE prospectocaracteristica
        SET Valor = pValor
        WHERE
			IdProspecto = pIdProspecto 
			and IdCaracteristicaParticular = pIdCaracteristicaParticular;
    end;
	end if;

    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsReferenciaLaboral
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsReferenciaLaboral`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsReferenciaLaboral`(IN `pIdProspecto` INT, IN `pEmpresa` VARCHAR(150), IN `pDomicilio` VARCHAR(150), IN `pContacto` VARCHAR(100), IN `pContacto_Email` VARCHAR(64), IN `pContacto_Telefono` VARCHAR(32), IN `pMotivoSeparacion` VARCHAR(150), IN `pPuesto` VARCHAR(150), IN `pTiempoLaborado` VARCHAR(128), IN `pComentario` VARCHAR(128), IN `pEstatus` TINYINT(1), IN `pIdUsuarioLog` INT, IN `pIdEmpresa` INT)
BEGIN
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
		ifnull(pComentario, ''),
		pEstatus,
		pIdUsuarioLog,
		now(),
		pIdUsuarioLog,
		now(),
		pIdEmpresa
	);
        
	set pIdReferencia = (SELECT MAX(IdReferencia) from referencialaboral);
        SELECT null as ErrorMessage, pIdReferencia as IdReferencia;
        
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsRol
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsRol`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsRol`(`pNombreRol` VARCHAR(50), `pIdUsuarioLog` INT, `pOrigenOperacion` TINYINT(3), `pIdEmpresa` INT)
BEGIN
	
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
                
        
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsRolUsuario
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsRolUsuario`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsRolUsuario`(`pIdUsuario` INT, `pIdRol` INT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pIdEmpresa` INT)
BEGIN

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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsSubCatalogo
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsSubCatalogo`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsSubCatalogo`(`pClave` VARCHAR(12), `pIdUsuarioLog` INT, `pIdCatalogo` INT, `pNombre` VARCHAR(64), `pDescripcion` VARCHAR(256), `pIdTipoCatalogo` SMALLINT, `pIdEmpresa` INT)
BEGIN
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
    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsTipoAsentamientos
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsTipoAsentamientos`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsTipoAsentamientos`(IN `pTipoAsentamiento` MEDIUMTEXT)
BEGIN

 set @sql = pTipoAsentamiento;
            prepare stmt1 from @sql;
            execute stmt1; 

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsUsuario
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsUsuario`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsUsuario`(`pLogin` VARCHAR(250), `pNombreCompleto` VARCHAR(250), `pCorreoElectronico` VARCHAR(250), `pContrasenia` VARCHAR(100), `pActivo` INT, `pComentarios` VARCHAR(512), `pUltimoModifico` INT, `pIdInstitucion` INT, `pIdUsuarioLog` INT, `pOrigenOperacion` INT, `pIdEmpresa` INT, `pDomicilio` VARCHAR(250), `pTelefono` VARCHAR(32), `pReferencia` VARCHAR(100), `pReferenciaTelefono` VARCHAR(32), `pFechaNacimiento` DATE)
BEGIN
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
    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsVacante
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsVacante`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante`(IN `pTitulo` VARCHAR(100),IN `pSubTitulo` VARCHAR(100), IN `pDescripcion` VARCHAR(100), IN `pFechaContratacion` TIMESTAMP, IN `pNumeroVacantes` INT(11), IN `pSalario` DOUBLE, IN `pIdTipoContrato` INT(11), IN `pIdCliente` INT(11), IN `pIdTipoJornada` INT(11), IN `pIdCiudad` VARCHAR(20), IN `pIdUsuarioCreacion` INT(11), IN `pIdUsuarioUltimoModifico` INT(11), IN `pEstatus` TINYINT(4), IN `pComentarios` VARCHAR(300), IN `pIdEmpresa` INT(11), IN `pFase` INT(11),
 IN `pFechaEntrega` DATETIME, in `pDetalles` MEDIUMTEXT)
BEGIN

DECLARE pIdVacante int;
		INSERT INTO reclutamiento.vacante 
		(
			vacante.Titulo,
			vacante.SubTitulo,
			vacante.Descripcion,
			vacante.FechaContratacion,
			vacante.NumeroVacantes,
			vacante.Salario, 
			vacante.IdTipoContrato,
			vacante.IdCliente,
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
			pSubTitulo,
			pDescripcion,
			pFechaContratacion,
			pNumeroVacantes,
			pSalario, 
			pIdTipoContrato,
			pIdCliente,
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
        
        /* Iniciar a insertar en tabla detalles  */
        set @sql = replace(pDetalles, 'idValor', pIdVacante) ;
        
            prepare stmt1 from @sql;
            execute stmt1; 

	
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsVacanteCaracteristica
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsVacanteCaracteristica`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacanteCaracteristica`(
	pIdVacante INT
    , pIdCaracteristicaParticular INT
    , pValor varchar(1024)
)
BEGIN
	
    if not exists(
					select 1 
                    from 
						vacantecaracteristica 
					where 
						IdVacante = pIdVacante 
                        and IdCaracteristicaParticular = pIdCaracteristicaParticular
				 ) then
	begin    
		INSERT INTO vacantecaracteristica
				( IdVacante
				 , IdCaracteristicaParticular
				 , Valor
				)
		VALUES  (
				 pIdVacante
				 , pIdCaracteristicaParticular
				 , pValor
				);
	end;
    else
    begin
		UPDATE vacantecaracteristica
        SET Valor = pValor
        WHERE
			IdVacante = pIdVacante 
			and IdCaracteristicaParticular = pIdCaracteristicaParticular;
    end;
	end if;

    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for InsVacante_Prospecto
-- ----------------------------
DROP PROCEDURE IF EXISTS `InsVacante_Prospecto`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsVacante_Prospecto`(IN `pIdVacante` INT,
	IN `pDetalles` MEDIUMTEXT)
BEGIN
	START TRANSACTION ; 
	CREATE TEMPORARY TABLE IF NOT EXISTS vacante_prospecto_tmp AS (SELECT * FROM vacante_prospecto WHERE idvacante = pIdVacante);
	-- DELETE FROM vacante_prospecto WHERE idvacante = pIdVacante; 
	
SET @SQL = pDetalles; 
PREPARE stmt1 FROM @SQL; 
EXECUTE stmt1; 

-- INSERT INTO vacante_prospecto SELECT * FROM vacante_prospecto_tmp WHERE IdVacante = pIdVacante AND IdProspecto NOT IN (SELECT IdProspecto FROM vacante_prospecto WHERE idvacante = pIdVacante);

SELECT NULL AS ErrorMessage; 
COMMIT;
	END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtBitacora
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtBitacora`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtBitacora`(IN `pIdProspecto` INT)
BEGIN
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
	b.IdProspecto = pIdProspecto
	ORDER BY b.idBitacora desc;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCaracteristicaParticular
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCaracteristicaParticular`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicaParticular`(IN `pIdEmpresa` INT(11), IN `pEstatus` TINYINT(4))
BEGIN
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
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCaracteristicas
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCaracteristicas`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicas`(IN `pCaracteristica` MEDIUMTEXT)
BEGIN
  set @sql = pCaracteristica;

  prepare stmt1 from @sql;
  execute stmt1;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCaracteristicasPorCategoria
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCaracteristicasPorCategoria`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasPorCategoria`(
	pIdsCategorias varchar(8000)
    , pIdEmpresa INT
    , pIdProspecto INT
)
BEGIN 
  
	create temporary table pT_Categorias( IdCategoria int );
    
    if  IFNULL(pIdsCategorias, '') != '' then
    begin
		set @sql = concat("insert into pT_Categorias (IdCategoria) values ('", replace((pIdsCategorias), ",", "'),('"),"');");
		prepare stmt1 from @sql;
		execute stmt1;
        
        SELECT
			-- cat.IdCategoria,
			caract.IdCaracteristica as IdCaracteristicaParticular
			-- , cat.Nombre as Categoria
			, caract.Nombre as Caracteristica
			, tipControl.Nombre as Control
			, tipControl.FormatoControl
			, tipControl.NumeroDecimales
			, tipControl.Requerido
			, valor.Valor                
		FROM
			caracteristicas caract
			inner join 
				caracteristica_categoria carac_cat
			on
				carac_cat.idcaracteristica = caract.idcaracteristica
			inner join 
				categoria cat
			on
				cat.IdCategoria = carac_cat.IdCategoria
				-- and cat.IdEmpresa = pIdEmpresa
				and cat.Estatus = 1
			inner join 
				pT_Categorias caractFiltro
			on
				caractFiltro.IdCategoria = cat.IdCategoria
			inner join 
				tipocontrol tipControl
			on
				tipControl.IdTipoControl = caract.IdTipoControl
			left join 
				prospectocaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdProspecto= pIdProspecto
		WHERE
			-- caract.IdEmpresa = pIdEmpresa
			caract.EsActivo = 1
			and caract.Aprobada = 1
		group by
			caract.IdCaracteristica
		ORDER BY
			 -- cat.Nombre
			 -- , 
             tipControl.Orden
			 , caract.Nombre;
        
    end;
    else
    begin
		SELECT
			-- cat.IdCategoria,
			caract.IdCaracteristica as IdCaracteristicaParticular
			-- , cat.Nombre as Categoria
			, caract.Nombre as Caracteristica
			, tipControl.Nombre as Control
			, tipControl.FormatoControl
			, tipControl.NumeroDecimales
			, tipControl.Requerido
			, valor.Valor                
		FROM
			caracteristicas caract
			inner join 
				caracteristica_categoria carac_cat
			on
				carac_cat.idcaracteristica = caract.idcaracteristica
			inner join 
				categoria cat
			on
				cat.IdCategoria = carac_cat.IdCategoria
				-- and cat.IdEmpresa = pIdEmpresa
				and cat.Estatus = 1
			inner join 
				tipocontrol tipControl
			on
				tipControl.IdTipoControl = caract.IdTipoControl
			left join 
				prospectocaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdProspecto= pIdProspecto
		WHERE
			-- caract.IdEmpresa = pIdEmpresa
			caract.EsActivo = 1
			and caract.Aprobada = 1
		group by
			caract.IdCaracteristica
		ORDER BY
			 -- cat.Nombre
			 -- , 
             tipControl.Orden
			 , caract.Nombre;
    end;
    end if;
    
    DROP TEMPORARY TABLE pT_Categorias;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCaracteristicasPorProspecto
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCaracteristicasPorProspecto`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasPorProspecto`(
    pIdEmpresa INT
    , pIdProspecto INT
)
BEGIN

		SELECT
			-- cat.IdCategoria,
			valor.IdProspectoCaracteristica
            ,caract.IdCaracteristica as IdCaracteristicaParticular
			-- , cat.Nombre as Categoria
			, caract.Nombre as Caracteristica
			, tipControl.Nombre as Control
			, tipControl.FormatoControl
			, tipControl.NumeroDecimales
			, tipControl.Requerido
            , valor.Valor
			, case 	when tipControl.Nombre = 'Dicotómico' and valor.Valor = 'true' then 'Si'
					when tipControl.Nombre = 'Dicotómico' and valor.Valor != 'true' then 'No'
					else valor.Valor
			  end as ValorColumna
		FROM
			caracteristicas caract
			inner join 
				caracteristica_categoria carac_cat
			on
				carac_cat.idcaracteristica = caract.idcaracteristica
			inner join 
				categoria cat
			on
				cat.IdCategoria = carac_cat.IdCategoria
				-- and cat.IdEmpresa = pIdEmpresa
				and cat.Estatus = 1
			inner join 
				tipocontrol tipControl
			on
				tipControl.IdTipoControl = caract.IdTipoControl
			inner join 
				prospectocaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdProspecto= pIdProspecto
		WHERE
			-- caract.IdEmpresa = pIdEmpresa
			caract.EsActivo = 1
			and caract.Aprobada = 1
		group by
			caract.IdCaracteristica
		ORDER BY
			 -- cat.Nombre
			 -- , 
             tipControl.Orden
			 , caract.Nombre;
    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCaracteristicasPorVacante
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCaracteristicasPorVacante`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasPorVacante`(
    pIdEmpresa INT
    , pIdVacante INT
)
BEGIN

		SELECT
			-- cat.IdCategoria,
			valor.IdVacanteCaracteristica as IdProspectoCaracteristica
            ,caract.IdCaracteristica as IdCaracteristicaParticular
			-- , cat.Nombre as Categoria
			, caract.Nombre as Caracteristica
			, tipControl.Nombre as Control
			, tipControl.FormatoControl
			, tipControl.NumeroDecimales
			, tipControl.Requerido
            , valor.Valor
			, case 	when tipControl.Nombre = 'Dicotómico' and valor.Valor = 'true' then 'Si'
					when tipControl.Nombre = 'Dicotómico' and valor.Valor != 'true' then 'No'
					else valor.Valor
			  end as ValorColumna
		FROM
			caracteristicas caract
			inner join 
				caracteristica_categoria carac_cat
			on
				carac_cat.idcaracteristica = caract.idcaracteristica
			inner join 
				categoria cat
			on
				cat.IdCategoria = carac_cat.IdCategoria
				-- and cat.IdEmpresa = pIdEmpresa
				and cat.Estatus = 1
			inner join 
				tipocontrol tipControl
			on
				tipControl.IdTipoControl = caract.IdTipoControl
			inner join 
				vacantecaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdVacante= pIdVacante
		WHERE
			-- caract.IdEmpresa = pIdEmpresa
			caract.EsActivo = 1
			and caract.Aprobada = 1
		group by
			caract.IdCaracteristica
		ORDER BY
			 -- cat.Nombre
			 -- , 
             tipControl.Orden
			 , caract.Nombre;
    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCaracteristicasVacantePorCategoria
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCaracteristicasVacantePorCategoria`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCaracteristicasVacantePorCategoria`(
	pIdsCategorias varchar(8000)
    , pIdEmpresa INT
    , pIdVacante INT
)
BEGIN 
  
	create temporary table pT_Categorias( IdCategoria int );
    
    if  IFNULL(pIdsCategorias, '') != '' then
    begin
		set @sql = concat("insert into pT_Categorias (IdCategoria) values ('", replace((pIdsCategorias), ",", "'),('"),"');");
		prepare stmt1 from @sql;
		execute stmt1;
        
        SELECT
			-- cat.IdCategoria,
			caract.IdCaracteristica as IdCaracteristicaParticular
			-- , cat.Nombre as Categoria
			, caract.Nombre as Caracteristica
			, tipControl.Nombre as Control
			, tipControl.FormatoControl
			, tipControl.NumeroDecimales
			, tipControl.Requerido
			, valor.Valor                
		FROM
			caracteristicas caract
			inner join 
				caracteristica_categoria carac_cat
			on
				carac_cat.idcaracteristica = caract.idcaracteristica
			inner join 
				categoria cat
			on
				cat.IdCategoria = carac_cat.IdCategoria
				-- and cat.IdEmpresa = pIdEmpresa
				and cat.Estatus = 1
			inner join 
				pT_Categorias caractFiltro
			on
				caractFiltro.IdCategoria = cat.IdCategoria
			inner join 
				tipocontrol tipControl
			on
				tipControl.IdTipoControl = caract.IdTipoControl
			left join 
				vacantecaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdVacante= pIdVacante
		WHERE
			-- caract.IdEmpresa = pIdEmpresa
			caract.EsActivo = 1
			and caract.Aprobada = 1
		group by
			caract.IdCaracteristica
		ORDER BY
			 -- cat.Nombre
			 -- , 
             tipControl.Orden
			 , caract.Nombre;
        
    end;
    else
    begin
		SELECT
			-- cat.IdCategoria,
			caract.IdCaracteristica as IdCaracteristicaParticular
			-- , cat.Nombre as Categoria
			, caract.Nombre as Caracteristica
			, tipControl.Nombre as Control
			, tipControl.FormatoControl
			, tipControl.NumeroDecimales
			, tipControl.Requerido
			, valor.Valor                
		FROM
			caracteristicas caract
			inner join 
				caracteristica_categoria carac_cat
			on
				carac_cat.idcaracteristica = caract.idcaracteristica
			inner join 
				categoria cat
			on
				cat.IdCategoria = carac_cat.IdCategoria
				-- and cat.IdEmpresa = pIdEmpresa
				and cat.Estatus = 1
			inner join 
				tipocontrol tipControl
			on
				tipControl.IdTipoControl = caract.IdTipoControl
			left join 
				vacantecaracteristica valor
			on
				valor.IdCaracteristicaParticular = caract.idcaracteristica
				and valor.IdVacante= pIdVacante
		WHERE
			-- caract.IdEmpresa = pIdEmpresa
			caract.EsActivo = 1
			and caract.Aprobada = 1
		group by
			caract.IdCaracteristica
		ORDER BY
			 -- cat.Nombre
			 -- , 
             tipControl.Orden
			 , caract.Nombre;
    end;
    end if;
    
    DROP TEMPORARY TABLE pT_Categorias;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCatalogo
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCatalogo`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCatalogo`(`pidTipoCatalogo` INT, `pNombreCatalogo` VARCHAR(64), `pEsActivo` INT, `pIdEmpresa` INT)
BEGIN
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
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCatalogoCtrlCaracteristica
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCatalogoCtrlCaracteristica`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCatalogoCtrlCaracteristica`(
	`pIdCaracteristicaParticular` INT
    , `pIdEmpresa` INT
)
BEGIN
	
    select 'Nulo' as IdReferencia, 'Nulo' as Nombre 
    union
    select 'Mínimo' as IdReferencia, 'Mínimo' as Nombre 
    union
    select 'Regular' as IdReferencia, 'Regular' as Nombre 
    union
    select 'Alto' as IdReferencia, 'Alto' as Nombre 
    union
    select 'Avanzado' as IdReferencia, 'Avanzado' as Nombre;

    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCatalogoDelSubCatalogo
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCatalogoDelSubCatalogo`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCatalogoDelSubCatalogo`(`pIdCatalogo` INT, `pIdEmpresa` INT)
BEGIN
	
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
    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCatalogoPorNombre
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCatalogoPorNombre`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCatalogoPorNombre`(`pCatalogo` VARCHAR(100), `pIdEmpresa` INT)
BEGIN
	SELECT 
		cat.IdCatalogo
		, cat.Nombre
		, cat.EsActivo
	FROM Catalogo cat
	inner join TipoCatalogo tipo on tipo.IdTipoCatalogo = cat.IdTipoCatalogo 
	where tipo.Nombre = replace(pCatalogo, '_', ' ')
		and cat.IdEmpresa = pIdEmpresa;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCatalogosCaracteristicas
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCatalogosCaracteristicas`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCatalogosCaracteristicas`(IN `pNombreCatalogo` VARCHAR(100), IN `pIdEmpresa` INT)
BEGIN
SELECT 
	*
FROM 
	catalogo

WHERE 
	IdTipoCatalogo = (Select IdTipoCatalogo From TipoCatalogo Where NombreSingular = pNombreCatalogo)
	AND EsActivo = 1;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCatalogosDelSubCatalogo
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCatalogosDelSubCatalogo`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCatalogosDelSubCatalogo`(`pIdCatalogo` INT)
BEGIN

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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCategorias
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCategorias`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCategorias`(IN `pNombre` VARCHAR(100), IN `pIdEmpresa` INT(11), IN `pEstatus` TINYINT)
BEGIN
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
				categoria.Idcategoria,
				categoria.Nombre,
				categoria.Estatus,
				categoria.FechaCreacion
		FROM 
				reclutamiento.categoria
		WHERE 
                ( categoria.Nombre like concat('%', IFNULL(pNombre, ''), '%')) 
				AND categoria.Estatus between pDesde and pHasta;
                -- AND categoria.IdEmpresa = pIdEmpresa;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCategoriasTipo
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCategoriasTipo`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCategoriasTipo`(IN `pIdEmpresa` INT(11))
BEGIN
SELECT 
	categoria.IdCategoria,
	categoria.Nombre
FROM  
	reclutamiento.categoria
WHERE      
	categoria.IdEmpresa=pIdEmpresa
AND 
	categoria.Estatus=1;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCiudades
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCiudades`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCiudades`(IN `pClaveEstado` VARCHAR(512), IN `pNombre` VARCHAR(512), IN `pActivo` INT)
BEGIN
SELECT Clave_Ciudad
      ,Nombre
FROM ciudad
WHERE Nombre like concat('%', IFNULL(pNombre, ''), '%') 
	AND Clave_Estado = pClaveEstado
	AND Estatus = pActivo
ORDER BY Nombre ASC;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCiudadTexto
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCiudadTexto`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCiudadTexto`(IN `pClaveCiudad` VARCHAR(3), IN `pClaveEstado` VARCHAR(3))
BEGIN

		SELECT 
			ciudad.nombre
		FROM 
			reclutamiento.ciudad
		WHERE 
			ciudad.Clave_Ciudad= pClaveCiudad AND ciudad.Clave_Estado= pClaveEstado;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtClienteId
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtClienteId`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClienteId`(IN `pIdCliente` INT)
BEGIN
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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtClientes
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtClientes`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtClientes`(IN `pRazonSocial` VARCHAR(96), IN `pEstatus` TINYINT, IN `pIdEmpresa` INT)
BEGIN
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
	   cliente.IdCliente,
	   cliente.IdEmpresa,
	   cliente.RFC,
	   cliente.RazonSocial,
	   cliente.NombreComercial,
	   cliente.Clave_Colonia,
	   cliente.CP,
	   cliente.Direccion,
       cliente.EmpresaCorreo,
       cliente.EmpresaTelefono,
	   cliente.Contacto_Nombre,
	   cliente.Contacto_Email,
	   cliente.Contacto_Telefono,
	   cliente.Comentarios,
	   cliente.Estatus,
	   colonia.Nombre as NombreColonia
	FROM cliente left join colonia on 
		( cliente.Clave_Colonia = colonia.Clave_colonia
			AND cliente.CP = Colonia.CodigoPostal
		)
	WHERE ( 
	      ( cliente.RazonSocial like concat('%', IFNULL(pRazonSocial, ''), '%')) 
          OR (cliente.NombreComercial like concat('%', IFNULL(pRazonSocial, ''), '%')) 
          OR (cliente.RFC like concat('%', IFNULL(pRazonSocial, ''), '%')) 
          )
		AND cliente.Estatus between pDesde and pHasta
		AND cliente.IdEmpresa = pIdEmpresa;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtColonias
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtColonias`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtColonias`(IN `pClaveCiudad` VARCHAR(512), IN `pClaveEstado` VARCHAR(512), IN `pNombre` VARCHAR(512), IN `pActivo` INT)
BEGIN
SELECT Clave_Colonia
      , Nombre
      , CodigoPostal
FROM colonia
WHERE Nombre like concat('%', IFNULL(pNombre, ''), '%') 
	AND Clave_Ciudad = pClaveCiudad
	AND Clave_Estado = pClaveEstado
	AND Estatus = pActivo
ORDER BY Nombre ASC;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtCP
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtCP`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtCP`(IN `pCP` VARCHAR(512))
BEGIN
  SELECT
    col.Clave_Colonia
    , CONCAT(col.Clave_Estado,'|',est.Nombre) as Clave_Estado
    , CONCAT(col.Clave_Ciudad,'|',ciu.Nombre) as Clave_Ciudad
    , col.Nombre
    , col.CodigoPostal
  FROM 
    colonia col inner join estado est on col.Clave_Estado = est.Clave_Estado
		inner join ciudad ciu on (col.Clave_Ciudad = ciu.Clave_Ciudad 
			and col.Clave_Estado = ciu.Clave_Estado )
  WHERE
    col.CodigoPostal = pCP AND col.Estatus = 1;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtDetallesCatalogo
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtDetallesCatalogo`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDetallesCatalogo`(IN `pNombreCatalogo` VARCHAR(100), IN `pIdEmpresa` INT)
BEGIN
	if pIdEmpresa = 0 then
		SELECT 
			*
		FROM 
			catalogo
		WHERE 
			IdTipoCatalogo = (Select IdTipoCatalogo From TipoCatalogo Where NombreSingular = pNombreCatalogo)
			AND EsActivo = 1;
	else
		SELECT 
			*
		FROM 
			catalogo
		WHERE 
			IdTipoCatalogo = (Select IdTipoCatalogo From TipoCatalogo Where NombreSingular = pNombreCatalogo)
			AND IdEmpresa = pIdEmpresa AND EsActivo = 1;
    end if;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtDocsCliente
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtDocsCliente`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDocsCliente`(IN `pIdCliente` INT, IN `pIdEmpresa` INT)
BEGIN	
	SELECT
	   c.IdCliente as IdCliente,
	   c.IdDocumento as IdDocumento,
	   c.Nombre as Nombre,
	   c.Url as Url,
	   c.IdEmpresa as Idempresa,
	   cat.Nombre as DescDocumento,
	   c.Id,
       c.NombreOriginal
	FROM clientedocumentos c, catalogo cat
	where (c.IdDocumento = cat.IdCatalogo) 
	  AND
	  c.IdCliente = pIdCliente AND c.IdEmpresa = pIdEmpresa;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtDocsProspecto
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtDocsProspecto`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtDocsProspecto`(IN `pIdProspecto` INT, IN `pIdEmpresa` INT)
BEGIN	
	SELECT
	   p.IdProspecto as IdProspecto,
	   p.IdDocumento as IdDocumento,
	   p.Nombre as Nombre,
	   p.Url as Url,
	   p.IdEmpresa as Idempresa,
	   cat.Nombre as DescDocumento,
	   p.Id,
       p.NombreOriginal
	FROM prospectodocumentos p, catalogo cat
	where (p.IdDocumento = cat.IdCatalogo) 
	  AND
	  p.IdProspecto = pIdProspecto AND p.IdEmpresa = pIdEmpresa;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtEmpresas
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtEmpresas`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtEmpresas`()
BEGIN
	SELECT 
		IdEmpresa,
        Dominio,
        ProductKey,
        Administrador,
        Contrasenia,
        NombreComercial,
        RutaLogo
    FROM empresa;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtenerParametros
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtenerParametros`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerParametros`()
BEGIN
    
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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtEstados
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtEstados`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtEstados`(IN `pClavePais` VARCHAR(512), IN `pActivo` INT)
BEGIN
SELECT Clave_Estado
      ,Nombre
FROM estado
WHERE Clave_Pais = pClavePais
	AND Estatus = pActivo
ORDER BY Nombre ASC;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtFechaUltimaCarga
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtFechaUltimaCarga`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtFechaUltimaCarga`(IN `pPais` VARCHAR(10))
BEGIN
 
 select max(FechaCreacion) from historicocargacp where Clave_Pais = pPais;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtFormas
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtFormas`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtFormas`(IN `pIdEmpresa` INT)
BEGIN
	
    SELECT
		IdForma
        , TextoLink
        , Descripcion
	FROM Forma
    WHERE 
		/*IdEmpresa = 1
		AND*/ Estatus = 1
        AND EsSuperAdministrador = 0;    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtFormasRolesPrivilegiosPorAdministrador
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtFormasRolesPrivilegiosPorAdministrador`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtFormasRolesPrivilegiosPorAdministrador`(IN `pIdEmpresa` INT, IN `pEsSuperAdministrador` TINYINT(1))
BEGIN
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
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtFormasRolesPrivilegiosPorRol
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtFormasRolesPrivilegiosPorRol`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtFormasRolesPrivilegiosPorRol`(`pNombreForma` VARCHAR(50), `pIdRol` INT, `pIdEmpresa` INT)
BEGIN

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
 		left join FormaRol on (FormaRol.IdForma =  Forma.IdForma and FormaRol.IdRol = pIdRol)
 		where 
 			Forma.Estatus = 1 
 			and (	Forma.Nombre like concat('%', ifnull(pNombreForma, ''), '%') 
					OR Forma.Descripcion like concat('%', ifnull(pNombreForma, ''), '%') 
				)
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
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtFormasRolesPrivilegiosPorUsuario
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtFormasRolesPrivilegiosPorUsuario`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtFormasRolesPrivilegiosPorUsuario`(IN `pIdUsuario` INT, IN `pIdEmpresa` INT)
BEGIN

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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtIdsCatalogosDelSubCatalogo
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtIdsCatalogosDelSubCatalogo`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtIdsCatalogosDelSubCatalogo`(`pIdSubCatalogo` INT, `pIdEmpresa` INT)
BEGIN    
                            
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
    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtInfoSubCatalogoPorIdPadre
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtInfoSubCatalogoPorIdPadre`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtInfoSubCatalogoPorIdPadre`(`pIdCatalogo` INT, `pIdTipoCatalogo` INT, `pIdEmpresa` INT)
BEGIN

	SELECT 
		cat.IdSubCatalogo as IdCatalogo
		, cat.Nombre
		, cat.EsActivo
	FROM SubCatalogo cat
	where	cat.IdCatalogo = pIdCatalogo
			and cat.IdTipoCatalogo = pIdTipoCatalogo
            and cat.IdEmpresa = pIdEmpresa;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtInfoSubCatalogoPorNombrePadre
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtInfoSubCatalogoPorNombrePadre`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtInfoSubCatalogoPorNombrePadre`(`pIdCatalogo` INT, `pCatalogo` VARCHAR(100), `pIdEmpresa` INT)
BEGIN

	SELECT 
		cat.IdSubCatalogo as IdCatalogo
		, cat.Nombre
		, cat.EsActivo
	FROM SubCatalogo cat
	inner join TipoCatalogo tipo on tipo.IdTipoCatalogo = cat.IdTipoCatalogo 
	where	cat.IdCatalogo = pIdCatalogo
			and tipo.Nombre = replace(pCatalogo, '_', ' ')
            and cat.IdEmpresa = pIdEmpresa;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtPaises
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtPaises`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtPaises`(IN `pNombre` VARCHAR(512), IN `pActivo` INT)
BEGIN
SELECT Clave_Pais
      ,Nombre
FROM pais 
WHERE Nombre like concat('%', IFNULL(pNombre, ''), '%')
AND Estatus = pActivo;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtParametros
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtParametros`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtParametros`(`pNombre` VARCHAR(64), `pDescripcion` VARCHAR(64), `pIdEmpresa` INT)
BEGIN

	SELECT IdParametro, Nombre, Descripcion, Valor, EsActivo, EsSensitivo, IdEmpresa 
 	FROM Parametro
 	WHERE 
		Nombre LIKE CONCAT('%', pNombre, '%')
        AND Descripcion LIKE CONCAT('%', pDescripcion, '%')
        AND IdEmpresa = pIdEmpresa;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtParametrosEmpresa
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtParametrosEmpresa`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtParametrosEmpresa`(`pNombre` VARCHAR(64), `pDescripcion` VARCHAR(64))
BEGIN

	SELECT IdParametro, Nombre, Descripcion, Valor, EsActivo, EsSensitivo
 	FROM parametroempresa
 	WHERE 
		Nombre LIKE CONCAT('%', pNombre, '%')
        AND Descripcion LIKE CONCAT('%', pDescripcion, '%');

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtPermisosForma
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtPermisosForma`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtPermisosForma`(`pIdForma` INT, `pIdEmpresa` INT)
BEGIN

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
 	INNER JOIN Permiso on Permiso.IdPermiso = FormaPermiso.IdPermiso
 	where Permiso.Estatus = 1
 			and FormaPermiso.IdForma = pIdForma;
            
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtProspectoId
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtProspectoId`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectoId`(IN `pIdProspecto` INT)
BEGIN	
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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtProspectos
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtProspectos`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectos`(IN `pNombre` VARCHAR(100), IN `pActivo` INT, IN `pIdEmpresa` INT)
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
	   p.IdProspecto as IdProspecto,
	   CONCAT(p.Nombre,' ', p.Apellidos) as NombreCompleto,
	   p.Nombre as Nombre,
	   p.Apellidos as Apellidos,
           p.FechaNacimiento as FechaNacimiento,
	   p.RFC as RFC,
	   p.Email as Email,
           p.TelefonoMovil as TelefonoMovil,
	   p.TelefonoOtro as TelefonoOtro,
           p.Clave_Colonia as Clave_Colonia,
           p.CP as CP,
	   p.Direccion as Direccion,
	   p.Salario as Salario,
	   p.IdSexo as IdSexo, 
           cSexo.Nombre as NombreSexo,
	   p.IdEstadoCivil as IdEstadoCivil,
           cEC.Nombre as NombreEstadoCivil,
	   p.IdEscolaridad as IdEscolaridad,   
           cEsco.Nombre as NombreEscolaridad,
	   p.Estatus as Estatus,
	   p.Comentario,
       p.NivelIngles,
	   colonia.Nombre as NombreColonia,
	   (Select MAX(bitacora.FechaCreacion) FROM bitacora WHERE bitacora.IdProspecto = p.IdProspecto) as FechaContacto,
       p.foto
	FROM prospecto p left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
    	  left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
          left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo
	  left join colonia on (p.Clave_Colonia = colonia.Clave_colonia
			AND p.CP = Colonia.CodigoPostal
		)
	where (p.Nombre like concat('%', IFNULL(pNombre, ''), '%')
		OR p.Apellidos like concat('%', IFNULL(pNombre, ''), '%')	)
		AND p.Estatus between pDesde and pHasta
		AND p.IdEmpresa = pIdEmpresa;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtProspectosPorCaracteristicas
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtProspectosPorCaracteristicas`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProspectosPorCaracteristicas`(IN `pIdEmpresa` INT, IN `ParametrosXML` VARCHAR(65535),IN `pIdSexo` INT,IN `pIdEstadoCivil` INT,IN `pIdEscolaridad` INT,IN `pEdadMin` INT,IN `pEdadMax` INT)
BEGIN
	SET @pXML = REPLACE(ParametrosXML,'[','<');
	SET @pXML = REPLACE(@pXML,']','>');

	SET @COUNT = (SELECT EXTRACTVALUE (@pXML,'COUNT(/Parametros/Parametro)'));	
	SET @SQL_EXTERNO = 'SELECT
	   p.IdProspecto as IdProspecto,
	   CONCAT(p.Nombre,'' ' ''', p.Apellidos) as NombreCompleto,
	   p.Nombre as Nombre,
	   p.Apellidos as Apellidos,
           p.FechaNacimiento as FechaNacimiento,
	   p.RFC as RFC,
	   p.Email as Email,
           p.TelefonoMovil as TelefonoMovil,
	   p.TelefonoOtro as TelefonoOtro,
           p.Clave_Colonia as Clave_Colonia,
           p.CP as CP,
	   p.Direccion as Direccion,
	   p.Salario as Salario,
	   p.IdSexo as IdSexo, 
           cSexo.Nombre as NombreSexo,
	   p.IdEstadoCivil as IdEstadoCivil,
           cEC.Nombre as NombreEstadoCivil,
	   p.IdEscolaridad as IdEscolaridad,   
           cEsco.Nombre as NombreEscolaridad,
	   p.Estatus as Estatus,
	   p.Comentario,
       p.NivelIngles,
	   colonia.Nombre as NombreColonia,
	   (Select MAX(bitacora.FechaCreacion) FROM bitacora WHERE bitacora.IdProspecto = p.IdProspecto) as FechaContacto,
       p.foto
	FROM prospecto p left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
    	  left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
          left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo
	  left join colonia on (p.Clave_Colonia = colonia.Clave_colonia
			AND p.CP = Colonia.CodigoPostal 
		)
	where p.IdEmpresa = ';
  SET @SQL_EXTERNO = concat( @SQL_EXTERNO, CONVERT ( pIdEmpresa, CHAR ) );	
	SET @SQL_EXTERNO = concat( @SQL_EXTERNO, ' AND p.IdProspecto IN ' );	
	SET @SQL_INTERNO = '(SELECT 	DISTINCT P.IdProspecto
											FROM 		prospecto P ';
	SET @I = 1;
	WHILE (@I <= @COUNT) DO
		SET @SQL_INTERNO = concat( @SQL_INTERNO, ' INNER 	JOIN prospectocaracteristica PC',@I,' ON P.IdProspecto = PC',@I,'.IdProspecto' );
		SET @I = @I + 1;
	END	WHILE;

	SET @SQL_INTERNO = concat( @SQL_INTERNO, ' WHERE		P.IdEmpresa = ' );		
	SET @SQL_INTERNO = concat( @SQL_INTERNO, CONVERT ( pIdEmpresa, CHAR ) );	
	SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND p.Estatus = 1 ' );	

/*
SET @ParametrosXML = '
		<Parametros>
			<Parametro>
				<IdCaracteristicaParticular>31</IdCaracteristicaParticular>
				<Valor>Alto</Valor>
			</Parametro>
			<Parametro>
				<IdCaracteristicaParticular>28</IdCaracteristicaParticular>
				<Valor>true</Valor>
			</Parametro>
		</Parametros>';


		SET @pIdSexo = NULL;

		SET @pIdEstadoCivil = NULL;

		SET @pIdEscolaridad = NULL;

		SET @pEdadMin = 20;

		SET @pEdadMax = 30;

		CALL ObtProspectosPorCaracteristicas (1 ,@ParametrosXML ,@pIdSexo, @pIdEstadoCivil, @pIdEscolaridad, @pEdadMin, @pEdadMax);*/

/*
	if(pIdSexo != 0) then
	SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND p.IdSexo = ',pIdSexo,' ');	
	end if;

	if(pIdEstadoCivil != 0) then
	SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND p.IdEstadoCivil = ',pIdEstadoCivil,' ');	
	end if;

	if(pIdEscolaridad != 0) then
	SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND p.IdEscolaridad = ',pIdEscolaridad,' ');	
	end if;

	if(pEdadMin != 0) then
	SET @sEdad = concat( ' AND CEILING((((365 * YEAR(CURDATE())) - (365 * (YEAR(FechaNacimiento)))) + (MONTH(CURDATE()) - MONTH(FechaNacimiento)) * 30 + (DAY(CURDATE()) - DAY(FechaNacimiento))) / 365) >= ',pEdadMin,' ');	
	end if;

	if(pEdadMax != 0) then
	SET @sEdad = concat( ' AND CEILING((((365 * YEAR(CURDATE())) - (365 * (YEAR(FechaNacimiento)))) + (MONTH(CURDATE()) - MONTH(FechaNacimiento)) * 30 + (DAY(CURDATE()) - DAY(FechaNacimiento))) / 365) <= ',pEdadMax,' ');	
	end if;

	if(pEdadMin != 0 and pEdadMax != -1) then
	SET @sEdad = concat( ' AND CEILING((((365 * YEAR(CURDATE())) - (365 * (YEAR(FechaNacimiento)))) + (MONTH(CURDATE()) - MONTH(FechaNacimiento)) * 30 + (DAY(CURDATE()) - DAY(FechaNacimiento))) / 365) BETWEEN ',pEdadMin,' and ',pEdadMax,' ');	
	end if;

	SET @SQL_INTERNO = concat( @SQL_INTERNO, @sEdad);	
*/

	SET @I = 1;
	WHILE (@I <= @COUNT) DO
		SET @IdCaracteristicaParticular = EXTRACTVALUE (@pXML,CONCAT('/Parametros/Parametro[',@I,']/IdCaracteristicaParticular'));
		
		SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND PC',@I,'.IdCaracteristicaParticular = ',@IdCaracteristicaParticular,' ' );

		SET @COUNT_VALOR =  (SELECT EXTRACTVALUE (@pXML,CONCAT('COUNT(/Parametros/Parametro[',@I,']/Valor)')));	

		SET @I_VALOR = 1;
		SET @COMA = '';
		SET @COMILLAS = '''';
		SET @Valor = '';
		WHILE (@I_VALOR <= @COUNT_VALOR) DO
			SET @Valor_S = EXTRACTVALUE (@pXML,CONCAT('/Parametros/Parametro[',@I,']/Valor[',@I_VALOR,']'));
			SET @Valor = concat(@Valor,@COMA,@COMILLAS,@Valor_S,@COMILLAS);
			SET @COMA = ',';
		SET @I_VALOR = @I_VALOR + 1;
		END	WHILE;

		SET @SQL_INTERNO = concat( @SQL_INTERNO, ' AND PC',@I,'.Valor IN (',@Valor,') ' );		
		SET @I = @I + 1;
	END	WHILE;

	SET @SQL = concat(@SQL_EXTERNO, @SQL_INTERNO, ')');
	-- SELECT @SQL;
	PREPARE stmt1 
	FROM @SQL;
	EXECUTE stmt1;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtProsVacante
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtProsVacante`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtProsVacante`(IN `pIdVacante` INT, IN `pIdEmpresa` INT)
BEGIN
	
	SELECT
	   p.IdProspecto as IdProspecto,
	   CONCAT(p.Nombre,' ', p.Apellidos) as NombreCompleto,
	   p.Nombre as Nombre,
	   p.Apellidos as Apellidos,
           p.FechaNacimiento as FechaNacimiento,
	   p.RFC as RFC,
	   p.Email as Email,
           p.TelefonoMovil as TelefonoMovil,
	   p.TelefonoOtro as TelefonoOtro,
           p.Clave_Colonia as Clave_Colonia,
           p.CP as CP,
	   p.Direccion as Direccion,
	   p.Salario as Salario,
	   p.IdSexo as IdSexo, 
           cSexo.Nombre as NombreSexo,
	   p.IdEstadoCivil as IdEstadoCivil,
           cEC.Nombre as NombreEstadoCivil,
	   p.IdEscolaridad as IdEscolaridad,   
           cEsco.Nombre as NombreEscolaridad,
	   p.Estatus as Estatus,
	   p.Comentario,
       p.NivelIngles,
	   colonia.Nombre as NombreColonia,
	   (Select MAX(bitacora.FechaCreacion) FROM bitacora WHERE bitacora.IdProspecto = p.IdProspecto) as FechaContacto,
       p.foto
	FROM prospecto p inner JOIN vacante_prospecto vp on p.IdProspecto = vp.IdProspecto left join catalogo cSexo ON p.IdSexo = cSexo.IdCatalogo
    	  left join catalogo cEC ON p.IdEstadoCivil = cEC.IdCatalogo
          left join catalogo cEsco ON p.IdEscolaridad = cEsco.IdCatalogo
	  left join colonia on (p.Clave_Colonia = colonia.Clave_colonia
			AND p.CP = Colonia.CodigoPostal 
		)
	where vp.IdVacante = pIdVacante
		AND p.IdEmpresa = pIdEmpresa;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtReferenciaLaboralIdProspecto
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtReferenciaLaboralIdProspecto`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtReferenciaLaboralIdProspecto`(IN `pIdProspecto` INT, IN `pEstatus` TINYINT(1), IN `pIdEmpresa` INT)
BEGIN
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
        
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtRoles
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtRoles`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtRoles`(`pNombreRol` VARCHAR(50), `pIdEmpresa` INT)
BEGIN
	DECLARE pBool tinyint(1);

 	SELECT IdRol
 		,NombreRol
 		,Estatus
        ,IdEmpresa
 	FROM Roles
 	where NombreRol like concat('%', ifnull(pNombreRol, ''), '%')
    AND IdEmpresa = pIdEmpresa;


END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtRolUsuario
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtRolUsuario`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtRolUsuario`(`pidUsuario` INT, `pIdEmpresa` INT)
BEGIN

 	SELECT 
 		R.IdRol
 		, R.NombreRol
 		, CASE when ru.IdRolUsuario is null then 0 else 1 end as Seleccionado
        , R.IdEmpresa
 	FROM Roles R
 	left join RolUsuario RU on ru.IdRol = r.IdRol and ru.IdUsuario = pidUsuario and ru.IdEmpresa = pIdEmpresa
 	WHERE r.Estatus = 1
    AND R.IdEmpresa = pIdEmpresa;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtSubCatalogoPorIdCatalogo
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtSubCatalogoPorIdCatalogo`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtSubCatalogoPorIdCatalogo`(`pIdCatalogo` INT, `pIdEmpresa` INT)
BEGIN
	
    SELECT SubCatalogo.IdSubCatalogo
		  ,SubCatalogo.Nombre
		  ,SubCatalogo.EsActivo
	 FROM SubCatalogo
	 WHERE SubCatalogo.IdCatalogo = pIdCatalogo
		AND SubCatalogo.IdEmpresa = pIdEmpresa;
    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtSubCatalogos
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtSubCatalogos`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtSubCatalogos`(`pidTipoCatalogo` INT, `pNombreCatalogo` VARCHAR(64), `pEsActivo` INT, `pIdEmpresa` INT)
BEGIN
	
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
    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtUsuarioPorId
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtUsuarioPorId`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuarioPorId`(`pIdUsuario` INT(11), `pIdEmpresa` INT)
BEGIN

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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtUsuarios
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtUsuarios`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuarios`(`pNombreCompleto` VARCHAR(250), `pActivo` TINYINT, `pIdEmpresa` INT)
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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtUsuariosAnalistas
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtUsuariosAnalistas`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuariosAnalistas`(`pNombreCompleto` VARCHAR(250), `pIdEmpresa` INT)
BEGIN
	
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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtUsuarioValidacionCorreo
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtUsuarioValidacionCorreo`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuarioValidacionCorreo`(`pIdUsuario` INT, `pCorreoElectronico` VARCHAR(50), `pIdEmpresa` INT)
BEGIN

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

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtUsuarioValidacionLogin
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtUsuarioValidacionLogin`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuarioValidacionLogin`(`pIdUsuario` INT, `pLogin` VARCHAR(50), `pIdEmpresa` INT)
BEGIN

 	SELECT
 	   (	CASE WHEN EXISTS (select 1 from Usuario where Login = pLogin and IdUsuario != pIdUsuario AND IdEmpresa = pIdEmpresa) then 0
 				 ELSE 1
 			END
 	   );

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtUsuarioValidar
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtUsuarioValidar`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtUsuarioValidar`(IN `pIdEmpresa` INT(11), IN `pLogin` VARCHAR(50), IN `pContrasenia` VARCHAR(100))
BEGIN
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
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ObtVacantes
-- ----------------------------
DROP PROCEDURE IF EXISTS `ObtVacantes`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtVacantes`(IN `pVacantes` MEDIUMTEXT)
BEGIN
 
  set @sql = pVacantes;



  prepare stmt1 from @sql;

  execute stmt1;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ReemplazarMVC
-- ----------------------------
DROP PROCEDURE IF EXISTS `ReemplazarMVC`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReemplazarMVC`()
BEGIN

	SELECT
		IdRemplazarMVC 
		, RealMVC
		, Reemplazar
    from reemplazarmvc;
    
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ReiniciarAutoIncrementable
-- ----------------------------
DROP PROCEDURE IF EXISTS `ReiniciarAutoIncrementable`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReiniciarAutoIncrementable`()
BEGIN	
        
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
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TruTablesCP
-- ----------------------------
DROP PROCEDURE IF EXISTS `TruTablesCP`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TruTablesCP`(IN `pPais` VARCHAR(10))
BEGIN

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


END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for ValidarCodigo
-- ----------------------------
DROP PROCEDURE IF EXISTS `ValidarCodigo`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ValidarCodigo`(IN `pCodigo` VARCHAR(10), IN `pId` INT)
BEGIN
	SELECT *
	FROM caracteristicas
	WHERE codigoGenerado = pCodigo
		AND IdCaracteristica = pId;
END
;;
DELIMITER ;
