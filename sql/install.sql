--
-- Host: localhost    Database: ansible
-- ------------------------------------------------------
-- Server version	5.6.32-78.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (1,'web');
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ion_groups`
--

DROP TABLE IF EXISTS `ion_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ion_groups` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ion_groups`
--

LOCK TABLES `ion_groups` WRITE;
/*!40000 ALTER TABLE `ion_groups` DISABLE KEYS */;
INSERT INTO `ion_groups` VALUES (1,'admin','Administrator'),(2,'members','General User');
/*!40000 ALTER TABLE `ion_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ion_login_attempts`
--

DROP TABLE IF EXISTS `ion_login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ion_login_attempts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(15) NOT NULL,
  `login` varchar(100) NOT NULL,
  `time` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ion_login_attempts`
--

LOCK TABLES `ion_login_attempts` WRITE;
/*!40000 ALTER TABLE `ion_login_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ion_login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ion_users`
--

DROP TABLE IF EXISTS `ion_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ion_users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(15) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `salt` varchar(255) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `activation_code` varchar(40) DEFAULT NULL,
  `forgotten_password_code` varchar(40) DEFAULT NULL,
  `forgotten_password_time` int(11) unsigned DEFAULT NULL,
  `remember_code` varchar(40) DEFAULT NULL,
  `created_on` int(11) unsigned NOT NULL,
  `last_login` int(11) unsigned DEFAULT NULL,
  `active` tinyint(1) unsigned DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ion_users`
--

LOCK TABLES `ion_users` WRITE;
/*!40000 ALTER TABLE `ion_users` DISABLE KEYS */;
INSERT INTO `ion_users` VALUES (1,'127.0.0.1','administrator','$2y$08$lZVDTbMVQUbfOM5aShbI9O129Er/N/R3n/CSICJg.JdDrd0qxgXSC','','admin@admin.com','',NULL,NULL,'5pmCduIYLVuzS2TeMVSNwO',1268889823,1485131499,1,'Admin','istratorx','ADMIN','0');
/*!40000 ALTER TABLE `ion_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ion_users_groups`
--

DROP TABLE IF EXISTS `ion_users_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ion_users_groups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `group_id` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_users_groups` (`user_id`,`group_id`),
  KEY `fk_users_groups_users1_idx` (`user_id`),
  KEY `fk_users_groups_groups1_idx` (`group_id`),
  CONSTRAINT `fk_users_groups_groups1` FOREIGN KEY (`group_id`) REFERENCES `ion_groups` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_groups_users1` FOREIGN KEY (`user_id`) REFERENCES `ion_users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ion_users_groups`
--

LOCK TABLES `ion_users_groups` WRITE;
/*!40000 ALTER TABLE `ion_users_groups` DISABLE KEYS */;
INSERT INTO `ion_users_groups` VALUES (1,1,1),(2,1,2);
/*!40000 ALTER TABLE `ion_users_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `monitor_groups`
--

DROP TABLE IF EXISTS `monitor_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `monitor_groups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monitor_groups`
--

LOCK TABLES `monitor_groups` WRITE;
/*!40000 ALTER TABLE `monitor_groups` DISABLE KEYS */;
INSERT INTO `monitor_groups` VALUES (1,'disk');
/*!40000 ALTER TABLE `monitor_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servers`
--

DROP TABLE IF EXISTS `servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `external_server_id` varchar(100) NOT NULL DEFAULT '',
  `server_name` varchar(100) NOT NULL DEFAULT '',
  `private_ip` varchar(20) NOT NULL DEFAULT '',
  `public_ip` varchar(20) NOT NULL DEFAULT '',
  `app` varchar(20) NOT NULL DEFAULT '',
  `region` varchar(20) NOT NULL DEFAULT '',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `lookup_idx` (`app`,`region`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servers`
--

LOCK TABLES `servers` WRITE;
/*!40000 ALTER TABLE `servers` DISABLE KEYS */;
INSERT INTO `servers` VALUES (1,'123-456-7890','example-web01','10.0.0.1','1.1.1.1','example','us-east-1',1,'2017-01-23 00:32:54'),(2,'xxx-xxx-xxx','new-web02','10.0.0.2','1.0.0.1','app2','us-west-1',1,'2017-01-23 00:34:55');
/*!40000 ALTER TABLE `servers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servers_groups`
--

DROP TABLE IF EXISTS `servers_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servers_groups` (
  `servers_id` int(11) unsigned NOT NULL DEFAULT '0',
  `groups_id` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`servers_id`,`groups_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servers_groups`
--

LOCK TABLES `servers_groups` WRITE;
/*!40000 ALTER TABLE `servers_groups` DISABLE KEYS */;
INSERT INTO `servers_groups` VALUES (1,1),(2,1);
/*!40000 ALTER TABLE `servers_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servers_monitor_groups`
--

DROP TABLE IF EXISTS `servers_monitor_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servers_monitor_groups` (
  `servers_id` int(11) unsigned NOT NULL DEFAULT '0',
  `monitor_groups_id` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`servers_id`,`monitor_groups_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servers_monitor_groups`
--

LOCK TABLES `servers_monitor_groups` WRITE;
/*!40000 ALTER TABLE `servers_monitor_groups` DISABLE KEYS */;
INSERT INTO `servers_monitor_groups` VALUES (1,1);
/*!40000 ALTER TABLE `servers_monitor_groups` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-01-22 19:36:21
