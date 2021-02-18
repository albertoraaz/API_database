
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

/* Replace with your SQL commands */
DROP TABLE IF EXISTS `Location` ;

-- -----------------------------------------------------
-- Table `User`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `User` ;

-- -----------------------------------------------------
-- Table `AccessToken`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AccessToken` ;

-- -----------------------------------------------------
-- Table `Company`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Company` ;

-- -----------------------------------------------------
-- Table `JobSearch`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `JobSearch` ;


-- -----------------------------------------------------
-- Table `Skill`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skill` ;


-- -----------------------------------------------------
-- Table `Postulant`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Postulant` ;

-- -----------------------------------------------------
-- Table `Franchise`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Franchise` ;



-- -----------------------------------------------------
-- Table `Recruiter`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Recruiter` ;

-- -----------------------------------------------------
-- Table `Interview`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Interview` ;

-- -----------------------------------------------------
-- Table `AssociateRecruiter`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AssociateRecruiter` ;


-- -----------------------------------------------------
-- Table `WorkingHour`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `WorkingHour` ;


-- -----------------------------------------------------
-- Table `UserSkills`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `UserSkills` ;

-- -----------------------------------------------------
-- Table `JobSearchSkills`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `JobSearchSkills` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
