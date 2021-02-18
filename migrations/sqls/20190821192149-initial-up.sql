-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema API-database
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `Location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Location` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(45) NOT NULL,
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
  `type` VARCHAR(45) NULL COMMENT 'Type: recruiter/aspirant/admin',
  `createdAt` DATETIME NOT NULL,
  `state` VARCHAR(45) NOT NULL,
  `profileDescription` JSON NULL COMMENT 'es el perfil completo del usuario\n',
  `profilePicture` VARCHAR(255) NULL,
  `idLocation` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_User_Location1_idx` (`idLocation` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  CONSTRAINT `fk_User_Location1`
    FOREIGN KEY (`idLocation`)
    REFERENCES `Location` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AccessToken`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AccessToken` (
  `id` VARCHAR(64) NOT NULL COMMENT 'the id is the token given to the user for access ',
  `ttl` INT NULL COMMENT 'TTL in milliseconds',
  `idUser` INT NOT NULL,
  `createdAt` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_AccessToken_User_idx` (`idUser` ASC),
  CONSTRAINT `fk_AccessToken_User`
    FOREIGN KEY (`idUser`)
    REFERENCES `User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Company` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `address` VARCHAR(45) NULL,
  `point` POINT NULL,
  `idLocation` INT NOT NULL,
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
  `createdAt` DATETIME NOT NULL,
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
  `description` VARCHAR(25) NULL,
  `idParentSkill` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Skill_Skill1_idx` (`idParentSkill` ASC),
  CONSTRAINT `fk_Skill_Skill1`
    FOREIGN KEY (`idParentSkill`)
    REFERENCES `Skill` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JobSearchCandidates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JobSearchCandidates` (
  `idJobSearch` INT NOT NULL,
  `idPostulantUser` INT NOT NULL,
  `postulatedAt` DATETIME NOT NULL,
  `state` VARCHAR(45) NOT NULL COMMENT 'postulated/scheduled/interviewed/approved/ready',
  `idPostulantOwnerUser` INT NULL,
  `expectedSalary` DECIMAL NULL,
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


-- -----------------------------------------------------
-- Table `FranchiseUsers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FranchiseUsers` (
  `idFranchise` INT NOT NULL,
  `idUser` INT NOT NULL,
  `state` VARCHAR(45) NULL,
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
  `idPostulantOwnerUser` INT NOT NULL,
  `startDate` DATETIME NOT NULL,
  `endDate` DATETIME NOT NULL,
  `notes` VARCHAR(255) NULL,
  `code` VARCHAR(45) NOT NULL COMMENT 'El code permite que se le genere a los participantes un link\n ',
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
