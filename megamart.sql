-- MySQL dump 10.13  Distrib 8.0.33, for Linux (x86_64)
--
-- Host: localhost    Database: megamart
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activities`
--

DROP TABLE IF EXISTS `activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `func` text NOT NULL,
  `query` text NOT NULL,
  `source` text NOT NULL,
  `time_exe` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=586 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activities`
--

LOCK TABLES `activities` WRITE;
/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
/*!40000 ALTER TABLE `activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adj_hd`
--

DROP TABLE IF EXISTS `adj_hd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adj_hd` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` char(10) NOT NULL,
  `type` char(20) NOT NULL,
  `ref_no` char(10) NOT NULL,
  `loc_id` char(3) NOT NULL,
  `entry_date` date NOT NULL,
  `remarks` text,
  `created_by` int NOT NULL,
  `date_created` date NOT NULL DEFAULT (curdate()),
  `approved` tinyint(1) DEFAULT '0',
  `posted` tinyint(1) DEFAULT '0',
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `entry_no_UNIQUE` (`entry_no`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adj_hd`
--

LOCK TABLES `adj_hd` WRITE;
/*!40000 ALTER TABLE `adj_hd` DISABLE KEYS */;
INSERT INTO `adj_hd` VALUES (9,'AD0011','stock_count','SC0011','001','2025-03-08','Hello tes',1,'2025-03-08',0,1,1);
/*!40000 ALTER TABLE `adj_hd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adj_tran`
--

DROP TABLE IF EXISTS `adj_tran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adj_tran` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` char(10) NOT NULL,
  `line` int NOT NULL,
  `barcode` varchar(45) NOT NULL,
  `item_des` varchar(45) NOT NULL,
  `qty` decimal(10,2) DEFAULT '0.00',
  `unit_price` decimal(10,2) DEFAULT '0.00',
  `total_price` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `entry_with_adj_hd` (`entry_no`),
  CONSTRAINT `entry_with_adj_hd` FOREIGN KEY (`entry_no`) REFERENCES `adj_hd` (`entry_no`)
) ENGINE=InnoDB AUTO_INCREMENT=274 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adj_tran`
--

LOCK TABLES `adj_tran` WRITE;
/*!40000 ALTER TABLE `adj_tran` DISABLE KEYS */;
INSERT INTO `adj_tran` VALUES (252,'AD0011',1,'6221024240195','HARS',-5.00,74.00,-370.00),(253,'AD0011',2,'6034000407099','NICHE INDULGENCE DARK CHOCO.88%',10.00,35.60,356.00),(254,'AD0011',3,'2000000001','OIL',47.00,700.00,32900.00),(255,'AD0011',4,'8410128112905','Pascual VANILLA 125gm',53.00,5.71,302.63),(256,'AD0011',5,'8410128113100','Pascual Creamy Strawberry 125gm',73.00,11.00,803.00),(257,'AD0011',6,'5413721000900','Incolac Chocolate',84.00,20.80,1747.20),(258,'AD0011',7,'6034000130690','FANICE VANILLA&STRAWBERRY 1L',64.00,45.90,2937.60),(259,'AD0011',8,'6034000407198','NICH INDULGENCE MILK CHO. 44%',84.00,31.70,2662.80),(260,'AD0011',9,'6034000407396','NICHE INDULGENCE MILK CHO. 48%',63.00,31.70,1997.10),(261,'AD0011',10,'60012401000590','HARS',95.00,74.00,7030.00),(262,'AD0011',11,'6154000043513','MENTOS CHEWY DRAGEES 135G',74.00,0.50,37.00),(263,'AD0011',12,'6034000130553','Fanmaxx Vanilla 330ML',65.00,6.60,429.00),(264,'AD0011',13,'5413721000894','Incolac Banana',5.00,28.00,140.00),(265,'AD0011',14,'5413721000887','Incolac Strawberry',76.00,22.70,1725.20),(266,'AD0011',15,'8410128112936','Pasual Fruit Salad/macedonia Yogurt  125',74.00,5.13,379.62),(267,'AD0011',16,'5411188543381','Alpro Soya Original Drink 1lt',26.00,48.40,1258.40),(268,'AD0011',17,'6002323007463','PEARLY BAY SWEET WHITE 750ML',75.00,91.00,6825.00),(269,'AD0011',18,'5411188543398','Alpro Soya Drink(Unsweetened) 1ltr',27.00,34.85,940.95),(270,'AD0011',19,'6034000163735','Namio Original 300ML',86.00,5.42,466.12),(271,'AD0011',20,'1234567','Mango Juice',77.00,25.00,1925.00),(272,'AD0011',21,'5411188110835','Alpro Soya Almond Drink 1Ltr',77.00,45.40,3495.80),(273,'AD0011',22,'897076002003','BULLDOG LONDON DRY GIN 750ML',81.00,375.90,30447.90);
/*!40000 ALTER TABLE `adj_tran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin.company_setup`
--

DROP TABLE IF EXISTS `admin.company_setup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin.company_setup` (
  `id` int NOT NULL AUTO_INCREMENT,
  `c_name` text NOT NULL,
  `currency` int NOT NULL,
  `box` text NOT NULL,
  `street` text NOT NULL,
  `country` text NOT NULL,
  `city` text NOT NULL,
  `phone` text NOT NULL,
  `email` text,
  `tax_code` text,
  `footer` text,
  `code` char(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin.company_setup`
--

