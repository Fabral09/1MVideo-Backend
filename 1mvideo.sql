-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: 1mvideo
-- ------------------------------------------------------
-- Server version	5.5.31-0ubuntu0.12.04.1

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

CREATE DATABASE 1mvideo;

USE 1mvideo;

--
-- Table structure for table `tbl_tags_videos`
--

DROP TABLE IF EXISTS `tbl_tags_videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tags_videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tag` int(11) DEFAULT NULL,
  `nome_tag` varchar(50) NOT NULL,
  `valore_personalizzato` varchar(100) NOT NULL,
  `id_video` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3992 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_tags_videos`
--

LOCK TABLES `tbl_tags_videos` WRITE;
/*!40000 ALTER TABLE `tbl_tags_videos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_tags_videos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_valori_tags`
--

DROP TABLE IF EXISTS `tbl_valori_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_valori_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `valore_tag` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_valori_tags`
--

LOCK TABLES `tbl_valori_tags` WRITE;
/*!40000 ALTER TABLE `tbl_valori_tags` DISABLE KEYS */;
INSERT INTO `tbl_valori_tags` VALUES (1,'La notte prima della partenza'),(2,'La sveglia'),(3,'I preparativi'),(4,'L\'appuntamento-Gli incontri'),(5,'Si parte'),(6,'Imprevisti di viaggio'),(7,'Arrivo a Roma'),(8,'Arrivo in piazza-gli incontri'),(9,'Si votano gli emergenti'),(10,'Il concertone'),(11,'Pausa concerto'),(12,'Intorno al concerto'),(13,'Fine concerto'),(14,'Un saluto'),(15,'Un pensiero'),(16,'Una battuta'),(17,'Si torna a casa - un ricordo'),(18,'Si torna a casa - i saluti finali'),(19,'L\'amicizia'),(20,'Gli amici ritrovati'),(21,'L\'amore'),(22,'L\'amore appena nato'),(23,'Gioia'),(24,'Grandi emozioni'),(25,'Le facce del concerto'),(26,'Sociale');
/*!40000 ALTER TABLE `tbl_valori_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_videos`
--

DROP TABLE IF EXISTS `tbl_videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(200) NOT NULL,
  `video_id` varchar(200) DEFAULT NULL,
  `user_id` varchar(200) DEFAULT NULL,
  `device` varchar(50) DEFAULT NULL,
  `s_geo_position` varchar(100) DEFAULT NULL,
  `s_gravity` varchar(100) DEFAULT NULL,
  `s_linear_acceleration` varchar(100) DEFAULT NULL,
  `s_orientation` varchar(100) DEFAULT NULL,
  `s_gyroscope` varchar(100) DEFAULT NULL,
  `duration` int(11) NOT NULL,
  `original_name` varchar(200) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `tmp_name` varchar(200) DEFAULT NULL,
  `error` varchar(45) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `server_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1187 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_videos`
--

LOCK TABLES `tbl_videos` WRITE;
/*!40000 ALTER TABLE `tbl_videos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_videos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-05-08 11:21:15
