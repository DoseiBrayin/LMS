-- MySQL Script generated by MySQL Workbench
-- Fri Oct 28 19:21:16 2022
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema lms
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `lms` ;

-- -----------------------------------------------------
-- Schema lms
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lms` DEFAULT CHARACTER SET utf8 ;
USE `lms` ;

-- -----------------------------------------------------
-- Table `lms`.`rol`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lms`.`rol` ;

CREATE TABLE IF NOT EXISTS `lms`.`rol` (
  `idrol` INT NOT NULL,
  `nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`idrol`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lms`.`usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lms`.`usuario` ;

CREATE TABLE IF NOT EXISTS `lms`.`usuario` (
  `idusuario` VARCHAR(20) NOT NULL,
  `contraseña` VARCHAR(45) NOT NULL,
  `rol_idrol` INT NOT NULL,
  PRIMARY KEY (`idusuario`, `rol_idrol`),
  INDEX `fk_usuario_rol1_idx` (`rol_idrol` ) ,
  CONSTRAINT `fk_usuario_rol1`
    FOREIGN KEY (`rol_idrol`)
    REFERENCES `lms`.`rol` (`idrol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lms`.`pensum`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lms`.`pensum` ;

CREATE TABLE IF NOT EXISTS `lms`.`pensum` (
  `idpensum` INT(4) unsigned ZEROFILL NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `materias` VARCHAR(45) NULL,
  PRIMARY KEY (`idpensum`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lms`.`estudiante`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lms`.`estudiante` ;

CREATE TABLE IF NOT EXISTS `lms`.`estudiante` (
  `cedula` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `pensum_idpensum` INT(4) unsigned ZEROFILL NOT NULL,
  `usuario_idusuario` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`cedula`, `pensum_idpensum`, `usuario_idusuario`),
  UNIQUE INDEX `correo_UNIQUE` (`correo` ) ,
  INDEX `fk_estudiante_pensum1_idx` (`pensum_idpensum` ) ,
  INDEX `fk_estudiante_usuario1_idx` (`usuario_idusuario` ) ,
  CONSTRAINT `fk_estudiante_pensum1`
    FOREIGN KEY (`pensum_idpensum`)
    REFERENCES `lms`.`pensum` (`idpensum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_estudiante_usuario1`
    FOREIGN KEY (`usuario_idusuario`)
    REFERENCES `lms`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lms`.`profesor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lms`.`profesor` ;

CREATE TABLE IF NOT EXISTS `lms`.`profesor` (
  `cedula` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `usuario_idusuario` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`cedula`, `usuario_idusuario`),
  UNIQUE INDEX `correo_UNIQUE` (`correo` ) ,
  INDEX `fk_profesor_usuario1_idx` (`usuario_idusuario` ) ,
  CONSTRAINT `fk_profesor_usuario1`
    FOREIGN KEY (`usuario_idusuario`)
    REFERENCES `lms`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lms`.`admin`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lms`.`admin` ;

CREATE TABLE IF NOT EXISTS `lms`.`admin` (
  `cedula` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `usuario_idusuario` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`cedula`, `usuario_idusuario`),
  UNIQUE INDEX `correo_UNIQUE` (`correo` ) ,
  INDEX `fk_admin_usuario1_idx` (`usuario_idusuario` ) ,
  CONSTRAINT `fk_admin_usuario1`
    FOREIGN KEY (`usuario_idusuario`)
    REFERENCES `lms`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lms`.`asignatura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lms`.`asignatura` ;

CREATE TABLE IF NOT EXISTS `lms`.`asignatura` (
  `id_asig` INT(4) unsigned ZEROFILL NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `creditos` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_asig`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lms`.`tiempo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lms`.`tiempo` ;

CREATE TABLE IF NOT EXISTS `lms`.`tiempo` (
  `idtiempo` INT(4) NOT NULL AUTO_INCREMENT,
  `dia` VARCHAR(45) NOT NULL,
  `hora_inicio` TIME NOT NULL,
  `hora_fin` TIME NOT NULL,
  PRIMARY KEY (`idtiempo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lms`.`grupo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lms`.`grupo` ;

CREATE TABLE IF NOT EXISTS `lms`.`grupo` (
  `idgrupo` INT(4) unsigned ZEROFILL NOT NULL AUTO_INCREMENT,
  `profesor_cedula` INT NOT NULL,
  `asignatura_id_asig` INT(4) unsigned ZEROFILL NOT NULL,
  `tiempo_idtiempo` INT(4) NOT NULL,
   PRIMARY KEY (`idgrupo`, `profesor_cedula`, `asignatura_id_asig`, `tiempo_idtiempo`),
  INDEX `fk_grupo_profesor1_idx` (`profesor_cedula` ) ,
  INDEX `fk_grupo_asignatura1_idx` (`asignatura_id_asig` ) ,
  INDEX `fk_grupo_tiempo1_idx` (`tiempo_idtiempo` ) ,
  CONSTRAINT `fk_grupo_profesor1`
    FOREIGN KEY (`profesor_cedula`)
    REFERENCES `lms`.`profesor` (`cedula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_grupo_asignatura1`
    FOREIGN KEY (`asignatura_id_asig`)
    REFERENCES `lms`.`asignatura` (`id_asig`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_grupo_tiempo1`
    FOREIGN KEY (`tiempo_idtiempo`)
    REFERENCES `lms`.`tiempo` (`idtiempo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lms`.`pensum_has_asignatura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lms`.`pensum_has_asignatura` ;

CREATE TABLE IF NOT EXISTS `lms`.`pensum_has_asignatura` (
  `pensum_idpensum` INT(4) unsigned ZEROFILL NOT NULL,
  `asignatura_id_asig` INT(4) unsigned ZEROFILL NOT NULL,
  PRIMARY KEY (`pensum_idpensum`, `asignatura_id_asig`),
  INDEX `fk_pensum_has_asignatura_asignatura1_idx` (`asignatura_id_asig` ) ,
  INDEX `fk_pensum_has_asignatura_pensum1_idx` (`pensum_idpensum` ) ,
  CONSTRAINT `fk_pensum_has_asignatura_pensum1`
    FOREIGN KEY (`pensum_idpensum`)
    REFERENCES `lms`.`pensum` (`idpensum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pensum_has_asignatura_asignatura1`
    FOREIGN KEY (`asignatura_id_asig`)
    REFERENCES `lms`.`asignatura` (`id_asig`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lms`.`notas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lms`.`notas` ;

CREATE TABLE IF NOT EXISTS `lms`.`notas` (
  `idnotas` INT NOT NULL AUTO_INCREMENT,
  `parcial` FLOAT(2) NULL,
  `seguimiento` FLOAT(2) NULL,
  `final` FLOAT(2) NULL,
  PRIMARY KEY (`idnotas`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lms`.`matriculada`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lms`.`matriculada` ;

CREATE TABLE IF NOT EXISTS `lms`.`matriculada` (
  `idmatriculada` INT(4) unsigned ZEROFILL NOT NULL AUTO_INCREMENT,
  `estado` VARCHAR(45) NOT NULL,
  `estudiante_cedula` INT NOT NULL,
  `estudiante_pensum_idpensum` INT(4) unsigned ZEROFILL NOT NULL,
  `estudiante_usuario_idusuario` VARCHAR(20) NOT NULL,
  `asignatura_id_asig` INT(4) ZEROFILL NOT NULL,
  PRIMARY KEY (`idmatriculada`, `estudiante_cedula`, `estudiante_pensum_idpensum`, `estudiante_usuario_idusuario`, `asignatura_id_asig`),
  INDEX `fk_matriculada_estudiante1_idx` (`estudiante_cedula` , `estudiante_pensum_idpensum` , `estudiante_usuario_idusuario` ) ,
  INDEX `fk_matriculada_asignatura1_idx` (`asignatura_id_asig` ) ,
  CONSTRAINT `fk_matriculada_estudiante1`
    FOREIGN KEY (`estudiante_cedula` , `estudiante_pensum_idpensum` , `estudiante_usuario_idusuario`)
    REFERENCES `lms`.`estudiante` (`cedula` , `pensum_idpensum` , `usuario_idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_matriculada_asignatura1`
    FOREIGN KEY (`asignatura_id_asig`)
    REFERENCES `lms`.`asignatura` (`id_asig`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `lms`.`estudiante_has_grupo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lms`.`estudiante_has_grupo` ;

CREATE TABLE IF NOT EXISTS `lms`.`estudiante_has_grupo` (
  `estudiante_cedula` INT NOT NULL,
  `estudiante_pensum_idpensum` INT(4) ZEROFILL NOT NULL,
  `estudiante_usuario_idusuario` VARCHAR(20) NOT NULL,
  `grupo_idgrupo` INT(4) ZEROFILL NOT NULL,
  `grupo_profesor_cedula` INT NOT NULL,
  `grupo_asignatura_id_asig` INT(4) ZEROFILL NOT NULL,
  `grupo_tiempo_idtiempo` INT(4) NOT NULL,
  `notas_idnotas` INT NOT NULL,
  PRIMARY KEY (`estudiante_cedula`, `estudiante_pensum_idpensum`, `estudiante_usuario_idusuario`, `grupo_idgrupo`, `grupo_profesor_cedula`, `grupo_asignatura_id_asig`, `grupo_tiempo_idtiempo`, `notas_idnotas`),
  INDEX `fk_estudiante_has_grupo_grupo1_idx` (`grupo_idgrupo` , `grupo_profesor_cedula` , `grupo_asignatura_id_asig` , `grupo_tiempo_idtiempo` ) ,
  INDEX `fk_estudiante_has_grupo_estudiante1_idx` (`estudiante_cedula` , `estudiante_pensum_idpensum` , `estudiante_usuario_idusuario` ) ,
  INDEX `fk_estudiante_has_grupo_notas1_idx` (`notas_idnotas` ) ,
  CONSTRAINT `fk_estudiante_has_grupo_estudiante1`
    FOREIGN KEY (`estudiante_cedula` , `estudiante_pensum_idpensum` , `estudiante_usuario_idusuario`)
    REFERENCES `lms`.`estudiante` (`cedula` , `pensum_idpensum` , `usuario_idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_estudiante_has_grupo_grupo1`
    FOREIGN KEY (`grupo_idgrupo` , `grupo_profesor_cedula` , `grupo_asignatura_id_asig` , `grupo_tiempo_idtiempo`)
    REFERENCES `lms`.`grupo` (`idgrupo` , `profesor_cedula` , `asignatura_id_asig` , `tiempo_idtiempo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_estudiante_has_grupo_notas1`
    FOREIGN KEY (`notas_idnotas`)
    REFERENCES `lms`.`notas` (`idnotas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO `pensum` (`idpensum`, `nombre`,`materias`) VALUES ('8210', 'La Magia De La informatica',10), ('9192', 'Encantamientos Audiovisuales',10);
INSERT INTO `rol` (`idrol`, `nombre`) VALUES ('1', 'admin'), ('2', 'profesor'), ('3', 'estudiante');
INSERT INTO `usuario` (`idusuario`, `contraseña`, `rol_idrol`) VALUES ('brayan_admin', '12345', '1'), ('Carlos_Arenas', '123', '3'), ('Ruben_Arenas', '12345', '3'), ('Sebas_Arenas', '1234', '3'), ('Xime_Pulgarin', '12345', '3'), ('Andreu_P', '1234', '2'), ('Martha_F', '1234', '2'), ('Pelayo_Gr', '1234', '2'), ('Graciela_D', '12345', '2');
INSERT INTO `estudiante` (`cedula`, `nombre`, `correo`, `pensum_idpensum`, `usuario_idusuario`) VALUES ('1779854', 'Ruben Arenas', 'ruben_estudiante@howards.com', '8210', 'Ruben_Arenas');
INSERT INTO `estudiante` (`cedula`, `nombre`, `correo`, `pensum_idpensum`, `usuario_idusuario`) VALUES('1883950', 'Carlos Arenas', 'carlos_arenas@howards.com', '8210', 'Carlos_Arenas');
INSERT INTO `estudiante` (`cedula`, `nombre`, `correo`, `pensum_idpensum`, `usuario_idusuario`) VALUES ('1546474', 'Ximena Pulgarin', 'xime_pulgarin@howards.com', '9192', 'Xime_Pulgarin'), ('1579123', 'Sebastian Arenas', 'sebas_arenas@howards.com', '9192', 'Sebas_Arenas');
INSERT INTO `profesor` (`cedula`, `nombre`, `correo`, `usuario_idusuario`) VALUES ('1130171', 'Andreu Pineda', 'andru_pineda@howards.com', 'Andreu_P'), ('1783532', 'Graciela Diaz', 'graciel_diaz@howards.com', 'Graciela_D'), ('1640564', 'Pelayo Grande', 'Pelayo_Grande@howards.com', 'Pelayo_Gr'), ('1301470', 'Martha Florez', 'Martha_Florez@howards.com', 'Martha_F');
INSERT INTO `admin` (`cedula`, `nombre`, `correo`, `usuario_idusuario`) VALUES ('1035970766', 'Brayan Ardila', 'brayan_ardila@howards.com', 'brayan_admin');
INSERT INTO `asignatura` (`id_asig`, `nombre`, `creditos`) VALUES (NULL, 'Defense against the dark arts', '4'), (NULL, '
History of Magic', '4'), (NULL, 'Astronomy', '2'), (NULL, 'Transformations', '4'), (NULL, 'Flight', '4'), (NULL, 'Muggle Studies', '3'), (NULL, 'Care of Magical Creatures', '3'), (NULL, '
Guessing', '4'), (NULL, 'Ancient Runes', '3');
INSERT INTO `asignatura` (`id_asig`, `nombre`, `creditos`) VALUES (NULL, 'Herbology', '2'), (NULL, 'Potions', '2'), (NULL, '
Incantations', '2'), (NULL, 'Arithmancy', '2'), (NULL, 'Ancient Studies', '4'), (NULL, 'Magical Theory', '4') ;
INSERT INTO `tiempo` (`idtiempo`, `dia`, `hora_inicio`, `hora_fin`) VALUES (NULL, 'MARTES-JUEVES', '14:00', '16:00'), (NULL, 'JUEVES-VIERNES', '12:00', '14:00'), (NULL, 'LUNES-MARTES', '10:00', '12:00'), (NULL, 'LUNES-MIERCOLES', '18:00', '20:00'), (NULL, 'LUNES-VIERNES', '8:00', '10:00'), (NULL, 'MIERCOLES-VIERNES', '6:00', '8:00');
INSERT INTO `matriculada` (`idmatriculada`, `estado`, `estudiante_cedula`, `estudiante_pensum_idpensum`, `estudiante_usuario_idusuario`, `asignatura_id_asig`) VALUES (NULL, 'REPROBADO', '1883950', '8210', 'Carlos_Arenas', '0002'), (NULL, 'REPROBADO', '1883950', '8210', 'Carlos_Arenas', '0002');
INSERT INTO `grupo` (`idgrupo`, `profesor_cedula`, `asignatura_id_asig`, `tiempo_idtiempo`) VALUES (null, '1130171', '0002', '2'), (null, '1130171', '0006', '1'), (null, '1783532', '0005', '3'), (null, '1783532', '0007', '6'), (null, '1301470', '0013', '1'), (null, '1301470', '0014', '6'), (null, '1640564', '0001', '3'), (null, '1640564', '0009', '4'), (null, '1301470', '0015', '5'), (null, '1301470', '0017', '2');
INSERT INTO `notas` (`idnotas`, `parcial`, `seguimiento`, `final`) VALUES (NULL, '', '', '');
INSERT INTO `notas` (`idnotas`, `parcial`, `seguimiento`, `final`) VALUES (NULL, '', '', '');
INSERT INTO `notas` (`idnotas`, `parcial`, `seguimiento`, `final`) VALUES (NULL, '', '', '');
INSERT INTO `notas` (`idnotas`, `parcial`, `seguimiento`, `final`) VALUES (NULL, '', '', '');
INSERT INTO `notas` (`idnotas`, `parcial`, `seguimiento`, `final`) VALUES (NULL, '', '', '');
INSERT INTO `notas` (`idnotas`, `parcial`, `seguimiento`, `final`) VALUES (NULL, '', '', '');
INSERT INTO `notas` (`idnotas`, `parcial`, `seguimiento`, `final`) VALUES (NULL, '', '', '');
INSERT INTO `notas` (`idnotas`, `parcial`, `seguimiento`, `final`) VALUES (NULL, '', '', '');
INSERT INTO `pensum_has_asignatura` (`pensum_idpensum`, `asignatura_id_asig`) VALUES ('8210', '0002'), ('8210', '0005'), ('8210', '0001'), ('8210', '0009'), ('8210', '0006'), ('8210', '0007'), ('8210', '0008'), ('8210', '0004'), ('8210', '0010'), ('8210', '0003'), ('9192', '0003'), ('9192', '0007'), ('9192', '0016'), ('9192', '0015'), ('9192', '0010'), ('9192', '0011'), ('9192', '0012'), ('9192', '0013'), ('9192', '0014'), ('9192', '0017');
INSERT INTO `estudiante_has_grupo` (`estudiante_cedula`, `estudiante_pensum_idpensum`, `estudiante_usuario_idusuario`, `grupo_idgrupo`, `grupo_profesor_cedula`, `grupo_asignatura_id_asig`, `grupo_tiempo_idtiempo`, `notas_idnotas`) VALUES ('1883950', '8210', 'Carlos_Arenas', '0001', '1130171', '0002', '2', '1'), ('1779854', '8210', 'Ruben_Arenas', '0001', '1130171', '0002', '2', '2');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
