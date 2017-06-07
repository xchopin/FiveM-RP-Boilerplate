-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Client :  127.0.0.1
-- Généré le :  Mar 06 Juin 2017 à 11:51
-- Version du serveur :  5.7.14
-- Version de PHP :  7.0.10

-- github.com/xchopin

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `gta5_gamemode_essential`
--

-- --------------------------------------------------------

--
-- Structure de la table `bans`
--

CREATE TABLE `bans` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `banned` varchar(50) NOT NULL DEFAULT '0',
  `banner` varchar(50) NOT NULL,
  `reason` varchar(150) NOT NULL DEFAULT '0',
  `expires` datetime NOT NULL,
  `timestamp` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- --------------------------------------------------------

--
-- Structure de la table `coordinates`
--

CREATE TABLE `coordinates` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `x` double DEFAULT NULL,
  `y` double DEFAULT NULL,
  `z` double DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `coordinates`
--

INSERT INTO `coordinates` (`id`, `x`, `y`, `z`, `name`) VALUES
(1, 2681.752, 2800.187, 40.36, 'Mines du vieux Los Santos'),
(2, 1077.64, -1989.417, 30.883, 'Fonte des métaux'),
(3, -510.449, -2751.847, 6.2, 'Vente du fer'),
(7, -801.323, 5403.05, 34.0766, 'Récolte bois'),
(8, -555.881, 5319.96, 73.5997, 'Traitement bois'),
(9, -473.829, -985.232, 23.5457, 'Vente du bois'),
(10, -1813.25, 2105.58, 135.808, 'Vignobles'),
(11, 823.7, 2193.76, 52.0271, 'Atelier du vin'),
(12, -561.508, 302.273, 82.6591, 'Vente du vin'),
(13, 2217.01, 5577.23, 53.8241, 'Récolte weed'),
(14, -1674.55, -1069.29, 13.1529, 'Traitement weed'),
(15, 485.292, -3382.2, 6.06991, 'Vente weed');

-- --------------------------------------------------------

--
-- Structure de la table `items`
--

CREATE TABLE `items` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) DEFAULT NULL,
  `isIllegal` tinyint(1) NOT NULL DEFAULT '0',
  `food` varchar(255) NOT NULL DEFAULT '0',
  `water` varchar(255) NOT NULL DEFAULT '0',
  `needs` varchar(255) NOT NULL DEFAULT '0',
  `limitation` int(11) DEFAULT '15',
  `type` varchar(255) NOT NULL DEFAULT 'object'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `items`
--

INSERT INTO `items` (`id`, `libelle`, `isIllegal`, `food`, `water`, `needs`, `limitation`, `type`) VALUES
(1, 'Pierre', 0, '0', '0', '0', NULL, 'object'),
(3, 'Minerais de fer', 0, '0', '0', '0', NULL, 'object'),
(6, 'Fer', 0, '0', '0', '0', NULL, 'object'),
(7, 'Diamant', 0, '0', '0', '0', NULL, 'object'),
(30, 'Burger', 0, '30', '0', '0', NULL, 'food'),
(31, 'Coca-Cola', 0, '5', '20', '0', NULL, 'drink'),
(32, 'Morceaux de bois', 0, '0', '0', '0', 15, 'object'),
(33, 'Planches', 0, '0', '0', '0', 15, 'object'),
(34, 'Raisins', 0, '5', '5', '0', 15, 'food'),
(36, 'Vin en cubi', 0, '0', '0', '0', 15, 'object'),
(37, 'Feuilles de chanvre', 1, '0', '0', '0', 15, 'object'),
(38, 'Marijuana', 1, '0', '0', '0', 15, 'object');

-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

