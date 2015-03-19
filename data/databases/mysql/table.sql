CREATE TABLE `user_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL,
  `uuid` varchar(45) DEFAULT NULL,
  `channel` int(11) DEFAULT NULL,
  `device` varchar(45) DEFAULT NULL,
  `register_time` timestamp NULL DEFAULT NULL,
  `login_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