LOCK TABLES `admin.company_setup` WRITE;
/*!40000 ALTER TABLE `admin.company_setup` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin.company_setup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin.currency`
--

DROP TABLE IF EXISTS `admin.currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin.currency` (
  `id` int NOT NULL AUTO_INCREMENT,
  `descr` text NOT NULL,
  `symbol` text NOT NULL,
  `short` text,
  `active` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin.currency`
--

LOCK TABLES `admin.currency` WRITE;
/*!40000 ALTER TABLE `admin.currency` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin.currency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_currency`
--

DROP TABLE IF EXISTS `admin_currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_currency` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` char(5) DEFAULT NULL,
  `descr` char(25) DEFAULT NULL,
  `symbol` char(1) DEFAULT NULL,
  `country` char(25) DEFAULT NULL,
  `rate` decimal(10,2) DEFAULT (1.00),
  `created_by` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT (true),
  `created_on` timestamp NULL DEFAULT (now()),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `admin_currency_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `clerk` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_currency`
--

LOCK TABLES `admin_currency` WRITE;
/*!40000 ALTER TABLE `admin_currency` DISABLE KEYS */;
INSERT INTO `admin_currency` VALUES (4,'GHS','GHANA CEDI','G','GHANA',1.00,NULL,1,'2025-02-18 05:59:26');
/*!40000 ALTER TABLE `admin_currency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_expense_type`
--

DROP TABLE IF EXISTS `admin_expense_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_expense_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` char(65) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_expense_type`
--

LOCK TABLES `admin_expense_type` WRITE;
/*!40000 ALTER TABLE `admin_expense_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_expense_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_payment_methods`
--

DROP TABLE IF EXISTS `admin_payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_payment_methods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `description` text,
  `status` int DEFAULT '1',
  UNIQUE KEY `admin_payment_methods_id_uindex` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_payment_methods`
--

LOCK TABLES `admin_payment_methods` WRITE;
/*!40000 ALTER TABLE `admin_payment_methods` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_payment_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `barcode`
--

DROP TABLE IF EXISTS `barcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `barcode` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_code` int NOT NULL,
  `barcode` text,
  `item_desc` text,
  `item_desc1` text,
  `retail` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `parent` varchar(200) DEFAULT 'master',
  PRIMARY KEY (`id`),
  KEY `relation_with_product` (`item_code`),
  CONSTRAINT `relation_with_product` FOREIGN KEY (`item_code`) REFERENCES `prod_master` (`item_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `barcode`
--

LOCK TABLES `barcode` WRITE;
/*!40000 ALTER TABLE `barcode` DISABLE KEYS */;
INSERT INTO `barcode` VALUES (43,1000006754,'2000000001','OIL','OIL',700.00,'2025-03-08 13:45:59','master'),(44,1000006755,'2000000002','MILK ','MILK ',15.00,'2025-04-05 07:19:49','master');
/*!40000 ALTER TABLE `barcode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_header`
--

DROP TABLE IF EXISTS `bill_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_header` (
  `mach_no` int DEFAULT NULL,
  `clerk` text,
  `bill_no` int DEFAULT NULL,
  `pmt_type` text,
  `gross_amt` decimal(10,2) DEFAULT '0.00',
  `disc_rate` decimal(10,2) DEFAULT '0.00',
  `disc_amt` decimal(10,0) DEFAULT '0',
  `bill_amt` decimal(10,2) DEFAULT NULL,
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `net_amt` decimal(10,2) DEFAULT '0.00',
  `amt_paid` decimal(10,2) NOT NULL DEFAULT '0.00',
  `bill_date` date DEFAULT (curdate()),
  `amt_bal` decimal(10,2) DEFAULT (0.00),
  `bill_time` time DEFAULT (curtime()),
  `tran_qty` decimal(10,2) NOT NULL DEFAULT '0.00',
  `id` int NOT NULL AUTO_INCREMENT,
  `billRef` text,
  `taxable_amt` decimal(10,2) DEFAULT (0.00),
  `non_taxable_amt` decimal(10,2) DEFAULT (0.00),
  `shift` int NOT NULL,
  `old_bill_ref` text,
  `sales_date` date DEFAULT (curdate()),
  `sales_type` text,
  `customer` text,
  `sync` tinyint(1) DEFAULT (false),
  `mast_slave` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_header`
--

LOCK TABLES `bill_header` WRITE;
/*!40000 ALTER TABLE `bill_header` DISABLE KEYS */;
INSERT INTO `bill_header` VALUES (1,'1',1,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-28',0.00,'12:11:35',1.00,113,'999250628111',700.00,0.00,1,NULL,'2025-06-28','sale','bill',0,0);
/*!40000 ALTER TABLE `bill_header` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_bill_header` BEFORE INSERT ON `bill_header` FOR EACH ROW BEGIN
    SET NEW.bill_amt = NEW.gross_amt - NEW.disc_amt;
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
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_update_bill_header` BEFORE UPDATE ON `bill_header` FOR EACH ROW BEGIN
    SET NEW.bill_amt = NEW.gross_amt - NEW.disc_amt;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `bill_history_header`
--

DROP TABLE IF EXISTS `bill_history_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_history_header` (
  `mach_no` int DEFAULT NULL,
  `clerk` text,
  `bill_no` int DEFAULT NULL,
  `pmt_type` text,
  `gross_amt` decimal(10,2) DEFAULT '0.00',
  `disc_rate` decimal(10,2) DEFAULT '0.00',
  `disc_amt` decimal(10,0) DEFAULT '0',
  `bill_amt` decimal(10,2) DEFAULT NULL,
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `net_amt` decimal(10,2) DEFAULT '0.00',
  `amt_paid` decimal(10,2) NOT NULL DEFAULT '0.00',
  `bill_date` date DEFAULT (curdate()),
  `amt_bal` decimal(10,2) DEFAULT (0.00),
  `bill_time` time DEFAULT (curtime()),
  `tran_qty` decimal(10,2) NOT NULL DEFAULT '0.00',
  `id` int NOT NULL DEFAULT '0',
  `billRef` text,
  `taxable_amt` decimal(10,2) DEFAULT (0.00),
  `non_taxable_amt` decimal(10,2) DEFAULT (0.00),
  `shift` int NOT NULL,
  `old_bill_ref` text,
  `sales_date` date DEFAULT (curdate()),
  `sales_type` text,
  `customer` text,
  `sync` tinyint(1) DEFAULT (false),
  `mast_slave` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_history_header`
--

LOCK TABLES `bill_history_header` WRITE;
/*!40000 ALTER TABLE `bill_history_header` DISABLE KEYS */;
INSERT INTO `bill_history_header` VALUES (1,'1',1,'cash',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-02-09',0.00,'15:31:34',1.00,1,'201250209111',375.90,0.00,1,NULL,'2025-02-09','sale','bill',1,0),(1,'1',2,'momo',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-02-09',0.00,'16:11:56',1.00,2,'201250209211',25.00,0.00,1,NULL,'2025-02-09','sale','bill',1,0),(1,'1',3,'cash',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-02-09',0.00,'16:16:05',1.00,3,'201250209311',375.90,0.00,1,NULL,'2025-02-09','sale','bill',1,0),(1,'1',4,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-02-09',0.00,'16:17:52',1.00,4,'201250209411',25.00,0.00,1,NULL,'2025-02-09','sale','bill',1,0),(1,'1',5,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-02-09',0.00,'16:21:05',1.00,5,'201250209511',25.00,0.00,1,NULL,'2025-02-09','sale','bill',1,0),(1,'1',6,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-02-09',0.00,'16:22:01',1.00,6,'201250209611',25.00,0.00,1,NULL,'2025-02-09','sale','bill',1,0),(1,'1',7,'cash',-25.00,0.00,0,-25.00,-5.48,-19.52,-25.00,'2025-02-09',0.00,'16:22:35',-1.00,7,'201250209711',-25.00,0.00,1,'201250209611','2025-02-09','refund','bill',1,0),(1,'1',8,'card',91.00,0.00,0,91.00,19.93,71.07,91.00,'2025-02-09',0.00,'16:38:04',1.00,8,'201250209811',91.00,0.00,1,NULL,'2025-02-09','sale','bill',1,0),(1,'1',9,'cancel',400.90,0.00,0,400.90,0.00,313.10,400.90,'2025-02-09',0.00,'06:23:07',0.00,9,'201250209911',0.00,0.00,1,NULL,'2025-02-13','canceled bill','',0,0),(1,'1',10,'cash',45.40,0.00,0,45.40,9.94,35.46,45.40,'2025-02-09',0.00,'06:38:56',1.00,10,'2012502091011',45.40,0.00,1,NULL,'2025-02-13','sale','bill',0,0),(1,'1',11,'cash',45.40,0.00,0,45.40,9.94,35.46,50.00,'2025-02-09',4.60,'06:39:34',1.00,11,'2012502091111',45.40,0.00,1,NULL,'2025-02-13','sale','bill',0,0),(1,'1',12,'credit',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-02-09',0.00,'06:43:46',1.00,12,'2012502091211',375.90,0.00,1,NULL,'2025-02-13','sale','CO2',0,0),(1,'1',13,'cancel',1127.70,0.00,0,1127.70,0.00,880.74,1127.70,'2025-02-09',0.00,'06:44:18',0.00,13,'2012502091311',0.00,0.00,1,NULL,'2025-02-13','canceled bill','',0,0),(1,'1',14,'card',50.70,0.00,0,50.70,11.10,39.60,50.70,'2025-02-09',0.00,'06:45:54',2.00,14,'2012502091411',50.70,0.00,1,NULL,'2025-02-13','sale','bill',0,0),(1,'1',15,'cash',52.00,0.00,0,52.00,11.39,40.61,100.00,'2025-02-09',48.00,'06:46:16',2.00,15,'2012502091511',52.00,0.00,1,NULL,'2025-02-13','sale','bill',0,0),(1,'1',16,'cash',45.69,0.00,-2,47.69,10.00,33.41,50.00,'2025-02-09',4.31,'06:48:54',2.00,16,'2012502091611',45.69,0.00,1,NULL,'2025-02-13','sale','bill',0,0),(1,'1',17,'cash',133.78,0.00,0,133.78,29.29,104.49,133.78,'2025-02-09',0.00,'06:49:16',4.00,17,'2012502091711',133.78,0.00,1,NULL,'2025-02-13','sale','bill',0,0),(1,'1',18,'cash',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-02-09',0.00,'06:52:41',2.00,18,'2012502091811',375.90,0.00,1,NULL,'2025-02-13','sale','bill',0,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-04-04',0.00,'22:52:18',1.00,19,'999250404111',25.00,0.00,1,NULL,'2025-04-04','sale','bill',1,0),(1,'1',2,'cancel',99.85,0.00,0,99.85,0.00,77.98,99.85,'2025-04-04',0.00,'13:14:40',0.00,20,'999250404211',0.00,0.00,1,NULL,'2025-04-05','canceled bill','',1,0),(1,'1',3,'cash',1075.90,0.00,0,1075.90,235.62,840.28,1075.90,'2025-04-04',0.00,'13:14:48',2.00,21,'999250404311',1075.90,0.00,1,NULL,'2025-04-05','sale','bill',1,0),(1,'1',4,'cash',78.00,0.00,0,78.00,17.09,60.91,78.00,'2025-04-04',0.00,'13:24:17',4.00,22,'999250404411',78.00,0.00,1,NULL,'2025-04-05','sale','bill',1,0),(1,'1',5,'cash',1075.90,0.00,0,1075.90,235.62,840.28,1075.90,'2025-04-04',0.00,'07:54:33',2.00,23,'999250404511',1075.90,0.00,1,NULL,'2025-04-18','sale','bill',1,0),(1,'1',6,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-04-04',0.00,'07:55:42',1.00,24,'999250404611',25.00,0.00,1,NULL,'2025-04-18','sale','bill',1,0),(1,'1',7,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-04-04',0.00,'13:14:12',1.00,25,'999250404711',25.00,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',8,'cash',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-04-04',0.00,'13:17:52',1.00,26,'999250404811',375.90,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',9,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-04-04',0.00,'13:19:34',1.00,27,'999250404911',700.00,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',10,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-04-04',0.00,'13:20:28',1.00,28,'9992504041011',700.00,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',11,'cash',1400.00,0.00,0,1400.00,306.60,1093.40,1400.00,'2025-04-04',0.00,'18:33:03',2.00,29,'9992504041111',1400.00,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',12,'cash',748.40,0.00,0,748.40,163.90,584.50,748.40,'2025-04-04',0.00,'18:35:13',2.00,30,'9992504041211',748.40,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',13,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-04-04',0.00,'18:39:56',1.00,31,'9992504041311',700.00,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',14,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-04-04',0.00,'18:41:14',1.00,32,'9992504041411',700.00,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',15,'cash',1075.90,0.00,0,1075.90,235.62,840.28,1075.90,'2025-04-04',0.00,'18:42:18',2.00,33,'9992504041511',1075.90,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',16,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-04-04',0.00,'18:46:38',1.00,34,'9992504041611',700.00,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',17,'cash',1075.90,0.00,0,1075.90,235.62,840.28,1075.90,'2025-04-04',0.00,'18:47:53',2.00,35,'9992504041711',1075.90,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',18,'cash',1075.90,0.00,0,1075.90,235.62,840.28,1075.90,'2025-04-04',0.00,'19:02:49',2.00,36,'9992504041811',1075.90,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',19,'cash',1075.90,0.00,0,1075.90,235.62,840.28,1075.90,'2025-04-04',0.00,'19:05:32',2.00,37,'9992504041911',1075.90,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',20,'cash',13300.00,0.00,0,13300.00,2.00,13298.00,13300.00,'2025-04-04',0.00,'22:47:49',1.00,38,'9992504042011',13300.00,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',21,'cash',1261.53,0.00,0,1261.53,276.29,985.24,1261.53,'2025-04-04',0.00,'23:37:48',12.00,39,'9992504042111',1261.53,0.00,1,NULL,'2025-04-19','sale','bill',1,0),(1,'1',22,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-04-04',0.00,'11:32:24',1.00,40,'9992504042211',700.00,0.00,1,NULL,'2025-04-20','sale','bill',1,0),(1,'1',1,'cash',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-04-20',0.00,'12:18:13',1.00,41,'999250420111',375.90,0.00,1,NULL,'2025-04-20','sale','bill',1,0),(1,'1',2,'cash',34.85,0.00,0,34.85,7.63,27.22,34.85,'2025-04-20',0.00,'13:39:00',1.00,42,'999250420211',34.85,0.00,1,NULL,'2025-04-20','sale','bill',1,0),(1,'1',3,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-04-20',0.00,'13:40:22',1.00,43,'999250420311',700.00,0.00,1,NULL,'2025-04-20','sale','bill',1,0),(1,'1',4,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-04-20',0.00,'21:25:05',1.00,44,'999250420411',700.00,0.00,1,NULL,'2025-04-26','sale','bill',1,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-04-27',0.00,'05:48:22',1.00,45,'999250427111',25.00,0.00,1,NULL,'2025-04-27','sale','bill',1,0),(1,'1',2,'cash',1075.90,0.00,0,1075.90,235.62,840.28,1075.90,'2025-04-27',0.00,'05:49:35',2.00,46,'999250427211',1075.90,0.00,1,NULL,'2025-04-27','sale','bill',1,0),(1,'1',3,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-04-27',0.00,'16:30:20',1.00,47,'999250427311',700.00,0.00,1,NULL,'2025-05-18','sale','bill',1,0),(1,'1',4,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-04-27',0.00,'22:51:18',1.00,48,'999250427411',700.00,0.00,1,NULL,'2025-06-01','sale','bill',1,0),(1,'1',5,'cash',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-04-27',0.00,'22:53:30',1.00,49,'999250427511',375.90,0.00,1,NULL,'2025-06-01','sale','bill',1,0),(1,'1',1,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-01',0.00,'22:54:30',1.00,50,'999250601111',700.00,0.00,1,NULL,'2025-06-01','sale','bill',1,0),(1,'1',1,'cash',75.20,0.00,0,75.20,16.47,58.73,75.20,'2025-06-07',0.00,'17:18:52',3.00,51,'999250607111',75.20,0.00,1,NULL,'2025-06-07','sale','bill',1,0),(1,'1',2,'cash',1400.00,0.00,0,1400.00,306.60,1093.40,1400.00,'2025-06-07',0.00,'20:35:47',2.00,52,'999250607211',1400.00,0.00,1,NULL,'2025-06-10','sale','bill',0,0),(1,'1',3,'credit',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-06-07',0.00,'20:37:23',1.00,53,'999250607311',375.90,0.00,1,NULL,'2025-06-10','sale','CO2',0,0),(1,'1',1,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-24',0.00,'02:29:00',1.00,54,'999250624111',700.00,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',1,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-24',0.00,'03:26:14',1.00,57,'999250624111',700.00,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',1,'cash',796.13,0.00,0,796.13,174.35,621.78,796.13,'2025-06-25',0.00,'03:16:56',3.00,58,'999250625111',796.13,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'cash',33.11,0.00,0,33.11,7.26,25.85,33.11,'2025-06-25',0.00,'03:17:08',3.00,59,'999250625211',33.11,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'cash',99.30,0.00,0,99.30,21.76,77.54,99.30,'2025-06-25',0.00,'03:17:18',5.00,60,'999250625311',99.30,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',4,'cash',93.11,0.00,0,93.11,20.39,72.72,93.11,'2025-06-25',0.00,'03:17:27',4.00,61,'999250625411',93.11,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',5,'card',1092.00,0.00,0,1092.00,239.15,852.85,1092.00,'2025-06-25',0.00,'03:17:43',1.00,62,'999250625511',1092.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',466.90,0.00,0,466.90,102.25,364.65,466.90,'2025-06-25',0.00,'03:32:36',2.00,63,'999250625111',466.90,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',1075.90,0.00,0,1075.90,235.62,840.28,1075.90,'2025-06-25',0.00,'03:41:50',2.00,64,'999250625111',1075.90,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'04:02:13',1.00,65,'999250625111',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-06-25',0.00,'04:02:18',1.00,66,'999250625211',375.90,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',91.00,0.00,0,91.00,19.93,71.07,91.00,'2025-06-25',0.00,'04:03:06',1.00,67,'999250625311',91.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',4,'card',273.00,0.00,0,273.00,59.79,213.21,273.00,'2025-06-25',0.00,'04:04:35',3.00,68,'999250625411',273.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',71.40,0.00,0,71.40,15.64,55.76,71.40,'2025-06-25',0.00,'04:17:37',3.00,69,'999250625111',71.40,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',182.00,0.00,0,182.00,39.86,142.14,182.00,'2025-06-25',0.00,'04:17:49',2.00,70,'999250625211',182.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',91.00,0.00,0,91.00,19.93,71.07,91.00,'2025-06-25',0.00,'04:17:54',1.00,71,'999250625311',91.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',45.40,0.00,0,45.40,9.94,35.46,45.40,'2025-06-25',0.00,'04:19:36',1.00,72,'999250625111',45.40,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',91.00,0.00,0,91.00,19.93,71.07,91.00,'2025-06-25',0.00,'04:19:45',1.00,73,'999250625211',91.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-06-25',0.00,'04:24:14',1.00,74,'999250625111',375.90,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'04:24:19',1.00,75,'999250625211',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',34.85,0.00,0,34.85,7.63,27.22,34.85,'2025-06-25',0.00,'04:24:26',1.00,76,'999250625311',34.85,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-06-25',0.00,'04:26:13',1.00,77,'999250625111',25.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'04:26:25',1.00,78,'999250625211',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',102.31,0.00,0,102.31,22.40,79.91,102.31,'2025-06-25',0.00,'04:26:34',4.00,79,'999250625311',102.31,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-06-25',0.00,'04:30:00',1.00,80,'999250625111',25.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'04:30:11',1.00,81,'999250625211',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',62.85,0.00,0,62.85,13.76,49.09,62.85,'2025-06-25',0.00,'04:30:20',2.00,82,'999250625311',62.85,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-06-25',0.00,'04:32:06',1.00,83,'999250625111',25.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'04:32:15',1.00,84,'999250625211',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',20.42,0.00,0,20.42,4.48,15.94,20.42,'2025-06-25',0.00,'04:32:24',2.00,85,'999250625311',20.42,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-06-25',0.00,'05:32:55',1.00,86,'999250625111',25.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',83.25,0.00,0,83.25,18.23,65.02,83.25,'2025-06-25',0.00,'05:33:03',2.00,87,'999250625211',83.25,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',91.00,0.00,0,91.00,19.93,71.07,91.00,'2025-06-25',0.00,'05:33:14',1.00,88,'999250625311',91.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-06-25',0.00,'05:35:40',1.00,89,'999250625111',25.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'05:35:47',1.00,90,'999250625211',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',20.71,0.00,0,20.71,4.54,16.17,20.71,'2025-06-25',0.00,'05:35:59',2.00,91,'999250625311',20.71,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',161.40,0.00,0,161.40,35.35,126.05,161.40,'2025-06-25',0.00,'05:47:19',3.00,92,'999250625111',161.40,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',836.40,0.00,0,836.40,183.17,653.23,836.40,'2025-06-25',0.00,'05:54:04',3.00,93,'999250625111',836.40,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'05:54:12',1.00,94,'999250625211',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',91.00,0.00,0,91.00,19.93,71.07,91.00,'2025-06-25',0.00,'05:54:25',1.00,95,'999250625311',91.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',1075.90,0.00,0,1075.90,235.62,840.28,1075.90,'2025-06-24',0.00,'16:08:19',2.00,96,'999250624111',1075.90,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-06-24',0.00,'16:13:44',1.00,97,'999250624111',25.00,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',2,'momo',6.60,0.00,0,6.60,1.45,5.15,6.60,'2025-06-24',0.00,'16:13:53',1.00,98,'999250624211',6.60,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',3,'card',10.84,0.00,0,10.84,2.37,8.47,10.84,'2025-06-24',0.00,'16:13:58',2.00,99,'999250624311',10.84,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',1,'cash',791.00,0.00,0,791.00,173.23,617.77,791.00,'2025-06-24',0.00,'17:10:06',2.00,100,'999250624111',791.00,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',1,'cash',791.00,0.00,0,791.00,173.23,617.77,791.00,'2025-06-24',0.00,'17:10:06',2.00,100,'999250624111',791.00,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',1,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-24',0.00,'17:21:58',1.00,101,'999250624111',700.00,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',2,'momo',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-06-24',0.00,'17:22:03',1.00,102,'999250624211',375.90,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',1,'cash',1075.90,0.00,0,1075.90,235.62,840.28,1075.90,'2025-06-28',0.00,'06:59:18',2.00,104,'999250628111',1075.90,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',1,'cash',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-06-28',0.00,'08:43:01',1.00,105,'999250628111',375.90,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-28',0.00,'08:43:06',1.00,106,'999250628211',700.00,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',3,'card',66.83,0.00,0,66.83,14.63,52.20,66.83,'2025-06-28',0.00,'08:43:17',4.00,107,'999250628311',66.83,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',4,'credit',91.00,0.00,0,91.00,19.93,71.07,91.00,'2025-06-28',0.00,'08:43:27',1.00,108,'999250628411',91.00,0.00,1,NULL,'2025-06-28','sale','CO2',0,0),(1,'1',1,'cash',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-06-28',0.00,'08:47:21',1.00,109,'999250628111',375.90,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-28',0.00,'08:47:26',1.00,110,'999250628211',700.00,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',3,'card',74.70,0.00,0,74.70,16.36,58.34,74.70,'2025-06-28',0.00,'08:47:34',3.00,111,'999250628311',74.70,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',4,'card',118.66,0.00,0,118.66,25.99,92.67,118.66,'2025-06-28',0.00,'08:47:42',7.00,112,'999250628411',118.66,0.00,1,NULL,'2025-06-28','sale','bill',0,0);
/*!40000 ALTER TABLE `bill_history_header` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_history_trans`
--

DROP TABLE IF EXISTS `bill_history_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_history_trans` (
  `id` int NOT NULL DEFAULT '0' COMMENT 'BILL NUMBER',
  `mach` int DEFAULT NULL COMMENT 'machine number',
  `clerk` text,
  `bill_number` int NOT NULL,
  `item_barcode` text NOT NULL,
  `trans_type` text NOT NULL COMMENT 'Transaction Type',
  `retail_price` decimal(10,2) DEFAULT NULL COMMENT 'Value of transaction',
  `date_added` date DEFAULT (curdate()),
  `time_added` time DEFAULT (curtime()),
  `item_qty` decimal(10,2) DEFAULT '0.00',
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `bill_amt` decimal(10,2) DEFAULT '0.00',
  `item_desc` varchar(255) DEFAULT NULL,
  `tax_grp` varchar(255) DEFAULT 'NULL',
  `tran_type` char(2) DEFAULT NULL,
  `tax_rate` int DEFAULT NULL,
  `selected` int DEFAULT '0',
  `billRef` text,
  `gfund` decimal(10,2) DEFAULT (0.00),
  `nhis` decimal(10,2) DEFAULT (0.00),
  `covid` decimal(10,2) DEFAULT (0.00),
  `vat` decimal(10,2) DEFAULT (0.00),
  `tax_code` text,
  `shift` int NOT NULL,
  `loyalty_points` decimal(10,2) DEFAULT (0.00),
  `discount` decimal(10,2) DEFAULT (0.00),
  `discount_rate` decimal(10,2) DEFAULT (0.00),
  `old_bill_ref` text,
  `sales_date` date DEFAULT (curdate()),
  `sales_time` time DEFAULT (curtime())
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_history_trans`
--

LOCK TABLES `bill_history_trans` WRITE;
/*!40000 ALTER TABLE `bill_history_trans` DISABLE KEYS */;
INSERT INTO `bill_history_trans` VALUES (1,1,'411',1,'897076002003','i',375.90,'2025-02-09','15:31:32',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'201250209111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-02-09','15:31:32'),(6,1,'411',2,'1234567','i',25.00,'2025-02-09','16:11:47',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'201250209211',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-02-09','16:11:47'),(7,1,'411',3,'897076002003','i',375.90,'2025-02-09','16:16:03',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'201250209311',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-02-09','16:16:03'),(8,1,'411',4,'1234567','i',25.00,'2025-02-09','16:17:50',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'201250209411',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-02-09','16:17:50'),(9,1,'411',5,'1234567','i',25.00,'2025-02-09','16:21:04',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'201250209511',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-02-09','16:21:04'),(10,1,'411',6,'1234567','i',25.00,'2025-02-09','16:21:59',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'201250209611',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-02-09','16:21:59'),(11,1,'411',7,'1234567','i',25.00,'2025-02-09','16:22:32',-1.00,0.00,-25.00,'Mango Juice','YES','RR',0,0,'201250209711',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-02-09','16:22:32'),(12,1,'411',8,'6002323007463','i',91.00,'2025-02-09','16:38:02',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'201250209811',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-02-09','16:38:02'),(13,1,'411',9,'897076002003','i',0.00,'2025-02-09','18:42:17',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','XX',0,0,'201250209911',0.00,0.00,0.00,0.00,'YES',1,0.00,0.00,0.00,NULL,'2025-02-09','18:42:17'),(14,1,'411',9,'1234567','i',0.00,'2025-02-09','18:43:02',1.00,0.00,25.00,'Mango Juice','YES','XX',0,0,'201250209911',0.00,0.00,0.00,0.00,'YES',1,0.00,0.00,0.00,NULL,'2025-02-09','18:43:02'),(15,1,'411',10,'5411188110835','i',45.40,'2025-02-09','06:37:35',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'2012502091011',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:37:35'),(16,1,'411',11,'5411188110835','i',45.40,'2025-02-09','06:39:23',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'2012502091111',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:39:23'),(17,1,'411',12,'897076002003','i',375.90,'2025-02-09','06:43:34',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'2012502091211',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:43:34'),(18,1,'411',13,'897076002003','i',0.00,'2025-02-09','06:44:07',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','XX',0,0,'2012502091311',0.00,0.00,0.00,0.00,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:44:07'),(19,1,'411',13,'897076002003','i',0.00,'2025-02-09','06:44:09',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','XX',0,0,'2012502091311',0.00,0.00,0.00,0.00,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:44:09'),(20,1,'411',13,'897076002003','i',0.00,'2025-02-09','06:44:10',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','XX',0,0,'2012502091311',0.00,0.00,0.00,0.00,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:44:10'),(24,1,'411',14,'5413721000894','i',28.00,'2025-02-09','06:45:52',1.00,6.13,28.00,'Incolac Banana','YES','SS',0,0,'2012502091411',0.57,0.57,0.23,6.13,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:45:52'),(25,1,'411',14,'5413721000887','i',22.70,'2025-02-09','06:45:53',1.00,4.97,22.70,'Incolac Strawberry','YES','SS',0,0,'2012502091411',0.47,0.47,0.19,4.97,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:45:53'),(26,1,'411',15,'5411188110835','i',45.40,'2025-02-09','06:46:08',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'2012502091511',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:46:08'),(27,1,'411',15,'6034000130553','i',6.60,'2025-02-09','06:46:08',1.00,1.45,6.60,'Fanmaxx Vanilla 330ML','YES','SS',0,0,'2012502091511',0.14,0.14,0.05,1.45,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:46:08'),(28,1,'411',16,'6034000163735','i',5.42,'2025-02-09','06:47:32',2.00,1.19,10.84,'Namio Original 300ML','YES','SS',0,0,'2012502091611',0.22,0.22,0.09,2.37,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:47:32'),(29,1,'411',16,'5411188543398','i',34.85,'2025-02-09','06:48:14',1.00,7.63,34.85,'Alpro Soya Drink(Unsweetened) 1ltr','YES','SS',0,0,'2012502091611',0.71,0.71,0.29,7.63,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:48:14'),(30,1,'411',16,'DICOUNT','D',0.00,'2025-02-09','06:48:32',0.00,0.00,0.00,'DISCOUNT','NULL','D',0,0,'2012502091611',0.00,0.00,0.00,0.00,NULL,1,0.00,0.00,5.00,NULL,'2025-02-13','06:48:32'),(31,1,'411',17,'5411188110835','i',45.40,'2025-02-09','06:49:10',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'2012502091711',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:49:10'),(32,1,'411',17,'5411188543398','i',34.85,'2025-02-09','06:49:11',1.00,7.63,34.85,'Alpro Soya Drink(Unsweetened) 1ltr','YES','SS',0,0,'2012502091711',0.71,0.71,0.29,7.63,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:49:11'),(33,1,'411',17,'5411188543381','i',48.40,'2025-02-09','06:49:11',1.00,10.60,48.40,'Alpro Soya Original Drink 1lt','YES','SS',0,0,'2012502091711',0.99,0.99,0.40,10.60,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:49:11'),(34,1,'411',17,'8410128112936','i',5.13,'2025-02-09','06:49:12',1.00,1.12,5.13,'Pasual Fruit Salad/macedonia Yogurt  125','YES','SS',0,0,'2012502091711',0.11,0.11,0.04,1.12,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:49:12'),(35,1,'411',18,'897076002003','i',375.90,'2025-02-09','06:51:51',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'2012502091811',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-02-13','06:51:51'),(36,1,'1',18,'6002323007463','i',0.00,'2025-02-09','06:52:28',1.00,0.00,0.00,'PEARLY BAY SWEET WHITE 750ML','NULL','SS',0,0,'2012502091811',0.00,0.00,0.00,0.00,NULL,1,0.00,0.00,0.00,NULL,'2025-02-13','06:52:28'),(37,1,'411',1,'1234567','i',25.00,'2025-04-04','22:52:16',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250404111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-04-04','22:52:16'),(38,1,'411',2,'5411188543398','i',0.00,'2025-04-04','07:12:57',1.00,7.63,34.85,'Alpro Soya Drink(Unsweetened) 1ltr','YES','XX',0,0,'999250404211',0.00,0.00,0.00,0.00,'YES',1,0.00,0.00,0.00,NULL,'2025-04-05','07:12:57'),(39,1,'411',2,'1234567','i',0.00,'2025-04-04','07:15:28',2.00,0.00,50.00,'Mango Juice','YES','XX',0,0,'999250404211',0.00,0.00,0.00,0.00,'YES',1,0.00,0.00,0.00,NULL,'2025-04-05','07:15:28'),(41,1,'411',2,'2000000002','i',0.00,'2025-04-04','07:22:55',1.00,2.69,15.00,'MILK ','YES','XX',0,0,'999250404211',0.00,0.00,0.00,0.00,'YES',1,0.00,0.00,0.00,NULL,'2025-04-05','07:22:55'),(42,1,'411',3,'897076002003','i',375.90,'2025-04-04','13:14:45',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250404311',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-04-05','13:14:45'),(43,1,'411',3,'2000000001','i',700.00,'2025-04-04','13:14:47',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250404311',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-05','13:14:47'),(44,1,'411',4,'5411188110835','i',45.40,'2025-04-04','13:24:12',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'999250404411',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-04-05','13:24:12'),(45,1,'411',4,'6034000130553','i',6.60,'2025-04-04','13:24:13',1.00,1.45,6.60,'Fanmaxx Vanilla 330ML','YES','SS',0,0,'999250404411',0.14,0.14,0.05,1.45,'YES',1,0.00,0.00,0.00,NULL,'2025-04-05','13:24:13'),(46,1,'411',4,'2000000002','i',15.00,'2025-04-04','13:24:15',1.00,2.69,15.00,'MILK ','YES','SS',0,0,'999250404411',0.31,0.31,0.12,3.29,'YES',1,0.00,0.00,0.00,NULL,'2025-04-05','13:24:15'),(47,1,'411',4,'8410128113100','i',11.00,'2025-04-04','13:24:16',1.00,2.41,11.00,'Pascual Creamy Strawberry 125gm','YES','SS',0,0,'999250404411',0.23,0.23,0.09,2.41,'YES',1,0.00,0.00,0.00,NULL,'2025-04-05','13:24:16'),(48,1,'411',5,'2000000001','i',700.00,'2025-04-04','07:54:26',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250404511',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-18','07:54:26'),(49,1,'411',5,'897076002003','i',375.90,'2025-04-04','07:54:30',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250404511',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-04-18','07:54:30'),(50,1,'411',6,'1234567','i',25.00,'2025-04-04','07:55:18',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250404611',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-04-18','07:55:18'),(51,1,'411',7,'1234567','i',25.00,'2025-04-04','13:10:00',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250404711',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','13:10:00'),(52,1,'411',8,'897076002003','i',375.90,'2025-04-04','13:17:30',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250404811',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','13:17:30'),(53,1,'411',9,'2000000001','i',700.00,'2025-04-04','13:19:22',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250404911',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','13:19:22'),(54,1,'411',10,'2000000001','i',700.00,'2025-04-04','13:20:08',1.00,125.76,700.00,'OIL','YES','SS',0,0,'9992504041011',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','13:20:08'),(55,1,'411',11,'2000000001','i',700.00,'2025-04-04','18:32:21',1.00,125.76,700.00,'OIL','YES','SS',0,0,'9992504041111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','18:32:21'),(56,1,'411',11,'2000000001','i',700.00,'2025-04-04','18:32:26',1.00,125.76,700.00,'OIL','YES','SS',0,0,'9992504041111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','18:32:26'),(57,1,'411',12,'2000000001','i',700.00,'2025-04-04','18:34:24',1.00,125.76,700.00,'OIL','YES','SS',0,0,'9992504041211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','18:34:24'),(58,1,'411',12,'5411188543381','i',48.40,'2025-04-04','18:35:10',1.00,10.60,48.40,'Alpro Soya Original Drink 1lt','YES','SS',0,0,'9992504041211',0.99,0.99,0.40,10.60,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','18:35:10'),(59,1,'411',13,'2000000001','i',700.00,'2025-04-04','18:39:42',1.00,125.76,700.00,'OIL','YES','SS',0,0,'9992504041311',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','18:39:42'),(60,1,'411',14,'2000000001','i',700.00,'2025-04-04','18:40:57',1.00,125.76,700.00,'OIL','YES','SS',0,0,'9992504041411',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','18:40:57'),(61,1,'411',15,'2000000001','i',700.00,'2025-04-04','18:41:53',1.00,125.76,700.00,'OIL','YES','SS',0,0,'9992504041511',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','18:41:53'),(62,1,'411',15,'897076002003','i',375.90,'2025-04-04','18:41:54',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'9992504041511',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','18:41:54'),(63,1,'411',16,'2000000001','i',700.00,'2025-04-04','18:46:25',1.00,125.76,700.00,'OIL','YES','SS',0,0,'9992504041611',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','18:46:25'),(64,1,'411',17,'2000000001','i',700.00,'2025-04-04','18:47:42',1.00,125.76,700.00,'OIL','YES','SS',0,0,'9992504041711',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','18:47:42'),(65,1,'411',17,'897076002003','i',375.90,'2025-04-04','18:47:42',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'9992504041711',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','18:47:42'),(66,1,'411',18,'897076002003','i',375.90,'2025-04-04','19:01:59',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'9992504041811',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','19:01:59'),(67,1,'411',18,'2000000001','i',700.00,'2025-04-04','19:02:00',1.00,125.76,700.00,'OIL','YES','SS',0,0,'9992504041811',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','19:02:00'),(68,1,'411',19,'897076002003','i',375.90,'2025-04-04','19:05:11',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'9992504041911',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','19:05:11'),(69,1,'411',19,'2000000001','i',700.00,'2025-04-04','19:05:12',1.00,125.76,700.00,'OIL','YES','SS',0,0,'9992504041911',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','19:05:12'),(70,1,'411',20,'2000000001','i',700.00,'2025-04-04','22:47:29',19.00,125.76,13300.00,'OIL','YES','SS',0,0,'9992504042011',272.76,272.76,109.11,2.00,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','22:47:29'),(71,1,'411',21,'1234567','i',25.00,'2025-04-04','23:32:46',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'9992504042111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','23:32:46'),(72,1,'411',21,'897076002003','i',375.90,'2025-04-04','23:32:49',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'9992504042111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','23:32:49'),(73,1,'411',21,'2000000001','i',700.00,'2025-04-04','23:32:49',1.00,125.76,700.00,'OIL','YES','SS',0,0,'9992504042111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','23:32:49'),(74,1,'411',21,'5411188110835','i',45.40,'2025-04-04','23:32:52',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'9992504042111',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','23:32:52'),(75,1,'411',21,'6034000130553','i',6.60,'2025-04-04','23:32:53',1.00,1.45,6.60,'Fanmaxx Vanilla 330ML','YES','SS',0,0,'9992504042111',0.14,0.14,0.05,1.45,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','23:32:53'),(76,1,'411',21,'5413721000887','i',22.70,'2025-04-04','23:32:53',1.00,4.97,22.70,'Incolac Strawberry','YES','SS',0,0,'9992504042111',0.47,0.47,0.19,4.97,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','23:32:53'),(77,1,'411',21,'5413721000900','i',20.80,'2025-04-04','23:32:54',1.00,4.56,20.80,'Incolac Chocolate','YES','SS',0,0,'9992504042111',0.43,0.43,0.17,4.56,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','23:32:54'),(78,1,'411',21,'6034000163735','i',5.42,'2025-04-04','23:32:55',1.00,1.19,5.42,'Namio Original 300ML','YES','SS',0,0,'9992504042111',0.11,0.11,0.04,1.19,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','23:32:55'),(79,1,'411',21,'8410128113100','i',11.00,'2025-04-04','23:32:56',1.00,2.41,11.00,'Pascual Creamy Strawberry 125gm','YES','SS',0,0,'9992504042111',0.23,0.23,0.09,2.41,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','23:32:56'),(80,1,'411',21,'8410128112905','i',5.71,'2025-04-04','23:32:57',1.00,1.25,5.71,'Pascual VANILLA 125gm','YES','SS',0,0,'9992504042111',0.12,0.12,0.05,1.25,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','23:32:57'),(81,1,'411',21,'2000000002','i',15.00,'2025-04-04','23:32:58',1.00,2.69,15.00,'MILK ','YES','SS',0,0,'9992504042111',0.31,0.31,0.12,3.29,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','23:32:58'),(82,1,'411',21,'5413721000894','i',28.00,'2025-04-04','23:32:59',1.00,6.13,28.00,'Incolac Banana','YES','SS',0,0,'9992504042111',0.57,0.57,0.23,6.13,'YES',1,0.00,0.00,0.00,NULL,'2025-04-19','23:32:59'),(83,1,'411',22,'2000000001','i',700.00,'2025-04-04','11:32:22',1.00,125.76,700.00,'OIL','YES','SS',0,0,'9992504042211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-20','11:32:22'),(84,1,'411',1,'897076002003','i',375.90,'2025-04-20','12:18:10',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250420111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-04-20','12:18:10'),(85,1,'411',2,'5411188543398','i',34.85,'2025-04-20','13:38:58',1.00,7.63,34.85,'Alpro Soya Drink(Unsweetened) 1ltr','YES','SS',0,0,'999250420211',0.71,0.71,0.29,7.63,'YES',1,0.00,0.00,0.00,NULL,'2025-04-20','13:38:58'),(86,1,'411',3,'2000000001','i',700.00,'2025-04-20','13:40:17',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250420311',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-20','13:40:17'),(87,1,'411',4,'2000000001','i',700.00,'2025-04-20','21:25:03',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250420411',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-26','21:25:03'),(88,1,'411',1,'1234567','i',25.00,'2025-04-27','05:45:14',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250427111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-04-27','05:45:14'),(89,1,'411',2,'897076002003','i',375.90,'2025-04-27','05:49:25',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250427211',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-04-27','05:49:25'),(90,1,'411',2,'2000000001','i',700.00,'2025-04-27','05:49:33',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250427211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-04-27','05:49:33'),(91,1,'411',3,'2000000001','i',700.00,'2025-04-27','16:30:17',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250427311',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-05-18','16:30:17'),(92,1,'411',4,'2000000001','i',700.00,'2025-04-27','22:51:16',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250427411',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-01','22:51:16'),(93,1,'411',5,'897076002003','i',375.90,'2025-04-27','22:53:28',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250427511',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-01','22:53:28'),(94,1,'411',1,'2000000001','i',700.00,'2025-06-01','22:54:28',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250601111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-01','22:54:28'),(95,1,'411',1,'6034000130690','i',45.90,'2025-06-07','17:18:45',1.00,10.05,45.90,'FANICE VANILLA&STRAWBERRY 1L','YES','SS',0,0,'999250607111',0.94,0.94,0.38,10.05,'YES',1,0.00,0.00,0.00,NULL,'2025-06-07','17:18:45'),(96,1,'411',1,'6034000130553','i',6.60,'2025-06-07','17:18:46',1.00,1.45,6.60,'Fanmaxx Vanilla 330ML','YES','SS',0,0,'999250607111',0.14,0.14,0.05,1.45,'YES',1,0.00,0.00,0.00,NULL,'2025-06-07','17:18:46'),(97,1,'411',1,'5413721000887','i',22.70,'2025-06-07','17:18:48',1.00,4.97,22.70,'Incolac Strawberry','YES','SS',0,0,'999250607111',0.47,0.47,0.19,4.97,'YES',1,0.00,0.00,0.00,NULL,'2025-06-07','17:18:48'),(98,1,'411',2,'2000000001','i',700.00,'2025-06-07','14:02:06',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250607211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-08','14:02:06'),(99,1,'411',2,'2000000001','i',700.00,'2025-06-07','20:35:37',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250607211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-10','20:35:37'),(100,1,'411',3,'897076002003','i',375.90,'2025-06-07','20:37:13',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250607311',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-10','20:37:13'),(101,1,'411',1,'2000000001','i',700.00,'2025-06-24','02:28:55',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250624111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','02:28:55'),(104,1,'411',1,'2000000001','i',700.00,'2025-06-24','03:26:11',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250624111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','03:26:11'),(105,1,'411',1,'2000000001','i',700.00,'2025-06-25','03:16:37',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:16:37'),(106,1,'411',1,'6002323007463','i',91.00,'2025-06-25','03:16:46',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625111',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:16:46'),(107,1,'411',1,'8410128112936','i',5.13,'2025-06-25','03:16:55',1.00,1.12,5.13,'Pasual Fruit Salad/macedonia Yogurt  125','YES','SS',0,0,'999250625111',0.11,0.11,0.04,1.12,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:16:55'),(108,1,'411',2,'8410128112905','i',5.71,'2025-06-25','03:17:02',1.00,1.25,5.71,'Pascual VANILLA 125gm','YES','SS',0,0,'999250625211',0.12,0.12,0.05,1.25,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:02'),(109,1,'411',2,'6034000130553','i',6.60,'2025-06-25','03:17:04',1.00,1.45,6.60,'Fanmaxx Vanilla 330ML','YES','SS',0,0,'999250625211',0.14,0.14,0.05,1.45,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:04'),(110,1,'411',2,'5413721000900','i',20.80,'2025-06-25','03:17:05',1.00,4.56,20.80,'Incolac Chocolate','YES','SS',0,0,'999250625211',0.43,0.43,0.17,4.56,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:05'),(111,1,'411',3,'2000000002','i',15.00,'2025-06-25','03:17:12',1.00,2.69,15.00,'MILK ','YES','SS',0,0,'999250625311',0.31,0.31,0.12,3.29,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:12'),(112,1,'411',3,'6034000130553','i',6.60,'2025-06-25','03:17:14',1.00,1.45,6.60,'Fanmaxx Vanilla 330ML','YES','SS',0,0,'999250625311',0.14,0.14,0.05,1.45,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:14'),(113,1,'411',3,'6034000130690','i',45.90,'2025-06-25','03:17:15',1.00,10.05,45.90,'FANICE VANILLA&STRAWBERRY 1L','YES','SS',0,0,'999250625311',0.94,0.94,0.38,10.05,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:15'),(114,1,'411',3,'5413721000900','i',20.80,'2025-06-25','03:17:16',1.00,4.56,20.80,'Incolac Chocolate','YES','SS',0,0,'999250625311',0.43,0.43,0.17,4.56,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:16'),(115,1,'411',3,'8410128113100','i',11.00,'2025-06-25','03:17:17',1.00,2.41,11.00,'Pascual Creamy Strawberry 125gm','YES','SS',0,0,'999250625311',0.23,0.23,0.09,2.41,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:17'),(116,1,'411',4,'8410128112905','i',5.71,'2025-06-25','03:17:23',1.00,1.25,5.71,'Pascual VANILLA 125gm','YES','SS',0,0,'999250625411',0.12,0.12,0.05,1.25,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:23'),(117,1,'411',4,'8410128113100','i',11.00,'2025-06-25','03:17:24',1.00,2.41,11.00,'Pascual Creamy Strawberry 125gm','YES','SS',0,0,'999250625411',0.23,0.23,0.09,2.41,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:24'),(118,1,'411',4,'5413721000894','i',28.00,'2025-06-25','03:17:25',1.00,6.13,28.00,'Incolac Banana','YES','SS',0,0,'999250625411',0.57,0.57,0.23,6.13,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:25'),(119,1,'411',4,'5411188543381','i',48.40,'2025-06-25','03:17:26',1.00,10.60,48.40,'Alpro Soya Original Drink 1lt','YES','SS',0,0,'999250625411',0.99,0.99,0.40,10.60,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:26'),(120,1,'411',5,'6002323007463','i',91.00,'2025-06-25','03:17:40',12.00,19.93,1092.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625511',22.40,22.40,8.96,239.15,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:40'),(121,1,'411',1,'897076002003','i',375.90,'2025-06-25','03:32:27',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250625111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:32:27'),(122,1,'411',1,'6002323007463','i',91.00,'2025-06-25','03:32:34',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625111',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:32:34'),(123,1,'411',1,'2000000001','i',700.00,'2025-06-25','03:41:46',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:41:46'),(124,1,'411',1,'897076002003','i',375.90,'2025-06-25','03:41:48',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250625111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:41:48'),(125,1,'411',1,'2000000001','i',700.00,'2025-06-25','04:02:10',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:02:10'),(126,1,'411',2,'897076002003','i',375.90,'2025-06-25','04:02:17',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250625211',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:02:17'),(127,1,'411',3,'6002323007463','i',91.00,'2025-06-25','04:03:05',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625311',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:03:05'),(128,1,'411',4,'6002323007463','i',91.00,'2025-06-25','04:04:31',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625411',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:04:31'),(129,1,'411',4,'6002323007463','i',91.00,'2025-06-25','04:04:33',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625411',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:04:33'),(130,1,'411',4,'6002323007463','i',91.00,'2025-06-25','04:04:34',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625411',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:04:34'),(131,1,'411',1,'5411188110835','i',45.40,'2025-06-25','04:17:31',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'999250625111',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:17:31'),(132,1,'411',1,'8410128113100','i',11.00,'2025-06-25','04:17:33',1.00,2.41,11.00,'Pascual Creamy Strawberry 125gm','YES','SS',0,0,'999250625111',0.23,0.23,0.09,2.41,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:17:33'),(133,1,'411',1,'2000000002','i',15.00,'2025-06-25','04:17:34',1.00,2.69,15.00,'MILK ','YES','SS',0,0,'999250625111',0.31,0.31,0.12,3.29,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:17:34'),(134,1,'411',2,'6002323007463','i',91.00,'2025-06-25','04:17:45',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625211',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:17:45'),(135,1,'411',2,'6002323007463','i',91.00,'2025-06-25','04:17:47',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625211',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:17:47'),(136,1,'411',3,'6002323007463','i',91.00,'2025-06-25','04:17:52',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625311',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:17:52'),(137,1,'411',1,'5411188110835','i',45.40,'2025-06-25','04:19:34',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'999250625111',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:19:34'),(138,1,'411',2,'6002323007463','i',91.00,'2025-06-25','04:19:43',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625211',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:19:43'),(139,1,'411',1,'897076002003','i',375.90,'2025-06-25','04:24:13',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250625111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:24:13'),(140,1,'411',2,'2000000001','i',700.00,'2025-06-25','04:24:18',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:24:18'),(141,1,'411',3,'5411188543398','i',34.85,'2025-06-25','04:24:24',1.00,7.63,34.85,'Alpro Soya Drink(Unsweetened) 1ltr','YES','SS',0,0,'999250625311',0.71,0.71,0.29,7.63,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:24:24'),(142,1,'411',1,'1234567','i',25.00,'2025-06-25','04:26:12',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250625111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:26:12'),(143,1,'411',2,'2000000001','i',700.00,'2025-06-25','04:26:18',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:26:18'),(144,1,'411',3,'5413721000894','i',28.00,'2025-06-25','04:26:30',1.00,6.13,28.00,'Incolac Banana','YES','SS',0,0,'999250625311',0.57,0.57,0.23,6.13,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:26:30'),(145,1,'411',3,'8410128112905','i',5.71,'2025-06-25','04:26:31',1.00,1.25,5.71,'Pascual VANILLA 125gm','YES','SS',0,0,'999250625311',0.12,0.12,0.05,1.25,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:26:31'),(146,1,'411',3,'5413721000887','i',22.70,'2025-06-25','04:26:32',1.00,4.97,22.70,'Incolac Strawberry','YES','SS',0,0,'999250625311',0.47,0.47,0.19,4.97,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:26:32'),(147,1,'411',3,'6034000130690','i',45.90,'2025-06-25','04:26:32',1.00,10.05,45.90,'FANICE VANILLA&STRAWBERRY 1L','YES','SS',0,0,'999250625311',0.94,0.94,0.38,10.05,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:26:32'),(148,1,'411',1,'1234567','i',25.00,'2025-06-25','04:29:59',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250625111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:29:59'),(149,1,'411',2,'2000000001','i',700.00,'2025-06-25','04:30:09',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:30:09'),(150,1,'411',3,'5411188543398','i',34.85,'2025-06-25','04:30:16',1.00,7.63,34.85,'Alpro Soya Drink(Unsweetened) 1ltr','YES','SS',0,0,'999250625311',0.71,0.71,0.29,7.63,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:30:16'),(151,1,'411',3,'5413721000894','i',28.00,'2025-06-25','04:30:18',1.00,6.13,28.00,'Incolac Banana','YES','SS',0,0,'999250625311',0.57,0.57,0.23,6.13,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:30:18'),(152,1,'411',1,'1234567','i',25.00,'2025-06-25','04:32:05',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250625111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:32:05'),(153,1,'411',2,'2000000001','i',700.00,'2025-06-25','04:32:13',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:32:13'),(154,1,'411',3,'2000000002','i',15.00,'2025-06-25','04:32:22',1.00,2.69,15.00,'MILK ','YES','SS',0,0,'999250625311',0.31,0.31,0.12,3.29,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:32:22'),(155,1,'411',3,'6034000163735','i',5.42,'2025-06-25','04:32:23',1.00,1.19,5.42,'Namio Original 300ML','YES','SS',0,0,'999250625311',0.11,0.11,0.04,1.19,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:32:23'),(156,1,'411',1,'1234567','i',25.00,'2025-06-25','05:32:51',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250625111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:32:51'),(157,1,'411',2,'5411188543398','i',34.85,'2025-06-25','05:33:01',1.00,7.63,34.85,'Alpro Soya Drink(Unsweetened) 1ltr','YES','SS',0,0,'999250625211',0.71,0.71,0.29,7.63,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:33:01'),(158,1,'411',2,'5411188543381','i',48.40,'2025-06-25','05:33:02',1.00,10.60,48.40,'Alpro Soya Original Drink 1lt','YES','SS',0,0,'999250625211',0.99,0.99,0.40,10.60,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:33:02'),(159,1,'411',3,'6002323007463','i',91.00,'2025-06-25','05:33:10',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625311',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:33:10'),(160,1,'411',1,'1234567','i',25.00,'2025-06-25','05:35:38',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250625111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:35:38'),(161,1,'411',2,'2000000001','i',700.00,'2025-06-25','05:35:46',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:35:46'),(162,1,'411',3,'2000000002','i',15.00,'2025-06-25','05:35:56',1.00,2.69,15.00,'MILK ','YES','SS',0,0,'999250625311',0.31,0.31,0.12,3.29,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:35:56'),(163,1,'411',3,'8410128112905','i',5.71,'2025-06-25','05:35:58',1.00,1.25,5.71,'Pascual VANILLA 125gm','YES','SS',0,0,'999250625311',0.12,0.12,0.05,1.25,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:35:58'),(164,1,'411',1,'1234567','i',25.00,'2025-06-25','05:47:12',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250625111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:47:12'),(165,1,'411',1,'5411188110835','i',45.40,'2025-06-25','05:47:15',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'999250625111',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:47:15'),(166,1,'411',1,'6002323007463','i',91.00,'2025-06-25','05:47:18',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625111',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:47:18'),(167,1,'411',1,'2000000001','i',700.00,'2025-06-25','05:53:52',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:53:52'),(168,1,'411',1,'5411188110835','i',45.40,'2025-06-25','05:53:58',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'999250625111',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:53:58'),(169,1,'411',1,'6002323007463','i',91.00,'2025-06-25','05:54:02',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625111',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:54:02'),(170,1,'411',2,'2000000001','i',700.00,'2025-06-25','05:54:11',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:54:11'),(171,1,'411',3,'6002323007463','i',91.00,'2025-06-25','05:54:24',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625311',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:54:24'),(172,1,'411',1,'2000000001','i',700.00,'2025-06-24','16:08:16',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250624111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','16:08:16'),(173,1,'411',1,'897076002003','i',375.90,'2025-06-24','16:08:18',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250624111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','16:08:18'),(174,1,'411',1,'1234567','i',25.00,'2025-06-24','16:13:42',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250624111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','16:13:42'),(175,1,'411',2,'6034000130553','i',6.60,'2025-06-24','16:13:51',1.00,1.45,6.60,'Fanmaxx Vanilla 330ML','YES','SS',0,0,'999250624211',0.14,0.14,0.05,1.45,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','16:13:51'),(176,1,'411',3,'8410128112905','i',5.71,'2025-06-24','16:13:56',1.00,1.25,5.71,'Pascual VANILLA 125gm','YES','SS',0,0,'999250624311',0.12,0.12,0.05,1.25,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','16:13:56'),(177,1,'411',3,'8410128112936','i',5.13,'2025-06-24','16:13:57',1.00,1.12,5.13,'Pasual Fruit Salad/macedonia Yogurt  125','YES','SS',0,0,'999250624311',0.11,0.11,0.04,1.12,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','16:13:57'),(178,1,'411',1,'2000000001','i',700.00,'2025-06-24','17:09:59',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250624111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','17:09:59'),(179,1,'411',1,'6002323007463','i',91.00,'2025-06-24','17:10:04',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250624111',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','17:10:04'),(178,1,'411',1,'2000000001','i',700.00,'2025-06-24','17:09:59',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250624111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','17:09:59'),(179,1,'411',1,'6002323007463','i',91.00,'2025-06-24','17:10:04',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250624111',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','17:10:04'),(180,1,'411',1,'2000000001','i',700.00,'2025-06-24','17:21:55',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250624111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','17:21:55'),(181,1,'411',2,'897076002003','i',375.90,'2025-06-24','17:22:02',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250624211',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','17:22:02'),(183,1,'411',1,'2000000001','i',700.00,'2025-06-28','06:59:15',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250628111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','06:59:15'),(184,1,'411',1,'897076002003','i',375.90,'2025-06-28','06:59:16',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250628111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','06:59:16'),(185,1,'411',1,'897076002003','i',375.90,'2025-06-28','08:43:00',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250628111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:00'),(186,1,'411',2,'2000000001','i',700.00,'2025-06-28','08:43:05',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250628211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:05'),(187,1,'411',3,'8410128112936','i',5.13,'2025-06-28','08:43:13',1.00,1.12,5.13,'Pasual Fruit Salad/macedonia Yogurt  125','YES','SS',0,0,'999250628311',0.11,0.11,0.04,1.12,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:13'),(188,1,'411',3,'8410128113100','i',11.00,'2025-06-28','08:43:14',1.00,2.41,11.00,'Pascual Creamy Strawberry 125gm','YES','SS',0,0,'999250628311',0.23,0.23,0.09,2.41,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:14'),(189,1,'411',3,'5413721000887','i',22.70,'2025-06-28','08:43:15',1.00,4.97,22.70,'Incolac Strawberry','YES','SS',0,0,'999250628311',0.47,0.47,0.19,4.97,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:15'),(190,1,'411',3,'5413721000894','i',28.00,'2025-06-28','08:43:15',1.00,6.13,28.00,'Incolac Banana','YES','SS',0,0,'999250628311',0.57,0.57,0.23,6.13,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:15'),(191,1,'411',4,'6002323007463','i',91.00,'2025-06-28','08:43:24',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250628411',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:24'),(192,1,'411',1,'897076002003','i',375.90,'2025-06-28','08:47:20',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250628111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:20'),(193,1,'411',2,'2000000001','i',700.00,'2025-06-28','08:47:25',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250628211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:25'),(194,1,'411',3,'5411188110835','i',45.40,'2025-06-28','08:47:32',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'999250628311',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:32'),(195,1,'411',3,'6034000130553','i',6.60,'2025-06-28','08:47:33',1.00,1.45,6.60,'Fanmaxx Vanilla 330ML','YES','SS',0,0,'999250628311',0.14,0.14,0.05,1.45,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:33'),(196,1,'411',3,'5413721000887','i',22.70,'2025-06-28','08:47:33',1.00,4.97,22.70,'Incolac Strawberry','YES','SS',0,0,'999250628311',0.47,0.47,0.19,4.97,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:33'),(197,1,'411',4,'5411188543381','i',48.40,'2025-06-28','08:47:37',1.00,10.60,48.40,'Alpro Soya Original Drink 1lt','YES','SS',0,0,'999250628411',0.99,0.99,0.40,10.60,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:37'),(198,1,'411',4,'5413721000894','i',28.00,'2025-06-28','08:47:38',1.00,6.13,28.00,'Incolac Banana','YES','SS',0,0,'999250628411',0.57,0.57,0.23,6.13,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:38'),(199,1,'411',4,'2000000002','i',15.00,'2025-06-28','08:47:38',1.00,2.69,15.00,'MILK ','YES','SS',0,0,'999250628411',0.31,0.31,0.12,3.29,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:38'),(200,1,'411',4,'8410128112905','i',5.71,'2025-06-28','08:47:39',1.00,1.25,5.71,'Pascual VANILLA 125gm','YES','SS',0,0,'999250628411',0.12,0.12,0.05,1.25,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:39'),(201,1,'411',4,'8410128113100','i',11.00,'2025-06-28','08:47:39',1.00,2.41,11.00,'Pascual Creamy Strawberry 125gm','YES','SS',0,0,'999250628411',0.23,0.23,0.09,2.41,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:39'),(202,1,'411',4,'6034000163735','i',5.42,'2025-06-28','08:47:40',1.00,1.19,5.42,'Namio Original 300ML','YES','SS',0,0,'999250628411',0.11,0.11,0.04,1.19,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:40'),(203,1,'411',4,'8410128112936','i',5.13,'2025-06-28','08:47:41',1.00,1.12,5.13,'Pasual Fruit Salad/macedonia Yogurt  125','YES','SS',0,0,'999250628411',0.11,0.11,0.04,1.12,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:41');
/*!40000 ALTER TABLE `bill_history_trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_hld_tr`
--

DROP TABLE IF EXISTS `bill_hld_tr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_hld_tr` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bill_group` char(4) DEFAULT NULL,
  `barcode` text,
  `qty` decimal(10,2) DEFAULT (0.00),
  `tran_date` date DEFAULT (curdate()),
  `tran_time` time DEFAULT (curtime()),
  `clerk` int NOT NULL,
  `billed` int DEFAULT (0),
  `billRef` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_hld_tr`
--

LOCK TABLES `bill_hld_tr` WRITE;
/*!40000 ALTER TABLE `bill_hld_tr` DISABLE KEYS */;
INSERT INTO `bill_hld_tr` VALUES (43,'0211','1234567',1.00,'2025-02-09','16:08:53',1,1,'001250209211'),(44,'3004','5411188110835',1.00,'2025-02-13','06:45:32',1,1,'0012502091211'),(45,'3004','6034000130553',1.00,'2025-02-13','06:45:32',1,1,'0012502091211');
/*!40000 ALTER TABLE `bill_hld_tr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_hold`
--

DROP TABLE IF EXISTS `bill_hold`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_hold` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bill_grp` char(4) NOT NULL,
  `bill_date` date DEFAULT (curdate()),
  `item_barcode` varchar(255) DEFAULT NULL,
  `item_qty` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_hold`
--

LOCK TABLES `bill_hold` WRITE;
/*!40000 ALTER TABLE `bill_hold` DISABLE KEYS */;
/*!40000 ALTER TABLE `bill_hold` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_payments`
--

DROP TABLE IF EXISTS `bill_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_payments` (
  `bill_ref` char(20) NOT NULL,
  `payment_type` char(20) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `bill_date` date NOT NULL,
  `date_created` date DEFAULT (curdate()),
  `time_created` time DEFAULT (curtime()),
  `mech_no` int NOT NULL,
  KEY `mech_no` (`mech_no`),
  CONSTRAINT `bill_payments_ibfk_1` FOREIGN KEY (`mech_no`) REFERENCES `mech_setup` (`mech_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_payments`
--

LOCK TABLES `bill_payments` WRITE;
/*!40000 ALTER TABLE `bill_payments` DISABLE KEYS */;
INSERT INTO `bill_payments` VALUES ('201250209111','cash',375.90,'2025-02-09','2025-02-09','15:31:34',1),('201250209211','momo',25.00,'2025-02-09','2025-02-09','16:11:56',1),('201250209311','cash',375.90,'2025-02-09','2025-02-09','16:16:05',1),('201250209411','cash',25.00,'2025-02-09','2025-02-09','16:17:52',1),('201250209511','cash',25.00,'2025-02-09','2025-02-09','16:21:05',1),('201250209611','cash',25.00,'2025-02-09','2025-02-09','16:22:01',1),('201250209711','cash',-25.00,'2025-02-09','2025-02-09','16:22:35',1),('201250209811','card',91.00,'2025-02-09','2025-02-09','16:38:04',1),('201250209911','cancel',400.90,'2025-02-09','2025-02-13','06:23:07',1),('2012502091011','cash',45.40,'2025-02-09','2025-02-13','06:38:56',1),('2012502091111','cash',50.00,'2025-02-09','2025-02-13','06:39:34',1),('2012502091211','credit',375.90,'2025-02-09','2025-02-13','06:43:46',1),('2012502091311','cancel',1127.70,'2025-02-09','2025-02-13','06:44:19',1),('2012502091411','card',50.70,'2025-02-09','2025-02-13','06:45:54',1),('2012502091511','cash',100.00,'2025-02-09','2025-02-13','06:46:16',1),('2012502091611','cash',50.00,'2025-02-09','2025-02-13','06:48:54',1),('2012502091711','cash',133.78,'2025-02-09','2025-02-13','06:49:16',1),('2012502091811','cash',375.90,'2025-02-09','2025-02-13','06:52:41',1),('999250404111','cash',25.00,'2025-04-04','2025-04-04','22:52:18',1),('999250404211','cancel',99.85,'2025-04-04','2025-04-05','13:14:40',1),('999250404311','cash',1075.90,'2025-04-04','2025-04-05','13:14:48',1),('999250404411','cash',78.00,'2025-04-04','2025-04-05','13:24:17',1),('999250404511','cash',1075.90,'2025-04-04','2025-04-18','07:54:33',1),('999250404611','cash',25.00,'2025-04-04','2025-04-18','07:55:42',1),('999250404711','cash',25.00,'2025-04-04','2025-04-19','13:14:12',1),('999250404811','cash',375.90,'2025-04-04','2025-04-19','13:17:52',1),('999250404911','cash',700.00,'2025-04-04','2025-04-19','13:19:34',1),('9992504041011','cash',700.00,'2025-04-04','2025-04-19','13:20:28',1),('9992504041111','cash',1400.00,'2025-04-04','2025-04-19','18:33:03',1),('9992504041211','cash',748.40,'2025-04-04','2025-04-19','18:35:13',1),('9992504041311','cash',700.00,'2025-04-04','2025-04-19','18:39:56',1),('9992504041411','cash',700.00,'2025-04-04','2025-04-19','18:41:14',1),('9992504041511','cash',1075.90,'2025-04-04','2025-04-19','18:42:19',1),('9992504041611','cash',700.00,'2025-04-04','2025-04-19','18:46:38',1),('9992504041711','cash',1075.90,'2025-04-04','2025-04-19','18:47:53',1),('9992504041811','cash',1075.90,'2025-04-04','2025-04-19','19:02:50',1),('9992504041911','cash',1075.90,'2025-04-04','2025-04-19','19:05:32',1),('9992504042011','cash',13300.00,'2025-04-04','2025-04-19','22:47:49',1),('9992504042111','cash',1261.53,'2025-04-04','2025-04-19','23:37:49',1),('9992504042211','cash',700.00,'2025-04-04','2025-04-20','11:32:24',1),('999250420111','cash',375.90,'2025-04-20','2025-04-20','12:18:13',1),('999250420211','cash',34.85,'2025-04-20','2025-04-20','13:39:00',1),('999250420311','cash',700.00,'2025-04-20','2025-04-20','13:40:22',1),('999250420411','cash',700.00,'2025-04-20','2025-04-26','21:25:05',1),('999250427111','cash',25.00,'2025-04-27','2025-04-27','05:48:22',1),('999250427211','cash',1075.90,'2025-04-27','2025-04-27','05:49:35',1),('999250427311','cash',700.00,'2025-04-27','2025-05-18','16:30:20',1),('999250427411','cash',700.00,'2025-04-27','2025-06-01','22:51:18',1),('999250427511','cash',375.90,'2025-04-27','2025-06-01','22:53:30',1),('999250601111','cash',700.00,'2025-06-01','2025-06-01','22:54:30',1),('999250607111','cash',75.20,'2025-06-07','2025-06-07','17:18:52',1),('999250607211','cash',1400.00,'2025-06-07','2025-06-10','20:35:47',1),('999250607311','credit',375.90,'2025-06-07','2025-06-10','20:37:23',1),('999250624111','cash',700.00,'2025-06-24','2025-06-24','02:29:00',1),('999250624111','cash',700.00,'2025-06-24','2025-06-24','03:07:14',1),('999250624111','cash',700.00,'2025-06-24','2025-06-24','03:09:54',1),('999250624111','cash',700.00,'2025-06-24','2025-06-24','03:26:14',1),('999250625111','cash',796.13,'2025-06-25','2025-06-25','03:16:56',1),('999250625211','cash',33.11,'2025-06-25','2025-06-25','03:17:08',1),('999250625311','cash',99.30,'2025-06-25','2025-06-25','03:17:18',1),('999250625411','cash',93.11,'2025-06-25','2025-06-25','03:17:27',1),('999250625511','card',1092.00,'2025-06-25','2025-06-25','03:17:43',1),('999250625111','cash',466.90,'2025-06-25','2025-06-25','03:32:36',1),('999250625111','cash',1075.90,'2025-06-25','2025-06-25','03:41:50',1),('999250625111','cash',700.00,'2025-06-25','2025-06-25','04:02:13',1),('999250625211','momo',375.90,'2025-06-25','2025-06-25','04:02:18',1),('999250625311','card',91.00,'2025-06-25','2025-06-25','04:03:07',1),('999250625411','card',273.00,'2025-06-25','2025-06-25','04:04:35',1),('999250625111','cash',71.40,'2025-06-25','2025-06-25','04:17:37',1),('999250625211','momo',182.00,'2025-06-25','2025-06-25','04:17:49',1),('999250625311','card',91.00,'2025-06-25','2025-06-25','04:17:54',1),('999250625111','cash',45.40,'2025-06-25','2025-06-25','04:19:36',1),('999250625211','momo',91.00,'2025-06-25','2025-06-25','04:19:45',1),('999250625111','cash',375.90,'2025-06-25','2025-06-25','04:24:14',1),('999250625211','momo',700.00,'2025-06-25','2025-06-25','04:24:19',1),('999250625311','card',34.85,'2025-06-25','2025-06-25','04:24:26',1),('999250625111','cash',25.00,'2025-06-25','2025-06-25','04:26:13',1),('999250625211','momo',700.00,'2025-06-25','2025-06-25','04:26:25',1),('999250625311','card',102.31,'2025-06-25','2025-06-25','04:26:34',1),('999250625111','cash',25.00,'2025-06-25','2025-06-25','04:30:00',1),('999250625211','momo',700.00,'2025-06-25','2025-06-25','04:30:11',1),('999250625311','card',62.85,'2025-06-25','2025-06-25','04:30:20',1),('999250625111','cash',25.00,'2025-06-25','2025-06-25','04:32:07',1),('999250625211','momo',700.00,'2025-06-25','2025-06-25','04:32:15',1),('999250625311','card',20.42,'2025-06-25','2025-06-25','04:32:24',1),('999250625111','cash',25.00,'2025-06-25','2025-06-25','05:32:55',1),('999250625211','momo',83.25,'2025-06-25','2025-06-25','05:33:03',1),('999250625311','card',91.00,'2025-06-25','2025-06-25','05:33:14',1),('999250625111','cash',25.00,'2025-06-25','2025-06-25','05:35:40',1),('999250625211','momo',700.00,'2025-06-25','2025-06-25','05:35:47',1),('999250625311','card',20.71,'2025-06-25','2025-06-25','05:35:59',1),('999250625111','cash',161.40,'2025-06-25','2025-06-25','05:47:19',1),('999250625111','cash',836.40,'2025-06-25','2025-06-25','05:54:04',1),('999250625211','momo',700.00,'2025-06-25','2025-06-25','05:54:12',1),('999250625311','card',91.00,'2025-06-25','2025-06-25','05:54:25',1),('999250624111','cash',1075.90,'2025-06-24','2025-06-24','16:08:19',1),('999250624111','cash',25.00,'2025-06-24','2025-06-24','16:13:44',1),('999250624211','momo',6.60,'2025-06-24','2025-06-24','16:13:53',1),('999250624311','card',10.84,'2025-06-24','2025-06-24','16:13:58',1),('999250624111','cash',791.00,'2025-06-24','2025-06-24','17:10:06',1),('999250624111','cash',700.00,'2025-06-24','2025-06-24','17:21:58',1),('999250624211','momo',375.90,'2025-06-24','2025-06-24','17:22:03',1),('999250627111','cash',700.00,'2025-06-27','2025-06-27','05:22:08',1),('999250628111','cash',1075.90,'2025-06-28','2025-06-28','06:59:18',1),('999250628111','cash',375.90,'2025-06-28','2025-06-28','08:43:01',1),('999250628211','momo',700.00,'2025-06-28','2025-06-28','08:43:06',1),('999250628311','card',66.83,'2025-06-28','2025-06-28','08:43:17',1),('999250628411','credit',91.00,'2025-06-28','2025-06-28','08:43:27',1),('999250628111','cash',375.90,'2025-06-28','2025-06-28','08:47:21',1),('999250628211','momo',700.00,'2025-06-28','2025-06-28','08:47:26',1),('999250628311','card',74.70,'2025-06-28','2025-06-28','08:47:34',1),('999250628411','card',118.66,'2025-06-28','2025-06-28','08:47:42',1),('999250628111','cash',700.00,'2025-06-28','2025-06-28','12:11:36',1);
/*!40000 ALTER TABLE `bill_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_pmt`
--

DROP TABLE IF EXISTS `bill_pmt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_pmt` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bill` int DEFAULT NULL,
  `bill_amount` decimal(10,2) DEFAULT NULL,
  `amount_paid` decimal(10,2) DEFAULT NULL,
  `amount_balance` decimal(10,2) DEFAULT NULL,
  `trans_date` date DEFAULT (curdate()),
  `trans_time` time DEFAULT (curtime()),
  PRIMARY KEY (`id`),
  UNIQUE KEY `bill_pmt_id_uindex` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_pmt`
--

LOCK TABLES `bill_pmt` WRITE;
/*!40000 ALTER TABLE `bill_pmt` DISABLE KEYS */;
/*!40000 ALTER TABLE `bill_pmt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_tax_tran`
--

DROP TABLE IF EXISTS `bill_tax_tran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_tax_tran` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bill_date` date NOT NULL,
  `clerk_code` int NOT NULL,
  `mech_no` int NOT NULL,
  `bill_no` int NOT NULL,
  `tran_code` int NOT NULL,
  `tran_qty` int NOT NULL,
  `taxableAmt` decimal(10,2) DEFAULT (0.00),
  `tax_code` varchar(3) NOT NULL,
  `tax_amt` decimal(10,2) DEFAULT (0.00),
  `billRef` text,
  `shift` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_tax_tran`
--

LOCK TABLES `bill_tax_tran` WRITE;
/*!40000 ALTER TABLE `bill_tax_tran` DISABLE KEYS */;
/*!40000 ALTER TABLE `bill_tax_tran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_trans`
--

DROP TABLE IF EXISTS `bill_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_trans` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'BILL NUMBER',
  `mach` int DEFAULT NULL COMMENT 'machine number',
  `clerk` text,
  `bill_number` int NOT NULL,
  `item_barcode` text NOT NULL,
  `trans_type` text NOT NULL COMMENT 'Transaction Type',
  `retail_price` decimal(10,2) DEFAULT '0.00',
  `date_added` date DEFAULT (curdate()),
  `time_added` time DEFAULT (curtime()),
  `item_qty` decimal(10,2) DEFAULT '0.00',
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `bill_amt` decimal(10,2) DEFAULT '0.00',
  `item_desc` varchar(255) DEFAULT NULL,
  `tax_grp` varchar(255) DEFAULT 'NULL',
  `tran_type` char(2) DEFAULT NULL,
  `tax_rate` decimal(10,2) DEFAULT '0.00',
  `selected` int DEFAULT '0',
  `billRef` text,
  `gfund` decimal(10,2) DEFAULT (0.00),
  `nhis` decimal(10,2) DEFAULT (0.00),
  `covid` decimal(10,2) DEFAULT (0.00),
  `vat` decimal(10,2) DEFAULT (0.00),
  `tax_code` text,
  `shift` int NOT NULL,
  `loyalty_points` decimal(10,2) DEFAULT (0.00),
  `discount` decimal(10,2) DEFAULT (0.00),
  `discount_rate` decimal(10,2) DEFAULT (0.00),
  `old_bill_ref` text,
  `sales_date` date DEFAULT (curdate()),
  `sales_time` time DEFAULT (curtime()),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=206 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_trans`
--

LOCK TABLES `bill_trans` WRITE;
/*!40000 ALTER TABLE `bill_trans` DISABLE KEYS */;
INSERT INTO `bill_trans` VALUES (204,1,'411',1,'2000000001','i',700.00,'2025-06-28','12:11:24',1.00,125.76,700.00,'OIL','YES','SS',0.00,0,'999250628111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','12:11:24'),(205,1,'411',2,'897076002003','i',375.90,'2025-06-28','12:11:48',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0.00,0,'999250628211',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','12:11:48');
/*!40000 ALTER TABLE `bill_trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulk_price_change_hd`
--

DROP TABLE IF EXISTS `bulk_price_change_hd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulk_price_change_hd` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` char(10) NOT NULL,
  `entry_date` date DEFAULT NULL,
  `prod_group` char(4) DEFAULT NULL,
  `rate` decimal(10,2) DEFAULT (0.00),
  `remarks` text,
  `owner` char(20) NOT NULL,
  `created_date` datetime DEFAULT (now()),
  `valid` tinyint(1) DEFAULT (true),
  `approved` tinyint(1) DEFAULT (false),
  `posted` tinyint(1) DEFAULT (false),
  `direction` char(1) DEFAULT (_utf8mb4'+'),
  `loc_id` char(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `loc_id` (`loc_id`),
  CONSTRAINT `bulk_price_change_hd_ibfk_1` FOREIGN KEY (`loc_id`) REFERENCES `loc` (`loc_id`),
  CONSTRAINT `bulk_price_change_hd_ibfk_2` FOREIGN KEY (`loc_id`) REFERENCES `loc` (`loc_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulk_price_change_hd`
--

LOCK TABLES `bulk_price_change_hd` WRITE;
/*!40000 ALTER TABLE `bulk_price_change_hd` DISABLE KEYS */;
INSERT INTO `bulk_price_change_hd` VALUES (7,'PC0011','2025-03-08','*',10.00,'FIRST PRICE CHANGE','1','2025-03-08 13:52:19',1,1,1,'+','001'),(8,'PC0018','2025-06-10','*',10.00,'TEST','1','2025-06-10 20:54:21',1,1,1,'+','001');
/*!40000 ALTER TABLE `bulk_price_change_hd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulk_price_change_trans`
--

DROP TABLE IF EXISTS `bulk_price_change_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulk_price_change_trans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` char(10) NOT NULL,
  `barcode` char(20) NOT NULL,
  `current_price` decimal(10,2) NOT NULL,
  `new_price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulk_price_change_trans`
--

LOCK TABLES `bulk_price_change_trans` WRITE;
/*!40000 ALTER TABLE `bulk_price_change_trans` DISABLE KEYS */;
INSERT INTO `bulk_price_change_trans` VALUES (169,'PC0011','1234567',25.00,27.50),(170,'PC0011','897076002003',0.00,0.00),(171,'PC0011','6154000043513',0.00,0.00),(172,'PC0011','5411188543381',0.00,0.00),(173,'PC0011','5411188110835',0.00,0.00),(174,'PC0011','5411188543398',0.00,0.00),(175,'PC0011','6221024240195',0.00,0.00),(176,'PC0011','60012401000590',0.00,0.00),(177,'PC0011','6002323007463',0.00,0.00),(178,'PC0011','6034000407396',0.00,0.00),(179,'PC0011','6034000407198',0.00,0.00),(180,'PC0011','6034000407099',0.00,0.00),(181,'PC0011','6034000130690',0.00,0.00),(182,'PC0011','6034000130553',0.00,0.00),(183,'PC0011','6034000163735',0.00,0.00),(184,'PC0011','5413721000894',0.00,0.00),(185,'PC0011','5413721000900',0.00,0.00),(186,'PC0011','5413721000887',0.00,0.00),(187,'PC0011','8410128112936',0.00,0.00),(188,'PC0011','8410128113100',0.00,0.00),(189,'PC0011','8410128112905',0.00,0.00),(190,'PC0011','2000000001',0.00,0.00),(191,'PC0018','1234567',27.50,30.25),(192,'PC0018','897076002003',0.00,0.00),(193,'PC0018','6154000043513',0.00,0.00),(194,'PC0018','5411188543381',0.00,0.00),(195,'PC0018','5411188110835',0.00,0.00),(196,'PC0018','5411188543398',0.00,0.00),(197,'PC0018','6221024240195',0.00,0.00),(198,'PC0018','60012401000590',0.00,0.00),(199,'PC0018','6002323007463',0.00,0.00),(200,'PC0018','6034000407396',0.00,0.00),(201,'PC0018','6034000407198',0.00,0.00),(202,'PC0018','6034000407099',0.00,0.00),(203,'PC0018','6034000130690',0.00,0.00),(204,'PC0018','6034000130553',0.00,0.00),(205,'PC0018','6034000163735',0.00,0.00),(206,'PC0018','5413721000894',0.00,0.00),(207,'PC0018','5413721000900',0.00,0.00),(208,'PC0018','5413721000887',0.00,0.00),(209,'PC0018','8410128112936',0.00,0.00),(210,'PC0018','8410128113100',0.00,0.00),(211,'PC0018','8410128112905',0.00,0.00),(212,'PC0018','2000000001',0.00,0.00),(213,'PC0018','2000000002',0.00,0.00);
/*!40000 ALTER TABLE `bulk_price_change_trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clerk`
--

DROP TABLE IF EXISTS `clerk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clerk` (
  `id` int NOT NULL AUTO_INCREMENT,
  `clerk_code` text NOT NULL,
  `clerk_key` text NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `clerk_name` text NOT NULL,
  `user_grp` int NOT NULL,
  `status` int DEFAULT (1) COMMENT 'If 1, clerk is active, else clerk is not active',
  `pin` char(4) NOT NULL,
  `token` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clerk_pk` (`pin`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clerk`
--

LOCK TABLES `clerk` WRITE;
/*!40000 ALTER TABLE `clerk` DISABLE KEYS */;
INSERT INTO `clerk` VALUES (1,'411','17d63b1625c816c22647a73e1482372b','2025-02-09 14:58:57','Admin',1,1,'1444','1444');
/*!40000 ALTER TABLE `clerk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comm_settings`
--

DROP TABLE IF EXISTS `comm_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comm_settings` (
  `sms_api_key` char(100) NOT NULL,
  `sms_api_url` char(100) NOT NULL,
  `sms_sender_id` char(10) NOT NULL,
  `smtp_host` char(100) NOT NULL,
  `smtp_pass` char(100) NOT NULL,
  `smtp_port` int NOT NULL,
  `smtp_secure` char(3) NOT NULL,
  `smtp_user` char(100) NOT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  `purpose` char(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comm_settings`
--

LOCK TABLES `comm_settings` WRITE;
/*!40000 ALTER TABLE `comm_settings` DISABLE KEYS */;
INSERT INTO `comm_settings` VALUES ('VENTA POS','jhdafhsdj','VENTA POS','smtp.gmail.com','kaljfkd',587,'ssl','test@gmail.com',1,'general');
/*!40000 ALTER TABLE `comm_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comp_setup`
--

DROP TABLE IF EXISTS `comp_setup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comp_setup` (
  `id` int NOT NULL DEFAULT '0',
  `c_name` text NOT NULL,
  `currency` int NOT NULL,
  `box` text NOT NULL,
  `street` text NOT NULL,
  `country` text NOT NULL,
  `city` text NOT NULL,
  `phone` text NOT NULL,
  `email` text,
  `tax_code` text,
  `footer` text,
  `code` char(3) NOT NULL,
  `app_version` decimal(10,2) DEFAULT (0.0),
  `is_default` tinyint(1) DEFAULT (false)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comp_setup`
--

LOCK TABLES `comp_setup` WRITE;
/*!40000 ALTER TABLE `comp_setup` DISABLE KEYS */;
INSERT INTO `comp_setup` VALUES (0,'MegaMart Retail',1,'170','East Legon','Ghana','Accra','0201998184','mega@retail.com','21.9',NULL,'001',1.60,0);
/*!40000 ALTER TABLE `comp_setup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `id` int NOT NULL DEFAULT '0',
  `c_name` text NOT NULL,
  `currency` int NOT NULL,
  `box` text NOT NULL,
  `street` text NOT NULL,
  `country` text NOT NULL,
  `city` text NOT NULL,
  `phone` text NOT NULL,
  `email` text,
  `tax_code` text,
  `footer` text,
  `vat_code` char(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_bill_tran`
--

DROP TABLE IF EXISTS `customer_bill_tran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_bill_tran` (
  `cust_no` int NOT NULL,
  `billRef` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_bill_tran`
--

LOCK TABLES `customer_bill_tran` WRITE;
/*!40000 ALTER TABLE `customer_bill_tran` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_bill_tran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` char(100) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `cust_no` char(10) NOT NULL,
  `status` int NOT NULL DEFAULT '1',
  `total_transactions` decimal(18,6) DEFAULT '0.000000',
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `customers_pk2` (`email`),
  UNIQUE KEY `customers_pk` (`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=10013 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (10012,'JAMES','BOND','jb@domain.com','0546310011','#6 cocoa street','Accra','178','Ghana','CO2',1,0.000000);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers_trans`
--

DROP TABLE IF EXISTS `customers_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers_trans` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `transaction_date` date NOT NULL DEFAULT (curdate()),
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `payment_method` varchar(50) DEFAULT NULL,
  `items_purchased` text,
  `transaction_notes` text,
  `entry_no` text,
  `user` int DEFAULT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `customer_id` (`customer_id`),
  KEY `customers_trans_clerk_id_fk` (`user`),
  CONSTRAINT `customers_trans_clerk_id_fk` FOREIGN KEY (`user`) REFERENCES `clerk` (`id`),
  CONSTRAINT `customers_trans_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers_trans`
--

LOCK TABLES `customers_trans` WRITE;
/*!40000 ALTER TABLE `customers_trans` DISABLE KEYS */;
/*!40000 ALTER TABLE `customers_trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disc_mast`
--

DROP TABLE IF EXISTS `disc_mast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disc_mast` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rate` int NOT NULL,
  `desc` text,
  `disc_uni` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disc_mast`
--

LOCK TABLES `disc_mast` WRITE;
/*!40000 ALTER TABLE `disc_mast` DISABLE KEYS */;
/*!40000 ALTER TABLE `disc_mast` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doc_serial`
--

DROP TABLE IF EXISTS `doc_serial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doc_serial` (
  `id` int NOT NULL AUTO_INCREMENT,
  `year` char(4) DEFAULT NULL,
  `doc` char(10) DEFAULT NULL,
  `nextno` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `doc` (`doc`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doc_serial`
--

LOCK TABLES `doc_serial` WRITE;
/*!40000 ALTER TABLE `doc_serial` DISABLE KEYS */;
INSERT INTO `doc_serial` VALUES (21,'2024','barcode',2000000003),(22,'2024','TR',100002),(23,'2024','SU',112),(24,'2024','PI',1029),(25,'2024','PRO',1001),(26,'2024','INV',100003),(27,'2024','TF',100001);
/*!40000 ALTER TABLE `doc_serial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doc_trans`
--

DROP TABLE IF EXISTS `doc_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doc_trans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doc_type` char(3) NOT NULL,
  `entry_no` varchar(13) NOT NULL,
  `trans_func` char(10) NOT NULL,
  `created_by` text NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=438 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doc_trans`
--

LOCK TABLES `doc_trans` WRITE;
/*!40000 ALTER TABLE `doc_trans` DISABLE KEYS */;
INSERT INTO `doc_trans` VALUES (399,'GRN','GR0001','ADD','411','2025-02-18 06:17:32'),(400,'GRN','GR0001','PRI','1','2025-02-18 06:19:17'),(401,'GRN','GR0001','AP','1','2025-02-18 06:20:00'),(402,'GRN','GR0001','AP','1','2025-02-18 06:50:39'),(403,'GRN','GR0001','AP','1','2025-02-18 06:53:36'),(404,'GRN','GR0001','AP','1','2025-02-26 04:06:14'),(405,'GRN','GR0001','AP','1','2025-02-26 04:16:00'),(406,'GRN','GR0001','AP','1','2025-02-27 05:43:56'),(407,'GRN','GR0001','AP','1','2025-02-27 05:44:12'),(408,'GRN','GR0001','AP','1','2025-02-27 05:45:25'),(409,'GRN','GR0001','AP','1','2025-02-27 05:45:56'),(410,'PC','PC0011','APP','Admin','2025-03-08 13:53:21'),(411,'GRN','GR2','ADD','411','2025-03-08 14:00:19'),(412,'GRN','GR2','PRI','1','2025-03-08 14:00:26'),(413,'GRN','GR2','AP','1','2025-03-08 14:01:10'),(414,'SF','SF0011','approved','1','2025-03-08 14:08:23'),(415,'SC','SC0011','approved','1','2025-03-08 14:09:45'),(416,'AD','AD0011','post','1','2025-03-08 14:10:40'),(417,'INV','INV100001','ADD','Admin','2025-03-08 14:18:13'),(418,'INV','INV100001','APP','Admin','2025-03-08 14:19:22'),(419,'GRN','GR3','ADD','411','2025-03-26 14:11:00'),(420,'GRN','GR3','PRI','1','2025-03-26 14:11:07'),(421,'GRN','GR3','PRI','1','2025-03-26 14:15:28'),(422,'GRN','GR3','PRI','1','2025-03-26 14:15:42'),(423,'GRN','GR3','PRI','1','2025-03-26 14:15:52'),(424,'GRN','GR3','PRI','1','2025-03-26 14:16:07'),(425,'GRN','GR3','PRI','1','2025-03-26 14:16:18'),(426,'GRN','GR3','PRI','1','2025-03-26 14:16:32'),(427,'GRN','GR3','PRI','1','2025-03-26 14:38:44'),(428,'GRN','GR3','PRI','1','2025-03-26 14:44:31'),(429,'GRN','GR3','PRI','1','2025-03-26 14:44:47'),(430,'GRN','GR3','PRI','1','2025-03-26 14:46:21'),(431,'GRN','GR3','PRI','1','2025-03-26 14:54:39'),(432,'PO','PO5','PRI','1','2025-03-26 14:58:02'),(433,'PRO','PRO1000','ADD','Admin','2025-03-27 06:10:45'),(434,'PRO','PRO1000','APP','Admin','2025-03-27 06:11:07'),(435,'INV','INV100002','ADD','Admin','2025-03-27 06:13:04'),(436,'INV','INV100002','APP','Admin','2025-03-27 06:13:24'),(437,'PC','PC0018','APP','Admin','2025-06-10 20:54:36');
/*!40000 ALTER TABLE `doc_trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eod_serial`
--

DROP TABLE IF EXISTS `eod_serial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eod_serial` (
  `sales_date` date NOT NULL,
  `gross` decimal(20,1) DEFAULT NULL,
  `deductions` decimal(20,1) DEFAULT NULL,
  `tax` decimal(20,1) DEFAULT NULL,
  `net` decimal(20,1) DEFAULT NULL,
  `eod_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `clerk_code` int DEFAULT NULL,
  `status` int DEFAULT (0),
  `shift` int NOT NULL,
  PRIMARY KEY (`sales_date`,`shift`),
  KEY `eod_serial_clerk_id_fk` (`clerk_code`),
  CONSTRAINT `eod_serial_clerk_id_fk` FOREIGN KEY (`clerk_code`) REFERENCES `clerk` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eod_serial`
--

LOCK TABLES `eod_serial` WRITE;
/*!40000 ALTER TABLE `eod_serial` DISABLE KEYS */;
/*!40000 ALTER TABLE `eod_serial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `err_code`
--

DROP TABLE IF EXISTS `err_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `err_code` (
  `code` char(255) DEFAULT NULL COMMENT 'Error Code',
  `description` text COMMENT 'Error Description\n',
  UNIQUE KEY `err_code_code_uindex` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `err_code`
--

LOCK TABLES `err_code` WRITE;
/*!40000 ALTER TABLE `err_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `err_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evat_transactions`
--

DROP TABLE IF EXISTS `evat_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evat_transactions` (
  `billRef` char(255) NOT NULL,
  `ysdcid` text NOT NULL,
  `ysdcitems` int NOT NULL,
  `ysdcmrc` text NOT NULL,
  `ysdcmrctim` text NOT NULL,
  `ysdcrecnum` text NOT NULL,
  `ysdctime` text NOT NULL,
  `ysdcintdata` char(255) NOT NULL,
  `ysdcregsig` char(255) NOT NULL,
  `qr_code` text NOT NULL,
  UNIQUE KEY `billRef` (`billRef`),
  UNIQUE KEY `ysdcintdata` (`ysdcintdata`),
  UNIQUE KEY `ysdcregsig` (`ysdcregsig`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evat_transactions`
--

LOCK TABLES `evat_transactions` WRITE;
/*!40000 ALTER TABLE `evat_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `evat_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grn_hd`
--

DROP TABLE IF EXISTS `grn_hd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grn_hd` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` varchar(13) DEFAULT NULL,
  `po_number` varchar(13) NOT NULL,
  `loc` varchar(3) NOT NULL,
  `date_received` date NOT NULL,
  `supplier` varchar(12) NOT NULL,
  `remarks` text,
  `invoice_num` varchar(13) NOT NULL,
  `invoice_amt` decimal(10,2) NOT NULL,
  `tax` int DEFAULT '0',
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `net_amt` decimal(10,2) DEFAULT '0.00',
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` text,
  `status` int DEFAULT '0',
  `fx_cur` char(5) DEFAULT NULL,
  `fx_rate` decimal(10,2) DEFAULT '1.00',
  `fx_value` decimal(10,2) DEFAULT '0.00',
  `is_posted` tinyint(1) DEFAULT (false),
  `approved` tinyint(1) DEFAULT (false),
  `type` enum('PO','GR','TR') DEFAULT 'GR',
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoice_num` (`invoice_num`),
  KEY `grn_hd_tax_master_id_fk` (`tax`),
  KEY `fx_cur` (`fx_cur`),
  CONSTRAINT `grn_hd_ibfk_1` FOREIGN KEY (`fx_cur`) REFERENCES `admin_currency` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grn_hd`
--

LOCK TABLES `grn_hd` WRITE;
/*!40000 ALTER TABLE `grn_hd` DISABLE KEYS */;
INSERT INTO `grn_hd` VALUES (1,'GR0001','PO4','001','2025-02-18','SU105','Purchase from CHANDLOK FZCO and delivered to Sales Outlet','IN19282',1000.00,0,0.00,0.00,'2025-02-18 06:17:32','411',1,'GHS',1.00,1000.00,1,1,'PO'),(2,'GR2','PO5','999','2025-03-08','SU101','Purchase from Ekaza and delivered to Storage','INV123',6000.00,0,0.00,0.00,'2025-03-08 14:00:19','411',1,'GHS',1.00,6000.00,1,1,'PO'),(3,'GR3','direct','001','2025-03-26','SU110','TEST','OBIDI',213.04,0,0.00,0.00,'2025-03-26 14:11:00','411',0,'GHS',1.00,213.04,0,0,'GR');
/*!40000 ALTER TABLE `grn_hd` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `before_grn_save` BEFORE INSERT ON `grn_hd` FOR EACH ROW BEGIN
    -- Set the type based on the po_number
    DECLARE po_count INT;
    IF NEW.po_number = 'transfer' THEN
        SET NEW.type = 'TR';
    ELSEIF NEW.po_number = 'direct' THEN
        SET NEW.type = 'GR';
    ELSE
        -- Check for the number of occurrences of po_number in the table

        SELECT COUNT(*) INTO po_count FROM po_hd WHERE doc_no = NEW.po_number;

        IF po_count = 1 THEN
            SET NEW.type = 'PO';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `grn_trans`
--

DROP TABLE IF EXISTS `grn_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grn_trans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` char(13) DEFAULT NULL,
  `item_code` char(13) DEFAULT NULL,
  `barcode` char(13) DEFAULT NULL,
  `item_description` text NOT NULL,
  `owner` char(13) DEFAULT NULL,
  `date_added` date DEFAULT (curdate()),
  `pack_desc` text,
  `packing` text,
  `pack_um` decimal(10,2) DEFAULT '0.00',
  `qty` decimal(10,2) DEFAULT '0.00',
  `cost` decimal(10,2) DEFAULT '0.00',
  `total_cost` decimal(10,2) DEFAULT '0.00',
  `status` int DEFAULT '0',
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `net_amt` decimal(10,2) DEFAULT '0.00',
  `prod_cost` decimal(10,2) DEFAULT '0.00',
  `ret_amt` decimal(10,2) DEFAULT '0.00',
  `expiry_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grn_trans`
--

LOCK TABLES `grn_trans` WRITE;
/*!40000 ALTER TABLE `grn_trans` DISABLE KEYS */;
INSERT INTO `grn_trans` VALUES (1,'GR0001','1000006739','6221024240195','HARS\"18','411','2025-02-18','CTN',NULL,1.00,10.00,100.00,1000.00,0,0.00,0.00,100.00,0.00,'2025-12-17'),(2,'GR2','1000006754','2000000001','OIL','411','2025-03-08','3',NULL,25.00,10.00,600.00,6000.00,0,0.00,0.00,24.00,0.00,'2025-04-02'),(3,'GR3','1000006739','6221024240195','HARS\"18','411','2025-03-26','CTN',NULL,10.00,1.00,100.00,100.00,0,0.00,0.00,10.00,0.00,'2025-12-31'),(4,'GR3','1000006741','6002323007463','PEARLY BAY SWEET WHITE 750ML','411','2025-03-26','CTN',NULL,10.00,2.00,56.52,113.04,0,0.00,0.00,5.65,0.00,'2025-12-26');
/*!40000 ALTER TABLE `grn_trans` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `grn_fx_calculations` AFTER INSERT ON `grn_trans` FOR EACH ROW BEGIN
    -- declare variable
    declare hd_entry char(12) default '';
    declare hd_rate decimal(10, 2) default (0.00);
    declare new_fx_value decimal(10, 2) default (0.00);

    -- set values
    set hd_entry = NEW.entry_no;
    set hd_rate = (SELECT grn_hd.fx_rate from grn_hd where grn_hd.entry_no = hd_entry);
    set new_fx_value = NEW.total_cost * hd_rate;

    -- update fx
    update grn_hd set grn_hd.fx_value = grn_hd.fx_value + new_fx_value where entry_no = hd_entry;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `history_header`
--

DROP TABLE IF EXISTS `history_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history_header` (
  `mach_no` int DEFAULT NULL,
  `clerk` text,
  `bill_no` int DEFAULT NULL,
  `pmt_type` text,
  `gross_amt` decimal(10,2) DEFAULT '0.00',
  `disc_rate` decimal(10,2) DEFAULT '0.00',
  `disc_amt` decimal(10,0) DEFAULT '0',
  `bill_amt` decimal(10,2) DEFAULT NULL,
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `net_amt` decimal(10,2) DEFAULT '0.00',
  `amt_paid` decimal(10,2) NOT NULL DEFAULT '0.00',
  `bill_date` date DEFAULT (curdate()),
  `amt_bal` decimal(10,2) DEFAULT (0.00),
  `bill_time` time DEFAULT (curtime()),
  `tran_qty` decimal(10,2) NOT NULL DEFAULT '0.00',
  `id` int NOT NULL DEFAULT '0',
  `billRef` text,
  `taxable_amt` decimal(10,2) DEFAULT (0.00),
  `non_taxable_amt` decimal(10,2) DEFAULT (0.00),
  `shift` int NOT NULL,
  `old_bill_ref` text,
  `sales_date` date DEFAULT (curdate()),
  `sales_type` text,
  `customer` text,
  `sync` tinyint(1) DEFAULT (false),
  `mast_slave` tinyint(1) DEFAULT (0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history_header`
--

LOCK TABLES `history_header` WRITE;
/*!40000 ALTER TABLE `history_header` DISABLE KEYS */;
INSERT INTO `history_header` VALUES (1,'1',1,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-24',0.00,'03:26:14',1.00,57,'999250624111',700.00,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',1,'cash',796.13,0.00,0,796.13,174.35,621.78,796.13,'2025-06-25',0.00,'03:16:56',3.00,58,'999250625111',796.13,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'cash',33.11,0.00,0,33.11,7.26,25.85,33.11,'2025-06-25',0.00,'03:17:08',3.00,59,'999250625211',33.11,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'cash',99.30,0.00,0,99.30,21.76,77.54,99.30,'2025-06-25',0.00,'03:17:18',5.00,60,'999250625311',99.30,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',4,'cash',93.11,0.00,0,93.11,20.39,72.72,93.11,'2025-06-25',0.00,'03:17:27',4.00,61,'999250625411',93.11,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',5,'card',1092.00,0.00,0,1092.00,239.15,852.85,1092.00,'2025-06-25',0.00,'03:17:43',1.00,62,'999250625511',1092.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',466.90,0.00,0,466.90,102.25,364.65,466.90,'2025-06-25',0.00,'03:32:36',2.00,63,'999250625111',466.90,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',1075.90,0.00,0,1075.90,235.62,840.28,1075.90,'2025-06-25',0.00,'03:41:50',2.00,64,'999250625111',1075.90,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'04:02:13',1.00,65,'999250625111',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-06-25',0.00,'04:02:18',1.00,66,'999250625211',375.90,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',91.00,0.00,0,91.00,19.93,71.07,91.00,'2025-06-25',0.00,'04:03:06',1.00,67,'999250625311',91.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',4,'card',273.00,0.00,0,273.00,59.79,213.21,273.00,'2025-06-25',0.00,'04:04:35',3.00,68,'999250625411',273.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',71.40,0.00,0,71.40,15.64,55.76,71.40,'2025-06-25',0.00,'04:17:37',3.00,69,'999250625111',71.40,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',182.00,0.00,0,182.00,39.86,142.14,182.00,'2025-06-25',0.00,'04:17:49',2.00,70,'999250625211',182.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',91.00,0.00,0,91.00,19.93,71.07,91.00,'2025-06-25',0.00,'04:17:54',1.00,71,'999250625311',91.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',45.40,0.00,0,45.40,9.94,35.46,45.40,'2025-06-25',0.00,'04:19:36',1.00,72,'999250625111',45.40,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',91.00,0.00,0,91.00,19.93,71.07,91.00,'2025-06-25',0.00,'04:19:45',1.00,73,'999250625211',91.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-06-25',0.00,'04:24:14',1.00,74,'999250625111',375.90,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'04:24:19',1.00,75,'999250625211',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',34.85,0.00,0,34.85,7.63,27.22,34.85,'2025-06-25',0.00,'04:24:26',1.00,76,'999250625311',34.85,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-06-25',0.00,'04:26:13',1.00,77,'999250625111',25.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'04:26:25',1.00,78,'999250625211',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',102.31,0.00,0,102.31,22.40,79.91,102.31,'2025-06-25',0.00,'04:26:34',4.00,79,'999250625311',102.31,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-06-25',0.00,'04:30:00',1.00,80,'999250625111',25.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'04:30:11',1.00,81,'999250625211',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',62.85,0.00,0,62.85,13.76,49.09,62.85,'2025-06-25',0.00,'04:30:20',2.00,82,'999250625311',62.85,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-06-25',0.00,'04:32:06',1.00,83,'999250625111',25.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'04:32:15',1.00,84,'999250625211',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',20.42,0.00,0,20.42,4.48,15.94,20.42,'2025-06-25',0.00,'04:32:24',2.00,85,'999250625311',20.42,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-06-25',0.00,'05:32:55',1.00,86,'999250625111',25.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',83.25,0.00,0,83.25,18.23,65.02,83.25,'2025-06-25',0.00,'05:33:03',2.00,87,'999250625211',83.25,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',91.00,0.00,0,91.00,19.93,71.07,91.00,'2025-06-25',0.00,'05:33:14',1.00,88,'999250625311',91.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-06-25',0.00,'05:35:40',1.00,89,'999250625111',25.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'05:35:47',1.00,90,'999250625211',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',20.71,0.00,0,20.71,4.54,16.17,20.71,'2025-06-25',0.00,'05:35:59',2.00,91,'999250625311',20.71,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',161.40,0.00,0,161.40,35.35,126.05,161.40,'2025-06-25',0.00,'05:47:19',3.00,92,'999250625111',161.40,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',836.40,0.00,0,836.40,183.17,653.23,836.40,'2025-06-25',0.00,'05:54:04',3.00,93,'999250625111',836.40,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-25',0.00,'05:54:12',1.00,94,'999250625211',700.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',3,'card',91.00,0.00,0,91.00,19.93,71.07,91.00,'2025-06-25',0.00,'05:54:25',1.00,95,'999250625311',91.00,0.00,1,NULL,'2025-06-25','sale','bill',0,0),(1,'1',1,'cash',1075.90,0.00,0,1075.90,235.62,840.28,1075.90,'2025-06-24',0.00,'16:08:19',2.00,96,'999250624111',1075.90,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',1,'cash',25.00,0.00,0,25.00,5.48,19.52,25.00,'2025-06-24',0.00,'16:13:44',1.00,97,'999250624111',25.00,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',2,'momo',6.60,0.00,0,6.60,1.45,5.15,6.60,'2025-06-24',0.00,'16:13:53',1.00,98,'999250624211',6.60,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',3,'card',10.84,0.00,0,10.84,2.37,8.47,10.84,'2025-06-24',0.00,'16:13:58',2.00,99,'999250624311',10.84,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',1,'cash',791.00,0.00,0,791.00,173.23,617.77,791.00,'2025-06-24',0.00,'17:10:06',2.00,100,'999250624111',791.00,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',1,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-24',0.00,'17:21:58',1.00,101,'999250624111',700.00,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',2,'momo',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-06-24',0.00,'17:22:03',1.00,102,'999250624211',375.90,0.00,1,NULL,'2025-06-24','sale','bill',0,0),(1,'1',1,'cash',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-27',0.00,'05:22:08',1.00,103,'999250627111',700.00,0.00,1,NULL,'2025-06-27','sale','bill',0,0),(1,'1',1,'cash',1075.90,0.00,0,1075.90,235.62,840.28,1075.90,'2025-06-28',0.00,'06:59:18',2.00,104,'999250628111',1075.90,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',1,'cash',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-06-28',0.00,'08:43:01',1.00,105,'999250628111',375.90,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-28',0.00,'08:43:06',1.00,106,'999250628211',700.00,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',3,'card',66.83,0.00,0,66.83,14.63,52.20,66.83,'2025-06-28',0.00,'08:43:17',4.00,107,'999250628311',66.83,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',4,'credit',91.00,0.00,0,91.00,19.93,71.07,91.00,'2025-06-28',0.00,'08:43:27',1.00,108,'999250628411',91.00,0.00,1,NULL,'2025-06-28','sale','CO2',0,0),(1,'1',1,'cash',375.90,0.00,0,375.90,82.32,293.58,375.90,'2025-06-28',0.00,'08:47:21',1.00,109,'999250628111',375.90,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',2,'momo',700.00,0.00,0,700.00,153.30,546.70,700.00,'2025-06-28',0.00,'08:47:26',1.00,110,'999250628211',700.00,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',3,'card',74.70,0.00,0,74.70,16.36,58.34,74.70,'2025-06-28',0.00,'08:47:34',3.00,111,'999250628311',74.70,0.00,1,NULL,'2025-06-28','sale','bill',0,0),(1,'1',4,'card',118.66,0.00,0,118.66,25.99,92.67,118.66,'2025-06-28',0.00,'08:47:42',7.00,112,'999250628411',118.66,0.00,1,NULL,'2025-06-28','sale','bill',0,0);
/*!40000 ALTER TABLE `history_header` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `history_tax_tran`
--

DROP TABLE IF EXISTS `history_tax_tran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history_tax_tran` (
  `id` int NOT NULL DEFAULT '0',
  `bill_date` date NOT NULL,
  `clerk_code` int NOT NULL,
  `mech_no` int NOT NULL,
  `bill_no` int NOT NULL,
  `tran_code` int NOT NULL,
  `tran_qty` int NOT NULL,
  `taxableAmt` decimal(10,2) DEFAULT (0.00),
  `tax_code` varchar(3) NOT NULL,
  `tax_amt` decimal(10,2) DEFAULT (0.00),
  `billRef` text,
  `shift` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history_tax_tran`
--

LOCK TABLES `history_tax_tran` WRITE;
/*!40000 ALTER TABLE `history_tax_tran` DISABLE KEYS */;
/*!40000 ALTER TABLE `history_tax_tran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `history_trans`
--

DROP TABLE IF EXISTS `history_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history_trans` (
  `id` int NOT NULL DEFAULT '0' COMMENT 'BILL NUMBER',
  `mach` int DEFAULT NULL COMMENT 'machine number',
  `clerk` text,
  `bill_number` int NOT NULL,
  `item_barcode` text NOT NULL,
  `trans_type` text NOT NULL COMMENT 'Transaction Type',
  `retail_price` decimal(10,2) DEFAULT NULL COMMENT 'Value of transaction',
  `date_added` date DEFAULT (curdate()),
  `time_added` time DEFAULT (curtime()),
  `item_qty` decimal(10,2) DEFAULT '0.00',
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `bill_amt` decimal(10,2) DEFAULT '0.00',
  `item_desc` varchar(255) DEFAULT NULL,
  `tax_grp` varchar(255) DEFAULT 'NULL',
  `tran_type` char(2) DEFAULT NULL,
  `tax_rate` int DEFAULT NULL,
  `selected` int DEFAULT '0',
  `billRef` text,
  `gfund` decimal(10,2) DEFAULT (0.00),
  `nhis` decimal(10,2) DEFAULT (0.00),
  `covid` decimal(10,2) DEFAULT (0.00),
  `vat` decimal(10,2) DEFAULT (0.00),
  `tax_code` text,
  `shift` int NOT NULL,
  `loyalty_points` decimal(10,2) DEFAULT (0.00),
  `discount` decimal(10,2) DEFAULT (0.00),
  `discount_rate` decimal(10,2) DEFAULT (0.00),
  `old_bill_ref` text,
  `sales_date` date DEFAULT (curdate()),
  `sales_time` time DEFAULT (curtime())
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history_trans`
--

LOCK TABLES `history_trans` WRITE;
/*!40000 ALTER TABLE `history_trans` DISABLE KEYS */;
INSERT INTO `history_trans` VALUES (104,1,'411',1,'2000000001','i',700.00,'2025-06-24','03:26:11',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250624111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','03:26:11'),(105,1,'411',1,'2000000001','i',700.00,'2025-06-25','03:16:37',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:16:37'),(106,1,'411',1,'6002323007463','i',91.00,'2025-06-25','03:16:46',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625111',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:16:46'),(107,1,'411',1,'8410128112936','i',5.13,'2025-06-25','03:16:55',1.00,1.12,5.13,'Pasual Fruit Salad/macedonia Yogurt  125','YES','SS',0,0,'999250625111',0.11,0.11,0.04,1.12,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:16:55'),(108,1,'411',2,'8410128112905','i',5.71,'2025-06-25','03:17:02',1.00,1.25,5.71,'Pascual VANILLA 125gm','YES','SS',0,0,'999250625211',0.12,0.12,0.05,1.25,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:02'),(109,1,'411',2,'6034000130553','i',6.60,'2025-06-25','03:17:04',1.00,1.45,6.60,'Fanmaxx Vanilla 330ML','YES','SS',0,0,'999250625211',0.14,0.14,0.05,1.45,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:04'),(110,1,'411',2,'5413721000900','i',20.80,'2025-06-25','03:17:05',1.00,4.56,20.80,'Incolac Chocolate','YES','SS',0,0,'999250625211',0.43,0.43,0.17,4.56,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:05'),(111,1,'411',3,'2000000002','i',15.00,'2025-06-25','03:17:12',1.00,2.69,15.00,'MILK ','YES','SS',0,0,'999250625311',0.31,0.31,0.12,3.29,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:12'),(112,1,'411',3,'6034000130553','i',6.60,'2025-06-25','03:17:14',1.00,1.45,6.60,'Fanmaxx Vanilla 330ML','YES','SS',0,0,'999250625311',0.14,0.14,0.05,1.45,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:14'),(113,1,'411',3,'6034000130690','i',45.90,'2025-06-25','03:17:15',1.00,10.05,45.90,'FANICE VANILLA&STRAWBERRY 1L','YES','SS',0,0,'999250625311',0.94,0.94,0.38,10.05,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:15'),(114,1,'411',3,'5413721000900','i',20.80,'2025-06-25','03:17:16',1.00,4.56,20.80,'Incolac Chocolate','YES','SS',0,0,'999250625311',0.43,0.43,0.17,4.56,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:16'),(115,1,'411',3,'8410128113100','i',11.00,'2025-06-25','03:17:17',1.00,2.41,11.00,'Pascual Creamy Strawberry 125gm','YES','SS',0,0,'999250625311',0.23,0.23,0.09,2.41,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:17'),(116,1,'411',4,'8410128112905','i',5.71,'2025-06-25','03:17:23',1.00,1.25,5.71,'Pascual VANILLA 125gm','YES','SS',0,0,'999250625411',0.12,0.12,0.05,1.25,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:23'),(117,1,'411',4,'8410128113100','i',11.00,'2025-06-25','03:17:24',1.00,2.41,11.00,'Pascual Creamy Strawberry 125gm','YES','SS',0,0,'999250625411',0.23,0.23,0.09,2.41,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:24'),(118,1,'411',4,'5413721000894','i',28.00,'2025-06-25','03:17:25',1.00,6.13,28.00,'Incolac Banana','YES','SS',0,0,'999250625411',0.57,0.57,0.23,6.13,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:25'),(119,1,'411',4,'5411188543381','i',48.40,'2025-06-25','03:17:26',1.00,10.60,48.40,'Alpro Soya Original Drink 1lt','YES','SS',0,0,'999250625411',0.99,0.99,0.40,10.60,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:26'),(120,1,'411',5,'6002323007463','i',91.00,'2025-06-25','03:17:40',12.00,19.93,1092.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625511',22.40,22.40,8.96,239.15,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:17:40'),(121,1,'411',1,'897076002003','i',375.90,'2025-06-25','03:32:27',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250625111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:32:27'),(122,1,'411',1,'6002323007463','i',91.00,'2025-06-25','03:32:34',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625111',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:32:34'),(123,1,'411',1,'2000000001','i',700.00,'2025-06-25','03:41:46',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:41:46'),(124,1,'411',1,'897076002003','i',375.90,'2025-06-25','03:41:48',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250625111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','03:41:48'),(125,1,'411',1,'2000000001','i',700.00,'2025-06-25','04:02:10',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:02:10'),(126,1,'411',2,'897076002003','i',375.90,'2025-06-25','04:02:17',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250625211',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:02:17'),(127,1,'411',3,'6002323007463','i',91.00,'2025-06-25','04:03:05',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625311',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:03:05'),(128,1,'411',4,'6002323007463','i',91.00,'2025-06-25','04:04:31',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625411',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:04:31'),(129,1,'411',4,'6002323007463','i',91.00,'2025-06-25','04:04:33',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625411',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:04:33'),(130,1,'411',4,'6002323007463','i',91.00,'2025-06-25','04:04:34',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625411',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:04:34'),(131,1,'411',1,'5411188110835','i',45.40,'2025-06-25','04:17:31',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'999250625111',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:17:31'),(132,1,'411',1,'8410128113100','i',11.00,'2025-06-25','04:17:33',1.00,2.41,11.00,'Pascual Creamy Strawberry 125gm','YES','SS',0,0,'999250625111',0.23,0.23,0.09,2.41,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:17:33'),(133,1,'411',1,'2000000002','i',15.00,'2025-06-25','04:17:34',1.00,2.69,15.00,'MILK ','YES','SS',0,0,'999250625111',0.31,0.31,0.12,3.29,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:17:34'),(134,1,'411',2,'6002323007463','i',91.00,'2025-06-25','04:17:45',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625211',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:17:45'),(135,1,'411',2,'6002323007463','i',91.00,'2025-06-25','04:17:47',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625211',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:17:47'),(136,1,'411',3,'6002323007463','i',91.00,'2025-06-25','04:17:52',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625311',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:17:52'),(137,1,'411',1,'5411188110835','i',45.40,'2025-06-25','04:19:34',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'999250625111',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:19:34'),(138,1,'411',2,'6002323007463','i',91.00,'2025-06-25','04:19:43',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625211',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:19:43'),(139,1,'411',1,'897076002003','i',375.90,'2025-06-25','04:24:13',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250625111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:24:13'),(140,1,'411',2,'2000000001','i',700.00,'2025-06-25','04:24:18',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:24:18'),(141,1,'411',3,'5411188543398','i',34.85,'2025-06-25','04:24:24',1.00,7.63,34.85,'Alpro Soya Drink(Unsweetened) 1ltr','YES','SS',0,0,'999250625311',0.71,0.71,0.29,7.63,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:24:24'),(142,1,'411',1,'1234567','i',25.00,'2025-06-25','04:26:12',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250625111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:26:12'),(143,1,'411',2,'2000000001','i',700.00,'2025-06-25','04:26:18',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:26:18'),(144,1,'411',3,'5413721000894','i',28.00,'2025-06-25','04:26:30',1.00,6.13,28.00,'Incolac Banana','YES','SS',0,0,'999250625311',0.57,0.57,0.23,6.13,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:26:30'),(145,1,'411',3,'8410128112905','i',5.71,'2025-06-25','04:26:31',1.00,1.25,5.71,'Pascual VANILLA 125gm','YES','SS',0,0,'999250625311',0.12,0.12,0.05,1.25,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:26:31'),(146,1,'411',3,'5413721000887','i',22.70,'2025-06-25','04:26:32',1.00,4.97,22.70,'Incolac Strawberry','YES','SS',0,0,'999250625311',0.47,0.47,0.19,4.97,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:26:32'),(147,1,'411',3,'6034000130690','i',45.90,'2025-06-25','04:26:32',1.00,10.05,45.90,'FANICE VANILLA&STRAWBERRY 1L','YES','SS',0,0,'999250625311',0.94,0.94,0.38,10.05,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:26:32'),(148,1,'411',1,'1234567','i',25.00,'2025-06-25','04:29:59',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250625111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:29:59'),(149,1,'411',2,'2000000001','i',700.00,'2025-06-25','04:30:09',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:30:09'),(150,1,'411',3,'5411188543398','i',34.85,'2025-06-25','04:30:16',1.00,7.63,34.85,'Alpro Soya Drink(Unsweetened) 1ltr','YES','SS',0,0,'999250625311',0.71,0.71,0.29,7.63,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:30:16'),(151,1,'411',3,'5413721000894','i',28.00,'2025-06-25','04:30:18',1.00,6.13,28.00,'Incolac Banana','YES','SS',0,0,'999250625311',0.57,0.57,0.23,6.13,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:30:18'),(152,1,'411',1,'1234567','i',25.00,'2025-06-25','04:32:05',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250625111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:32:05'),(153,1,'411',2,'2000000001','i',700.00,'2025-06-25','04:32:13',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:32:13'),(154,1,'411',3,'2000000002','i',15.00,'2025-06-25','04:32:22',1.00,2.69,15.00,'MILK ','YES','SS',0,0,'999250625311',0.31,0.31,0.12,3.29,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:32:22'),(155,1,'411',3,'6034000163735','i',5.42,'2025-06-25','04:32:23',1.00,1.19,5.42,'Namio Original 300ML','YES','SS',0,0,'999250625311',0.11,0.11,0.04,1.19,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','04:32:23'),(156,1,'411',1,'1234567','i',25.00,'2025-06-25','05:32:51',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250625111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:32:51'),(157,1,'411',2,'5411188543398','i',34.85,'2025-06-25','05:33:01',1.00,7.63,34.85,'Alpro Soya Drink(Unsweetened) 1ltr','YES','SS',0,0,'999250625211',0.71,0.71,0.29,7.63,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:33:01'),(158,1,'411',2,'5411188543381','i',48.40,'2025-06-25','05:33:02',1.00,10.60,48.40,'Alpro Soya Original Drink 1lt','YES','SS',0,0,'999250625211',0.99,0.99,0.40,10.60,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:33:02'),(159,1,'411',3,'6002323007463','i',91.00,'2025-06-25','05:33:10',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625311',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:33:10'),(160,1,'411',1,'1234567','i',25.00,'2025-06-25','05:35:38',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250625111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:35:38'),(161,1,'411',2,'2000000001','i',700.00,'2025-06-25','05:35:46',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:35:46'),(162,1,'411',3,'2000000002','i',15.00,'2025-06-25','05:35:56',1.00,2.69,15.00,'MILK ','YES','SS',0,0,'999250625311',0.31,0.31,0.12,3.29,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:35:56'),(163,1,'411',3,'8410128112905','i',5.71,'2025-06-25','05:35:58',1.00,1.25,5.71,'Pascual VANILLA 125gm','YES','SS',0,0,'999250625311',0.12,0.12,0.05,1.25,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:35:58'),(164,1,'411',1,'1234567','i',25.00,'2025-06-25','05:47:12',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250625111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:47:12'),(165,1,'411',1,'5411188110835','i',45.40,'2025-06-25','05:47:15',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'999250625111',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:47:15'),(166,1,'411',1,'6002323007463','i',91.00,'2025-06-25','05:47:18',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625111',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:47:18'),(167,1,'411',1,'2000000001','i',700.00,'2025-06-25','05:53:52',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:53:52'),(168,1,'411',1,'5411188110835','i',45.40,'2025-06-25','05:53:58',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'999250625111',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:53:58'),(169,1,'411',1,'6002323007463','i',91.00,'2025-06-25','05:54:02',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625111',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:54:02'),(170,1,'411',2,'2000000001','i',700.00,'2025-06-25','05:54:11',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250625211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:54:11'),(171,1,'411',3,'6002323007463','i',91.00,'2025-06-25','05:54:24',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250625311',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-25','05:54:24'),(172,1,'411',1,'2000000001','i',700.00,'2025-06-24','16:08:16',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250624111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','16:08:16'),(173,1,'411',1,'897076002003','i',375.90,'2025-06-24','16:08:18',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250624111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','16:08:18'),(174,1,'411',1,'1234567','i',25.00,'2025-06-24','16:13:42',1.00,0.00,25.00,'Mango Juice','YES','SS',0,0,'999250624111',0.51,0.51,0.21,5.48,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','16:13:42'),(175,1,'411',2,'6034000130553','i',6.60,'2025-06-24','16:13:51',1.00,1.45,6.60,'Fanmaxx Vanilla 330ML','YES','SS',0,0,'999250624211',0.14,0.14,0.05,1.45,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','16:13:51'),(176,1,'411',3,'8410128112905','i',5.71,'2025-06-24','16:13:56',1.00,1.25,5.71,'Pascual VANILLA 125gm','YES','SS',0,0,'999250624311',0.12,0.12,0.05,1.25,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','16:13:56'),(177,1,'411',3,'8410128112936','i',5.13,'2025-06-24','16:13:57',1.00,1.12,5.13,'Pasual Fruit Salad/macedonia Yogurt  125','YES','SS',0,0,'999250624311',0.11,0.11,0.04,1.12,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','16:13:57'),(178,1,'411',1,'2000000001','i',700.00,'2025-06-24','17:09:59',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250624111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','17:09:59'),(179,1,'411',1,'6002323007463','i',91.00,'2025-06-24','17:10:04',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250624111',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','17:10:04'),(180,1,'411',1,'2000000001','i',700.00,'2025-06-24','17:21:55',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250624111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','17:21:55'),(181,1,'411',2,'897076002003','i',375.90,'2025-06-24','17:22:02',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250624211',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-24','17:22:02'),(182,1,'411',1,'2000000001','i',700.00,'2025-06-27','05:22:06',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250627111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-27','05:22:06'),(183,1,'411',1,'2000000001','i',700.00,'2025-06-28','06:59:15',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250628111',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','06:59:15'),(184,1,'411',1,'897076002003','i',375.90,'2025-06-28','06:59:16',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250628111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','06:59:16'),(185,1,'411',1,'897076002003','i',375.90,'2025-06-28','08:43:00',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250628111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:00'),(186,1,'411',2,'2000000001','i',700.00,'2025-06-28','08:43:05',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250628211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:05'),(187,1,'411',3,'8410128112936','i',5.13,'2025-06-28','08:43:13',1.00,1.12,5.13,'Pasual Fruit Salad/macedonia Yogurt  125','YES','SS',0,0,'999250628311',0.11,0.11,0.04,1.12,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:13'),(188,1,'411',3,'8410128113100','i',11.00,'2025-06-28','08:43:14',1.00,2.41,11.00,'Pascual Creamy Strawberry 125gm','YES','SS',0,0,'999250628311',0.23,0.23,0.09,2.41,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:14'),(189,1,'411',3,'5413721000887','i',22.70,'2025-06-28','08:43:15',1.00,4.97,22.70,'Incolac Strawberry','YES','SS',0,0,'999250628311',0.47,0.47,0.19,4.97,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:15'),(190,1,'411',3,'5413721000894','i',28.00,'2025-06-28','08:43:15',1.00,6.13,28.00,'Incolac Banana','YES','SS',0,0,'999250628311',0.57,0.57,0.23,6.13,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:15'),(191,1,'411',4,'6002323007463','i',91.00,'2025-06-28','08:43:24',1.00,19.93,91.00,'PEARLY BAY SWEET WHITE 750ML','YES','SS',0,0,'999250628411',1.87,1.87,0.75,19.93,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:43:24'),(192,1,'411',1,'897076002003','i',375.90,'2025-06-28','08:47:20',1.00,82.32,375.90,'BULLDOG LONDON DRY GIN 750ML','YES','SS',0,0,'999250628111',7.71,7.71,3.08,82.32,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:20'),(193,1,'411',2,'2000000001','i',700.00,'2025-06-28','08:47:25',1.00,125.76,700.00,'OIL','YES','SS',0,0,'999250628211',14.36,14.36,5.74,153.30,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:25'),(194,1,'411',3,'5411188110835','i',45.40,'2025-06-28','08:47:32',1.00,9.94,45.40,'Alpro Soya Almond Drink 1Ltr','YES','SS',0,0,'999250628311',0.93,0.93,0.37,9.94,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:32'),(195,1,'411',3,'6034000130553','i',6.60,'2025-06-28','08:47:33',1.00,1.45,6.60,'Fanmaxx Vanilla 330ML','YES','SS',0,0,'999250628311',0.14,0.14,0.05,1.45,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:33'),(196,1,'411',3,'5413721000887','i',22.70,'2025-06-28','08:47:33',1.00,4.97,22.70,'Incolac Strawberry','YES','SS',0,0,'999250628311',0.47,0.47,0.19,4.97,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:33'),(197,1,'411',4,'5411188543381','i',48.40,'2025-06-28','08:47:37',1.00,10.60,48.40,'Alpro Soya Original Drink 1lt','YES','SS',0,0,'999250628411',0.99,0.99,0.40,10.60,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:37'),(198,1,'411',4,'5413721000894','i',28.00,'2025-06-28','08:47:38',1.00,6.13,28.00,'Incolac Banana','YES','SS',0,0,'999250628411',0.57,0.57,0.23,6.13,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:38'),(199,1,'411',4,'2000000002','i',15.00,'2025-06-28','08:47:38',1.00,2.69,15.00,'MILK ','YES','SS',0,0,'999250628411',0.31,0.31,0.12,3.29,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:38'),(200,1,'411',4,'8410128112905','i',5.71,'2025-06-28','08:47:39',1.00,1.25,5.71,'Pascual VANILLA 125gm','YES','SS',0,0,'999250628411',0.12,0.12,0.05,1.25,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:39'),(201,1,'411',4,'8410128113100','i',11.00,'2025-06-28','08:47:39',1.00,2.41,11.00,'Pascual Creamy Strawberry 125gm','YES','SS',0,0,'999250628411',0.23,0.23,0.09,2.41,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:39'),(202,1,'411',4,'6034000163735','i',5.42,'2025-06-28','08:47:40',1.00,1.19,5.42,'Namio Original 300ML','YES','SS',0,0,'999250628411',0.11,0.11,0.04,1.19,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:40'),(203,1,'411',4,'8410128112936','i',5.13,'2025-06-28','08:47:41',1.00,1.12,5.13,'Pasual Fruit Salad/macedonia Yogurt  125','YES','SS',0,0,'999250628411',0.11,0.11,0.04,1.12,'YES',1,0.00,0.00,0.00,NULL,'2025-06-28','08:47:41');
/*!40000 ALTER TABLE `history_trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inv_tran_hd`
--

DROP TABLE IF EXISTS `inv_tran_hd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_tran_hd` (
  `entry_no` char(10) NOT NULL,
  `from_loc` char(3) NOT NULL,
  `to_loc` char(3) NOT NULL,
  `total_cost` decimal(10,2) DEFAULT (0.00),
  `created_by` int NOT NULL,
  `created_date` date DEFAULT (curdate()),
  `created_time` time DEFAULT (curtime()),
  `is_sent` tinyint(1) DEFAULT (false),
  `delivered_by` char(20) DEFAULT NULL,
  `entry_date` date NOT NULL,
  `remarks` text NOT NULL,
  `pk` int NOT NULL AUTO_INCREMENT,
  `sent_by` char(60) DEFAULT NULL,
  `comment` text,
  `valid` tinyint(1) DEFAULT '1',
  `confirm` tinyint(1) DEFAULT '0',
  `is_posted` tinyint(1) DEFAULT '0',
  `send_approval` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`entry_no`),
  UNIQUE KEY `pk` (`pk`),
  KEY `created_by` (`created_by`),
  KEY `from_loc` (`from_loc`),
  KEY `to_loc` (`to_loc`),
  CONSTRAINT `inv_tran_hd_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `clerk` (`id`),
  CONSTRAINT `inv_tran_hd_ibfk_2` FOREIGN KEY (`from_loc`) REFERENCES `loc` (`loc_id`),
  CONSTRAINT `inv_tran_hd_ibfk_3` FOREIGN KEY (`to_loc`) REFERENCES `loc` (`loc_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_tran_hd`
--

LOCK TABLES `inv_tran_hd` WRITE;
/*!40000 ALTER TABLE `inv_tran_hd` DISABLE KEYS */;
INSERT INTO `inv_tran_hd` VALUES ('TR100001','001','999',147.47,1,'2025-03-26','15:03:25',0,NULL,'2025-03-26','dear child of god',14,NULL,NULL,1,1,1,0);
/*!40000 ALTER TABLE `inv_tran_hd` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `before_tran_hd` BEFORE INSERT ON `inv_tran_hd` FOR EACH ROW BEGIN
        declare new_entry_no char(10) default '';
        SET new_entry_no = CONCAT('TR',(SELECT nextno from doc_serial where doc='TR'));

        SET NEW.entry_no = new_entry_no;
    end */;;
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
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `after_tran_hd` AFTER INSERT ON `inv_tran_hd` FOR EACH ROW BEGIN
            UPDATE doc_serial set nextno = nextno + 1 where doc = 'TR';
        end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `inv_tran_rec_hd`
--

DROP TABLE IF EXISTS `inv_tran_rec_hd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_tran_rec_hd` (
  `pk` int NOT NULL AUTO_INCREMENT,
  `entry_no` char(10) NOT NULL,
  `ref_entry` char(10) DEFAULT NULL,
  `from_loc` char(3) NOT NULL,
  `to_loc` char(3) NOT NULL,
  `sent_cost` decimal(10,2) DEFAULT (0.00),
  `rec_cost` decimal(10,2) DEFAULT (0.00),
  `sent_by` char(10) DEFAULT NULL,
  `rec_by` char(10) DEFAULT NULL,
  `rec_date` date DEFAULT (curdate()),
  `rec_time` time DEFAULT (curtime()),
  `is_posted` tinyint(1) DEFAULT (false),
  `carrier` char(60) NOT NULL,
  `remarks` text,
  `comment` text,
  `valid` tinyint(1) DEFAULT '1',
  `approved` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`entry_no`),
  UNIQUE KEY `pk` (`pk`),
  UNIQUE KEY `entry_no` (`entry_no`),
  UNIQUE KEY `ref_entry` (`ref_entry`),
  KEY `from_loc` (`from_loc`),
  KEY `to_loc` (`to_loc`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_tran_rec_hd`
--

LOCK TABLES `inv_tran_rec_hd` WRITE;
/*!40000 ALTER TABLE `inv_tran_rec_hd` DISABLE KEYS */;
/*!40000 ALTER TABLE `inv_tran_rec_hd` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `save_rec_hd` BEFORE INSERT ON `inv_tran_rec_hd` FOR EACH ROW BEGIN
        declare generated_entry_no char(10) DEFAULT '';
        declare new_location char(3) default NEW.from_loc;
        set generated_entry_no = CONCAT('TR',(SELECT doc_serial.nextno from doc_serial where doc = 'TR'));

        SET NEW.entry_no = generated_entry_no;


        IF (SELECT COUNT(*) from loc where loc_id = new_location) = 0 THen
            INSERT INTO loc (loc_id, loc_desc) values (NEW.from_loc,'Transfer Location');
        end if;
    end */;;
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
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `after_save_rec_hd` AFTER INSERT ON `inv_tran_rec_hd` FOR EACH ROW BEGIN
        UPDATE doc_serial set nextno = nextno + 1 where doc = 'TR';
        INSERT INTO doc_trans (doc_type, entry_no, trans_func, created_by)
        VALUES ('TR', NEW.entry_no, 'ADD', NEW.rec_by);


    end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `inv_tran_rec_tr`
--

DROP TABLE IF EXISTS `inv_tran_rec_tr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_tran_rec_tr` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` char(10) NOT NULL,
  `barcode` char(14) NOT NULL,
  `item_code` int NOT NULL,
  `pack_id` char(5) NOT NULL,
  `pack_qty` decimal(10,2) DEFAULT '0.00',
  `sent_qty` decimal(10,2) DEFAULT '0.00',
  `rec_qty` decimal(10,2) DEFAULT '0.00',
  `unit_cost` decimal(10,2) DEFAULT '0.00',
  `total_cost` decimal(10,2) DEFAULT '0.00',
  `avg_cost` decimal(10,2) DEFAULT '0.00',
  `expiry_date` date NOT NULL,
  `item_des` text,
  PRIMARY KEY (`id`),
  KEY `entry_no` (`entry_no`),
  KEY `barcode` (`barcode`),
  CONSTRAINT `inv_tran_rec_tr_ibfk_1` FOREIGN KEY (`entry_no`) REFERENCES `inv_tran_rec_hd` (`entry_no`),
  CONSTRAINT `inv_tran_rec_tr_ibfk_2` FOREIGN KEY (`barcode`) REFERENCES `prod_master` (`barcode`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_tran_rec_tr`
--

LOCK TABLES `inv_tran_rec_tr` WRITE;
/*!40000 ALTER TABLE `inv_tran_rec_tr` DISABLE KEYS */;
/*!40000 ALTER TABLE `inv_tran_rec_tr` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `on_inv_tran_rec_tr_save` BEFORE INSERT ON `inv_tran_rec_tr` FOR EACH ROW BEGIN

        end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `inv_tran_tr`
--

DROP TABLE IF EXISTS `inv_tran_tr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_tran_tr` (
  `entry_no` char(10) NOT NULL,
  `barcode` char(14) NOT NULL,
  `item_code` int NOT NULL,
  `pack_id` char(5) NOT NULL,
  `pack_qty` decimal(10,2) DEFAULT '0.00',
  `send_qty` decimal(10,2) DEFAULT '0.00',
  `unit_cost` decimal(10,2) DEFAULT '0.00',
  `total_cost` decimal(10,2) DEFAULT '0.00',
  `avg_cost` decimal(10,2) DEFAULT '0.00',
  `expiry_date` date NOT NULL,
  `prod_desc` text NOT NULL,
  `expiry` date DEFAULT (_utf8mb4'2099-12-12'),
  `rec_qty` decimal(10,2) DEFAULT '0.00',
  KEY `entry_no` (`entry_no`),
  KEY `item_code` (`item_code`),
  CONSTRAINT `inv_tran_tr_ibfk_1` FOREIGN KEY (`entry_no`) REFERENCES `inv_tran_hd` (`entry_no`),
  CONSTRAINT `inv_tran_tr_ibfk_2` FOREIGN KEY (`item_code`) REFERENCES `prod_master` (`item_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_tran_tr`
--

LOCK TABLES `inv_tran_tr` WRITE;
/*!40000 ALTER TABLE `inv_tran_tr` DISABLE KEYS */;
INSERT INTO `inv_tran_tr` VALUES ('TR100001','5411188543381',1000006736,'CTN',1.00,1.00,30.35,30.35,30.35,'2025-12-14','null','2099-12-12',1.00),('TR100001','5411188110835',1000006737,'CTN',1.00,1.00,36.96,36.96,36.96,'2025-12-15','null','2099-12-12',1.00),('TR100001','6002323007463',1000006741,'CTN',1.00,1.00,56.52,56.52,56.52,'2025-12-19','null','2099-12-12',1.00),('TR100001','6034000407396',1000006742,'CTN',1.00,1.00,23.64,23.64,23.64,'2025-12-20','null','2099-12-12',1.00);
/*!40000 ALTER TABLE `inv_tran_tr` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `after_tran_tr_save` AFTER INSERT ON `inv_tran_tr` FOR EACH ROW BEGIN


            update inv_tran_hd set total_cost = total_cost + NEW.total_cost where inv_tran_hd.entry_no = NEW.entry_no;
        end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `invoice_hd`
--

DROP TABLE IF EXISTS `invoice_hd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_hd` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` char(10) NOT NULL,
  `loc_id` char(3) NOT NULL,
  `customer` int NOT NULL,
  `remarks` text,
  `taxable` int NOT NULL DEFAULT '0',
  `net_amt` decimal(10,2) DEFAULT '0.00',
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `other_cost` decimal(10,2) DEFAULT '0.00',
  `gross_amt` decimal(10,2) DEFAULT '0.00',
  `date_created` date DEFAULT (curdate()),
  `time_created` time DEFAULT (curtime()),
  `created_by` int NOT NULL,
  `valid` int DEFAULT '1',
  `approved` int DEFAULT '0',
  `ref_type` text,
  `ref_no` text,
  `posted` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `invoice_hd_customers_customer_id_fk` (`customer`),
  KEY `invoice_hd_loc_loc_id_fk` (`loc_id`),
  CONSTRAINT `invoice_hd_customers_customer_id_fk` FOREIGN KEY (`customer`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `invoice_hd_loc_loc_id_fk` FOREIGN KEY (`loc_id`) REFERENCES `loc` (`loc_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_hd`
--

LOCK TABLES `invoice_hd` WRITE;
/*!40000 ALTER TABLE `invoice_hd` DISABLE KEYS */;
INSERT INTO `invoice_hd` VALUES (1,'INV100001','001',10012,'This a test sales',1,3500.00,0.00,50.00,3550.00,'2025-03-08','14:18:13',1,1,1,'direct','none',1),(2,'INV100002','001',10012,'this is a test pro',1,4500.00,0.00,0.00,4500.00,'2025-03-27','06:13:04',1,1,1,'proforma','PRO1000',1);
/*!40000 ALTER TABLE `invoice_hd` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `before_inv_hd` BEFORE INSERT ON `invoice_hd` FOR EACH ROW BEGIN
    -- set new entry num
    IF (select count(*) from doc_serial where doc = 'INV') > 0 THEN

        SET NEW.entry_no = (SELECT CONCAT(doc, nextno) from doc_serial where doc = 'INV');

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot generate document serial';

    end if;
end */;;
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
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `after_inv_hd` AFTER INSERT ON `invoice_hd` FOR EACH ROW BEGIN
    -- insert doc tran
    insert into doc_trans (doc_type, entry_no, trans_func, created_by)
    values ('INV', NEW.entry_no, 'ADD', (SELECT clerk_name from clerk where clerk.id = new.created_by));
    -- update doc serial
    update doc_serial set nextno = nextno + 1 where doc = 'INV';
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `invoice_tran`
--

DROP TABLE IF EXISTS `invoice_tran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_tran` (
  `entry_no` char(10) NOT NULL,
  `line_no` int NOT NULL,
  `barcode` char(255) NOT NULL,
  `item_desc` text NOT NULL,
  `packing` char(30) DEFAULT NULL,
  `pack_qty` decimal(10,2) NOT NULL,
  `tran_qty` decimal(10,2) DEFAULT '0.00',
  `unit_cost` decimal(10,2) NOT NULL,
  `net_cost` decimal(10,2) NOT NULL,
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `gross_amt` decimal(10,2) NOT NULL,
  `foc` decimal(10,2) DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_tran`
--

LOCK TABLES `invoice_tran` WRITE;
/*!40000 ALTER TABLE `invoice_tran` DISABLE KEYS */;
INSERT INTO `invoice_tran` VALUES ('INV100001',1,'2000000001','OIL','LIT',25.00,5.00,700.00,3500.00,0.00,3500.00,2.00),('INV100002',1,'6154000043513','MENTOS CHEWY DRAGEES','1 * 1 PCS',1.00,10.00,100.00,1000.00,0.00,1000.00,0.00),('INV100002',2,'6034000407396','NICHE INDULGENCE MIL','1 * 1 PCS',1.00,20.00,100.00,2000.00,0.00,2000.00,0.00),('INV100002',3,'6034000407099','NICHE INDULGENCE DAR','1 * 1 PCS',1.00,30.00,50.00,1500.00,0.00,1500.00,0.00);
/*!40000 ALTER TABLE `invoice_tran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_buttons`
--

DROP TABLE IF EXISTS `item_buttons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_buttons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `button_index` int DEFAULT NULL,
  `description` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=352 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_buttons`
--

LOCK TABLES `item_buttons` WRITE;
/*!40000 ALTER TABLE `item_buttons` DISABLE KEYS */;
INSERT INTO `item_buttons` VALUES (347,1344,'Beverage'),(348,1345,'Alcohol'),(349,1347,'Bakery'),(350,1350,'Chilled Food Counter'),(351,1352,'Tobacco Products');
/*!40000 ALTER TABLE `item_buttons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_group`
--

DROP TABLE IF EXISTS `item_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_group` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'group id',
  `group_name` char(255) NOT NULL,
  `date_created` date DEFAULT (curdate()),
  `time_added` time DEFAULT (curtime()),
  `owner` text NOT NULL COMMENT 'who created group',
  `grp_uni` char(255) DEFAULT NULL,
  `modified_by` text,
  `date_modified` date DEFAULT (curdate()),
  `time_modified` time DEFAULT (curtime()),
  `shrt_name` text,
  `tax_grp` int DEFAULT '0',
  `status` int DEFAULT (1),
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_name` (`group_name`),
  UNIQUE KEY `group_name_2` (`group_name`),
  UNIQUE KEY `item_group_grp_uni_uindex` (`grp_uni`)
) ENGINE=InnoDB AUTO_INCREMENT=1365 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_group`
--

LOCK TABLES `item_group` WRITE;
/*!40000 ALTER TABLE `item_group` DISABLE KEYS */;
INSERT INTO `item_group` VALUES (1344,'Beverage','2025-02-09','15:09:53','1','a1255f381e392c0751576fea6d1760c1',NULL,'2025-02-09','15:09:53',NULL,0,1),(1345,'Alcohol','2025-02-09','15:26:13','1','374441213f60e52d60fed0278e0872b5',NULL,'2025-02-09','15:26:13',NULL,0,1),(1346,'Biscuits Crackers & Cakes','2025-02-09','15:26:13','1','2b799eb39c7a8261595e338c408add18',NULL,'2025-02-09','15:26:13',NULL,0,1),(1347,'Bakery','2025-02-09','15:26:14','1','c07c35714963668a8ec1b8784f83d143',NULL,'2025-02-09','15:26:14',NULL,0,1),(1350,'Chilled Food Counter','2025-02-09','15:26:14','1','6a644f4639559e2b987e2826f7b03597',NULL,'2025-02-09','15:26:14',NULL,0,1),(1352,'Tobacco Products','2025-02-09','15:26:14','1','b6a6d13bf336435f6202e7c51d98d28d',NULL,'2025-02-09','15:26:14',NULL,0,1),(1354,'Chocolate & Confectionery','2025-02-09','15:26:14','1','f95ab997215955e21acd563471b688f4',NULL,'2025-02-09','15:26:14',NULL,0,1);
/*!40000 ALTER TABLE `item_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_group_sub`
--

DROP TABLE IF EXISTS `item_group_sub`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_group_sub` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent` int DEFAULT '0',
  `description` char(30) DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `owner` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_index` (`id`,`parent`),
  UNIQUE KEY `parent` (`parent`,`description`),
  KEY `route_with_parent` (`parent`),
  CONSTRAINT `route_with_parent` FOREIGN KEY (`parent`) REFERENCES `item_group` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_group_sub`
--

LOCK TABLES `item_group_sub` WRITE;
/*!40000 ALTER TABLE `item_group_sub` DISABLE KEYS */;
INSERT INTO `item_group_sub` VALUES (1,1344,'Soft Drink','2025-02-09 15:09:53','1'),(2,1345,'Spirits','2025-02-09 15:26:13','1'),(3,1346,'DISC CHOCOLATES &CANDIES','2025-02-09 15:26:13','1'),(4,1347,'DAIRY','2025-02-09 15:26:14','1'),(7,1350,'Olives & Antipasti','2025-02-09 15:26:14','1'),(9,1352,'Rolling Papers & filters','2025-02-09 15:26:14','1'),(11,1354,'Chocolates','2025-02-09 15:26:14','1'),(13,1347,'ICE CREAM &DESSERTS','2025-02-09 15:26:14','1');
/*!40000 ALTER TABLE `item_group_sub` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items_master`
--

DROP TABLE IF EXISTS `items_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items_master` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'unique id of each item',
  `barcode` text NOT NULL COMMENT 'barcode of item',
  `desc` text NOT NULL COMMENT 'item description',
  `cost` decimal(10,2) NOT NULL COMMENT 'cost price of the item from supplier',
  `retail` decimal(10,2) NOT NULL COMMENT 'how much is it sold for',
  `tax_grp` int NOT NULL DEFAULT '0' COMMENT 'id of tax this belongs oo',
  `item_grp` text NOT NULL,
  `item_uni` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items_master`
--

LOCK TABLES `items_master` WRITE;
/*!40000 ALTER TABLE `items_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `items_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ledger`
--

DROP TABLE IF EXISTS `ledger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ledger` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `transaction_type` enum('supplier','customer') NOT NULL,
  `entity_id` int NOT NULL,
  `ref_no` char(10) NOT NULL,
  `transaction_date` datetime NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int DEFAULT (1),
  `dr` decimal(10,2) DEFAULT (0.00),
  `cr` decimal(10,2) DEFAULT (0.00),
  PRIMARY KEY (`transaction_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `ledger_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `clerk` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ledger`
--

LOCK TABLES `ledger` WRITE;
/*!40000 ALTER TABLE `ledger` DISABLE KEYS */;
INSERT INTO `ledger` VALUES (24,'customer',10012,'PI1000','2025-02-09 00:00:00',-375.90,'Credit Purchase: PI1000','2025-02-13 06:56:03','2025-02-13 06:56:03',1,0.00,0.00),(25,'customer',10012,'payment','2024-10-14 00:40:57',100.00,'PAYMENT: cash, REMARK: This is a cash payment','2025-02-18 05:54:46','2025-02-18 05:54:46',1,0.00,0.00),(38,'supplier',9,'GR0001','2025-02-18 00:00:00',0.00,'REFERENCE TO GRN: GR0001','2025-02-27 05:45:55','2025-02-27 05:45:55',1,1000.00,0.00),(39,'supplier',5,'GR2','2025-03-08 00:00:00',0.00,'REFERENCE TO GRN: GR2','2025-03-08 14:01:10','2025-03-08 14:01:10',1,6000.00,0.00),(40,'customer',10012,'INV100001','2025-03-08 00:00:00',-3550.00,'REFERENCE TO INVOICE: INV100001','2025-03-08 14:19:22','2025-03-08 14:19:22',1,0.00,0.00),(41,'customer',10012,'payment','2024-10-14 00:40:57',3000.00,'PAYMENT: cheque, REMARK: kjhasfgh','2025-03-08 14:20:52','2025-03-08 14:20:52',1,0.00,0.00),(42,'customer',10012,'INV100002','2025-03-27 00:00:00',-4500.00,'REFERENCE TO INVOICE: INV100002','2025-03-27 06:13:24','2025-03-27 06:13:24',1,0.00,0.00);
/*!40000 ALTER TABLE `ledger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loc`
--

DROP TABLE IF EXISTS `loc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loc` (
  `id` int NOT NULL AUTO_INCREMENT,
  `loc_id` char(3) DEFAULT NULL,
  `loc_desc` text,
  `country` text COMMENT 'country',
  `city` text COMMENT 'city',
  `street` text COMMENT 'street',
  `post_box` text COMMENT 'post box',
  `email` text COMMENT 'email address',
  `phone` text COMMENT 'phone number',
  `server_address` char(15) DEFAULT '000.000.000.000',
  `api_end_point` char(65) DEFAULT 'http://address.com',
  `type` enum('retail','wh') DEFAULT NULL,
  `power` enum('slave','master') DEFAULT 'slave',
  `db_host` char(255) DEFAULT NULL,
  `db_user` char(255) DEFAULT NULL,
  `db_password` char(255) DEFAULT NULL,
  `db_name` char(255) DEFAULT NULL,
  `owner` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `loc_pk` (`loc_id`),
  KEY `owner` (`owner`),
  CONSTRAINT `loc_ibfk_1` FOREIGN KEY (`owner`) REFERENCES `clerk` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loc`
--

LOCK TABLES `loc` WRITE;
/*!40000 ALTER TABLE `loc` DISABLE KEYS */;
INSERT INTO `loc` VALUES (104,'001','Sales Outlet',NULL,NULL,NULL,NULL,NULL,NULL,'000.000.000.000','http://address.com',NULL,'slave',NULL,NULL,NULL,NULL,NULL),(105,'999','Storage',NULL,NULL,NULL,NULL,NULL,NULL,'000.000.000.000','http://address.com',NULL,'slave',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `loc` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `update_loc` AFTER UPDATE ON `loc` FOR EACH ROW begin
        if NEW.power = 'master'then
            update loc set power = 'slave' where loc_id != new.loc_id;
        end if;
    end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `log_cronjobs`
--

DROP TABLE IF EXISTS `log_cronjobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_cronjobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `job` text NOT NULL,
  `status_code` int NOT NULL,
  `message` text,
  `ref` char(10) DEFAULT NULL,
  `date_logged` date DEFAULT (curdate()),
  `time_logged` time DEFAULT (curtime()),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_cronjobs`
--

LOCK TABLES `log_cronjobs` WRITE;
/*!40000 ALTER TABLE `log_cronjobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_cronjobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_notification`
--

DROP TABLE IF EXISTS `log_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_notification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` enum('SYS','INV','UNK') DEFAULT (_utf8mb4'UKN'),
  `title` char(255) NOT NULL,
  `details` text,
  `is_read` tinyint(1) DEFAULT (false),
  `date_notified` date DEFAULT (curdate()),
  `time_notified` time DEFAULT (curtime()),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_notification`
--

LOCK TABLES `log_notification` WRITE;
/*!40000 ALTER TABLE `log_notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message` text,
  `date_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loy_customer`
--

DROP TABLE IF EXISTS `loy_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loy_customer` (
  `cust_code` int NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `email` char(60) DEFAULT NULL,
  `mobile` char(30) NOT NULL COMMENT 'customer mobile number',
  PRIMARY KEY (`cust_code`),
  UNIQUE KEY `loy_customer_pk` (`mobile`),
  UNIQUE KEY `loy_customer_pk2` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=100033 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Loyalty Customers';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loy_customer`
--

LOCK TABLES `loy_customer` WRITE;
/*!40000 ALTER TABLE `loy_customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `loy_customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loyalty_point_stmt`
--

DROP TABLE IF EXISTS `loyalty_point_stmt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loyalty_point_stmt` (
  `cust_code` int NOT NULL,
  `value` decimal(10,2) DEFAULT '0.00',
  `billRef` char(20) NOT NULL,
  UNIQUE KEY `loyalty_point_stmt_pk` (`billRef`),
  KEY `loyalty_point_stmt_loy_customer_cust_code_fk` (`cust_code`),
  CONSTRAINT `loyalty_point_stmt_loy_customer_cust_code_fk` FOREIGN KEY (`cust_code`) REFERENCES `loy_customer` (`cust_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Rable keeps loyalty points transactions for a customer';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loyalty_point_stmt`
--

LOCK TABLES `loyalty_point_stmt` WRITE;
/*!40000 ALTER TABLE `loyalty_point_stmt` DISABLE KEYS */;
/*!40000 ALTER TABLE `loyalty_point_stmt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loyalty_tran`
--

DROP TABLE IF EXISTS `loyalty_tran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loyalty_tran` (
  `cust_code` char(66) NOT NULL,
  `billRef` char(60) NOT NULL,
  `time_stamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `cust_name` text,
  `points_before` decimal(10,2) DEFAULT (0.00),
  `points_earned` decimal(10,2) DEFAULT (0.00),
  `current_points` decimal(10,2) DEFAULT ((`points_before` + `points_earned`)),
  PRIMARY KEY (`billRef`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loyalty_tran`
--

LOCK TABLES `loyalty_tran` WRITE;
/*!40000 ALTER TABLE `loyalty_tran` DISABLE KEYS */;
INSERT INTO `loyalty_tran` VALUES ('9000000001','001250404511','2025-04-18 07:54:17','Uyn Solomon',1200.00,0.00,1200.00),('9000000001','9992504041011','2025-04-19 13:20:21','Uyn Solomon',1200.00,700.00,1900.00),('9000000001','9992504041111','2025-04-19 18:32:58','Uyn Solomon',1200.00,1400.00,2600.00),('9000000001','9992504041211','2025-04-19 18:34:32','Uyn Solomon',1200.00,748.40,1948.40),('9000000001','9992504041311','2025-04-19 18:39:51','Uyn Solomon',1200.00,700.00,1900.00),('9000000001','9992504041411','2025-04-19 18:41:05','Uyn Solomon',1746.70,700.00,2446.70),('9000000001','9992504041511','2025-04-19 18:42:13','Uyn Solomon',2293.40,1075.90,3369.30),('9000000001','9992504041611','2025-04-19 18:46:32','Uyn Solomon',3133.68,700.00,3833.68),('9000000001','9992504041711','2025-04-19 18:47:48','Uyn Solomon',3680.38,1075.90,4756.28),('9000000002','9992504041811','2025-04-19 19:02:43','JAMES BOND',0.00,1075.90,1075.90),('9000000002','9992504041911','2025-04-19 19:05:28','JAMES BOND',840.28,1075.90,1916.18),('9000000001','9992504042011','2025-04-19 22:47:43','Uyn Solomon',4520.66,13300.00,17820.66),('9000000002','9992504042111','2025-04-19 23:33:37','JAMES BOND',1916.18,1261.53,3177.71),('9000000001','999250404611','2025-04-18 07:55:36','Uyn Solomon',1200.00,25.00,1225.00),('9000000001','999250404711','2025-04-19 13:14:07','Uyn Solomon',1200.00,25.00,1225.00),('9000000001','999250404811','2025-04-19 13:17:43','Uyn Solomon',1200.00,375.90,1575.90),('9000000001','999250404911','2025-04-19 13:19:29','Uyn Solomon',1200.00,700.00,1900.00);
/*!40000 ALTER TABLE `loyalty_tran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mech_setup`
--

DROP TABLE IF EXISTS `mech_setup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mech_setup` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mech_no` int NOT NULL,
  `descr` text,
  `mac_addr` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `mech_no` (`mech_no`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mech_setup`
--

LOCK TABLES `mech_setup` WRITE;
/*!40000 ALTER TABLE `mech_setup` DISABLE KEYS */;
INSERT INTO `mech_setup` VALUES (2,1,'POS ONE','none');
/*!40000 ALTER TABLE `mech_setup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `my_table`
--

DROP TABLE IF EXISTS `my_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `my_table` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `my_column` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `my_table`
--

LOCK TABLES `my_table` WRITE;
/*!40000 ALTER TABLE `my_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `my_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packaging`
--

DROP TABLE IF EXISTS `packaging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `packaging` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `desc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packaging`
--

LOCK TABLES `packaging` WRITE;
/*!40000 ALTER TABLE `packaging` DISABLE KEYS */;
INSERT INTO `packaging` VALUES (1,'2025-02-09 14:58:57','PCS'),(2,'2025-02-09 14:58:57','CTN'),(3,'2025-02-09 14:58:57','LIT'),(4,'2025-02-09 14:58:57','KG');
/*!40000 ALTER TABLE `packaging` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_hd`
--

DROP TABLE IF EXISTS `po_hd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `po_hd` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doc_no` char(13) DEFAULT NULL,
  `status` int DEFAULT '0',
  `location` char(3) NOT NULL,
  `suppler` char(13) NOT NULL,
  `type` char(13) NOT NULL,
  `remarks` text,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `owner` text,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `edited_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `edited_by` char(30) DEFAULT NULL,
  `approved_by` char(13) DEFAULT NULL,
  `approved_on` datetime DEFAULT NULL,
  `grn` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_hd`
--

LOCK TABLES `po_hd` WRITE;
/*!40000 ALTER TABLE `po_hd` DISABLE KEYS */;
INSERT INTO `po_hd` VALUES (1,'PO1',0,'001','SU105','direct','Purchase from CHANDLOK FZCO and delivered to Sales Outlet',0.00,'Admin','2025-02-18 05:55:37','2025-02-18 05:55:37',NULL,NULL,NULL,0),(2,'PO2',0,'001','SU105','direct','Purchase from CHANDLOK FZCO and delivered to Sales Outlet',0.00,'Admin','2025-02-18 05:55:41','2025-02-18 05:55:41',NULL,NULL,NULL,0),(3,'PO3',0,'001','SU105','direct','Purchase from CHANDLOK FZCO and delivered to Sales Outlet',0.00,'Admin','2025-02-18 05:55:44','2025-02-18 05:55:44',NULL,NULL,NULL,0),(4,'PO4',1,'001','SU105','direct','Purchase from CHANDLOK FZCO and delivered to Sales Outlet',1000.00,'Admin','2025-02-18 05:56:18','2025-02-18 05:56:18',NULL,'Admin','2025-02-18 05:56:19',1),(5,'PO5',1,'999','SU101','direct','Purchase from Ekaza and delivered to Storage',6000.00,'Admin','2025-03-08 13:57:40','2025-03-08 13:57:40',NULL,'Admin','2025-03-08 13:57:41',1);
/*!40000 ALTER TABLE `po_hd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_trans`
--

DROP TABLE IF EXISTS `po_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `po_trans` (
  `prefix` varchar(2) NOT NULL DEFAULT 'PO',
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `parent` char(13) DEFAULT NULL,
  `line` int NOT NULL DEFAULT '0',
  `item_code` char(13) DEFAULT NULL,
  `barcode` char(13) DEFAULT NULL,
  `item_description` text NOT NULL,
  `packing` text,
  `pack_desc` text,
  `pack_um` decimal(10,2) DEFAULT '0.00',
  `qty` decimal(10,2) DEFAULT '0.00',
  `cost` decimal(10,2) DEFAULT '0.00',
  `total_cost` decimal(10,2) DEFAULT '0.00',
  `date_added` date DEFAULT (curdate()),
  `owner` char(13) DEFAULT NULL,
  `status` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_trans`
--

LOCK TABLES `po_trans` WRITE;
/*!40000 ALTER TABLE `po_trans` DISABLE KEYS */;
INSERT INTO `po_trans` VALUES ('PO',1,'PO4',1,'1000006739','6221024240195','HARS\"18','7.00 * 1 CTN','CTN',1.00,10.00,100.00,1000.00,'2025-02-18','Admin',0),('PO',2,'PO5',1,'1000006754','2000000001','OIL','LIT','3',25.00,10.00,600.00,6000.00,'2025-03-08','Admin',0);
/*!40000 ALTER TABLE `po_trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `price_change`
--

DROP TABLE IF EXISTS `price_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `price_change` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_code` int NOT NULL,
  `price_type` text,
  `previous` decimal(10,2) NOT NULL,
  `current` decimal(10,2) NOT NULL,
  `changed_on` datetime DEFAULT (now()),
  `loc_id` char(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `price_change_with_product` (`item_code`),
  CONSTRAINT `price_change_with_product` FOREIGN KEY (`item_code`) REFERENCES `prod_master` (`item_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=584 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `price_change`
--

LOCK TABLES `price_change` WRITE;
/*!40000 ALTER TABLE `price_change` DISABLE KEYS */;
INSERT INTO `price_change` VALUES (533,1000006739,'c',26.42,100.00,'2025-02-18 06:19:59',NULL),(534,1000006739,'c',100.00,100.00,'2025-02-18 06:50:39',NULL),(535,1000006739,'c',100.00,100.00,'2025-02-18 06:53:35',NULL),(536,1000006739,'c',100.00,100.00,'2025-02-26 04:06:14',NULL),(537,1000006754,'r',700.00,700.00,'2025-03-08 13:45:59',NULL),(538,1000006733,NULL,25.00,27.50,'2025-03-08 13:53:21','001'),(539,1000006734,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(540,1000006735,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(541,1000006736,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(542,1000006737,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(543,1000006738,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(544,1000006739,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(545,1000006740,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(546,1000006741,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(547,1000006742,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(548,1000006743,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(549,1000006744,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(550,1000006745,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(551,1000006746,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(552,1000006747,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(553,1000006748,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(554,1000006749,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(555,1000006750,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(556,1000006751,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(557,1000006752,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(558,1000006753,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(559,1000006754,NULL,0.00,0.00,'2025-03-08 13:53:21','001'),(560,1000006755,'r',15.00,15.00,'2025-04-05 07:19:49',NULL),(561,1000006733,NULL,27.50,30.25,'2025-06-10 20:54:36','001'),(562,1000006734,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(563,1000006735,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(564,1000006736,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(565,1000006737,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(566,1000006738,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(567,1000006739,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(568,1000006740,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(569,1000006741,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(570,1000006742,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(571,1000006743,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(572,1000006744,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(573,1000006745,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(574,1000006746,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(575,1000006747,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(576,1000006748,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(577,1000006749,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(578,1000006750,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(579,1000006751,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(580,1000006752,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(581,1000006753,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(582,1000006754,NULL,0.00,0.00,'2025-06-10 20:54:36','001'),(583,1000006755,NULL,0.00,0.00,'2025-06-10 20:54:36','001');
/*!40000 ALTER TABLE `price_change` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `price_level`
--

DROP TABLE IF EXISTS `price_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `price_level` (
  `loc_id` char(3) NOT NULL,
  `item_code` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int NOT NULL,
  KEY `loc_id` (`loc_id`),
  KEY `item_code` (`item_code`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `price_level_ibfk_1` FOREIGN KEY (`loc_id`) REFERENCES `loc` (`loc_id`),
  CONSTRAINT `price_level_ibfk_2` FOREIGN KEY (`item_code`) REFERENCES `prod_master` (`item_code`),
  CONSTRAINT `price_level_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `clerk` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `price_level`
--

LOCK TABLES `price_level` WRITE;
/*!40000 ALTER TABLE `price_level` DISABLE KEYS */;
INSERT INTO `price_level` VALUES ('999',1000006733,25.00,'2025-02-09 15:11:23','2025-02-09 15:11:23',1),('001',1000006733,30.25,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006734,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006735,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006736,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006737,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006738,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006739,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006740,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006741,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006742,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006743,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006744,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006745,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006746,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006747,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006748,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006749,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006750,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006751,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006752,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006753,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006754,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1),('001',1000006755,0.00,'2025-06-10 20:54:36','2025-06-10 20:54:36',1);
/*!40000 ALTER TABLE `price_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prod_disc`
--

DROP TABLE IF EXISTS `prod_disc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_disc` (
  `id` int NOT NULL AUTO_INCREMENT,
  `prod_code` text NOT NULL,
  `rate` decimal(10,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prod_disc`
--

LOCK TABLES `prod_disc` WRITE;
/*!40000 ALTER TABLE `prod_disc` DISABLE KEYS */;
/*!40000 ALTER TABLE `prod_disc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prod_expiry`
--

DROP TABLE IF EXISTS `prod_expiry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_expiry` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_code` char(10) NOT NULL,
  `expiry_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prod_expiry`
--

LOCK TABLES `prod_expiry` WRITE;
/*!40000 ALTER TABLE `prod_expiry` DISABLE KEYS */;
INSERT INTO `prod_expiry` VALUES (28,'1000006754','2025-03-28'),(29,'1000006755','2025-04-11');
/*!40000 ALTER TABLE `prod_expiry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prod_mast`
--

DROP TABLE IF EXISTS `prod_mast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_mast` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_grp` int NOT NULL,
  `item_uni` text DEFAULT (md5(`desc`)),
  `barcode` char(255) NOT NULL COMMENT 'barcode of item',
  `desc` text NOT NULL COMMENT 'item description',
  `cost` decimal(10,2) NOT NULL COMMENT 'cost price of the item from supplier',
  `retail` decimal(10,2) NOT NULL COMMENT 'how much is it sold for',
  `tax_grp` char(3) NOT NULL DEFAULT '0' COMMENT 'id of tax this belongs oo',
  `discount_rate` decimal(10,2) DEFAULT '0.00',
  `stock_type` int NOT NULL DEFAULT '1',
  `prev_retail` decimal(10,2) DEFAULT '0.00',
  `sub_grp` int DEFAULT NULL,
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `retail_wo_tax` decimal(10,2) DEFAULT '0.00',
  `discount` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `barcode` (`barcode`),
  KEY `stock_typ` (`stock_type`)
) ENGINE=InnoDB AUTO_INCREMENT=1000006756 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prod_mast`
--

LOCK TABLES `prod_mast` WRITE;
/*!40000 ALTER TABLE `prod_mast` DISABLE KEYS */;
INSERT INTO `prod_mast` VALUES (1000006733,1344,'fcea920f7412b5da7be0cf42b8c93759','1234567','Mango Juice',12.00,25.00,'YES',0.00,1,0.00,1,0.00,19.52,1),(1000006734,1345,'9795ae6255c2b08b0ed56cdfa7968979','897076002003','BULLDOG LONDON DRY GIN 750ML',232.96,375.90,'YES',0.00,0,0.00,2,82.32,293.58,0),(1000006735,1346,'86b4532ff647709bbfcab3e2532ccc73','6154000043513','MENTOS CHEWY DRAGEES 135G',0.28,0.50,'YES',0.00,0,0.00,3,0.11,0.39,0),(1000006736,1347,'32b49160fe78902a6de3bb4214e126c8','5411188543381','Alpro Soya Original Drink 1lt',30.35,48.40,'YES',0.00,0,0.00,4,10.60,37.80,0),(1000006737,1347,'d60c056a6a9a7618162b017e79c356f5','5411188110835','Alpro Soya Almond Drink 1Ltr',36.96,45.40,'YES',0.00,0,0.00,4,9.94,35.46,0),(1000006738,1347,'67c078a9e4df0c9958bae6355b3c9992','5411188543398','Alpro Soya Drink(Unsweetened) 1ltr',16.36,34.85,'YES',0.00,0,0.00,4,7.63,27.22,0),(1000006741,1352,'e76837180b384ff428ab921a6df0361e','6002323007463','PEARLY BAY SWEET WHITE 750ML',56.52,91.00,'YES',0.00,0,0.00,9,19.93,71.07,0),(1000006742,1346,'37bfde96b0983a22a0df7255b608ed44','6034000407396','NICHE INDULGENCE MILK CHO. 48%',23.64,31.70,'YES',0.00,0,0.00,3,6.94,24.76,0),(1000006743,1354,'3905face433215eab2bc2557c80ee7ce','6034000407198','NICH INDULGENCE MILK CHO. 44%',22.61,31.70,'YES',0.00,0,0.00,11,6.94,24.76,0),(1000006744,1346,'ebf1f845d8b25a6fa8866f5a4fbe1689','6034000407099','NICHE INDULGENCE DARK CHOCO.88%',25.22,35.60,'YES',0.00,0,0.00,3,7.80,27.80,0),(1000006745,1347,'78b575232e76a144f42db09c9d4661d4','6034000130690','FANICE VANILLA&STRAWBERRY 1L',28.52,45.90,'YES',0.00,0,0.00,13,10.05,35.85,0),(1000006746,1347,'0532443ff7a1317c6ab3c4aa2db789f6','6034000130553','Fanmaxx Vanilla 330ML',3.28,6.60,'YES',0.00,0,0.00,13,1.45,5.15,0),(1000006747,1347,'ab999de5557930085d3cc6f8eb47856f','6034000163735','Namio Original 300ML',2.35,5.42,'YES',0.00,0,0.00,4,1.19,4.23,0),(1000006748,1347,'d03ba53e5ee5fb63ed8275584d7696f1','5413721000894','Incolac Banana',17.02,28.00,'YES',0.00,0,0.00,4,6.13,21.87,0),(1000006749,1347,'c6f844c364b219cb1fc38dc3f18a4610','5413721000900','Incolac Chocolate',17.61,20.80,'YES',0.00,0,0.00,4,4.56,16.24,0),(1000006750,1347,'bf53373115ba29548f623eb719b8429a','5413721000887','Incolac Strawberry',16.73,22.70,'YES',0.00,0,0.00,4,4.97,17.73,0),(1000006751,1347,'6045c0a51bd038a907f93d35a3eced52','8410128112936','Pasual Fruit Salad/macedonia Yogurt  125',2.58,5.13,'YES',0.00,0,0.00,4,1.12,4.01,0),(1000006752,1347,'2e4c32f4f2511d3daff8040ae9ef6493','8410128113100','Pascual Creamy Strawberry 125gm',8.10,11.00,'YES',0.00,0,0.00,4,2.41,8.59,0),(1000006753,1347,'8c137532a03ababd1cab3f0db216e29a','8410128112905','Pascual VANILLA 125gm',2.83,5.71,'YES',0.00,0,0.00,4,1.25,4.46,0),(1000006754,1345,'a4cd02a1b5afdc66f9b97f01b0da6fad','2000000001','OIL',600.00,700.00,'YES',0.00,1,0.00,2,125.76,574.24,0),(1000006755,1347,'8403e50d57a9d01685b06ba50337b5d1','2000000002','MILK ',10.00,15.00,'YES',0.00,1,0.00,13,2.69,12.31,0);
/*!40000 ALTER TABLE `prod_mast` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prod_master`
--

DROP TABLE IF EXISTS `prod_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_master` (
  `item_code` int NOT NULL AUTO_INCREMENT,
  `item_uni` text DEFAULT (md5(`item_desc`)),
  `group` int NOT NULL,
  `sub_group` int NOT NULL,
  `supplier` text,
  `barcode` char(255) NOT NULL COMMENT 'barcode of item',
  `item_desc` text NOT NULL COMMENT 'item description',
  `cost` decimal(10,2) NOT NULL COMMENT 'cost price of the item from supplier',
  `retail` decimal(10,2) NOT NULL COMMENT 'how much is it sold for',
  `tax` char(3) NOT NULL DEFAULT '0' COMMENT 'tax status',
  `packing` char(3) DEFAULT NULL,
  `stock_type` int NOT NULL DEFAULT '0' COMMENT 'Stock Type',
  `special_price` int NOT NULL DEFAULT '0' COMMENT 'Special Price',
  `discount_rate` decimal(10,2) DEFAULT '0.00',
  `prev_retail` decimal(10,2) DEFAULT '0.00',
  `owner` varchar(200) DEFAULT 'master',
  `created_at` date DEFAULT (curdate()),
  `edited_at` date DEFAULT (curdate()),
  `edited_by` varchar(200) DEFAULT NULL,
  `download_flag` int DEFAULT (1),
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `retail_wo_tax` decimal(10,2) DEFAULT '0.00',
  `expiry_date` date DEFAULT (curdate()) COMMENT 'Expiry date of product',
  `image` text DEFAULT (_utf8mb4'default.png'),
  `discount` tinyint(1) DEFAULT '0',
  `item_desc1` char(20) DEFAULT NULL,
  PRIMARY KEY (`item_code`),
  UNIQUE KEY `barcode` (`barcode`)
) ENGINE=InnoDB AUTO_INCREMENT=1000006756 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prod_master`
--

LOCK TABLES `prod_master` WRITE;
/*!40000 ALTER TABLE `prod_master` DISABLE KEYS */;
INSERT INTO `prod_master` VALUES (1000006733,'fcea920f7412b5da7be0cf42b8c93759',1344,1,'SU101','1234567','Mango Juice',12.00,25.00,'YES','PCS',1,0,0.00,0.00,'1','2025-02-09','2025-02-09','Admin',0,0.00,19.52,'2025-12-12','1234567.png',1,'Mango Juice'),(1000006734,'9795ae6255c2b08b0ed56cdfa7968979',1345,2,'SU102','897076002003','BULLDOG LONDON DRY GIN 750ML',232.96,375.90,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,82.32,293.58,'2025-12-12','897076002003.png',0,'BULLDOG LONDON DRY G'),(1000006735,'86b4532ff647709bbfcab3e2532ccc73',1346,3,'SU103','6154000043513','MENTOS CHEWY DRAGEES 135G',0.28,0.50,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,0.11,0.39,'2025-12-13','6154000043513.png',0,'MENTOS CHEWY DRAGEES'),(1000006736,'32b49160fe78902a6de3bb4214e126c8',1347,4,'SU104','5411188543381','Alpro Soya Original Drink 1lt',30.35,48.40,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,10.60,37.80,'2025-12-14','5411188543381.jpg',0,'Alpro Soya Original'),(1000006737,'d60c056a6a9a7618162b017e79c356f5',1347,4,'SU104','5411188110835','Alpro Soya Almond Drink 1Ltr',36.96,45.40,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,9.94,35.46,'2025-12-15','5411188110835.webp',0,'Alpro Soya Almond Dr'),(1000006738,'67c078a9e4df0c9958bae6355b3c9992',1347,4,'SU104','5411188543398','Alpro Soya Drink(Unsweetened) 1ltr',16.36,34.85,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,7.63,27.22,'2025-12-16','5411188543398.jpg',0,'Alpro Soya Drink(Uns'),(1000006739,'9ed9e8ae1311dd0e97b780a3cef695d0',1350,7,'SU105','6221024240195','HARS\"18',100.00,74.00,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,16.21,57.79,'2025-12-17','default.png',0,'HARS\"18'),(1000006740,'41703b3e6087a9283ab7b8b8d2d98590',1350,7,'SU106','60012401000590','HARS\"18',26.21,74.00,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,16.21,57.79,'2025-12-18','default.png',0,'HARS\"18'),(1000006741,'e76837180b384ff428ab921a6df0361e',1352,9,'SU107','6002323007463','PEARLY BAY SWEET WHITE 750ML',56.52,91.00,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,19.93,71.07,'2025-12-19','6002323007463.jpg',0,'PEARLY BAY SWEET WHI'),(1000006742,'37bfde96b0983a22a0df7255b608ed44',1346,3,'SU108','6034000407396','NICHE INDULGENCE MILK CHO. 48%',23.64,31.70,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,6.94,24.76,'2025-12-20','6034000407396.jpeg',0,'NICHE INDULGENCE MIL'),(1000006743,'3905face433215eab2bc2557c80ee7ce',1354,11,'SU108','6034000407198','NICH INDULGENCE MILK CHO. 44%',22.61,31.70,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,6.94,24.76,'2025-12-21','6034000407198.jpeg',0,'NICH INDULGENCE MILK'),(1000006744,'ebf1f845d8b25a6fa8866f5a4fbe1689',1346,3,'SU108','6034000407099','NICHE INDULGENCE DARK CHOCO.88%',25.22,35.60,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,7.80,27.80,'2025-12-22','6034000407099.jpeg',0,'NICHE INDULGENCE DAR'),(1000006745,'78b575232e76a144f42db09c9d4661d4',1347,13,'SU109','6034000130690','FANICE VANILLA&STRAWBERRY 1L',28.52,45.90,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,10.05,35.85,'2025-12-23','6034000130690.png',0,'FANICE VANILLA&STRAW'),(1000006746,'0532443ff7a1317c6ab3c4aa2db789f6',1347,13,'SU109','6034000130553','Fanmaxx Vanilla 330ML',3.28,6.60,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,1.45,5.15,'2025-12-24','6034000130553.jpeg',0,'Fanmaxx Vanilla 330M'),(1000006747,'ab999de5557930085d3cc6f8eb47856f',1347,4,'SU110','6034000163735','Namio Original 300ML',2.35,5.42,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,1.19,4.23,'2025-12-25','6034000163735.jpg',0,'Namio Original 300ML'),(1000006748,'d03ba53e5ee5fb63ed8275584d7696f1',1347,4,'SU104','5413721000894','Incolac Banana',17.02,28.00,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,6.13,21.87,'2025-12-26','5413721000894.png',0,'Incolac Banana'),(1000006749,'c6f844c364b219cb1fc38dc3f18a4610',1347,4,'SU104','5413721000900','Incolac Chocolate',17.61,20.80,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,4.56,16.24,'2025-12-27','5413721000900.jpeg',0,'Incolac Chocolate'),(1000006750,'bf53373115ba29548f623eb719b8429a',1347,4,'SU104','5413721000887','Incolac Strawberry',16.73,22.70,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,4.97,17.73,'2025-12-28','5413721000887.jpg',0,'Incolac Strawberry'),(1000006751,'6045c0a51bd038a907f93d35a3eced52',1347,4,'SU104','8410128112936','Pasual Fruit Salad/macedonia Yogurt  125',2.58,5.13,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,1.12,4.01,'2025-12-29','8410128112936.webp',0,'Pasual Fruit Salad/m'),(1000006752,'2e4c32f4f2511d3daff8040ae9ef6493',1347,4,'SU104','8410128113100','Pascual Creamy Strawberry 125gm',8.10,11.00,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,2.41,8.59,'2025-12-30','8410128113100.jpg',0,'Pascual Creamy Straw'),(1000006753,'8c137532a03ababd1cab3f0db216e29a',1347,4,'SU104','8410128112905','Pascual VANILLA 125gm',2.83,5.71,'YES',NULL,0,0,0.00,0.00,'1','2025-02-09','2025-02-09',NULL,0,1.25,4.46,'2025-12-31','8410128112905.avif',0,'Pascual VANILLA 125g'),(1000006754,'a4cd02a1b5afdc66f9b97f01b0da6fad',1345,2,'SU101','2000000001','OIL',600.00,700.00,'YES','3',1,0,0.00,700.00,'Admin','2025-03-08','2025-03-08',NULL,0,125.76,574.24,'2025-03-28','2000000001.jpg',0,'OIL'),(1000006755,'8403e50d57a9d01685b06ba50337b5d1',1347,13,'SU101','2000000002','MILK ',10.00,15.00,'YES','2',1,0,0.00,15.00,'Admin','2025-04-05','2025-04-05',NULL,0,2.69,12.31,'2025-04-11','default.png',0,'MILK');
/*!40000 ALTER TABLE `prod_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prod_packing`
--

DROP TABLE IF EXISTS `prod_packing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_packing` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_code` char(10) NOT NULL,
  `pack_id` char(3) NOT NULL,
  `qty` decimal(10,2) NOT NULL,
  `purpose` int DEFAULT '1',
  `pack_desc` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5569 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prod_packing`
--

LOCK TABLES `prod_packing` WRITE;
/*!40000 ALTER TABLE `prod_packing` DISABLE KEYS */;
INSERT INTO `prod_packing` VALUES (5523,'1000006733','PCS',12.00,1,' 12.00 * 1 CTN'),(5524,'1000006733','PCS',1.00,2,' 1 * 1 PCS'),(5525,'1000006734','CTN',2.00,2,'2.00 * 1 CTN'),(5526,'1000006734','PCS',1.00,1,'1 * 1 PCS'),(5527,'1000006735','CTN',3.00,2,'3.00 * 1 CTN'),(5528,'1000006735','PCS',1.00,1,'1 * 1 PCS'),(5529,'1000006736','CTN',4.00,2,'4.00 * 1 CTN'),(5530,'1000006736','PCS',1.00,1,'1 * 1 PCS'),(5531,'1000006737','CTN',5.00,2,'5.00 * 1 CTN'),(5532,'1000006737','PCS',1.00,1,'1 * 1 PCS'),(5533,'1000006738','CTN',6.00,2,'6.00 * 1 CTN'),(5534,'1000006738','PCS',1.00,1,'1 * 1 PCS'),(5535,'1000006739','CTN',7.00,2,'7.00 * 1 CTN'),(5536,'1000006739','PCS',1.00,1,'1 * 1 PCS'),(5537,'1000006740','CTN',8.00,2,'8.00 * 1 CTN'),(5538,'1000006740','PCS',1.00,1,'1 * 1 PCS'),(5539,'1000006741','CTN',9.00,2,'9.00 * 1 CTN'),(5540,'1000006741','PCS',1.00,1,'1 * 1 PCS'),(5541,'1000006742','CTN',10.00,2,'10.00 * 1 CTN'),(5542,'1000006742','PCS',1.00,1,'1 * 1 PCS'),(5543,'1000006743','CTN',11.00,2,'11.00 * 1 CTN'),(5544,'1000006743','PCS',1.00,1,'1 * 1 PCS'),(5545,'1000006744','CTN',12.00,2,'12.00 * 1 CTN'),(5546,'1000006744','PCS',1.00,1,'1 * 1 PCS'),(5547,'1000006745','CTN',13.00,2,'13.00 * 1 CTN'),(5548,'1000006745','PCS',1.00,1,'1 * 1 PCS'),(5549,'1000006746','CTN',14.00,2,'14.00 * 1 CTN'),(5550,'1000006746','PCS',1.00,1,'1 * 1 PCS'),(5551,'1000006747','CTN',15.00,2,'15.00 * 1 CTN'),(5552,'1000006747','PCS',1.00,1,'1 * 1 PCS'),(5553,'1000006748','CTN',16.00,2,'16.00 * 1 CTN'),(5554,'1000006748','PCS',1.00,1,'1 * 1 PCS'),(5555,'1000006749','CTN',17.00,2,'17.00 * 1 CTN'),(5556,'1000006749','PCS',1.00,1,'1 * 1 PCS'),(5557,'1000006750','CTN',18.00,2,'18.00 * 1 CTN'),(5558,'1000006750','PCS',1.00,1,'1 * 1 PCS'),(5559,'1000006751','CTN',19.00,2,'19.00 * 1 CTN'),(5560,'1000006751','PCS',1.00,1,'1 * 1 PCS'),(5561,'1000006752','CTN',20.00,2,'20.00 * 1 CTN'),(5562,'1000006752','PCS',1.00,1,'1 * 1 PCS'),(5563,'1000006753','CTN',21.00,2,'21.00 * 1 CTN'),(5564,'1000006753','PCS',1.00,1,'1 * 1 PCS'),(5565,'1000006754','3',25.00,1,'LIT'),(5566,'1000006754','3',25.00,2,'LIT'),(5567,'1000006755','2',10.00,1,'CTN'),(5568,'1000006755','2',10.00,2,'CTN');
/*!40000 ALTER TABLE `prod_packing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prod_supplier`
--

DROP TABLE IF EXISTS `prod_supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_supplier` (
  `sp_id` int NOT NULL AUTO_INCREMENT,
  `item_code` int DEFAULT NULL,
  `supplier_code` text,
  `level` int DEFAULT '0',
  PRIMARY KEY (`sp_id`),
  KEY `prod_supplier_prod` (`item_code`),
  CONSTRAINT `prod_supplier_prod` FOREIGN KEY (`item_code`) REFERENCES `prod_master` (`item_code`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Suppliers for each product';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prod_supplier`
--

LOCK TABLES `prod_supplier` WRITE;
/*!40000 ALTER TABLE `prod_supplier` DISABLE KEYS */;
/*!40000 ALTER TABLE `prod_supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prof_hd`
--

DROP TABLE IF EXISTS `prof_hd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prof_hd` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` char(10) NOT NULL,
  `loc_id` char(3) NOT NULL,
  `customer` int NOT NULL,
  `remarks` text,
  `taxable` int NOT NULL DEFAULT '0',
  `iss_date` date NOT NULL,
  `due_date` date NOT NULL,
  `net_amt` decimal(10,2) DEFAULT '0.00',
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `other_cost` decimal(10,2) DEFAULT '0.00',
  `gross_amt` decimal(10,2) DEFAULT '0.00',
  `date_created` date DEFAULT (curdate()),
  `time_created` time DEFAULT (curtime()),
  `created_by` int NOT NULL,
  `valid` int DEFAULT '1',
  `approved` int DEFAULT '0',
  `posted` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `prof_hd_customers_customer_id_fk` (`customer`),
  KEY `prof_hd_clerk_id_fk` (`created_by`),
  CONSTRAINT `prof_hd_clerk_id_fk` FOREIGN KEY (`created_by`) REFERENCES `clerk` (`id`),
  CONSTRAINT `prof_hd_customers_customer_id_fk` FOREIGN KEY (`customer`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prof_hd`
--

LOCK TABLES `prof_hd` WRITE;
/*!40000 ALTER TABLE `prof_hd` DISABLE KEYS */;
INSERT INTO `prof_hd` VALUES (1,'PRO1000','001',10012,'this is a test pro',1,'2025-03-27','2025-03-28',4500.00,0.00,0.00,4500.00,'2025-03-27','06:10:45',1,1,1,1);
/*!40000 ALTER TABLE `prof_hd` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `before_prof_hd` BEFORE INSERT ON `prof_hd` FOR EACH ROW BEGIN
    -- set new entry num
    IF (select count(*) from doc_serial where doc = 'PRO') > 0 THEN

        SET NEW.entry_no = (SELECT CONCAT(doc, nextno) from doc_serial where doc = 'PRO');

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot generate document serial';

    end if;
end */;;
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
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `after_prof_hd` AFTER INSERT ON `prof_hd` FOR EACH ROW BEGIN
    -- insert doc tran
    insert into doc_trans (doc_type, entry_no, trans_func, created_by)
    values ('PRO', NEW.entry_no, 'ADD', (SELECT clerk_name from clerk where clerk.id = new.created_by));
    -- update doc serila
    update doc_serial set nextno = nextno + 1 where doc = 'PRO';
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `prof_tran`
--

DROP TABLE IF EXISTS `prof_tran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prof_tran` (
  `entry_no` char(10) NOT NULL,
  `line_no` int NOT NULL,
  `barcode` char(255) NOT NULL,
  `item_desc` text NOT NULL,
  `packing` char(20) DEFAULT NULL,
  `pack_qty` decimal(10,2) NOT NULL,
  `tran_qty` decimal(10,2) DEFAULT '0.00',
  `unit_cost` decimal(10,2) NOT NULL,
  `net_cost` decimal(10,2) NOT NULL,
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `gross_amt` decimal(10,2) NOT NULL,
  `foc` decimal(10,2) DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prof_tran`
--

LOCK TABLES `prof_tran` WRITE;
/*!40000 ALTER TABLE `prof_tran` DISABLE KEYS */;
INSERT INTO `prof_tran` VALUES ('PRO1000',1,'6154000043513','MENTOS CHEWY DRAGEES','1 * 1 PCS',1.00,10.00,100.00,1000.00,0.00,1000.00,0.00),('PRO1000',2,'6034000407396','NICHE INDULGENCE MIL','1 * 1 PCS',1.00,20.00,100.00,2000.00,0.00,2000.00,0.00),('PRO1000',3,'6034000407099','NICHE INDULGENCE DAR','1 * 1 PCS',1.00,30.00,50.00,1500.00,0.00,1500.00,0.00);
/*!40000 ALTER TABLE `prof_tran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refund`
--

DROP TABLE IF EXISTS `refund`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refund` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bill_number` int DEFAULT NULL,
  `amount_refund` decimal(50,2) DEFAULT NULL,
  `receptionist` text,
  `date` date DEFAULT (curdate()),
  `reason` text,
  `customer` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refund`
--

LOCK TABLES `refund` WRITE;
/*!40000 ALTER TABLE `refund` DISABLE KEYS */;
/*!40000 ALTER TABLE `refund` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `value` double(6,2) DEFAULT NULL,
  `stage` text,
  `day` text,
  `month` text,
  `year` text,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_hd`
--

DROP TABLE IF EXISTS `sales_hd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_hd` (
  `sales_date` date NOT NULL,
  `gross` decimal(10,0) DEFAULT (0.00),
  `tax` decimal(10,0) DEFAULT (0.00),
  `net` decimal(10,0) DEFAULT (0.00),
  `posted` int DEFAULT (0),
  `check_customer` int DEFAULT '0',
  `shitf` int NOT NULL,
  `entry_no` char(10) NOT NULL,
  `sync` tinyint(1) DEFAULT '0',
  `loc_id` char(3) DEFAULT NULL,
  UNIQUE KEY `entry_no` (`entry_no`),
  UNIQUE KEY `sales_hd_pk` (`loc_id`,`sales_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_hd`
--

LOCK TABLES `sales_hd` WRITE;
/*!40000 ALTER TABLE `sales_hd` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_hd` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `sales_hd_save` BEFORE INSERT ON `sales_hd` FOR EACH ROW BEGIN
        -- set entry no
        declare new_ent_no char(10) default '';
        set new_ent_no = CONCAT('PI',(SELECT nextno from doc_serial where doc  = 'PI'));

        if length(NEW.entry_no) > 0 then
            SET new.entry_no = new_ent_no;
        end if;

    end */;;
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
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `sales_hd_after` AFTER INSERT ON `sales_hd` FOR EACH ROW begin
        -- update serial x
#         if length(NEW.entry_no) > 0 then 
#             UPDATE doc_serial set nextno = nextno + 1 where doc = 'PI';
#         end if;
        
    end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sales_tran`
--

DROP TABLE IF EXISTS `sales_tran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_tran` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mach` int NOT NULL,
  `shift` int NOT NULL,
  `barcode` char(30) NOT NULL,
  `item_desc` text NOT NULL,
  `un_cost` decimal(10,2) DEFAULT (0.00),
  `un_retail` decimal(10,2) DEFAULT (0.00),
  `sold_qty` decimal(10,2) DEFAULT (0.00),
  `total_cost` decimal(10,2) DEFAULT (0.00),
  `total_sold` decimal(10,2) DEFAULT (0.00),
  `total_tax` decimal(10,2) DEFAULT (0.00),
  `bill_date` date DEFAULT (curdate()),
  `bill_no` int DEFAULT (0),
  `check_customer` int DEFAULT '0',
  `shitf` int NOT NULL,
  `entry_no` char(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_tran`
--

LOCK TABLES `sales_tran` WRITE;
/*!40000 ALTER TABLE `sales_tran` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_tran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `screens`
--

DROP TABLE IF EXISTS `screens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screens` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `module` varchar(45) DEFAULT NULL,
  `sub_module` varchar(45) DEFAULT NULL,
  `created_on` date DEFAULT (curdate()),
  `scr_uni` varchar(50) DEFAULT (md5(concat(`created_on`,`module`))),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `screens`
--

LOCK TABLES `screens` WRITE;
/*!40000 ALTER TABLE `screens` DISABLE KEYS */;
/*!40000 ALTER TABLE `screens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shifts`
--

DROP TABLE IF EXISTS `shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shifts` (
  `recId` int NOT NULL AUTO_INCREMENT,
  `shift_no` int NOT NULL,
  `clerk` text,
  `mech_no` int NOT NULL,
  `shift_date` date DEFAULT (curdate()),
  `endate` date DEFAULT NULL,
  `start_time` time DEFAULT (curtime()),
  `end_time` time DEFAULT (NULL),
  `enc` char(255) NOT NULL,
  `pending_eod` int DEFAULT '0',
  PRIMARY KEY (`recId`),
  UNIQUE KEY `recId` (`recId`),
  UNIQUE KEY `enc` (`enc`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shifts`
--

LOCK TABLES `shifts` WRITE;
/*!40000 ALTER TABLE `shifts` DISABLE KEYS */;
INSERT INTO `shifts` VALUES (34,1,'411',1,'2025-06-28',NULL,'12:05:32',NULL,'d823a043560dffdc3e28d35f6599d8a7',0);
/*!40000 ALTER TABLE `shifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sms_ques`
--

DROP TABLE IF EXISTS `sms_ques`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sms_ques` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message` text NOT NULL,
  `recipient` char(10) NOT NULL,
  `status` tinyint(1) DEFAULT '0',
  `response` text,
  `date_qued` timestamp NULL DEFAULT (curdate()),
  `last_tried` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sms_ques`
--

LOCK TABLES `sms_ques` WRITE;
/*!40000 ALTER TABLE `sms_ques` DISABLE KEYS */;
/*!40000 ALTER TABLE `sms_ques` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stk_tran`
--

DROP TABLE IF EXISTS `stk_tran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stk_tran` (
  `entry_no` char(12) NOT NULL,
  `doc` char(3) NOT NULL,
  `item_code` int NOT NULL,
  `loc_id` char(3) NOT NULL,
  `pack_desc` text NOT NULL,
  `pack_un` decimal(10,2) NOT NULL,
  `tran_qty` decimal(10,2) NOT NULL DEFAULT '0.00',
  `date_created` date NOT NULL DEFAULT (curdate()),
  `time_created` time NOT NULL DEFAULT (curtime()),
  `unit_qty` decimal(10,2) DEFAULT (0.00),
  KEY `stk_check_prod_mast_id_fk` (`item_code`),
  CONSTRAINT `stk_check_prod_mast_id_fk` FOREIGN KEY (`item_code`) REFERENCES `prod_master` (`item_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stk_tran`
--

LOCK TABLES `stk_tran` WRITE;
/*!40000 ALTER TABLE `stk_tran` DISABLE KEYS */;
INSERT INTO `stk_tran` VALUES ('SS2025-02-09','SS',1000006733,'001','PCS',1.00,-1.00,'2025-02-13','06:56:02',-1.00),('SS2025-02-09','SS',1000006733,'001','PCS',1.00,-3.00,'2025-02-13','06:56:02',-3.00),('SS2025-02-09','SS',1000006734,'001','PCS',1.00,-4.00,'2025-02-13','06:56:02',-4.00),('SS2025-02-09','SS',1000006734,'001','PCS',1.00,-4.00,'2025-02-13','06:56:02',-4.00),('SS2025-02-09','SS',1000006736,'001','PCS',1.00,-1.00,'2025-02-13','06:56:02',-1.00),('SS2025-02-09','SS',1000006737,'001','PCS',1.00,-4.00,'2025-02-13','06:56:02',-4.00),('SS2025-02-09','SS',1000006738,'001','PCS',1.00,-2.00,'2025-02-13','06:56:02',-2.00),('SS2025-02-09','SS',1000006741,'001','PCS',1.00,-1.00,'2025-02-13','06:56:03',-1.00),('SS2025-02-09','SS',1000006741,'001','PCS',1.00,-1.00,'2025-02-13','06:56:03',-1.00),('SS2025-02-09','SS',1000006746,'001','PCS',1.00,-1.00,'2025-02-13','06:56:03',-1.00),('SS2025-02-09','SS',1000006747,'001','PCS',1.00,-2.00,'2025-02-13','06:56:03',-2.00),('SS2025-02-09','SS',1000006748,'001','PCS',1.00,-1.00,'2025-02-13','06:56:03',-1.00),('SS2025-02-09','SS',1000006750,'001','PCS',1.00,-1.00,'2025-02-13','06:56:03',-1.00),('SS2025-02-09','SS',1000006751,'001','PCS',1.00,-1.00,'2025-02-13','06:56:03',-1.00),('GR0001','GR',1000006739,'001','CTN',1.00,10.00,'2025-02-18','05:45:55',10.00),('GR2','GR',1000006754,'999','3',25.00,10.00,'2025-03-08','14:01:10',250.00),('AD0011','AD',1000006739,'001','PCS',1.00,-5.00,'2025-03-08','14:10:39',-5.00),('AD0011','AD',1000006744,'001','PCS',1.00,10.00,'2025-03-08','14:10:39',10.00),('AD0011','AD',1000006754,'001','PCS',1.00,47.00,'2025-03-08','14:10:39',47.00),('AD0011','AD',1000006753,'001','PCS',1.00,53.00,'2025-03-08','14:10:39',53.00),('AD0011','AD',1000006752,'001','PCS',1.00,73.00,'2025-03-08','14:10:39',73.00),('AD0011','AD',1000006749,'001','PCS',1.00,84.00,'2025-03-08','14:10:39',84.00),('AD0011','AD',1000006745,'001','PCS',1.00,64.00,'2025-03-08','14:10:39',64.00),('AD0011','AD',1000006743,'001','PCS',1.00,84.00,'2025-03-08','14:10:39',84.00),('AD0011','AD',1000006742,'001','PCS',1.00,63.00,'2025-03-08','14:10:39',63.00),('AD0011','AD',1000006740,'001','PCS',1.00,95.00,'2025-03-08','14:10:39',95.00),('AD0011','AD',1000006735,'001','PCS',1.00,74.00,'2025-03-08','14:10:39',74.00),('AD0011','AD',1000006746,'001','PCS',1.00,65.00,'2025-03-08','14:10:39',65.00),('AD0011','AD',1000006748,'001','PCS',1.00,5.00,'2025-03-08','14:10:39',5.00),('AD0011','AD',1000006750,'001','PCS',1.00,76.00,'2025-03-08','14:10:39',76.00),('AD0011','AD',1000006751,'001','PCS',1.00,74.00,'2025-03-08','14:10:39',74.00),('AD0011','AD',1000006736,'001','PCS',1.00,26.00,'2025-03-08','14:10:40',26.00),('AD0011','AD',1000006741,'001','PCS',1.00,75.00,'2025-03-08','14:10:40',75.00),('AD0011','AD',1000006738,'001','PCS',1.00,27.00,'2025-03-08','14:10:40',27.00),('AD0011','AD',1000006747,'001','PCS',1.00,86.00,'2025-03-08','14:10:40',86.00),('AD0011','AD',1000006733,'001','PCS',1.00,77.00,'2025-03-08','14:10:40',77.00),('AD0011','AD',1000006737,'001','PCS',1.00,77.00,'2025-03-08','14:10:40',77.00),('AD0011','AD',1000006734,'001','PCS',1.00,81.00,'2025-03-08','14:10:40',81.00),('INV100001','INV',1000006754,'001','LIT',25.00,-5.00,'2025-03-08','14:19:22',-125.00),('INV100001','INV',1000006754,'001','FOC (PCS)',1.00,-2.00,'2025-03-08','14:19:22',-2.00),('TR100001','TF',1000006736,'001','CTN',1.00,-1.00,'2025-03-26','15:03:35',-1.00),('TR100001','TF',1000006737,'001','CTN',1.00,-1.00,'2025-03-26','15:03:35',-1.00),('TR100001','TF',1000006741,'001','CTN',1.00,-1.00,'2025-03-26','15:03:35',-1.00),('TR100001','TF',1000006742,'001','CTN',1.00,-1.00,'2025-03-26','15:03:35',-1.00),('INV100002','INV',1000006735,'001','1 * 1 PCS',1.00,-10.00,'2025-03-27','06:13:24',-10.00),('INV100002','INV',1000006742,'001','1 * 1 PCS',1.00,-20.00,'2025-03-27','06:13:24',-20.00),('INV100002','INV',1000006744,'001','1 * 1 PCS',1.00,-30.00,'2025-03-27','06:13:24',-30.00);
/*!40000 ALTER TABLE `stk_tran` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `stk_tran_before_save` BEFORE INSERT ON `stk_tran` FOR EACH ROW BEGIN
            SET NEW.unit_qty = NEW.pack_un * NEW.tran_qty;
        end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `stock`
--

DROP TABLE IF EXISTS `stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_code` char(10) NOT NULL,
  `loc_id` char(3) NOT NULL,
  `qty` decimal(14,2) NOT NULL,
  `ob_qty` decimal(14,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock`
--

LOCK TABLES `stock` WRITE;
/*!40000 ALTER TABLE `stock` DISABLE KEYS */;
INSERT INTO `stock` VALUES (40,'1000006739','001',10.00,NULL),(41,'1000006739','001',10.00,NULL),(42,'1000006739','001',10.00,NULL),(43,'1000006739','001',10.00,NULL);
/*!40000 ALTER TABLE `stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_count_hd`
--

DROP TABLE IF EXISTS `stock_count_hd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_count_hd` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` char(10) NOT NULL,
  `ref_no` char(10) NOT NULL,
  `loc_id` char(3) NOT NULL,
  `entry_date` date NOT NULL,
  `remarks` text,
  `created_by` int NOT NULL,
  `date_created` date NOT NULL DEFAULT (curdate()),
  `approved` tinyint(1) DEFAULT '0',
  `posted` tinyint(1) DEFAULT '0',
  `status` tinyint(1) DEFAULT '1',
  `post_no` char(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `entry_no_UNIQUE` (`entry_no`),
  KEY `entry_with_frozen` (`ref_no`),
  CONSTRAINT `entry_with_frozen` FOREIGN KEY (`ref_no`) REFERENCES `stock_freeze_hd` (`entry_no`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_count_hd`
--

LOCK TABLES `stock_count_hd` WRITE;
/*!40000 ALTER TABLE `stock_count_hd` DISABLE KEYS */;
INSERT INTO `stock_count_hd` VALUES (9,'SC0011','SF0011','001','2025-03-08','Hello tes',1,'2025-03-08',1,1,1,'AD0011');
/*!40000 ALTER TABLE `stock_count_hd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_count_tran`
--

DROP TABLE IF EXISTS `stock_count_tran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_count_tran` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` char(10) NOT NULL,
  `line` int NOT NULL,
  `barcode` varchar(45) NOT NULL,
  `item_des` varchar(45) NOT NULL,
  `frozen` decimal(10,2) DEFAULT '0.00',
  `counted` decimal(10,2) DEFAULT '0.00',
  `unit_price` decimal(10,2) DEFAULT '0.00',
  `qty_diff` decimal(10,2) DEFAULT '0.00',
  `val_diff` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `entry_with_hd` (`entry_no`),
  CONSTRAINT `entry_with_hd` FOREIGN KEY (`entry_no`) REFERENCES `stock_count_hd` (`entry_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1847 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_count_tran`
--

LOCK TABLES `stock_count_tran` WRITE;
/*!40000 ALTER TABLE `stock_count_tran` DISABLE KEYS */;
INSERT INTO `stock_count_tran` VALUES (1825,'SC0011',1,'6221024240195','HARS\"18',10.00,5.00,74.00,-5.00,-370.00),(1826,'SC0011',2,'6034000407099','NICHE INDULGENCE DARK CHOCO.88%',0.00,10.00,35.60,10.00,356.00),(1827,'SC0011',3,'2000000001','OIL',0.00,47.00,700.00,47.00,32900.00),(1828,'SC0011',4,'8410128112905','Pascual VANILLA 125gm',0.00,53.00,5.71,53.00,302.63),(1829,'SC0011',5,'8410128113100','Pascual Creamy Strawberry 125gm',0.00,73.00,11.00,73.00,803.00),(1830,'SC0011',6,'5413721000900','Incolac Chocolate',0.00,84.00,20.80,84.00,1747.20),(1831,'SC0011',7,'6034000130690','FANICE VANILLA&STRAWBERRY 1L',0.00,64.00,45.90,64.00,2937.60),(1832,'SC0011',8,'6034000407198','NICH INDULGENCE MILK CHO. 44%',0.00,84.00,31.70,84.00,2662.80),(1833,'SC0011',9,'6034000407396','NICHE INDULGENCE MILK CHO. 48%',0.00,63.00,31.70,63.00,1997.10),(1834,'SC0011',10,'60012401000590','HARS\"18',0.00,95.00,74.00,95.00,7030.00),(1835,'SC0011',11,'6154000043513','MENTOS CHEWY DRAGEES 135G',0.00,74.00,0.50,74.00,37.00),(1836,'SC0011',12,'6034000130553','Fanmaxx Vanilla 330ML',-1.00,64.00,6.60,65.00,429.00),(1837,'SC0011',13,'5413721000894','Incolac Banana',-1.00,4.00,28.00,5.00,140.00),(1838,'SC0011',14,'5413721000887','Incolac Strawberry',-1.00,75.00,22.70,76.00,1725.20),(1839,'SC0011',15,'8410128112936','Pasual Fruit Salad/macedonia Yogurt  125',-1.00,73.00,5.13,74.00,379.62),(1840,'SC0011',16,'5411188543381','Alpro Soya Original Drink 1lt',-1.00,25.00,48.40,26.00,1258.40),(1841,'SC0011',17,'6002323007463','PEARLY BAY SWEET WHITE 750ML',-2.00,73.00,91.00,75.00,6825.00),(1842,'SC0011',18,'5411188543398','Alpro Soya Drink(Unsweetened) 1ltr',-2.00,25.00,34.85,27.00,940.95),(1843,'SC0011',19,'6034000163735','Namio Original 300ML',-2.00,84.00,5.42,86.00,466.12),(1844,'SC0011',20,'1234567','Mango Juice',-4.00,73.00,25.00,77.00,1925.00),(1845,'SC0011',21,'5411188110835','Alpro Soya Almond Drink 1Ltr',-4.00,73.00,45.40,77.00,3495.80),(1846,'SC0011',22,'897076002003','BULLDOG LONDON DRY GIN 750ML',-8.00,73.00,375.90,81.00,30447.90);
/*!40000 ALTER TABLE `stock_count_tran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_freeze_hd`
--

DROP TABLE IF EXISTS `stock_freeze_hd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_freeze_hd` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` char(10) NOT NULL,
  `loc_id` char(3) NOT NULL,
  `entry_date` date NOT NULL,
  `remarks` text,
  `created_by` int NOT NULL,
  `date_created` date NOT NULL DEFAULT (curdate()),
  `approved` tinyint(1) DEFAULT '0',
  `posted` tinyint(1) DEFAULT '0',
  `stock_count_entry` char(10) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `entry_no_UNIQUE` (`entry_no`),
  KEY `loc_id_idx` (`loc_id`),
  CONSTRAINT `loc_id` FOREIGN KEY (`loc_id`) REFERENCES `loc` (`loc_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='This table keeps the header of all froozen stock';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_freeze_hd`
--

LOCK TABLES `stock_freeze_hd` WRITE;
/*!40000 ALTER TABLE `stock_freeze_hd` DISABLE KEYS */;
INSERT INTO `stock_freeze_hd` VALUES (13,'SF0011','001','2025-03-08','Hello tes',1,'2025-03-08',1,1,'SC0011',1);
/*!40000 ALTER TABLE `stock_freeze_hd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_freeze_tran`
--

DROP TABLE IF EXISTS `stock_freeze_tran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_freeze_tran` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` char(10) NOT NULL,
  `line` int NOT NULL,
  `barcode` varchar(45) NOT NULL,
  `item_des` varchar(45) NOT NULL,
  `frozen_qty` decimal(10,2) DEFAULT '0.00',
  `unit_price` decimal(10,2) DEFAULT '0.00',
  `frozen_value` decimal(10,2) DEFAULT '0.00',
  `unit_cost` decimal(10,2) DEFAULT '0.00',
  `frozen_cost` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `entry_no_idx` (`entry_no`),
  CONSTRAINT `entry_no` FOREIGN KEY (`entry_no`) REFERENCES `stock_freeze_hd` (`entry_no`)
) ENGINE=InnoDB AUTO_INCREMENT=4951 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='transactions of all stock freeze';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_freeze_tran`
--

LOCK TABLES `stock_freeze_tran` WRITE;
/*!40000 ALTER TABLE `stock_freeze_tran` DISABLE KEYS */;
INSERT INTO `stock_freeze_tran` VALUES (4929,'SF0011',1,'6221024240195','HARS\"18',10.00,74.00,740.00,100.00,1000.00),(4930,'SF0011',2,'6034000407099','NICHE INDULGENCE DARK CHOCO.88%',0.00,35.60,0.00,25.22,0.00),(4931,'SF0011',3,'2000000001','OIL',0.00,700.00,0.00,600.00,0.00),(4932,'SF0011',4,'8410128112905','Pascual VANILLA 125gm',0.00,5.71,0.00,2.83,0.00),(4933,'SF0011',5,'8410128113100','Pascual Creamy Strawberry 125gm',0.00,11.00,0.00,8.10,0.00),(4934,'SF0011',6,'5413721000900','Incolac Chocolate',0.00,20.80,0.00,17.61,0.00),(4935,'SF0011',7,'6034000130690','FANICE VANILLA&STRAWBERRY 1L',0.00,45.90,0.00,28.52,0.00),(4936,'SF0011',8,'6034000407198','NICH INDULGENCE MILK CHO. 44%',0.00,31.70,0.00,22.61,0.00),(4937,'SF0011',9,'6034000407396','NICHE INDULGENCE MILK CHO. 48%',0.00,31.70,0.00,23.64,0.00),(4938,'SF0011',10,'60012401000590','HARS\"18',0.00,74.00,0.00,26.21,0.00),(4939,'SF0011',11,'6154000043513','MENTOS CHEWY DRAGEES 135G',0.00,0.50,0.00,0.28,0.00),(4940,'SF0011',12,'6034000130553','Fanmaxx Vanilla 330ML',-1.00,6.60,-6.60,3.28,-3.28),(4941,'SF0011',13,'5413721000894','Incolac Banana',-1.00,28.00,-28.00,17.02,-17.02),(4942,'SF0011',14,'5413721000887','Incolac Strawberry',-1.00,22.70,-22.70,16.73,-16.73),(4943,'SF0011',15,'8410128112936','Pasual Fruit Salad/macedonia Yogurt  125',-1.00,5.13,-5.13,2.58,-2.58),(4944,'SF0011',16,'5411188543381','Alpro Soya Original Drink 1lt',-1.00,48.40,-48.40,30.35,-30.35),(4945,'SF0011',17,'6002323007463','PEARLY BAY SWEET WHITE 750ML',-2.00,91.00,-182.00,56.52,-113.04),(4946,'SF0011',18,'5411188543398','Alpro Soya Drink(Unsweetened) 1ltr',-2.00,34.85,-69.70,16.36,-32.72),(4947,'SF0011',19,'6034000163735','Namio Original 300ML',-2.00,5.42,-10.84,2.35,-4.70),(4948,'SF0011',20,'1234567','Mango Juice',-4.00,25.00,-100.00,12.00,-48.00),(4949,'SF0011',21,'5411188110835','Alpro Soya Almond Drink 1Ltr',-4.00,45.40,-181.60,36.96,-147.84),(4950,'SF0011',22,'897076002003','BULLDOG LONDON DRY GIN 750ML',-8.00,375.90,-3007.20,232.96,-1863.68);
/*!40000 ALTER TABLE `stock_freeze_tran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_master`
--

DROP TABLE IF EXISTS `stock_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `desc` char(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `desc` (`desc`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_master`
--

LOCK TABLES `stock_master` WRITE;
/*!40000 ALTER TABLE `stock_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_type`
--

DROP TABLE IF EXISTS `stock_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_type`
--

LOCK TABLES `stock_type` WRITE;
/*!40000 ALTER TABLE `stock_type` DISABLE KEYS */;
INSERT INTO `stock_type` VALUES (1,'Regular'),(2,'Non-Stock'),(3,'Discontinued');
/*!40000 ALTER TABLE `stock_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sub_categories`
--

DROP TABLE IF EXISTS `sub_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sub_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` int NOT NULL,
  `description` text,
  `tax_group` int NOT NULL,
  `owner` text NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sub_categories`
--

LOCK TABLES `sub_categories` WRITE;
/*!40000 ALTER TABLE `sub_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `sub_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supp_mast`
--

DROP TABLE IF EXISTS `supp_mast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supp_mast` (
  `id` int NOT NULL AUTO_INCREMENT,
  `supp_id` char(10) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `supp_name` char(100) NOT NULL,
  `country` text,
  `city` text,
  `address` text,
  `postal_code` text,
  `phone` text,
  `email` text,
  `dr` decimal(10,2) DEFAULT (0.00),
  `cr` decimal(10,2) DEFAULT (0.00),
  PRIMARY KEY (`id`),
  UNIQUE KEY `supp_name` (`supp_name`),
  UNIQUE KEY `supp_mast_pk` (`supp_id`),
  UNIQUE KEY `supp_id` (`supp_id`),
  UNIQUE KEY `supp_id_2` (`supp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supp_mast`
--

LOCK TABLES `supp_mast` WRITE;
/*!40000 ALTER TABLE `supp_mast` DISABLE KEYS */;
INSERT INTO `supp_mast` VALUES (5,'SU101','2025-02-09 15:09:53','Ekaza',NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00),(6,'SU102','2025-02-09 15:26:13','Imexco Ghana Ltd',NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00),(7,'SU103','2025-02-09 15:26:14','Far East Mercantile Ltd',NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00),(8,'SU104','2025-02-09 15:26:14','Gold Coast Matcom Ltd',NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00),(9,'SU105','2025-02-09 15:26:14','CHANDLOK FZCO','UAE','Dubai','Some Big\nMasion','231','893432978','chd@domain.com',0.00,0.00),(10,'SU106','2025-02-09 15:26:14','Cash Purchase',NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00),(11,'SU107','2025-02-09 15:26:14','REALLY GREAT BRANDS LTD',NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00),(12,'SU108','2025-02-09 15:26:14','NICHE CONFECTIONERY LTD',NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00),(13,'SU109','2025-02-09 15:26:14','Fanmilk Ltd / JTPM LTD',NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00),(14,'SU110','2025-02-09 15:26:15','Cave & Gardens','Ghana','Accra','Japan Motors\nRoom 6','175','0201998184','test@domain.com',0.00,0.00),(15,'SU111','2025-02-26 11:21:32','James Bond','Ghana','Accra','#6 cocoa stree','123','05278621','test@domain.com',0.00,0.00),(19,'SU112','2025-02-26 11:22:58','Amanda Cook','Ghana','East Legon','#6 cocoa street\nRoom 6','123','0546310011','info@venta.com',0.00,0.00);
/*!40000 ALTER TABLE `supp_mast` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `after_save_supplier` BEFORE INSERT ON `supp_mast` FOR EACH ROW begin
    BEGIN


        UPDATE doc_serial set nextno = nextno + 1 where doc = 'SU';
    end;
end */;;
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
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `save_supplier` BEFORE INSERT ON `supp_mast` FOR EACH ROW begin
    BEGIN
        declare new_code char(10) default '';
        SET new_code = CONCAT('SU',(SELECT doc_serial.nextno from doc_serial where doc = 'SU'));

        SET NEW.supp_id = new_code;
    end;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `variable` varchar(128) NOT NULL,
  `value` varchar(128) DEFAULT NULL,
  `set_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `set_by` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`variable`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_settings`
--

DROP TABLE IF EXISTS `sys_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_settings` (
  `set_key` char(255) NOT NULL,
  `set_value` text,
  `set_desc` text,
  `set_status` int DEFAULT (0),
  UNIQUE KEY `set_key` (`set_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_settings`
--

LOCK TABLES `sys_settings` WRITE;
/*!40000 ALTER TABLE `sys_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_buttons`
--

DROP TABLE IF EXISTS `system_buttons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_buttons` (
  `button_id` int NOT NULL AUTO_INCREMENT,
  `module` text,
  `sub_module` text,
  `sub_sub_module` text,
  `descr` text,
  `elem_id` char(255) DEFAULT NULL,
  `elem_name` char(255) DEFAULT NULL,
  `status` int DEFAULT '1',
  `target_id` text COMMENT 'if there is a target div this will target it on button invoking',
  PRIMARY KEY (`button_id`),
  UNIQUE KEY `elem_id` (`elem_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='This will hold buttons of sensitve parts of the system';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_buttons`
--

LOCK TABLES `system_buttons` WRITE;
/*!40000 ALTER TABLE `system_buttons` DISABLE KEYS */;
INSERT INTO `system_buttons` VALUES (1,'inventory','products','product_details','PRICES','inv_prod_prices','inv_prod_prices',1,'price'),(2,'inventory','products','product_details','STOCK','inv_prod_stock','inv_prod_stock',1,'stock'),(3,'inventory','products','product_details','PACKING','inv_prod_packing_tab','inv_prod_packing_tab',1,'packing_tab'),(4,'inventory','products','product_details','BARCODE','inv_prod_more_barcode','inv_prod_more_barcode',1,'more_barcode'),(5,'inventory','products','product_details','SUPPLIER','inv_prod_more_supplier','inv_prod_more_supplier',1,'more_supplier');
/*!40000 ALTER TABLE `system_buttons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_master`
--

DROP TABLE IF EXISTS `tax_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tax_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `description` text NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `owner` text NOT NULL,
  `active` int DEFAULT '0' COMMENT '1 means tax is enabled, 0 means not',
  `type` varchar(20) DEFAULT NULL,
  `attr` char(3) NOT NULL,
  `cls` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tax_master_attr_uindex` (`attr`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_master`
--

LOCK TABLES `tax_master` WRITE;
/*!40000 ALTER TABLE `tax_master` DISABLE KEYS */;
INSERT INTO `tax_master` VALUES (1,'Not Taxable',0.00,'1',1,NULL,'NON',NULL);
/*!40000 ALTER TABLE `tax_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_trans`
--

DROP TABLE IF EXISTS `tax_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tax_trans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entry_no` varchar(13) DEFAULT NULL,
  `doc` char(3) DEFAULT NULL,
  `item_code` int NOT NULL,
  `tax_amt` decimal(10,2) DEFAULT '0.00',
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tax_code` char(2) DEFAULT NULL,
  `tran_amt` decimal(10,2) DEFAULT NULL,
  `tax_rate` decimal(10,2) DEFAULT NULL,
  `unit_qty` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tax_trans___fk__with_products` (`item_code`),
  CONSTRAINT `tax_trans___fk__with_products` FOREIGN KEY (`item_code`) REFERENCES `prod_master` (`item_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_trans`
--

LOCK TABLES `tax_trans` WRITE;
/*!40000 ALTER TABLE `tax_trans` DISABLE KEYS */;
/*!40000 ALTER TABLE `tax_trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_access`
--

DROP TABLE IF EXISTS `user_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_access` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group` int NOT NULL,
  `screen` int NOT NULL,
  `read` int DEFAULT '1',
  `write` int DEFAULT '0',
  `print` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_access`
--

LOCK TABLES `user_access` WRITE;
/*!40000 ALTER TABLE `user_access` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_group`
--

DROP TABLE IF EXISTS `user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `descr` char(45) DEFAULT NULL,
  `created_on` date DEFAULT (curdate()),
  `created_on_time` time DEFAULT (curtime()),
  `remarks` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `descr_UNIQUE` (`descr`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_group`
--

LOCK TABLES `user_group` WRITE;
/*!40000 ALTER TABLE `user_group` DISABLE KEYS */;
INSERT INTO `user_group` VALUES (13,'System Administrators','2025-02-09','14:58:57','Adminsirative permissions'),(14,'Clerks','2025-02-09','14:58:57','Sales Personnel');
/*!40000 ALTER TABLE `user_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_login_log`
--

DROP TABLE IF EXISTS `user_login_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_login_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `username` text NOT NULL,
  `func` text NOT NULL,
  `date_created` date NOT NULL DEFAULT (curdate()),
  `time` time DEFAULT (curtime()),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_login_log`
--

LOCK TABLES `user_login_log` WRITE;
/*!40000 ALTER TABLE `user_login_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_login_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_task`
--

DROP TABLE IF EXISTS `user_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_task` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` text NOT NULL,
  `task_status` int NOT NULL DEFAULT '1',
  `task` text NOT NULL,
  `message` text NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_task`
--

LOCK TABLES `user_task` WRITE;
/*!40000 ALTER TABLE `user_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'user id',
  `username` text NOT NULL,
  `first_name` text,
  `last_name` text,
  `password` text NOT NULL,
  `ual` int NOT NULL DEFAULT '0',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `online` int DEFAULT NULL,
  `ip_address` text,
  `owner` text NOT NULL,
  `db_access` varchar(5999) NOT NULL DEFAULT (_utf8mb4'hello'),
  `last_login_time` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zserial`
--

DROP TABLE IF EXISTS `zserial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zserial` (
  `zSerial` int NOT NULL,
  `mech_no` int NOT NULL,
  `sales_date` date NOT NULL,
  `clerk_code` text NOT NULL,
  `shift_no` int NOT NULL,
  `z_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `gross` decimal(10,2) DEFAULT NULL,
  `deduction` decimal(10,2) DEFAULT NULL,
  `net` decimal(10,2) DEFAULT NULL,
  `eod` int DEFAULT (0),
  PRIMARY KEY (`zSerial`,`mech_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zserial`
--

LOCK TABLES `zserial` WRITE;
/*!40000 ALTER TABLE `zserial` DISABLE KEYS */;
INSERT INTO `zserial` VALUES (1,1,'2025-02-09','411',1,'2025-02-13 06:54:04',2067.57,0.00,2067.57,0),(2,1,'2025-04-04','411',1,'2025-04-20 12:17:42',27894.23,0.00,27894.23,0),(3,1,'2025-04-20','411',1,'2025-04-27 05:44:42',1810.75,0.00,1810.75,0),(4,1,'2025-04-27','411',1,'2025-06-01 22:54:09',2876.80,0.00,2876.80,0),(5,1,'2025-06-01','411',1,'2025-06-07 17:18:11',700.00,0.00,700.00,0),(6,1,'2025-06-07','411',1,'2025-06-24 02:27:05',1851.10,0.00,1851.10,0),(7,1,'2025-06-24','411',1,'2025-06-24 02:29:24',700.00,0.00,700.00,0),(8,1,'2025-06-24','411',1,'2025-06-24 03:07:39',700.00,0.00,700.00,0),(9,1,'2025-06-24','411',1,'2025-06-24 03:10:33',700.00,0.00,700.00,0),(10,1,'2025-06-24','411',1,'2025-06-24 03:26:35',700.00,0.00,700.00,0),(11,1,'2025-06-25','411',1,'2025-06-25 03:24:24',2113.65,0.00,2113.65,0),(12,1,'2025-06-25','411',1,'2025-06-25 03:35:12',466.90,0.00,466.90,0),(13,1,'2025-06-25','411',1,'2025-06-25 03:42:11',1075.90,0.00,1075.90,0),(14,1,'2025-06-25','411',1,'2025-06-25 04:05:13',1439.90,0.00,1439.90,0),(15,1,'2025-06-25','411',1,'2025-06-25 04:18:11',344.40,0.00,344.40,0),(16,1,'2025-06-25','411',1,'2025-06-25 04:22:21',136.40,0.00,136.40,0),(17,1,'2025-06-25','411',1,'2025-06-25 04:24:42',1110.75,0.00,1110.75,0),(18,1,'2025-06-25','411',1,'2025-06-25 04:26:52',827.31,0.00,827.31,0),(19,1,'2025-06-25','411',1,'2025-06-25 04:30:37',787.85,0.00,787.85,0),(20,1,'2025-06-25','411',1,'2025-06-25 04:32:41',745.42,0.00,745.42,0),(21,1,'2025-06-25','411',1,'2025-06-25 05:33:32',199.25,0.00,199.25,0),(22,1,'2025-06-25','411',1,'2025-06-25 05:36:16',745.71,0.00,745.71,0),(23,1,'2025-06-25','411',1,'2025-06-25 05:48:13',161.40,0.00,161.40,0),(24,1,'2025-06-25','411',1,'2025-06-25 05:54:59',1627.40,0.00,1627.40,0),(25,1,'2025-06-24','411',1,'2025-06-24 16:08:50',1075.90,0.00,1075.90,0),(26,1,'2025-06-24','411',1,'2025-06-24 16:15:41',42.44,0.00,42.44,0),(27,1,'2025-06-24','411',1,'2025-06-24 17:10:25',791.00,0.00,791.00,0),(28,1,'2025-06-24','411',1,'2025-06-24 17:24:42',1075.90,0.00,1075.90,0),(29,1,'2025-06-27','411',1,'2025-06-27 05:22:34',700.00,0.00,700.00,0),(30,1,'2025-06-28','411',1,'2025-06-28 06:59:38',1075.90,0.00,1075.90,0),(31,1,'2025-06-28','411',1,'2025-06-28 08:43:41',1233.73,0.00,1233.73,0),(32,1,'2025-06-28','411',1,'2025-06-28 08:47:59',1269.26,0.00,1269.26,0);
/*!40000 ALTER TABLE `zserial` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-25 14:37:12
