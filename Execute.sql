CREATE TABLE IF NOT EXISTS `ricky_bossmenu` (
  `identifier` varchar(100) NOT NULL DEFAULT '',
  `job` longtext DEFAULT NULL,
  `hireDate` longtext DEFAULT NULL,
  `playTime` longtext DEFAULT NULL,
  `note` longtext DEFAULT NULL,
  `hiredFrom` longtext DEFAULT NULL,
  `noteUpdate` longtext DEFAULT NULL,
  `avatar` longtext DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS `ricky_bossmenu_society` (
  `job` varchar(50) NOT NULL DEFAULT '',
  `money` longtext NOT NULL,
  PRIMARY KEY (`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
