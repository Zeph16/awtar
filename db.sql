/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.7.2-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: awtar
-- ------------------------------------------------------
-- Server version	11.7.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `authors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `bio` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `joined_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
INSERT INTO `authors` VALUES
(1,'sof','12345678','vcrumbleholme0@sakura.ne.jp','Sofonias','Ut at dolor quis odio consequat varius. Integer ac leo.','http://localhost:8000/images/profile1.jpg','2024-02-01 08:43:08'),
(3,'tvarker2','jJ5|y_!u)9|{','tvarker2@mail.ru','Trenna Varker','Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.','http://localhost:8000/images/profile4.jpg','2024-02-01 08:43:08'),
(4,'glintot3','tU9(<TlBk{KOq','glintot3@hubpages.com','Gibb Lintot','Pellentesque at nulla. Suspendisse potenti.','http://localhost:8000/images/profile4.jpg','2024-02-01 08:43:08'),
(5,'jdewsbury4','lV4{bmOwb@','jdewsbury4@eepurl.com','Joshua Dewsbury','Nulla ut erat id mauris vulputate elementum.','http://localhost:8000/images/profile5.jpg','2024-02-01 08:43:08');
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER author_created
AFTER INSERT ON authors
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data)
  VALUES ('authorCreated', NEW.id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER author_updated
AFTER UPDATE ON authors
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data)
  VALUES ('authorUpdated', NEW.id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER before_author_deleted
BEFORE DELETE ON authors
FOR EACH ROW
BEGIN
  DELETE FROM followers WHERE following_id = OLD.id;
  DELETE FROM followers WHERE follower_id = OLD.id;
  DELETE FROM blogs WHERE author_id = OLD.id;
  DELETE FROM comments WHERE author_id = OLD.id;
  DELETE FROM likes WHERE author_id = OLD.id;
  DELETE FROM notifications WHERE sender_id = OLD.id or recipient_id = OLD.id
; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER author_deleted
AFTER DELETE ON authors
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data)
  VALUES ('authorDeleted', OLD.id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `blogs`
--

DROP TABLE IF EXISTS `blogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `blogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `featured` tinyint(1) DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `author_id` (`author_id`),
  KEY `fk_tag` (`tag_id`),
  CONSTRAINT `blogs_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`),
  CONSTRAINT `fk_tag` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blogs`
--

LOCK TABLES `blogs` WRITE;
/*!40000 ALTER TABLE `blogs` DISABLE KEYS */;
INSERT INTO `blogs` VALUES
(1,1,'Morbi non quam nec dui luctus rutrum.','Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,1),
(2,4,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.','Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,1),
(4,4,'Pellentesque ultrices mattis odio.','In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,4),
(5,4,'In sagittis dui vel nisl.','Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.\n\nNam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,4),
(6,3,'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.','Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,2),
(7,4,'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.','Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,2),
(8,3,'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.','In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,1),
(9,1,'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,2),
(10,4,'Nam tristique tortor eu pede.','Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,1),
(11,3,'Proin at turpis a pede posuere nonummy.','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,1),
(12,3,'Fusce consequat.','Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,2),
(14,3,'Proin eu mi.','Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,3),
(15,4,'Duis mattis egestas metus.','Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,4),
(17,3,'Curabitur at ipsum ac tellus semper interdum.','Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,1),
(18,3,'Pellentesque viverra pede ac diam.','Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,4),
(19,4,'Morbi vel lectus in quam fringilla rhoncus.','Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,2),
(20,4,'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.','Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.','2024-02-01 08:43:31','2024-02-01 08:43:31',0,NULL,1),
(21,1,'But how could you live and have no story to tell?','# New Header\n\n## New second header\n\nLorem markdownum! Quae tu: qui locis partes: fugante rura, quin maneas\nconplexibus requiescere dextrasque Ecce meruit quod. Sis lateque postquam\n**rara**; mei rogus centauri interdum epulis.\n\n## Nihil subdita quibus anili\n\nSanguis c unde relevasse canibus iuvenis gemuit deae, inde orbus, ut hoc erat\nplaustri. Iura pro satis exclamatque Manto conscendere, frugum aurum arma quos\neandem! Summa sorores.\n\n## Pinus nunc\n\nA quamquam, Theseus auro duris motis **mea pavido** abstinet Pentheus? Inquit ad\naequa quia Achilles inmensa novos attonitas nato tenebroso. O cornua Calliroe\nprovolat vagantem Titaniacis forti, manusque ego.\n\n- Tyranni qui coacti verticibus inque Threiciam conubia\n- Est per silvam pariterque Phrygiae\n- Qui illa cumulumque Persea nodis praebuit annos\n\n## Margine fasque conata quam Argolica ut versa\n\nTertius alioque locus ex foedera ut mater pretium pendent accipiam servatusque.\nDolores iamque succincta et Elateia *legeret* dominum miserabile, eodem in\nrigidas Arcadis. Humus colubriferi fortis conspectum oramus datque cum\n**aliter** tecto, ab trepidat quaerit tenebant. De per.\n\nIlle nihil? Dis ipso iube **celer reieci**.\n\nAeacidis tympana robora! Temptanda amens solebat ut passim ordine nequeunt\npositas facto repulsa? Percussis ferebat quidem, te longo quaecumque, dare\nlacrimisque ille? Sidere notat; verbis Lucina ante favent pollentibus tamen\ncomae stupuit: bis inquit, non dum specus frugis retro. At meruisse icta.','2024-02-08 09:36:07','2024-02-08 09:36:07',0,'http://localhost:8000/images/blog4.jpg',1),
(22,1,'Empathy? What\'s that? Itâ€™s a sad fact, but pain only makes you sorry for yourself.','[Lorem markdownum](http://www.imumque.com/optata) etiamnum limoso cortice terrae\ndexteriore eundem: habes sed delendaque nostra Aeginae, nec. Fugant fratri hunc,\ninmeriti patior; *ad manu* tenet pietas. Unum cornu.\n\n> Lina Hecabe me quod nostrae utrimque se domum **vestibus adplicat mugitus**\n> abest germanae opusque morari. Regnum vela quod. Videntem vox alimenta emisit,\n> portante, volucris animam, undis quercu *fatalia da petentia*.\n\n## Nunc ipsa sed retro\n\nSubdita ab circumdata umerum quaeque lacrimoso stipitis premunt, ab optare\ncaptare prosum pariterque Cauni, [dedit](http://alishanc.com/laeva.html). Aquis\nsemine iussit [quo intendit erat](http://www.quotibi.net/malo-annis), tura.\nDubia Minervae et Saturnius hominemque, Achivam opibusque enim sumpserat. Haec\nab telis, ut, Quid flabat anilem; enim lumen nec!\n\nCorpore ambarum secundi edita: curribus aspergine quod quassaque, quod, medios\nvaluit donec rigidis rauco alumnus venisse nempe. Lina durata delet?\n\n## Inter Corythi tamen ad Amorum atra in\n\nUtinam vota paratu, altera auras natura *Medea amoris* terrificam et. Aberant\nnil coronis ab supero pererratis noctem, mota tundit caeso, dum me proceres\nRedditus ulterius.\n\n## Vobis per est olor tibi inmensi\n\nFractarum nil crinita dimittit solas mortalia equo fissa, suberant media\nAlcyonen paterna. Qui moratur mirabere vulneret annum et unus inpune laude, me\nilla, petiit rapida armiferae Armeniae\n[crura](http://www.nunc.org/membra-vestibus).\n\n    if (tweak) {\n        error = androidEmulation - opengl_wep;\n        qbe_undo = virus(1, insertionDesign + ip_ethics, 2);\n        flaming_cell_page.multiprocessingAddressWddm(binary_emulation, cron, 3 +\n                matrixSpeakersHyper);\n    }\n    sector_wpa(flaming_ppga_ebook(80, bsod_plagiarism_router));\n    spider_trinitron += agpSupply;\n    dvr_icann.ramTween = 1;\n    whoisQuery(ansi_ide(static_hard_ip, copyDomainExpress, mtuFirmware) - -1 +\n            paste);\n\n## Opus erit contraria hanc vestro mentitur donec\n\nEst in dant movebatur proceres; qui [veniat Troezenius\nocculta](http://humo.io/nox-sub.aspx) gestamina quo illa vidit soror. Fluctus\nfratres Nileus, et pavidus inductus effugere. Opaca sim cibus Gigantas et dedi\nmutilatae geminas errat o Medea ferant imperiumque peteretis sed modo conveniunt\nferri, **animum**. Sternis urbs. Invidit fata **egit Hic exhibuit**, sed\nagrisque enim publica inquit, haec *vestram*, domini quoque est nudis?\n\nAquae vidit; **dum late**, triformis dulce, huc fateamur quem nullus corpora\npossent per. Aetatis et centum dedit illic indoluit ab somnus, liquefaciunt\nfontis. Finem artibus mea vix!\n\nPotiere toto ipsum ferrugine Graiorum atque non, flamma at officiis factas.\n[Et](http://virusurbe.org/vires) arma.','2024-02-08 09:36:45','2024-02-08 09:36:45',0,'http://localhost:8000/images/blog4.jpg',1),
(23,1,'The skies piss on everyone the same.','Lorem markdownum conbiberat deprendi inque et sub perarantem noctes laqueosque\nfuerat discubuere quod, nec videri aspera. Scit iussit e genusque coepto\nlongave, de capillos dubio *honor secernunt* terra et, inde tantum. Putri\nsolebam, vincloque concubitus duo meum adhibere vulgusque ab minus bracchia\nquanto prodita pollue venti. Est quasque salutem datur caelum mittunt clavae\nPhoebus: nec duo inportuna lucem, superare.\n\n- Nostrum incertae fiunt heros manumque nostro\n- Haberi arbitrio muneris Solem videndum saeviat caesarumque\n- Dixerat gurgite casu Iove Semiramio Ulixes capillos\n- Visaque Argolicae senis\n\nUvis auro; est brumalis adpareat Troiae ex longis sanguine, cavatur ut sumit.\nHaemonias natis, in milite non cura manu, fervoribus beati illic! Catenis illa\ncetera hic inferni enixa angit, montisque deum, data Ulixem tamen et linguae.\n\n## Colle minasque et ignibus pelagoque quid\n\nSunto adorat si possis colo arcitenens, sic, sed undis fraxinus mansit, gradus\ncolles subposuisse adspicit fiducia derant! Est duorum sentit et Cephesidas\nflorem. Ordine inventa ad ramis. Nodis Iuli non vacuas non Minervae quoque metu\niactu posuitque pectora anguis! Cnosiacaeque ambit enim ituros, et anilem,\nOssaeae et milia tectus, cum te inhaeret iugulata tuum.\n\n    if (wan_streaming + scrollModifier + search) {\n        dpiAtm(tag_bare / redundancy_state, keyPrinterCron + impact_sound);\n        basicRom(commercialDirect(bit_card_software), spywareAiff.double_finder(\n                39784, 62), midiBetaHalftone + cookie);\n    } else {\n        pdf -= logDockingRuby;\n    }\n    publishing_mca = copyrightCdn;\n    diskIpxHard += 87;\n    var mnemonic_rpc_parity = xhtml_sound_serial;\n\nA edidit **Ionium** innumeris, senex **quamquam**, ut ceditque qui. Tamen mihi,\nanum tellusAndros sineres haut vulnera [peregrina\nboni](http://undis.com/deriguere.html) destinat patrii, utque ulla. Quercus\nsolidum dictu, rector dea **fuit validos** Oeten ambiguo dederat, et caput me\nstupuit, et patens; cum.\n\n## Hic coepi abesse\n\nVobis pro Achille sorores tuo oris quos ingemuit cunctantem lintea dissimilemque\ninde blanditur undis canistris Aurora externasque. Arge cuspide undis **longius\nsi pluvialis** et ut novis, *eo annis*: non aequora quam. Adiuvet prodes fratrem\ncaeruleaeque nomen draconum animae. Peragit vidi Liber posituro nam Agaue\nprimoque.\n\n> Adde nervis sparsuras consorte [siquis](http://www.agris.com/vilisque.html);\n> ferebat et superata, et et. Turnusque plaustrum cives, Minos umoris, Echion\n> quae *circumdata tumet* reparabat secutus pependit caelum. Moveo in dicor [in\n> invidia](http://non.org/ideoque-infelix) a si tota Troiani crura.\n> Verticibusque extemplo io auras adversum Saturnia arator fragorem Procne.\n\n## Fer nempe rationis auctorem\n\nNam iuro videbar quod, cursu vero tamen, agat est arte inferiora. Per vixque.\nQuod *pignus* membra; futura regnumque vultum, aquarum Veneris. Concutiens iacet\nagros nota inmenso: opes, adiutrixque forma [praelate et](http://non.com/census)\ncolunt.\n\n> Aristas onus quoque captam. Hoc tinxit sic guttura pectora: magna dubioque\n> queri quattuor. Funera te nymphas fortuna cineres *increpat ut* Minos rumpunt?\n\n## Inbutam mitior levitate pariter hiemes arvis corpora\n\nCum *citius verba* promissaque quae ingenua! Summum aquae colis sanguine\ndiscederet: sedem **augentur** redigentur Medon; ut aurem vultum petita, curia.\nAuro occupat vocem diva Oliaros heros quod linigera re ecce, pateat, sit. Sic\nSalmacis atra celerem Ophiusiaque quem undis obliquos aequales infundere tristis\ncomes facies nubibus. Cornu cava coronae Coeo odium; aquae in nescio, et\nincurvae?\n\n1. Suo anxia interea non adversi nobis\n2. Urbes gaudete\n3. Accedere deum me iacentes subitus\n\n## Sub cum sustinet et glaebae\n\nNumerum in ubi et monitusque fassaque, et tepidi concessa videtur numeratur,\npectine? Dum fuit sua trepidumque miserrima verbis pondus vulnera patris\n*intonsum* terga. In vide designat, sedatis et mortis naribus deme, ingrate\ndelphines videbit Myconon animos, foliis. Conplentur inscius defensae, cruorem,\nhanc utque aevi viam ausum, quae Iuppiter seducta. Tibi habe optabile Proximus\nnocti cunctaque *meminere o ferocia* fama calcat Cyllenide iamque?\n\n    if (fifo_rootkit_encoding.file.mountainDcimMiddleware(character_hexadecimal,\n            pram) + rte_samba_quicktime.capacityVdsl(mysql_adapter_plug)) {\n        verticalScroll(array_layout);\n    } else {\n        bot_process = startParity;\n        ansiHoneypot -= drive_raid;\n    }\n    php_megahertz_subnet.icqPower(verticalRecursiveSoftware(megabit, jsf_css,\n            camera) + systemFilename);\n    if (copyright * google_process.commerce(open) * macCertificateTrackball) {\n        firmware_text += 1;\n    }\n    ppc_tag_zip = 1;\n\nSex pulsat Eous et montes, tempore quia pennis tum. Patet *saepe demens* ex per\neburno fluxit Pithecusas turbae bellum sive fert!','2024-02-08 09:35:15','2024-02-08 09:35:15',0,'http://localhost:8000/images/blog5.jpg',1),
(24,1,'Test blog 2 electric boogaloo','This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. \n# Welcome\nThis is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. \n- This is my blog. \n- This is my blog. \n- This is my blog. \n## Once again\nThis is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. This is my blog. \n\n**Thanks for reading!**','2024-02-08 09:37:01','2024-02-08 09:37:01',0,'http://localhost:8000/images/blog3.jpg',1),
(25,1,'You have to be realistic about these things.','This is a very wonderful blog.\n# HALLO THERE\nyes yes','2024-02-08 09:37:28','2024-02-08 09:37:28',0,'http://localhost:8000/images/blog3.jpg',1),
(26,1,'This is my blog','This is my blogThis is my blogThis is my blogThis is my blogThis is my blog This is my blogThis is my blogThis is my blogThis is my blogThis is my blog This is my blogThis is my blogThis is my blogThis is my blogThis is my blog This is my blogThis is my blogThis is my blogThis is my blogThis is my blog\n# Title\n- one\ntest\n\n','2024-02-08 09:35:41','2024-02-08 09:35:41',0,'http://localhost:8000/images/blog6.jpg',1),
(28,1,'New blog','# My title\nMy list\n- one \n- two\n- three','2024-02-08 09:42:45','2024-02-08 09:42:45',0,'http://localhost:8000/images/blog2.jpg',1),
(29,1,'I will search for this later.','# Header 1\n## Header 2\n### Header 3\n\n*This is italic*\n\n**This is bold**\n\nThis is a list of items:\n- First\n- Second\n- Third','2024-02-08 12:42:13','2024-02-08 12:42:13',0,'http://localhost:8000/images/blog3.jpg',1);
/*!40000 ALTER TABLE `blogs` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER blog_created
AFTER INSERT ON blogs
FOR EACH ROW
BEGIN
  
  INSERT INTO events (type, data) VALUES ('blogCreated', NEW.id);

  
  INSERT INTO notifications (recipient_id, sender_id, action, action_id)
  SELECT followers.follower_id, NEW.author_id, 'blogCreated', NEW.id
  FROM followers
  WHERE followers.following_id = NEW.author_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER blog_edited
AFTER UPDATE ON blogs
FOR EACH ROW
BEGIN
  
  INSERT INTO events (type, data) VALUES ('blogEdited', OLD.id);

  
  INSERT INTO notifications (recipient_id, sender_id, action, action_id)
  SELECT followers.follower_id, OLD.author_id, 'blogEdited', OLD.id
  FROM followers
  WHERE followers.following_id = OLD.author_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER before_blog_deleted
BEFORE DELETE ON blogs
FOR EACH ROW
BEGIN
  DELETE FROM bookmarks WHERE blog_id = OLD.id;
  DELETE FROM comments WHERE blog_id = OLD.id;
  DELETE FROM likes WHERE blog_id = OLD.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER blog_deleted
AFTER DELETE ON blogs
FOR EACH ROW
BEGIN
  
  INSERT INTO events (type, data) VALUES ('blogDeleted', OLD.id);

  DELETE FROM notifications
    WHERE sender_id = OLD.author_id
      AND action_id = OLD.id
      AND action in ('blogCreated', 'blogEdited');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `bookmarks`
--

DROP TABLE IF EXISTS `bookmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookmarks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author_id` int(11) NOT NULL,
  `blog_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `author_id` (`author_id`),
  KEY `blog_id` (`blog_id`),
  CONSTRAINT `bookmarks_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`),
  CONSTRAINT `bookmarks_ibfk_2` FOREIGN KEY (`blog_id`) REFERENCES `blogs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks`
