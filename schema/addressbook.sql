SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `decodemtl_addressbook` ;
CREATE SCHEMA IF NOT EXISTS `decodemtl_addressbook` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `decodemtl_addressbook` ;

-- -----------------------------------------------------
-- Table `decodemtl_addressbook`.`Account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decodemtl_addressbook`.`Account` ;

CREATE TABLE IF NOT EXISTS `decodemtl_addressbook`.`Account` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(40) NOT NULL,
  `createdOn` DATETIME NOT NULL,
  `modifiedOn` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_unique` (`email` ASC),
  INDEX `authentication_idx` (`email` ASC, `password` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `decodemtl_addressbook`.`AddressBook`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decodemtl_addressbook`.`AddressBook` ;

CREATE TABLE IF NOT EXISTS `decodemtl_addressbook`.`AddressBook` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `accountId` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `createdOn` DATETIME NOT NULL,
  `modifiedOn` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `accountId_foreign_index` (`accountId` ASC),
  CONSTRAINT `accountId_foreign`
    FOREIGN KEY (`accountId`)
    REFERENCES `decodemtl_addressbook`.`Account` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `decodemtl_addressbook`.`Entry`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decodemtl_addressbook`.`Entry` ;

CREATE TABLE IF NOT EXISTS `decodemtl_addressbook`.`Entry` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `addressBookId` INT NOT NULL,
  `firstName` VARCHAR(255) NOT NULL,
  `lastName` VARCHAR(255) NULL,
  `birthday` DATETIME NULL,
  `type` ENUM('phone', 'address', 'electronic-mail') NOT NULL,
  PRIMARY KEY (`id`),
  -- INDEX `type_index` (),
  INDEX `addressBookId_foreign_index` (`addressBookId` ASC),
  CONSTRAINT `addressBookId_foreign`
    FOREIGN KEY (`addressBookId`)
    REFERENCES `decodemtl_addressbook`.`AddressBook` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `decodemtl_addressbook`.`ElectronicMail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decodemtl_addressbook`.`ElectronicMail` ;

CREATE TABLE IF NOT EXISTS `decodemtl_addressbook`.`ElectronicMail` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `entryId` INT NOT NULL,
  `type` ENUM('home', 'work', 'other') NOT NULL,
  `content` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `entryId_foreign_index` (`entryId` ASC),
  CONSTRAINT `entryId_foreign`
    FOREIGN KEY (`entryId`)
    REFERENCES `decodemtl_addressbook`.`Entry` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `decodemtl_addressbook`.`Phone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decodemtl_addressbook`.`Phone` ;

CREATE TABLE IF NOT EXISTS `decodemtl_addressbook`.`Phone` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `entryId` INT NOT NULL,
  `type` ENUM('home', 'work', 'other') NOT NULL,
  `subtype` ENUM('landline', 'cellular', 'fax') NOT NULL,
  `content` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `entryId_foreign_index` (`entryId` ASC),
  INDEX `type_index` (`subtype` ASC),
  CONSTRAINT `entryId_foreign_phone`
    FOREIGN KEY (`entryId`)
    REFERENCES `decodemtl_addressbook`.`Entry` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `decodemtl_addressbook`.`Address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decodemtl_addressbook`.`Address` ;

CREATE TABLE IF NOT EXISTS `decodemtl_addressbook`.`Address` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `entryId` INT NOT NULL,
  `type` ENUM('home', 'work', 'other') NOT NULL,
  `addressLine1` VARCHAR(255) NOT NULL,
  `addressLine2` VARCHAR(255) NULL,
  `city` VARCHAR(255) NOT NULL,
  `province` VARCHAR(128) NOT NULL,
  `country` VARCHAR(128) NOT NULL,
  `postalCode` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `entryId_foreign_index` (`entryId` ASC),
  INDEX `province_index` (`province` ASC),
  INDEX `country_index` (`country` ASC),
  CONSTRAINT `entryId_foreign_address`
    FOREIGN KEY (`entryId`)
    REFERENCES `decodemtl_addressbook`.`Entry` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
