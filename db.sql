-- MySQL dump 10.15  Distrib 10.0.36-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: sign
-- ------------------------------------------------------
-- Server version       10.0.36-MariaDB-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `qrtz_fired_triggers`
--DROP TABLE IF EXISTS `qrtz_fired_triggers`;/*!40101 SET @saved_cs_client     = @@character_set_client */;/*!40101 SET character_set_client = utf8 */;CREATE TABLE `qrtz_fired_triggers` (  `SCHED_NAME` varchar(120) NOT NULL,  `ENTRY_ID` varchar(95) NOT NULL,  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `FIRED_TIME` bigint(13) NOT NULL,
  `SCHED_TIME` bigint(13) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `STATE` varchar(16) NOT NULL,
  `JOB_NAME` varchar(200) DEFAULT NULL,
  `JOB_GROUP` varchar(200) DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`ENTRY_ID`),
  KEY `IDX_QRTZ_FT_T_G` (`SCHED_NAME`,`TRIGGER_NAME`(191),`TRIGGER_GROUP`(191)),
  KEY `IDX_QRTZ_FT_TG` (`SCHED_NAME`,`TRIGGER_GROUP`(191)),
  KEY `IDX_QRTZ_FT_INST_JOB_REQ_RCVRY` (`SCHED_NAME`,`INSTANCE_NAME`(191),`REQUESTS_RECOVERY`),
  KEY `IDX_QRTZ_FT_TRIG_INST_NAME` (`SCHED_NAME`,`INSTANCE_NAME`(191)),
  KEY `IDX_QRTZ_FT_J_G` (`SCHED_NAME`,`JOB_NAME`(191),`JOB_GROUP`(191)),
  KEY `IDX_QRTZ_FT_JG` (`SCHED_NAME`,`JOB_GROUP`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_locks`
--

DROP TABLE IF EXISTS `qrtz_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_locks` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `LOCK_NAME` varchar(40) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schedule_job`
--

DROP TABLE IF EXISTS `schedule_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule_job` (
  `schedule_job_id` bigint(20) NOT NULL COMMENT 'ID主键',
  `job_name` varchar(200) NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) NOT NULL COMMENT '任务分组',
  `clazz` varchar(500) NOT NULL COMMENT '定时任务对应的类（包括包路径）',
  `job_status` varchar(2) NOT NULL COMMENT '任务状态 1禁用 2启用',
  `cron_expression` varchar(200) DEFAULT NULL COMMENT '任务运行时间表达式',
  `time_value` int(11) DEFAULT NULL COMMENT '简单时间格式的值',
  `time_type` varchar(50) DEFAULT NULL COMMENT '简单时间格式的类型：天、时、分、秒',
  `job_desc` varchar(500) DEFAULT NULL COMMENT '任务描述',
  `create_man` bigint(20) NOT NULL,
  `create_time` datetime NOT NULL,
  `update_man` bigint(20) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`schedule_job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_class_info`
--

DROP TABLE IF EXISTS `sign_class_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_class_info` (
  `id_class_info` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类信息表主键',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `created_date` datetime DEFAULT NULL COMMENT '创建时间',
  `class_name` varchar(30) DEFAULT NULL COMMENT '分类名称',
  `class_desc` varchar(200) DEFAULT NULL COMMENT '分类备注',
  `updated_by` varchar(20) DEFAULT NULL COMMENT '修改人',
  `updated_date` datetime DEFAULT NULL COMMENT '修改时间',
  `id_task_info` int(8) DEFAULT NULL,
  PRIMARY KEY (`id_class_info`)
) ENGINE=InnoDB AUTO_INCREMENT=3737 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_collect_info`
--

DROP TABLE IF EXISTS `sign_collect_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_collect_info` (
  `id_collect` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `created_date` datetime NOT NULL COMMENT '创建时间',
  `created_by` varchar(100) DEFAULT NULL COMMENT '创建人',
  `updated_by` varchar(100) DEFAULT NULL COMMENT '更新人',
  `updated_date` datetime DEFAULT NULL COMMENT '更新时间',
  `id_group` int(11) DEFAULT NULL COMMENT '分组ID',
  `id_task_info` int(11) NOT NULL COMMENT '用户任务ID',
  PRIMARY KEY (`id_collect`)
) ENGINE=InnoDB AUTO_INCREMENT=11631 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_file_list_info`
--

DROP TABLE IF EXISTS `sign_file_list_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_file_list_info` (
  `id_file_list` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片ID',
  `created_date` datetime NOT NULL COMMENT '创建时间',
  `created_by` varchar(100) DEFAULT NULL COMMENT '创建人',
  `updated_by` varchar(100) DEFAULT NULL COMMENT '更新人',
  `updated_date` datetime DEFAULT NULL COMMENT '更新时间',
  `active_flag` varchar(50) DEFAULT NULL COMMENT '图片状态',
  `file_name` varchar(100) DEFAULT NULL COMMENT '图片名称',
  `file_src` varchar(500) DEFAULT NULL COMMENT '图片路径',
  `id_collect` int(11) DEFAULT NULL COMMENT '批次号',
  `file_zoom_src` varchar(500) DEFAULT NULL,
  `height` int(6) DEFAULT NULL,
  `width` int(6) DEFAULT NULL,
  PRIMARY KEY (`id_file_list`)
) ENGINE=InnoDB AUTO_INCREMENT=11656 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_group`
--

DROP TABLE IF EXISTS `sign_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_group` (
  `id_group` int(11) NOT NULL AUTO_INCREMENT,
  `created_date` datetime DEFAULT NULL,
  `created_by` varchar(20) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` varchar(20) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  `enabled` tinyint(4) DEFAULT '1',
  PRIMARY KEY (`id_group`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_info`
--

DROP TABLE IF EXISTS `sign_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_info` (
  `id_sign_info` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID自增长',
  `created_date` datetime NOT NULL COMMENT '创建时间',
  `created_by` varchar(100) DEFAULT NULL COMMENT '创建人',
  `updated_by` varchar(100) DEFAULT NULL COMMENT '更新人',
  `updated_date` datetime NOT NULL COMMENT '更新时间',
  `upload_by` varchar(50) DEFAULT NULL COMMENT '上传人',
  `sign_by` varchar(50) DEFAULT NULL COMMENT '标注人',
  `audit_by` varchar(50) DEFAULT NULL COMMENT '审核人',
  `id_file_list` int(11) DEFAULT NULL COMMENT '图片ID',
  `id_user` int(11) DEFAULT NULL COMMENT '会员ID',
  `id_group` int(11) DEFAULT NULL COMMENT '分组ID',
  `id_task_info` int(11) DEFAULT NULL COMMENT '任务ID',
  `state` varchar(50) DEFAULT NULL COMMENT '标注状态',
  `audit_msg` varchar(3000) DEFAULT NULL COMMENT '审核失败原因',
  `id_collect` int(11) DEFAULT NULL COMMENT '批次ID',
  `sign_detail` varchar(500) DEFAULT NULL COMMENT '标注信息',
  `id_train_info` int(11) DEFAULT NULL,
  `id_class_info` int(8) DEFAULT NULL,
  PRIMARY KEY (`id_sign_info`)
) ENGINE=InnoDB AUTO_INCREMENT=11533 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_label_info`
--

DROP TABLE IF EXISTS `sign_label_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_label_info` (
  `id_label_info` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户信息表主键',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `created_date` datetime DEFAULT NULL COMMENT '创建时间',
  `id_file` int(11) DEFAULT NULL COMMENT '图片外键\n',
  `lable_info` text COMMENT '标注信息',
  `label_name` varchar(30) DEFAULT NULL COMMENT '标注名称',
  `label_remark` varchar(200) DEFAULT NULL COMMENT '标注备注',
  `update_by` varchar(20) DEFAULT NULL COMMENT '修改人',
  `update_date` datetime DEFAULT NULL COMMENT '修改时间',
  `label_zoom_info` text,
  PRIMARY KEY (`id_label_info`)
) ENGINE=InnoDB AUTO_INCREMENT=6211 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_resource`
--

DROP TABLE IF EXISTS `sign_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_resource` (
  `id_resource` int(11) NOT NULL AUTO_INCREMENT COMMENT '请求资源表主键',
  `created_date` datetime NOT NULL COMMENT '创建时间',
  `created_by` varchar(20) NOT NULL DEFAULT 'system' COMMENT '创建人',
  `id_parent` int(11) NOT NULL COMMENT '父资源主键，最高级别的父主键为0',
  `resource_code` varchar(10) NOT NULL COMMENT '请求资源编码',
  `enabled` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否可用',
  `resource_name` varchar(10) NOT NULL COMMENT '请求资源名称',
  `resource_url` varchar(50) DEFAULT NULL COMMENT '资源请求的地址，用于拦截资源请求路径',
  `resource_type` varchar(10) NOT NULL COMMENT '资源的类型，纯视图拦截为view，带url为handle',
  `resource_level` int(2) NOT NULL COMMENT '资源的分层等级，最高层为1',
  `is_config` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否可配置',
  PRIMARY KEY (`id_resource`)
) ENGINE=InnoDB AUTO_INCREMENT=100000004 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_resource_role`
--

DROP TABLE IF EXISTS `sign_resource_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_resource_role` (
  `id_role_resource` int(11) NOT NULL COMMENT '请求资源角色关联表主键',
  `created_date` datetime NOT NULL COMMENT '创建时间',
  `created_by` varchar(10) NOT NULL DEFAULT 'system' COMMENT '创建人',
  `enabled` bit(1) NOT NULL COMMENT '是否可用',
  `id_role` int(11) NOT NULL COMMENT '角色外键',
  `id_resource` int(11) NOT NULL COMMENT '资源外键',
  `id_user_group` int(11) DEFAULT NULL COMMENT '保留字段，用于扩展，用户分组主键',
  PRIMARY KEY (`id_role_resource`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_role`
--

DROP TABLE IF EXISTS `sign_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_role` (
  `id_role` int(11) NOT NULL AUTO_INCREMENT COMMENT '角色的主键',
  `created_date` datetime NOT NULL COMMENT '创建时间',
  `created_by` varchar(20) NOT NULL DEFAULT 'system' COMMENT '角色创建人',
  `update_date` datetime DEFAULT NULL COMMENT '角色修改时间',
  `update_by` varchar(20) DEFAULT '' COMMENT '角色修改人',
  `description` varchar(100) DEFAULT NULL COMMENT '主角的描述说明',
  `enabled` bit(1) NOT NULL DEFAULT b'1' COMMENT '角色是否可用',
  `role_code` varchar(10) NOT NULL COMMENT '角色编码',
  `role_name` varchar(10) NOT NULL COMMENT '角色名称',
  PRIMARY KEY (`id_role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_task_info`
--

DROP TABLE IF EXISTS `sign_task_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_task_info` (
  `id_task_info` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户任务表主键',
  `created_date` datetime NOT NULL COMMENT '创建时间',
  `created_by` varchar(20) NOT NULL DEFAULT 'system' COMMENT '创建人',
  `updated_date` datetime NOT NULL COMMENT '更新时间',
  `updated_by` varchar(50) NOT NULL DEFAULT 'system' COMMENT '更新人',
  `id_group` int(11) NOT NULL COMMENT '分组ID',
  `task_name` varchar(256) DEFAULT NULL COMMENT '用户任务表名称',
  `active_flag` varchar(256) NOT NULL DEFAULT 'Y' COMMENT '是否可用',
  PRIMARY KEY (`id_task_info`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_train_info`
--

DROP TABLE IF EXISTS `sign_train_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_train_info` (
  `id_train_info` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键iD自增长',
  `created_date` datetime NOT NULL COMMENT '创建时间',
  `created_by` varchar(100) DEFAULT NULL COMMENT '创建人',
  `updated_by` varchar(100) DEFAULT NULL COMMENT '更新人',
  `updated_date` datetime NOT NULL COMMENT '更新时间',
  `status` varchar(50) DEFAULT NULL COMMENT '是否有效',
  `log_file_name` varchar(100) DEFAULT NULL COMMENT '日志文件名',
  `train_config` text COMMENT '训练参数',
  `id_task_info` int(11) DEFAULT NULL,
  `train_type` varchar(20) DEFAULT NULL,
  `trainStatus` int(2) DEFAULT NULL,
  `train_status` int(2) DEFAULT NULL,
  PRIMARY KEY (`id_train_info`)
) ENGINE=InnoDB AUTO_INCREMENT=253 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_tranction_info`
--

DROP TABLE IF EXISTS `sign_tranction_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_tranction_info` (
  `id_tranction` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键iD自增长',
  `created_date` datetime NOT NULL COMMENT '创建时间',
  `created_by` varchar(100) DEFAULT NULL COMMENT '创建人',
  `updated_by` varchar(100) DEFAULT NULL COMMENT '更新人',
  `updated_date` datetime NOT NULL COMMENT '更新时间',
  `id_sign_info` int(11) DEFAULT NULL COMMENT '标注信息ID',
  `status` varchar(50) DEFAULT NULL COMMENT '标注状态',
  `sign_result` varchar(100) DEFAULT NULL COMMENT '标注结果',
  `sign_msg` varchar(3000) DEFAULT NULL COMMENT '失败原因',
  PRIMARY KEY (`id_tranction`)
) ENGINE=InnoDB AUTO_INCREMENT=19349 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_user`
--

DROP TABLE IF EXISTS `sign_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_name` varchar(50) DEFAULT NULL COMMENT '用户名',
  `password` varchar(50) DEFAULT NULL COMMENT '密码',
  `email` varchar(50) DEFAULT NULL,
  `user_status` int(8) DEFAULT '1' COMMENT '用户状态:0未启用，1：启用',
  `user_ip` varchar(30) DEFAULT NULL COMMENT '用户登录IP',
  `user_count` int(8) DEFAULT '0' COMMENT '登录次数',
  `last_login_time` datetime DEFAULT NULL COMMENT '上次登录时间',
  `create_by` varchar(50) DEFAULT 'system' COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(255) DEFAULT NULL COMMENT '修改人',
  `update_date` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_user_group`
--

DROP TABLE IF EXISTS `sign_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_user_group` (
  `id_user_group` int(11) NOT NULL AUTO_INCREMENT,
  `created_date` datetime DEFAULT NULL,
  `created_by` varchar(20) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` varchar(20) DEFAULT NULL,
  `id_role` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_group` int(11) NOT NULL,
  `enabled` tinyint(4) DEFAULT '1',
  PRIMARY KEY (`id_user_group`)
) ENGINE=InnoDB AUTO_INCREMENT=421 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-11-08 20:49:08