--

LOCK TABLES `bookmarks` WRITE;
/*!40000 ALTER TABLE `bookmarks` DISABLE KEYS */;
INSERT INTO `bookmarks` VALUES
(9,1,8,'2024-02-08 12:34:30'),
(10,3,29,'2024-02-08 13:08:08');
/*!40000 ALTER TABLE `bookmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author_id` int(11) NOT NULL,
  `blog_id` int(11) NOT NULL,
  `parent_comment_id` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `author_id` (`author_id`),
  KEY `blog_id` (`blog_id`),
  KEY `parent_comment_id` (`parent_comment_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`),
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`blog_id`) REFERENCES `blogs` (`id`),
  CONSTRAINT `comments_ibfk_3` FOREIGN KEY (`parent_comment_id`) REFERENCES `comments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES
(4,4,15,NULL,'Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(5,4,8,NULL,'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(6,4,5,NULL,'Ut tellus. Nulla ut erat id mauris vulputate elementum.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(7,4,2,NULL,'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(10,5,9,NULL,'Fusce consequat. Nulla nisl.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(11,5,20,NULL,'Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(12,1,18,NULL,'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(15,3,8,NULL,'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(17,4,10,NULL,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(18,4,4,NULL,'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(19,5,19,NULL,'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(20,5,7,NULL,'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(21,1,15,NULL,'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(22,1,15,NULL,'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(23,4,15,NULL,'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(24,3,14,NULL,'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(25,1,6,NULL,'Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(26,4,12,NULL,'Duis aliquam convallis nunc.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(27,3,6,NULL,'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(29,3,8,NULL,'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(30,1,12,NULL,'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(31,1,10,NULL,'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(32,3,12,NULL,'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(34,1,1,NULL,'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(36,3,11,NULL,'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(37,1,2,NULL,'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(38,1,20,NULL,'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(39,4,8,NULL,'Nulla facilisi.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(40,4,18,NULL,'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(41,5,6,NULL,'Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui.','2024-02-02 16:20:18','2024-02-02 16:20:18'),
(42,1,18,NULL,'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(44,4,10,NULL,'Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(45,5,8,NULL,'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(47,1,8,NULL,'Aliquam non mauris.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(50,5,8,NULL,'Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(51,3,17,NULL,'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(52,5,18,NULL,'Nulla ut erat id mauris vulputate elementum.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(53,4,5,NULL,'Suspendisse ornare consequat lectus.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(55,4,6,NULL,'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(56,4,11,NULL,'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(58,3,17,NULL,'Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(59,1,11,NULL,'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(61,4,1,NULL,'Etiam justo. Etiam pretium iaculis justo.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(63,5,14,NULL,'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(64,4,5,NULL,'Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(66,5,10,NULL,'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(67,5,1,NULL,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(68,5,17,NULL,'Maecenas pulvinar lobortis est. Phasellus sit amet erat.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(69,3,2,NULL,'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(71,5,20,NULL,'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(72,1,1,NULL,'Suspendisse accumsan tortor quis turpis.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(74,5,20,NULL,'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(75,3,17,NULL,'Curabitur at ipsum ac tellus semper interdum.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(76,3,1,NULL,'Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(78,4,18,NULL,'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(79,1,18,NULL,'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(80,3,1,NULL,'Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(81,4,9,NULL,'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(82,3,17,NULL,'Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(83,4,20,NULL,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(85,3,1,NULL,'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(86,1,12,NULL,'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(89,1,8,NULL,'Curabitur gravida nisi at nibh.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(90,1,10,NULL,'Quisque id justo sit amet sapien dignissim vestibulum.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(91,1,2,NULL,'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(92,1,8,NULL,'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(94,1,10,NULL,'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(97,4,20,NULL,'Proin eu mi. Nulla ac enim.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(99,1,9,NULL,'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(103,4,2,NULL,'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.','2024-02-02 16:20:19','2024-02-02 16:20:19'),
(111,1,7,NULL,'Commented with curl, catch it SSE!','2024-02-03 09:48:39','2024-02-03 09:48:39'),
(112,1,7,NULL,'Commented through input','2024-02-03 09:49:26','2024-02-03 09:49:26'),
(114,1,20,NULL,'Wow!!! This is marvelous!!','2024-02-05 20:14:26','2024-02-05 20:14:26'),
(115,1,22,NULL,'THis is a comment','2024-02-06 14:26:04','2024-02-06 14:26:04'),
(116,1,7,NULL,'Another comment','2024-02-06 20:56:27','2024-02-06 20:56:27'),
(117,1,7,NULL,'Another another comment','2024-02-06 20:56:32','2024-02-06 20:56:32'),
(118,1,7,NULL,'Yet another one!','2024-02-06 20:56:42','2024-02-06 20:56:42'),
(119,1,7,NULL,'You thought I was done, didn\'t you?','2024-02-06 20:56:50','2024-02-06 20:56:50'),
(122,1,8,NULL,'This was very informative.','2024-02-08 12:33:58','2024-02-08 12:33:58'),
(123,1,29,NULL,'Reach out to me at @xyz!','2024-02-08 12:42:41','2024-02-08 12:42:41'),
(124,3,14,NULL,'This is a comment yes','2025-03-19 07:45:38','2025-03-19 07:45:38'),
(125,3,14,NULL,'This is a comment?','2025-03-19 07:45:45','2025-03-19 07:45:45'),
(126,3,14,NULL,'tset','2025-03-19 07:46:45','2025-03-19 07:46:45');
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER comment_created
AFTER INSERT ON comments
FOR EACH ROW
BEGIN
  DECLARE blog_author_id INT;

  
  SELECT author_id INTO blog_author_id
  FROM blogs
  WHERE id = NEW.blog_id;

  INSERT INTO events (type, data) VALUES ('commentCreated', NEW.id);
  
  INSERT INTO notifications (recipient_id, sender_id, action, action_id)
  VALUES (blog_author_id, NEW.author_id, 'newComment', NEW.id);

  
  INSERT INTO notifications (recipient_id, sender_id, action, action_id)
  SELECT followers.follower_id, NEW.author_id, 'followedAuthorComment', NEW.id
  FROM followers
  WHERE followers.following_id = NEW.author_id
    AND followers.follower_id != blog_author_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER comment_edited
AFTER UPDATE ON comments
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data) VALUES ('commentEdited', NEW.id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER before_comment_deleted
BEFORE DELETE ON comments
FOR EACH ROW
BEGIN
  DELETE FROM likes WHERE comment_id = OLD.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER comment_deleted
AFTER DELETE ON comments
FOR EACH ROW
BEGIN
  DECLARE blog_author_id INT;

  
  SELECT author_id INTO blog_author_id
  FROM blogs
  WHERE id = OLD.blog_id;

  INSERT INTO events (type, data) VALUES ('commentDeleted', OLD.id);

  
  DELETE FROM notifications
  WHERE recipient_id = blog_author_id
    AND sender_id = OLD.author_id
    AND action = 'newComment'
    AND action_id = OLD.id;

  
  DELETE FROM notifications
  WHERE sender_id = OLD.author_id
    AND action = 'followedAuthorComment'
    AND action_id = OLD.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `data` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1350 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES
(215,'authorCreated',4),
(216,'authorCreated',5),
(217,'authorCreated',6),
(218,'authorCreated',7),
(219,'authorCreated',8),
(220,'blogCreated',71),
(221,'blogCreated',73),
(222,'blogCreated',74),
(223,'blogCreated',76),
(224,'blogCreated',79),
(225,'blogCreated',84),
(226,'blogCreated',88),
(227,'blogCreated',89),
(228,'blogDeleted',71),
(229,'blogDeleted',73),
(230,'blogDeleted',74),
(231,'blogDeleted',76),
(232,'blogDeleted',79),
(233,'blogDeleted',84),
(234,'blogDeleted',88),
(235,'blogDeleted',89),
(236,'authorDeleted',4),
(237,'authorDeleted',5),
(238,'authorDeleted',6),
(239,'authorDeleted',7),
(240,'authorDeleted',8),
(241,'authorCreated',1),
(242,'authorCreated',2),
(243,'authorCreated',3),
(244,'authorCreated',4),
(245,'authorCreated',5),
(246,'blogCreated',1),
(247,'blogCreated',2),
(248,'blogCreated',3),
(249,'blogCreated',4),
(250,'blogCreated',5),
(251,'blogCreated',6),
(252,'blogCreated',7),
(253,'blogCreated',8),
(254,'blogCreated',9),
(255,'blogCreated',10),
(256,'blogCreated',11),
(257,'blogCreated',12),
(258,'blogCreated',13),
(259,'blogCreated',14),
(260,'blogCreated',15),
(261,'blogCreated',16),
(262,'blogCreated',17),
(263,'blogCreated',18),
(264,'blogCreated',19),
(265,'blogCreated',20),
(266,'commentCreated',4),
(267,'newNotification',4),
(268,'commentCreated',5),
(269,'newNotification',3),
(270,'commentCreated',6),
(271,'newNotification',4),
(272,'commentCreated',7),
(273,'newNotification',4),
(274,'commentCreated',8),
(275,'newNotification',2),
(276,'commentCreated',9),
(277,'newNotification',2),
(278,'commentCreated',10),
(279,'newNotification',1),
(280,'commentCreated',11),
(281,'newNotification',4),
(282,'commentCreated',12),
(283,'newNotification',3),
(284,'commentCreated',13),
(285,'newNotification',4),
(286,'commentCreated',14),
(287,'newNotification',2),
(288,'commentCreated',15),
(289,'newNotification',3),
(290,'commentCreated',16),
(291,'newNotification',2),
(292,'commentCreated',17),
(293,'newNotification',4),
(294,'commentCreated',18),
(295,'newNotification',4),
(296,'commentCreated',19),
(297,'newNotification',4),
(298,'commentCreated',20),
(299,'newNotification',4),
(300,'commentCreated',21),
(301,'newNotification',4),
(302,'commentCreated',22),
(303,'newNotification',4),
(304,'commentCreated',23),
(305,'newNotification',4),
(306,'commentCreated',24),
(307,'newNotification',3),
(308,'commentCreated',25),
(309,'newNotification',3),
(310,'commentCreated',26),
(311,'newNotification',3),
(312,'commentCreated',27),
(313,'newNotification',3),
(314,'commentCreated',28),
(315,'newNotification',2),
(316,'commentCreated',29),
(317,'newNotification',3),
(318,'commentCreated',30),
(319,'newNotification',3),
(320,'commentCreated',31),
(321,'newNotification',4),
(322,'commentCreated',32),
(323,'newNotification',3),
(324,'commentCreated',33),
(325,'newNotification',2),
(326,'commentCreated',34),
(327,'newNotification',1),
(328,'commentCreated',35),
(329,'newNotification',2),
(330,'commentCreated',36),
(331,'newNotification',3),
(332,'commentCreated',37),
(333,'newNotification',4),
(334,'commentCreated',38),
(335,'newNotification',4),
(336,'commentCreated',39),
(337,'newNotification',3),
(338,'commentCreated',40),
(339,'newNotification',3),
(340,'commentCreated',41),
(341,'newNotification',3),
(342,'commentCreated',42),
(343,'newNotification',3),
(344,'commentCreated',43),
(345,'newNotification',2),
(346,'commentCreated',44),
(347,'newNotification',4),
(348,'commentCreated',45),
(349,'newNotification',3),
(350,'commentCreated',46),
(351,'newNotification',2),
(352,'commentCreated',47),
(353,'newNotification',3),
(354,'commentCreated',48),
(355,'newNotification',4),
(356,'commentCreated',49),
(357,'newNotification',4),
(358,'commentCreated',50),
(359,'newNotification',3),
(360,'commentCreated',51),
(361,'newNotification',3),
(362,'commentCreated',52),
(363,'newNotification',3),
(364,'commentCreated',53),
(365,'newNotification',4),
(366,'commentCreated',54),
(367,'newNotification',4),
(368,'commentCreated',55),
(369,'newNotification',3),
(370,'commentCreated',56),
(371,'newNotification',3),
(372,'commentCreated',57),
(373,'newNotification',3),
(374,'commentCreated',58),
(375,'newNotification',3),
(376,'commentCreated',59),
(377,'newNotification',3),
(378,'commentCreated',60),
(379,'newNotification',3),
(380,'commentCreated',61),
(381,'newNotification',1),
(382,'commentCreated',62),
(383,'newNotification',4),
(384,'commentCreated',63),
(385,'newNotification',3),
(386,'commentCreated',64),
(387,'newNotification',4),
(388,'commentCreated',65),
(389,'newNotification',3),
(390,'commentCreated',66),
(391,'newNotification',4),
(392,'commentCreated',67),
(393,'newNotification',1),
(394,'commentCreated',68),
(395,'newNotification',3),
(396,'commentCreated',69),
(397,'newNotification',4),
(398,'commentCreated',70),
(399,'newNotification',2),
(400,'commentCreated',71),
(401,'newNotification',4),
(402,'commentCreated',72),
(403,'newNotification',1),
(404,'commentCreated',73),
(405,'newNotification',4),
(406,'commentCreated',74),
(407,'newNotification',4),
(408,'commentCreated',75),
(409,'newNotification',3),
(410,'commentCreated',76),
(411,'newNotification',1),
(412,'commentCreated',77),
(413,'newNotification',1),
(414,'commentCreated',78),
(415,'newNotification',3),
(416,'commentCreated',79),
(417,'newNotification',3),
(418,'commentCreated',80),
(419,'newNotification',1),
(420,'commentCreated',81),
(421,'newNotification',1),
(422,'commentCreated',82),
(423,'newNotification',3),
(424,'commentCreated',83),
(425,'newNotification',4),
(426,'commentCreated',84),
(427,'newNotification',3),
(428,'commentCreated',85),
(429,'newNotification',1),
(430,'commentCreated',86),
(431,'newNotification',3),
(432,'commentCreated',87),
(433,'newNotification',2),
(434,'commentCreated',88),
(435,'newNotification',3),
(436,'commentCreated',89),
(437,'newNotification',3),
(438,'commentCreated',90),
(439,'newNotification',4),
(440,'commentCreated',91),
(441,'newNotification',4),
(442,'commentCreated',92),
(443,'newNotification',3),
(444,'commentCreated',93),
(445,'newNotification',1),
(446,'commentCreated',94),
(447,'newNotification',4),
(448,'commentCreated',95),
(449,'newNotification',2),
(450,'commentCreated',96),
(451,'newNotification',3),
(452,'commentCreated',97),
(453,'newNotification',4),
(454,'commentCreated',98),
(455,'newNotification',2),
(456,'commentCreated',99),
(457,'newNotification',1),
(458,'commentCreated',100),
(459,'newNotification',2),
(460,'commentCreated',101),
(461,'newNotification',2),
(462,'commentCreated',102),
(463,'newNotification',4),
(464,'commentCreated',103),
(465,'newNotification',4),
(466,'commentCreated',104),
(467,'newNotification',4),
(468,'commentLiked',48),
(469,'newNotification',2),
(470,'commentCreated',105),
(471,'newNotification',4),
(472,'commentCreated',106),
(473,'newNotification',4),
(474,'commentDeleted',106),
(475,'removedNotification',4),
(476,'commentDeleted',105),
(477,'removedNotification',4),
(478,'commentDeleted',104),
(479,'removedNotification',4),
(480,'commentCreated',107),
(481,'newNotification',4),
(482,'commentDeleted',107),
(483,'removedNotification',4),
(484,'commentLiked',20),
(485,'newNotification',5),
(486,'commentLiked',20),
(487,'newNotification',5),
(488,'commentLiked',54),
(489,'newNotification',2),
(490,'commentUnliked',54),
(491,'removedNotification',2),
(492,'commentUnliked',20),
(493,'removedNotification',5),
(494,'removedNotification',5),
(495,'commentUnliked',20),
(496,'commentUnliked',48),
(497,'removedNotification',2),
(498,'commentLiked',48),
(499,'newNotification',2),
(500,'commentCreated',108),
(501,'newNotification',4),
(502,'commentCreated',109),
(503,'newNotification',4),
(504,'commentCreated',110),
(505,'newNotification',4),
(506,'commentLiked',10),
(507,'newNotification',5),
(508,'commentUnliked',10),
(509,'removedNotification',5),
(510,'blogLiked',7),
(511,'newNotification',4),
(512,'blogUnliked',7),
(513,'removedNotification',4),
(514,'blogLiked',7),
(515,'newNotification',4),
(516,'blogUnliked',7),
(517,'removedNotification',4),
(518,'blogLiked',7),
(519,'newNotification',4),
(520,'blogLiked',9),
(521,'newNotification',1),
(522,'blogUnliked',9),
(523,'removedNotification',1),
(524,'blogLiked',9),
(525,'newNotification',1),
(526,'blogUnliked',9),
(527,'removedNotification',1),
(528,'blogLiked',9),
(529,'newNotification',1),
(530,'blogUnliked',9),
(531,'removedNotification',1),
(532,'blogLiked',9),
(533,'newNotification',1),
(534,'blogUnliked',9),
(535,'removedNotification',1),
(536,'blogLiked',9),
(537,'newNotification',1),
(538,'blogUnliked',9),
(539,'removedNotification',1),
(540,'blogLiked',9),
(541,'newNotification',1),
(542,'blogUnliked',9),
(543,'removedNotification',1),
(544,'blogLiked',9),
(545,'newNotification',1),
(546,'blogUnliked',9),
(547,'removedNotification',1),
(548,'blogLiked',9),
(549,'newNotification',1),
(550,'blogUnliked',9),
(551,'removedNotification',1),
(552,'blogLiked',9),
(553,'newNotification',1),
(554,'blogUnliked',9),
(555,'removedNotification',1),
(556,'blogLiked',9),
(557,'newNotification',1),
(558,'blogUnliked',9),
(559,'removedNotification',1),
(560,'commentDeleted',109),
(561,'removedNotification',4),
(562,'commentDeleted',110),
(563,'removedNotification',4),
(564,'commentDeleted',108),
(565,'removedNotification',4),
(566,'commentLiked',48),
(567,'newNotification',2),
(568,'commentLiked',48),
(569,'newNotification',2),
(570,'commentLiked',48),
(571,'newNotification',2),
(572,'commentUnliked',48),
(573,'removedNotification',2),
(574,'removedNotification',2),
(575,'removedNotification',2),
(576,'removedNotification',2),
(577,'commentUnliked',48),
(578,'commentUnliked',48),
(579,'commentUnliked',48),
(580,'commentLiked',48),
(581,'newNotification',2),
(582,'commentUnliked',48),
(583,'removedNotification',2),
(584,'commentLiked',48),
(585,'newNotification',2),
(586,'commentUnliked',48),
(587,'removedNotification',2),
(588,'commentLiked',48),
(589,'newNotification',2),
(590,'commentCreated',111),
(591,'newNotification',4),
(592,'commentCreated',112),
(593,'newNotification',4),
(594,'newNotification',2),
(595,'newNotification',4),
(596,'newNotification',1),
(597,'newNotification',4),
(598,'newNotification',4),
(599,'newNotification',4),
(600,'newNotification',4),
(601,'newNotification',4),
(602,'blogLiked',17),
(603,'newNotification',3),
(604,'newNotification',2),
(605,'newNotification',3),
(606,'blogUnliked',17),
(607,'removedNotification',3),
(608,'removedNotification',2),
(609,'commentCreated',113),
(610,'newNotification',3),
(611,'newNotification',2),
(612,'commentLiked',113),
(613,'newNotification',1),
(614,'commentUnliked',113),
(615,'removedNotification',1),
(616,'commentDeleted',113),
(617,'removedNotification',3),
(618,'removedNotification',2),
(619,'commentLiked',36),
(620,'newNotification',3),
(621,'commentUnliked',36),
(622,'removedNotification',3),
(623,'blogCreated',21),
(624,'newNotification',2),
(625,'blogCreated',22),
(626,'newNotification',2),
(627,'blogCreated',23),
(628,'newNotification',2),
(629,'blogCreated',24),
(630,'newNotification',2),
(631,'commentCreated',114),
(632,'newNotification',4),
(633,'newNotification',2),
(634,'commentLiked',11),
(635,'newNotification',5),
(636,'commentUnliked',11),
(637,'removedNotification',5),
(638,'commentLiked',11),
(639,'newNotification',5),
(640,'newNotification',4),
(641,'blogLiked',20),
(642,'newNotification',4),
(643,'newNotification',2),
(644,'blogCreated',25),
(645,'newNotification',2),
(646,'blogLiked',2),
(647,'newNotification',4),
(648,'newNotification',2),
(649,'newNotification',4),
(650,'newNotification',4),
(651,'newNotification',4),
(652,'newNotification',4),
(653,'newNotification',4),
(654,'newNotification',4),
(655,'newNotification',4),
(656,'blogLiked',10),
(657,'newNotification',4),
(658,'blogLiked',22),
(659,'newNotification',1),
(660,'commentCreated',115),
(661,'newNotification',1),
(662,'newNotification',1),
(663,'blogCreated',26),
(664,'newNotification',1),
(665,'commentLiked',115),
(666,'newNotification',1),
(667,'commentUnliked',115),
(668,'removedNotification',1),
(669,'blogUnliked',22),
(670,'removedNotification',1),
(671,'blogUnliked',10),
(672,'removedNotification',4),
(673,'blogLiked',10),
(674,'newNotification',4),
(675,'newNotification',1),
(676,'blogUnliked',10),
(677,'removedNotification',4),
(678,'removedNotification',1),
(679,'blogLiked',10),
(680,'newNotification',4),
(681,'newNotification',1),
(682,'blogUnliked',10),
(683,'removedNotification',4),
(684,'removedNotification',1),
(685,'blogLiked',10),
(686,'newNotification',4),
(687,'newNotification',1),
(688,'blogUnliked',10),
(689,'removedNotification',4),
(690,'removedNotification',1),
(691,'blogLiked',10),
(692,'newNotification',4),
(693,'newNotification',1),
(694,'blogUnliked',10),
(695,'removedNotification',4),
(696,'removedNotification',1),
(697,'blogLiked',10),
(698,'newNotification',4),
(699,'newNotification',1),
(700,'blogUnliked',10),
(701,'removedNotification',4),
(702,'removedNotification',1),
(703,'newNotification',2),
(704,'newNotification',2),
(705,'newNotification',2),
(706,'newNotification',2),
(707,'newNotification',2),
(708,'newNotification',2),
(709,'newNotification',2),
(710,'newNotification',2),
(711,'newNotification',2),
(712,'newNotification',2),
(713,'newNotification',2),
(714,'newNotification',2),
(715,'newNotification',2),
(716,'newNotification',2),
(717,'newNotification',2),
(718,'newNotification',2),
(719,'blogLiked',23),
(720,'newNotification',1),
(721,'blogLiked',23),
(722,'newNotification',1),
(723,'blogLiked',1),
(724,'newNotification',1),
(725,'blogLiked',1),
(726,'newNotification',1),
(727,'blogLiked',9),
(728,'newNotification',1),
(729,'blogLiked',9),
(730,'newNotification',1),
(731,'blogLiked',21),
(732,'newNotification',1),
(733,'blogEdited',21),
(734,'newNotification',1),
(735,'blogEdited',21),
(736,'newNotification',1),
(737,'blogCreated',27),
(738,'newNotification',1),
(739,'blogDeleted',27),
(740,'removedNotification',1),
(741,'blogLiked',23),
(742,'newNotification',1),
(743,'commentCreated',116),
(744,'newNotification',4),
(745,'newNotification',1),
(746,'commentCreated',117),
(747,'newNotification',4),
(748,'newNotification',1),
(749,'commentCreated',118),
(750,'newNotification',4),
(751,'newNotification',1),
(752,'commentCreated',119),
(753,'newNotification',4),
(754,'newNotification',1),
(755,'removedNotification',1),
(756,'removedNotification',4),
(757,'removedNotification',3),
(758,'removedNotification',4),
(759,'removedNotification',4),
(760,'removedNotification',2),
(761,'removedNotification',2),
(762,'removedNotification',1),
(763,'removedNotification',4),
(764,'removedNotification',3),
(765,'removedNotification',4),
(766,'removedNotification',2),
(767,'removedNotification',3),
(768,'removedNotification',2),
(769,'removedNotification',4),
(770,'removedNotification',4),
(771,'removedNotification',4),
(772,'removedNotification',4),
(773,'removedNotification',4),
(774,'removedNotification',4),
(775,'removedNotification',4),
(776,'removedNotification',3),
(777,'removedNotification',3),
(778,'removedNotification',3),
(779,'removedNotification',3),
(780,'removedNotification',2),
(781,'removedNotification',3),
(782,'removedNotification',3),
(783,'removedNotification',4),
(784,'removedNotification',3),
(785,'removedNotification',2),
(786,'removedNotification',1),
(787,'removedNotification',2),
(788,'removedNotification',3),
(789,'removedNotification',4),
(790,'removedNotification',4),
(791,'removedNotification',3),
(792,'removedNotification',3),
(793,'removedNotification',3),
(794,'removedNotification',3),
(795,'removedNotification',2),
(796,'removedNotification',4),
(797,'removedNotification',3),
(798,'removedNotification',2),
(799,'removedNotification',3),
(800,'removedNotification',4),
(801,'removedNotification',4),
(802,'removedNotification',3),
(803,'removedNotification',3),
(804,'removedNotification',3),
(805,'removedNotification',4),
(806,'removedNotification',4),
(807,'removedNotification',3),
(808,'removedNotification',3),
(809,'removedNotification',3),
(810,'removedNotification',3),
(811,'removedNotification',3),
(812,'removedNotification',3),
(813,'removedNotification',1),
(814,'removedNotification',4),
(815,'removedNotification',3),
(816,'removedNotification',4),
(817,'removedNotification',3),
(818,'removedNotification',4),
(819,'removedNotification',1),
(820,'removedNotification',3),
(821,'removedNotification',4),
(822,'removedNotification',2),
(823,'removedNotification',4),
(824,'removedNotification',1),
(825,'removedNotification',4),
(826,'removedNotification',4),
(827,'removedNotification',3),
(828,'removedNotification',1),
(829,'removedNotification',1),
(830,'removedNotification',3),
(831,'removedNotification',3),
(832,'removedNotification',1),
(833,'removedNotification',1),
(834,'removedNotification',3),
(835,'removedNotification',4),
(836,'removedNotification',3),
(837,'removedNotification',1),
(838,'removedNotification',3),
(839,'removedNotification',2),
(840,'removedNotification',3),
(841,'removedNotification',3),
(842,'removedNotification',4),
(843,'removedNotification',4),
(844,'removedNotification',3),
(845,'removedNotification',1),
(846,'removedNotification',4),
(847,'removedNotification',2),
(848,'removedNotification',3),
(849,'removedNotification',4),
(850,'removedNotification',2),
(851,'removedNotification',1),
(852,'removedNotification',2),
(853,'removedNotification',2),
(854,'removedNotification',4),
(855,'removedNotification',4),
(856,'removedNotification',4),
(857,'removedNotification',2),
(858,'removedNotification',4),
(859,'removedNotification',4),
(860,'removedNotification',2),
(861,'removedNotification',4),
(862,'removedNotification',1),
(863,'removedNotification',4),
(864,'removedNotification',4),
(865,'removedNotification',4),
(866,'removedNotification',4),
(867,'removedNotification',4),
(868,'removedNotification',3),
(869,'removedNotification',2),
(870,'removedNotification',2),
(871,'removedNotification',2),
(872,'removedNotification',2),
(873,'removedNotification',4),
(874,'removedNotification',2),
(875,'removedNotification',5),
(876,'removedNotification',4),
(877,'removedNotification',4),
(878,'removedNotification',2),
(879,'removedNotification',2),
(880,'removedNotification',4),
(881,'removedNotification',2),
(882,'removedNotification',4),
(883,'removedNotification',4),
(884,'removedNotification',4),
(885,'removedNotification',4),
(886,'removedNotification',4),
(887,'removedNotification',4),
(888,'removedNotification',4),
(889,'removedNotification',1),
(890,'removedNotification',1),
(891,'removedNotification',1),
(892,'removedNotification',2),
(893,'removedNotification',2),
(894,'removedNotification',2),
(895,'removedNotification',2),
(896,'removedNotification',2),
(897,'removedNotification',2),
(898,'removedNotification',2),
(899,'removedNotification',2),
(900,'removedNotification',2),
(901,'removedNotification',2),
(902,'removedNotification',2),
(903,'removedNotification',2),
(904,'removedNotification',2),
(905,'removedNotification',2),
(906,'removedNotification',2),
(907,'removedNotification',2),
(908,'removedNotification',1),
(909,'removedNotification',1),
(910,'removedNotification',1),
(911,'removedNotification',1),
(912,'removedNotification',1),
(913,'removedNotification',1),
(914,'removedNotification',1),
(915,'removedNotification',1),
(916,'removedNotification',1),
(917,'removedNotification',1),
(918,'removedNotification',4),
(919,'removedNotification',1),
(920,'removedNotification',4),
(921,'removedNotification',1),
(922,'removedNotification',4),
(923,'removedNotification',1),
(924,'removedNotification',4),
(925,'blogLiked',1),
(926,'newNotification',1),
(927,'blogLiked',9),
(928,'newNotification',1),
(929,'blogLiked',21),
(930,'newNotification',1),
(931,'blogLiked',22),
(932,'newNotification',1),
(933,'blogLiked',23),
(934,'newNotification',1),
(935,'blogLiked',24),
(936,'newNotification',1),
(937,'blogLiked',25),
(938,'newNotification',1),
(939,'blogLiked',26),
(940,'newNotification',1),
(941,'blogLiked',26),
(942,'newNotification',1),
(943,'blogLiked',25),
(944,'newNotification',1),
(945,'commentLiked',100),
(946,'newNotification',1),
(947,'commentLiked',101),
(948,'newNotification',1),
(949,'commentLiked',111),
(950,'newNotification',1),
(951,'commentLiked',119),
(952,'newNotification',1),
(953,'commentLiked',118),
(954,'newNotification',1),
(955,'commentLiked',37),
(956,'newNotification',1),
(957,'commentLiked',72),
(958,'newNotification',1),
(959,'commentLiked',99),
(960,'newNotification',1),
(961,'commentLiked',94),
(962,'newNotification',1),
(963,'commentLiked',92),
(964,'newNotification',1),
(965,'commentLiked',89),
(966,'newNotification',1),
(967,'commentLiked',59),
(968,'newNotification',1),
(969,'commentLiked',90),
(970,'newNotification',1),
(971,'commentLiked',115),
(972,'newNotification',1),
(973,'commentLiked',90),
(974,'newNotification',1),
(975,'commentLiked',100),
(976,'newNotification',1),
(977,'blogLiked',21),
(978,'newNotification',1),
(979,'blogLiked',21),
(980,'newNotification',1),
(981,'blogLiked',1),
(982,'newNotification',1),
(983,'blogLiked',9),
(984,'newNotification',1),
(985,'blogLiked',21),
(986,'newNotification',1),
(987,'blogLiked',22),
(988,'newNotification',1),
(989,'blogLiked',23),
(990,'newNotification',1),
(991,'blogLiked',23),
(992,'newNotification',1),
(993,'blogLiked',24),
(994,'newNotification',1),
(995,'blogLiked',25),
(996,'newNotification',1),
(997,'blogLiked',26),
(998,'newNotification',1),
(999,'commentLiked',100),
(1000,'newNotification',1),
(1001,'commentLiked',112),
(1002,'newNotification',1),
(1003,'commentLiked',114),
(1004,'newNotification',1),
(1005,'commentLiked',119),
(1006,'newNotification',1),
(1007,'blogLiked',22),
(1008,'newNotification',1),
(1009,'blogLiked',21),
(1010,'newNotification',1),
(1011,'newNotification',1),
(1012,'blogUnliked',21),
(1013,'removedNotification',1),
(1014,'newNotification',1),
(1015,'removedNotification',1),
(1016,'removedNotification',1),
(1017,'removedNotification',1),
(1018,'removedNotification',1),
(1019,'removedNotification',1),
(1020,'removedNotification',1),
(1021,'removedNotification',1),
(1022,'removedNotification',1),
(1023,'removedNotification',1),
(1024,'removedNotification',1),
(1025,'removedNotification',1),
(1026,'removedNotification',1),
(1027,'removedNotification',1),
(1028,'removedNotification',1),
(1029,'removedNotification',1),
(1030,'removedNotification',1),
(1031,'removedNotification',1),
(1032,'removedNotification',1),
(1033,'removedNotification',1),
(1034,'removedNotification',1),
(1035,'removedNotification',1),
(1036,'removedNotification',1),
(1037,'removedNotification',1),
(1038,'removedNotification',1),
(1039,'removedNotification',1),
(1040,'removedNotification',1),
(1041,'removedNotification',1),
(1042,'removedNotification',1),
(1043,'removedNotification',1),
(1044,'removedNotification',1),
(1045,'removedNotification',1),
(1046,'removedNotification',1),
(1047,'removedNotification',1),
(1048,'removedNotification',1),
(1049,'removedNotification',1),
(1050,'removedNotification',1),
(1051,'removedNotification',1),
(1052,'removedNotification',1),
(1053,'removedNotification',1),
(1054,'removedNotification',1),
(1055,'removedNotification',1),
(1056,'removedNotification',1),
(1057,'removedNotification',1),
(1058,'removedNotification',1),
(1059,'blogUnliked',21),
(1060,'blogUnliked',1),
(1061,'blogUnliked',9),
(1062,'blogUnliked',21),
(1063,'blogUnliked',22),
(1064,'blogUnliked',23),
(1065,'blogUnliked',23),
(1066,'blogUnliked',24),
(1067,'blogUnliked',25),
(1068,'blogUnliked',26),
(1069,'commentUnliked',100),
(1070,'commentUnliked',112),
(1071,'commentUnliked',114),
(1072,'commentUnliked',119),
(1073,'blogUnliked',9),
(1074,'blogUnliked',21),
(1075,'blogUnliked',22),
(1076,'blogUnliked',23),
(1077,'blogUnliked',24),
(1078,'blogUnliked',25),
(1079,'blogUnliked',26),
(1080,'blogUnliked',22),
(1081,'blogUnliked',23),
(1082,'blogUnliked',1),
(1083,'blogUnliked',9),
(1084,'blogUnliked',1),
(1085,'blogUnliked',26),
(1086,'blogUnliked',25),
(1087,'commentUnliked',100),
(1088,'commentUnliked',101),
(1089,'commentUnliked',111),
(1090,'commentUnliked',119),
(1091,'commentUnliked',118),
(1092,'commentUnliked',37),
(1093,'commentUnliked',72),
(1094,'commentUnliked',99),
(1095,'commentUnliked',94),
(1096,'commentUnliked',92),
(1097,'commentUnliked',89),
(1098,'commentUnliked',59),
(1099,'commentUnliked',90),
(1100,'commentUnliked',115),
(1101,'blogUnliked',21),
(1102,'blogLiked',1),
(1103,'newNotification',1),
(1104,'blogLiked',9),
(1105,'newNotification',1),
(1106,'blogLiked',21),
(1107,'newNotification',1),
(1108,'blogUnliked',21),
(1109,'removedNotification',1),
(1110,'blogUnliked',9),
(1111,'removedNotification',1),
(1112,'blogLiked',9),
(1113,'newNotification',1),
(1114,'blogUnliked',9),
(1115,'removedNotification',1),
(1116,'blogLiked',9),
(1117,'newNotification',1),
(1118,'blogLiked',21),
(1119,'newNotification',1),
(1120,'blogUnliked',21),
(1121,'removedNotification',1),
(1122,'blogUnliked',1),
(1123,'removedNotification',1),
(1124,'blogUnliked',9),
(1125,'removedNotification',1),
(1126,'blogLiked',21),
(1127,'newNotification',1),
(1128,'blogLiked',9),
(1129,'newNotification',1),
(1130,'blogUnliked',21),
(1131,'removedNotification',1),
(1132,'blogUnliked',9),
(1133,'removedNotification',1),
(1134,'blogLiked',1),
(1135,'newNotification',1),
(1136,'blogLiked',9),
(1137,'newNotification',1),
(1138,'blogLiked',21),
(1139,'newNotification',1),
(1140,'blogLiked',26),
(1141,'newNotification',1),
(1142,'removedNotification',1),
(1143,'removedNotification',1),
(1144,'removedNotification',1),
(1145,'removedNotification',1),
(1146,'blogUnliked',1),
(1147,'blogUnliked',9),
(1148,'blogUnliked',21),
(1149,'blogUnliked',26),
(1150,'blogLiked',9),
(1151,'newNotification',1),
(1152,'blogLiked',21),
(1153,'newNotification',1),
(1154,'blogLiked',26),
(1155,'newNotification',1),
(1156,'blogUnliked',9),
(1157,'removedNotification',1),
(1158,'blogUnliked',21),
(1159,'removedNotification',1),
(1160,'blogUnliked',26),
(1161,'removedNotification',1),
(1162,'blogLiked',3),
(1163,'newNotification',2),
(1164,'blogUnliked',3),
(1165,'removedNotification',2),
(1166,'newNotification',2),
(1167,'blogLiked',17),
(1168,'newNotification',3),
(1169,'newNotification',1),
(1170,'commentCreated',120),
(1171,'newNotification',3),
(1172,'newNotification',1),
(1173,'commentDeleted',120),
(1174,'removedNotification',3),
(1175,'removedNotification',1),
(1176,'commentCreated',121),
(1177,'newNotification',3),
(1178,'newNotification',1),
(1179,'blogUnliked',17),
(1180,'removedNotification',3),
(1181,'removedNotification',1),
(1182,'blogUnliked',2),
(1183,'blogLiked',26),
(1184,'newNotification',1),
(1185,'newNotification',2),
(1186,'authorUpdated',1),
(1187,'authorUpdated',2),
(1188,'authorUpdated',3),
(1189,'authorUpdated',4),
(1190,'authorUpdated',5),
(1191,'authorUpdated',1),
(1192,'authorUpdated',1),
(1193,'authorUpdated',1),
(1194,'authorUpdated',1),
(1195,'authorUpdated',1),
(1196,'authorUpdated',1),
(1197,'commentLiked',115),
(1198,'newNotification',1),
(1199,'commentUnliked',115),
(1200,'removedNotification',1),
(1201,'authorUpdated',1),
(1202,'authorUpdated',1),
(1203,'newNotification',5),
(1204,'commentDeleted',8),
(1205,'commentDeleted',14),
(1206,'commentDeleted',33),
(1207,'commentDeleted',43),
(1208,'commentDeleted',70),
(1209,'commentDeleted',87),
(1210,'blogDeleted',3),
(1211,'commentDeleted',28),
(1212,'commentDeleted',35),
(1213,'commentDeleted',46),
(1214,'blogDeleted',13),
(1215,'commentDeleted',9),
(1216,'commentDeleted',16),
(1217,'commentDeleted',95),
(1218,'commentDeleted',98),
(1219,'commentUnliked',100),
(1220,'commentDeleted',100),
(1221,'commentDeleted',101),
(1222,'blogDeleted',16),
(1280,'commentDeleted',13),
(1281,'commentUnliked',48),
(1282,'commentDeleted',48),
(1283,'commentDeleted',49),
(1284,'commentDeleted',54),
(1285,'commentDeleted',57),
(1286,'commentDeleted',60),
(1287,'commentDeleted',62),
(1288,'commentDeleted',65),
(1289,'commentDeleted',73),
(1290,'commentDeleted',77),
(1291,'commentDeleted',84),
(1292,'commentDeleted',88),
(1293,'commentDeleted',93),
(1294,'commentDeleted',96),
(1295,'commentDeleted',102),
(1296,'commentDeleted',121),
(1297,'removedNotification',3),
(1298,'removedNotification',1),
(1299,'removedNotification',2),
(1300,'removedNotification',2),
(1301,'authorDeleted',2),
(1302,'authorUpdated',1),
(1303,'blogEdited',23),
(1304,'blogEdited',26),
(1305,'blogEdited',21),
(1306,'blogEdited',22),
(1307,'blogEdited',24),
(1308,'blogEdited',25),
(1309,'authorUpdated',3),
(1310,'blogLiked',23),
(1311,'newNotification',1),
(1312,'newNotification',1),
(1313,'blogCreated',28),
(1314,'newNotification',3),
(1315,'commentCreated',122),
(1316,'newNotification',3),
(1317,'commentLiked',39),
(1318,'newNotification',4),
(1319,'blogLiked',8),
(1320,'newNotification',3),
(1321,'authorUpdated',1),
(1322,'blogCreated',29),
(1323,'newNotification',3),
(1324,'commentCreated',123),
(1325,'newNotification',1),
(1326,'newNotification',3),
(1327,'removedNotification',1),
(1328,'removedNotification',1),
(1329,'removedNotification',1),
(1330,'removedNotification',1),
(1331,'newNotification',4),
(1332,'authorUpdated',3),
(1333,'authorUpdated',4),
(1334,'authorUpdated',3),
(1335,'authorUpdated',1),
(1336,'authorUpdated',3),
(1337,'authorUpdated',4),
(1338,'newNotification',4),
(1339,'authorUpdated',3),
(1340,'authorUpdated',4),
(1341,'newNotification',1),
(1342,'authorUpdated',3),
(1343,'authorUpdated',1),
(1344,'commentCreated',124),
(1345,'newNotification',3),
(1346,'commentCreated',125),
(1347,'newNotification',3),
(1348,'commentCreated',126),
(1349,'newNotification',3);
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `followers`
--

DROP TABLE IF EXISTS `followers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `followers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `follower_id` int(11) NOT NULL,
  `following_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `follower_id` (`follower_id`),
  KEY `following_id` (`following_id`),
  CONSTRAINT `followers_ibfk_1` FOREIGN KEY (`follower_id`) REFERENCES `authors` (`id`),
  CONSTRAINT `followers_ibfk_2` FOREIGN KEY (`following_id`) REFERENCES `authors` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `followers`
--

LOCK TABLES `followers` WRITE;
/*!40000 ALTER TABLE `followers` DISABLE KEYS */;
INSERT INTO `followers` VALUES
(25,1,4,'2024-02-05 20:37:19'),
(51,3,4,'2024-02-08 17:03:33'),
(52,3,1,'2024-02-08 17:04:17');
/*!40000 ALTER TABLE `followers` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER author_followed
AFTER INSERT ON followers
FOR EACH ROW
BEGIN
  
  INSERT INTO notifications (recipient_id, sender_id, action)
  VALUES (NEW.following_id, NEW.follower_id, 'follow');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER follower_updated
AFTER INSERT ON followers
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data) VALUES ('authorUpdated', NEW.follower_id);
  INSERT INTO events (type, data) VALUES ('authorUpdated', NEW.following_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER follower_deleted
AFTER DELETE ON followers
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data) VALUES ('authorUpdated', OLD.follower_id);
  INSERT INTO events (type, data) VALUES ('authorUpdated', OLD.following_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author_id` int(11) NOT NULL,
  `blog_id` int(11) DEFAULT NULL,
  `comment_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `author_id` (`author_id`),
  KEY `blog_id` (`blog_id`),
  KEY `comment_id` (`comment_id`),
  CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`),
  CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`blog_id`) REFERENCES `blogs` (`id`),
  CONSTRAINT `likes_ibfk_3` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` VALUES
(17,1,7,NULL,'2024-02-02 21:46:59'),
(38,1,NULL,11,'2024-02-05 20:14:50'),
(39,1,20,NULL,'2024-02-05 20:15:00'),
(50,4,23,NULL,'2024-02-06 18:07:01'),
(51,4,1,NULL,'2024-02-06 18:08:25'),
(54,4,9,NULL,'2024-02-06 18:09:48'),
(55,4,21,NULL,'2024-02-06 18:13:52'),
(56,1,23,NULL,'2024-02-06 19:30:17'),
(81,4,NULL,90,'2024-02-06 22:38:22'),
(117,3,26,NULL,'2024-02-07 03:22:49'),
(119,3,23,NULL,'2024-02-08 09:41:29'),
(120,1,NULL,39,'2024-02-08 12:34:05'),
(121,1,8,NULL,'2024-02-08 12:34:15');
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER like_created
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
  DECLARE blog_author_id INT;
  DECLARE comment_author_id INT;

  
  SELECT author_id INTO blog_author_id
  FROM blogs
  WHERE id = NEW.blog_id;

  
  SELECT author_id INTO comment_author_id
  FROM comments
  WHERE id = NEW.comment_id;


  
  IF NEW.blog_id IS NOT NULL THEN
    INSERT INTO events (type, data) VALUES ('blogLiked', NEW.blog_id);
    
    INSERT INTO notifications (recipient_id, sender_id, action, action_id)
    VALUES (blog_author_id, NEW.author_id, 'blogLiked', NEW.blog_id);

    
    INSERT INTO notifications (recipient_id, sender_id, action, action_id)
    SELECT followers.follower_id, NEW.author_id, 'authorLiked', NEW.blog_id
    FROM followers
    WHERE followers.following_id = NEW.author_id
      AND followers.follower_id != blog_author_id;
  ELSE
    INSERT INTO events (type, data) VALUES ('commentLiked', NEW.comment_id);
    
    INSERT INTO notifications (recipient_id, sender_id, action, action_id)
    VALUES (comment_author_id, NEW.author_id, 'commentLiked', NEW.comment_id);
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
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER like_deleted
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
  DECLARE blog_author_id INT;
  DECLARE comment_author_id INT;

  
  SELECT author_id INTO blog_author_id
  FROM blogs
  WHERE id = OLD.blog_id;

  
  SELECT author_id INTO comment_author_id
  FROM comments
  WHERE id = OLD.comment_id;


  
  IF OLD.blog_id IS NOT NULL THEN
    INSERT INTO events (type, data) VALUES ('blogUnliked', OLD.blog_id);

    
    DELETE FROM notifications
    WHERE recipient_id = blog_author_id
      AND sender_id = OLD.author_id
      AND action = 'blogLiked'
      AND action_id = OLD.blog_id;

    
    DELETE FROM notifications
    WHERE recipient_id IN (
        SELECT followers.follower_id
        FROM followers
        WHERE followers.following_id = OLD.author_id
          AND followers.follower_id != blog_author_id
      )
      AND sender_id = OLD.author_id
      AND action = 'authorLiked'
      AND action_id = OLD.blog_id;
  ELSE
    INSERT INTO events (type, data) VALUES ('commentUnliked', OLD.comment_id);
    
    DELETE FROM notifications
    WHERE recipient_id = comment_author_id
      AND sender_id = OLD.author_id
      AND action = 'commentLiked'
      AND action_id = OLD.comment_id;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `recipient_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `action` varchar(50) DEFAULT NULL,
  `action_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_read` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `recipient_id` (`recipient_id`),
  KEY `sender_id` (`sender_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`recipient_id`) REFERENCES `authors` (`id`),
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `authors` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=408 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES
(392,5,1,'follow',NULL,'2024-02-07 11:09:44',0),
(395,3,1,'blogCreated',28,'2024-02-08 09:42:58',1),
(396,3,1,'newComment',122,'2024-02-08 12:33:58',0),
(397,4,1,'commentLiked',39,'2024-02-08 12:34:05',0),
(398,3,1,'blogLiked',8,'2024-02-08 12:34:15',0),
(399,3,1,'blogCreated',29,'2024-02-08 12:42:13',0),
(401,3,1,'followedAuthorComment',123,'2024-02-08 14:12:09',1),
(402,4,3,'follow',NULL,'2024-02-08 16:53:26',0),
(403,4,3,'follow',NULL,'2024-02-08 17:03:33',0),
(404,1,3,'follow',NULL,'2024-02-08 17:04:17',0),
(405,3,3,'newComment',124,'2025-03-19 07:45:38',0),
(406,3,3,'newComment',125,'2025-03-19 07:45:45',0),
(407,3,3,'newComment',126,'2025-03-19 07:46:45',0);
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER notification_inserted
AFTER INSERT ON notifications
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data) VALUES ('newNotification', NEW.recipient_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`awtar`@`%`*/ /*!50003 TRIGGER notification_deleted
AFTER DELETE ON notifications
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data) VALUES ('removedNotification', OLD.recipient_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES
(1,'Technology'),
(2,'Health and Fitness'),
(3,'Gaming'),
(4,'Lifestyle');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-03-24 15:19:13
