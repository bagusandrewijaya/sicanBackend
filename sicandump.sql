-- MySQL dump 10.13  Distrib 5.7.31, for Win64 (x86_64)
--
-- Host: localhost    Database: sicandb
-- ------------------------------------------------------
-- Server version	5.7.31

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
-- Table structure for table `ceritaprev`
--

DROP TABLE IF EXISTS `ceritaprev`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ceritaprev` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jumlah_cerita` int(11) DEFAULT NULL,
  `jumlah_blacklist` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ceritaprev`
--

LOCK TABLES `ceritaprev` WRITE;
/*!40000 ALTER TABLE `ceritaprev` DISABLE KEYS */;
/*!40000 ALTER TABLE `ceritaprev` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_cerita`
--

DROP TABLE IF EXISTS `tbl_cerita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cerita` (
  `id_cerita` varchar(250) NOT NULL,
  `judul` varchar(250) DEFAULT NULL,
  `videourl` text,
  `gambar` varchar(250) DEFAULT NULL,
  `deskripsi` text,
  `status` varchar(250) DEFAULT NULL,
  `fkg_penulis` varchar(250) DEFAULT NULL,
  `likes` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id_cerita`),
  KEY `fkg_penulis` (`fkg_penulis`),
  CONSTRAINT `tbl_cerita_ibfk_1` FOREIGN KEY (`fkg_penulis`) REFERENCES `users` (`uuid_users`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_cerita`
--

LOCK TABLES `tbl_cerita` WRITE;
/*!40000 ALTER TABLE `tbl_cerita` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_cerita` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_jumlah_cerita` AFTER INSERT ON `tbl_cerita` FOR EACH ROW BEGIN
    UPDATE ceritaprev SET jumlah_cerita = jumlah_cerita + 1 WHERE id = (SELECT id FROM users WHERE uuid_users = NEW.fkg_penulis);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trigger_api_logsins
AFTER INSERT ON tbl_cerita
FOR EACH ROW
BEGIN
    INSERT INTO tbl_logs (action, table_name, record_id, user_id, data)
    VALUES ('insert', 'tbl_cerita', NEW.id_cerita, NEW.fkg_penulis, JSON_OBJECT('judul', NEW.judul, 'videourl', NEW.videourl, 'gambar', NEW.gambar, 'deskripsi', NEW.deskripsi, 'status', NEW.status, 'fkg_penulis', NEW.fkg_penulis, 'likes', NEW.likes));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tambah_jumlah_blacklist` AFTER UPDATE ON `tbl_cerita` FOR EACH ROW BEGIN
    IF NEW.status = '0' THEN
        UPDATE ceritaprev SET jumlah_blacklist = jumlah_blacklist + 1 WHERE id = (SELECT id FROM users WHERE uuid_users = NEW.fkg_penulis);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trigger_api_logsup
AFTER UPDATE ON tbl_cerita
FOR EACH ROW
BEGIN
    INSERT INTO tbl_logs (action, table_name, record_id, user_id, data)
    VALUES ('update', 'tbl_cerita', NEW.id_cerita, NEW.fkg_penulis, JSON_OBJECT('judul', NEW.judul, 'videourl', NEW.videourl, 'gambar', NEW.gambar, 'deskripsi', NEW.deskripsi, 'status', NEW.status, 'fkg_penulis', NEW.fkg_penulis, 'likes', NEW.likes));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbl_logs`
--

DROP TABLE IF EXISTS `tbl_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `action` varchar(250) NOT NULL,
  `table_name` varchar(250) NOT NULL,
  `record_id` varchar(250) DEFAULT NULL,
  `user_id` varchar(250) DEFAULT NULL,
  `data` json DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_logs`
--

LOCK TABLES `tbl_logs` WRITE;
/*!40000 ALTER TABLE `tbl_logs` DISABLE KEYS */;
INSERT INTO `tbl_logs` VALUES (4,'2023-06-04 05:53:47','insert','tbl_cerita','230604125347-715713','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230604125347-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604125347-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(5,'2023-06-04 05:55:11','update','tbl_cerita','230604125347-715713','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230604125419-P-230604114202.png\", \"status\": \"1\", \"videourl\": \"20230604125419-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(6,'2023-06-04 05:59:40','insert','tbl_cerita','230604125940-467588','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230604125940-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604125940-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(7,'2023-06-04 06:00:31','insert','tbl_cerita','230604130031-152750','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230604130031-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130031-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(8,'2023-06-04 06:00:42','update','tbl_cerita','230604130031-152750','P-230604114202','{\"judul\": \"sicandb\", \"likes\": \"0\", \"gambar\": \"20230604130042-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130042-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(9,'2023-06-04 06:00:57','update','tbl_cerita','230604130031-152750','P-230604114202','{\"judul\": \"sicandb\", \"likes\": \"0\", \"gambar\": \"20230604130057-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130057-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(10,'2023-06-04 06:01:04','update','tbl_cerita','230604130031-152750','P-230604114202','{\"judul\": \"sicandb\", \"likes\": \"0\", \"gambar\": \"20230604130057-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130057-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(11,'2023-06-04 06:01:11','update','tbl_cerita','230604130031-152750','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130057-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130057-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(12,'2023-06-04 06:02:27','update','tbl_cerita','230604130031-152750','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130057-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130057-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(13,'2023-06-04 06:07:07','insert','tbl_cerita','230604130707-223649','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230604130707-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130707-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(14,'2023-06-04 06:07:35','update','tbl_cerita','230604130707-223649','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130735-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130735-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(15,'2023-06-04 06:07:43','update','tbl_cerita','230604130707-223649','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130743-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130743-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(16,'2023-06-04 06:07:46','update','tbl_cerita','230604130707-223649','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130746-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130746-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(17,'2023-06-04 06:11:32','update','tbl_cerita','230604130707-223649','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130746-P-230604114202.jpg\", \"status\": \"0\", \"videourl\": \"20230604130746-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(18,'2023-06-04 06:11:57','update','tbl_cerita','230604130707-223649','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130746-P-230604114202.jpg\", \"status\": \"2\", \"videourl\": \"20230604130746-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(19,'2023-06-04 06:18:20','insert','tbl_cerita','230604131820-61133','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230604131820-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604131820-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}');
/*!40000 ALTER TABLE `tbl_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_usersmobile`
--

DROP TABLE IF EXISTS `tbl_usersmobile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_usersmobile` (
  `uuid` varchar(250) DEFAULT NULL,
  `nama` varchar(250) DEFAULT NULL,
  `umur` varchar(250) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_usersmobile`
--

LOCK TABLES `tbl_usersmobile` WRITE;
/*!40000 ALTER TABLE `tbl_usersmobile` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_usersmobile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `uuid_users` varchar(250) NOT NULL,
  `nama` varchar(250) DEFAULT NULL,
  `password` text,
  `role` varchar(1) DEFAULT NULL,
  `alamat` text,
  PRIMARY KEY (`uuid_users`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('12321','bagusandre','1234','1','asdasdaqsdasd'),('P-230604114052','bagusandre','polibek22x','1','tenjolayabogor'),('P-230604114202','bagus asd','polibek22x','1','tenjolayabogor');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-04 13:41:11
