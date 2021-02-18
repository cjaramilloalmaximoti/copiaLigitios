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