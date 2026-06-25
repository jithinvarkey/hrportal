-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: hrsystem
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity_log`
--

DROP TABLE IF EXISTS `activity_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `log_name` varchar(255) DEFAULT NULL,
  `description` text NOT NULL,
  `subject_type` varchar(255) DEFAULT NULL,
  `subject_id` bigint(20) unsigned DEFAULT NULL,
  `causer_type` varchar(255) DEFAULT NULL,
  `causer_id` bigint(20) unsigned DEFAULT NULL,
  `properties` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`properties`)),
  `batch_uuid` char(36) DEFAULT NULL,
  `event` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subject` (`subject_type`,`subject_id`),
  KEY `causer` (`causer_type`,`causer_id`),
  KEY `activity_log_log_name_index` (`log_name`)
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log`
--

LOCK TABLES `activity_log` WRITE;
/*!40000 ALTER TABLE `activity_log` DISABLE KEYS */;
INSERT INTO `activity_log` VALUES (109,'default','created','App\\Models\\Employee',106,NULL,NULL,'{\"attributes\":{\"first_name\":\"System\",\"last_name\":\"Admin\",\"email\":\"admin@hrms.com\",\"status\":\"active\",\"department_id\":2,\"salary\":\"5000.00\"}}',NULL,'created','2026-04-12 07:14:15','2026-04-12 07:14:15'),(110,'default','created','App\\Models\\Employee',107,'App\\Models\\User',284,'{\"attributes\":{\"first_name\":\"jithin\",\"last_name\":\"varkey\",\"email\":\"jithinvarkey@gmail.com\",\"status\":\"probation\",\"department_id\":3,\"salary\":\"10000.00\"}}',NULL,'created','2026-04-13 10:56:12','2026-04-13 10:56:12'),(111,'default','created','App\\Models\\Employee',108,'App\\Models\\User',284,'{\"attributes\":{\"first_name\":\"Jinesh\",\"last_name\":\"Mani\",\"email\":\"j.mani@dbroker.com.sa\",\"status\":\"active\",\"department_id\":3,\"salary\":\"5570.00\"}}',NULL,'created','2026-06-18 10:12:59','2026-06-18 10:12:59'),(112,'default','updated','App\\Models\\Employee',107,'App\\Models\\User',284,'{\"attributes\":[],\"old\":[]}',NULL,'updated','2026-06-18 10:16:44','2026-06-18 10:16:44'),(113,'default','created','App\\Models\\Employee',109,'App\\Models\\User',284,'{\"attributes\":{\"first_name\":\"Saad\",\"last_name\":\"Alshaya\",\"email\":\"s.alshaya@dbroker.com.sa\",\"status\":\"active\",\"department_id\":2,\"salary\":\"6000.00\"}}',NULL,'created','2026-06-18 10:18:58','2026-06-18 10:18:58'),(114,'system_settings','Loan approval workflow updated.',NULL,NULL,'App\\Models\\User',284,'{\"setting\":\"loan_approval_levels\",\"from\":2,\"to\":2}',NULL,'updated','2026-06-18 10:19:39','2026-06-18 10:19:39'),(115,'loan_request','Loan request submitted.','App\\Models\\Loan',6,'App\\Models\\User',286,'{\"to_status\":\"pending_hr\",\"requested_amount\":5000,\"installments\":\"5\",\"notes\":\"test loan approval request\"}',NULL,'submitted','2026-06-18 10:21:42','2026-06-18 10:21:42'),(116,'default','created','App\\Models\\Employee',110,'App\\Models\\User',284,'{\"attributes\":{\"first_name\":\"Ahmed\",\"last_name\":\"Helmy\",\"email\":\"a.helmy@dbroker.com.sa\",\"status\":\"active\",\"department_id\":4,\"salary\":\"15000.00\"}}',NULL,'created','2026-06-18 10:24:34','2026-06-18 10:24:34'),(117,'loan_request','Loan request approved by HR.','App\\Models\\Loan',6,'App\\Models\\User',287,'{\"from_status\":\"pending_hr\",\"to_status\":\"pending_finance\"}',NULL,'hr_approved','2026-06-18 10:35:29','2026-06-18 10:35:29'),(118,'loan_request','Loan request approved by finance and schedule generated.','App\\Models\\Loan',6,'App\\Models\\User',288,'{\"from_status\":\"pending_finance\",\"to_status\":\"approved\",\"approved_amount\":5000,\"monthly_installment\":1000}',NULL,'finance_approved','2026-06-18 10:36:08','2026-06-18 10:36:08'),(119,'loan_request','Loan marked as disbursed.','App\\Models\\Loan',6,'App\\Models\\User',288,'{\"from_status\":\"approved\",\"to_status\":\"disbursed\",\"disbursed_date\":\"2026-06-18\"}',NULL,'disbursed','2026-06-18 10:36:15','2026-06-18 10:36:15'),(120,'system_settings','Loan approval workflow updated.',NULL,NULL,'App\\Models\\User',284,'{\"setting\":\"loan_approval_levels\",\"from\":2,\"to\":3}',NULL,'updated','2026-06-18 11:00:48','2026-06-18 11:00:48'),(121,'loan_request','Loan request submitted.','App\\Models\\Loan',7,'App\\Models\\User',286,'{\"to_status\":\"pending_manager\",\"requested_amount\":1000,\"installments\":\"4\",\"notes\":\"edcation loan request\"}',NULL,'submitted','2026-06-18 11:01:42','2026-06-18 11:01:42'),(122,'loan_request','Loan request approved by manager.','App\\Models\\Loan',7,'App\\Models\\User',284,'{\"from_status\":\"pending_manager\",\"to_status\":\"pending_hr\"}',NULL,'manager_approved','2026-06-18 11:02:52','2026-06-18 11:02:52'),(123,'loan_request','Loan request approved by HR.','App\\Models\\Loan',7,'App\\Models\\User',284,'{\"from_status\":\"pending_hr\",\"to_status\":\"pending_finance\"}',NULL,'hr_approved','2026-06-18 11:02:56','2026-06-18 11:02:56'),(124,'default','created','App\\Models\\Employee',111,'App\\Models\\User',284,'{\"attributes\":{\"first_name\":\"Badr\",\"last_name\":\"Alshaya\",\"email\":\"b.alshaya@dbroker.com.sa\",\"status\":\"active\",\"department_id\":8,\"salary\":\"50000.00\"}}',NULL,'created','2026-06-18 11:06:24','2026-06-18 11:06:24'),(128,'default','updated','App\\Models\\Employee',108,'App\\Models\\User',284,'{\"attributes\":[],\"old\":[]}',NULL,'updated','2026-06-18 12:58:00','2026-06-18 12:58:00'),(129,'default','updated','App\\Models\\Employee',108,'App\\Models\\User',284,'{\"attributes\":[],\"old\":[]}',NULL,'updated','2026-06-18 12:58:50','2026-06-18 12:58:50'),(130,'birthday_wishes','Birthday wish sent','App\\Models\\Employee',108,'App\\Models\\User',284,'[]',NULL,'sent','2026-06-18 12:59:16','2026-06-18 12:59:16'),(131,'birthday_wishes','Birthday wish sent','App\\Models\\Employee',108,'App\\Models\\User',284,'[]',NULL,'sent','2026-06-18 13:05:58','2026-06-18 13:05:58'),(132,'birthday_wishes','Birthday wish sent','App\\Models\\Employee',108,'App\\Models\\User',284,'[]',NULL,'sent','2026-06-18 13:11:42','2026-06-18 13:11:42'),(133,'default','created','App\\Models\\Employee',114,'App\\Models\\User',284,'{\"attributes\":{\"first_name\":\"Hany\",\"last_name\":\"Hashem\",\"email\":\"h.hashem@dbroker.com.sa\",\"status\":\"active\",\"department_id\":9,\"salary\":\"15000.00\"}}',NULL,'created','2026-06-18 13:25:27','2026-06-18 13:25:27'),(134,'default','updated','App\\Models\\Employee',107,'App\\Models\\User',284,'{\"attributes\":[],\"old\":[]}',NULL,'updated','2026-06-18 13:27:27','2026-06-18 13:27:27'),(135,'default','updated','App\\Models\\Employee',107,'App\\Models\\User',284,'{\"attributes\":{\"status\":\"active\"},\"old\":{\"status\":\"probation\"}}',NULL,'updated','2026-06-18 13:28:32','2026-06-18 13:28:32'),(136,'default','created','App\\Models\\Employee',115,'App\\Models\\User',284,'{\"attributes\":{\"first_name\":\"Azher\",\"last_name\":\"Mohammed\",\"email\":\"m.azher@dbroker.com.sa\",\"status\":\"active\",\"department_id\":9,\"salary\":\"6000.00\"}}',NULL,'created','2026-06-18 13:31:24','2026-06-18 13:31:24'),(137,'default','updated','App\\Models\\Employee',115,'App\\Models\\User',284,'{\"attributes\":[],\"old\":[]}',NULL,'updated','2026-06-21 06:40:48','2026-06-21 06:40:48'),(138,'default','updated','App\\Models\\Employee',115,'App\\Models\\User',284,'{\"attributes\":[],\"old\":[]}',NULL,'updated','2026-06-21 06:41:26','2026-06-21 06:41:26'),(139,'birthday_wishes','Birthday wish sent','App\\Models\\Employee',115,'App\\Models\\User',284,'[]',NULL,'sent','2026-06-21 07:52:24','2026-06-21 07:52:24'),(140,'birthday_wishes','Birthday wish sent','App\\Models\\Employee',115,'App\\Models\\User',284,'[]',NULL,'sent','2026-06-21 07:56:53','2026-06-21 07:56:53'),(141,'birthday_wishes','Birthday wish sent','App\\Models\\Employee',115,'App\\Models\\User',284,'[]',NULL,'sent','2026-06-21 07:59:37','2026-06-21 07:59:37'),(145,'attendance','Missed checkout notification sent','App\\Models\\AttendanceLog',11,NULL,NULL,'{\"employee_id\":108,\"date\":\"2026-06-20\"}',NULL,'missed_checkout_notified','2026-06-21 09:01:05','2026-06-21 09:01:05'),(148,'leave_request','Annual Leave leave request submitted.','App\\Models\\LeaveRequest',12,'App\\Models\\User',286,'{\"to_status\":\"pending\",\"total_days\":4,\"notes\":\"annual leave please approve\"}',NULL,'submitted','2026-06-21 09:51:48','2026-06-21 09:51:48'),(150,'default','updated','App\\Models\\Employee',115,'App\\Models\\User',284,'{\"attributes\":[],\"old\":[]}',NULL,'updated','2026-06-21 10:05:38','2026-06-21 10:05:38'),(151,'default','updated','App\\Models\\Employee',108,'App\\Models\\User',284,'{\"attributes\":[],\"old\":[]}',NULL,'updated','2026-06-21 10:06:09','2026-06-21 10:06:09'),(152,'leave_request','Leave request approved at manager level.','App\\Models\\LeaveRequest',12,'App\\Models\\User',285,'{\"from_status\":\"pending\",\"to_status\":\"manager_approved\"}',NULL,'manager_approved','2026-06-21 10:06:34','2026-06-21 10:06:34'),(153,'leave_request','Leave request fully approved by HR.','App\\Models\\LeaveRequest',12,'App\\Models\\User',287,'{\"from_status\":\"manager_approved\",\"to_status\":\"approved\"}',NULL,'hr_approved','2026-06-21 10:07:18','2026-06-21 10:07:18'),(154,'leave_request','Leave request cancelled.','App\\Models\\LeaveRequest',12,'App\\Models\\User',287,'{\"from_status\":\"approved\",\"to_status\":\"cancelled\"}',NULL,'cancelled','2026-06-21 10:43:06','2026-06-21 10:43:06'),(158,'leave_request','Annual Leave leave request submitted.','App\\Models\\LeaveRequest',14,'App\\Models\\User',286,'{\"to_status\":\"pending\",\"total_days\":5,\"notes\":\"leaves vvvvvvvvvvvvvvvvvvvv\"}',NULL,'submitted','2026-06-21 12:24:20','2026-06-21 12:24:20'),(159,'loan_request','Loan request submitted.','App\\Models\\Loan',8,'App\\Models\\User',284,'{\"to_status\":\"pending_manager\",\"requested_amount\":10000,\"installments\":\"5\",\"notes\":\"requesting loan\"}',NULL,'submitted','2026-06-21 12:49:07','2026-06-21 12:49:07'),(160,'system_settings','Loan approval workflow updated.',NULL,NULL,'App\\Models\\User',284,'{\"setting\":\"loan_approval_levels\",\"from\":3,\"to\":2}',NULL,'updated','2026-06-21 12:49:37','2026-06-21 12:49:37'),(161,'loan_request','Loan request approved by HR; manager approval was skipped by configuration.','App\\Models\\Loan',8,'App\\Models\\User',284,'{\"from_status\":\"pending_manager\",\"to_status\":\"pending_finance\",\"approval_levels\":2}',NULL,'hr_approved','2026-06-21 12:50:09','2026-06-21 12:50:09'),(162,'default','updated','App\\Models\\Employee',115,'App\\Models\\User',287,'{\"attributes\":[],\"old\":[]}',NULL,'updated','2026-06-22 07:29:29','2026-06-22 07:29:29'),(163,'birthday_wishes','Birthday wish sent','App\\Models\\Employee',115,'App\\Models\\User',287,'[]',NULL,'sent','2026-06-22 07:29:50','2026-06-22 07:29:50'),(164,'default','created','App\\Models\\EmployeeAsset',1,'App\\Models\\User',287,'{\"attributes\":{\"employee_id\":115,\"asset_category_id\":8,\"asset_name\":\"dfdfdf\",\"asset_tag\":\"fgfg\",\"serial_number\":\"tytyt\",\"brand\":null,\"model\":null,\"license_key\":null,\"license_expiry\":null,\"purchase_date\":null,\"purchase_cost\":null,\"assigned_at\":\"2026-06-21T21:00:00.000000Z\",\"returned_at\":null,\"condition\":\"good\",\"status\":\"assigned\",\"notes\":null,\"created_by\":287,\"updated_by\":287}}',NULL,'created','2026-06-22 09:23:18','2026-06-22 09:23:18'),(165,'default','updated','App\\Models\\Employee',108,'App\\Models\\User',284,'{\"attributes\":[],\"old\":[]}',NULL,'updated','2026-06-22 12:12:47','2026-06-22 12:12:47'),(166,'loan_request','Loan request rejected at finance stage.','App\\Models\\Loan',7,'App\\Models\\User',284,'{\"from_status\":\"pending_finance\",\"to_status\":\"rejected\",\"reason\":\"not allowed\",\"stage\":\"finance\"}',NULL,'rejected','2026-06-23 13:11:56','2026-06-23 13:11:56'),(167,'leave_request','Annual Leave leave request submitted.','App\\Models\\LeaveRequest',15,'App\\Models\\User',286,'{\"to_status\":\"pending\",\"total_days\":0.5,\"notes\":\"test reason for the leave\"}',NULL,'submitted','2026-06-24 08:49:56','2026-06-24 08:49:56'),(168,'leave_request','Leave request approved at manager level.','App\\Models\\LeaveRequest',14,'App\\Models\\User',285,'{\"from_status\":\"pending\",\"to_status\":\"manager_approved\"}',NULL,'manager_approved','2026-06-24 08:50:48','2026-06-24 08:50:48'),(169,'leave_request','Leave request approved at manager level.','App\\Models\\LeaveRequest',15,'App\\Models\\User',285,'{\"from_status\":\"pending\",\"to_status\":\"manager_approved\"}',NULL,'manager_approved','2026-06-24 09:07:10','2026-06-24 09:07:10'),(170,'leave_request','Leave request fully approved by HR.','App\\Models\\LeaveRequest',15,'App\\Models\\User',287,'{\"from_status\":\"manager_approved\",\"to_status\":\"approved\"}',NULL,'hr_approved','2026-06-24 09:10:41','2026-06-24 09:10:41'),(171,'leave_request','Leave request approved at manager level.','App\\Models\\LeaveRequest',10,'App\\Models\\User',287,'{\"from_status\":\"pending\",\"to_status\":\"manager_approved\"}',NULL,'manager_approved','2026-06-24 09:11:05','2026-06-24 09:11:05'),(172,'default','created','App\\Models\\Employee',121,'App\\Models\\User',284,'{\"attributes\":{\"first_name\":\"Mohammed\",\"last_name\":\"Abdulfaisal\",\"email\":\"m.faisal@dbroker.com.sa\",\"status\":\"active\",\"department_id\":5,\"salary\":\"5000.00\"}}',NULL,'created','2026-06-24 09:56:00','2026-06-24 09:56:00'),(173,'default','created','App\\Models\\Employee',122,'App\\Models\\User',287,'{\"attributes\":{\"first_name\":\"Kiran\",\"last_name\":\"raj\",\"email\":\"kiran@gmail.com\",\"status\":\"probation\",\"department_id\":3,\"salary\":\"7000.00\"}}',NULL,'created','2026-06-25 11:18:19','2026-06-25 11:18:19'),(174,'default','updated','App\\Models\\Employee',122,NULL,NULL,'{\"attributes\":[],\"old\":[]}',NULL,'updated','2026-06-25 11:30:49','2026-06-25 11:30:49');
/*!40000 ALTER TABLE `activity_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcement_categories`
--

DROP TABLE IF EXISTS `announcement_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcement_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(120) NOT NULL,
  `color` varchar(20) DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `announcement_categories_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcement_categories`
--

LOCK TABLES `announcement_categories` WRITE;
/*!40000 ALTER TABLE `announcement_categories` DISABLE KEYS */;
INSERT INTO `announcement_categories` VALUES (1,'Holiday','holiday','#2E75B6','campaign',1,'2026-06-18 10:01:56','2026-06-18 10:01:56'),(2,'Circular','circular','#2E75B6','campaign',1,'2026-06-21 10:30:37','2026-06-21 10:30:37');
/*!40000 ALTER TABLE `announcement_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcement_reactions`
--

DROP TABLE IF EXISTS `announcement_reactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcement_reactions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `announcement_id` bigint(20) unsigned NOT NULL,
  `employee_id` bigint(20) unsigned NOT NULL,
  `emoji` varchar(16) NOT NULL DEFAULT 'like',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `announcement_reactions_announcement_id_employee_id_unique` (`announcement_id`,`employee_id`),
  KEY `announcement_reactions_employee_id_foreign` (`employee_id`),
  CONSTRAINT `announcement_reactions_announcement_id_foreign` FOREIGN KEY (`announcement_id`) REFERENCES `announcements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `announcement_reactions_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcement_reactions`
--

LOCK TABLES `announcement_reactions` WRITE;
/*!40000 ALTER TABLE `announcement_reactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `announcement_reactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcement_reads`
--

DROP TABLE IF EXISTS `announcement_reads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcement_reads` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `announcement_id` bigint(20) unsigned NOT NULL,
  `employee_id` bigint(20) unsigned NOT NULL,
  `read_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `announcement_reads_announcement_id_employee_id_unique` (`announcement_id`,`employee_id`),
  KEY `announcement_reads_employee_id_foreign` (`employee_id`),
  CONSTRAINT `announcement_reads_announcement_id_foreign` FOREIGN KEY (`announcement_id`) REFERENCES `announcements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `announcement_reads_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcement_reads`
--

LOCK TABLES `announcement_reads` WRITE;
/*!40000 ALTER TABLE `announcement_reads` DISABLE KEYS */;
INSERT INTO `announcement_reads` VALUES (1,1,108,'2026-06-22 08:37:00','2026-06-22 08:37:00','2026-06-22 08:37:00');
/*!40000 ALTER TABLE `announcement_reads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcements` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) unsigned DEFAULT NULL,
  `title` varchar(200) NOT NULL,
  `title_ar` varchar(200) DEFAULT NULL,
  `body` text DEFAULT NULL,
  `body_ar` text DEFAULT NULL,
  `priority` varchar(20) NOT NULL DEFAULT 'normal',
  `audience_type` varchar(20) NOT NULL DEFAULT 'all',
  `target_department_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_department_ids`)),
  `target_roles` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_roles`)),
  `is_pinned` tinyint(1) NOT NULL DEFAULT 0,
  `is_published` tinyint(1) NOT NULL DEFAULT 1,
  `published_at` timestamp NULL DEFAULT NULL,
  `scheduled_at` timestamp NULL DEFAULT NULL,
  `expires_at` date DEFAULT NULL,
  `attachment_path` varchar(255) DEFAULT NULL,
  `attachment_name` varchar(255) DEFAULT NULL,
  `attachment_mime` varchar(255) DEFAULT NULL,
  `attachment_size` bigint(20) unsigned DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `announcements_category_id_foreign` (`category_id`),
  KEY `announcements_created_by_foreign` (`created_by`),
  KEY `announcements_is_published_published_at_index` (`is_published`,`published_at`),
  CONSTRAINT `announcements_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `announcement_categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `announcements_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
INSERT INTO `announcements` VALUES (1,2,'Diamond -Test',NULL,'ببلابىبىبىبىبىبىبىببب',NULL,'normal','all',NULL,NULL,0,1,'2026-06-21 12:27:08',NULL,NULL,'announcements/L9U8BNnjw2jvqIeZAgr1eKcYQnMoAiy3MUlV4KgK.pdf','PRD.pdf','application/pdf',397497,284,'2026-06-21 12:27:08','2026-06-21 12:27:08');
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_notifications`
--

DROP TABLE IF EXISTS `app_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_notifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `type` varchar(50) NOT NULL,
  `title` varchar(200) NOT NULL,
  `body` varchar(500) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `ref_id` bigint(20) unsigned DEFAULT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `app_notifications_employee_id_read_at_index` (`employee_id`,`read_at`),
  CONSTRAINT `app_notifications_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_notifications`
--

LOCK TABLES `app_notifications` WRITE;
/*!40000 ALTER TABLE `app_notifications` DISABLE KEYS */;
INSERT INTO `app_notifications` VALUES (2,108,'missed_checkout','Missing checkout','No checkout was recorded for June 20, 2026. Please contact HR to correct your attendance.','/attendance',11,NULL,'2026-06-21 09:01:05','2026-06-21 09:01:05'),(3,106,'announcement','Diamond -Test','ببلابىبىبىبىبىبىبىببب','/announcements',1,'2026-06-21 13:02:40','2026-06-21 12:27:08','2026-06-21 13:02:40'),(4,107,'announcement','Diamond -Test','ببلابىبىبىبىبىبىبىببب','/announcements',1,NULL,'2026-06-21 12:27:08','2026-06-21 12:27:08'),(5,108,'announcement','Diamond -Test','ببلابىبىبىبىبىبىبىببب','/announcements',1,'2026-06-21 12:27:52','2026-06-21 12:27:08','2026-06-21 12:27:52'),(6,109,'announcement','Diamond -Test','ببلابىبىبىبىبىبىبىببب','/announcements',1,'2026-06-22 07:27:26','2026-06-21 12:27:08','2026-06-22 07:27:26'),(7,110,'announcement','Diamond -Test','ببلابىبىبىبىبىبىبىببب','/announcements',1,NULL,'2026-06-21 12:27:08','2026-06-21 12:27:08'),(8,111,'announcement','Diamond -Test','ببلابىبىبىبىبىبىبىببب','/announcements',1,NULL,'2026-06-21 12:27:08','2026-06-21 12:27:08'),(9,114,'announcement','Diamond -Test','ببلابىبىبىبىبىبىبىببب','/announcements',1,NULL,'2026-06-21 12:27:08','2026-06-21 12:27:08'),(10,115,'announcement','Diamond -Test','ببلابىبىبىبىبىبىبىببب','/announcements',1,NULL,'2026-06-21 12:27:08','2026-06-21 12:27:08'),(11,106,'policy','Policy: HR Leave policy','“HR Leave policy” requires your acknowledgement.','/policies',1,'2026-06-21 13:02:40','2026-06-21 12:31:10','2026-06-21 13:02:40'),(12,107,'policy','Policy: HR Leave policy','“HR Leave policy” requires your acknowledgement.','/policies',1,NULL,'2026-06-21 12:31:10','2026-06-21 12:31:10'),(13,108,'policy','Policy: HR Leave policy','“HR Leave policy” requires your acknowledgement.','/policies',1,NULL,'2026-06-21 12:31:10','2026-06-21 12:31:10'),(14,109,'policy','Policy: HR Leave policy','“HR Leave policy” requires your acknowledgement.','/policies',1,'2026-06-22 07:27:26','2026-06-21 12:31:10','2026-06-22 07:27:26'),(15,110,'policy','Policy: HR Leave policy','“HR Leave policy” requires your acknowledgement.','/policies',1,NULL,'2026-06-21 12:31:10','2026-06-21 12:31:10'),(16,111,'policy','Policy: HR Leave policy','“HR Leave policy” requires your acknowledgement.','/policies',1,NULL,'2026-06-21 12:31:10','2026-06-21 12:31:10'),(17,114,'policy','Policy: HR Leave policy','“HR Leave policy” requires your acknowledgement.','/policies',1,NULL,'2026-06-21 12:31:10','2026-06-21 12:31:10'),(18,115,'policy','Policy: HR Leave policy','“HR Leave policy” requires your acknowledgement.','/policies',1,NULL,'2026-06-21 12:31:10','2026-06-21 12:31:10');
/*!40000 ALTER TABLE `app_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asset_assignments`
--

DROP TABLE IF EXISTS `asset_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_assignments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `asset_id` bigint(20) unsigned NOT NULL,
  `employee_id` bigint(20) unsigned NOT NULL,
  `assigned_date` date NOT NULL,
  `return_date` date DEFAULT NULL COMMENT 'Null = currently assigned',
  `condition_at_assign` varchar(20) NOT NULL DEFAULT 'good',
  `condition_at_return` varchar(20) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `assigned_by` bigint(20) unsigned DEFAULT NULL,
  `returned_to` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_assignments_assigned_by_foreign` (`assigned_by`),
  KEY `asset_assignments_returned_to_foreign` (`returned_to`),
  KEY `asset_assignments_asset_id_return_date_index` (`asset_id`,`return_date`),
  KEY `asset_assignments_employee_id_return_date_index` (`employee_id`,`return_date`),
  CONSTRAINT `asset_assignments_asset_id_foreign` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `asset_assignments_assigned_by_foreign` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `asset_assignments_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `asset_assignments_returned_to_foreign` FOREIGN KEY (`returned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asset_assignments`
--

LOCK TABLES `asset_assignments` WRITE;
/*!40000 ALTER TABLE `asset_assignments` DISABLE KEYS */;
INSERT INTO `asset_assignments` VALUES (1,1,108,'2026-06-23','2026-06-23','good','good','ter rer re\nreturned',287,287,'2026-06-23 07:43:29','2026-06-23 07:48:52'),(2,1,115,'2026-05-01',NULL,'good',NULL,NULL,287,NULL,'2026-06-23 07:49:15','2026-06-23 07:49:15');
/*!40000 ALTER TABLE `asset_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asset_categories`
--

DROP TABLE IF EXISTS `asset_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Category display name',
  `slug` varchar(120) NOT NULL,
  `icon` varchar(50) DEFAULT NULL COMMENT 'Material icon name',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `asset_categories_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asset_categories`
--

LOCK TABLES `asset_categories` WRITE;
/*!40000 ALTER TABLE `asset_categories` DISABLE KEYS */;
INSERT INTO `asset_categories` VALUES (1,'laptop','laptop','devices',1,0,'2026-06-23 07:41:55','2026-06-23 07:41:55');
/*!40000 ALTER TABLE `asset_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asset_maintenance`
--

DROP TABLE IF EXISTS `asset_maintenance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_maintenance` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `asset_id` bigint(20) unsigned NOT NULL,
  `type` varchar(50) NOT NULL COMMENT 'repair | service | inspection | upgrade',
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `scheduled_date` date DEFAULT NULL,
  `completed_date` date DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT NULL,
  `vendor` varchar(150) DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'scheduled' COMMENT 'scheduled | in_progress | completed | cancelled',
  `resolution` text DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_maintenance_created_by_foreign` (`created_by`),
  KEY `asset_maintenance_asset_id_status_index` (`asset_id`,`status`),
  CONSTRAINT `asset_maintenance_asset_id_foreign` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `asset_maintenance_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asset_maintenance`
--

LOCK TABLES `asset_maintenance` WRITE;
/*!40000 ALTER TABLE `asset_maintenance` DISABLE KEYS */;
/*!40000 ALTER TABLE `asset_maintenance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) unsigned DEFAULT NULL,
  `name` varchar(200) NOT NULL COMMENT 'Asset display name',
  `asset_code` varchar(100) NOT NULL COMMENT 'Internal asset tag / barcode',
  `brand` varchar(100) DEFAULT NULL,
  `model` varchar(100) DEFAULT NULL,
  `serial_number` varchar(150) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'available',
  `condition` varchar(20) NOT NULL DEFAULT 'good',
  `purchase_price` decimal(12,2) DEFAULT NULL,
  `purchase_date` date DEFAULT NULL,
  `vendor` varchar(150) DEFAULT NULL,
  `warranty_expiry` varchar(20) DEFAULT NULL COMMENT 'YYYY-MM-DD',
  `location` varchar(150) DEFAULT NULL COMMENT 'Physical location / office',
  `custodian_employee_id` bigint(20) unsigned DEFAULT NULL,
  `attachment_path` varchar(500) DEFAULT NULL,
  `attachment_name` varchar(255) DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assets_asset_code_unique` (`asset_code`),
  UNIQUE KEY `assets_serial_number_unique` (`serial_number`),
  KEY `assets_category_id_foreign` (`category_id`),
  KEY `assets_created_by_foreign` (`created_by`),
  KEY `assets_status_category_id_index` (`status`,`category_id`),
  KEY `assets_custodian_employee_id_index` (`custodian_employee_id`),
  CONSTRAINT `assets_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `asset_categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `assets_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `assets_custodian_employee_id_foreign` FOREIGN KEY (`custodian_employee_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (1,1,'Laptop','IT-001','HP',NULL,NULL,'e eeeeeeeeeewe','assigned','good',NULL,'2025-05-05',NULL,NULL,NULL,115,NULL,NULL,287,'2026-06-23 07:43:14','2026-06-23 07:49:15',NULL);
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_devices`
--

DROP TABLE IF EXISTS `attendance_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_devices` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `brand` varchar(50) NOT NULL DEFAULT 'zkteco',
  `ip_address` varchar(45) NOT NULL,
  `port` int(11) NOT NULL DEFAULT 4370,
  `protocol` varchar(20) NOT NULL DEFAULT 'tcp',
  `api_path` varchar(255) DEFAULT NULL,
  `api_key` varchar(255) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `timeout_seconds` int(11) NOT NULL DEFAULT 30,
  `employee_number_field` varchar(50) NOT NULL DEFAULT 'employee_code',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_synced_at` timestamp NULL DEFAULT NULL,
  `last_sync_status` varchar(20) DEFAULT NULL,
  `last_sync_count` int(11) DEFAULT NULL,
  `last_sync_error` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_devices`
--

LOCK TABLES `attendance_devices` WRITE;
/*!40000 ALTER TABLE `attendance_devices` DISABLE KEYS */;
INSERT INTO `attendance_devices` VALUES (1,'Biotime','zkteco','192.168.100.10',81,'http','/iclock/api/transactions/',NULL,'admin','eyJpdiI6Imkzdks1MEZKZy9LVXJUVlk1ditLOEE9PSIsInZhbHVlIjoiRTcyNUVuOUgvbWQ1dGxzNFlYT0RHZz09IiwibWFjIjoiOWM4NmJmODA2ODU1Yjc0ZGJkMTlmNTNmOGI2OWZjZWQzZWEwMzBlYTRmNWQxNjAxYTIzZDU4OTk2YmIzZmQ3NiIsInRhZyI6IiJ9',30,'employee_code',1,'2026-06-21 08:50:02','success',1,NULL,'2026-06-18 10:41:28','2026-06-21 08:50:02');
/*!40000 ALTER TABLE `attendance_devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_logs`
--

DROP TABLE IF EXISTS `attendance_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `date` date NOT NULL,
  `check_in` time DEFAULT NULL,
  `check_out` time DEFAULT NULL,
  `total_minutes` int(11) DEFAULT NULL,
  `status` enum('present','absent','late','half_day','on_leave','holiday') NOT NULL DEFAULT 'present',
  `source` enum('manual','api','biometric','import') NOT NULL DEFAULT 'api',
  `ip_address` varchar(45) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `missed_checkout_notified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attendance_logs_employee_id_date_unique` (`employee_id`,`date`),
  CONSTRAINT `attendance_logs_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_logs`
--

LOCK TABLES `attendance_logs` WRITE;
/*!40000 ALTER TABLE `attendance_logs` DISABLE KEYS */;
INSERT INTO `attendance_logs` VALUES (1,106,'2026-04-13','08:28:41','08:33:49',5,'present','api','127.0.0.1',NULL,NULL,'2026-04-13 05:28:41','2026-04-13 05:33:49'),(2,107,'2026-06-18','08:42:03',NULL,NULL,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:42:58','2026-06-18 10:42:58'),(3,108,'2026-06-18','16:56:44',NULL,NULL,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:42:58','2026-06-21 08:50:02'),(4,107,'2026-06-17','08:42:07','16:32:49',470,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:44:57','2026-06-18 10:44:57'),(5,107,'2026-06-16','08:50:52','16:46:36',475,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:45:13','2026-06-18 10:45:13'),(6,107,'2026-06-15','08:42:24','16:40:04',477,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:46:13','2026-06-18 10:46:13'),(7,108,'2026-06-15','08:42:28','16:31:56',469,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:48:19','2026-06-18 10:48:19'),(8,110,'2026-06-15','10:24:10','17:36:19',432,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:48:19','2026-06-18 10:48:19'),(10,110,'2026-06-16','10:44:41','18:30:30',465,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:48:19','2026-06-18 10:48:19'),(11,108,'2026-06-20','08:42:11',NULL,470,'late','api',NULL,'Synced from Biotime','2026-06-21 09:01:05','2026-06-20 10:48:19','2026-06-21 09:01:05'),(12,110,'2026-06-17','09:41:33','17:16:20',454,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:48:19','2026-06-18 10:48:19'),(13,107,'2026-06-11','08:38:35','17:39:24',540,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:49:45','2026-06-18 10:49:45'),(14,108,'2026-06-11','08:38:38','17:36:45',538,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:49:45','2026-06-18 10:49:45'),(15,110,'2026-06-11','10:29:45','17:48:11',438,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:49:45','2026-06-18 10:49:45'),(16,108,'2026-06-07','08:38:36','16:43:22',484,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(17,107,'2026-06-07','08:38:50','16:40:15',481,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(18,110,'2026-06-07','10:58:55','17:24:14',385,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(19,108,'2026-06-08','08:37:10','16:43:00',485,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(20,107,'2026-06-08','08:37:15','16:48:44',491,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(21,110,'2026-06-08','10:27:40','20:36:22',608,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(22,107,'2026-06-09','08:36:40','16:59:50',503,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(23,108,'2026-06-09','08:36:42','16:56:53',500,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(24,110,'2026-06-09','10:23:31','17:42:49',439,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(25,107,'2026-06-10','08:49:09','16:36:36',467,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(26,108,'2026-06-10','08:49:14','16:36:18',467,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(27,110,'2026-06-10','17:51:31',NULL,NULL,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(28,108,'2026-04-01','08:40:55','16:22:44',461,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(29,107,'2026-04-01','08:40:58','16:22:18',461,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(30,109,'2026-04-01','17:03:58',NULL,NULL,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(31,107,'2026-04-02','08:38:36','16:20:05',461,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(32,108,'2026-04-02','08:38:39','16:20:09',461,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(33,110,'2026-04-03','23:58:12',NULL,NULL,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(34,110,'2026-04-04','22:30:29',NULL,NULL,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(35,110,'2026-04-05','01:02:40','19:03:42',1081,'present','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(36,107,'2026-04-05','08:34:11','16:45:53',491,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(37,108,'2026-04-05','08:34:15','16:45:00',490,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(38,109,'2026-04-05','16:05:30',NULL,NULL,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(39,107,'2026-04-06','08:34:43','16:37:27',482,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(40,108,'2026-04-06','08:34:47','16:37:23',482,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(41,110,'2026-04-06','09:43:30','17:49:55',486,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(42,109,'2026-04-06','13:41:31',NULL,NULL,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(43,108,'2026-04-07','00:00:00','16:33:33',993,'present','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(44,107,'2026-04-07','08:35:53','16:32:31',476,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(45,110,'2026-04-07','09:48:46','19:56:18',607,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(46,107,'2026-04-08','08:30:02','16:43:38',493,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(47,108,'2026-04-08','08:30:07','16:39:33',489,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(48,110,'2026-04-08','11:44:02','18:04:06',380,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(49,107,'2026-04-09','08:38:18','17:20:11',521,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(50,108,'2026-04-09','08:38:23','17:18:04',519,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(51,110,'2026-04-09','10:20:59','19:18:23',537,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(52,110,'2026-04-10','12:32:28',NULL,NULL,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(53,110,'2026-04-11','00:44:08','11:38:19',654,'present','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(54,110,'2026-04-12','08:25:55','18:16:35',590,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(55,107,'2026-04-12','08:41:31','16:44:56',483,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(56,108,'2026-04-12','08:41:41','16:45:19',483,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(57,107,'2026-04-13','08:37:46','16:12:07',454,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(58,108,'2026-04-13','09:06:38','16:12:29',425,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(59,110,'2026-04-13','18:39:24',NULL,NULL,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(60,108,'2026-04-14','08:36:06','16:39:29',483,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(61,107,'2026-04-14','08:36:10','16:40:23',484,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(62,110,'2026-04-14','10:05:20','17:44:20',459,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(63,107,'2026-04-15','08:32:29','16:51:00',498,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(64,110,'2026-04-15','10:29:52','18:10:06',460,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(65,108,'2026-04-15','13:12:17','16:57:40',225,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(66,107,'2026-04-16','08:35:28','16:59:29',504,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(67,108,'2026-04-16','08:35:32','16:34:54',479,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(68,110,'2026-04-16','10:33:56','21:56:04',682,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(69,108,'2026-04-19','16:33:23',NULL,NULL,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(70,107,'2026-04-19','16:38:29',NULL,NULL,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(71,110,'2026-04-19','16:52:31','16:52:34',0,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(72,107,'2026-04-20','08:36:25','16:39:16',482,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(73,108,'2026-04-20','08:36:29','16:37:39',481,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(74,110,'2026-04-20','09:40:38','17:37:15',476,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(75,107,'2026-04-21','08:36:21','16:30:07',473,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(76,108,'2026-04-21','08:36:27','16:30:04',473,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(77,110,'2026-04-21','10:58:06','17:12:10',374,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(78,107,'2026-04-22','08:35:23','16:39:16',483,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(79,108,'2026-04-22','08:35:28','16:38:43',483,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(80,110,'2026-04-22','10:23:09','21:11:22',648,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(81,107,'2026-04-23','08:42:24','16:40:46',478,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(82,108,'2026-04-23','08:42:31','16:38:13',475,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(83,110,'2026-04-23','10:11:07','17:48:52',457,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(84,110,'2026-04-25','13:29:40','16:10:26',160,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(85,107,'2026-04-26','08:39:38','16:46:04',486,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(86,108,'2026-04-26','08:39:43','16:45:59',486,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(87,110,'2026-04-26','11:28:48','18:30:15',421,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(88,107,'2026-04-27','08:50:22','16:46:02',475,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(89,108,'2026-04-27','08:50:30','16:45:08',474,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(90,110,'2026-04-27','10:53:17','18:24:36',451,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(91,107,'2026-04-28','08:42:14','16:37:41',475,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(92,108,'2026-04-28','08:42:17','16:37:48',475,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(93,110,'2026-04-28','17:32:33',NULL,NULL,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(94,108,'2026-04-29','08:38:02','16:48:22',490,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(95,107,'2026-04-29','08:38:04','16:48:18',490,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(96,110,'2026-04-29','10:43:12','22:42:14',719,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(97,107,'2026-04-30','08:33:23','16:40:40',487,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(98,108,'2026-04-30','08:33:27','16:41:27',488,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(99,110,'2026-04-30','09:39:26','18:40:20',540,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(100,108,'2026-05-03','08:35:25','16:35:02',479,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(101,110,'2026-05-03','12:05:41','17:40:56',335,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(102,107,'2026-05-04','08:35:35','16:32:53',477,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(103,108,'2026-05-04','08:35:38','16:32:57',477,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(104,110,'2026-05-04','10:38:33','17:31:58',413,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(105,107,'2026-05-05','08:41:32','16:11:27',449,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(106,108,'2026-05-05','08:41:36','16:11:55',450,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(107,110,'2026-05-05','10:19:25','18:11:51',472,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(108,108,'2026-05-06','08:58:14','16:54:44',476,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(109,107,'2026-05-06','08:58:17','16:30:18',452,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(110,110,'2026-05-06','09:30:02','09:30:05',0,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(111,107,'2026-05-07','08:46:14','17:11:10',504,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(112,108,'2026-05-07','08:46:20','16:46:50',480,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(113,110,'2026-05-07','09:59:27','18:26:23',506,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(114,107,'2026-05-10','08:38:39','16:36:46',478,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(115,108,'2026-05-10','08:38:43','16:38:15',479,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(116,110,'2026-05-10','09:54:55','17:58:02',483,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(117,108,'2026-05-11','08:42:11','16:36:24',474,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(118,107,'2026-05-11','08:42:20','16:36:50',474,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(119,110,'2026-05-11','10:43:02','18:13:14',450,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(120,107,'2026-05-12','08:41:42','16:38:09',476,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(121,108,'2026-05-12','08:41:53','16:42:18',480,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(122,110,'2026-05-12','10:11:16','19:35:13',563,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(123,107,'2026-05-13','08:34:13','17:09:23',515,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(124,108,'2026-05-13','08:34:16','17:09:26',515,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(125,110,'2026-05-13','10:59:15','19:06:30',487,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(126,107,'2026-05-14','08:38:17','16:04:28',446,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(127,108,'2026-05-14','08:38:20','16:08:09',449,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57'),(128,110,'2026-05-14','11:04:36','17:56:28',411,'late','api',NULL,'Synced from Biotime',NULL,'2026-06-18 10:50:57','2026-06-18 10:50:57');
/*!40000 ALTER TABLE `attendance_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `birthday_wish_deliveries`
--

DROP TABLE IF EXISTS `birthday_wish_deliveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `birthday_wish_deliveries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `birthday_year` smallint(5) unsigned NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `recipient_email` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `error` text DEFAULT NULL,
  `sent_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `birthday_wish_deliveries_employee_id_birthday_year_unique` (`employee_id`,`birthday_year`),
  CONSTRAINT `birthday_wish_deliveries_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `birthday_wish_deliveries`
--

LOCK TABLES `birthday_wish_deliveries` WRITE;
/*!40000 ALTER TABLE `birthday_wish_deliveries` DISABLE KEYS */;
INSERT INTO `birthday_wish_deliveries` VALUES (2,115,2026,'sent','m.azher@dbroker.com.sa','Happy Birthday, Azher Mohammed!',NULL,'2026-06-22 07:29:50','2026-06-22 07:29:45','2026-06-22 07:29:50');
/*!40000 ALTER TABLE `birthday_wish_deliveries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_renewal_requests`
--

DROP TABLE IF EXISTS `contract_renewal_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract_renewal_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` bigint(20) unsigned NOT NULL,
  `employee_id` bigint(20) unsigned NOT NULL,
  `reference` varchar(60) NOT NULL,
  `proposed_start_date` date NOT NULL,
  `proposed_end_date` date DEFAULT NULL,
  `proposed_salary` decimal(12,2) DEFAULT NULL,
  `proposed_type` varchar(30) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `document_path` varchar(500) DEFAULT NULL,
  `document_name` varchar(255) DEFAULT NULL,
  `document_mime` varchar(100) DEFAULT NULL,
  `document_size` bigint(20) unsigned DEFAULT NULL,
  `status` enum('pending','manager_approved','hr_approved','approved','rejected','cancelled') NOT NULL DEFAULT 'pending',
  `manager_id` bigint(20) unsigned DEFAULT NULL,
  `manager_approved_by` bigint(20) unsigned DEFAULT NULL,
  `manager_approved_at` timestamp NULL DEFAULT NULL,
  `manager_notes` text DEFAULT NULL,
  `hr_approved_by` bigint(20) unsigned DEFAULT NULL,
  `hr_approved_at` timestamp NULL DEFAULT NULL,
  `hr_notes` text DEFAULT NULL,
  `ceo_approved_by` bigint(20) unsigned DEFAULT NULL,
  `ceo_approved_at` timestamp NULL DEFAULT NULL,
  `ceo_notes` text DEFAULT NULL,
  `rejected_by` bigint(20) unsigned DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `rejected_stage` varchar(20) DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `new_contract_id` bigint(20) unsigned DEFAULT NULL,
  `auto_generated` tinyint(1) NOT NULL DEFAULT 1,
  `notified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contract_renewal_requests_reference_unique` (`reference`),
  KEY `contract_renewal_requests_new_contract_id_foreign` (`new_contract_id`),
  KEY `contract_renewal_requests_contract_id_status_index` (`contract_id`,`status`),
  KEY `contract_renewal_requests_employee_id_status_index` (`employee_id`,`status`),
  KEY `contract_renewal_requests_status_index` (`status`),
  CONSTRAINT `contract_renewal_requests_contract_id_foreign` FOREIGN KEY (`contract_id`) REFERENCES `employee_contracts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `contract_renewal_requests_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `contract_renewal_requests_new_contract_id_foreign` FOREIGN KEY (`new_contract_id`) REFERENCES `employee_contracts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_renewal_requests`
--

LOCK TABLES `contract_renewal_requests` WRITE;
/*!40000 ALTER TABLE `contract_renewal_requests` DISABLE KEYS */;
INSERT INTO `contract_renewal_requests` VALUES (1,3,107,'RNW-2026-00001','2026-04-21','2027-04-20',10000.00,'full_time','need this employee',NULL,NULL,NULL,NULL,'approved',111,289,'2026-06-23 08:55:46','s dsds d sdsdsd sdsd',287,'2026-06-23 09:10:50','he is one of the best staff in our department. We need his service for future acheivement.',289,'2026-06-23 09:11:40','Ok, i approved',NULL,NULL,NULL,NULL,NULL,0,'2026-06-23 08:51:41','2026-06-23 08:51:41','2026-06-23 09:11:40',NULL),(2,4,107,'RNW-2026-00002','2026-08-23','2027-08-22',10000.00,'full_time','Auto-generated: contract CTR-2026-00002 expires on 2026-08-22. 60-day renewal window triggered.',NULL,NULL,NULL,NULL,'hr_approved',111,287,'2026-06-23 10:23:30','ds dsd s fggfg fgf gfg fgh fgfgf gfg',287,'2026-06-23 10:23:48','fgf gfgfgfgfgf',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-06-23 10:21:46','2026-06-23 10:21:46','2026-06-23 10:23:48',NULL);
/*!40000 ALTER TABLE `contract_renewal_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_renewals`
--

DROP TABLE IF EXISTS `contract_renewals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract_renewals` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` bigint(20) unsigned NOT NULL,
  `proposed_start_date` date DEFAULT NULL,
  `proposed_end_date` date DEFAULT NULL,
  `status` enum('pending_manager','pending_hr','pending_ceo','approved','rejected') NOT NULL DEFAULT 'pending_manager',
  `rejected_at_stage` varchar(255) DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `requested_by` bigint(20) unsigned DEFAULT NULL,
  `auto_created` tinyint(1) NOT NULL DEFAULT 0,
  `manager_approver_id` bigint(20) unsigned DEFAULT NULL,
  `hr_approver_id` bigint(20) unsigned DEFAULT NULL,
  `ceo_approver_id` bigint(20) unsigned DEFAULT NULL,
  `manager_approved_at` timestamp NULL DEFAULT NULL,
  `hr_approved_at` timestamp NULL DEFAULT NULL,
  `ceo_approved_at` timestamp NULL DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contract_renewals_requested_by_foreign` (`requested_by`),
  KEY `contract_renewals_manager_approver_id_foreign` (`manager_approver_id`),
  KEY `contract_renewals_hr_approver_id_foreign` (`hr_approver_id`),
  KEY `contract_renewals_ceo_approver_id_foreign` (`ceo_approver_id`),
  KEY `contract_renewals_contract_id_status_index` (`contract_id`,`status`),
  KEY `contract_renewals_status_index` (`status`),
  CONSTRAINT `contract_renewals_ceo_approver_id_foreign` FOREIGN KEY (`ceo_approver_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `contract_renewals_contract_id_foreign` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `contract_renewals_hr_approver_id_foreign` FOREIGN KEY (`hr_approver_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `contract_renewals_manager_approver_id_foreign` FOREIGN KEY (`manager_approver_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `contract_renewals_requested_by_foreign` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_renewals`
--

LOCK TABLES `contract_renewals` WRITE;
/*!40000 ALTER TABLE `contract_renewals` DISABLE KEYS */;
/*!40000 ALTER TABLE `contract_renewals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contracts`
--

DROP TABLE IF EXISTS `contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contracts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `contract_type` enum('fixed','unlimited','part_time','freelance') NOT NULL DEFAULT 'fixed',
  `position` varchar(255) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `probation_end` date DEFAULT NULL,
  `salary` decimal(12,2) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `renewal_notified` tinyint(1) NOT NULL DEFAULT 0,
  `renewal_requested` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contracts_employee_id_is_active_index` (`employee_id`,`is_active`),
  KEY `contracts_end_date_index` (`end_date`),
  CONSTRAINT `contracts_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contracts`
--

LOCK TABLES `contracts` WRITE;
/*!40000 ALTER TABLE `contracts` DISABLE KEYS */;
/*!40000 ALTER TABLE `contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_excuse_limits`
--

DROP TABLE IF EXISTS `department_excuse_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_excuse_limits` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `department_id` bigint(20) unsigned NOT NULL,
  `leave_type_id` bigint(20) unsigned NOT NULL,
  `monthly_hours_limit` decimal(5,2) DEFAULT NULL COMMENT 'NULL = unlimited. Set a value to cap hours per month.',
  `is_limited` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'false = unlimited regardless of monthly_hours_limit',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dept_leavetype_unique` (`department_id`,`leave_type_id`),
  KEY `department_excuse_limits_leave_type_id_foreign` (`leave_type_id`),
  CONSTRAINT `department_excuse_limits_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `department_excuse_limits_leave_type_id_foreign` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_excuse_limits`
--

LOCK TABLES `department_excuse_limits` WRITE;
/*!40000 ALTER TABLE `department_excuse_limits` DISABLE KEYS */;
/*!40000 ALTER TABLE `department_excuse_limits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` text DEFAULT NULL,
  `parent_id` bigint(20) unsigned DEFAULT NULL,
  `manager_id` bigint(20) unsigned DEFAULT NULL,
  `headcount_budget` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `departments_code_unique` (`code`),
  KEY `departments_parent_id_foreign` (`parent_id`),
  CONSTRAINT `departments_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (2,'Human Resources','HR',NULL,NULL,NULL,10,1,'2026-04-12 07:14:15','2026-04-12 07:14:15',NULL),(3,'Information Technology','IT',NULL,NULL,NULL,20,1,'2026-04-12 07:14:15','2026-04-12 07:14:15',NULL),(4,'Finance','FIN',NULL,NULL,NULL,8,1,'2026-04-12 07:14:15','2026-04-12 07:14:15',NULL),(5,'Operations','OPS',NULL,NULL,NULL,25,1,'2026-04-12 07:14:15','2026-04-12 07:14:15',NULL),(6,'Sales & Marketing','SM',NULL,NULL,NULL,15,1,'2026-04-12 07:14:15','2026-04-12 07:14:15',NULL),(7,'Legal & Compliance','LEG',NULL,NULL,NULL,5,1,'2026-04-12 07:14:15','2026-04-12 07:14:15',NULL),(8,'Executive','EXE',NULL,NULL,NULL,3,1,'2026-04-12 07:14:15','2026-04-12 07:14:15',NULL),(9,'Technical','TE','technical',NULL,NULL,1,1,'2026-06-18 10:07:16','2026-06-18 10:07:16',NULL),(10,'Quality','QTY','Quality department',NULL,NULL,6,1,'2026-06-18 10:09:05','2026-06-18 10:09:05',NULL);
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `designations`
--

DROP TABLE IF EXISTS `designations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `designations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `level` varchar(50) DEFAULT NULL,
  `department_id` bigint(20) unsigned DEFAULT NULL,
  `min_salary` decimal(12,2) DEFAULT NULL,
  `max_salary` decimal(12,2) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `designations_department_id_foreign` (`department_id`),
  CONSTRAINT `designations_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `designations`
--

LOCK TABLES `designations` WRITE;
/*!40000 ALTER TABLE `designations` DISABLE KEYS */;
INSERT INTO `designations` VALUES (1,'Chief Executive Officer','executive',8,NULL,NULL,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(2,'Chief Technology Officer','executive',3,NULL,NULL,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(3,'HR Manager','management',2,NULL,NULL,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(4,'HR Officer','staff',2,NULL,NULL,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(5,'Software Engineer','staff',3,NULL,NULL,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(6,'Senior Software Engineer','senior',3,NULL,NULL,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(7,'Finance Manager','management',4,NULL,NULL,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(8,'Accountant','staff',4,NULL,NULL,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(9,'Operations Manager','management',5,NULL,NULL,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(10,'Operations Coordinator','staff',5,NULL,NULL,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(11,'IT Supervisor','manager',3,NULL,NULL,1,'2026-06-18 10:16:20','2026-06-18 10:16:20'),(12,'Technical Manager','manager',9,NULL,NULL,1,'2026-06-18 13:22:42','2026-06-18 13:22:42'),(13,'Technical Lead','lead',9,NULL,NULL,1,'2026-06-18 13:32:13','2026-06-18 13:32:13'),(14,'IT Developer','mid',3,NULL,NULL,1,'2026-06-24 12:51:04','2026-06-24 12:51:04');
/*!40000 ALTER TABLE `designations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_attendance_logs`
--

DROP TABLE IF EXISTS `device_attendance_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_attendance_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` bigint(20) unsigned NOT NULL,
  `device_employee_number` varchar(50) NOT NULL,
  `employee_id` bigint(20) unsigned DEFAULT NULL,
  `punch_time` datetime NOT NULL,
  `punch_type` tinyint(4) NOT NULL DEFAULT 0,
  `verification_mode` varchar(20) DEFAULT NULL,
  `processed` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dal_device_empno_punchtime_unique` (`device_id`,`device_employee_number`,`punch_time`),
  KEY `device_attendance_logs_device_employee_number_punch_time_index` (`device_employee_number`,`punch_time`),
  KEY `device_attendance_logs_employee_id_punch_time_index` (`employee_id`,`punch_time`),
  CONSTRAINT `device_attendance_logs_device_id_foreign` FOREIGN KEY (`device_id`) REFERENCES `attendance_devices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `device_attendance_logs_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=257 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_attendance_logs`
--

LOCK TABLES `device_attendance_logs` WRITE;
/*!40000 ALTER TABLE `device_attendance_logs` DISABLE KEYS */;
INSERT INTO `device_attendance_logs` VALUES (1,1,'129',107,'2026-06-18 13:42:58',0,NULL,1,'2026-06-18 10:42:58','2026-06-18 10:42:58'),(3,1,'129',107,'2026-06-17 08:42:07',0,NULL,1,'2026-06-18 10:44:57','2026-06-18 10:48:19'),(4,1,'182',108,'2026-06-17 08:42:11',0,NULL,1,'2026-06-18 10:44:57','2026-06-18 10:48:19'),(5,1,'158',110,'2026-06-17 09:41:33',0,NULL,1,'2026-06-18 10:44:57','2026-06-18 10:48:19'),(6,1,'129',107,'2026-06-17 16:32:49',0,NULL,1,'2026-06-18 10:44:57','2026-06-18 10:48:19'),(7,1,'182',108,'2026-06-17 16:32:54',0,NULL,1,'2026-06-18 10:44:57','2026-06-18 10:48:19'),(8,1,'158',110,'2026-06-17 17:16:20',0,NULL,1,'2026-06-18 10:44:57','2026-06-18 10:48:19'),(9,1,'129',107,'2026-06-16 08:50:52',0,NULL,1,'2026-06-18 10:45:13','2026-06-18 10:48:19'),(10,1,'182',108,'2026-06-16 08:51:10',0,NULL,1,'2026-06-18 10:45:13','2026-06-18 10:48:19'),(11,1,'158',110,'2026-06-16 10:44:41',0,NULL,1,'2026-06-18 10:45:13','2026-06-18 10:48:19'),(12,1,'129',107,'2026-06-16 16:46:36',0,NULL,1,'2026-06-18 10:45:13','2026-06-18 10:48:19'),(13,1,'182',108,'2026-06-16 16:48:00',0,NULL,1,'2026-06-18 10:45:13','2026-06-18 10:48:19'),(14,1,'158',110,'2026-06-16 18:30:30',0,NULL,1,'2026-06-18 10:45:13','2026-06-18 10:48:19'),(15,1,'129',107,'2026-06-15 08:42:24',0,NULL,1,'2026-06-18 10:46:13','2026-06-18 10:48:19'),(16,1,'182',108,'2026-06-15 08:42:28',0,NULL,1,'2026-06-18 10:46:13','2026-06-18 10:48:19'),(17,1,'158',110,'2026-06-15 10:24:10',0,NULL,1,'2026-06-18 10:46:13','2026-06-18 10:48:19'),(18,1,'182',108,'2026-06-15 16:31:56',0,NULL,1,'2026-06-18 10:46:13','2026-06-18 10:48:19'),(19,1,'129',107,'2026-06-15 16:40:04',0,NULL,1,'2026-06-18 10:46:13','2026-06-18 10:48:19'),(20,1,'158',110,'2026-06-15 17:36:19',0,NULL,1,'2026-06-18 10:46:13','2026-06-18 10:48:19'),(21,1,'129',107,'2026-06-18 08:42:03',0,NULL,1,'2026-06-18 10:48:19','2026-06-18 10:48:19'),(22,1,'182',108,'2026-06-20 08:42:06',0,NULL,1,'2026-06-20 10:48:19','2026-06-20 10:48:19'),(23,1,'129',107,'2026-06-11 08:38:35',0,NULL,1,'2026-06-18 10:49:45','2026-06-18 10:49:45'),(24,1,'182',108,'2026-06-11 08:38:38',0,NULL,1,'2026-06-18 10:49:45','2026-06-18 10:49:45'),(25,1,'158',110,'2026-06-11 10:29:45',0,NULL,1,'2026-06-18 10:49:45','2026-06-18 10:49:45'),(26,1,'182',108,'2026-06-11 17:36:45',0,NULL,1,'2026-06-18 10:49:45','2026-06-18 10:49:45'),(27,1,'129',107,'2026-06-11 17:39:24',0,NULL,1,'2026-06-18 10:49:45','2026-06-18 10:49:45'),(28,1,'158',110,'2026-06-11 17:48:11',0,NULL,1,'2026-06-18 10:49:45','2026-06-18 10:49:45'),(29,1,'182',108,'2026-06-07 08:38:36',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(30,1,'129',107,'2026-06-07 08:38:50',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(31,1,'158',110,'2026-06-07 10:58:55',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(32,1,'129',107,'2026-06-07 16:40:15',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(33,1,'182',108,'2026-06-07 16:43:22',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(34,1,'158',110,'2026-06-07 17:24:14',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(35,1,'182',108,'2026-06-08 08:37:10',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(36,1,'129',107,'2026-06-08 08:37:15',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(37,1,'158',110,'2026-06-08 10:27:40',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(38,1,'182',108,'2026-06-08 16:43:00',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(39,1,'129',107,'2026-06-08 16:48:44',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(40,1,'158',110,'2026-06-08 20:16:57',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(41,1,'158',110,'2026-06-08 20:36:22',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(42,1,'129',107,'2026-06-09 08:36:40',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(43,1,'182',108,'2026-06-09 08:36:42',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(44,1,'158',110,'2026-06-09 10:23:31',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(45,1,'182',108,'2026-06-09 16:56:53',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(46,1,'129',107,'2026-06-09 16:59:50',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(47,1,'158',110,'2026-06-09 17:42:49',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(48,1,'129',107,'2026-06-10 08:49:09',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(49,1,'182',108,'2026-06-10 08:49:14',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(50,1,'182',108,'2026-06-10 16:36:18',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(51,1,'129',107,'2026-06-10 16:36:36',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(52,1,'158',110,'2026-06-10 17:51:31',0,NULL,1,'2026-06-18 10:50:04','2026-06-18 10:50:04'),(53,1,'182',108,'2026-04-07 00:00:00',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(54,1,'182',108,'2026-04-01 08:40:55',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(55,1,'129',107,'2026-04-01 08:40:58',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(56,1,'129',107,'2026-04-01 16:22:18',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(57,1,'182',108,'2026-04-01 16:22:44',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(58,1,'4',109,'2026-04-01 17:03:58',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(59,1,'129',107,'2026-04-02 08:38:36',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(60,1,'182',108,'2026-04-02 08:38:39',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(61,1,'129',107,'2026-04-02 16:20:05',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(62,1,'182',108,'2026-04-02 16:20:09',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(63,1,'158',110,'2026-04-03 23:58:12',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(64,1,'158',110,'2026-04-04 22:30:29',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(65,1,'158',110,'2026-04-05 01:02:40',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(66,1,'129',107,'2026-04-05 08:34:11',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(67,1,'182',108,'2026-04-05 08:34:15',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(68,1,'158',110,'2026-04-05 09:57:51',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(69,1,'4',109,'2026-04-05 16:05:30',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(70,1,'182',108,'2026-04-05 16:45:00',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(71,1,'129',107,'2026-04-05 16:45:53',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(72,1,'158',110,'2026-04-05 19:03:42',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(73,1,'129',107,'2026-04-06 08:34:43',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(74,1,'182',108,'2026-04-06 08:34:47',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(75,1,'158',110,'2026-04-06 09:43:30',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(76,1,'4',109,'2026-04-06 13:41:31',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(77,1,'182',108,'2026-04-06 16:37:23',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(78,1,'129',107,'2026-04-06 16:37:27',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(79,1,'158',110,'2026-04-06 17:49:55',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(80,1,'129',107,'2026-04-07 08:35:53',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(81,1,'182',108,'2026-04-07 08:35:58',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(82,1,'158',110,'2026-04-07 09:48:46',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(83,1,'129',107,'2026-04-07 16:32:31',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(84,1,'182',108,'2026-04-07 16:33:33',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(85,1,'158',110,'2026-04-07 19:56:18',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(86,1,'129',107,'2026-04-08 08:30:02',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(87,1,'182',108,'2026-04-08 08:30:07',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(88,1,'158',110,'2026-04-08 11:44:02',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(89,1,'182',108,'2026-04-08 16:39:33',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(90,1,'129',107,'2026-04-08 16:43:38',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(91,1,'158',110,'2026-04-08 18:04:06',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(92,1,'129',107,'2026-04-09 08:38:18',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(93,1,'182',108,'2026-04-09 08:38:23',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(94,1,'158',110,'2026-04-09 10:20:59',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(95,1,'182',108,'2026-04-09 17:18:04',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(96,1,'129',107,'2026-04-09 17:20:11',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(97,1,'158',110,'2026-04-09 19:18:21',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(98,1,'158',110,'2026-04-09 19:18:23',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(99,1,'158',110,'2026-04-10 12:32:28',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(100,1,'158',110,'2026-04-11 00:44:08',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(101,1,'158',110,'2026-04-11 11:38:19',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(102,1,'158',110,'2026-04-12 08:25:55',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(103,1,'129',107,'2026-04-12 08:41:31',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(104,1,'182',108,'2026-04-12 08:41:41',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(105,1,'129',107,'2026-04-12 16:44:56',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(106,1,'182',108,'2026-04-12 16:45:19',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(107,1,'158',110,'2026-04-12 18:16:35',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(108,1,'129',107,'2026-04-13 08:37:46',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(109,1,'182',108,'2026-04-13 09:06:38',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(110,1,'129',107,'2026-04-13 16:12:07',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(111,1,'182',108,'2026-04-13 16:12:29',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(112,1,'158',110,'2026-04-13 18:39:24',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(113,1,'182',108,'2026-04-14 08:36:06',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(114,1,'129',107,'2026-04-14 08:36:10',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(115,1,'158',110,'2026-04-14 10:05:20',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(116,1,'182',108,'2026-04-14 16:39:29',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(117,1,'129',107,'2026-04-14 16:40:23',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(118,1,'158',110,'2026-04-14 17:44:20',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(119,1,'129',107,'2026-04-15 08:32:29',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(120,1,'158',110,'2026-04-15 10:29:52',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(121,1,'182',108,'2026-04-15 13:12:17',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(122,1,'129',107,'2026-04-15 16:51:00',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(123,1,'182',108,'2026-04-15 16:57:40',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(124,1,'158',110,'2026-04-15 18:10:06',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(125,1,'129',107,'2026-04-16 08:35:28',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(126,1,'182',108,'2026-04-16 08:35:32',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(127,1,'158',110,'2026-04-16 10:33:56',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(128,1,'182',108,'2026-04-16 16:34:54',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(129,1,'129',107,'2026-04-16 16:59:29',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(130,1,'158',110,'2026-04-16 21:56:04',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(131,1,'182',108,'2026-04-19 16:33:23',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(132,1,'129',107,'2026-04-19 16:38:29',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(133,1,'158',110,'2026-04-19 16:52:31',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(134,1,'158',110,'2026-04-19 16:52:34',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(135,1,'129',107,'2026-04-20 08:36:25',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(136,1,'182',108,'2026-04-20 08:36:29',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(137,1,'158',110,'2026-04-20 09:40:38',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(138,1,'182',108,'2026-04-20 16:37:39',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(139,1,'129',107,'2026-04-20 16:39:16',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(140,1,'158',110,'2026-04-20 17:37:15',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(141,1,'129',107,'2026-04-21 08:36:21',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(142,1,'182',108,'2026-04-21 08:36:27',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(143,1,'158',110,'2026-04-21 10:58:06',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(144,1,'182',108,'2026-04-21 16:30:04',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(145,1,'129',107,'2026-04-21 16:30:07',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(146,1,'158',110,'2026-04-21 17:12:10',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(147,1,'129',107,'2026-04-22 08:35:23',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(148,1,'182',108,'2026-04-22 08:35:28',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(149,1,'158',110,'2026-04-22 10:23:09',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(150,1,'182',108,'2026-04-22 16:38:43',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(151,1,'129',107,'2026-04-22 16:39:16',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(152,1,'158',110,'2026-04-22 21:10:28',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(153,1,'158',110,'2026-04-22 21:11:22',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:56'),(154,1,'129',107,'2026-04-23 08:42:24',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(155,1,'182',108,'2026-04-23 08:42:31',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(156,1,'158',110,'2026-04-23 10:11:07',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(157,1,'182',108,'2026-04-23 16:38:13',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(158,1,'129',107,'2026-04-23 16:40:46',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(159,1,'158',110,'2026-04-23 17:48:52',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(160,1,'158',110,'2026-04-25 13:29:40',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(161,1,'158',110,'2026-04-25 16:10:26',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(162,1,'129',107,'2026-04-26 08:39:38',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(163,1,'182',108,'2026-04-26 08:39:43',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(164,1,'158',110,'2026-04-26 11:28:48',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(165,1,'158',110,'2026-04-26 11:28:50',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(166,1,'182',108,'2026-04-26 14:15:18',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(167,1,'182',108,'2026-04-26 16:45:59',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(168,1,'129',107,'2026-04-26 16:46:04',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(169,1,'158',110,'2026-04-26 18:30:15',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(170,1,'129',107,'2026-04-27 08:50:22',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(171,1,'182',108,'2026-04-27 08:50:30',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(172,1,'158',110,'2026-04-27 10:53:17',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(173,1,'182',108,'2026-04-27 16:45:08',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(174,1,'129',107,'2026-04-27 16:46:00',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(175,1,'129',107,'2026-04-27 16:46:02',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(176,1,'158',110,'2026-04-27 17:18:22',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(177,1,'158',110,'2026-04-27 18:24:36',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(178,1,'129',107,'2026-04-28 08:42:14',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(179,1,'182',108,'2026-04-28 08:42:17',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(180,1,'129',107,'2026-04-28 16:37:41',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(181,1,'182',108,'2026-04-28 16:37:48',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(182,1,'158',110,'2026-04-28 17:32:33',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(183,1,'182',108,'2026-04-29 08:38:02',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(184,1,'129',107,'2026-04-29 08:38:04',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(185,1,'158',110,'2026-04-29 10:43:12',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(186,1,'129',107,'2026-04-29 16:48:18',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(187,1,'182',108,'2026-04-29 16:48:22',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(188,1,'158',110,'2026-04-29 22:42:14',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(189,1,'129',107,'2026-04-30 08:33:23',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(190,1,'182',108,'2026-04-30 08:33:27',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(191,1,'158',110,'2026-04-30 09:39:26',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(192,1,'158',110,'2026-04-30 09:39:29',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(193,1,'129',107,'2026-04-30 16:40:40',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(194,1,'182',108,'2026-04-30 16:41:27',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(195,1,'158',110,'2026-04-30 18:40:20',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(196,1,'182',108,'2026-05-03 08:35:25',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(197,1,'158',110,'2026-05-03 12:05:41',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(198,1,'182',108,'2026-05-03 16:35:02',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(199,1,'158',110,'2026-05-03 17:40:56',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(200,1,'129',107,'2026-05-04 08:35:35',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(201,1,'182',108,'2026-05-04 08:35:38',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(202,1,'158',110,'2026-05-04 10:38:33',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(203,1,'129',107,'2026-05-04 16:32:53',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(204,1,'182',108,'2026-05-04 16:32:57',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(205,1,'158',110,'2026-05-04 17:31:58',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(206,1,'129',107,'2026-05-05 08:41:32',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(207,1,'182',108,'2026-05-05 08:41:36',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(208,1,'158',110,'2026-05-05 10:19:25',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(209,1,'129',107,'2026-05-05 16:11:27',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(210,1,'182',108,'2026-05-05 16:11:55',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(211,1,'158',110,'2026-05-05 18:11:51',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(212,1,'182',108,'2026-05-06 08:58:14',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(213,1,'129',107,'2026-05-06 08:58:17',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(214,1,'158',110,'2026-05-06 09:30:02',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(215,1,'158',110,'2026-05-06 09:30:05',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(216,1,'129',107,'2026-05-06 16:30:18',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(217,1,'182',108,'2026-05-06 16:54:44',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(218,1,'129',107,'2026-05-07 08:46:14',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(219,1,'182',108,'2026-05-07 08:46:20',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(220,1,'158',110,'2026-05-07 09:59:27',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(221,1,'182',108,'2026-05-07 16:46:50',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(222,1,'129',107,'2026-05-07 17:11:10',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(223,1,'158',110,'2026-05-07 18:26:23',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(224,1,'129',107,'2026-05-10 08:38:39',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(225,1,'182',108,'2026-05-10 08:38:43',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(226,1,'158',110,'2026-05-10 09:54:55',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(227,1,'129',107,'2026-05-10 16:36:46',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(228,1,'182',108,'2026-05-10 16:38:15',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(229,1,'158',110,'2026-05-10 17:58:02',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(230,1,'182',108,'2026-05-11 08:42:11',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(231,1,'129',107,'2026-05-11 08:42:20',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(232,1,'158',110,'2026-05-11 10:43:02',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(233,1,'182',108,'2026-05-11 16:36:24',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(234,1,'129',107,'2026-05-11 16:36:50',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(235,1,'158',110,'2026-05-11 18:13:14',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(236,1,'129',107,'2026-05-12 08:41:42',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(237,1,'129',107,'2026-05-12 08:41:50',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(238,1,'182',108,'2026-05-12 08:41:53',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(239,1,'158',110,'2026-05-12 10:11:16',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(240,1,'129',107,'2026-05-12 16:38:07',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(241,1,'129',107,'2026-05-12 16:38:09',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(242,1,'182',108,'2026-05-12 16:42:18',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(243,1,'158',110,'2026-05-12 19:35:13',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(244,1,'129',107,'2026-05-13 08:34:13',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(245,1,'182',108,'2026-05-13 08:34:16',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(246,1,'158',110,'2026-05-13 10:59:15',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(247,1,'129',107,'2026-05-13 17:09:23',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(248,1,'182',108,'2026-05-13 17:09:26',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(249,1,'158',110,'2026-05-13 19:06:30',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(250,1,'129',107,'2026-05-14 08:38:17',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(251,1,'182',108,'2026-05-14 08:38:20',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(252,1,'158',110,'2026-05-14 11:04:36',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(253,1,'129',107,'2026-05-14 16:04:28',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(254,1,'182',108,'2026-05-14 16:08:09',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57'),(255,1,'158',110,'2026-05-14 17:56:28',0,NULL,1,'2026-06-18 10:50:56','2026-06-18 10:50:57');
/*!40000 ALTER TABLE `device_attendance_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_contracts`
--

DROP TABLE IF EXISTS `employee_contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_contracts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `reference` varchar(50) NOT NULL,
  `type` enum('full_time','part_time','contract','intern','probation','fixed_term','unlimited') NOT NULL DEFAULT 'full_time',
  `status` enum('draft','active','expired','terminated','cancelled') NOT NULL DEFAULT 'draft',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `salary` decimal(12,2) DEFAULT NULL,
  `currency` varchar(3) NOT NULL DEFAULT 'SAR',
  `position` varchar(150) DEFAULT NULL,
  `department_id` bigint(20) unsigned DEFAULT NULL,
  `terms` text DEFAULT NULL,
  `pdf_path` varchar(500) DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `approved_by` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `renewal_requested` tinyint(1) NOT NULL DEFAULT 0,
  `renewal_notified` tinyint(1) NOT NULL DEFAULT 0,
  `annual_leave_reminder_sent_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_contracts_reference_unique` (`reference`),
  KEY `employee_contracts_department_id_foreign` (`department_id`),
  KEY `employee_contracts_created_by_foreign` (`created_by`),
  KEY `employee_contracts_approved_by_foreign` (`approved_by`),
  KEY `employee_contracts_employee_id_status_index` (`employee_id`,`status`),
  KEY `employee_contracts_status_index` (`status`),
  CONSTRAINT `employee_contracts_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employee_contracts_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employee_contracts_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employee_contracts_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_contracts`
--

LOCK TABLES `employee_contracts` WRITE;
/*!40000 ALTER TABLE `employee_contracts` DISABLE KEYS */;
INSERT INTO `employee_contracts` VALUES (3,107,'CTR-2026-00001','full_time','active','2025-03-21','2026-03-20',10000.00,'SAR','IT supervisor',3,'fffffffffffffffffff','contracts/documents/Lp5lGerhauL8D0tvFYSpbL6meUH5tVMwBXY1ed5B.pdf',284,284,'2026-06-21 12:44:52','2026-06-21 12:41:18','2026-06-22 12:15:46',NULL,0,0,NULL),(4,107,'CTR-2026-00002','full_time','active','2026-04-21','2026-08-22',10000.00,'SAR','IT Supervisor',3,NULL,NULL,284,284,'2026-06-23 10:21:35','2026-06-23 08:46:21','2026-06-23 10:21:35',NULL,0,0,NULL);
/*!40000 ALTER TABLE `employee_contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_dependents`
--

DROP TABLE IF EXISTS `employee_dependents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_dependents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `relationship` varchar(30) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `nationality` varchar(100) DEFAULT NULL,
  `id_number` varchar(50) DEFAULT NULL,
  `id_expiry` date DEFAULT NULL,
  `passport_number` varchar(50) DEFAULT NULL,
  `passport_expiry` date DEFAULT NULL,
  `passport_file_path` varchar(255) DEFAULT NULL,
  `passport_file_name` varchar(255) DEFAULT NULL,
  `id_file_path` varchar(255) DEFAULT NULL,
  `id_file_name` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_dependents_employee_id_foreign` (`employee_id`),
  CONSTRAINT `employee_dependents_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_dependents`
--

LOCK TABLES `employee_dependents` WRITE;
/*!40000 ALTER TABLE `employee_dependents` DISABLE KEYS */;
INSERT INTO `employee_dependents` VALUES (5,108,'Hannah Maria','daughter','2015-06-18','India','2474227812','2027-04-26','W5361294','2027-09-18','employees/108/dependents/auZTIOYqB6jsbhG7eYu6whGA3ZE0u9aCRpFLEGc6.pdf','DOC230125-23012025090431.pdf','employees/108/dependents/xx2cXu3yEap9uRsNWG2ziydNtOSaEkschGS4sFMh.jpg','Hannah.jpeg',1,'2026-06-21 09:43:25','2026-06-22 11:59:29'),(6,108,'Haizel Maria Jinesh','daughter','2020-02-22','India',NULL,NULL,'Y3992095','2029-08-07',NULL,NULL,NULL,NULL,1,'2026-06-21 09:48:00','2026-06-21 09:48:00');
/*!40000 ALTER TABLE `employee_dependents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_documents`
--

DROP TABLE IF EXISTS `employee_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_documents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `title` varchar(100) NOT NULL,
  `type` enum('contract','id','certificate','visa','passport','medical','other') NOT NULL DEFAULT 'other',
  `file_path` varchar(255) NOT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `file_size` bigint(20) unsigned DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `uploaded_by` bigint(20) unsigned DEFAULT NULL,
  `verified_by` bigint(20) unsigned DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_documents_employee_id_foreign` (`employee_id`),
  KEY `employee_documents_uploaded_by_foreign` (`uploaded_by`),
  KEY `employee_documents_verified_by_foreign` (`verified_by`),
  CONSTRAINT `employee_documents_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `employee_documents_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employee_documents_verified_by_foreign` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_documents`
--

LOCK TABLES `employee_documents` WRITE;
/*!40000 ALTER TABLE `employee_documents` DISABLE KEYS */;
INSERT INTO `employee_documents` VALUES (1,115,'ID','id','employees/115/documents/Sne0VLDJgJO3IK0vQUu9en3zYNOJZCOJJZiiXDga.xlsx','25000059.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',14151,'2027-03-12',0,NULL,NULL,NULL,'2026-06-21 12:11:29','2026-06-21 12:11:29'),(2,108,'contract','contract','employees/108/documents/16wtmgfI4qSQotuVux6IIvA7EtQXCf0yk4sYL5wO.jpg','omanair.JPG','image/jpeg',100803,'2026-06-22',1,NULL,287,'2026-06-22 12:13:38','2026-06-22 12:05:38','2026-06-22 12:13:38'),(3,108,'iqama','id','employees/108/documents/BCG9cuJcPRDIhwq4sSEJVXUc24b12VVWaIsy26mR.jpg','srilankan.JPG','image/jpeg',101594,'2026-09-11',1,287,287,'2026-06-22 12:14:12','2026-06-22 12:14:12','2026-06-22 12:14:12'),(4,108,'ID / Iqama','id','employees/108/documents/VhYWpZbmdDdsvfo0Cr3y84JiBJG8dsZXCPgTM5YX.pdf','DN COMMISSION_20231029093934.pdf','application/pdf',115697,'2027-06-15',0,286,NULL,NULL,'2026-06-24 12:00:18','2026-06-24 12:00:18'),(5,108,'Experience Letter','certificate','employees/108/documents/qPhLNUCUa33Lp9oiI8wTqWv7lfshTllWpbbvv7T2.jpg','omanair.JPG','image/jpeg',100803,NULL,0,286,NULL,NULL,'2026-06-24 12:00:54','2026-06-24 12:00:54'),(6,108,'HDF','medical','employees/108/documents/2HJtqRvb16N34JRpQlh8QYUrp05jUJRA5uYDCYH3.jpg','Hannah (1).jpeg','image/jpeg',90304,NULL,0,286,NULL,NULL,'2026-06-24 12:12:01','2026-06-24 12:12:01'),(7,122,'Signed Offer Letter','contract','employees/122/documents/XpWwu0GCZ33J69wqaKYYavvmjaS6aDLs2EyKTAUc.pdf','CANCELATION END_20231029093901.pdf','application/pdf',107064,NULL,0,NULL,NULL,NULL,'2026-06-25 11:30:49','2026-06-25 11:30:49'),(8,122,'Latest CV','other','employees/122/documents/JwPMcDskz3hRbC5OL7apoEdss3Z3a57e0AG3NRAw.pdf','DN COMMISSION_20231029093934 (1).pdf','application/pdf',115697,NULL,0,NULL,NULL,NULL,'2026-06-25 11:30:49','2026-06-25 11:30:49'),(9,122,'ID / Iqama','id','employees/122/documents/Mpj61vPi11Tte7GOV9fYlnZBgzZdOcMFgIqWJS5p.pdf','Client Pending Requests Follow-Up and Closure Procedure - updated.pdf','application/pdf',217026,NULL,0,NULL,NULL,NULL,'2026-06-25 11:30:49','2026-06-25 11:30:49'),(10,122,'Bank Details','other','employees/122/documents/5zWelq4nWM7NucDhGL3ZG4N2S6YOw968U87a9E1B.pdf','NDA (4).pdf','application/pdf',49515,NULL,0,NULL,NULL,NULL,'2026-06-25 11:30:49','2026-06-25 11:30:49'),(11,122,'HDF','medical','employees/122/documents/EYVjiSleW0XpMV8rOWbu8dzsi9DzM4vwT9Ze7UW5.pdf','استقبال وتهيئة الموظف الجديد.pdf','application/pdf',125255,NULL,0,NULL,NULL,NULL,'2026-06-25 11:30:49','2026-06-25 11:30:49'),(12,122,'Experience Certificate','certificate','employees/122/documents/NkcObY0Vgk81cuNRtWQ4Mic8SB4gyebCjHKlIwKg.docx','نموذج نقل موظف داخليًا.docx','application/vnd.openxmlformats-officedocument.wordprocessingml.document',83960,NULL,0,NULL,NULL,NULL,'2026-06-25 11:30:49','2026-06-25 11:30:49');
/*!40000 ALTER TABLE `employee_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_onboarding_links`
--

DROP TABLE IF EXISTS `employee_onboarding_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_onboarding_links` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `token_hash` varchar(64) NOT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_onboarding_links_token_hash_unique` (`token_hash`),
  KEY `employee_onboarding_links_employee_id_foreign` (`employee_id`),
  KEY `employee_onboarding_links_created_by_foreign` (`created_by`),
  CONSTRAINT `employee_onboarding_links_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employee_onboarding_links_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_onboarding_links`
--

LOCK TABLES `employee_onboarding_links` WRITE;
/*!40000 ALTER TABLE `employee_onboarding_links` DISABLE KEYS */;
INSERT INTO `employee_onboarding_links` VALUES (1,122,'9654c15a9bc1d264e8a2655c67460f8aed64305873b000fe56cda7fd22bd6e69','2026-07-09 11:18:19','2026-06-25 11:30:49',287,'2026-06-25 11:18:19','2026-06-25 11:30:49');
/*!40000 ALTER TABLE `employee_onboarding_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_requests`
--

DROP TABLE IF EXISTS `employee_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `reference` varchar(30) NOT NULL,
  `employee_id` bigint(20) unsigned NOT NULL,
  `leave_request_id` bigint(20) unsigned DEFAULT NULL,
  `linked_service` varchar(30) DEFAULT NULL,
  `request_type_id` bigint(20) unsigned NOT NULL,
  `status` enum('pending','pending_manager','in_progress','completed','rejected','cancelled') NOT NULL DEFAULT 'pending',
  `details` text NOT NULL,
  `hr_notes` text DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `required_by` date DEFAULT NULL,
  `copies_needed` int(11) NOT NULL DEFAULT 1,
  `attachment_path` varchar(255) DEFAULT NULL COMMENT 'Path to supporting document uploaded by employee',
  `manager_approved_by` bigint(20) unsigned DEFAULT NULL,
  `manager_approved_at` timestamp NULL DEFAULT NULL,
  `manager_notes` text DEFAULT NULL COMMENT 'Notes added by manager when approving',
  `assigned_to` bigint(20) unsigned DEFAULT NULL,
  `completed_by` bigint(20) unsigned DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `rejected_by` bigint(20) unsigned DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `is_overdue` tinyint(1) NOT NULL DEFAULT 0,
  `completion_file` varchar(255) DEFAULT NULL,
  `completion_notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_requests_reference_unique` (`reference`),
  UNIQUE KEY `employee_requests_leave_service_unique` (`leave_request_id`,`linked_service`),
  KEY `employee_requests_employee_id_foreign` (`employee_id`),
  KEY `employee_requests_request_type_id_foreign` (`request_type_id`),
  KEY `employee_requests_manager_approved_by_foreign` (`manager_approved_by`),
  KEY `employee_requests_assigned_to_foreign` (`assigned_to`),
  KEY `employee_requests_completed_by_foreign` (`completed_by`),
  KEY `employee_requests_rejected_by_foreign` (`rejected_by`),
  CONSTRAINT `employee_requests_assigned_to_foreign` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`),
  CONSTRAINT `employee_requests_completed_by_foreign` FOREIGN KEY (`completed_by`) REFERENCES `users` (`id`),
  CONSTRAINT `employee_requests_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `employee_requests_leave_request_id_foreign` FOREIGN KEY (`leave_request_id`) REFERENCES `leave_requests` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employee_requests_manager_approved_by_foreign` FOREIGN KEY (`manager_approved_by`) REFERENCES `users` (`id`),
  CONSTRAINT `employee_requests_rejected_by_foreign` FOREIGN KEY (`rejected_by`) REFERENCES `users` (`id`),
  CONSTRAINT `employee_requests_request_type_id_foreign` FOREIGN KEY (`request_type_id`) REFERENCES `request_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_requests`
--

LOCK TABLES `employee_requests` WRITE;
/*!40000 ALTER TABLE `employee_requests` DISABLE KEYS */;
INSERT INTO `employee_requests` VALUES (1,'REQ-2026-00001',106,NULL,NULL,21,'completed','dddddddddddddddddddddd','f',NULL,'2026-04-13',1,NULL,NULL,NULL,NULL,284,284,'2026-04-12 08:11:47',NULL,NULL,'2026-04-15',0,NULL,'ffffffff','2026-04-12 08:11:02','2026-04-12 08:11:47'),(2,'REQ-2026-00002',106,NULL,NULL,18,'completed','sssffff',NULL,NULL,'2026-04-13',1,NULL,284,'2026-04-12 09:04:55',NULL,284,287,'2026-06-21 12:18:48',NULL,NULL,'2026-04-17',0,NULL,'completd','2026-04-12 09:04:51','2026-06-21 12:18:48'),(3,'REQ-2026-00003',106,NULL,NULL,2,'in_progress','Auto-generated from annual leave request #10. Annual leave: 2026-04-14 00:00:00 – 2026-04-16 00:00:00 (3.0 days). Exit re-entry visa required before departure.',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,284,NULL,NULL,NULL,NULL,'2026-04-20',0,NULL,NULL,'2026-04-13 09:56:20','2026-04-13 09:57:01'),(4,'REQ-2026-00004',108,NULL,NULL,2,'pending','Auto-generated from annual leave request #12. Annual leave: 2026-06-25 00:00:00 – 2026-06-30 00:00:00 (4.0 days). Exit re-entry visa required before departure.',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-28',0,NULL,NULL,'2026-06-21 09:51:53','2026-06-21 09:51:53'),(5,'REQ-2026-00005',108,NULL,NULL,5,'pending','Auto-generated from annual leave request #12. Annual leave: 2026-06-25 00:00:00 – 2026-06-30 00:00:00 (4.0 days). Air ticket requested for: Jinesh Mani, Hannah Maria, Haizel Maria Jinesh.',NULL,NULL,NULL,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24',0,NULL,NULL,'2026-06-21 09:51:53','2026-06-21 09:51:53'),(6,'REQ-2026-00006',106,NULL,NULL,7,'in_progress','require letter',NULL,NULL,'2026-06-22',1,NULL,NULL,NULL,NULL,287,NULL,NULL,NULL,NULL,'2026-06-23',0,NULL,NULL,'2026-06-21 12:35:39','2026-06-21 12:35:52'),(7,'REQ-2026-00007',106,NULL,NULL,17,'pending_manager','Require a training in IT development',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-26',0,NULL,NULL,'2026-06-21 12:36:24','2026-06-21 12:36:24');
/*!40000 ALTER TABLE `employee_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `department_id` bigint(20) unsigned DEFAULT NULL,
  `unit_id` bigint(20) unsigned DEFAULT NULL,
  `designation_id` bigint(20) unsigned DEFAULT NULL,
  `manager_id` bigint(20) unsigned DEFAULT NULL,
  `employee_code` varchar(20) NOT NULL,
  `prefix` varchar(10) DEFAULT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `arabic_name` varchar(200) DEFAULT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `work_phone` varchar(20) DEFAULT NULL,
  `extension` varchar(10) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `marital_status` enum('single','married','divorced','widowed') DEFAULT NULL,
  `hire_date` date NOT NULL,
  `confirmation_date` date DEFAULT NULL,
  `probation_period` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `years_of_experience` smallint(5) unsigned DEFAULT NULL,
  `termination_date` date DEFAULT NULL,
  `employment_type` enum('full_time','part_time','contract','intern') NOT NULL DEFAULT 'full_time',
  `mode_of_employment` varchar(50) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `status` enum('active','inactive','terminated','on_leave','probation') DEFAULT 'active',
  `salary` decimal(12,2) NOT NULL DEFAULT 0.00,
  `housing_allowance` decimal(12,2) DEFAULT NULL COMMENT 'Monthly housing allowance (SAR). If null, 25% of basic is used.',
  `transport_allowance` decimal(12,2) DEFAULT NULL COMMENT 'Monthly transport allowance (SAR). If null, SAR 400 default is used.',
  `other_allowances` decimal(12,2) DEFAULT 0.00 COMMENT 'Other fixed monthly allowances (SAR).',
  `mobile_allowance` decimal(12,2) DEFAULT 0.00 COMMENT 'Monthly mobile/phone allowance (SAR).',
  `food_allowance` decimal(12,2) DEFAULT 0.00 COMMENT 'Monthly food/meal allowance (SAR).',
  `avatar` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `nationality` varchar(100) DEFAULT NULL,
  `national_id` varchar(50) DEFAULT NULL,
  `id_expiry_date` date DEFAULT NULL,
  `passport_number` varchar(50) DEFAULT NULL,
  `passport_expiry_date` date DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `bank_account` varchar(50) DEFAULT NULL,
  `emergency_contact_name` varchar(100) DEFAULT NULL,
  `emergency_contact_phone` varchar(20) DEFAULT NULL,
  `emergency_contact_relation` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employees_user_id_unique` (`user_id`),
  UNIQUE KEY `employees_employee_code_unique` (`employee_code`),
  UNIQUE KEY `employees_email_unique` (`email`),
  KEY `employees_department_id_foreign` (`department_id`),
  KEY `employees_designation_id_foreign` (`designation_id`),
  KEY `employees_manager_id_foreign` (`manager_id`),
  KEY `employees_unit_id_foreign` (`unit_id`),
  CONSTRAINT `employees_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_designation_id_foreign` FOREIGN KEY (`designation_id`) REFERENCES `designations` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_manager_id_foreign` FOREIGN KEY (`manager_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (106,284,2,NULL,3,NULL,'EMP0001',NULL,'System','Admin',NULL,'admin@hrms.com',NULL,NULL,NULL,NULL,NULL,NULL,'2026-04-12',NULL,0,NULL,NULL,'full_time',NULL,NULL,'active',5000.00,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-04-12 07:14:15','2026-04-12 07:14:15',NULL),(107,285,3,NULL,11,111,'EMP0129',NULL,'jithin','varkey',NULL,'jithinvarkey@gmail.com','+966920004778',NULL,NULL,NULL,NULL,NULL,'2017-01-01','2017-01-01',90,NULL,NULL,'full_time',NULL,NULL,'active',10000.00,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-04-13 10:56:11','2026-06-18 13:28:32',NULL),(108,286,3,NULL,6,107,'EMP0182',NULL,'Jinesh','Mani',NULL,'j.mani@dbroker.com.sa',NULL,NULL,NULL,'1985-06-17','male','married','2019-04-18','2019-04-18',0,NULL,NULL,'full_time','direct',NULL,'active',5570.00,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,'Indian',NULL,NULL,NULL,NULL,NULL,'SA343434343',NULL,NULL,NULL,NULL,'2026-06-18 10:12:59','2026-06-22 12:12:47',NULL),(109,287,2,NULL,3,NULL,'EMP0004',NULL,'Saad','Alshaya',NULL,'s.alshaya@dbroker.com.sa',NULL,NULL,NULL,'2003-06-03','male','single','2026-01-01','2026-01-01',0,NULL,NULL,'full_time','direct',NULL,'active',6000.00,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,'Saudi',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-18 10:18:58','2026-06-18 10:18:58',NULL),(110,288,4,NULL,7,106,'EMP0158',NULL,'Ahmed','Helmy',NULL,'a.helmy@dbroker.com.sa',NULL,NULL,NULL,'2005-02-16',NULL,'single','2016-03-08','2016-03-08',0,NULL,NULL,'full_time','direct',NULL,'active',15000.00,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,'Egyptian',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-18 10:24:34','2026-06-18 10:24:34',NULL),(111,289,8,NULL,1,106,'EMP0006',NULL,'Badr','Alshaya',NULL,'b.alshaya@dbroker.com.sa',NULL,NULL,NULL,'1984-02-10','male','married','2015-06-15','2015-06-15',0,NULL,NULL,'full_time','direct',NULL,'active',50000.00,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,'Saudi',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-18 11:06:24','2026-06-18 11:06:24',NULL),(114,292,9,NULL,12,111,'EMP0007',NULL,'Hany','Hashem',NULL,'h.hashem@dbroker.com.sa',NULL,NULL,NULL,'1996-06-18','male','married','2022-02-01','2022-02-02',0,NULL,NULL,'full_time','direct',NULL,'active',15000.00,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,'Egyptian',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-18 13:25:27','2026-06-18 13:25:27',NULL),(115,293,9,NULL,10,114,'EMP0008',NULL,'Azher','Mohammed',NULL,'m.azher@dbroker.com.sa',NULL,NULL,NULL,'2018-06-22','male','married','2022-01-14','2022-01-14',0,NULL,NULL,'full_time','direct',NULL,'active',6000.00,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,'Indian',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-18 13:31:24','2026-06-22 07:29:29',NULL),(121,299,5,NULL,10,106,'EMP0009',NULL,'Mohammed','Abdulfaisal',NULL,'m.faisal@dbroker.com.sa',NULL,NULL,NULL,'1999-01-13',NULL,'married','2026-01-01','2026-01-01',0,NULL,NULL,'full_time','direct',NULL,'active',5000.00,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 09:56:00','2026-06-24 09:56:00',NULL),(122,300,3,NULL,14,NULL,'EMP0010',NULL,'Kiran','raj',NULL,'kiran@gmail.com','552816198',NULL,NULL,'1985-01-15',NULL,NULL,'2026-06-25',NULL,90,NULL,NULL,'full_time',NULL,NULL,'probation',7000.00,NULL,NULL,0.00,0.00,0.00,NULL,'test,resse','Riyadh','Saudi Arabia',NULL,'963258741','2026-08-20',NULL,NULL,'Al rajhi bank','SA3698545489655',NULL,NULL,NULL,NULL,'2026-06-25 11:18:19','2026-06-25 11:30:49',NULL);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `holidays`
--

DROP TABLE IF EXISTS `holidays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `holidays` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `date` date NOT NULL,
  `is_recurring` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `holidays`
--

LOCK TABLES `holidays` WRITE;
/*!40000 ALTER TABLE `holidays` DISABLE KEYS */;
/*!40000 ALTER TABLE `holidays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interviews`
--

DROP TABLE IF EXISTS `interviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interviews` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) unsigned NOT NULL,
  `round` varchar(50) NOT NULL,
  `scheduled_at` datetime NOT NULL,
  `duration_minutes` int(11) NOT NULL DEFAULT 60,
  `format` enum('in_person','video','phone') NOT NULL DEFAULT 'video',
  `location_or_link` varchar(255) DEFAULT NULL,
  `status` enum('scheduled','completed','cancelled','no_show') NOT NULL DEFAULT 'scheduled',
  `feedback` text DEFAULT NULL,
  `result` enum('pass','fail','pending') NOT NULL DEFAULT 'pending',
  `interviewers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`interviewers`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `interviews_application_id_foreign` (`application_id`),
  CONSTRAINT `interviews_application_id_foreign` FOREIGN KEY (`application_id`) REFERENCES `job_applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interviews`
--

LOCK TABLES `interviews` WRITE;
/*!40000 ALTER TABLE `interviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `interviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_applications`
--

DROP TABLE IF EXISTS `job_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_applications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `job_posting_id` bigint(20) unsigned DEFAULT NULL,
  `is_cv_bank` tinyint(1) NOT NULL DEFAULT 0,
  `department_id` bigint(20) unsigned DEFAULT NULL,
  `position_applied` varchar(150) DEFAULT NULL,
  `nationality` varchar(100) DEFAULT NULL,
  `experience_years` int(11) DEFAULT NULL,
  `skills` text DEFAULT NULL,
  `source` varchar(80) DEFAULT NULL,
  `rating` varchar(10) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `applicant_name` varchar(150) NOT NULL,
  `applicant_email` varchar(191) NOT NULL,
  `applicant_phone` varchar(20) DEFAULT NULL,
  `cv_path` varchar(255) DEFAULT NULL,
  `cover_letter_path` varchar(255) DEFAULT NULL,
  `cover_letter_text` text DEFAULT NULL,
  `stage` enum('applied','screening','interview','offer','hired','rejected') NOT NULL DEFAULT 'applied',
  `hr_notes` text DEFAULT NULL,
  `expected_salary` decimal(12,2) DEFAULT NULL,
  `available_from` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `job_applications_job_posting_id_foreign` (`job_posting_id`),
  KEY `job_applications_department_id_foreign` (`department_id`),
  CONSTRAINT `job_applications_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `job_applications_job_posting_id_foreign` FOREIGN KEY (`job_posting_id`) REFERENCES `job_postings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_applications`
--

LOCK TABLES `job_applications` WRITE;
/*!40000 ALTER TABLE `job_applications` DISABLE KEYS */;
INSERT INTO `job_applications` VALUES (3,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'jithin varkey','jithinvarkey@gmail.com','+966920004778',NULL,NULL,'ddd','hired',NULL,10000.00,'2026-04-14','2026-04-13 10:21:54','2026-06-24 10:30:42'),(4,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Joseph','joseph@gmail.com',NULL,'recruitment/cvs/6/QHiUJcJbSnlNbsDxO47GrbV5oBhK4tR7uWDyE0ZH.pdf',NULL,NULL,'applied',NULL,NULL,NULL,'2026-06-24 09:41:15','2026-06-24 09:41:15'),(5,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'James','james@test.com',NULL,'recruitment/cvs/6/w19lWgUmalE9erT1PUB2lAEMPCA6ncVQK7QFdX0F.pdf',NULL,NULL,'offer',NULL,NULL,NULL,'2026-06-24 10:29:13','2026-06-24 10:41:04'),(6,7,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Kiran raj','kiran@gmail.com','552816197','recruitment/cvs/7/hTtIXz4Cu6D4lxUB1JeQg2dFJfKYWGAcMUJ2p29M.pdf',NULL,NULL,'hired',NULL,NULL,NULL,'2026-06-25 11:04:02','2026-06-25 11:18:19');
/*!40000 ALTER TABLE `job_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_postings`
--

DROP TABLE IF EXISTS `job_postings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_postings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `department_id` bigint(20) unsigned DEFAULT NULL,
  `designation_id` bigint(20) unsigned DEFAULT NULL,
  `employment_type` enum('full_time','part_time','contract','intern') NOT NULL,
  `status` enum('draft','open','closed','on_hold') NOT NULL DEFAULT 'draft',
  `vacancies` int(11) NOT NULL DEFAULT 1,
  `description` text NOT NULL,
  `requirements` text DEFAULT NULL,
  `benefits` text DEFAULT NULL,
  `salary_min` decimal(12,2) DEFAULT NULL,
  `salary_max` decimal(12,2) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `closing_date` date DEFAULT NULL,
  `created_by` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `job_postings_department_id_foreign` (`department_id`),
  KEY `job_postings_designation_id_foreign` (`designation_id`),
  KEY `job_postings_created_by_foreign` (`created_by`),
  CONSTRAINT `job_postings_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `job_postings_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `job_postings_designation_id_foreign` FOREIGN KEY (`designation_id`) REFERENCES `designations` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_postings`
--

LOCK TABLES `job_postings` WRITE;
/*!40000 ALTER TABLE `job_postings` DISABLE KEYS */;
INSERT INTO `job_postings` VALUES (6,'IT Developer',3,14,'full_time','closed',1,'dgggggggggggggggggggggg','dddddddddddddddddddddddddd','ddddddddddddddddddd',10000.00,10000.00,NULL,NULL,284,'2026-04-13 10:10:36','2026-06-24 12:51:35',NULL),(7,'IT Developer',3,14,'full_time','closed',1,'IT Developer position',NULL,NULL,NULL,NULL,NULL,NULL,287,'2026-06-25 10:59:46','2026-06-25 11:18:19',NULL);
/*!40000 ALTER TABLE `job_postings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `manpower_request_id` bigint(20) unsigned DEFAULT NULL,
  `source` varchar(255) DEFAULT 'direct',
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `department_id` bigint(20) unsigned DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `status` enum('open','paused','closed','filled') NOT NULL DEFAULT 'open',
  `employment_type` enum('full_time','part_time','contract','internship','freelance') NOT NULL DEFAULT 'full_time',
  `vacancies` int(10) unsigned NOT NULL DEFAULT 1,
  `location` varchar(255) DEFAULT NULL,
  `experience_years` int(10) unsigned DEFAULT NULL,
  `salary_min` bigint(20) unsigned DEFAULT NULL,
  `salary_max` bigint(20) unsigned DEFAULT NULL,
  `deadline` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  `requirements` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_created_by_foreign` (`created_by`),
  KEY `jobs_department_id_foreign` (`department_id`),
  CONSTRAINT `jobs_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `jobs_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kpis`
--

DROP TABLE IF EXISTS `kpis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kpis` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `department_id` bigint(20) unsigned DEFAULT NULL,
  `employee_id` bigint(20) unsigned DEFAULT NULL,
  `category` enum('quantitative','qualitative','behavioral','learning') NOT NULL,
  `target_value` decimal(10,2) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `weight` int(11) NOT NULL DEFAULT 10,
  `year` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kpis_department_id_foreign` (`department_id`),
  KEY `kpis_employee_id_foreign` (`employee_id`),
  CONSTRAINT `kpis_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `kpis_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kpis`
--

LOCK TABLES `kpis` WRITE;
/*!40000 ALTER TABLE `kpis` DISABLE KEYS */;
/*!40000 ALTER TABLE `kpis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leave_allocations`
--

DROP TABLE IF EXISTS `leave_allocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_allocations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `leave_type_id` bigint(20) unsigned NOT NULL,
  `year` int(11) NOT NULL,
  `allocated_days` decimal(5,1) NOT NULL DEFAULT 0.0,
  `used_days` decimal(5,1) NOT NULL DEFAULT 0.0,
  `pending_days` decimal(5,1) NOT NULL DEFAULT 0.0,
  `remaining_days` decimal(5,1) NOT NULL DEFAULT 0.0,
  `carried_forward_days` decimal(5,1) NOT NULL DEFAULT 0.0 COMMENT 'Days carried forward from previous year',
  `used_hours` decimal(7,2) NOT NULL DEFAULT 0.00 COMMENT 'Total hours consumed this month (for hourly leave)',
  `pending_hours` decimal(7,2) NOT NULL DEFAULT 0.00,
  `accrual_year_start` date DEFAULT NULL COMMENT 'Anniversary date that started the current accrual year',
  `last_accrual_date` date DEFAULT NULL COMMENT 'Date this record was last updated by the accrual command',
  `annual_entitlement` tinyint(3) unsigned NOT NULL DEFAULT 22 COMMENT '22 days (<5 yrs service) or 30 days (>=5 yrs service)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `leave_allocations_employee_id_leave_type_id_year_unique` (`employee_id`,`leave_type_id`,`year`),
  KEY `leave_allocations_leave_type_id_foreign` (`leave_type_id`),
  CONSTRAINT `leave_allocations_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `leave_allocations_leave_type_id_foreign` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_allocations`
--

LOCK TABLES `leave_allocations` WRITE;
/*!40000 ALTER TABLE `leave_allocations` DISABLE KEYS */;
INSERT INTO `leave_allocations` VALUES (19,107,37,2026,22.0,0.0,0.0,22.0,0.0,0.00,0.00,NULL,NULL,22,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(20,107,38,2026,10.0,0.0,0.0,10.0,0.0,0.00,0.00,NULL,NULL,22,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(21,107,39,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(22,107,40,2026,90.0,0.0,0.0,90.0,0.0,0.00,0.00,NULL,NULL,22,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(23,107,41,2026,5.0,0.0,0.0,5.0,0.0,0.00,0.00,NULL,NULL,22,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(24,107,42,2026,30.0,0.0,0.0,30.0,0.0,0.00,0.00,NULL,NULL,22,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(25,107,43,2026,3.0,0.0,0.0,3.0,0.0,0.00,0.00,NULL,NULL,22,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(26,108,37,2026,22.0,10.0,-14.0,12.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:12:59','2026-06-24 09:10:41'),(27,108,38,2026,10.0,0.0,0.0,10.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(28,108,39,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(29,108,40,2026,90.0,0.0,0.0,90.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(30,108,41,2026,5.0,0.0,0.0,5.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(31,108,42,2026,30.0,0.0,0.0,30.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(32,108,43,2026,3.0,0.0,0.0,3.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(33,108,44,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(34,109,37,2026,22.0,0.0,0.0,22.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(35,109,38,2026,10.0,0.0,0.0,10.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(36,109,39,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(37,109,40,2026,90.0,0.0,0.0,90.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(38,109,41,2026,5.0,0.0,0.0,5.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(39,109,42,2026,30.0,0.0,0.0,30.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(40,109,43,2026,3.0,0.0,0.0,3.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(41,109,44,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(42,110,37,2026,22.0,0.0,0.0,22.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(43,110,38,2026,10.0,0.0,0.0,10.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(44,110,39,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(45,110,40,2026,90.0,0.0,0.0,90.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(46,110,41,2026,5.0,0.0,0.0,5.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(47,110,42,2026,30.0,0.0,0.0,30.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(48,110,43,2026,3.0,0.0,0.0,3.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(49,110,44,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(50,111,37,2026,22.0,0.0,0.0,22.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(51,111,38,2026,10.0,0.0,0.0,10.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(52,111,39,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(53,111,40,2026,90.0,0.0,0.0,90.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(54,111,41,2026,5.0,0.0,0.0,5.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(55,111,42,2026,30.0,0.0,0.0,30.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(56,111,43,2026,3.0,0.0,0.0,3.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(57,111,44,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(58,114,37,2026,22.0,0.0,0.0,22.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(59,114,38,2026,10.0,0.0,0.0,10.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(60,114,39,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(61,114,40,2026,90.0,0.0,0.0,90.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(62,114,41,2026,5.0,0.0,0.0,5.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(63,114,42,2026,30.0,0.0,0.0,30.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(64,114,43,2026,3.0,0.0,0.0,3.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(65,114,44,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(66,115,37,2026,22.0,0.0,0.0,22.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(67,115,38,2026,10.0,0.0,0.0,10.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(68,115,39,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(69,115,40,2026,90.0,0.0,0.0,90.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(70,115,41,2026,5.0,0.0,0.0,5.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(71,115,42,2026,30.0,0.0,0.0,30.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(72,115,43,2026,3.0,0.0,0.0,3.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(73,115,44,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(74,121,37,2026,22.0,0.0,0.0,22.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(75,121,38,2026,10.0,0.0,0.0,10.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(76,121,39,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(77,121,40,2026,90.0,0.0,0.0,90.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(78,121,41,2026,5.0,0.0,0.0,5.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(79,121,42,2026,30.0,0.0,0.0,30.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(80,121,43,2026,3.0,0.0,0.0,3.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(81,121,44,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(82,122,37,2026,22.0,0.0,0.0,22.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(83,122,38,2026,10.0,0.0,0.0,10.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(84,122,39,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(85,122,40,2026,90.0,0.0,0.0,90.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(86,122,41,2026,5.0,0.0,0.0,5.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(87,122,42,2026,30.0,0.0,0.0,30.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(88,122,43,2026,3.0,0.0,0.0,3.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(89,122,44,2026,0.0,0.0,0.0,0.0,0.0,0.00,0.00,NULL,NULL,22,'2026-06-25 11:18:19','2026-06-25 11:18:19');
/*!40000 ALTER TABLE `leave_allocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leave_requests`
--

DROP TABLE IF EXISTS `leave_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `leave_type_id` bigint(20) unsigned NOT NULL,
  `start_date` date NOT NULL,
  `start_time` time DEFAULT NULL COMMENT 'For hourly leave (e.g. Business Excuse)',
  `end_time` time DEFAULT NULL COMMENT 'For hourly leave',
  `end_date` date NOT NULL,
  `total_days` decimal(5,1) NOT NULL,
  `is_half_day` tinyint(1) NOT NULL DEFAULT 0,
  `half_day_period` enum('morning','afternoon') DEFAULT NULL,
  `requires_exit_reentry` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Employee needs exit re-entry visa',
  `requires_ticket` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Employee needs air ticket',
  `ticket_year` smallint(5) unsigned DEFAULT NULL,
  `ticket_count` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `destination_country` varchar(100) DEFAULT NULL COMMENT 'Travel destination for annual leave',
  `total_hours` decimal(5,2) DEFAULT NULL COMMENT 'Duration in hours for hourly leave types',
  `status` enum('pending','manager_approved','approved','rejected','cancelled') NOT NULL DEFAULT 'pending',
  `reason` text NOT NULL,
  `rejection_reason` text DEFAULT NULL,
  `rejected_stage` varchar(20) DEFAULT NULL COMMENT 'manager or hr',
  `approved_by` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `manager_approved_by` bigint(20) unsigned DEFAULT NULL,
  `manager_approved_at` timestamp NULL DEFAULT NULL,
  `manager_notes` text DEFAULT NULL,
  `hr_notes` text DEFAULT NULL,
  `document_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `leave_requests_employee_id_foreign` (`employee_id`),
  KEY `leave_requests_leave_type_id_foreign` (`leave_type_id`),
  KEY `leave_requests_approved_by_foreign` (`approved_by`),
  KEY `leave_requests_manager_approved_by_foreign` (`manager_approved_by`),
  CONSTRAINT `leave_requests_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`),
  CONSTRAINT `leave_requests_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `leave_requests_leave_type_id_foreign` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`),
  CONSTRAINT `leave_requests_manager_approved_by_foreign` FOREIGN KEY (`manager_approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_requests`
--

LOCK TABLES `leave_requests` WRITE;
/*!40000 ALTER TABLE `leave_requests` DISABLE KEYS */;
INSERT INTO `leave_requests` VALUES (9,106,37,'2026-04-13',NULL,NULL,'2026-04-16',4.0,0,NULL,0,0,NULL,0,NULL,NULL,'pending','ccddddggggggggggggg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-04-12 09:17:41','2026-04-12 09:17:41'),(10,106,37,'2026-04-14',NULL,NULL,'2026-04-16',3.0,0,NULL,1,0,NULL,0,NULL,NULL,'manager_approved','ffffffffffffffffffffffffffff',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-04-13 09:56:12','2026-06-24 09:11:05'),(12,108,37,'2026-06-25',NULL,NULL,'2026-06-30',4.0,0,NULL,1,1,2026,3,NULL,NULL,'cancelled','annual leave please approve',NULL,NULL,287,'2026-06-21 10:07:18',NULL,NULL,NULL,NULL,NULL,'2026-06-21 09:51:48','2026-06-21 10:43:06'),(14,108,37,'2026-06-21',NULL,NULL,'2026-06-25',5.0,0,NULL,0,1,2026,3,'India',NULL,'manager_approved','leaves vvvvvvvvvvvvvvvvvvvv',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-21 12:24:20','2026-06-24 08:50:48'),(15,108,37,'2026-06-25',NULL,NULL,'2026-06-25',0.5,1,'morning',0,0,NULL,0,NULL,NULL,'approved','test reason for the leave',NULL,NULL,287,'2026-06-24 09:10:41',NULL,NULL,NULL,NULL,NULL,'2026-06-24 08:49:56','2026-06-24 09:10:41');
/*!40000 ALTER TABLE `leave_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leave_ticket_passengers`
--

DROP TABLE IF EXISTS `leave_ticket_passengers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_ticket_passengers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `leave_request_id` bigint(20) unsigned NOT NULL,
  `passenger_type` varchar(20) NOT NULL,
  `dependent_id` bigint(20) unsigned DEFAULT NULL,
  `passenger_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `leave_ticket_passengers_leave_request_id_foreign` (`leave_request_id`),
  KEY `leave_ticket_passengers_dependent_id_foreign` (`dependent_id`),
  CONSTRAINT `leave_ticket_passengers_dependent_id_foreign` FOREIGN KEY (`dependent_id`) REFERENCES `employee_dependents` (`id`) ON DELETE SET NULL,
  CONSTRAINT `leave_ticket_passengers_leave_request_id_foreign` FOREIGN KEY (`leave_request_id`) REFERENCES `leave_requests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_ticket_passengers`
--

LOCK TABLES `leave_ticket_passengers` WRITE;
/*!40000 ALTER TABLE `leave_ticket_passengers` DISABLE KEYS */;
INSERT INTO `leave_ticket_passengers` VALUES (4,12,'employee',NULL,'Jinesh Mani','2026-06-21 09:51:48','2026-06-21 09:51:48'),(5,12,'dependent',5,'Hannah Maria','2026-06-21 09:51:48','2026-06-21 09:51:48'),(6,12,'dependent',6,'Haizel Maria Jinesh','2026-06-21 09:51:48','2026-06-21 09:51:48'),(10,14,'employee',NULL,'Jinesh Mani','2026-06-21 12:24:20','2026-06-21 12:24:20'),(11,14,'dependent',5,'Hannah Maria','2026-06-21 12:24:20','2026-06-21 12:24:20'),(12,14,'dependent',6,'Haizel Maria Jinesh','2026-06-21 12:24:20','2026-06-21 12:24:20');
/*!40000 ALTER TABLE `leave_ticket_passengers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leave_type_department_visibility`
--

DROP TABLE IF EXISTS `leave_type_department_visibility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_type_department_visibility` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `leave_type_id` bigint(20) unsigned NOT NULL,
  `department_id` bigint(20) unsigned NOT NULL,
  `is_visible` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `leave_type_department_visible_unique` (`leave_type_id`,`department_id`),
  KEY `leave_type_department_visibility_department_id_foreign` (`department_id`),
  CONSTRAINT `leave_type_department_visibility_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `leave_type_department_visibility_leave_type_id_foreign` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_type_department_visibility`
--

LOCK TABLES `leave_type_department_visibility` WRITE;
/*!40000 ALTER TABLE `leave_type_department_visibility` DISABLE KEYS */;
INSERT INTO `leave_type_department_visibility` VALUES (1,39,8,0,'2026-06-18 10:00:30','2026-06-18 10:00:30'),(2,39,4,0,'2026-06-18 10:00:30','2026-06-18 10:00:30'),(3,39,2,0,'2026-06-18 10:00:30','2026-06-18 10:00:30'),(4,39,3,0,'2026-06-18 10:00:30','2026-06-18 10:00:30'),(5,39,7,0,'2026-06-18 10:00:30','2026-06-18 10:00:30'),(6,39,5,1,'2026-06-18 10:00:30','2026-06-18 10:00:30'),(7,39,6,1,'2026-06-18 10:00:30','2026-06-18 10:00:30');
/*!40000 ALTER TABLE `leave_type_department_visibility` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leave_types`
--

DROP TABLE IF EXISTS `leave_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `days_allowed` int(11) NOT NULL DEFAULT 0,
  `is_paid` tinyint(1) NOT NULL DEFAULT 1,
  `carry_forward` tinyint(1) NOT NULL DEFAULT 0,
  `max_carry_forward` int(11) NOT NULL DEFAULT 0,
  `requires_document` tinyint(1) NOT NULL DEFAULT 0,
  `is_hourly` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'If true, leave is measured in hours not days',
  `is_annual` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Annual leave — shows exit re-entry & ticket options',
  `monthly_hours_limit` decimal(5,2) DEFAULT NULL COMMENT 'Monthly cap in hours. NULL = unlimited (e.g. Sales team override)',
  `exempt_department_codes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Departments exempt from the monthly hours limit' CHECK (json_valid(`exempt_department_codes`)),
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `skip_manager_approval` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'If true, requests go straight to HR without manager approval (e.g. sick leave)',
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `leave_types_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_types`
--

LOCK TABLES `leave_types` WRITE;
/*!40000 ALTER TABLE `leave_types` DISABLE KEYS */;
INSERT INTO `leave_types` VALUES (37,'Annual Leave','AL',22,1,1,5,0,0,1,NULL,NULL,1,0,NULL,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(38,'Sick Leave','SL',10,1,0,0,0,0,0,NULL,NULL,1,0,NULL,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(39,'Business Excuse','BE',0,1,0,0,0,1,0,12.00,'\"[\\\"SM\\\"]\"',1,0,'Hourly excuse for business purposes. Sales team: unlimited. Others: 12h/month max.','2026-04-12 07:14:15','2026-04-12 07:14:15'),(40,'Maternity Leave','ML',90,1,0,0,0,0,0,NULL,NULL,1,0,NULL,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(41,'Paternity Leave','PL',5,1,0,0,0,0,0,NULL,NULL,1,0,NULL,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(42,'Unpaid Leave','UL',30,0,0,0,0,0,0,NULL,NULL,1,0,NULL,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(43,'Emergency Leave','EML',3,1,0,0,0,0,0,NULL,NULL,1,0,NULL,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(44,'Personal Excuse','PE',0,1,0,0,0,1,0,12.00,NULL,1,0,'Hourly personal excuse with department-wise monthly limits. Default cap: 12h/month per employee.','2026-06-18 10:00:30','2026-06-18 10:00:30');
/*!40000 ALTER TABLE `leave_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_installments`
--

DROP TABLE IF EXISTS `loan_installments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_installments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) unsigned NOT NULL,
  `installment_no` int(11) NOT NULL,
  `due_date` date NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `paid_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending','paid','skipped','overdue') NOT NULL DEFAULT 'pending',
  `paid_date` date DEFAULT NULL,
  `processed_by` bigint(20) unsigned DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `loan_installments_loan_id_foreign` (`loan_id`),
  KEY `loan_installments_processed_by_foreign` (`processed_by`),
  CONSTRAINT `loan_installments_loan_id_foreign` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `loan_installments_processed_by_foreign` FOREIGN KEY (`processed_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_installments`
--

LOCK TABLES `loan_installments` WRITE;
/*!40000 ALTER TABLE `loan_installments` DISABLE KEYS */;
INSERT INTO `loan_installments` VALUES (2,6,1,'2026-06-25',1000.00,0.00,'pending',NULL,NULL,NULL,'2026-06-18 10:36:08','2026-06-18 10:36:08'),(3,6,2,'2026-07-25',1000.00,0.00,'pending',NULL,NULL,NULL,'2026-06-18 10:36:08','2026-06-18 10:36:08'),(4,6,3,'2026-08-25',1000.00,0.00,'pending',NULL,NULL,NULL,'2026-06-18 10:36:08','2026-06-18 10:36:08'),(5,6,4,'2026-09-25',1000.00,0.00,'pending',NULL,NULL,NULL,'2026-06-18 10:36:08','2026-06-18 10:36:08'),(6,6,5,'2026-10-25',1000.00,0.00,'pending',NULL,NULL,NULL,'2026-06-18 10:36:08','2026-06-18 10:36:08');
/*!40000 ALTER TABLE `loan_installments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_types`
--

DROP TABLE IF EXISTS `loan_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `max_amount` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '0 = no limit',
  `max_installments` int(11) NOT NULL DEFAULT 12,
  `interest_rate` decimal(5,2) NOT NULL DEFAULT 0.00 COMMENT 'Annual % — 0 for interest-free',
  `requires_guarantor` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `loan_types_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_types`
--

LOCK TABLES `loan_types` WRITE;
/*!40000 ALTER TABLE `loan_types` DISABLE KEYS */;
INSERT INTO `loan_types` VALUES (7,'Personal Loan','PL',50000.00,12,0.00,0,1,'General purpose personal loan, interest-free.','2026-04-12 07:14:15','2026-04-12 07:14:15'),(8,'Housing Loan','HL',200000.00,12,0.00,0,1,'For housing expenses and rent deposits.','2026-04-12 07:14:15','2026-04-12 07:14:15'),(9,'Emergency Loan','EL',20000.00,6,0.00,0,1,'Fast-track emergency loan, max 6 months.','2026-04-12 07:14:15','2026-04-12 07:14:15'),(10,'Education Loan','EDL',30000.00,12,0.00,0,1,'For employee or dependent education costs.','2026-04-12 07:14:15','2026-04-12 07:14:15'),(11,'Vehicle Loan','VL',80000.00,12,3.50,0,1,'Vehicle purchase or major repair.','2026-04-12 07:14:15','2026-04-12 07:14:15');
/*!40000 ALTER TABLE `loan_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loans`
--

DROP TABLE IF EXISTS `loans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loans` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `reference` varchar(30) NOT NULL COMMENT 'e.g. LOAN-2025-00042',
  `employee_id` bigint(20) unsigned NOT NULL,
  `loan_type_id` bigint(20) unsigned NOT NULL,
  `requested_amount` decimal(12,2) NOT NULL,
  `approved_amount` decimal(12,2) DEFAULT NULL,
  `installments` int(11) NOT NULL COMMENT 'Number of monthly installments',
  `monthly_installment` decimal(10,2) DEFAULT NULL,
  `purpose` text NOT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('pending_manager','pending_hr','pending_finance','approved','disbursed','completed','rejected','cancelled') NOT NULL DEFAULT 'pending_manager',
  `manager_approved_by` bigint(20) unsigned DEFAULT NULL,
  `manager_approved_at` timestamp NULL DEFAULT NULL,
  `hr_approved_by` bigint(20) unsigned DEFAULT NULL,
  `hr_approved_at` timestamp NULL DEFAULT NULL,
  `finance_approved_by` bigint(20) unsigned DEFAULT NULL,
  `finance_approved_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `rejected_by` bigint(20) unsigned DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `rejected_stage` enum('manager','hr','finance') DEFAULT NULL,
  `disbursed_date` date DEFAULT NULL,
  `first_installment_date` date DEFAULT NULL,
  `total_paid` decimal(12,2) NOT NULL DEFAULT 0.00,
  `balance_remaining` decimal(12,2) NOT NULL DEFAULT 0.00,
  `installments_paid` int(11) NOT NULL DEFAULT 0,
  `installments_skipped` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `loans_reference_unique` (`reference`),
  KEY `loans_employee_id_foreign` (`employee_id`),
  KEY `loans_loan_type_id_foreign` (`loan_type_id`),
  KEY `loans_manager_approved_by_foreign` (`manager_approved_by`),
  KEY `loans_hr_approved_by_foreign` (`hr_approved_by`),
  KEY `loans_finance_approved_by_foreign` (`finance_approved_by`),
  KEY `loans_rejected_by_foreign` (`rejected_by`),
  CONSTRAINT `loans_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `loans_finance_approved_by_foreign` FOREIGN KEY (`finance_approved_by`) REFERENCES `users` (`id`),
  CONSTRAINT `loans_hr_approved_by_foreign` FOREIGN KEY (`hr_approved_by`) REFERENCES `users` (`id`),
  CONSTRAINT `loans_loan_type_id_foreign` FOREIGN KEY (`loan_type_id`) REFERENCES `loan_types` (`id`),
  CONSTRAINT `loans_manager_approved_by_foreign` FOREIGN KEY (`manager_approved_by`) REFERENCES `users` (`id`),
  CONSTRAINT `loans_rejected_by_foreign` FOREIGN KEY (`rejected_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loans`
--

LOCK TABLES `loans` WRITE;
/*!40000 ALTER TABLE `loans` DISABLE KEYS */;
INSERT INTO `loans` VALUES (6,'LOAN-2026-00001',108,8,5000.00,5000.00,5,1000.00,'test loan approval request',NULL,'disbursed',NULL,NULL,287,'2026-06-18 10:35:29',288,'2026-06-18 10:36:08',NULL,NULL,NULL,NULL,'2026-06-18','2026-06-25',0.00,5000.00,0,0,'2026-06-18 10:21:42','2026-06-18 10:36:15'),(7,'LOAN-2026-00002',108,10,1000.00,NULL,4,250.00,'edcation loan request',NULL,'rejected',284,'2026-06-18 11:02:52',284,'2026-06-18 11:02:56',NULL,NULL,'not allowed',284,'2026-06-23 13:11:56','finance',NULL,NULL,0.00,0.00,0,0,'2026-06-18 11:01:42','2026-06-23 13:11:56'),(8,'LOAN-2026-00003',106,7,10000.00,NULL,5,2000.00,'requesting loan',NULL,'pending_finance',NULL,NULL,284,'2026-06-21 12:50:09',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0,0,'2026-06-21 12:49:07','2026-06-21 12:50:09');
/*!40000 ALTER TABLE `loans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manpower_requests`
--

DROP TABLE IF EXISTS `manpower_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manpower_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `reference` varchar(255) DEFAULT NULL,
  `requested_by` bigint(20) unsigned NOT NULL,
  `department_id` bigint(20) unsigned NOT NULL,
  `position_title` varchar(255) NOT NULL,
  `headcount` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `approved_headcount` tinyint(3) unsigned DEFAULT NULL,
  `employment_type` enum('full_time','part_time','contract','internship','freelance') NOT NULL DEFAULT 'full_time',
  `urgency` enum('low','medium','high','critical') NOT NULL DEFAULT 'medium',
  `reason` text NOT NULL,
  `expected_start_date` date DEFAULT NULL,
  `salary_min` bigint(20) unsigned DEFAULT NULL,
  `salary_max` bigint(20) unsigned DEFAULT NULL,
  `job_description` text DEFAULT NULL,
  `requirements` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `hr_notes` text DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `status` enum('draft','pending_hr','approved','rejected','hired') NOT NULL DEFAULT 'draft',
  `approved_by` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `job_posting_created` tinyint(1) NOT NULL DEFAULT 0,
  `job_posting_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manpower_requests_reference_unique` (`reference`),
  KEY `manpower_requests_requested_by_foreign` (`requested_by`),
  KEY `manpower_requests_department_id_foreign` (`department_id`),
  KEY `manpower_requests_approved_by_foreign` (`approved_by`),
  CONSTRAINT `manpower_requests_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `manpower_requests_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `manpower_requests_requested_by_foreign` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manpower_requests`
--

LOCK TABLES `manpower_requests` WRITE;
/*!40000 ALTER TABLE `manpower_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `manpower_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2014_10_12_000000_create_users_table',1),(2,'2014_10_12_100000_create_password_reset_tokens_table',1),(3,'2019_08_19_000000_create_failed_jobs_table',1),(4,'2019_12_14_000001_create_personal_access_tokens_table',1),(5,'2023_12_31_000001_create_activity_log_table',1),(6,'2024_01_01_000001_create_departments_table',1),(7,'2024_01_01_000002_create_designations_table',1),(8,'2024_01_01_000003_create_employees_table',1),(9,'2024_01_01_000004_create_contracts_table',1),(10,'2024_01_01_000004_create_payroll_tables',1),(11,'2024_01_01_000005_create_contract_renewals_table',1),(12,'2024_01_01_000005_create_leave_attendance_tables',1),(13,'2024_01_01_000006_create_recruitment_tables',1),(14,'2024_01_01_000007_create_performance_tables',1),(15,'2024_01_01_000010_create_manpower_requests_table',1),(16,'2024_01_01_000011_add_manpower_fields_to_jobs_table',1),(17,'2024_01_02_000001_add_extra_fields_to_employees_table',1),(18,'2024_01_02_000002_create_employee_documents_table',1),(19,'2024_01_02_000003_add_accrual_fields_to_leave_allocations',1),(20,'2024_01_02_000004_add_salary_components_to_payslips',1),(21,'2024_01_02_000005_add_business_excuse_fields',1),(22,'2024_01_02_000006_create_department_excuse_limits_table',1),(23,'2024_01_03_000001_add_carry_forward_to_leave_allocations',1),(24,'2024_01_03_000001_create_loan_tables',1),(25,'2024_01_03_000002_add_salary_components_to_employees',1),(26,'2024_01_04_000001_create_attendance_devices_table',1),(27,'2024_01_04_000001_create_separation_tables',1),(28,'2024_01_05_000001_create_request_management_tables',1),(29,'2024_01_05_000002_add_attachment_path_to_requests',1),(30,'2024_01_06_000001_create_contracts_table',1),(31,'2024_01_06_000002_create_contract_renewal_requests_table',1),(32,'2024_01_06_000003_seed_payroll_settings',1),(33,'2024_01_07_000001_add_two_level_approval_to_leave',1),(34,'2024_01_20_000001_create_performance_cycles_table',1),(35,'2024_01_20_000002_create_performance_reviews_table',1),(36,'2024_01_20_000003_create_performance_goals_table',1),(37,'2024_01_20_000004_create_performance_kpis_table',1),(38,'2024_01_20_000005_create_performance_feedback_table',1),(39,'2026_03_09_094854_create_permission_tables',1),(40,'2026_03_11_110530_create_attendance_logs_table',1),(41,'2026_04_13_000001_add_half_day_to_leave_requests',2),(42,'2026_04_13_000002_add_annual_fields_to_leave_tables',3),(43,'2026_04_13_000002_add_cv_bank_fields_to_job_applications',4),(44,'2026_06_08_000001_add_document_columns_to_contract_renewal_requests_table',5),(45,'2026_06_08_1201223_add_renewal_requested_to_employee_contracts_table',5),(46,'2026_06_16_000000_create_communications_tables',5),(47,'2026_06_16_000001_add_personal_excuse_leave_type',5),(48,'2026_06_16_000002_create_leave_type_department_visibility_table',5),(49,'2026_06_16_000004_enhance_communications_modules',5),(50,'2026_06_16_000005_add_department_visibility_to_policies',5),(51,'2026_06_18_000001_create_system_settings_table',5),(52,'2026_06_18_000002_fix_device_punch_time_column',6),(53,'2026_06_18_000003_create_birthday_wish_deliveries_table',7),(54,'2026_06_21_000001_add_missed_checkout_notified_at_to_attendance_logs',8),(55,'2026_06_21_000002_create_annual_ticket_tables',9),(56,'2026_06_21_000003_link_employee_requests_to_leave_requests',10),(57,'2026_06_21_000004_add_annual_leave_reminder_to_employee_contracts',11),(58,'2026_06_21_000005_add_arabic_content_to_announcements',12),(59,'2026_06_22_000001_create_policy_reads_and_secure_attachments',13),(64,'2026_06_22_000006_add_identification_documents_to_employee_dependents',14),(65,'2026_06_22_000007_add_verification_audit_to_employee_documents',15),(66,'2026_06_22_000001_create_asset_management_tables',16),(67,'2026_06_24_000001_add_department_to_cv_bank_entries',17),(68,'2026_06_25_000001_create_employee_onboarding_links',18),(69,'2026_06_25_000002_create_units_and_link_employees',19),(70,'2026_06_25_000003_remove_unit_from_departments',20);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_permissions`
--

DROP TABLE IF EXISTS `model_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) unsigned NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_permissions`
--

LOCK TABLES `model_has_permissions` WRITE;
/*!40000 ALTER TABLE `model_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `model_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_roles`
--

DROP TABLE IF EXISTS `model_has_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) unsigned NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_roles`
--

LOCK TABLES `model_has_roles` WRITE;
/*!40000 ALTER TABLE `model_has_roles` DISABLE KEYS */;
INSERT INTO `model_has_roles` VALUES (351,'App\\Models\\User',284),(351,'App\\Models\\User',289),(352,'App\\Models\\User',287),(354,'App\\Models\\User',288),(355,'App\\Models\\User',285),(355,'App\\Models\\User',292),(356,'App\\Models\\User',285),(356,'App\\Models\\User',286),(356,'App\\Models\\User',293),(356,'App\\Models\\User',299),(356,'App\\Models\\User',300);
/*!40000 ALTER TABLE `model_has_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offboarding_items`
--

DROP TABLE IF EXISTS `offboarding_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offboarding_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `separation_id` bigint(20) unsigned NOT NULL,
  `template_id` bigint(20) unsigned DEFAULT NULL,
  `title` varchar(150) NOT NULL,
  `category` varchar(60) NOT NULL DEFAULT 'general',
  `is_required` tinyint(1) NOT NULL DEFAULT 1,
  `status` enum('pending','completed','skipped','na') NOT NULL DEFAULT 'pending',
  `completed_by` bigint(20) unsigned DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `offboarding_items_separation_id_foreign` (`separation_id`),
  KEY `offboarding_items_template_id_foreign` (`template_id`),
  KEY `offboarding_items_completed_by_foreign` (`completed_by`),
  CONSTRAINT `offboarding_items_completed_by_foreign` FOREIGN KEY (`completed_by`) REFERENCES `users` (`id`),
  CONSTRAINT `offboarding_items_separation_id_foreign` FOREIGN KEY (`separation_id`) REFERENCES `separations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `offboarding_items_template_id_foreign` FOREIGN KEY (`template_id`) REFERENCES `offboarding_templates` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offboarding_items`
--

LOCK TABLES `offboarding_items` WRITE;
/*!40000 ALTER TABLE `offboarding_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `offboarding_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offboarding_templates`
--

DROP TABLE IF EXISTS `offboarding_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offboarding_templates` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `category` varchar(60) NOT NULL DEFAULT 'general',
  `description` text DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `is_required` tinyint(1) NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offboarding_templates`
--

LOCK TABLES `offboarding_templates` WRITE;
/*!40000 ALTER TABLE `offboarding_templates` DISABLE KEYS */;
INSERT INTO `offboarding_templates` VALUES (1,'Return laptop / workstation','it',NULL,1,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(2,'Return mobile phone / SIM card','it',NULL,2,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(3,'Revoke system / application access','it',NULL,3,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(4,'Disable email account','it',NULL,4,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(5,'Transfer data / project files','it',NULL,5,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(6,'Complete exit interview','hr',NULL,10,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(7,'Return ID / access card','hr',NULL,11,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(8,'Return employee handbook','hr',NULL,12,0,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(9,'Sign NDAs / non-compete docs','hr',NULL,13,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(10,'Update HR records / GOSI','hr',NULL,14,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(11,'Clear outstanding loans','finance',NULL,20,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(12,'Return petty cash / advances','finance',NULL,21,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(13,'Process final settlement','finance',NULL,22,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(14,'Return company credit card','finance',NULL,23,0,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(16,'Return office keys','admin',NULL,31,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15'),(18,'Knowledge transfer to successor','admin',NULL,33,1,1,'2026-04-12 07:14:15','2026-04-12 07:14:15');
/*!40000 ALTER TABLE `offboarding_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `onboarding_tasks`
--

DROP TABLE IF EXISTS `onboarding_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `onboarding_tasks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `title` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `category` enum('it_setup','hr_documents','training','introduction','probation') NOT NULL DEFAULT 'hr_documents',
  `status` enum('pending','in_progress','completed','skipped') NOT NULL DEFAULT 'pending',
  `due_date` date DEFAULT NULL,
  `completed_date` date DEFAULT NULL,
  `assigned_to` bigint(20) unsigned DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `onboarding_tasks_employee_id_foreign` (`employee_id`),
  KEY `onboarding_tasks_assigned_to_foreign` (`assigned_to`),
  CONSTRAINT `onboarding_tasks_assigned_to_foreign` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`),
  CONSTRAINT `onboarding_tasks_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `onboarding_tasks`
--

LOCK TABLES `onboarding_tasks` WRITE;
/*!40000 ALTER TABLE `onboarding_tasks` DISABLE KEYS */;
INSERT INTO `onboarding_tasks` VALUES (61,107,'Submit copy of National ID / Iqama',NULL,'hr_documents','completed','2026-04-14','2026-06-24',NULL,0,'2026-04-13 10:56:12','2026-06-24 10:37:33'),(62,107,'Submit educational certificates',NULL,'hr_documents','pending','2026-04-16',NULL,NULL,1,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(63,107,'Submit bank account details for payroll',NULL,'hr_documents','pending','2026-04-16',NULL,NULL,2,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(64,107,'Sign employment contract',NULL,'hr_documents','pending','2026-04-14',NULL,NULL,3,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(65,107,'Complete HR policy acknowledgement form',NULL,'hr_documents','pending','2026-04-20',NULL,NULL,4,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(66,107,'IT: Set up workstation & email',NULL,'it_setup','pending','2026-04-14',NULL,NULL,5,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(67,107,'IT: Configure VPN & system access',NULL,'it_setup','pending','2026-04-15',NULL,NULL,6,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(68,107,'Complete system orientation / training',NULL,'training','pending','2026-04-27',NULL,NULL,7,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(69,107,'Meet department manager & team introduction',NULL,'introduction','pending','2026-04-14',NULL,NULL,8,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(70,107,'Complete probation review at 90 days',NULL,'probation','pending','2026-07-12',NULL,NULL,9,'2026-04-13 10:56:12','2026-04-13 10:56:12'),(71,108,'Issue company laptop and equipment',NULL,'it_setup','pending','2019-04-28',NULL,NULL,1,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(72,108,'Create email and system accounts',NULL,'it_setup','pending','2019-05-05',NULL,NULL,2,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(73,108,'Sign employment contract',NULL,'hr_documents','pending','2019-05-12',NULL,NULL,3,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(74,108,'Sign NDA and confidentiality agreement',NULL,'hr_documents','pending','2019-05-19',NULL,NULL,4,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(75,108,'Complete mandatory compliance training',NULL,'training','pending','2019-05-26',NULL,NULL,5,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(76,108,'Introduce to team and department',NULL,'introduction','pending','2019-06-02',NULL,NULL,6,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(77,108,'Set up buddy / mentor',NULL,'introduction','pending','2019-06-09',NULL,NULL,7,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(78,108,'30-day probation check-in',NULL,'probation','pending','2019-06-16',NULL,NULL,8,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(79,108,'60-day probation check-in',NULL,'probation','pending','2019-06-23',NULL,NULL,9,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(80,108,'90-day probation review',NULL,'probation','pending','2019-06-30',NULL,NULL,10,'2026-06-18 10:12:59','2026-06-18 10:12:59'),(81,109,'Issue company laptop and equipment',NULL,'it_setup','pending','2026-01-08',NULL,NULL,1,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(82,109,'Create email and system accounts',NULL,'it_setup','pending','2026-01-15',NULL,NULL,2,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(83,109,'Sign employment contract',NULL,'hr_documents','pending','2026-01-22',NULL,NULL,3,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(84,109,'Sign NDA and confidentiality agreement',NULL,'hr_documents','pending','2026-01-29',NULL,NULL,4,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(85,109,'Complete mandatory compliance training',NULL,'training','pending','2026-02-05',NULL,NULL,5,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(86,109,'Introduce to team and department',NULL,'introduction','pending','2026-02-12',NULL,NULL,6,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(87,109,'Set up buddy / mentor',NULL,'introduction','pending','2026-02-19',NULL,NULL,7,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(88,109,'30-day probation check-in',NULL,'probation','pending','2026-02-26',NULL,NULL,8,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(89,109,'60-day probation check-in',NULL,'probation','pending','2026-03-05',NULL,NULL,9,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(90,109,'90-day probation review',NULL,'probation','pending','2026-03-12',NULL,NULL,10,'2026-06-18 10:18:58','2026-06-18 10:18:58'),(91,110,'Issue company laptop and equipment',NULL,'it_setup','pending','2016-03-15',NULL,NULL,1,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(92,110,'Create email and system accounts',NULL,'it_setup','pending','2016-03-22',NULL,NULL,2,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(93,110,'Sign employment contract',NULL,'hr_documents','pending','2016-03-29',NULL,NULL,3,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(94,110,'Sign NDA and confidentiality agreement',NULL,'hr_documents','pending','2016-04-05',NULL,NULL,4,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(95,110,'Complete mandatory compliance training',NULL,'training','pending','2016-04-12',NULL,NULL,5,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(96,110,'Introduce to team and department',NULL,'introduction','pending','2016-04-19',NULL,NULL,6,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(97,110,'Set up buddy / mentor',NULL,'introduction','pending','2016-04-26',NULL,NULL,7,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(98,110,'30-day probation check-in',NULL,'probation','pending','2016-05-03',NULL,NULL,8,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(99,110,'60-day probation check-in',NULL,'probation','pending','2016-05-10',NULL,NULL,9,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(100,110,'90-day probation review',NULL,'probation','pending','2016-05-17',NULL,NULL,10,'2026-06-18 10:24:34','2026-06-18 10:24:34'),(101,111,'Issue company laptop and equipment',NULL,'it_setup','pending','2015-06-22',NULL,NULL,1,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(102,111,'Create email and system accounts',NULL,'it_setup','pending','2015-06-29',NULL,NULL,2,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(103,111,'Sign employment contract',NULL,'hr_documents','pending','2015-07-06',NULL,NULL,3,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(104,111,'Sign NDA and confidentiality agreement',NULL,'hr_documents','pending','2015-07-13',NULL,NULL,4,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(105,111,'Complete mandatory compliance training',NULL,'training','pending','2015-07-20',NULL,NULL,5,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(106,111,'Introduce to team and department',NULL,'introduction','pending','2015-07-27',NULL,NULL,6,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(107,111,'Set up buddy / mentor',NULL,'introduction','pending','2015-08-03',NULL,NULL,7,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(108,111,'30-day probation check-in',NULL,'probation','pending','2015-08-10',NULL,NULL,8,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(109,111,'60-day probation check-in',NULL,'probation','pending','2015-08-17',NULL,NULL,9,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(110,111,'90-day probation review',NULL,'probation','pending','2015-08-24',NULL,NULL,10,'2026-06-18 11:06:24','2026-06-18 11:06:24'),(111,114,'Issue company laptop and equipment',NULL,'it_setup','pending','2022-02-08',NULL,NULL,1,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(112,114,'Create email and system accounts',NULL,'it_setup','pending','2022-02-15',NULL,NULL,2,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(113,114,'Sign employment contract',NULL,'hr_documents','pending','2022-02-22',NULL,NULL,3,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(114,114,'Sign NDA and confidentiality agreement',NULL,'hr_documents','pending','2022-03-01',NULL,NULL,4,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(115,114,'Complete mandatory compliance training',NULL,'training','pending','2022-03-08',NULL,NULL,5,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(116,114,'Introduce to team and department',NULL,'introduction','pending','2022-03-15',NULL,NULL,6,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(117,114,'Set up buddy / mentor',NULL,'introduction','pending','2022-03-22',NULL,NULL,7,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(118,114,'30-day probation check-in',NULL,'probation','pending','2022-03-29',NULL,NULL,8,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(119,114,'60-day probation check-in',NULL,'probation','pending','2022-04-05',NULL,NULL,9,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(120,114,'90-day probation review',NULL,'probation','pending','2022-04-12',NULL,NULL,10,'2026-06-18 13:25:27','2026-06-18 13:25:27'),(121,115,'Issue company laptop and equipment',NULL,'it_setup','completed','2022-01-25','2026-06-21',NULL,1,'2026-06-18 13:31:24','2026-06-21 12:16:39'),(122,115,'Create email and system accounts',NULL,'it_setup','pending','2022-02-01',NULL,NULL,2,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(123,115,'Sign employment contract',NULL,'hr_documents','pending','2022-02-08',NULL,NULL,3,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(124,115,'Sign NDA and confidentiality agreement',NULL,'hr_documents','pending','2022-02-15',NULL,NULL,4,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(125,115,'Complete mandatory compliance training',NULL,'training','pending','2022-02-22',NULL,NULL,5,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(126,115,'Introduce to team and department',NULL,'introduction','pending','2022-03-01',NULL,NULL,6,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(127,115,'Set up buddy / mentor',NULL,'introduction','pending','2022-03-08',NULL,NULL,7,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(128,115,'30-day probation check-in',NULL,'probation','pending','2022-03-15',NULL,NULL,8,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(129,115,'60-day probation check-in',NULL,'probation','pending','2022-03-22',NULL,NULL,9,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(130,115,'90-day probation review',NULL,'probation','pending','2022-03-29',NULL,NULL,10,'2026-06-18 13:31:24','2026-06-18 13:31:24'),(131,121,'Provide company laptop and accessories',NULL,'it_setup','pending','2026-01-08',NULL,NULL,1,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(132,121,'Create email and system accounts',NULL,'it_setup','pending','2026-01-15',NULL,NULL,2,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(133,121,'Prepare ID badge and access card',NULL,'hr_documents','pending','2026-01-22',NULL,NULL,3,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(134,121,'Set up workstation and desk allocation',NULL,'it_setup','pending','2026-01-29',NULL,NULL,4,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(135,121,'Sign employment contract',NULL,'hr_documents','pending','2026-02-05',NULL,NULL,5,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(136,121,'Collect required personal documents',NULL,'hr_documents','pending','2026-02-12',NULL,NULL,6,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(137,121,'Register bank and payroll details',NULL,'hr_documents','pending','2026-02-19',NULL,NULL,7,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(138,121,'Complete mandatory compliance training',NULL,'training','pending','2026-02-26',NULL,NULL,8,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(139,121,'Introduce to team and department',NULL,'introduction','pending','2026-03-05',NULL,NULL,9,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(140,121,'Set up buddy or mentor',NULL,'introduction','pending','2026-03-12',NULL,NULL,10,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(141,121,'30-day probation check-in',NULL,'probation','pending','2026-03-19',NULL,NULL,11,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(142,121,'90-day probation review',NULL,'probation','pending','2026-03-26',NULL,NULL,12,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(143,122,'Provide company laptop and accessories',NULL,'it_setup','pending','2026-06-26',NULL,NULL,1,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(144,122,'Create email and system accounts',NULL,'it_setup','pending','2026-06-26',NULL,NULL,2,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(145,122,'Prepare ID badge and access card',NULL,'hr_documents','pending','2026-06-26',NULL,NULL,3,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(146,122,'Set up workstation and desk allocation',NULL,'it_setup','pending','2026-06-26',NULL,NULL,4,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(147,122,'Sign employment contract',NULL,'hr_documents','pending','2026-06-26',NULL,NULL,5,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(148,122,'Collect required personal documents',NULL,'hr_documents','pending','2026-06-28',NULL,NULL,6,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(149,122,'Register bank and payroll details',NULL,'hr_documents','pending','2026-06-28',NULL,NULL,7,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(150,122,'Complete mandatory compliance training',NULL,'training','pending','2026-07-02',NULL,NULL,8,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(151,122,'Introduce to team and department',NULL,'introduction','pending','2026-06-26',NULL,NULL,9,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(152,122,'Set up buddy or mentor',NULL,'introduction','pending','2026-06-28',NULL,NULL,10,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(153,122,'30-day probation check-in',NULL,'probation','pending','2026-07-25',NULL,NULL,11,'2026-06-25 11:18:19','2026-06-25 11:18:19'),(154,122,'90-day probation review',NULL,'probation','pending','2026-09-23',NULL,NULL,12,'2026-06-25 11:18:19','2026-06-25 11:18:19');
/*!40000 ALTER TABLE `onboarding_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payroll_components`
--

DROP TABLE IF EXISTS `payroll_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payroll_components` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `type` enum('earning','deduction') NOT NULL,
  `calculation` enum('fixed','percentage') NOT NULL,
  `value` decimal(10,2) NOT NULL DEFAULT 0.00,
  `is_taxable` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payroll_components_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payroll_components`
--

LOCK TABLES `payroll_components` WRITE;
/*!40000 ALTER TABLE `payroll_components` DISABLE KEYS */;
INSERT INTO `payroll_components` VALUES (1,'Performance Bonus','PB','earning','percentage',0.00,0,0,'Discretionary performance bonus (% of basic)','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2,'Mobile Allowance','MOB','earning','fixed',0.00,0,0,'Monthly mobile allowance (SAR)','2026-04-12 07:14:15','2026-04-12 07:14:15'),(3,'Loan Deduction','LOAN','deduction','fixed',0.00,0,0,'Monthly loan repayment deduction (SAR)','2026-04-12 07:14:15','2026-04-12 07:14:15'),(4,'Penalty Deduction','PEN','deduction','fixed',0.00,0,0,'Disciplinary / penalty deduction (SAR)','2026-04-12 07:14:15','2026-04-12 07:14:15');
/*!40000 ALTER TABLE `payroll_components` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payroll_settings`
--

DROP TABLE IF EXISTS `payroll_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payroll_settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(100) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `type` varchar(30) NOT NULL DEFAULT 'string',
  `label` varchar(200) DEFAULT NULL,
  `group` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payroll_settings_key_unique` (`key`),
  KEY `payroll_settings_group_index` (`group`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payroll_settings`
--

LOCK TABLES `payroll_settings` WRITE;
/*!40000 ALTER TABLE `payroll_settings` DISABLE KEYS */;
INSERT INTO `payroll_settings` VALUES (1,'daily_rate_basis','monthly','string','Daily Rate Calculation Basis','deductions','monthly = salary ÷ working days in period | fixed = salary ÷ 26 | annual = salary × 12 ÷ 260','2026-04-12 07:08:59','2026-04-12 07:08:59'),(2,'working_days_per_month','26','integer','Working Days Per Month (Fixed Basis)','deductions','Used when daily_rate_basis = \"fixed\". Saudi standard is 26.','2026-04-12 07:08:59','2026-04-12 07:08:59'),(3,'deduct_unpaid_leave','1','boolean','Deduct Unpaid Leave from Salary','leave','When ON, approved leaves of types marked \"Unpaid\" are deducted from basic salary at the daily rate.','2026-04-12 07:08:59','2026-04-12 07:08:59'),(4,'deduct_absences','1','boolean','Deduct Unrecorded Absences','leave','When ON, days marked Absent in attendance with no approved leave request are deducted from basic salary.','2026-04-12 07:08:59','2026-04-12 07:08:59'),(5,'deduct_allowances_on_leave','0','boolean','Deduct Allowances on Unpaid Leave','leave','When ON, housing and transport allowances are also pro-rated for unpaid leave days.','2026-04-12 07:08:59','2026-04-12 07:08:59'),(6,'gosi_apply_saudi_only','1','boolean','Apply GOSI to Saudi Nationals Only','gosi','When ON, GOSI deductions only apply to Saudi national employees.','2026-04-12 07:08:59','2026-04-12 07:08:59'),(7,'gosi_employee_rate','0.09','decimal','GOSI Employee Contribution Rate','gosi','Employee-side GOSI rate (default 9% = 0.09).','2026-04-12 07:08:59','2026-04-12 07:08:59'),(8,'gosi_employer_rate','0.1175','decimal','GOSI Employer Contribution Rate','gosi','Employer-side GOSI rate (default 11.75% = 0.1175).','2026-04-12 07:08:59','2026-04-12 07:08:59'),(9,'overtime_rate','1.5','decimal','Overtime Rate Multiplier','overtime','Daily rate multiplier for overtime (e.g. 1.5 = 150% of daily rate).','2026-04-12 07:08:59','2026-04-12 07:08:59');
/*!40000 ALTER TABLE `payroll_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payrolls`
--

DROP TABLE IF EXISTS `payrolls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payrolls` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cycle_name` varchar(100) NOT NULL,
  `month` varchar(7) NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `status` enum('draft','pending_approval','approved','rejected','paid') NOT NULL DEFAULT 'draft',
  `total_gross` decimal(14,2) NOT NULL DEFAULT 0.00,
  `total_deductions` decimal(14,2) NOT NULL DEFAULT 0.00,
  `total_net` decimal(14,2) NOT NULL DEFAULT 0.00,
  `created_by` bigint(20) unsigned NOT NULL,
  `approved_by` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payrolls_created_by_foreign` (`created_by`),
  KEY `payrolls_approved_by_foreign` (`approved_by`),
  CONSTRAINT `payrolls_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`),
  CONSTRAINT `payrolls_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payrolls`
--

LOCK TABLES `payrolls` WRITE;
/*!40000 ALTER TABLE `payrolls` DISABLE KEYS */;
/*!40000 ALTER TABLE `payrolls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payslips`
--

DROP TABLE IF EXISTS `payslips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payslips` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `payroll_id` bigint(20) unsigned NOT NULL,
  `employee_id` bigint(20) unsigned NOT NULL,
  `basic_salary` decimal(12,2) NOT NULL DEFAULT 0.00,
  `housing_allowance` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '25% of basic salary',
  `transport_allowance` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT 'Fixed monthly transport allowance',
  `other_allowances` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT 'Any other allowances / bonuses',
  `total_earnings` decimal(12,2) NOT NULL DEFAULT 0.00,
  `gosi_employee` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT 'GOSI employee share: 9% of basic (Saudi nationals only)',
  `gosi_employer` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT 'GOSI employer share: 11.75% of basic (cost, not deducted from employee)',
  `other_deductions` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT 'Loans, penalties, etc.',
  `is_saudi` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Whether GOSI applies',
  `total_deductions` decimal(12,2) NOT NULL DEFAULT 0.00,
  `gross_salary` decimal(12,2) NOT NULL DEFAULT 0.00,
  `net_salary` decimal(12,2) NOT NULL DEFAULT 0.00,
  `working_days` int(11) NOT NULL DEFAULT 0,
  `absent_days` int(11) NOT NULL DEFAULT 0,
  `leave_days` int(11) NOT NULL DEFAULT 0,
  `pdf_path` varchar(255) DEFAULT NULL,
  `email_sent` tinyint(1) NOT NULL DEFAULT 0,
  `email_sent_at` timestamp NULL DEFAULT NULL,
  `components` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`components`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payslips_payroll_id_foreign` (`payroll_id`),
  KEY `payslips_employee_id_foreign` (`employee_id`),
  CONSTRAINT `payslips_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `payslips_payroll_id_foreign` FOREIGN KEY (`payroll_id`) REFERENCES `payrolls` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payslips`
--

LOCK TABLES `payslips` WRITE;
/*!40000 ALTER TABLE `payslips` DISABLE KEYS */;
/*!40000 ALTER TABLE `payslips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `performance_cycles`
--

DROP TABLE IF EXISTS `performance_cycles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performance_cycles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` enum('annual','semi_annual','quarterly') NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `self_assessment_deadline` date DEFAULT NULL,
  `manager_review_deadline` date DEFAULT NULL,
  `status` enum('draft','active','completed','archived') NOT NULL DEFAULT 'draft',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performance_cycles`
--

LOCK TABLES `performance_cycles` WRITE;
/*!40000 ALTER TABLE `performance_cycles` DISABLE KEYS */;
/*!40000 ALTER TABLE `performance_cycles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `performance_feedback`
--

DROP TABLE IF EXISTS `performance_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performance_feedback` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `subject_employee_id` bigint(20) unsigned NOT NULL,
  `reviewer_id` bigint(20) unsigned NOT NULL,
  `review_id` bigint(20) unsigned DEFAULT NULL,
  `relationship` enum('self','manager','peer','report','client') NOT NULL DEFAULT 'peer',
  `is_anonymous` tinyint(1) NOT NULL DEFAULT 0,
  `communication` tinyint(3) unsigned DEFAULT NULL,
  `teamwork` tinyint(3) unsigned DEFAULT NULL,
  `technical` tinyint(3) unsigned DEFAULT NULL,
  `leadership` tinyint(3) unsigned DEFAULT NULL,
  `initiative` tinyint(3) unsigned DEFAULT NULL,
  `strengths` text DEFAULT NULL,
  `improvements` text DEFAULT NULL,
  `overall_comment` text DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `performance_feedback_subject_employee_id_foreign` (`subject_employee_id`),
  KEY `performance_feedback_reviewer_id_foreign` (`reviewer_id`),
  KEY `performance_feedback_review_id_foreign` (`review_id`),
  CONSTRAINT `performance_feedback_review_id_foreign` FOREIGN KEY (`review_id`) REFERENCES `performance_reviews` (`id`) ON DELETE SET NULL,
  CONSTRAINT `performance_feedback_reviewer_id_foreign` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `performance_feedback_subject_employee_id_foreign` FOREIGN KEY (`subject_employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performance_feedback`
--

LOCK TABLES `performance_feedback` WRITE;
/*!40000 ALTER TABLE `performance_feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `performance_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `performance_goals`
--

DROP TABLE IF EXISTS `performance_goals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performance_goals` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `review_id` bigint(20) unsigned DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `category` enum('professional','learning','leadership','project','personal','okr') NOT NULL DEFAULT 'professional',
  `priority` enum('low','medium','high','critical') NOT NULL DEFAULT 'medium',
  `status` enum('not_started','in_progress','achieved','on_hold','cancelled') NOT NULL DEFAULT 'not_started',
  `target_value` decimal(10,2) DEFAULT NULL,
  `current_value` decimal(10,2) NOT NULL DEFAULT 0.00,
  `unit` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `achieved_at` date DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `performance_goals_employee_id_foreign` (`employee_id`),
  KEY `performance_goals_review_id_foreign` (`review_id`),
  KEY `performance_goals_created_by_foreign` (`created_by`),
  CONSTRAINT `performance_goals_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `performance_goals_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `performance_goals_review_id_foreign` FOREIGN KEY (`review_id`) REFERENCES `performance_reviews` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performance_goals`
--

LOCK TABLES `performance_goals` WRITE;
/*!40000 ALTER TABLE `performance_goals` DISABLE KEYS */;
/*!40000 ALTER TABLE `performance_goals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `performance_kpis`
--

DROP TABLE IF EXISTS `performance_kpis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performance_kpis` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `review_id` bigint(20) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `target` decimal(12,2) DEFAULT NULL,
  `actual` decimal(12,2) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `period` varchar(255) DEFAULT NULL,
  `frequency` enum('daily','weekly','monthly','quarterly','annual') NOT NULL DEFAULT 'monthly',
  `weight` decimal(5,2) NOT NULL DEFAULT 1.00,
  `status` enum('on_track','at_risk','missed','achieved') NOT NULL DEFAULT 'on_track',
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `performance_kpis_employee_id_foreign` (`employee_id`),
  KEY `performance_kpis_review_id_foreign` (`review_id`),
  KEY `performance_kpis_created_by_foreign` (`created_by`),
  CONSTRAINT `performance_kpis_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `performance_kpis_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `performance_kpis_review_id_foreign` FOREIGN KEY (`review_id`) REFERENCES `performance_reviews` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performance_kpis`
--

LOCK TABLES `performance_kpis` WRITE;
/*!40000 ALTER TABLE `performance_kpis` DISABLE KEYS */;
/*!40000 ALTER TABLE `performance_kpis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `performance_reviews`
--

DROP TABLE IF EXISTS `performance_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performance_reviews` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cycle_id` bigint(20) unsigned NOT NULL,
  `employee_id` bigint(20) unsigned NOT NULL,
  `reviewer_id` bigint(20) unsigned DEFAULT NULL,
  `status` enum('pending','self_submitted','manager_reviewed','hr_calibrated','finalized') NOT NULL DEFAULT 'pending',
  `self_rating` decimal(3,1) DEFAULT NULL,
  `self_comments` text DEFAULT NULL,
  `self_kpi_scores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`self_kpi_scores`)),
  `manager_rating` decimal(3,1) DEFAULT NULL,
  `manager_comments` text DEFAULT NULL,
  `manager_kpi_scores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`manager_kpi_scores`)),
  `final_rating` decimal(3,1) DEFAULT NULL,
  `performance_band` enum('excellent','good','average','below_average','poor') DEFAULT NULL,
  `development_plan` text DEFAULT NULL,
  `hr_notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `performance_reviews_cycle_id_employee_id_unique` (`cycle_id`,`employee_id`),
  KEY `performance_reviews_employee_id_foreign` (`employee_id`),
  KEY `performance_reviews_reviewer_id_foreign` (`reviewer_id`),
  CONSTRAINT `performance_reviews_cycle_id_foreign` FOREIGN KEY (`cycle_id`) REFERENCES `performance_cycles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `performance_reviews_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `performance_reviews_reviewer_id_foreign` FOREIGN KEY (`reviewer_id`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performance_reviews`
--

LOCK TABLES `performance_reviews` WRITE;
/*!40000 ALTER TABLE `performance_reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `performance_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2592 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (2539,'dashboard.view','web','2026-04-12 07:14:14','2026-04-12 07:14:14'),(2540,'employees.view','web','2026-04-12 07:14:14','2026-04-12 07:14:14'),(2541,'employees.create','web','2026-04-12 07:14:14','2026-04-12 07:14:14'),(2542,'employees.edit','web','2026-04-12 07:14:14','2026-04-12 07:14:14'),(2543,'employees.delete','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2544,'employees.view_salary','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2545,'employees.view_documents','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2546,'payroll.view','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2547,'payroll.run','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2548,'payroll.approve','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2549,'payroll.export','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2550,'payroll.view_own','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2551,'leave.view_all','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2552,'leave.approve','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2553,'leave.manage_types','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2554,'leave.manage_holidays','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2555,'leave.view_own','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2556,'leave.request','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2557,'loans.view_all','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2558,'loans.approve_manager','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2559,'loans.approve_hr','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2560,'loans.approve_finance','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2561,'loans.disburse','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2562,'loans.manage_types','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2563,'loans.view_own','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2564,'loans.request','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2565,'separations.view_all','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2566,'separations.create','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2567,'separations.approve_manager','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2568,'separations.approve_hr','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2569,'separations.manage_offboarding','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2570,'requests.view_all','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2571,'requests.process','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2572,'requests.approve_manager','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2573,'requests.manage_types','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2574,'requests.view_own','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2575,'requests.submit','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2576,'recruitment.view','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2577,'recruitment.manage','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2578,'performance.view','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2579,'performance.manage','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2580,'attendance.view_all','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2581,'attendance.view_own','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2582,'attendance.checkin','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2583,'attendance.manual_entry','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2584,'attendance.manage','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2585,'orgchart.view','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2586,'admin.manage_users','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2587,'admin.manage_roles','web','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2588,'admin.view_logs','web','2026-04-12 07:14:15','2026-04-12 07:14:15');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES (2,'App\\Models\\User',284,'hrms-token','9d3ebde25fda92abe44c2ce98c7f5b1a623e9579d97b0d63841b8cbd351318b1','[\"*\"]',NULL,NULL,'2026-04-12 07:17:31','2026-04-12 07:17:31'),(3,'App\\Models\\User',284,'hrms-token','aca1c836b560a899dcacf11207959da8368c78a6c1601e1e54a12db236eb45a1','[\"*\"]',NULL,NULL,'2026-04-12 07:31:07','2026-04-12 07:31:07'),(4,'App\\Models\\User',284,'hrms-token','f7f5baebaf5be76c09b0d7791c3e002445aab8504c66881807408104231b21a0','[\"*\"]',NULL,NULL,'2026-04-12 08:36:29','2026-04-12 08:36:29'),(6,'App\\Models\\User',284,'hrms-token','66f904be689d7d5b80630eee93ca549cdb40112a385b4449f525013b69f70337','[\"*\"]',NULL,NULL,'2026-04-13 03:51:22','2026-04-13 03:51:22'),(7,'App\\Models\\User',284,'hrms-token','5b258362094abe1e71b1cb34ed195b76f7e69c04a14906580dae6ed9c040f4d1','[\"*\"]',NULL,NULL,'2026-04-13 04:53:20','2026-04-13 04:53:20'),(8,'App\\Models\\User',284,'hrms-token','37b5158460bcb10ba396e660831d72816945222b876db5ca06767cf7d02044c5','[\"*\"]',NULL,NULL,'2026-06-18 10:00:54','2026-06-18 10:00:54'),(10,'App\\Models\\User',284,'hrms-token','6bec8eddbb92939d9d2f18da0f9493fa5f25411a35043087b9a26565dfb0a6a4','[\"*\"]',NULL,NULL,'2026-06-18 10:20:22','2026-06-18 10:20:22'),(11,'App\\Models\\User',286,'hrms-token','5f371472f10f1717e77d1ceff97e456de1adfb311576e6faa813e05e318284e4','[\"*\"]',NULL,NULL,'2026-06-18 10:20:45','2026-06-18 10:20:45'),(12,'App\\Models\\User',285,'hrms-token','9f7dbe5b912083ab1c07271e86684ca7fac7fcf05acea7048c8ad48442ed472c','[\"*\"]',NULL,NULL,'2026-06-18 10:22:13','2026-06-18 10:22:13'),(13,'App\\Models\\User',284,'hrms-token','1342f81d4b4ebc755e7d7c8ef648b8069209c0b777cdaa86b7cbcb8d9059920b','[\"*\"]',NULL,NULL,'2026-06-18 10:22:34','2026-06-18 10:22:34'),(14,'App\\Models\\User',288,'hrms-token','7bfa53a7eb5b869b556a50ff2213467590f4de6830bebe2fc7d35efdfb319a30','[\"*\"]',NULL,NULL,'2026-06-18 10:25:33','2026-06-18 10:25:33'),(15,'App\\Models\\User',287,'hrms-token','2dfe0782b066e2283c7ada21b31987801498a8409ffb339a5eb3bc62c9bbb59a','[\"*\"]',NULL,NULL,'2026-06-18 10:35:10','2026-06-18 10:35:10'),(16,'App\\Models\\User',288,'hrms-token','ec0bf4bf0fef2bee5c0900bf4c7574980c92dc87ec3c2637003f8c9ff886729c','[\"*\"]',NULL,NULL,'2026-06-18 10:35:48','2026-06-18 10:35:48'),(17,'App\\Models\\User',284,'hrms-token','632c1250a060b2a62ca13ff7f551bb7841a8879f38f0883fe1e6ba8afc021d41','[\"*\"]',NULL,NULL,'2026-06-18 10:36:35','2026-06-18 10:36:35'),(18,'App\\Models\\User',284,'hrms-token','e248b3e1dea21d7a1ce272add1986d4fa67b132eb5597a39dcb5f87f33bfb84a','[\"*\"]','2026-06-18 10:48:19',NULL,'2026-06-18 10:48:18','2026-06-18 10:48:19'),(19,'App\\Models\\User',284,'hrms-token','1388c3cadd8bd18dee2a3d9ba1659536607c2eaffa9287def72c9de9fba281c0','[\"*\"]','2026-06-18 10:52:57',NULL,'2026-06-18 10:52:57','2026-06-18 10:52:57'),(20,'App\\Models\\User',284,'hrms-token','511359af31411e5d64c5950bd0ea7cbe847b79b86f288bce5f2bf362d1249184','[\"*\"]','2026-06-18 10:56:49',NULL,'2026-06-18 10:56:48','2026-06-18 10:56:49'),(21,'App\\Models\\User',284,'hrms-token','41f5f411f40d8ace4d2556cfb72d444e4d78c5ff1583b962598fed5fea0628b2','[\"*\"]',NULL,NULL,'2026-06-18 11:00:36','2026-06-18 11:00:36'),(22,'App\\Models\\User',286,'hrms-token','3513b24bbcac4b9c879759c9ffed6759f1cb6cf5633c6fb2530f13890914293a','[\"*\"]',NULL,NULL,'2026-06-18 11:01:04','2026-06-18 11:01:04'),(23,'App\\Models\\User',284,'hrms-token','1a39fcb6fb4fcd78220778a683452c42f18b6281df628f5c39b56c9a8d2550a5','[\"*\"]',NULL,NULL,'2026-06-18 11:02:06','2026-06-18 11:02:06'),(24,'App\\Models\\User',287,'hrms-token','4ed70c95f18988276220f46c30264f75ac050782c95797981c80dd830729acd0','[\"*\"]',NULL,NULL,'2026-06-18 11:03:17','2026-06-18 11:03:17'),(25,'App\\Models\\User',284,'hrms-token','a21d3a088c0e9beb8569352cdc6870aac042698501054a093ade01d749ad5166','[\"*\"]',NULL,NULL,'2026-06-18 11:04:18','2026-06-18 11:04:18'),(27,'App\\Models\\User',286,'hrms-token','b83776b28279e72b350469c937313c3996aae4f243b5379029342255aaa93373','[\"*\"]',NULL,NULL,'2026-06-21 09:48:19','2026-06-21 09:48:19'),(28,'App\\Models\\User',285,'hrms-token','cd0b21242d28080f09f9711c9d4404bc630c90d683a6fabe36c2cd6b301f7082','[\"*\"]',NULL,NULL,'2026-06-21 09:52:14','2026-06-21 09:52:14'),(29,'App\\Models\\User',284,'hrms-token','924e4cb183d025453b39466078e98690de529d2f68e13af46a49aae601205a58','[\"*\"]',NULL,NULL,'2026-06-21 09:56:44','2026-06-21 09:56:44'),(30,'App\\Models\\User',285,'hrms-token','8ea948cf43ece5862e2be24664a769e8cdc41e42df9fae1ea906b72d22305488','[\"*\"]',NULL,NULL,'2026-06-21 10:06:19','2026-06-21 10:06:19'),(31,'App\\Models\\User',287,'hrms-token','b310c4d4a6a5e39d78d9f90231f240440e3aaca7f238d378b11c097e361d1f4f','[\"*\"]',NULL,NULL,'2026-06-21 10:07:06','2026-06-21 10:07:06'),(35,'App\\Models\\User',284,'hrms-token','e3babb6345bc281109cdb3d25532abd585d453ac5e9422e7baaa978ff6f6ed59','[\"*\"]','2026-06-24 08:59:27',NULL,'2026-06-21 10:49:58','2026-06-24 08:59:27'),(36,'App\\Models\\User',286,'hrms-token','f7a0f0cf08ae5e09d671b11d5efa0af87bfb42433171922cf8beb4717ca75a54','[\"*\"]',NULL,NULL,'2026-06-21 11:01:48','2026-06-21 11:01:48'),(44,'App\\Models\\User',285,'hrms-token','2313c39e532a14c2116f1aeaf03b6b603cbe492abd0b6f22fb7b6f7257a34c8a','[\"*\"]','2026-06-22 07:31:35',NULL,'2026-06-21 11:46:22','2026-06-22 07:31:35'),(53,'App\\Models\\User',284,'hrms-token','57c2d55e6cdb44e450dd4c2088023644bb4144d7e4ac51ca33cd066b924d38e7','[\"*\"]','2026-06-21 13:05:39',NULL,'2026-06-21 12:54:39','2026-06-21 13:05:39'),(54,'App\\Models\\User',284,'hrms-token','604a0016f311eb5039b233a5e332739bc50a6214cd05568cad3c76452abb5059','[\"*\"]',NULL,NULL,'2026-06-22 07:26:54','2026-06-22 07:26:54'),(55,'App\\Models\\User',287,'hrms-token','27f23e817ac49b4f285d74390c47766b50ab1b429e24eb4a6c4944867ca5aeb7','[\"*\"]',NULL,NULL,'2026-06-22 07:27:05','2026-06-22 07:27:05'),(56,'App\\Models\\User',286,'hrms-token','a7d828490a6429d638eb20091b7ecb911b024866ce0ad39ff933b66ba94e74e9','[\"*\"]','2026-06-22 08:06:49',NULL,'2026-06-22 07:49:26','2026-06-22 08:06:49'),(57,'App\\Models\\User',284,'hrms-token','3ad10fae5b7607ba4b6d6e10d7656eaefb560eaaa1bf3e06bdd3c71700a36b5c','[\"*\"]',NULL,NULL,'2026-06-22 08:37:20','2026-06-22 08:37:20'),(58,'App\\Models\\User',287,'hrms-token','5bd7125724c2883a6b3b2f4bd2b059d61198dc117cf964994508376fac68618a','[\"*\"]',NULL,NULL,'2026-06-22 08:37:41','2026-06-22 08:37:41'),(59,'App\\Models\\User',286,'hrms-token','975d76af97109832dc906671b008c99907bdc4a56603beddc0d8e0951e17a3a2','[\"*\"]',NULL,NULL,'2026-06-22 08:49:54','2026-06-22 08:49:54'),(60,'App\\Models\\User',287,'hrms-token','58dc37d096a001244a0b7d8ddad01d3e00d2c791620054b9caea49d35e3aac02','[\"*\"]',NULL,NULL,'2026-06-22 08:50:26','2026-06-22 08:50:26'),(61,'App\\Models\\User',293,'hrms-token','3d95984c9dcb8c902164b03ef69eed062204595e251428fa0d29a7b96eb247e2','[\"*\"]',NULL,NULL,'2026-06-22 09:23:40','2026-06-22 09:23:40'),(62,'App\\Models\\User',285,'hrms-token','d898c22fe00278386bc7f55e16a500f718a7f0255e9db10d1938d0d24f751ff5','[\"*\"]',NULL,NULL,'2026-06-22 10:57:12','2026-06-22 10:57:12'),(63,'App\\Models\\User',284,'hrms-token','cc717fc23a570c6773b1f72f80de6478a684e5f94ac6181513d42e289ef0e073','[\"*\"]',NULL,NULL,'2026-06-22 11:20:22','2026-06-22 11:20:22'),(64,'App\\Models\\User',285,'hrms-token','0e3e2222172d65dd4d0fa07f378f6d92d2b6150b419788a57da93854f588399e','[\"*\"]',NULL,NULL,'2026-06-22 11:31:43','2026-06-22 11:31:43'),(65,'App\\Models\\User',284,'hrms-token','9a067dc7ab4dffed045399a7a61f0b652f336db5942fe359e9adb5bc27cf9a92','[\"*\"]',NULL,NULL,'2026-06-22 11:37:03','2026-06-22 11:37:03'),(66,'App\\Models\\User',287,'hrms-token','234d578a7201e0a2f4851e839fff01dc6c72526cc609a86b8ea02fe09d90f90d','[\"*\"]',NULL,NULL,'2026-06-22 12:12:57','2026-06-22 12:12:57'),(67,'App\\Models\\User',286,'hrms-token','ab9d538ed606a6adaab6b0e9dbd031d69c97f67bc624a4edd3ca0e5033111409','[\"*\"]',NULL,NULL,'2026-06-22 12:14:30','2026-06-22 12:14:30'),(69,'App\\Models\\User',284,'hrms-token','029bda7e3e70ec8b0f2d2060640588f8fc6428b8b9515fd2449e40635665de31','[\"*\"]',NULL,NULL,'2026-06-22 13:35:14','2026-06-22 13:35:14'),(70,'App\\Models\\User',287,'hrms-token','450fb60768a3857f3a3b267c483d7b9e2c08b3e317a3608c3e39a558dbeea5b0','[\"*\"]','2026-06-23 07:46:48',NULL,'2026-06-22 13:36:08','2026-06-23 07:46:48'),(71,'App\\Models\\User',293,'hrms-token','1ae5286a87a779b6a37c6471e68102b89b9c7162fd9c7401230659547b97e2e3','[\"*\"]',NULL,NULL,'2026-06-23 07:49:50','2026-06-23 07:49:50'),(72,'App\\Models\\User',285,'hrms-token','dfa112eb85651a1c0514db20afad7e423838fb783694b9df4ba1a0e0de52ba68','[\"*\"]',NULL,NULL,'2026-06-23 07:54:54','2026-06-23 07:54:54'),(73,'App\\Models\\User',287,'hrms-token','57cbd57319c30714d62ce448764342ac13173b39412452618e1fa76d5becb9a1','[\"*\"]',NULL,NULL,'2026-06-23 07:55:27','2026-06-23 07:55:27'),(74,'App\\Models\\User',293,'hrms-token','bedecb6df0c8dea96879422b36661afb6766e80504df53d1bbe50eb0a422f171','[\"*\"]',NULL,NULL,'2026-06-23 08:09:23','2026-06-23 08:09:23'),(75,'App\\Models\\User',286,'hrms-token','eed8433ad2f6cf8cf7a24aacd3d10eea93e6ae5d36f080e3e8ac88ccdcc519d2','[\"*\"]',NULL,NULL,'2026-06-23 08:13:00','2026-06-23 08:13:00'),(76,'App\\Models\\User',285,'hrms-token','7ee4eeac6cbef94db4106fcddabad75f183e97b7d6e536f3b2a4c274eaf31f56','[\"*\"]',NULL,NULL,'2026-06-23 08:13:32','2026-06-23 08:13:32'),(77,'App\\Models\\User',284,'hrms-token','3fef55fca8521a611dc0af0328c11c473ab92ddb7e86908f32e0ce1dce5d453e','[\"*\"]',NULL,NULL,'2026-06-23 08:15:26','2026-06-23 08:15:26'),(78,'App\\Models\\User',284,'hrms-token','2edb6fb23a731e6335018b29b75a0f5165de12b1f838a763a5cfd65d667e8647','[\"*\"]',NULL,NULL,'2026-06-23 08:16:26','2026-06-23 08:16:26'),(79,'App\\Models\\User',285,'hrms-token','924406a26642c982af9ee23e4e3cf80cb23dcd24968e7aa11f9a2b78ea49dac8','[\"*\"]',NULL,NULL,'2026-06-23 08:17:44','2026-06-23 08:17:44'),(80,'App\\Models\\User',286,'hrms-token','597810417f977ce0badd1ad73b6051fab9174f6b6b13e57d3e73197ebaf9b655','[\"*\"]',NULL,NULL,'2026-06-23 08:18:00','2026-06-23 08:18:00'),(81,'App\\Models\\User',285,'hrms-token','f5c59fa740dcf5f4f6d54e0b6ca0130810e82cb5be6b3787e6733ee99d94b0a1','[\"*\"]',NULL,NULL,'2026-06-23 08:18:08','2026-06-23 08:18:08'),(82,'App\\Models\\User',284,'hrms-token','1f0ee9f79d5bb99476de8767ca0be7506c99e251caacd12af7dc14086345c6dd','[\"*\"]',NULL,NULL,'2026-06-23 08:44:35','2026-06-23 08:44:35'),(83,'App\\Models\\User',284,'hrms-token','ea4144815e461108df9cad4ae8087ddf629939a81dbcb06cb6c5e5a9e6f13b84','[\"*\"]',NULL,NULL,'2026-06-23 08:52:12','2026-06-23 08:52:12'),(84,'App\\Models\\User',284,'hrms-token','d7007e12cf9de57e69c57c7cedd33afef031459be8a1e03b5ae9bfc17455cfe8','[\"*\"]',NULL,NULL,'2026-06-23 08:53:19','2026-06-23 08:53:19'),(85,'App\\Models\\User',288,'hrms-token','c1639cb1b8adb23c87c072d3c68d0f65cbe3b1f74ffd9c7adc9cfd0f96be198f','[\"*\"]',NULL,NULL,'2026-06-23 08:55:03','2026-06-23 08:55:03'),(86,'App\\Models\\User',289,'hrms-token','2469742324fbea4b05ab082b0898ba9282556c1a742dad2f799eacf78b352c39','[\"*\"]',NULL,NULL,'2026-06-23 08:55:21','2026-06-23 08:55:21'),(87,'App\\Models\\User',287,'hrms-token','8a67e164279aa5f9605317b5a3a7342a9ccd473319a3718c4fab9a31fa4e4ca5','[\"*\"]',NULL,NULL,'2026-06-23 08:56:09','2026-06-23 08:56:09'),(88,'App\\Models\\User',289,'hrms-token','3b6e02073e5d407e6726c4fc0d49410eaaaa828eeeebe50723e7a917bbe4eedd','[\"*\"]',NULL,NULL,'2026-06-23 09:11:12','2026-06-23 09:11:12'),(89,'App\\Models\\User',285,'hrms-token','111aead7b262611a61d7bc025163b181da3369fbe3136da480843860c93eb8aa','[\"*\"]',NULL,NULL,'2026-06-23 09:12:10','2026-06-23 09:12:10'),(90,'App\\Models\\User',284,'hrms-token','7bbfdef3e7db3830653a8416d9ad36cda4c243c835b0df568110f7e61cc47581','[\"*\"]',NULL,NULL,'2026-06-23 09:30:33','2026-06-23 09:30:33'),(91,'App\\Models\\User',289,'hrms-token','2f8bffe0a166691aa3d0acbceffc4feb5cdab9d062cfb82c367a45388184d4e2','[\"*\"]',NULL,NULL,'2026-06-23 10:22:16','2026-06-23 10:22:16'),(92,'App\\Models\\User',287,'hrms-token','1dde9dc96c23f03fb4549fff1280443d7ad064f5cbcbfb809d0ff0b9cdd4c9d3','[\"*\"]',NULL,NULL,'2026-06-23 10:22:36','2026-06-23 10:22:36'),(94,'App\\Models\\User',286,'hrms-token','1887ff0a7ba4fe67bb4ee609d7e3aec24f2ab709c8ed46ff68cf284025819c77','[\"*\"]',NULL,NULL,'2026-06-24 08:49:23','2026-06-24 08:49:23'),(95,'App\\Models\\User',285,'hrms-token','5c3acb85adb961a2e07da6b867000d2ce62cf37ef678bf6fa617303cd0ab61da','[\"*\"]',NULL,NULL,'2026-06-24 08:50:33','2026-06-24 08:50:33'),(96,'App\\Models\\User',287,'hrms-token','2de607502e2dad807d4938b248546a06beb7e50fb5d3b84cf374c61f37bb0622','[\"*\"]',NULL,NULL,'2026-06-24 09:10:30','2026-06-24 09:10:30'),(97,'App\\Models\\User',284,'hrms-token','25eac4c60a627912d911ad92ece16261639356b1f2a555e0fbdd1b3d3553f793','[\"*\"]',NULL,NULL,'2026-06-24 09:40:09','2026-06-24 09:40:09'),(98,'App\\Models\\User',286,'hrms-token','14a7c5bcf5625f6307798b44b3fd64d39860072fb3482932982ac9970baf9d53','[\"*\"]',NULL,NULL,'2026-06-24 11:05:33','2026-06-24 11:05:33'),(99,'App\\Models\\User',287,'hrms-token','5232b70a7e6a5a0747c7834f5c2f78944bb940aa170e9264b83e9f58cb4c3f69','[\"*\"]',NULL,NULL,'2026-06-24 12:01:05','2026-06-24 12:01:05'),(100,'App\\Models\\User',286,'hrms-token','77544aa1f0efd12bffb29ac8e25f0f82c5a0aaad20a80c9ae71e10485bf8c8c0','[\"*\"]',NULL,NULL,'2026-06-24 12:11:38','2026-06-24 12:11:38'),(101,'App\\Models\\User',287,'hrms-token','3ae43bf5bc8f6d01df5e4232dceda368ab6f9a1620b5282cc51a1821b38c785e','[\"*\"]','2026-06-25 12:57:00',NULL,'2026-06-24 12:24:55','2026-06-25 12:57:00');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policies`
--

DROP TABLE IF EXISTS `policies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `policies` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) unsigned DEFAULT NULL,
  `audience_type` varchar(20) NOT NULL DEFAULT 'all',
  `target_department_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_department_ids`)),
  `title` varchar(200) NOT NULL,
  `content` longtext DEFAULT NULL,
  `version` varchar(20) NOT NULL DEFAULT '1.0',
  `effective_date` date DEFAULT NULL,
  `review_date` date DEFAULT NULL,
  `requires_acknowledgement` tinyint(1) NOT NULL DEFAULT 1,
  `mandatory` tinyint(1) NOT NULL DEFAULT 0,
  `is_published` tinyint(1) NOT NULL DEFAULT 1,
  `status` varchar(20) NOT NULL DEFAULT 'approved',
  `attachment_path` varchar(255) DEFAULT NULL,
  `attachment_name` varchar(255) DEFAULT NULL,
  `attachment_mime` varchar(255) DEFAULT NULL,
  `attachment_size` bigint(20) unsigned DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `approved_by` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `policies_category_id_foreign` (`category_id`),
  KEY `policies_created_by_foreign` (`created_by`),
  KEY `policies_is_published_effective_date_index` (`is_published`,`effective_date`),
  KEY `policies_approved_by_foreign` (`approved_by`),
  CONSTRAINT `policies_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `policies_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `policy_categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `policies_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policies`
--

LOCK TABLES `policies` WRITE;
/*!40000 ALTER TABLE `policies` DISABLE KEYS */;
INSERT INTO `policies` VALUES (1,NULL,'all',NULL,'HR Leave policy','new leave policy','1.0','2026-06-21','2027-06-21',1,0,1,'approved','policies/YNv4XWznSYSDBf0VLsAcpGXZCFMR1CtLfKRD1ps3.pdf','PRD.pdf','application/pdf',397497,284,NULL,NULL,'2026-06-21 12:31:10','2026-06-21 12:31:10');
/*!40000 ALTER TABLE `policies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy_acknowledgements`
--

DROP TABLE IF EXISTS `policy_acknowledgements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_acknowledgements` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `policy_id` bigint(20) unsigned NOT NULL,
  `employee_id` bigint(20) unsigned NOT NULL,
  `policy_version` varchar(20) NOT NULL DEFAULT '1.0',
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `acknowledged_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `policy_acknowledgements_policy_id_employee_id_unique` (`policy_id`,`employee_id`),
  UNIQUE KEY `policy_ack_unique_per_version` (`policy_id`,`employee_id`,`policy_version`),
  KEY `policy_acknowledgements_employee_id_foreign` (`employee_id`),
  CONSTRAINT `policy_acknowledgements_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `policy_acknowledgements_policy_id_foreign` FOREIGN KEY (`policy_id`) REFERENCES `policies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_acknowledgements`
--

LOCK TABLES `policy_acknowledgements` WRITE;
/*!40000 ALTER TABLE `policy_acknowledgements` DISABLE KEYS */;
INSERT INTO `policy_acknowledgements` VALUES (1,1,108,'1.0','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','2026-06-21 12:32:40','2026-06-21 12:32:40','2026-06-21 12:32:40');
/*!40000 ALTER TABLE `policy_acknowledgements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy_categories`
--

DROP TABLE IF EXISTS `policy_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(120) NOT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `policy_categories_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_categories`
--

LOCK TABLES `policy_categories` WRITE;
/*!40000 ALTER TABLE `policy_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `policy_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy_reads`
--

DROP TABLE IF EXISTS `policy_reads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_reads` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `policy_id` bigint(20) unsigned NOT NULL,
  `employee_id` bigint(20) unsigned NOT NULL,
  `read_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `policy_reads_policy_id_employee_id_unique` (`policy_id`,`employee_id`),
  KEY `policy_reads_employee_id_foreign` (`employee_id`),
  CONSTRAINT `policy_reads_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `policy_reads_policy_id_foreign` FOREIGN KEY (`policy_id`) REFERENCES `policies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_reads`
--

LOCK TABLES `policy_reads` WRITE;
/*!40000 ALTER TABLE `policy_reads` DISABLE KEYS */;
INSERT INTO `policy_reads` VALUES (2,1,108,'2026-06-22 07:49:56','2026-06-22 07:49:56','2026-06-22 07:49:56');
/*!40000 ALTER TABLE `policy_reads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `request_comments`
--

DROP TABLE IF EXISTS `request_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `request_comments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `request_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `comment` text NOT NULL,
  `is_internal` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `request_comments_request_id_foreign` (`request_id`),
  KEY `request_comments_user_id_foreign` (`user_id`),
  CONSTRAINT `request_comments_request_id_foreign` FOREIGN KEY (`request_id`) REFERENCES `employee_requests` (`id`) ON DELETE CASCADE,
  CONSTRAINT `request_comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `request_comments`
--

LOCK TABLES `request_comments` WRITE;
/*!40000 ALTER TABLE `request_comments` DISABLE KEYS */;
INSERT INTO `request_comments` VALUES (1,1,284,'Request completed. ffffffff',0,'2026-04-12 08:11:42','2026-04-12 08:11:42'),(2,1,284,'Request completed. ffffffff',0,'2026-04-12 08:11:47','2026-04-12 08:11:47'),(3,2,284,'Request assigned to System Admin and is now in progress.',1,'2026-04-12 09:05:16','2026-04-12 09:05:16'),(4,3,284,'Request assigned to self and is now in progress.',1,'2026-04-13 09:57:01','2026-04-13 09:57:01'),(5,2,287,'Request completed. completd',0,'2026-06-21 12:18:48','2026-06-21 12:18:48'),(6,6,284,'Request assigned to Saad Alshaya and is now in progress.',1,'2026-06-21 12:35:52','2026-06-21 12:35:52');
/*!40000 ALTER TABLE `request_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `request_types`
--

DROP TABLE IF EXISTS `request_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `request_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `code` varchar(30) NOT NULL,
  `category` varchar(60) NOT NULL DEFAULT 'general',
  `description` text DEFAULT NULL,
  `instructions` text DEFAULT NULL,
  `sla_days` int(11) NOT NULL DEFAULT 3,
  `requires_attachment` tinyint(1) NOT NULL DEFAULT 0,
  `requires_manager_approval` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `icon` varchar(50) NOT NULL DEFAULT 'description',
  `color` varchar(20) NOT NULL DEFAULT '#6366f1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `request_types_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `request_types`
--

LOCK TABLES `request_types` WRITE;
/*!40000 ALTER TABLE `request_types` DISABLE KEYS */;
INSERT INTO `request_types` VALUES (1,'Exit Re-entry Visa (Single)','VISA_EXIT_S','visa',NULL,'Please provide your passport copy, ID copy, and intended travel dates.',5,0,0,1,1,'flight_takeoff','#3b82f6','2026-04-12 07:14:15','2026-04-12 07:14:15'),(2,'Exit Re-entry Visa (Multiple)','VISA_EXIT_M','visa',NULL,'Provide passport copy, ID copy, duration needed, and travel purpose.',7,0,0,1,2,'flight_takeoff','#3b82f6','2026-04-12 07:14:15','2026-04-12 07:14:15'),(3,'Visit Visa for Family','VISA_FAMILY','visa',NULL,'Provide family member details (name, passport, relationship) and visit duration.',7,0,0,1,3,'family_restroom','#6366f1','2026-04-12 07:14:15','2026-04-12 07:14:15'),(4,'Business Visa Support Letter','VISA_BIZ','visa',NULL,'Specify destination country, business purpose, and travel dates.',3,0,0,1,4,'business_center','#0ea5e9','2026-04-12 07:14:15','2026-04-12 07:14:15'),(5,'Air Ticket Request','TRAVEL_TICKET','travel',NULL,'Provide travel dates, destination, preferred airline if any, and reason for travel.',3,0,0,1,10,'airplane_ticket','#f59e0b','2026-04-12 07:14:15','2026-04-12 07:14:15'),(6,'Air Ticket Allowance Letter','TRAVEL_LETTER','travel',NULL,'Specify destination and travel dates for the allowance letter.',2,0,0,1,11,'mail','#f59e0b','2026-04-12 07:14:15','2026-04-12 07:14:15'),(7,'Salary Certificate','DOC_SALARY','documents',NULL,'Specify if required for bank, embassy, or other purpose. Mention language (Arabic/English).',2,0,0,1,20,'payments','#10b981','2026-04-12 07:14:15','2026-04-12 07:14:15'),(8,'Employment Certificate','DOC_EMPLOY','documents',NULL,'Mention the purpose (bank, embassy, other) and required language.',2,0,0,1,21,'badge','#10b981','2026-04-12 07:14:15','2026-04-12 07:14:15'),(9,'Experience Letter','DOC_EXP','documents',NULL,'Provide the addressee details if directed to a specific party.',3,0,0,1,22,'workspace_premium','#10b981','2026-04-12 07:14:15','2026-04-12 07:14:15'),(10,'NOC Letter','DOC_NOC','documents',NULL,'State the purpose of the NOC and to whom it is addressed.',3,0,1,1,23,'verified','#10b981','2026-04-12 07:14:15','2026-04-12 07:14:15'),(11,'Bank Letter','DOC_BANK','documents',NULL,'Mention your bank name, account details, and purpose of the letter.',2,0,0,1,24,'account_balance','#10b981','2026-04-12 07:14:15','2026-04-12 07:14:15'),(12,'Salary Transfer Letter','DOC_SALARY_TR','documents',NULL,'Provide new bank name and account number for the transfer.',2,0,0,1,25,'swap_horiz','#10b981','2026-04-12 07:14:15','2026-04-12 07:14:15'),(13,'GOSI Certificate','DOC_GOSI','documents',NULL,'Specify required for personal use or third party.',3,0,0,1,26,'health_and_safety','#10b981','2026-04-12 07:14:15','2026-04-12 07:14:15'),(14,'Advance Salary Request','HR_ADVANCE','hr',NULL,'State the advance amount needed and reason.',5,0,1,1,30,'monetization_on','#8b5cf6','2026-04-12 07:14:15','2026-04-12 07:14:15'),(15,'Change of Information','HR_INFO','hr',NULL,'Describe the information that needs to be updated and attach supporting documents.',3,0,0,1,31,'manage_accounts','#8b5cf6','2026-04-12 07:14:15','2026-04-12 07:14:15'),(16,'Work From Home Request','HR_WFH','hr',NULL,'Specify dates and reason for WFH request.',2,0,1,1,32,'home_work','#8b5cf6','2026-04-12 07:14:15','2026-04-12 07:14:15'),(17,'Training Request','HR_TRAIN','hr',NULL,'Provide training name, provider, dates, and how it benefits your role.',5,0,1,1,33,'school','#8b5cf6','2026-04-12 07:14:15','2026-04-12 07:14:15'),(18,'IT Equipment Request','IT_EQUIP','it',NULL,'Specify equipment type, model if preferred, and business justification.',5,0,1,1,40,'computer','#ef4444','2026-04-12 07:14:15','2026-04-12 07:14:15'),(19,'Software Access Request','IT_ACCESS','it',NULL,'Specify the system/software name and the access level required.',3,0,1,1,41,'lock_open','#ef4444','2026-04-12 07:14:15','2026-04-12 07:14:15'),(20,'Email / Account Setup','IT_EMAIL','it',NULL,'Provide details of the account or email needed.',2,0,0,1,42,'email','#ef4444','2026-04-12 07:14:15','2026-04-12 07:14:15'),(21,'Parking Pass Request','ADMIN_PARK','admin',NULL,'Provide vehicle plate number, make, and model.',3,0,0,1,50,'local_parking','#ec4899','2026-04-12 07:14:15','2026-04-12 07:14:15'),(22,'Business Card Request','ADMIN_CARD','admin',NULL,'Confirm your name, designation, phone, and email to appear on the card.',5,0,0,1,51,'contact_page','#ec4899','2026-04-12 07:14:15','2026-04-12 07:14:15'),(23,'Office Supply Request','ADMIN_SUPPLY','admin',NULL,'List the items needed with quantities.',2,0,0,1,52,'inventory_2','#ec4899','2026-04-12 07:14:15','2026-04-12 07:14:15');
/*!40000 ALTER TABLE `request_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_has_permissions`
--

DROP TABLE IF EXISTS `role_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) unsigned NOT NULL,
  `role_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `role_has_permissions_role_id_foreign` (`role_id`),
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_has_permissions`
--

LOCK TABLES `role_has_permissions` WRITE;
/*!40000 ALTER TABLE `role_has_permissions` DISABLE KEYS */;
INSERT INTO `role_has_permissions` VALUES (2539,351),(2539,352),(2539,353),(2539,354),(2539,355),(2539,356),(2540,351),(2540,352),(2540,353),(2540,354),(2540,355),(2541,351),(2541,352),(2541,353),(2542,351),(2542,352),(2542,353),(2543,351),(2543,352),(2544,351),(2544,352),(2544,354),(2545,351),(2545,352),(2545,353),(2546,351),(2546,352),(2546,353),(2546,354),(2547,351),(2547,352),(2548,351),(2548,352),(2548,354),(2549,351),(2549,352),(2549,354),(2550,351),(2550,356),(2551,351),(2551,352),(2551,353),(2551,355),(2552,351),(2552,352),(2552,353),(2552,355),(2553,351),(2553,352),(2554,351),(2554,352),(2555,351),(2555,354),(2555,356),(2556,351),(2556,354),(2556,356),(2557,351),(2557,352),(2557,353),(2557,354),(2557,355),(2558,351),(2558,355),(2559,351),(2559,352),(2560,351),(2560,354),(2561,351),(2561,354),(2562,351),(2562,352),(2563,351),(2563,356),(2564,351),(2564,356),(2565,351),(2565,352),(2565,353),(2565,355),(2566,351),(2566,352),(2566,353),(2567,351),(2567,355),(2568,351),(2568,352),(2568,354),(2569,351),(2569,352),(2570,351),(2570,352),(2570,353),(2570,355),(2571,351),(2571,352),(2571,353),(2572,351),(2572,352),(2572,355),(2573,351),(2573,352),(2574,351),(2574,354),(2574,356),(2575,351),(2575,354),(2575,356),(2576,351),(2576,352),(2576,353),(2577,351),(2577,352),(2578,351),(2578,352),(2578,353),(2578,355),(2579,351),(2579,352),(2579,355),(2580,351),(2580,352),(2580,353),(2580,355),(2581,351),(2581,354),(2581,356),(2582,351),(2582,352),(2582,353),(2582,354),(2582,355),(2582,356),(2583,351),(2583,352),(2583,353),(2584,351),(2584,352),(2585,351),(2585,352),(2585,353),(2585,354),(2585,355),(2585,356),(2586,351),(2586,352),(2587,351),(2587,352),(2588,351);
/*!40000 ALTER TABLE `role_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=364 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (351,'super_admin','web','2026-04-12 07:14:14','2026-04-12 07:14:14'),(352,'hr_manager','web','2026-04-12 07:14:14','2026-04-12 07:14:14'),(353,'hr_staff','web','2026-04-12 07:14:14','2026-04-12 07:14:14'),(354,'finance_manager','web','2026-04-12 07:14:14','2026-04-12 07:14:14'),(355,'department_manager','web','2026-04-12 07:14:14','2026-04-12 07:14:14'),(356,'employee','web','2026-04-12 07:14:14','2026-04-12 07:14:14');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `separations`
--

DROP TABLE IF EXISTS `separations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `separations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `reference` varchar(30) NOT NULL,
  `employee_id` bigint(20) unsigned NOT NULL,
  `type` enum('resignation','termination','end_of_contract','retirement','abandonment','mutual_agreement') NOT NULL,
  `status` enum('draft','submitted','pending_manager','pending_hr','approved','offboarding','completed','cancelled','rejected') NOT NULL DEFAULT 'draft',
  `request_date` date NOT NULL,
  `last_working_day` date NOT NULL,
  `notice_period_start` date DEFAULT NULL,
  `notice_period_days` int(11) NOT NULL DEFAULT 30,
  `notice_waived` tinyint(1) NOT NULL DEFAULT 0,
  `notice_waived_reason` text DEFAULT NULL,
  `reason` text NOT NULL,
  `reason_category` enum('personal','better_opportunity','relocation','health','misconduct','performance','restructuring','contract_end','other') DEFAULT NULL,
  `hr_notes` text DEFAULT NULL,
  `initiated_by` bigint(20) unsigned NOT NULL,
  `manager_approved_by` bigint(20) unsigned DEFAULT NULL,
  `manager_approved_at` timestamp NULL DEFAULT NULL,
  `hr_approved_by` bigint(20) unsigned DEFAULT NULL,
  `hr_approved_at` timestamp NULL DEFAULT NULL,
  `rejected_by` bigint(20) unsigned DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `exit_interview_required` tinyint(1) NOT NULL DEFAULT 1,
  `exit_interview_done` tinyint(1) NOT NULL DEFAULT 0,
  `exit_interview_date` date DEFAULT NULL,
  `exit_interview_notes` text DEFAULT NULL,
  `gratuity_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `leave_encashment` decimal(12,2) NOT NULL DEFAULT 0.00,
  `other_deductions` decimal(12,2) NOT NULL DEFAULT 0.00,
  `other_additions` decimal(12,2) NOT NULL DEFAULT 0.00,
  `final_settlement_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `settlement_paid` tinyint(1) NOT NULL DEFAULT 0,
  `settlement_paid_date` date DEFAULT NULL,
  `settlement_notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `separations_reference_unique` (`reference`),
  KEY `separations_employee_id_foreign` (`employee_id`),
  KEY `separations_initiated_by_foreign` (`initiated_by`),
  KEY `separations_manager_approved_by_foreign` (`manager_approved_by`),
  KEY `separations_hr_approved_by_foreign` (`hr_approved_by`),
  KEY `separations_rejected_by_foreign` (`rejected_by`),
  CONSTRAINT `separations_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `separations_hr_approved_by_foreign` FOREIGN KEY (`hr_approved_by`) REFERENCES `users` (`id`),
  CONSTRAINT `separations_initiated_by_foreign` FOREIGN KEY (`initiated_by`) REFERENCES `users` (`id`),
  CONSTRAINT `separations_manager_approved_by_foreign` FOREIGN KEY (`manager_approved_by`) REFERENCES `users` (`id`),
  CONSTRAINT `separations_rejected_by_foreign` FOREIGN KEY (`rejected_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `separations`
--

LOCK TABLES `separations` WRITE;
/*!40000 ALTER TABLE `separations` DISABLE KEYS */;
INSERT INTO `separations` VALUES (1,'SEP-2026-00001',107,'resignation','pending_manager','2026-06-21','2026-07-21','2026-06-21',30,0,NULL,'hhhhhhhhhffffffffffffffffffffffffff','personal',NULL,287,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,NULL,0.00,0.00,0.00,0.00,0.00,0,NULL,NULL,'2026-06-21 12:20:44','2026-06-21 12:20:44');
/*!40000 ALTER TABLE `separations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(100) NOT NULL,
  `value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `system_settings_key_unique` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_settings`
--

LOCK TABLES `system_settings` WRITE;
/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
INSERT INTO `system_settings` VALUES (1,'loan_approval_levels','2','2026-06-21 12:49:37','2026-06-21 12:49:37'),(2,'birthday_wishes_enabled','1','2026-06-22 07:28:46','2026-06-22 07:28:46'),(3,'birthday_wish_subject','Happy Birthday, {{employee_name}}!','2026-06-22 07:28:46','2026-06-22 07:28:46'),(4,'birthday_wish_body','Dear {{first_name}},\r\n\r\nWishing you a very happy birthday and a wonderful year ahead!\r\n\r\nBest wishes,\r\n{{company_name}}','2026-06-22 07:28:46','2026-06-22 07:28:46'),(5,'birthday_wish_background_image',NULL,'2026-06-22 07:28:46','2026-06-22 07:28:46'),(6,'non_saudi_max_dependent_tickets','3','2026-06-21 10:38:37','2026-06-21 10:38:37'),(9,'birthday_wish_subject_ar','','2026-06-22 07:28:46','2026-06-22 07:28:46'),(10,'birthday_wish_body_ar','عزيزي/عزيزتي {{first_name}}،\r\n\r\nنتمنى لك عيد ميلاد سعيدًا وعامًا مليئًا بالنجاح!\r\n\r\nمع أطيب التمنيات،\r\n{{company_name}}','2026-06-22 07:28:46','2026-06-22 07:28:46'),(11,'monthly_leave_reminder_enabled','1','2026-06-24 13:25:09','2026-06-24 13:25:09'),(12,'monthly_leave_reminder_day','24','2026-06-24 13:25:09','2026-06-24 13:25:09'),(13,'monthly_leave_reminder_subject','Reminder: Leave Submission Reminder-{{month_name}} {{year}}','2026-06-24 13:25:09','2026-06-24 13:25:09'),(14,'monthly_leave_reminder_body','Dear {{first_name}},\n\nPlease ensure that all leave requests for {{month_name}} {{year}} are submitted and approved in the HRMS before payroll processing.\nKindly note that any leave taken but not recorded in the HRMS, or any pending/unsubmitted leave requests, may be treated as unpaid leave and deducted from salary in accordance with company policy.\nWe request everyone to review their leave records and complete any pending submissions at the earliest to avoid payroll discrepancies.\n\nRegards,\nHuman Resources','2026-06-24 13:25:09','2026-06-24 13:25:09'),(15,'monthly_leave_reminder_last_sent_month','2026-06','2026-06-24 13:26:13','2026-06-24 13:26:13');
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `units` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `code` varchar(50) NOT NULL,
  `legacy_unitid` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `units_code_unique` (`code`),
  KEY `units_legacy_unitid_index` (`legacy_unitid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,'Head office','RUH','1','Riyadh head office',1,'2026-06-25 12:53:48','2026-06-25 12:53:48',NULL),(2,'Jeddah Branch','JED','2','Jeddah branch',1,'2026-06-25 12:54:27','2026-06-25 12:54:27',NULL);
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (284,'System Admin','admin@hrms.com',NULL,'$2y$12$/YHlWGwJZsLlHg9nE.XCxuDopE/dLhjQdDMNxJEzlsEMeqvwOKfpm',NULL,'2026-04-12 07:14:15','2026-04-12 07:16:55'),(285,'jithin varkey','jithinvarkey@gmail.com',NULL,'$2y$12$nYom1s8j536XU4X61xznUebI2AkTv/kq38reyQrE3cP4PMV3THU..',NULL,'2026-04-13 10:56:11','2026-06-18 10:13:31'),(286,'Jinesh Mani','j.mani@dbroker.com.sa',NULL,'$2y$12$MGXLooZ5WjrO8NU1cGFHx.tfZR57d5CRv428vIdKW30b875Ye3xt2',NULL,'2026-06-18 10:12:59','2026-06-18 10:20:36'),(287,'Saad Alshaya','s.alshaya@dbroker.com.sa',NULL,'$2y$12$3/e6VaWJVodU8Ce/VvYvH.pnmbJj/5ZhuMzXwTn.4ocUwage.peC.',NULL,'2026-06-18 10:18:58','2026-06-18 10:19:19'),(288,'Ahmed Helmy','a.helmy@dbroker.com.sa',NULL,'$2y$12$lcq.cwbrLlZi5UfnCzqfK.5pwcJYiON5MSHhx9t2AptDaC.XaYIzS',NULL,'2026-06-18 10:24:34','2026-06-18 10:25:11'),(289,'Badr Alshaya','b.alshaya@dbroker.com.sa',NULL,'$2y$12$gtqN3Wa0Mo.SQ5jyMAZEj.mDHXO9IoTyRjmw/kYYTCrhlz3dnTrze',NULL,'2026-06-18 11:06:24','2026-06-23 08:54:07'),(292,'Hany Hashem','h.hashem@dbroker.com.sa',NULL,'$2y$12$tuM7wmkdFxOV.NYo5wDSQ.IDkDYOT1MP20qonaxomJAywZAuyLRay',NULL,'2026-06-18 13:25:27','2026-06-18 13:26:07'),(293,'Azher Mohammed','m.azher@dbroker.com.sa',NULL,'$2y$12$iuj3h8lHiEaaAWHQpFi3UuN1fHIctfTx1ziMTvCxRMAOO5rabSgK6',NULL,'2026-06-18 13:31:24','2026-06-18 13:32:52'),(299,'Mohammed Abdulfaisal','m.faisal@dbroker.com.sa',NULL,'$2y$12$iPP8J0SE.r0.fr5i5kCZE.E/IdxVXFlr6NALqteLRC7aCvETVkJNi',NULL,'2026-06-24 09:56:00','2026-06-24 09:56:00'),(300,'Kiran raj','kiran@gmail.com',NULL,'$2y$12$cZppI7zvr2ceEURIjIDheuuLv.C2Sy1W.caec00soKAxLfNeePFQO',NULL,'2026-06-25 11:18:19','2026-06-25 11:18:19');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'hrsystem'
--

--
-- Dumping routines for database 'hrsystem'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-25 15:57:02