CREATE TABLE `jobs` (
  `job_id` int(11) NOT NULL,
  `job_name` varchar(40) NOT NULL,
  `salary` int(11) NOT NULL DEFAULT '500',
  `whitelisted` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `jobs`
--

INSERT INTO `jobs` (`job_id`, `job_name`, `salary`, `whitelisted`) VALUES
(1, 'Chômeur', 200, 0),
(2, 'LSPD (Cadet)', 450, 1),
(3, 'LSPD (Officier)', 750, 1),
(4, 'LSPD (Sergent)', 1000, 1),
(5, 'LSPD (Commandant)', 1600, 1),
(6, 'CHU (Interne)', 400, 1),
(7, 'CHU (Médecin)', 850, 1),
(8, 'CHU (Chef de service)', 900, 1),
(9, 'CHU (Directeur)', 2700, 1),
(10, 'GSPR 1', 2200, 1),
(11, 'GSPR 2', 3200, 1),
(12, 'GSPR 3', 4800, 1),
(13, 'Gouverneur', 5000, 1),
(14, 'Ministre de l\'Économie', 3000, 1),
(15, 'Ministre de l\'Intérieur', 3000, 1),
(16, 'Ministre de la Communication', 3000, 1),
(17, 'Bûcheron', 90, 0),
(18, 'Viticulteur', 75, 0),
(19, 'Mineur', 75, 0),
(20, 'Illegal', 0, 0),
(21, 'Livreur', 75, 0),
(22, 'Taxi', 90, 0),
(23, 'Juge', 1300, 1),
(24, 'Avocat', 1000, 1);

-- --------------------------------------------------------

--
-- Structure de la table `licences`
--

CREATE TABLE `licences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `licences`
--

INSERT INTO `licences` (`id`, `name`, `price`) VALUES
(1, 'De conduire', 1000),
(2, 'De port d\'arme', 5000);



-- --------------------------------------------------------

--
-- Structure de la table `recolt`
--

CREATE TABLE `recolt` (
  `ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `raw_id` int(11) UNSIGNED DEFAULT NULL,
  `treated_id` int(11) UNSIGNED DEFAULT NULL,
  `job_id` int(11) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `field_id` int(10) UNSIGNED DEFAULT NULL,
  `treatment_id` int(10) UNSIGNED DEFAULT NULL,
  `seller_id` int(10) UNSIGNED DEFAULT NULL,
  `nom` varchar(255) DEFAULT NULL,
  `isIllegal` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `recolt`
--

INSERT INTO `recolt` (`ID`, `raw_id`, `treated_id`, `job_id`, `price`, `field_id`, `treatment_id`, `seller_id`, `nom`, `isIllegal`) VALUES
(4, 1, 3, 19, 40, 1, 2, 3, 'Mineur', 0),
(5, 32, 33, 17, 55, 7, 8, 9, 'Bucheron', 0),
(6, 34, 36, 18, 40, 10, 11, 12, 'Viticulteur', 0),
(7, 37, 38, 1, 95, 13, 14, 15, 'Weed', 1);

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL DEFAULT '',
  `player_state` int(255) NOT NULL DEFAULT '0',
  `group` varchar(50) NOT NULL DEFAULT '0',
  `permission_level` int(11) NOT NULL DEFAULT '0',
  `money` double NOT NULL DEFAULT '0',
  `dirty_money` double NOT NULL DEFAULT '0',
  `bankbalance` int(32) DEFAULT '0',
  `job` int(11) DEFAULT '1',
  `lastpos` varchar(255) DEFAULT '{241.609985351563, -877.769958496094,  30.4920997619629, 0}',
  `personalvehicle` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT 'github.com/xchopin',
  `isFirstConnection` int(11) DEFAULT '1',
  `food` double NOT NULL DEFAULT '100',
  `water` double NOT NULL DEFAULT '100',
  `needs` double NOT NULL DEFAULT '0',
  `enService` tinyint(4) NOT NULL DEFAULT '0',
  `phone_number` varchar(255) DEFAULT 'none'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



--
-- Structure de la table `user_clothes`
--

CREATE TABLE `user_clothes` (
  `identifier` varchar(150) NOT NULL,
  `skin` varchar(255) NOT NULL DEFAULT 'mp_m_freemode_01',
  `face` varchar(255) NOT NULL DEFAULT '0',
  `face_texture` varchar(255) NOT NULL DEFAULT '0',
  `hair` varchar(255) NOT NULL DEFAULT '11',
  `hair_texture` varchar(255) NOT NULL DEFAULT '4',
  `shirt` varchar(255) NOT NULL DEFAULT '0',
  `shirt_texture` varchar(255) NOT NULL DEFAULT '0',
  `pants` varchar(255) NOT NULL DEFAULT '8',
  `pants_texture` varchar(255) NOT NULL DEFAULT '0',
  `shoes` varchar(255) NOT NULL DEFAULT '1',
  `shoes_texture` varchar(255) NOT NULL DEFAULT '0',
  `vest` varchar(255) NOT NULL DEFAULT '0',
  `vest_texture` varchar(255) NOT NULL DEFAULT '0',
  `bag` varchar(255) NOT NULL DEFAULT '40',
  `bag_texture` varchar(255) NOT NULL DEFAULT '0',
  `hat` varchar(255) NOT NULL DEFAULT '1',
  `hat_texture` varchar(255) NOT NULL DEFAULT '1',
  `mask` varchar(255) NOT NULL DEFAULT '0',
  `mask_texture` varchar(255) NOT NULL DEFAULT '0',
  `glasses` varchar(255) NOT NULL DEFAULT '6',
  `glasses_texture` varchar(255) NOT NULL DEFAULT '0',
  `gloves` varchar(255) NOT NULL DEFAULT '2',
  `gloves_texture` varchar(255) NOT NULL DEFAULT '0',
  `jacket` varchar(255) NOT NULL DEFAULT '7',
  `jacket_texture` varchar(255) NOT NULL DEFAULT '2',
  `ears` varchar(255) NOT NULL DEFAULT '1',
  `ears_texture` varchar(255) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Structure de la table `user_inventory`
--

CREATE TABLE `user_inventory` (
  `user_id` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `item_id` int(11) UNSIGNED NOT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Structure de la table `user_licence`
--

CREATE TABLE `user_licence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `licence_id` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Structure de la table `user_message`
--

CREATE TABLE `user_message` (
  `owner_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT 'Inconnu',
  `msg` varchar(255) NOT NULL,
  `date` varchar(255) DEFAULT '01/01/1970',
  `has_read` int(11) NOT NULL DEFAULT '0',
  `receiver_id` varchar(255) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



-- --------------------------------------------------------

--
-- Structure de la table `user_phonelist`
--

CREATE TABLE `user_phonelist` (
  `contact_id` varchar(255) NOT NULL,
  `owner_id` varchar(255) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT 'Contact'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



--
-- Structure de la table `user_vehicle`
--

CREATE TABLE `user_vehicle` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `vehicle_name` varchar(60) DEFAULT NULL,
  `vehicle_model` varchar(60) DEFAULT NULL,
  `vehicle_plate` varchar(60) DEFAULT NULL,
  `vehicle_state` varchar(60) DEFAULT NULL,
  `vehicle_colorprimary` varchar(60) DEFAULT NULL,
  `vehicle_colorsecondary` varchar(60) DEFAULT NULL,
  `vehicle_pearlescentcolor` varchar(60) NOT NULL,
  `vehicle_wheelcolor` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



--
-- Structure de la table `user_weapons`
--

CREATE TABLE `user_weapons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `weapon_model` varchar(255) NOT NULL,
  `withdraw_cost` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Structure de la table `user_whitelist`
--

CREATE TABLE `user_whitelist` (
  `identifier` varchar(255) NOT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--

--
-- Structure de la table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` int(255) NOT NULL,
  `model` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `vehicles`
--

INSERT INTO `vehicles` (`id`, `name`, `price`, `model`) VALUES
(1, 'Blista', 15000, 'blista'),
(2, 'Brioso R/A', 155000, 'brioso'),
(3, 'Dilettante', 25000, 'Dilettante'),
(4, 'Issi', 18000, 'issi2'),
(5, 'Panto', 85000, 'panto'),
(6, 'Prairie', 30000, 'prairie'),
(7, 'Rhapsody', 120000, 'rhapsody'),
(8, 'Cognoscenti Cabrio', 180000, 'cogcabrio'),
(9, 'Exemplar', 200000, 'exemplar'),
(10, 'F620', 80000, 'f620'),
(11, 'Felon', 90000, 'felon'),
(12, 'Felon GT', 95000, 'felon2'),
(13, 'Jackal', 60000, 'jackal'),
(14, 'Oracle', 80000, 'oracle'),
(15, 'Oracle XS', 82000, 'oracle2'),
(16, 'Sentinel', 90000, 'sentinel'),
(17, 'Sentinel XS', 60000, 'sentinel2'),
(18, 'Windsor', 800000, 'windsor'),
(19, 'Windsor Drop', 850000, 'windsor2'),
(20, 'Zion', 60000, 'zion'),
(21, 'Zion Cabrio', 65000, 'zion2'),
(22, '9F', 120000, 'ninef'),
(23, '9F Cabrio', 130000, 'ninef2'),
(24, 'Alpha', 150000, 'alpha'),
(25, 'Banshee', 105000, 'banshee'),
(26, 'Bestia GTS', 610000, 'bestiagts'),
(27, 'Blista Compact', 42000, 'blista'),
(28, 'Buffalo', 35000, 'buffalo'),
(29, 'Buffalo S', 96000, 'buffalo2'),
(30, 'Carbonizzare', 195000, 'carbonizzare'),
(31, 'Comet', 100000, 'comet2'),
(32, 'Coquette', 138000, 'coquette'),
(33, 'Drift Tampa', 995000, 'tampa2'),
(34, 'Feltzer', 130000, 'feltzer2'),
(35, 'Furore GT', 448000, 'furoregt'),
(36, 'Fusilade', 36000, 'fusilade'),
(37, 'Jester', 240000, 'jester'),
(38, 'Jester(Racecar)', 350000, 'jester2'),
(39, 'Kuruma', 95000, 'kuruma'),
(40, 'Lynx', 1735000, 'lynx'),
(41, 'Massacro', 275000, 'massacro'),
(42, 'Massacro(Racecar)', 385000, 'massacro2'),
(43, 'Omnis', 701000, 'omnis'),
(44, 'Penumbra', 24000, 'penumbra'),
(45, 'Rapid GT', 140000, 'rapidgt'),
(46, 'Rapid GT Convertible', 150000, 'rapidgt2'),
(47, 'Schafter V12', 140000, 'schafter3'),
(48, 'Sultan', 12000, 'sultan'),
(49, 'Surano', 110000, 'surano'),
(50, 'Tropos', 816000, 'tropos'),
(51, 'Verkierer', 695000, 'verlierer2'),
(52, 'Casco', 680000, 'casco'),
(53, 'Coquette Classic', 665000, 'coquette2'),
(54, 'JB 700', 350000, 'jb700'),
(55, 'Pigalle', 400000, 'pigalle'),
(56, 'Stinger', 850000, 'stinger'),
(57, 'Stinger GT', 875000, 'stingergt'),
(58, 'Stirling GT', 975000, 'feltzer3'),
(59, 'Z-Type', 950000, 'ztype'),
(60, 'Adder', 1000000, 'adder'),
(61, 'Banshee 900R', 565000, 'banshee2'),
(62, 'Bullet', 155000, 'bullet'),
(63, 'Cheetah', 650000, 'cheetah'),
(64, 'Entity XF', 795000, 'entityxf'),
(65, 'ETR1', 199500, 'sheava'),
(66, 'FMJ', 1750000, 'fmj'),
(67, 'Infernus', 440000, 'infernus'),
(68, 'Osiris', 1950000, 'osiris'),
(69, 'RE-7B', 2475000, 'le7b'),
(70, 'Reaper', 1595000, 'reaper'),
(71, 'Sultan RS', 795000, 'sultanrs'),
(72, 'T20', 2200000, 't20'),
(73, 'Turismo R', 500000, 'turismor'),
(74, 'Tyrus', 2550000, 'tyrus'),
(75, 'Vacca', 240000, 'vacca'),
(76, 'Voltic', 150000, 'voltic'),
(77, 'X80 Proto', 2700000, 'prototipo'),
(78, 'Zentorno', 725000, 'zentorno'),
(79, 'Blade', 160000, 'blade'),
(80, 'Buccaneer', 29000, 'buccaneer'),
(81, 'Chino', 225000, 'chino'),
(82, 'Coquette BlackFin', 695000, 'coquette3'),
(83, 'Dominator', 35000, 'dominator'),
(84, 'Dukes', 62000, 'dukes'),
(85, 'Gauntlet', 32000, 'gauntlet'),
(86, 'Hotknife', 90000, 'hotknife'),
(87, 'Faction', 36000, 'faction'),
(88, 'Nightshade', 585000, 'nightshade'),
(89, 'Picador', 9000, 'picador'),
(90, 'Sabre Turbo', 15000, 'sabregt'),
(91, 'Tampa', 375000, 'tampa'),
(92, 'Virgo', 195000, 'virgo'),
(93, 'Vigero', 21000, 'vigero'),
(94, 'Bifta', 75000, 'bifta'),
(95, 'Blazer', 8000, 'blazer'),
(96, 'Brawler', 715000, 'brawler'),
(97, 'Bubsta 6x6', 249000, 'dubsta3'),
(98, 'Dune Buggy', 20000, 'dune'),
(99, 'Rebel', 22000, 'rebel2'),
(100, 'Sandking', 38000, 'sandking'),
(101, 'The Liberator', 550000, 'monster'),
(102, 'Trophy Truck', 550000, 'trophytruck'),
(103, 'Baller', 90000, 'baller'),
(104, 'Cavalcade', 60000, 'cavalcade'),
(105, 'Grabger', 35000, 'granger'),
(106, 'Huntley S', 195000, 'huntley'),
(107, 'Landstalker', 58000, 'landstalker'),
(108, 'Radius', 32000, 'radi'),
(109, 'Rocoto', 85000, 'rocoto'),
(110, 'Seminole', 30000, 'seminole'),
(111, 'XLS', 253000, 'xls'),
(112, 'Bison', 30000, 'bison'),
(113, 'Bobcat XL', 23000, 'bobcatxl'),
(114, 'Gang Burrito', 65000, 'gburrito'),
(115, 'Journey', 15000, 'journey'),
(116, 'Minivan', 30000, 'minivan'),
(117, 'Paradise', 25000, 'paradise'),
(118, 'Rumpo', 13000, 'rumpo'),
(119, 'Surfer', 11000, 'surfer'),
(120, 'Youga', 16000, 'youga'),
(121, 'Asea', 1000000, 'asea'),
(122, 'Asterope', 1000000, 'asterope'),
(123, 'Fugitive', 24000, 'fugitive'),
(124, 'Glendale', 200000, 'glendale'),
(125, 'Ingot', 9000, 'ingot'),
(126, 'Intruder', 16000, 'intruder'),
(127, 'Premier', 10000, 'premier'),
(128, 'Primo', 9000, 'primo'),
(129, 'Primo Custom', 9500, 'primo2'),
(130, 'Regina', 8000, 'regina'),
(131, 'Schafter', 65000, 'schafter2'),
(132, 'Stanier', 10000, 'stanier'),
(133, 'Stratum', 10000, 'stratum'),
(134, 'Stretch', 30000, 'stretch'),
(135, 'Super Diamond', 250000, 'superd'),
(136, 'Surge', 38000, 'surge'),
(137, 'Tailgater', 55000, 'tailgater'),
(138, 'Warrener', 120000, 'warrener'),
(139, 'Washington', 15000, 'washington'),
(140, 'Akuma', 9000, 'AKUMA'),
(141, 'Bagger', 5000, 'bagger'),
(142, 'Bati 801', 15000, 'bati'),
(143, 'Bati 801RR', 15000, 'bati2'),
(144, 'BF400', 95000, 'bf400'),
(145, 'Carbon RS', 40000, 'carbonrs'),
(146, 'Cliffhanger', 225000, 'cliffhanger'),
(147, 'Daemon', 5000, 'daemon'),
(148, 'Double T', 12000, 'double'),
(149, 'Enduro', 48000, 'enduro'),
(150, 'Faggio', 4000, 'faggio2'),
(151, 'Gargoyle', 120000, 'gargoyle'),
(152, 'Hakuchou', 82000, 'hakuchou'),
(153, 'Hexer', 15000, 'hexer'),
(154, 'Innovation', 90000, 'innovation'),
(155, 'Lectro', 700000, 'lectro'),
(156, 'Nemesis', 12000, 'nemesis'),
(157, 'PCJ-600', 9000, 'pcj'),
(158, 'Ruffian', 9000, 'ruffian'),
(159, 'Sanchez', 7000, 'sanchez'),
(160, 'Sovereign', 90000, 'sovereign'),
(161, 'Thrust', 75000, 'thrust'),
(162, 'Vader', 9000, 'vader'),
(163, 'Vindicator', 600000, 'vindicator');

--
-- Index pour les tables exportées
--

--
-- Index pour la table `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `coordinates`
--
ALTER TABLE `coordinates`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`job_id`);

--
-- Index pour la table `licences`
--
ALTER TABLE `licences`
  ADD PRIMARY KEY (`id`);


--
-- Index pour la table `recolt`
--
ALTER TABLE `recolt`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `raw_id` (`raw_id`),
  ADD KEY `treated_id` (`treated_id`),
  ADD KEY `job_id` (`job_id`),
  ADD KEY `field_id` (`field_id`),
  ADD KEY `treatment_id` (`treatment_id`),
  ADD KEY `seller_id` (`seller_id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`identifier`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Index pour la table `user_clothes`
--
ALTER TABLE `user_clothes`
  ADD PRIMARY KEY (`identifier`);

--
-- Index pour la table `user_inventory`
--
ALTER TABLE `user_inventory`
  ADD PRIMARY KEY (`user_id`,`item_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Index pour la table `user_licence`
--
ALTER TABLE `user_licence`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `user_message`
--
ALTER TABLE `user_message`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `user_phonelist`
--
ALTER TABLE `user_phonelist`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `user_vehicle`
--
ALTER TABLE `user_vehicle`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `fk_user_vehicle` (`identifier`);

--
-- Index pour la table `user_weapons`
--
ALTER TABLE `user_weapons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_weapon` (`identifier`);

--
-- Index pour la table `user_whitelist`
--
ALTER TABLE `user_whitelist`
  ADD PRIMARY KEY (`identifier`);

--
-- Index pour la table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;
--
-- AUTO_INCREMENT pour la table `coordinates`
--
ALTER TABLE `coordinates`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT pour la table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;
--
-- AUTO_INCREMENT pour la table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `job_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
--
-- AUTO_INCREMENT pour la table `licences`
--
ALTER TABLE `licences`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `recolt`
--
ALTER TABLE `recolt`
  MODIFY `ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;
--
-- AUTO_INCREMENT pour la table `user_licence`
--
ALTER TABLE `user_licence`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;
--
-- AUTO_INCREMENT pour la table `user_message`
--
ALTER TABLE `user_message`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=537;
--
-- AUTO_INCREMENT pour la table `user_phonelist`
--
ALTER TABLE `user_phonelist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=175;
--
-- AUTO_INCREMENT pour la table `user_vehicle`
--
ALTER TABLE `user_vehicle`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;
--
-- AUTO_INCREMENT pour la table `user_weapons`
--
ALTER TABLE `user_weapons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;
--
-- AUTO_INCREMENT pour la table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=164;
--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `recolt`
--
ALTER TABLE `recolt`
  ADD CONSTRAINT `recolt_ibfk_1` FOREIGN KEY (`raw_id`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `recolt_ibfk_2` FOREIGN KEY (`treated_id`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `recolt_ibfk_3` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`),
  ADD CONSTRAINT `recolt_ibfk_4` FOREIGN KEY (`field_id`) REFERENCES `coordinates` (`id`),
  ADD CONSTRAINT `recolt_ibfk_5` FOREIGN KEY (`treatment_id`) REFERENCES `coordinates` (`id`),
  ADD CONSTRAINT `recolt_ibfk_6` FOREIGN KEY (`seller_id`) REFERENCES `coordinates` (`id`);

--
-- Contraintes pour la table `user_clothes`
--
ALTER TABLE `user_clothes`
  ADD CONSTRAINT `fk_user_clothes` FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON DELETE CASCADE;

--
-- Contraintes pour la table `user_inventory`
--
ALTER TABLE `user_inventory`
  ADD CONSTRAINT `user_inventory_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`);

--
-- Contraintes pour la table `user_vehicle`
--
ALTER TABLE `user_vehicle`
  ADD CONSTRAINT `fk_user_vehicle` FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON DELETE CASCADE;

--
-- Contraintes pour la table `user_weapons`
--
ALTER TABLE `user_weapons`
  ADD CONSTRAINT `fk_user_weapon` FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
