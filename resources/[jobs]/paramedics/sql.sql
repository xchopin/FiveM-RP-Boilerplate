USE gta5_gamemode_essential;

CREATE TABLE IF NOT EXISTS `jobs` (
  `job_id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(40) NOT NULL,
  `salary` int(11) NOT NULL DEFAULT '500',
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `users` (
  `identifier` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `group` varchar(50) NOT NULL DEFAULT '0',
  `permission_level` int(11) NOT NULL DEFAULT '0',
  `money` double NOT NULL DEFAULT '0',
  `bankbalance` int(32) DEFAULT '0',
  `job` int(11) DEFAULT '1',
  `lastpos` varchar(255) DEFAULT '{-1044.99914550781,-2749.8173828125,21.3634204864502}',
  `personalvehicle` varchar(60) DEFAULT NULL,
  `isFirstConnection` int(11) DEFAULT '1',
  `nom` varchar(128) NOT NULL DEFAULT '',
  `prenom` varchar(128) NOT NULL DEFAULT '',
  `dateNaissance` date DEFAULT '0000-01-01',
  `sexe` varchar(1) NOT NULL DEFAULT 'f',
  `taille` int(10) unsigned NOT NULL DEFAULT '0',
  `enService` boolean NOT NULL DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE users ADD `JOB` int(11) DEFAULT '1';

INSERT INTO `jobs` (`job_id`, `job_name`, `salary`) VALUES (11, 'Ambulancier', 1200);

UPDATE users SET job = 11 WHERE identifier = 'steam:';

ALTER TABLE users ADD `enService` boolean NOT NULL DEFAULT FALSE;
