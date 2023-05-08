-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mar. 11 avr. 2023 à 10:59
-- Version du serveur : 8.0.31
-- Version de PHP : 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `jvi`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `deleteParticulier`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteParticulier` (IN `p_tel` VARCHAR(10), IN `p_email` VARCHAR(50))   Begin
delete from particulier where tel = p_tel and email = p_email;
delete from client where tel = p_tel and email = p_email;
End$$

DROP PROCEDURE IF EXISTS `deleteProfessionnel`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteProfessionnel` (IN `p_tel` VARCHAR(10), IN `p_email` VARCHAR(50))   Begin
delete from professionnel where tel = p_tel and email = p_email;
delete from client where tel = p_tel and email = p_email;
End$$

DROP PROCEDURE IF EXISTS `insertParticulier`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertParticulier` (IN `p_nom` VARCHAR(30), IN `p_prenom` VARCHAR(30), IN `p_tel` VARCHAR(10), IN `p_email` VARCHAR(50), IN `p_mdp` VARCHAR(255), IN `p_adresse` VARCHAR(100), IN `p_cp` VARCHAR(5), IN `p_ville` VARCHAR(50), IN `p_pays` VARCHAR(50), IN `p_etat` ENUM("Prospect","Client actif","Client très actif"), IN `p_role` ENUM("client","admin"))   Begin
declare p_idclient int(11);
insert into client values (null, p_nom, p_tel, p_email, sha1(p_mdp), p_adresse, p_cp, p_ville, p_pays, p_etat, p_role, 0, 0, 0, 'Particulier', sysdate(), sysdate(), sysdate(), sysdate());
select idclient into p_idclient
from client
where tel = p_tel and email = p_email;
insert into particulier values (p_idclient, p_nom, p_prenom, p_tel, p_email, sha1(p_mdp), p_adresse, p_cp, p_ville, p_pays, p_etat, p_role, 0, 0, 0, 'Particulier', sysdate(), sysdate(), sysdate());
End$$

DROP PROCEDURE IF EXISTS `insertProfessionnel`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertProfessionnel` (IN `p_nom` VARCHAR(30), IN `p_tel` VARCHAR(10), IN `p_email` VARCHAR(50), IN `p_mdp` VARCHAR(255), IN `p_adresse` VARCHAR(100), IN `p_cp` VARCHAR(5), IN `p_ville` VARCHAR(50), IN `p_pays` VARCHAR(50), IN `p_numSIRET` VARCHAR(50), IN `p_statut` VARCHAR(30), IN `p_etat` ENUM("Prospect","Client actif","Client très actif"), IN `p_role` ENUM("client","admin"))   Begin
declare p_idclient int(11);
insert into client values (null, p_nom, p_tel, p_email, sha1(p_mdp), p_adresse, p_cp, p_ville, p_pays, p_etat, p_role, 0, 0, 0, 'Professionnel', sysdate(), sysdate(), sysdate(), sysdate());
select idclient into p_idclient
from client
where tel = p_tel and email = p_email;
insert into professionnel values (p_idclient, p_nom, p_tel, p_email, sha1(p_mdp), p_adresse, p_cp, p_ville, p_pays, p_numSIRET, p_statut, p_etat, p_role, 0, 0, 0, 'Professionnel', sysdate(), sysdate(), sysdate());
End$$

DROP PROCEDURE IF EXISTS `insertReponse`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertReponse` (IN `p_enonce` LONGTEXT, IN `p_reponse` TEXT, IN `p_email` VARCHAR(50), IN `p_mdp` VARCHAR(255))   Begin
declare p_idquestion int(11);
declare p_idclient int(11);

select idquestion into p_idquestion
from question
where enonce = p_enonce;

select idclient into p_idclient
from client
where email = p_email and mdp = sha1(p_mdp);

insert into reponse values (null, p_idquestion, p_reponse, p_idclient);
End$$

DROP PROCEDURE IF EXISTS `statsbdd`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `statsbdd` (`nomBdd` VARCHAR(60))   Begin
declare nbview, nbtrigger, nbprocedure, nbfunction int;

select count(*) into nbview 
from information_schema.views
where TABLE_SCHEMA = nomBdd;

select count(*) into nbtrigger
from information_schema.triggers
where TRIGGER_SCHEMA = nomBdd;

select count(*) into nbprocedure
from information_schema.ROUTINES
where ROUTINE_SCHEMA = nomBdd
and ROUTINE_TYPE = 'procedure';

select count(*) into nbfunction
from information_schema.ROUTINES
where ROUTINE_SCHEMA = nomBdd
and ROUTINE_TYPE = 'function';

insert into BDD values (nomBdd, nbview, nbtrigger, nbprocedure, nbfunction);
End$$

DROP PROCEDURE IF EXISTS `updateParticulier`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateParticulier` (IN `p_nom` VARCHAR(30), IN `p_prenom` VARCHAR(30), IN `p_tel` VARCHAR(10), IN `p_email` VARCHAR(50), IN `p_mdp` VARCHAR(255), IN `p_adresse` VARCHAR(100), IN `p_cp` VARCHAR(5), IN `p_ville` VARCHAR(50), IN `p_pays` VARCHAR(50), IN `p_etat` ENUM("Prospect","Client actif","Client très actif"), IN `p_role` ENUM("client","admin"), IN `p_bloque` INT, IN `p_nbConnexion` INT, IN `p_date_changement_mdp` DATETIME)   Begin
update client set nom = p_nom, tel = p_tel, email = p_email, mdp = sha1(p_mdp), adresse = p_adresse, cp = p_cp, ville = p_ville, pays = p_pays, etat = p_etat, role = p_role, bloque = p_bloque, nbConnexion = p_nbConnexion, date_dernier_changement_mdp = p_date_changement_mdp
where tel = p_tel and email = p_email;
update particulier set nom = p_nom, prenom = p_prenom, tel = p_tel, email = p_email, mdp = sha1(p_mdp), adresse = p_adresse, cp = p_cp, ville = p_ville, pays = p_pays, etat = p_etat, role = p_role, bloque = p_bloque, nbConnexion = p_nbConnexion, date_dernier_changement_mdp = p_date_changement_mdp
where tel = p_tel and email = p_email;
End$$

DROP PROCEDURE IF EXISTS `updateProfessionnel`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateProfessionnel` (IN `p_nom` VARCHAR(30), IN `p_tel` VARCHAR(10), IN `p_email` VARCHAR(50), IN `p_mdp` VARCHAR(255), IN `p_adresse` VARCHAR(100), IN `p_cp` VARCHAR(5), IN `p_ville` VARCHAR(50), IN `p_pays` VARCHAR(50), IN `p_statut` VARCHAR(30), IN `p_etat` ENUM("Prospect","Client actif","Client très actif"), IN `p_role` ENUM("client","admin"), IN `p_bloque` INT, IN `p_nbConnexion` INT, IN `p_date_changement_mdp` DATETIME)   Begin
update client set nom = p_nom, tel = p_tel, email = p_email, mdp = sha1(p_mdp), adresse = p_adresse, cp = p_cp, ville = p_ville, pays = p_pays, etat = p_etat, role = p_role, bloque = p_bloque, nbConnexion = p_nbConnexion, date_dernier_changement_mdp = p_date_changement_mdp
where tel = p_tel and email = p_email;
update professionnel set nom = p_nom, tel = p_tel, email = p_email, mdp = sha1(p_mdp), adresse = p_adresse, cp = p_cp, ville = p_ville, pays = p_pays, statut = p_statut, etat = p_etat, role = p_role, bloque = p_bloque, nbConnexion = p_nbConnexion, date_dernier_changement_mdp = p_date_changement_mdp
where tel = p_tel and email = p_email;
End$$

--
-- Fonctions
--
DROP FUNCTION IF EXISTS `countEmailParticulier`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `countEmailParticulier` (`newemail` VARCHAR(50)) RETURNS INT  Begin
select count(*) from particulier where email = newemail into @result;
return @result;
End$$

DROP FUNCTION IF EXISTS `countEmailProfessionnel`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `countEmailProfessionnel` (`newemail` VARCHAR(50)) RETURNS INT  Begin
select count(*) from professionnel where email = newemail into @result;
return @result;
End$$

DROP FUNCTION IF EXISTS `countTelParticulier`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `countTelParticulier` (`newtel` VARCHAR(10)) RETURNS INT  Begin
select count(*) from particulier where tel = newtel into @result;
return @result;
End$$

DROP FUNCTION IF EXISTS `countTelProfessionnel`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `countTelProfessionnel` (`newtel` VARCHAR(10)) RETURNS INT  Begin
select count(*) from professionnel where tel = newtel into @result;
return @result;
End$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE IF NOT EXISTS `admin` (
  `idadmin` int NOT NULL AUTO_INCREMENT,
  `email` varchar(50) DEFAULT NULL,
  `mdp` varchar(50) DEFAULT NULL,
  `droit` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`idadmin`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `admin`
--

INSERT INTO `admin` (`idadmin`, `email`, `mdp`, `droit`) VALUES
(1, 'admin@gmail.com', '40bd001563085fc35165329ea1ff5c5ecbdbbeef', 1);

--
-- Déclencheurs `admin`
--
DROP TRIGGER IF EXISTS `modifierMdp`;
DELIMITER $$
CREATE TRIGGER `modifierMdp` BEFORE INSERT ON `admin` FOR EACH ROW Begin
set new.mdp = sha1(new.mdp);
End
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `bdd`
--

DROP TABLE IF EXISTS `bdd`;
CREATE TABLE IF NOT EXISTS `bdd` (
  `nom_bdd` varchar(60) NOT NULL,
  `nb_views` int DEFAULT NULL,
  `nb_triggers` int DEFAULT NULL,
  `nb_procedures` int DEFAULT NULL,
  `nb_functions` int DEFAULT NULL,
  PRIMARY KEY (`nom_bdd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `bdd`
