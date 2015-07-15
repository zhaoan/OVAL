-- MySQL dump 10.13  Distrib 5.1.61, for redhat-linux-gnu (x86_64)
--
-- Host: localhost    Database: dev_annotation_tool
-- ------------------------------------------------------
-- Server version	5.1.61

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
-- Table structure for table `annotationViewedBy`
--

DROP TABLE IF EXISTS `annotationViewedBy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `annotationViewedBy` (
  `uid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `annotation_id` int(10) unsigned NOT NULL,
  `viewed_by` int(10) unsigned NOT NULL,
  `view_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `annotationViewedBy`
--

LOCK TABLES `annotationViewedBy` WRITE;
/*!40000 ALTER TABLE `annotationViewedBy` DISABLE KEYS */;
/*!40000 ALTER TABLE `annotationViewedBy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `annotations`
--

DROP TABLE IF EXISTS `annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `annotations` (
  `annotation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `video_id` varchar(20) DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `user_name` varchar(40) NOT NULL DEFAULT '',
  `start_time` double unsigned DEFAULT NULL,
  `end_time` double unsigned DEFAULT NULL,
  `description` varchar(512) DEFAULT NULL,
  `tags` varchar(128) DEFAULT NULL,
  `is_private` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `video_annotation_id` varchar(20) DEFAULT NULL,
  `parent_id` int(20) unsigned DEFAULT NULL,
  `child_id` int(20) unsigned DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`annotation_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `annotations`
--

LOCK TABLES `annotations` WRITE;
/*!40000 ALTER TABLE `annotations` DISABLE KEYS */;
/*!40000 ALTER TABLE `annotations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class`
--

DROP TABLE IF EXISTS `class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `class` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class`
--

LOCK TABLES `class` WRITE;
/*!40000 ALTER TABLE `class` DISABLE KEYS */;
/*!40000 ALTER TABLE `class` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER DELETE_class_trigger
AFTER delete ON class
FOR EACH ROW
BEGIN
DELETE FROM classEnrollmentLists WHERE class_id = old.id;
DELETE FROM classInstructorsAndTAs WHERE class_id = old.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `classEnrollmentLists`
--

DROP TABLE IF EXISTS `classEnrollmentLists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classEnrollmentLists` (
  `class_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`class_id`,`user_id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `classEnrollmentLists_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `class` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classEnrollmentLists`
--

LOCK TABLES `classEnrollmentLists` WRITE;
/*!40000 ALTER TABLE `classEnrollmentLists` DISABLE KEYS */;
/*!40000 ALTER TABLE `classEnrollmentLists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classInstructorsAndTAs`
--

DROP TABLE IF EXISTS `classInstructorsAndTAs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classInstructorsAndTAs` (
  `class_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `is_instructor` tinyint(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`class_id`,`user_id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `classInstructorsAndTAs_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `class` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classInstructorsAndTAs`
--

LOCK TABLES `classInstructorsAndTAs` WRITE;
/*!40000 ALTER TABLE `classInstructorsAndTAs` DISABLE KEYS */;
/*!40000 ALTER TABLE `classInstructorsAndTAs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flavors`
--

DROP TABLE IF EXISTS `flavors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flavors` (
  `flavor_id` varchar(20) NOT NULL,
  `video_id` varchar(20) NOT NULL,
  `codec_id` varchar(20) DEFAULT NULL,
  `file_ext` varchar(20) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`flavor_id`,`video_id`),
  KEY `flavors_ibfk_1` (`video_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flavors`
--

LOCK TABLES `flavors` WRITE;
/*!40000 ALTER TABLE `flavors` DISABLE KEYS */;
INSERT INTO `flavors` VALUES ('0_2adfm20c','0_s8iv973k','mpeg-4 visual','3gp','2012-09-07 23:30:15'),('0_34wobkmc','0_s8iv973k','avc1','mp4','2012-09-07 23:30:15'),('0_4qdltcnh','0_s8iv973k','vp6','flv','2012-09-07 23:30:15'),('0_57irbi83','0_s8iv973k','avc1','mp4','2012-09-07 23:30:15'),('0_6sh8nluz','0_s8iv973k','avc1','mp4','2012-09-07 23:30:15'),('0_7nle7h6b','0_r12t0cos','theora','ogg','2012-09-08 21:02:23'),('0_dpnnbch4','0_s8iv973k','theora','ogg','2012-09-07 23:30:15'),('0_e1tl1nru','0_r12t0cos','avc1','mp4','2012-09-08 21:02:23'),('0_e3qk1pe8','0_s8iv973k','vp6','flv','2012-09-07 23:30:15'),('0_fh7wfe75','0_s8iv973k','avc1','mp4','2012-09-07 23:30:15'),('0_jjcieo9n','0_r12t0cos','vp6','flv','2012-09-08 21:02:23'),('0_lgzepkmg','0_r12t0cos','avc1','mov','2012-09-08 21:02:23'),('0_n2347drl','0_s8iv973k','v_vp8','webm','2012-09-07 23:30:15'),('0_rm5nlop6','0_r12t0cos','v_vp8','webm','2012-09-08 21:02:23'),('0_s2hojetz','0_r12t0cos','mpeg-4 visual','3gp','2012-09-08 21:02:23'),('0_vf850340','0_s8iv973k','vp6','flv','2012-09-07 23:30:15'),('0_xcsib6xz','0_r12t0cos','avc1','mp4','2012-09-08 21:02:23');
/*!40000 ALTER TABLE `flavors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groupMembers`
--

DROP TABLE IF EXISTS `groupMembers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groupMembers` (
  `group_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`group_id`,`user_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `groupMembers_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groupMembers`
--

LOCK TABLES `groupMembers` WRITE;
/*!40000 ALTER TABLE `groupMembers` DISABLE KEYS */;
/*!40000 ALTER TABLE `groupMembers` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER DELETE_groupMembers_trigger
AFTER delete ON groupMembers
FOR EACH ROW
BEGIN
DELETE FROM videoAccessControlLists WHERE user_id = old.user_id AND group_id = old.group_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `groupOwners`
--

DROP TABLE IF EXISTS `groupOwners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groupOwners` (
  `group_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`group_id`,`user_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `groupOwners_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groupOwners`
--

LOCK TABLES `groupOwners` WRITE;
/*!40000 ALTER TABLE `groupOwners` DISABLE KEYS */;
/*!40000 ALTER TABLE `groupOwners` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER DELETE_groupOwners_trigger
AFTER delete ON groupOwners
FOR EACH ROW
BEGIN
DELETE FROM videoAccessControlLists WHERE user_id = old.user_id AND group_id = old.group_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `class_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER DELETE_groups_trigger
AFTER delete ON groups
FOR EACH ROW
BEGIN
DELETE FROM groupOwners WHERE group_id = old.id;
DELETE FROM groupMembers WHERE group_id = old.id;
DELETE FROM videoAccessControlLists WHERE group_id = old.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `loginSessions`
--

DROP TABLE IF EXISTS `loginSessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `loginSessions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `login_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `logout_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loginSessions`
--

LOCK TABLES `loginSessions` WRITE;
/*!40000 ALTER TABLE `loginSessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `loginSessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media` (
  `video_id` varchar(20) NOT NULL,
  `uploaded_by_user_id` int(10) unsigned NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` varchar(512) DEFAULT NULL,
  `duration` int(10) unsigned DEFAULT NULL,
  `thumbnail_url` varchar(255) DEFAULT NULL,
  `upload_complete` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `conversion_complete` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `creation_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`video_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES ('0_s8iv973k',169,'short vid','this is for testing',4,'http://cdnbakmi.kaltura.com/p/401711/sp/40171100/thumbnail/entry_id/0_s8iv973k/version/0',1,1,'2012-09-07 23:28:18'),('0_r12t0cos',170,'audio track','audio only track',2337,'http://cdnbakmi.kaltura.com/p/401711/sp/40171100/thumbnail/entry_id/0_r12t0cos/version/100001',1,1,'2012-09-08 20:41:25');
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER DELETE_video_trigger
AFTER delete ON media
FOR EACH ROW BEGIN
DELETE FROM videoOwners WHERE video_id LIKE old.video_id;
DELETE FROM flavors WHERE video_id LIKE old.video_id;
DELETE FROM videoGroup WHERE video_id LIKE old.video_id;
DELETE FROM videoAccessControlLists WHERE video_id LIKE old.video_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `userInterfaceConfigs`
--

DROP TABLE IF EXISTS `userInterfaceConfigs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userInterfaceConfigs` (
  `user_id` int(10) unsigned NOT NULL,
  `annotation_mode` varchar(20) NOT NULL,
  `annotations_enabled` varchar(20) DEFAULT NULL,
  `trendline_visibility` varchar(20) NOT NULL,
  `n` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userInterfaceConfigs`
--

LOCK TABLES `userInterfaceConfigs` WRITE;
/*!40000 ALTER TABLE `userInterfaceConfigs` DISABLE KEYS */;
/*!40000 ALTER TABLE `userInterfaceConfigs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash_user_id` varchar(64) DEFAULT NULL,
  `salt` varchar(64) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `role` tinyint(3) unsigned NOT NULL,
  `creation_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`142.103.199.234`*/ /*!50003 TRIGGER `DELETE_users_trigger` AFTER DELETE ON `users` FOR EACH ROW BEGIN
DELETE FROM userInterfaceConfigs WHERE user_id LIKE old.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `videoAccessControlLists`
--

DROP TABLE IF EXISTS `videoAccessControlLists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `videoAccessControlLists` (
  `video_id` varchar(20) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  `total_views` int(11) unsigned NOT NULL DEFAULT '0',
  `first_view` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `creation_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`video_id`,`user_id`),
  KEY `videoAccessControlLists_ibfk_1` (`group_id`),
  CONSTRAINT `videoAccessControlLists_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videoAccessControlLists`
--

LOCK TABLES `videoAccessControlLists` WRITE;
/*!40000 ALTER TABLE `videoAccessControlLists` DISABLE KEYS */;
/*!40000 ALTER TABLE `videoAccessControlLists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videoGroup`
--

DROP TABLE IF EXISTS `videoGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `videoGroup` (
  `video_id` varchar(20) NOT NULL,
  `group_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`video_id`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videoGroup`
--

LOCK TABLES `videoGroup` WRITE;
/*!40000 ALTER TABLE `videoGroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `videoGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videoOwners`
--

DROP TABLE IF EXISTS `videoOwners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `videoOwners` (
  `video_id` varchar(20) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`video_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videoOwners`
--

LOCK TABLES `videoOwners` WRITE;
/*!40000 ALTER TABLE `videoOwners` DISABLE KEYS */;
INSERT INTO `videoOwners` VALUES ('0_s8iv973k',169),('0_s8iv973k',170);
/*!40000 ALTER TABLE `videoOwners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videoViewedBy`
--

DROP TABLE IF EXISTS `videoViewedBy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `videoViewedBy` (
  `uid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `video_id` varchar(20) NOT NULL,
  `viewed_by` int(10) unsigned NOT NULL,
  `playback_start_time` int(10) unsigned NOT NULL DEFAULT '0',
  `playback_end_time` int(10) unsigned DEFAULT NULL,
  `start_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_time` datetime DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videoViewedBy`
--

LOCK TABLES `videoViewedBy` WRITE;
/*!40000 ALTER TABLE `videoViewedBy` DISABLE KEYS */;
/*!40000 ALTER TABLE `videoViewedBy` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-09-08 14:07:14
