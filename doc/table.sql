CREATE TABLE `mhjong`.`game_user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `uid` INT NOT NULL,
  `uuid` VARCHAR(45) NULL,
  `device` VARCHAR(45) NULL,
  `channel` INT NULL,
  `nickname` VARCHAR(45) NULL,
  `password` VARCHAR(45) NULL,
  `systime` INT NULL,
  PRIMARY KEY (`id`, `uid`),
  UNIQUE INDEX `uid_UNIQUE` (`uid` ASC));