--

INSERT INTO `bdd` (`nom_bdd`, `nb_views`, `nb_triggers`, `nb_procedures`, `nb_functions`) VALUES
('JVI', 12, 28, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `client`
--

DROP TABLE IF EXISTS `client`;
CREATE TABLE IF NOT EXISTS `client` (
  `idclient` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(30) DEFAULT NULL,
  `tel` varchar(10) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `mdp` varchar(255) DEFAULT NULL,
  `adresse` varchar(100) DEFAULT NULL,
  `cp` varchar(5) DEFAULT NULL,
  `ville` varchar(50) DEFAULT NULL,
  `pays` varchar(50) DEFAULT NULL,
  `etat` enum('Prospect','Client actif','Client très actif') DEFAULT NULL,
  `role` enum('client','admin') DEFAULT NULL,
  `nbTentatives` int NOT NULL DEFAULT '0',
  `bloque` int NOT NULL DEFAULT '0',
  `nbConnexion` int NOT NULL DEFAULT '0',
  `type` enum('Particulier','Professionnel') DEFAULT NULL,
  `date_creation_mdp` datetime DEFAULT NULL,
  `date_dernier_changement_mdp` datetime DEFAULT NULL,
  `date_creation_compte` datetime DEFAULT NULL,
  `connected_at` datetime DEFAULT NULL,
  PRIMARY KEY (`idclient`),
  UNIQUE KEY `tel` (`tel`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `client`
--

INSERT INTO `client` (`idclient`, `nom`, `tel`, `email`, `mdp`, `adresse`, `cp`, `ville`, `pays`, `etat`, `role`, `nbTentatives`, `bloque`, `nbConnexion`, `type`, `date_creation_mdp`, `date_dernier_changement_mdp`, `date_creation_compte`, `connected_at`) VALUES
(1, 'LeD', '0353952424', 'darrent@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '3, rue des lieutemants Thomazo', '59500', 'DOUAI', 'France', 'Prospect', 'client', 0, 0, 0, 'Particulier', '2023-04-02 00:59:23', '2023-04-02 00:59:23', '2023-04-02 00:59:23', '2023-04-02 00:59:23'),
(2, 'LeL', '0214316122', 'lassana@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '15, rue Michel Ange', '76600', 'LE HAVRE', 'France', 'Prospect', 'client', 0, 0, 0, 'Particulier', '2023-04-02 00:59:23', '2023-04-02 00:59:23', '2023-04-02 00:59:23', '2023-04-02 00:59:23'),
(3, 'LeM', '0451596927', 'maamar@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '15, rue des Soeurs', '06160', 'JUAN-LES-PINS', 'France', 'Prospect', 'client', 0, 0, 0, 'Particulier', '2023-04-02 00:59:23', '2023-04-02 00:59:23', '2023-04-02 00:59:23', '2023-04-02 00:59:23'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 4, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-12 12:31:27'),
(5, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 3, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-10 03:09:48'),
(6, 'Steam', '0652535152', 'steam@steam.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '5 steam ddsf', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 2, 'Professionnel', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-12 12:55:04'),
(7, 'Epicgame', '0652535658', 'epic@game.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '40 epic game', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 1, 'Professionnel', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-12 12:51:13');

--
-- Déclencheurs `client`
--
DROP TRIGGER IF EXISTS `deleteClient`;
DELIMITER $$
CREATE TRIGGER `deleteClient` BEFORE DELETE ON `client` FOR EACH ROW Begin
insert into histoClient select *, sysdate(), user(), 'DELETE'
from client
where idclient = old.idclient;
End
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `insertClient`;
DELIMITER $$
CREATE TRIGGER `insertClient` AFTER INSERT ON `client` FOR EACH ROW Begin
insert into histoClient select *, sysdate(), user(), 'INSERT'
from client
where idclient = new.idclient;
End
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `updateClient`;
DELIMITER $$
CREATE TRIGGER `updateClient` BEFORE UPDATE ON `client` FOR EACH ROW Begin
insert into histoClient select *, sysdate(), user(), 'UPDATE'
from client
where idclient = old.idclient;
End
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `commentaire`
--

DROP TABLE IF EXISTS `commentaire`;
CREATE TABLE IF NOT EXISTS `commentaire` (
  `idcom` int NOT NULL AUTO_INCREMENT,
  `idpublication` int NOT NULL,
  `idclient` int NOT NULL,
  `contenu` longtext NOT NULL,
  `client_id` int NOT NULL,
  `dateheurepost` datetime DEFAULT NULL,
  PRIMARY KEY (`idcom`),
  KEY `idpublication` (`idpublication`),
  KEY `idclient` (`idclient`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `commentaire`
--

INSERT INTO `commentaire` (`idcom`, `idpublication`, `idclient`, `contenu`, `client_id`, `dateheurepost`) VALUES
(1, 13, 4, 't\r\n', 4, '2023-04-09 02:09:03'),
(2, 13, 5, 'a', 5, '2023-04-09 02:09:44'),
(3, 14, 7, 'Coucou ^^', 11, '2023-04-11 11:51:11'),
(4, 15, 6, 'Salut ^^', 10, '2023-04-11 11:51:32');

-- --------------------------------------------------------

--
-- Structure de la table `histoclient`
--

DROP TABLE IF EXISTS `histoclient`;
CREATE TABLE IF NOT EXISTS `histoclient` (
  `idclient` int NOT NULL DEFAULT '0',
  `nom` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `tel` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `email` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `mdp` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `adresse` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cp` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ville` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `pays` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `etat` enum('Prospect','Client actif','Client très actif') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `role` enum('client','admin') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `nbTentatives` int NOT NULL DEFAULT '0',
  `bloque` int NOT NULL DEFAULT '0',
  `nbConnexion` int NOT NULL DEFAULT '0',
  `type` enum('Particulier','Professionnel') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `date_creation_mdp` datetime DEFAULT NULL,
  `date_dernier_changement_mdp` datetime DEFAULT NULL,
  `date_creation_compte` datetime DEFAULT NULL,
  `connected_at` datetime DEFAULT NULL,
  `dateHeureAction` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user` varchar(288) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `action` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `histoclient`
--

INSERT INTO `histoclient` (`idclient`, `nom`, `tel`, `email`, `mdp`, `adresse`, `cp`, `ville`, `pays`, `etat`, `role`, `nbTentatives`, `bloque`, `nbConnexion`, `type`, `date_creation_mdp`, `date_dernier_changement_mdp`, `date_creation_compte`, `connected_at`, `dateHeureAction`, `user`, `action`) VALUES
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 0, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-09 16:51:11', '2023-04-08 23:56:23', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 0, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-09 16:51:11', '2023-04-08 23:56:23', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 0, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-09 16:51:11', '2023-04-08 23:56:23', 'root@localhost', 'UPDATE'),
(9, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 2, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-09 20:37:42', '2023-04-08 23:56:18', 'root@localhost', 'UPDATE'),
(9, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 0, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:31:02', 'root@localhost', 'UPDATE'),
(9, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 1, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:37:42', 'root@localhost', 'UPDATE'),
(9, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 1, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-09 20:37:42', '2023-04-08 23:55:54', 'root@localhost', 'UPDATE'),
(9, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 1, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-09 20:37:42', '2023-04-08 23:55:54', 'root@localhost', 'UPDATE'),
(9, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 1, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-09 20:37:42', '2023-04-08 23:55:54', 'root@localhost', 'UPDATE'),
(9, 'Vilmax', '0652535251', 'yass@gmail.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 0, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', 'root@localhost', 'INSERT'),
(9, 'Vilmax', '0652535251', 'yass@gmail.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 0, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:30:20', 'root@localhost', 'UPDATE'),
(9, 'Vilmax', '0652535251', 'yass@gmail.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 1, 0, 0, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:30:45', 'root@localhost', 'UPDATE'),
(9, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 1, 0, 0, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:30:56', 'root@localhost', 'UPDATE'),
(9, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 2, 0, 0, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:31:02', 'root@localhost', 'UPDATE'),
(9, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 0, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:31:02', 'root@localhost', 'UPDATE'),
(9, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 2, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-09 23:56:18', '2023-04-08 23:58:12', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 1, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-09 16:51:11', '2023-04-09 00:06:24', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 1, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-10 00:06:24', '2023-04-09 03:08:42', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 1, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-10 00:06:24', '2023-04-09 03:08:42', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 1, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-10 00:06:24', '2023-04-09 03:08:43', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 2, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-10 00:06:24', '2023-04-09 03:09:10', 'root@localhost', 'UPDATE'),
(5, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 2, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-09 23:56:18', '2023-04-09 03:09:30', 'root@localhost', 'UPDATE'),
(5, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 2, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-09 23:56:18', '2023-04-09 03:09:30', 'root@localhost', 'UPDATE'),
(5, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 2, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-09 23:56:18', '2023-04-09 03:09:30', 'root@localhost', 'UPDATE'),
(5, 'Vilmax', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 3, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-09 23:56:18', '2023-04-09 03:09:48', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 2, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-10 03:09:10', '2023-04-09 03:09:50', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 2, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-10 03:09:10', '2023-04-09 03:09:50', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 2, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-10 03:09:10', '2023-04-09 03:09:50', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 3, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-10 03:09:10', '2023-04-09 03:10:51', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 3, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-10 03:10:51', '2023-04-09 20:40:59', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 3, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-10 03:10:51', '2023-04-09 20:40:59', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 3, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-10 03:10:51', '2023-04-09 20:40:59', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 4, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-10 03:10:51', '2023-04-10 01:53:50', 'root@localhost', 'UPDATE'),
(4, 'Cst_Yass', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 4, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-11 01:53:50', '2023-04-11 12:31:27', 'root@localhost', 'UPDATE'),
(10, 'Steam', '0652535152', 'steam@steam.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '5 steam ddsf', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 0, 'Professionnel', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', 'root@localhost', 'INSERT'),
(11, 'Epicgame', '0652535658', 'epic@game.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '40 epic game', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 0, 'Professionnel', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09', 'root@localhost', 'INSERT'),
(10, 'Steam', '0652535152', 'steam@steam.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '5 steam ddsf', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 0, 'Professionnel', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:39:46', 'root@localhost', 'UPDATE'),
(10, 'Steam', '0652535152', 'steam@steam.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '5 steam ddsf', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 0, 'Professionnel', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:39:46', 'root@localhost', 'UPDATE'),
(10, 'Steam', '0652535152', 'steam@steam.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '5 steam ddsf', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 0, 'Professionnel', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:39:46', 'root@localhost', 'UPDATE'),
(10, 'Steam', '0652535152', 'steam@steam.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '5 steam ddsf', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 1, 'Professionnel', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:48:48', 'root@localhost', 'UPDATE'),
(11, 'Epicgame', '0652535658', 'epic@game.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '40 epic game', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 0, 'Professionnel', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:49:39', 'root@localhost', 'UPDATE'),
(11, 'Epicgame', '0652535658', 'epic@game.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '40 epic game', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 0, 'Professionnel', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:49:39', 'root@localhost', 'UPDATE'),
(11, 'Epicgame', '0652535658', 'epic@game.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '40 epic game', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 0, 'Professionnel', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:49:39', 'root@localhost', 'UPDATE'),
(11, 'Epicgame', '0652535658', 'epic@game.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '40 epic game', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 1, 'Professionnel', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:51:13', 'root@localhost', 'UPDATE'),
(10, 'Steam', '0652535152', 'steam@steam.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '5 steam ddsf', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 1, 'Professionnel', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-12 12:48:48', '2023-04-11 12:51:23', 'root@localhost', 'UPDATE'),
(10, 'Steam', '0652535152', 'steam@steam.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '5 steam ddsf', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 1, 'Professionnel', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-12 12:48:48', '2023-04-11 12:51:23', 'root@localhost', 'UPDATE'),
(10, 'Steam', '0652535152', 'steam@steam.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '5 steam ddsf', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 1, 'Professionnel', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-12 12:48:48', '2023-04-11 12:51:23', 'root@localhost', 'UPDATE'),
(10, 'Steam', '0652535152', 'steam@steam.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '5 steam ddsf', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 2, 'Professionnel', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-12 12:48:48', '2023-04-11 12:55:04', 'root@localhost', 'UPDATE'),
(10, 'Steam', '0652535152', 'steam@steam.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '5 steam ddsf', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 2, 'Professionnel', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-12 12:55:04', '2023-04-11 12:55:28', 'root@localhost', 'UPDATE'),
(11, 'Epicgame', '0652535658', 'epic@game.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '40 epic game', '75017', 'Paris', 'France', 'Prospect', 'client', 0, 0, 1, 'Professionnel', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-12 12:51:13', '2023-04-11 12:55:30', 'root@localhost', 'UPDATE');

-- --------------------------------------------------------

--
-- Structure de la table `histopublication`
--

DROP TABLE IF EXISTS `histopublication`;
CREATE TABLE IF NOT EXISTS `histopublication` (
  `idpublication` int NOT NULL DEFAULT '0',
  `idclient` int NOT NULL,
  `nompublication` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `imagepublication` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `descriptionpublication` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `idtype` int NOT NULL,
  `date_ajout` datetime DEFAULT NULL,
  `dateHeureAction` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user` varchar(288) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `action` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `histopublication`
--

INSERT INTO `histopublication` (`idpublication`, `idclient`, `nompublication`, `imagepublication`, `descriptionpublication`, `idtype`, `date_ajout`, `dateHeureAction`, `user`, `action`) VALUES
(12, 4, 'Dota 2 : le jeu de stratégie multijoueur compétitif pour les joueurs les plus aguerris', 'Dota2.jpg', 'Dota 2 est un jeu de stratégie multijoueur en ligne compétitif qui met en scène deux équipes de cinq joueurs qui s\'affrontent pour détruire la forteresse ennemie. Avec un large choix de héros aux capacités uniques, une carte dynamique et des mécanismes de jeu complexes, Dota 2 est un jeu qui demande beaucoup de compétence, de stratégie et de coordination.', 6, '2023-04-02 00:59:30', '2023-04-08 17:28:02', 'root@localhost', 'UPDATE'),
(9, 5, 'NBA : le jeu de basketball ultime pour les fans de sport', 'NBA.jpg', 'NBA est le jeu de simulation de basketball le plus populaire au monde, offrant des graphismes époustouflants, des mouvements de joueurs incroyablement fluides et des équipes officielles sous licence. Créez votre propre joueur et participez à des matchs en ligne pour déterminer qui est le meilleur joueur de NBA.', 3, '2023-04-02 00:59:30', '2023-04-08 17:27:59', 'root@localhost', 'UPDATE'),
(12, 6, 'Dota 2 : le jeu de stratégie multijoueur compétitif pour les joueurs les plus aguerris', 'Dota2.jpg', 'Dota 2 est un jeu de stratégie multijoueur en ligne compétitif qui met en scène deux équipes de cinq joueurs qui s\'affrontent pour détruire la forteresse ennemie. Avec un large choix de héros aux capacités uniques, une carte dynamique et des mécanismes de jeu complexes, Dota 2 est un jeu qui demande beaucoup de compétence, de stratégie et de coordination.', 6, '2023-04-02 00:59:30', '2023-04-08 17:27:53', 'root@localhost', 'UPDATE'),
(10, 5, 'World of Warcraft : un monde de fantaisie immense à explorer', 'wow.png', 'World of Warcraft est un jeu de rôle en ligne massivement multijoueur (MMORPG) qui se déroule dans un monde de fantaisie immense et riche en histoire. Créez votre propre personnage et rejoignez des millions de joueurs pour explorer des terres dangereuses, combattre des monstres légendaires, forger des alliances avec d\'autres joueurs et relever des défis épiques.', 4, '2023-04-02 00:59:30', '2023-04-08 17:27:41', 'root@localhost', 'UPDATE'),
(12, 5, 'Killua Zoldyck, l\'assassin', 'killua.gif', 'Killua Zoldyck est un personnage fictif de la série manga et anime japonaise \"Hunter x Hunter\". Il est membre de la famille Zoldyck, connue pour son expertise en tant qu\'assassins.\r\n\r\nKillua est un assassin hautement qualifié, qui possède une force, une agilité et une vitesse incroyables. Il est également très intelligent et stratégique, avec une forte volonté et une détermination remarquable. Tout au long de la série, Killua développe des relations étroites avec ses compagnons chasseurs, en particulier Gon Freecss, et commence à remettre en question le mode de vie de sa famille.', 7, '2023-04-08 18:36:32', '2023-04-09 03:18:36', 'root@localhost', 'UPDATE'),
(12, 5, 'Killua Zoldyck', 'killua.gif', 'Killua Zoldyck est un personnage fictif de la série manga et anime japonaise \"Hunter x Hunter\". Il est membre de la famille Zoldyck, connue pour son expertise en tant qu\'assassins.\r\n\r\nKillua est un assassin hautement qualifié, qui possède une force, une agilité et une vitesse incroyables. Il est également très intelligent et stratégique, avec une forte volonté et une détermination remarquable. Tout au long de la série, Killua développe des relations étroites avec ses compagnons chasseurs, en particulier Gon Freecss, et commence à remettre en question le mode de vie de sa famille.', 7, '2023-04-08 18:36:32', '2023-04-09 03:18:16', 'root@localhost', 'UPDATE'),
(108, 4, 'Super Mario Bros : le jeu de plateforme classique qui a marqué l\'histoire des jeux vidéo', 'Super_Mario_Bros.jpg', 'Super Mario Bros est l\'un des jeux les plus emblématiques de tous les temps, qui a popularisé le genre de la plateforme avec ses niveaux créatifs, ses power-ups uniques et ses personnages adorables. Traversez le royaume champignon en incarnant Mario ou Luigi, affrontez Bowser et sauvez la princesse Peach dans ce jeu incontournable pour les fans de jeux vidéo.', 5, '2023-04-08 22:01:17', '2023-04-09 03:17:53', 'root@localhost', 'UPDATE'),
(108, 4, 'Super Mario Bros : le jeu de plateforme classique qui a marqué l\'histoire des jeux vidéo', 'Super_Mario_Bros.jpg', 'Super Mario Bros est l\'un des jeux les plus emblématiques de tous les temps, qui a popularisé le genre de la plateforme avec ses niveaux créatifs, ses power-ups uniques et ses personnages adorables. Traversez le royaume champignon en incarnant Mario ou Luigi, affrontez Bowser et sauvez la princesse Peach dans ce jeu incontournable pour les fans de jeux vidéo.', 5, '2023-04-08 22:01:17', '2023-04-09 00:01:17', 'root@localhost', 'INSERT'),
(13, 5, 'Killua Zoldyck', 'killua.gif', 'Killua Zoldyck est un personnage fictif de la série manga et anime japonaise \"Hunter x Hunter\". Il est membre de la famille Zoldyck, connue pour son expertise en tant qu\'assassins.\r\n\r\nKillua est un assassin hautement qualifié, qui possède une force, une agilité et une vitesse incroyables. Il est également très intelligent et stratégique, avec une forte volonté et une détermination remarquable. Tout au long de la série, Killua développe des relations étroites avec ses compagnons chasseurs, en particulier Gon Freecss, et commence à remettre en question le mode de vie de sa famille.', 7, '2023-04-08 18:36:32', '2023-04-08 23:58:57', 'root@localhost', 'UPDATE'),
(12, 1, 'Dota 2 : le jeu de stratégie multijoueur compétitif pour les joueurs les plus aguerris', 'Dota2.jpg', 'Dota 2 est un jeu de stratégie multijoueur en ligne compétitif qui met en scène deux équipes de cinq joueurs qui s\'affrontent pour détruire la forteresse ennemie. Avec un large choix de héros aux capacités uniques, une carte dynamique et des mécanismes de jeu complexes, Dota 2 est un jeu qui demande beaucoup de compétence, de stratégie et de coordination.', 6, '2023-04-02 00:59:30', '2023-04-08 23:58:54', 'root@localhost', 'UPDATE'),
(107, 9, 'Killua Zoldyck', 'killua.gif', 'Killua Zoldyck est un personnage fictif de la série manga et anime japonaise \"Hunter x Hunter\". Il est membre de la famille Zoldyck, connue pour son expertise en tant qu\'assassins.\r\n\r\nKillua est un assassin hautement qualifié, qui possède une force, une agilité et une vitesse incroyables. Il est également très intelligent et stratégique, avec une forte volonté et une détermination remarquable. Tout au long de la série, Killua développe des relations étroites avec ses compagnons chasseurs, en particulier Gon Freecss, et commence à remettre en question le mode de vie de sa famille.', 7, '2023-04-08 18:36:32', '2023-04-08 23:58:02', 'root@localhost', 'UPDATE'),
(107, 9, 'Killua Zoldyck', 'killua.gif', 'Killua Zoldyck est un personnage fictif de la série manga et anime japonaise \"Hunter x Hunter\". Il est membre de la famille Zoldyck, connue pour son expertise en tant qu\'assassins.\r\n\r\nKillua est un assassin hautement qualifié, qui possède une force, une agilité et une vitesse incroyables. Il est également très intelligent et stratégique, avec une forte volonté et une détermination remarquable. Tout au long de la série, Killua développe des relations étroites avec ses compagnons chasseurs, en particulier Gon Freecss, et commence à remettre en question le mode de vie de sa famille.', 7, '2023-04-08 18:36:32', '2023-04-08 20:36:32', 'root@localhost', 'INSERT'),
(108, 4, 'Super Mario Bros : le jeu de plateforme classique qui a marqué l\'histoire des jeux', 'Super_Mario_Bros.jpg', 'Super Mario Bros est l\'un des jeux les plus emblématiques de tous les temps, qui a popularisé le genre de la plateforme avec ses niveaux créatifs, ses power-ups uniques et ses personnages adorables. Traversez le royaume champignon en incarnant Mario ou Luigi, affrontez Bowser et sauvez la princesse Peach dans ce jeu incontournable pour les fans de jeux vidéo.', 5, '2023-04-08 22:01:17', '2023-04-09 20:37:38', 'root@localhost', 'UPDATE'),
(6, 3, 'Sonic : le hérisson bleu rapide et légendaire est de retour', 'Sonic.jpg', 'Sonic est un jeu de plateforme classique où vous incarnez Sonic, le hérisson bleu rapide et légendaire, pour courir à travers des niveaux stimulants, sauter par-dessus des obstacles et vaincre des ennemis emblématiques. Avec des graphismes étonnants, des musiques entraînantes et un gameplay addictif, Sonic est un jeu de plateforme emblématique qui a captivé des générations de joueurs.', 5, '2023-04-02 00:59:30', '2023-04-09 20:41:27', 'root@localhost', 'UPDATE'),
(9, 1, 'NBA : le jeu de basketball ultime pour les fans de sport', 'NBA.jpg', 'NBA est le jeu de simulation de basketball le plus populaire au monde, offrant des graphismes époustouflants, des mouvements de joueurs incroyablement fluides et des équipes officielles sous licence. Créez votre propre joueur et participez à des matchs en ligne pour déterminer qui est le meilleur joueur de NBA.', 3, '2023-04-02 00:59:30', '2023-04-09 22:45:17', 'root@localhost', 'UPDATE'),
(11, 1, 'Dota 2 : le jeu de stratégie multijoueur compétitif pour les joueurs les plus aguerris', 'Dota2.jpg', 'Dota 2 est un jeu de stratégie multijoueur en ligne compétitif qui met en scène deux équipes de cinq joueurs qui s\'affrontent pour détruire la forteresse ennemie. Avec un large choix de héros aux capacités uniques, une carte dynamique et des mécanismes de jeu complexes, Dota 2 est un jeu qui demande beaucoup de compétence, de stratégie et de coordination.', 6, '2023-04-02 00:59:30', '2023-04-09 22:45:23', 'root@localhost', 'UPDATE'),
(13, 4, 'Super Mario Bros : le jeu de plateforme classique qui a marqué l\'histoire des jeux', 'Super_Mario_Bros.jpg', 'Super Mario Bros est l\'un des jeux les plus emblématiques de tous les temps, qui a popularisé le genre de la plateforme avec ses niveaux créatifs, ses power-ups uniques et ses personnages adorables. Traversez le royaume champignon en incarnant Mario ou Luigi, affrontez Bowser et sauvez la princesse Peach dans ce jeu incontournable pour les fans de jeux vidéo.', 5, '2023-04-08 22:01:17', '2023-04-09 22:45:28', 'root@localhost', 'UPDATE'),
(7, 4, 'Call of Duty : une expérience de guerre moderne dans un jeu de tir en ligne', 'Call of Duty.jpg', 'Call of Duty est un jeu de tir à la première personne populaire, qui propose une variété de modes de jeu, y compris le multijoueur en ligne, le mode zombie et le mode campagne solo. Avec des graphismes époustouflants, une action rapide et un arsenal d\'armes modernes, Call of Duty offre une expérience de guerre intense et passionnante pour les fans de FPS.', 1, '2023-04-02 00:59:30', '2023-04-09 22:45:33', 'root@localhost', 'UPDATE'),
(109, 10, 'Steam : la plateforme incontournable pour les gamers', 'O-Que-e-Steam.jpg', 'Steam est une plateforme de distribution de jeux vidéo créée par Valve Corporation. Elle permet aux utilisateurs d\'acheter, de télécharger et de jouer à des jeux sur leur ordinateur. Avec une communauté active de millions de joueurs, Steam est devenue l\'une des plus grandes plateformes de jeux en ligne au monde.', 5, '2023-04-11 10:45:35', '2023-04-11 12:45:35', 'root@localhost', 'INSERT'),
(109, 10, 'Steam : la plateforme incontournable pour les gamers', 'O-Que-e-Steam.jpg', 'Steam est une plateforme de distribution de jeux vidéo créée par Valve Corporation. Elle permet aux utilisateurs d\'acheter, de télécharger et de jouer à des jeux sur leur ordinateur. Avec une communauté active de millions de joueurs, Steam est devenue l\'une des plus grandes plateformes de jeux en ligne au monde.', 5, '2023-04-11 10:45:35', '2023-04-11 12:47:09', 'root@localhost', 'DELETE'),
(110, 10, 'Steam : la plateforme incontournable pour les gamers', 'O-Que-e-Steam.jpg', 'Steam est une plateforme de distribution de jeux vidéo créée par Valve Corporation. Elle permet aux utilisateurs d\'acheter, de télécharger et de jouer à des jeux sur leur ordinateur. Avec une communauté active de millions de joueurs, Steam est devenue l\'une des plus grandes plateformes de jeux en ligne au monde.', 5, '2023-04-11 10:47:43', '2023-04-11 12:47:43', 'root@localhost', 'INSERT'),
(110, 10, 'Steam : la plateforme incontournable pour les gamers', 'O-Que-e-Steam.jpg', 'Steam est une plateforme de distribution de jeux vidéo créée par Valve Corporation. Elle permet aux utilisateurs d\'acheter, de télécharger et de jouer à des jeux sur leur ordinateur. Avec une communauté active de millions de joueurs, Steam est devenue l\'une des plus grandes plateformes de jeux en ligne au monde.', 5, '2023-04-11 10:47:43', '2023-04-11 12:48:23', 'root@localhost', 'UPDATE'),
(111, 11, 'Epic Games Store : une plateforme de jeux innovante en concurrence avec Steam', 'epic-games-logo.jpg', 'Epic Games est une entreprise de développement de jeux vidéo et de logiciels connue pour avoir créé le célèbre jeu Fortnite. Elle a également lancé sa propre plateforme de distribution de jeux, l\'Epic Games Store, qui offre une alternative à Steam avec une sélection de jeux exclusifs et des offres intéressantes pour les joueurs.', 5, '2023-04-11 10:50:31', '2023-04-11 12:50:31', 'root@localhost', 'INSERT'),
(111, 11, 'Epic Games Store : une plateforme de jeux innovante en concurrence avec Steam', 'epic-games-logo.jpg', 'Epic Games est une entreprise de développement de jeux vidéo et de logiciels connue pour avoir créé le célèbre jeu Fortnite. Elle a également lancé sa propre plateforme de distribution de jeux, l\'Epic Games Store, qui offre une alternative à Steam avec une sélection de jeux exclusifs et des offres intéressantes pour les joueurs.', 5, '2023-04-11 10:50:31', '2023-04-11 12:55:13', 'root@localhost', 'UPDATE');

-- --------------------------------------------------------

--
-- Structure de la table `histotype`
--

DROP TABLE IF EXISTS `histotype`;
CREATE TABLE IF NOT EXISTS `histotype` (
  `idtype` int NOT NULL DEFAULT '0',
  `libelle` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `dateHeureAction` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user` varchar(288) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `action` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`idtype`,`dateHeureAction`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `histotype`
--

INSERT INTO `histotype` (`idtype`, `libelle`, `dateHeureAction`, `user`, `action`) VALUES
(7, 'Manga', '2023-04-08 20:35:39', 'root@localhost', 'UPDATE'),
(7, 'Manga', '2023-04-08 20:35:24', 'root@localhost', 'INSERT'),
(7, '', '2023-04-08 20:34:19', 'root@localhost', 'INSERT');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `mesquestions`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `mesquestions`;
CREATE TABLE IF NOT EXISTS `mesquestions` (
`idreponse` int
,`enonce` longtext
,`reponse` text
,`idclient` int
,`email` varchar(50)
);

-- --------------------------------------------------------

--
-- Structure de la table `message`
--

DROP TABLE IF EXISTS `message`;
CREATE TABLE IF NOT EXISTS `message` (
  `idmessage` int NOT NULL AUTO_INCREMENT,
  `id_exp` int NOT NULL,
  `id_dest` int NOT NULL,
  `date_envoi` datetime DEFAULT NULL,
  `contenu` longtext,
  `lu` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`idmessage`,`id_exp`,`id_dest`),
  KEY `id_dest` (`id_dest`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `message`
--

INSERT INTO `message` (`idmessage`, `id_exp`, `id_dest`, `date_envoi`, `contenu`, `lu`) VALUES
(1, 1, 2, '2023-04-02 00:59:40', 'Coucou, ca va ?', 1),
(2, 1, 3, '2023-04-02 00:59:40', 'AAaaaaaa', 1),
(3, 1, 1, '2023-04-02 00:59:40', 'Rappel RDV', 0);

-- --------------------------------------------------------

--
-- Structure de la table `particulier`
--

DROP TABLE IF EXISTS `particulier`;
CREATE TABLE IF NOT EXISTS `particulier` (
  `idclient` int NOT NULL,
  `nom` varchar(30) DEFAULT NULL,
  `prenom` varchar(30) DEFAULT NULL,
  `tel` varchar(10) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `mdp` varchar(255) DEFAULT NULL,
  `adresse` varchar(100) DEFAULT NULL,
  `cp` varchar(5) DEFAULT NULL,
  `ville` varchar(50) DEFAULT NULL,
  `pays` varchar(50) DEFAULT NULL,
  `etat` enum('Prospect','Client actif','Client très actif') DEFAULT NULL,
  `role` enum('client','admin') DEFAULT NULL,
  `nbTentatives` int NOT NULL DEFAULT '0',
  `bloque` int NOT NULL DEFAULT '0',
  `nbConnexion` int NOT NULL DEFAULT '0',
  `type` enum('Particulier','Professionnel') DEFAULT NULL,
  `date_creation_mdp` datetime DEFAULT NULL,
  `date_dernier_changement_mdp` datetime DEFAULT NULL,
  `date_creation_compte` datetime DEFAULT NULL,
  PRIMARY KEY (`idclient`),
  UNIQUE KEY `tel` (`tel`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `particulier`
--

INSERT INTO `particulier` (`idclient`, `nom`, `prenom`, `tel`, `email`, `mdp`, `adresse`, `cp`, `ville`, `pays`, `etat`, `role`, `nbTentatives`, `bloque`, `nbConnexion`, `type`, `date_creation_mdp`, `date_dernier_changement_mdp`, `date_creation_compte`) VALUES
(1, 'LeD', 'Darren', '0353952424', 'darren@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '3, rue des lieutemants Thomazo', '59500', 'DOUAI', 'France', 'Prospect', 'client', 0, 0, 0, 'Particulier', '2023-04-02 00:59:23', '2023-04-02 00:59:23', '2023-04-02 00:59:23'),
(2, 'LeL', 'Lassana', '0214316122', 'lassana@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '15, rue Michel Ange', '76600', 'LE HAVRE', 'France', 'Prospect', 'client', 0, 0, 0, 'Particulier', '2023-04-02 00:59:23', '2023-04-02 00:59:23', '2023-04-02 00:59:23'),
(3, 'LeM', 'Maamar', '0451596927', 'maamar@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '15, rue des Soeurs', '06160', 'JUAN-LES-PINS', 'France', 'Prospect', 'client', 0, 0, 0, 'Particulier', '2023-04-02 00:59:23', '2023-04-02 00:59:23', '2023-04-02 00:59:23'),
(4, 'Cst_Yass', 'Yassine', '0652518228', 'yassine@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andree grunig', '95200', 'Sarcelles', 'France', 'Prospect', 'admin', 0, 0, 0, 'Particulier', '2023-04-02 00:59:24', '2023-04-02 00:59:24', '2023-04-02 00:59:24'),
(5, 'Vilmax', 'Yassine', '0652535251', 'yass@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', '40 rue andr', '95200', 'Sarcelles', 'France', 'Prospect', 'client', 0, 0, 0, 'Particulier', '2023-04-08 20:29:43', '2023-04-08 20:29:43', '2023-04-08 20:29:43');

--
-- Déclencheurs `particulier`
--
DROP TRIGGER IF EXISTS `checkEmailParticulier`;
DELIMITER $$
CREATE TRIGGER `checkEmailParticulier` BEFORE INSERT ON `particulier` FOR EACH ROW Begin
if countEmailParticulier(new.email)
then signal sqlstate '45000'
set message_text = 'Email deja utilisee !';
end if ;
End
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `checkTelParticulier`;
DELIMITER $$
CREATE TRIGGER `checkTelParticulier` BEFORE INSERT ON `particulier` FOR EACH ROW Begin
if countTelParticulier(new.tel)
then signal sqlstate '45000'
set message_text = 'Telephone deja utilisee !';
end if ;
End
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `checkTelProfessionnel`;
DELIMITER $$
CREATE TRIGGER `checkTelProfessionnel` BEFORE INSERT ON `particulier` FOR EACH ROW Begin
if countTelProfessionnel(new.tel)
then signal sqlstate '45000'
set message_text = 'Telephone deja utilisee !';
end if ;
End
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `professionnel`
--

DROP TABLE IF EXISTS `professionnel`;
CREATE TABLE IF NOT EXISTS `professionnel` (
  `idclient` int NOT NULL,
  `nom` varchar(30) DEFAULT NULL,
  `tel` varchar(10) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `mdp` varchar(255) DEFAULT NULL,
  `adresse` varchar(100) DEFAULT NULL,
  `cp` varchar(5) DEFAULT NULL,
  `ville` varchar(50) DEFAULT NULL,
  `pays` varchar(50) DEFAULT NULL,
  `numSIRET` varchar(50) DEFAULT NULL,
  `statut` varchar(30) DEFAULT NULL,
  `etat` enum('Prospect','Client actif','Client très actif') DEFAULT NULL,
  `role` enum('client','admin') DEFAULT NULL,
  `nbTentatives` int NOT NULL DEFAULT '0',
  `bloque` int NOT NULL DEFAULT '0',
  `nbConnexion` int NOT NULL DEFAULT '0',
  `type` enum('Particulier','Professionnel') DEFAULT NULL,
  `date_creation_mdp` datetime DEFAULT NULL,
  `date_dernier_changement_mdp` datetime DEFAULT NULL,
  `date_creation_compte` datetime DEFAULT NULL,
  PRIMARY KEY (`idclient`),
  UNIQUE KEY `tel` (`tel`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `professionnel`
--

INSERT INTO `professionnel` (`idclient`, `nom`, `tel`, `email`, `mdp`, `adresse`, `cp`, `ville`, `pays`, `numSIRET`, `statut`, `etat`, `role`, `nbTentatives`, `bloque`, `nbConnexion`, `type`, `date_creation_mdp`, `date_dernier_changement_mdp`, `date_creation_compte`) VALUES
(6, 'Steam', '0652535152', 'steam@steam.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '5 steam ddsf', '75017', 'Paris', 'France', '521 868 267 00014', 'Entreprise', 'Prospect', 'client', 0, 0, 0, 'Professionnel', '2023-04-11 12:37:10', '2023-04-11 12:37:10', '2023-04-11 12:37:10'),
(7, 'Epicgame', '0652535658', 'epic@game.com', '0d89688120739bf78b4f75cd1cd8ce20c0ca788b', '40 epic game', '75017', 'Paris', 'France', '521 868 267 00014', 'Entreprise', 'Prospect', 'client', 0, 0, 0, 'Professionnel', '2023-04-11 12:39:09', '2023-04-11 12:39:09', '2023-04-11 12:39:09');

--
-- Déclencheurs `professionnel`
--
DROP TRIGGER IF EXISTS `checkEmailProfessionnel`;
DELIMITER $$
CREATE TRIGGER `checkEmailProfessionnel` BEFORE INSERT ON `professionnel` FOR EACH ROW Begin
if countEmailProfessionnel(new.email)
then signal sqlstate '45000'
set message_text = 'Email deja utilisee !';
end if ;
End
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `publication`
--

DROP TABLE IF EXISTS `publication`;
CREATE TABLE IF NOT EXISTS `publication` (
  `idpublication` int NOT NULL AUTO_INCREMENT,
  `idclient` int NOT NULL,
  `nompublication` varchar(100) NOT NULL,
  `imagepublication` varchar(255) DEFAULT NULL,
  `descriptionpublication` longtext,
  `idtype` int NOT NULL,
  `date_ajout` datetime DEFAULT NULL,
  PRIMARY KEY (`idpublication`),
  UNIQUE KEY `nompublication` (`nompublication`),
  KEY `idtype` (`idtype`),
  KEY `idclient` (`idclient`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `publication`
--

INSERT INTO `publication` (`idpublication`, `idclient`, `nompublication`, `imagepublication`, `descriptionpublication`, `idtype`, `date_ajout`) VALUES
(1, 1, 'Dofus : Un MMORPG fantastique et captivant', 'Dofus.png', 'Plongez dans un monde magique rempli de créatures fantastiques et de défis passionnants avec Dofus, un MMORPG en ligne captivant. Avec une variété de personnages à jouer, des villes animées et des donjons dangereux à explorer, Dofus offre une expérience de jeu immersive qui ravira les joueurs de tous les niveaux.', 4, '2023-04-02 00:59:30'),
(2, 1, 'League of Legends : un MOBA épique pour des combats palpitants', 'Lol.jpg', 'League of Legends est un MOBA (Multiplayer Online Battle Arena) palpitant où des joueurs du monde entier s\'affrontent dans des combats en équipe pour détruire la base ennemie. Avec des personnages variés, des cartes dynamiques et des compétences uniques à maîtriser, League of Legends offre une expérience de jeu en ligne passionnante et compétitive pour les joueurs de tous niveaux.', 6, '2023-04-02 00:59:30'),
(3, 2, 'CS:GO : un jeu de tir compétitif pour les amateurs de FPS', 'Csgo.jpg', 'Counter-Strike: Global Offensive (CS:GO) est un jeu de tir à la première personne compétitif où deux équipes s\'affrontent pour remplir des objectifs différents. Avec des graphismes immersifs, des armes réalistes et un gameplay rapide et tactique, CS:GO est un jeu de tir en ligne addictif pour les amateurs de FPS.', 1, '2023-04-02 00:59:30'),
(4, 2, 'Tekken : un jeu de combat classique pour les fans de baston', 'Tekken.jpg', 'Tekken est un jeu de combat légendaire où des combattants de différents pays s\'affrontent pour le titre de champion. Avec des personnages emblématiques, des combos spectaculaires et des arènes variées, Tekken offre une expérience de jeu de combat en 3D passionnante pour les joueurs de tous niveaux.', 2, '2023-04-02 00:59:30'),
(5, 3, 'FIFA : le jeu de football ultime pour les fans de sport', 'Fifa.jpg', 'FIFA est le jeu de simulation de football le plus célèbre au monde, offrant des graphismes époustouflants, un gameplay fluide et des équipes officielles sous licence. Jouez avec vos joueurs préférés, créez votre propre équipe et participez à des compétitions en ligne pour déterminer qui est le meilleur joueur de FIFA.', 3, '2023-04-02 00:59:30'),
(6, 3, 'Sonic : le hérisson bleu rapide et légendaire est de retour', 'Sonic.jpg', 'Sonic est un jeu de plateforme classique où vous incarnez Sonic, le hérisson bleu rapide et légendaire, pour courir à travers des niveaux stimulants, sauter par-dessus des obstacles et vaincre des ennemis emblématiques. Avec des graphismes étonnants, des musiques entraînantes et un gameplay addictif, Sonic est un jeu de plateforme emblématique qui a captivé des générations de joueurs..', 5, '2023-04-02 00:59:30'),
(7, 3, 'Call of Duty : une expérience de guerre moderne dans un jeu de tir en ligne', 'Call of Duty.jpg', 'Call of Duty est un jeu de tir à la première personne populaire, qui propose une variété de modes de jeu, y compris le multijoueur en ligne, le mode zombie et le mode campagne solo. Avec des graphismes époustouflants, une action rapide et un arsenal d\'armes modernes, Call of Duty offre une expérience de guerre intense et passionnante pour les fans de FPS.', 1, '2023-04-02 00:59:30'),
(8, 4, 'Street Fighter : le jeu de combat classique qui a redéfini le genre', 'Street Fighter.jpg', 'Street Fighter est l\'un des jeux de combat les plus emblématiques de tous les temps, qui a redéfini le genre avec son gameplay innovant, ses personnages légendaires et ses combos spectaculaires. Jouez en solo ou défiez vos amis en ligne pour déterminer qui est le meilleur combattant de rue.', 2, '2023-04-02 00:59:30'),
(9, 4, 'NBA : le jeu de basketball ultime pour les fans de sport', 'NBA.jpg', 'NBA est le jeu de simulation de basketball le plus populaire au monde, offrant des graphismes époustouflants, des mouvements de joueurs incroyablement fluides et des équipes officielles sous licence. Créez votre propre joueur et participez à des matchs en ligne pour déterminer qui est le meilleur joueur de NBA.', 3, '2023-04-02 00:59:30'),
(10, 4, 'World of Warcraft : un monde de fantaisie immense à explorer', 'wow.png', 'World of Warcraft est un jeu de rôle en ligne massivement multijoueur (MMORPG) qui se déroule dans un monde de fantaisie immense et riche en histoire. Créez votre propre personnage et rejoignez des millions de joueurs pour explorer des terres dangereuses, combattre des monstres légendaires, forger des alliances avec d\'autres joueurs et relever des défis épiques.', 4, '2023-04-02 00:59:30'),
(11, 5, 'Dota 2 : le jeu de stratégie multijoueur compétitif pour les joueurs les plus aguerris', 'Dota2.jpg', 'Dota 2 est un jeu de stratégie multijoueur en ligne compétitif qui met en scène deux équipes de cinq joueurs qui s\'affrontent pour détruire la forteresse ennemie. Avec un large choix de héros aux capacités uniques, une carte dynamique et des mécanismes de jeu complexes, Dota 2 est un jeu qui demande beaucoup de compétence, de stratégie et de coordination.', 6, '2023-04-02 00:59:30'),
(12, 5, 'Killua Zoldyck, l\'assassin d\'hunter x hunter', 'killua.gif', 'Killua Zoldyck est un personnage fictif de la série manga et anime japonaise \"Hunter x Hunter\". Il est membre de la famille Zoldyck, connue pour son expertise en tant qu\'assassins.\r\n\r\nKillua est un assassin hautement qualifié, qui possède une force, une agilité et une vitesse incroyables. Il est également très intelligent et stratégique, avec une forte volonté et une détermination remarquable. Tout au long de la série, Killua développe des relations étroites avec ses compagnons chasseurs, en particulier Gon Freecss, et commence à remettre en question le mode de vie de sa famille.', 7, '2023-04-08 18:36:32'),
(13, 5, 'Super Mario Bros : le jeu de plateforme classique qui a marqué l\'histoire des jeux', 'Super_Mario_Bros.jpg', 'Super Mario Bros est l\'un des jeux les plus emblématiques de tous les temps, qui a popularisé le genre de la plateforme avec ses niveaux créatifs, ses power-ups uniques et ses personnages adorables. Traversez le royaume champignon en incarnant Mario ou Luigi, affrontez Bowser et sauvez la princesse Peach dans ce jeu incontournable pour les fans de jeux vidéo.', 5, '2023-04-08 22:01:17'),
(14, 6, 'Steam : la plateforme incontournable pour les gamers', 'O-Que-e-Steam.jpg', 'Steam est une plateforme de distribution de jeux vidéo créée par Valve Corporation. Elle permet aux utilisateurs d\'acheter, de télécharger et de jouer à des jeux sur leur ordinateur. Avec une communauté active de millions de joueurs, Steam est devenue l\'une des plus grandes plateformes de jeux en ligne au monde.', 5, '2023-04-11 10:47:43'),
(15, 7, 'Epic Games Store : une plateforme de jeux innovante en concurrence avec Steam', 'epic-games-logo.jpg', 'Epic Games est une entreprise de développement de jeux vidéo et de logiciels connue pour avoir créé le célèbre jeu Fortnite. Elle a également lancé sa propre plateforme de distribution de jeux, l\'Epic Games Store, qui offre une alternative à Steam avec une sélection de jeux exclusifs et des offres intéressantes pour les joueurs.', 5, '2023-04-11 10:50:31');

--
-- Déclencheurs `publication`
--
DROP TRIGGER IF EXISTS `deletePublication`;
DELIMITER $$
CREATE TRIGGER `deletePublication` BEFORE DELETE ON `publication` FOR EACH ROW Begin
insert into histoPublication select *, sysdate(), user(), 'DELETE'
from publication
where idpublication = old.idpublication;
End
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `insertPublication`;
DELIMITER $$
CREATE TRIGGER `insertPublication` AFTER INSERT ON `publication` FOR EACH ROW Begin
insert into histoPublication select *, sysdate(), user(), 'INSERT'
from publication
where idpublication = new.idpublication;
End
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `updatePublication`;
DELIMITER $$
CREATE TRIGGER `updatePublication` BEFORE UPDATE ON `publication` FOR EACH ROW Begin
insert into histoPublication select *, sysdate(), user(), 'UPDATE'
from publication
where idpublication = old.idpublication;
End
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `question`
--

DROP TABLE IF EXISTS `question`;
CREATE TABLE IF NOT EXISTS `question` (
  `idquestion` int NOT NULL AUTO_INCREMENT,
  `enonce` longtext,
  PRIMARY KEY (`idquestion`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `question`
--

INSERT INTO `question` (`idquestion`, `enonce`) VALUES
(1, 'Quelle est la personnalité historique que vous préférez ?'),
(2, 'Quel est votre acteur, musicien ou artiste favori ?'),
(3, 'Dans quelle ville se sont rencontrés vos parents ?'),
(4, 'Quel est le nom de famille de votre professeur d\'enfance préféré ?');

-- --------------------------------------------------------

--
-- Structure de la table `reponse`
--

DROP TABLE IF EXISTS `reponse`;
CREATE TABLE IF NOT EXISTS `reponse` (
  `idreponse` int NOT NULL AUTO_INCREMENT,
  `idquestion` int NOT NULL,
  `reponse` text,
  `idclient` int NOT NULL,
  PRIMARY KEY (`idreponse`),
  KEY `idquestion` (`idquestion`),
  KEY `idclient` (`idclient`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `reponse`
--

INSERT INTO `reponse` (`idreponse`, `idquestion`, `reponse`, `idclient`) VALUES
(1, 2, 'Tom Hanks', 1),
(2, 3, 'Paris', 2),
(3, 1, 'Napoléon', 3),
(4, 1, 'test', 5),
(5, 1, 'Steam', 6),
(6, 1, 'epic game', 7);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `tp`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `tp`;
CREATE TABLE IF NOT EXISTS `tp` (
`libelle` varchar(50)
,`nompublication` varchar(100)
);

-- --------------------------------------------------------

--
-- Structure de la table `type`
--

DROP TABLE IF EXISTS `type`;
CREATE TABLE IF NOT EXISTS `type` (
  `idtype` int NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) NOT NULL,
  PRIMARY KEY (`idtype`),
  UNIQUE KEY `libelle` (`libelle`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `type`
--

INSERT INTO `type` (`idtype`, `libelle`) VALUES
(7, 'Anime'),
(1, 'Les FPS'),
(2, 'Les jeux de combat'),
(5, 'Les jeux de plateforme'),
(3, 'Les jeux de sport'),
(4, 'Les jeux MMORPG'),
(6, 'Les jeux MOBA');

--
-- Déclencheurs `type`
--
DROP TRIGGER IF EXISTS `checkTypeInsert`;
DELIMITER $$
CREATE TRIGGER `checkTypeInsert` BEFORE INSERT ON `type` FOR EACH ROW Begin
if new.libelle = (select libelle from type where libelle = new.libelle)
then signal sqlstate '45000'
set message_text = 'Ce type est déjà enregistré !';
end if ;
End
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `deleteType`;
DELIMITER $$
CREATE TRIGGER `deleteType` BEFORE DELETE ON `type` FOR EACH ROW Begin
Insert into histoType select *, sysdate(), user(), 'DELETE'
From type
Where idtype = old.idtype;
End
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `insertType`;
DELIMITER $$
CREATE TRIGGER `insertType` AFTER INSERT ON `type` FOR EACH ROW Begin
Insert into histoType select *, sysdate(), user(), 'INSERT'
From type
Where idtype = new.idtype;
End
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `updateType`;
DELIMITER $$
CREATE TRIGGER `updateType` BEFORE UPDATE ON `type` FOR EACH ROW Begin
Insert into histoType select *, sysdate(), user(), 'UPDATE'
From type
Where idtype = old.idtype;
End
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vclient`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `vclient`;
CREATE TABLE IF NOT EXISTS `vclient` (
`idclient` int
,`nom` varchar(30)
,`tel` varchar(10)
,`email` varchar(50)
,`mdp` varchar(255)
,`adresse` varchar(100)
,`cp` varchar(5)
,`ville` varchar(50)
,`pays` varchar(50)
,`etat` enum('Prospect','Client actif','Client très actif')
,`role` enum('client','admin')
,`nbTentatives` int
,`bloque` int
,`nbConnexion` int
,`type` enum('Particulier','Professionnel')
,`date_creation_mdp` varchar(21)
,`date_dernier_changement_mdp` varchar(21)
,`date_creation_compte` varchar(21)
,`connected_at` varchar(21)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vcommentaire`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `vcommentaire`;
CREATE TABLE IF NOT EXISTS `vcommentaire` (
`idcom` int
,`idpublication` int
,`idclient` varchar(30)
,`contenu` longtext
,`client_id` int
,`dateheurepost` varchar(21)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vmessage`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `vmessage`;
CREATE TABLE IF NOT EXISTS `vmessage` (
`idmessage` int
,`id_exp` int
,`expediteur` varchar(30)
,`id_dest` int
,`destinataire` varchar(30)
,`date_envoi` varchar(21)
,`contenu` longtext
,`lu` int
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vpublication`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `vpublication`;
CREATE TABLE IF NOT EXISTS `vpublication` (
`idpublication` int
,`nompublication` varchar(100)
,`imagepublication` varchar(255)
,`descriptionpublication` longtext
,`date_ajout` datetime
,`nomclient` varchar(30)
,`email` varchar(50)
);

-- --------------------------------------------------------

--
-- Structure de la vue `mesquestions`
--
DROP TABLE IF EXISTS `mesquestions`;

DROP VIEW IF EXISTS `mesquestions`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mesquestions` (`idreponse`, `enonce`, `reponse`, `idclient`, `email`) AS   select `r`.`idreponse` AS `idreponse`,`q`.`enonce` AS `enonce`,`r`.`reponse` AS `reponse`,`c`.`idclient` AS `idclient`,`c`.`email` AS `email` from ((`reponse` `r` join `question` `q` on((`r`.`idquestion` = `q`.`idquestion`))) join `client` `c` on((`r`.`idclient` = `c`.`idclient`))) group by `r`.`idreponse`  ;

-- --------------------------------------------------------

--
-- Structure de la vue `tp`
--
DROP TABLE IF EXISTS `tp`;

DROP VIEW IF EXISTS `tp`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tp` (`libelle`, `nompublication`) AS   select `t`.`libelle` AS `libelle`,`p`.`nompublication` AS `nompublication` from (`type` `t` join `publication` `p`) where (`t`.`idtype` = `p`.`idtype`) order by `t`.`libelle`  ;

-- --------------------------------------------------------

--
-- Structure de la vue `vclient`
--
DROP TABLE IF EXISTS `vclient`;

DROP VIEW IF EXISTS `vclient`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vclient` (`idclient`, `nom`, `tel`, `email`, `mdp`, `adresse`, `cp`, `ville`, `pays`, `etat`, `role`, `nbTentatives`, `bloque`, `nbConnexion`, `type`, `date_creation_mdp`, `date_dernier_changement_mdp`, `date_creation_compte`, `connected_at`) AS   select `client`.`idclient` AS `idclient`,`client`.`nom` AS `nom`,`client`.`tel` AS `tel`,`client`.`email` AS `email`,`client`.`mdp` AS `mdp`,`client`.`adresse` AS `adresse`,`client`.`cp` AS `cp`,`client`.`ville` AS `ville`,`client`.`pays` AS `pays`,`client`.`etat` AS `etat`,`client`.`role` AS `role`,`client`.`nbTentatives` AS `nbTentatives`,`client`.`bloque` AS `bloque`,`client`.`nbConnexion` AS `nbConnexion`,`client`.`type` AS `type`,date_format(`client`.`date_creation_mdp`,'%d/%m/%Y %H:%i') AS `date_format(date_creation_mdp, '%d/%m/%Y %H:%i')`,date_format(`client`.`date_dernier_changement_mdp`,'%d/%m/%Y %H:%i') AS `date_format(date_dernier_changement_mdp, '%d/%m/%Y %H:%i')`,date_format(`client`.`date_creation_compte`,'%d/%m/%Y %H:%i') AS `date_format(date_creation_compte, '%d/%m/%Y %H:%i')`,date_format(`client`.`connected_at`,'%d/%m/%Y %H:%i') AS `date_format(connected_at, '%d/%m/%Y %H:%i')` from `client`  ;

-- --------------------------------------------------------

--
-- Structure de la vue `vcommentaire`
--
DROP TABLE IF EXISTS `vcommentaire`;

DROP VIEW IF EXISTS `vcommentaire`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vcommentaire` (`idcom`, `idpublication`, `idclient`, `contenu`, `client_id`, `dateheurepost`) AS   select `co`.`idcom` AS `idcom`,`p`.`idpublication` AS `idpublication`,`cl`.`nom` AS `nom`,`co`.`contenu` AS `contenu`,`co`.`client_id` AS `client_id`,date_format(`co`.`dateheurepost`,'%d/%m/%Y %H:%i') AS `date_format(co.dateheurepost, '%d/%m/%Y %H:%i')` from ((`commentaire` `co` join `publication` `p` on((`co`.`idpublication` = `p`.`idpublication`))) join `client` `cl` on((`co`.`idclient` = `cl`.`idclient`))) group by `co`.`idcom`  ;

-- --------------------------------------------------------

--
-- Structure de la vue `vmessage`
--
DROP TABLE IF EXISTS `vmessage`;

DROP VIEW IF EXISTS `vmessage`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vmessage` (`idmessage`, `id_exp`, `expediteur`, `id_dest`, `destinataire`, `date_envoi`, `contenu`, `lu`) AS   select `m2`.`idmessage` AS `idmessage`,`m1`.`id_exp` AS `id_exp`,`a`.`nom` AS `nom`,`m2`.`id_dest` AS `id_dest`,`b`.`nom` AS `nom`,date_format(`m1`.`date_envoi`,'%d/%m/%Y %H:%i') AS `date_format(m1.date_envoi, '%d/%m/%Y %H:%i')`,`m2`.`contenu` AS `contenu`,`m2`.`lu` AS `lu` from (((`client` `a` join `client` `b`) join `message` `m1`) join `message` `m2`) where ((`m1`.`id_exp` = `a`.`idclient`) and (`m2`.`id_dest` = `b`.`idclient`) and (`m1`.`date_envoi` = `m2`.`date_envoi`)) group by `m2`.`idmessage`  ;

-- --------------------------------------------------------

--
-- Structure de la vue `vpublication`
--
DROP TABLE IF EXISTS `vpublication`;

DROP VIEW IF EXISTS `vpublication`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vpublication`  AS SELECT `p`.`idpublication` AS `idpublication`, `p`.`nompublication` AS `nompublication`, `p`.`imagepublication` AS `imagepublication`, `p`.`descriptionpublication` AS `descriptionpublication`, `p`.`date_ajout` AS `date_ajout`, `c`.`nom` AS `nomclient`, `c`.`email` AS `email` FROM (`publication` `p` join `client` `c` on((`p`.`idclient` = `c`.`idclient`)))  ;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `commentaire`
--
ALTER TABLE `commentaire`
  ADD CONSTRAINT `commentaire_ibfk_1` FOREIGN KEY (`idpublication`) REFERENCES `publication` (`idpublication`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `commentaire_ibfk_2` FOREIGN KEY (`idclient`) REFERENCES `client` (`idclient`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `message_ibfk_1` FOREIGN KEY (`id_dest`) REFERENCES `client` (`idclient`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `particulier`
--
ALTER TABLE `particulier`
  ADD CONSTRAINT `particulier_ibfk_1` FOREIGN KEY (`idclient`) REFERENCES `client` (`idclient`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `publication`
--
ALTER TABLE `publication`
  ADD CONSTRAINT `publication_ibfk_1` FOREIGN KEY (`idtype`) REFERENCES `type` (`idtype`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `publication_ibfk_2` FOREIGN KEY (`idclient`) REFERENCES `client` (`idclient`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `reponse`
--
ALTER TABLE `reponse`
  ADD CONSTRAINT `reponse_ibfk_1` FOREIGN KEY (`idquestion`) REFERENCES `question` (`idquestion`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reponse_ibfk_2` FOREIGN KEY (`idclient`) REFERENCES `client` (`idclient`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
