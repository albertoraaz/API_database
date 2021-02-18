-- MySQL Workbench Forward Engineering
CREATE DATABASE main_db;
USE main_db;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `Location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Location` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` ENUM('country', 'province', 'state', 'locality', 'district'),
  `name` VARCHAR(255) NOT NULL,
  `point` POINT NULL,
  `idParentLocation` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Location_Location1_idx` (`idParentLocation` ASC),
  CONSTRAINT `fk_Location_Location1`
    FOREIGN KEY (`idParentLocation`)
    REFERENCES `Location` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

LOCK TABLES `Location` WRITE;
/*!40000 ALTER TABLE `Location` DISABLE KEYS */;
INSERT INTO `Location` (id,type,name)
values
(1,'state', 'Córdoba'),
(2,'state', 'Buenos Aires'),
(3,'state', 'Tucumán');

/*!40000 ALTER TABLE `Location` ENABLE KEYS */;
UNLOCK TABLES;

-- -----------------------------------------------------
-- Table `User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `User` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(255) NULL,
  `email` VARCHAR(255) NOT NULL,
  `passwordEncrypted` VARCHAR(255) NULL,
  `firstName` VARCHAR(255) NULL,
  `lastName` VARCHAR(255) NULL,
  `type` ENUM('recruiter','aspirant','admin', 'contact'),
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` ENUM('active','pending', 'invited','blocked'),
  `profileDescription` TEXT NULL COMMENT 'es la description del usuario',
  `profilePicture` VARCHAR(255) NULL,
  `idLocation` INT NULL,
  `birthDate` DATETIME NULL DEFAULT NULL,
  `cv` JSON NULL COMMENT 'es el cv del usuario\n',
  `workingHours` JSON NULL COMMENT 'rango horario laboral disponible',
  PRIMARY KEY (`id`),
  INDEX `fk_User_Location1_idx` (`idLocation` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  CONSTRAINT `fk_User_Location1`
    FOREIGN KEY (`idLocation`)
    REFERENCES `Location` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` (id,username,email,passwordEncrypted,firstName,lastName,type,state)
values
(1,'user', 'user@mail.com', '$2a$10$y1YpEHpRV7FH9WE./JA5k.ZWNYiMmifrojBXuOtdNukcPxj2FRWYe', 'user', 'last','admin','active'),
(2,'user2', 'user2@mail.com', '$2a$10$y1YpEHpRV7FH9WE./JA5k.ZWNYiMmifrojBXuOtdNukcPxj2FRWYe', 'user', 'last','recruiter','active'),
(3,'user3', 'user3@mail.com', '$2a$10$y1YpEHpRV7FH9WE./JA5k.ZWNYiMmifrojBXuOtdNukcPxj2FRWYe', 'user', 'last','aspirant','active');

/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

-- -----------------------------------------------------
-- Table `AccessToken`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AccessToken` (
  `id` varchar(255) NOT NULL COMMENT 'the id is the token given to the user for access ',
  `ttl` INT NULL COMMENT 'TTL in milliseconds',
  `idUser` INT NOT NULL,
  `type` ENUM('user','validation','reset'),
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_AccessToken_User_idx` (`idUser` ASC),
  CONSTRAINT `fk_AccessToken_User`
    FOREIGN KEY (`idUser`)
    REFERENCES `User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

LOCK TABLES `AccessToken` WRITE;
/*!40000 ALTER TABLE `AccessToken` DISABLE KEYS */;
INSERT INTO `AccessToken` (id, ttl, idUser) values ('a120',86400000,1);
/*!40000 ALTER TABLE `AccessToken` ENABLE KEYS */;
UNLOCK TABLES;

-- -----------------------------------------------------
-- Table `Company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Company` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `address` VARCHAR(45) NULL,
  `point` POINT NULL,
  `idLocation` INT NULL,
  `idContactUser` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Company_Location1_idx` (`idLocation` ASC),
  INDEX `fk_Company_User1_idx` (`idContactUser` ASC),
  CONSTRAINT `fk_Company_Location1`
    FOREIGN KEY (`idLocation`)
    REFERENCES `Location` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Company_User1`
    FOREIGN KEY (`idContactUser`)
    REFERENCES `User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JobSearch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JobSearch` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NULL,
  `text` TEXT NULL,
  `address` VARCHAR(255) NULL,
  `idCompany` INT NOT NULL,
  `idFranchise` INT NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dueDate` DATETIME NULL,
  `state` VARCHAR(45) NOT NULL,
  `idJobSearchOwnerUser` INT NOT NULL,
  `idLocation` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_JobSearch_Company1_idx` (`idCompany` ASC),
  INDEX `fk_JobSearch_User1_idx` (`idJobSearchOwnerUser` ASC),
  INDEX `fk_JobSearch_Location1_idx` (`idLocation` ASC),
  CONSTRAINT `fk_JobSearch_Company1`
    FOREIGN KEY (`idCompany`)
    REFERENCES `Company` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_JobSearch_Franchise1`
    FOREIGN KEY (`idFranchise`)
    REFERENCES `Franchise` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_JobSearch_User1`
    FOREIGN KEY (`idJobSearchOwnerUser`)
    REFERENCES `User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_JobSearch_Location1`
    FOREIGN KEY (`idLocation`)
    REFERENCES `Location` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Skill`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Skill` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  `idParentSkill` INT NULL,
  `idOwner` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Skill_Skill1_idx` (`idParentSkill` ASC),
  CONSTRAINT `fk_Skill_Skill1`
    FOREIGN KEY (`idParentSkill`)
    REFERENCES `Skill` (`id`),
  CONSTRAINT `fk_Skill_user1`
    FOREIGN KEY (`idOwner`)
    REFERENCES `User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JobSearchCandidates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JobSearchCandidates` (
  `idJobSearch` INT NOT NULL,
  `idPostulantUser` INT NOT NULL,
  `postulatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` VARCHAR(45) NOT NULL COMMENT 'postulated/scheduled/interviewed/approved/ready',
  `idPostulantOwnerUser` INT NULL,
  `expectedSalary` DECIMAL NULL,
  `report` JSON NULL,
  `attachment1` TEXT null,
  `attachment2` TEXT null,
  `attachment3` TEXT null,
  PRIMARY KEY (`idJobSearch`, `idPostulantUser`),
  INDEX `fk_JobSearch_has_User_User1_idx` (`idPostulantUser` ASC),
  INDEX `fk_JobSearch_has_User_JobSearch1_idx` (`idJobSearch` ASC),
  INDEX `fk_Postulant_User1_idx` (`idPostulantOwnerUser` ASC),
  CONSTRAINT `fk_JobSearch_has_User_JobSearch1`
    FOREIGN KEY (`idJobSearch`)
    REFERENCES `JobSearch` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_JobSearch_has_User_User1`
    FOREIGN KEY (`idPostulantUser`)
    REFERENCES `User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Postulant_User1`
    FOREIGN KEY (`idPostulantOwnerUser`)
    REFERENCES `User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Franchise`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Franchise` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NULL,
  `logoURL` VARCHAR(255) NULL,
  `idOwnerUser` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Franchise_User1_idx` (`idOwnerUser` ASC),
  CONSTRAINT `fk_Franchise_User1`
    FOREIGN KEY (`idOwnerUser`)
    REFERENCES `User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

LOCK TABLES `Franchise` WRITE;
/*!40000 ALTER TABLE `Franchise` DISABLE KEYS */;

INSERT INTO `Franchise` (id, name, description, idOwnerUser) 
values (1, 'franchise1', 'franchise desc', 2);

/*!40000 ALTER TABLE `Franchise` ENABLE KEYS */;
UNLOCK TABLES;

-- -----------------------------------------------------
-- Table `FranchiseUsers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FranchiseUsers` (
  `idFranchise` INT NOT NULL,
  `idUser` INT NOT NULL,
  `state` ENUM('active','pending','invited'),
  PRIMARY KEY (`idFranchise`, `idUser`),
  INDEX `fk_Franchise_has_User_User1_idx` (`idUser` ASC),
  INDEX `fk_Franchise_has_User_Franchise1_idx` (`idFranchise` ASC),
  CONSTRAINT `fk_Franchise_has_User_Franchise1`
    FOREIGN KEY (`idFranchise`)
    REFERENCES `Franchise` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Franchise_has_User_User1`
    FOREIGN KEY (`idUser`)
    REFERENCES `User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Interview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Interview` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `idJobSearch` INT NOT NULL,
  `idPostulantUser` INT NOT NULL,
  `idPostulantOwnerUser` INT NULL,
  `startDate` DATETIME NULL,
  `endDate` DATETIME NULL,
  `notes` VARCHAR(255) NULL,
  `code` VARCHAR(255) NOT NULL COMMENT 'El code permite que se le genere a los participantes un link\n ',
  `state` VARCHAR(45) NOT NULL COMMENT 'postulated/scheduled/interviewed/approved/ready',
  PRIMARY KEY (`id`),
  INDEX `fk_Interview_JobSearch1_idx` (`idJobSearch` ASC),
  INDEX `fk_Interview_Postulant1_idx` (`idJobSearch` ASC, `idPostulantUser` ASC),
  INDEX `fk_Interview_User1_idx` (`idPostulantOwnerUser` ASC),
  UNIQUE INDEX `code_UNIQUE` (`code` ASC),
  CONSTRAINT `fk_Interview_JobSearch1`
    FOREIGN KEY (`idJobSearch`)
    REFERENCES `JobSearch` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Interview_Postulant1`
    FOREIGN KEY (`idJobSearch` , `idPostulantUser`)
    REFERENCES `JobSearchCandidates` (`idJobSearch` , `idPostulantUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Interview_User1`
    FOREIGN KEY (`idPostulantOwnerUser`)
    REFERENCES `User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AssociateRecruiter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AssociateRecruiter` (
  `idJobSearch` INT NOT NULL,
  `idUser` INT NOT NULL,
  `state` VARCHAR(45) NULL COMMENT 'pending/approved/rejected',
  PRIMARY KEY (`idJobSearch`, `idUser`),
  INDEX `fk_JobSearch_has_User_User2_idx` (`idUser` ASC),
  INDEX `fk_JobSearch_has_User_JobSearch2_idx` (`idJobSearch` ASC),
  CONSTRAINT `fk_JobSearch_has_User_JobSearch2`
    FOREIGN KEY (`idJobSearch`)
    REFERENCES `JobSearch` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_JobSearch_has_User_User2`
    FOREIGN KEY (`idUser`)
    REFERENCES `User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WorkingHour`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WorkingHour` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `weekdayCode` VARCHAR(45) NOT NULL,
  `startTime` SMALLINT NOT NULL COMMENT '0000 - 2359',
  `endTime` SMALLINT NOT NULL COMMENT '0000 - 2359',
  `idUser` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_WorkingHour_User1_idx` (`idUser` ASC),
  CONSTRAINT `fk_WorkingHour_User1`
    FOREIGN KEY (`idUser`)
    REFERENCES `User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EducationalInstitution`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EducationalInstitution` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(1024) NOT NULL,
  `idLocation` int(11) NULL,
  PRIMARY KEY (`id`),
  KEY `fk_v_Location1_idx` (`idLocation`),
  CONSTRAINT `fk_EducationalInstitution_Location1`
   FOREIGN KEY (`idLocation`) 
   REFERENCES `Location` (`id`) 
  ON DELETE NO ACTION 
  ON UPDATE NO ACTION) 
ENGINE=InnoDB;


-- -----------------------------------------------------
-- Table `UserSkills`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `UserSkills` (
  `idUser` INT NOT NULL,
  `idSkill` INT NOT NULL,
  `level` TINYINT NULL,
  PRIMARY KEY (`idUser`, `idSkill`),
  INDEX `fk_User_has_Skill_Skill1_idx` (`idSkill` ASC),
  INDEX `fk_User_has_Skill_User1_idx` (`idUser` ASC),
  CONSTRAINT `fk_User_has_Skill_User1`
    FOREIGN KEY (`idUser`)
    REFERENCES `User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_has_Skill_Skill1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `Skill` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JobSearchSkills`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JobSearchSkills` (
  `idJobSearch` INT NOT NULL,
  `idSkill` INT NOT NULL,
  `type` VARCHAR(45) NULL,
  PRIMARY KEY (`idJobSearch`, `idSkill`),
  INDEX `fk_JobSearch_has_Skill_Skill1_idx` (`idSkill` ASC),
  INDEX `fk_JobSearch_has_Skill_JobSearch1_idx` (`idJobSearch` ASC),
  CONSTRAINT `fk_JobSearch_has_Skill_JobSearch1`
    FOREIGN KEY (`idJobSearch`)
    REFERENCES `JobSearch` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_JobSearch_has_Skill_Skill1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `Skill` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
