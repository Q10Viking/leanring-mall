/*
 Navicat Premium Data Transfer

 Source Server         : tlmall-normal-master-71
 Source Server Type    : MySQL
 Source Server Version : 80029
 Source Host           : 192.168.65.71:3306
 Source Schema         : xxl_job

 Target Server Type    : MySQL
 Target Server Version : 80029
 File Encoding         : 65001

 Date: 14/10/2022 19:10:34
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for xxl_job_group
-- ----------------------------
DROP TABLE IF EXISTS `xxl_job_group`;
CREATE TABLE `xxl_job_group`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `app_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行器AppName',
  `title` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行器名称',
  `address_type` tinyint(0) NOT NULL DEFAULT 0 COMMENT '执行器地址类型：0=自动注册、1=手动录入',
  `address_list` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '执行器地址列表，多地址逗号分隔',
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of xxl_job_group
-- ----------------------------
INSERT INTO `xxl_job_group` VALUES (1, 'xxl-job-executor-sample', '示例执行器', 0, 'http://192.168.65.48:9999/', '2022-09-13 18:11:49');

-- ----------------------------
-- Table structure for xxl_job_info
-- ----------------------------
DROP TABLE IF EXISTS `xxl_job_info`;
CREATE TABLE `xxl_job_info`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `job_group` int(0) NOT NULL COMMENT '执行器主键ID',
  `job_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `add_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `author` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '作者',
  `alarm_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '报警邮件',
  `schedule_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'NONE' COMMENT '调度类型',
  `schedule_conf` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '调度配置，值含义取决于调度类型',
  `misfire_strategy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DO_NOTHING' COMMENT '调度过期策略',
  `executor_route_strategy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '执行器路由策略',
  `executor_handler` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '执行器任务handler',
  `executor_param` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '执行器任务参数',
  `executor_block_strategy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '阻塞处理策略',
  `executor_timeout` int(0) NOT NULL DEFAULT 0 COMMENT '任务执行超时时间，单位秒',
  `executor_fail_retry_count` int(0) NOT NULL DEFAULT 0 COMMENT '失败重试次数',
  `glue_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'GLUE类型',
  `glue_source` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'GLUE源代码',
  `glue_remark` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'GLUE备注',
  `glue_updatetime` datetime(0) NULL DEFAULT NULL COMMENT 'GLUE更新时间',
  `child_jobid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子任务ID，多个逗号分隔',
  `trigger_status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '调度状态：0-停止，1-运行',
  `trigger_last_time` bigint(0) NOT NULL DEFAULT 0 COMMENT '上次调度时间',
  `trigger_next_time` bigint(0) NOT NULL DEFAULT 0 COMMENT '下次调度时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of xxl_job_info
-- ----------------------------
INSERT INTO `xxl_job_info` VALUES (1, 1, '测试任务1', '2018-11-03 22:21:31', '2018-11-03 22:21:31', 'XXL', '', 'CRON', '0 0 0 * * ? *', 'DO_NOTHING', 'FIRST', 'demoJobHandler', '', 'SERIAL_EXECUTION', 0, 0, 'BEAN', '', 'GLUE代码初始化', '2018-11-03 22:21:31', '', 0, 0, 0);
INSERT INTO `xxl_job_info` VALUES (2, 1, '电商定时任务', '2022-09-07 17:37:01', '2022-09-13 13:35:32', 'roy', '', 'NONE', '', 'DO_NOTHING', 'FIRST', '', 'http://www.baidu.com', 'SERIAL_EXECUTION', 0, 0, 'GLUE_GROOVY', 'package com.xxl.job.service.handler;\n\nimport com.xxl.job.core.context.XxlJobHelper;\nimport com.xxl.job.core.handler.IJobHandler;\n\nimport java.io.BufferedReader;\nimport java.io.InputStreamReader;\nimport java.net.HttpURLConnection;\nimport java.net.URL;\n\n/**\n * @author loulan\n * @desc\n */\npublic class HttpJobHandler extends IJobHandler {\n    @Override\n    public void execute() throws Exception {\n        String target = XxlJobHelper.getJobParam();\n        XxlJobHelper.log(\"received job target:\"+target);\n\n        boolean isPostMethod= false;\n\n        // request\n        HttpURLConnection connection = null;\n        BufferedReader bufferedReader = null;\n        try {\n            // connection\n            URL realUrl = new URL(target);\n            connection = (HttpURLConnection) realUrl.openConnection();\n\n            // connection setting\n//            connection.setRequestMethod(method);\n            connection.setDoOutput(isPostMethod);\n            connection.setDoInput(true);\n            connection.setUseCaches(false);\n            connection.setReadTimeout(5 * 1000);\n            connection.setConnectTimeout(3 * 1000);\n            connection.setRequestProperty(\"connection\", \"Keep-Alive\");\n            connection.setRequestProperty(\"Content-Type\", \"application/json;charset=UTF-8\");\n            connection.setRequestProperty(\"Accept-Charset\", \"application/json;charset=UTF-8\");\n\n            // do connection\n            connection.connect();\n\n            // data\n//            if (isPostMethod && data!=null && data.trim().length()>0) {\n//                DataOutputStream dataOutputStream = new DataOutputStream(connection.getOutputStream());\n//                dataOutputStream.write(data.getBytes(\"UTF-8\"));\n//                dataOutputStream.flush();\n//                dataOutputStream.close();\n//            }\n\n            // valid StatusCode\n            int statusCode = connection.getResponseCode();\n            if (statusCode != 200) {\n                throw new RuntimeException(\"Http Request StatusCode(\" + statusCode + \") Invalid.\");\n            }\n\n            // result\n            bufferedReader = new BufferedReader(new InputStreamReader(connection.getInputStream(), \"UTF-8\"));\n            StringBuilder result = new StringBuilder();\n            String line;\n            while ((line = bufferedReader.readLine()) != null) {\n                result.append(line);\n            }\n            String responseMsg = result.toString();\n\n            XxlJobHelper.log(responseMsg);\n\n            return;\n        } catch (Exception e) {\n            XxlJobHelper.log(e);\n\n            XxlJobHelper.handleFail();\n            return;\n        } finally {\n            try {\n                if (bufferedReader != null) {\n                    bufferedReader.close();\n                }\n                if (connection != null) {\n                    connection.disconnect();\n                }\n            } catch (Exception e2) {\n                XxlJobHelper.log(e2);\n            }\n        }\n    }\n}\n', 'httpJobHandler', '2022-09-07 17:44:21', '', 0, 0, 0);

-- ----------------------------
-- Table structure for xxl_job_lock
-- ----------------------------
DROP TABLE IF EXISTS `xxl_job_lock`;
CREATE TABLE `xxl_job_lock`  (
  `lock_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '锁名称',
  PRIMARY KEY (`lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of xxl_job_lock
-- ----------------------------
INSERT INTO `xxl_job_lock` VALUES ('schedule_lock');

-- ----------------------------
-- Table structure for xxl_job_log
-- ----------------------------
DROP TABLE IF EXISTS `xxl_job_log`;
CREATE TABLE `xxl_job_log`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `job_group` int(0) NOT NULL COMMENT '执行器主键ID',
  `job_id` int(0) NOT NULL COMMENT '任务，主键ID',
  `executor_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '执行器地址，本次执行的地址',
  `executor_handler` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '执行器任务handler',
  `executor_param` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '执行器任务参数',
  `executor_sharding_param` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '执行器任务分片参数，格式如 1/2',
  `executor_fail_retry_count` int(0) NOT NULL DEFAULT 0 COMMENT '失败重试次数',
  `trigger_time` datetime(0) NULL DEFAULT NULL COMMENT '调度-时间',
  `trigger_code` int(0) NOT NULL COMMENT '调度-结果',
  `trigger_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '调度-日志',
  `handle_time` datetime(0) NULL DEFAULT NULL COMMENT '执行-时间',
  `handle_code` int(0) NOT NULL COMMENT '执行-状态',
  `handle_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '执行-日志',
  `alarm_status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '告警状态：0-默认、1-无需告警、2-告警成功、3-告警失败',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `I_trigger_time`(`trigger_time`) USING BTREE,
  INDEX `I_handle_code`(`handle_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of xxl_job_log
-- ----------------------------
INSERT INTO `xxl_job_log` VALUES (1, 1, 2, NULL, '', 'www.baidu.com', NULL, 0, '2022-09-07 17:44:45', 500, '任务触发类型：手动触发<br>调度机器：192.168.65.48<br>执行器-注册方式：自动注册<br>执行器-地址列表：null<br>路由策略：第一个<br>阻塞处理策略：单机串行<br>任务超时时间：0<br>失败重试次数：0<br><br><span style=\"color:#00c0ef;\" > >>>>>>>>>>>触发调度<<<<<<<<<<< </span><br>调度失败：执行器地址为空<br><br>', NULL, 0, NULL, 2);
INSERT INTO `xxl_job_log` VALUES (2, 1, 2, 'localhost:8081', '', 'www.baidu.com', NULL, 0, '2022-09-07 17:46:26', 500, '任务触发类型：手动触发<br>调度机器：192.168.65.48<br>执行器-注册方式：手动录入<br>执行器-地址列表：[localhost:8081]<br>路由策略：第一个<br>阻塞处理策略：单机串行<br>任务超时时间：0<br>失败重试次数：0<br><br><span style=\"color:#00c0ef;\" > >>>>>>>>>>>触发调度<<<<<<<<<<< </span><br>触发调度：<br>address：localhost:8081<br>code：500<br>msg：xxl-job remoting error(unknown protocol: localhost), for url : localhost:8081/run', NULL, 0, NULL, 2);
INSERT INTO `xxl_job_log` VALUES (3, 1, 2, 'http://192.168.65.48:9999/', '', 'www.baidu.com', NULL, 0, '2022-09-07 17:47:37', 200, '任务触发类型：手动触发<br>调度机器：192.168.65.48<br>执行器-注册方式：手动录入<br>执行器-地址列表：[http://192.168.65.48:9999/]<br>路由策略：第一个<br>阻塞处理策略：单机串行<br>任务超时时间：0<br>失败重试次数：0<br><br><span style=\"color:#00c0ef;\" > >>>>>>>>>>>触发调度<<<<<<<<<<< </span><br>触发调度：<br>address：http://192.168.65.48:9999/<br>code：200<br>msg：null', '2022-09-07 17:47:37', 500, '', 2);
INSERT INTO `xxl_job_log` VALUES (4, 1, 2, 'http://192.168.65.48:9999/', '', 'http://www.baidu.com', NULL, 0, '2022-09-07 17:48:53', 200, '任务触发类型：手动触发<br>调度机器：192.168.65.48<br>执行器-注册方式：手动录入<br>执行器-地址列表：[http://192.168.65.48:9999/]<br>路由策略：第一个<br>阻塞处理策略：单机串行<br>任务超时时间：0<br>失败重试次数：0<br><br><span style=\"color:#00c0ef;\" > >>>>>>>>>>>触发调度<<<<<<<<<<< </span><br>触发调度：<br>address：http://192.168.65.48:9999/<br>code：200<br>msg：null', '2022-09-07 17:48:54', 200, '', 0);

-- ----------------------------
-- Table structure for xxl_job_log_report
-- ----------------------------
DROP TABLE IF EXISTS `xxl_job_log_report`;
CREATE TABLE `xxl_job_log_report`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `trigger_day` datetime(0) NULL DEFAULT NULL COMMENT '调度-时间',
  `running_count` int(0) NOT NULL DEFAULT 0 COMMENT '运行中-日志数量',
  `suc_count` int(0) NOT NULL DEFAULT 0 COMMENT '执行成功-日志数量',
  `fail_count` int(0) NOT NULL DEFAULT 0 COMMENT '执行失败-日志数量',
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `i_trigger_day`(`trigger_day`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of xxl_job_log_report
-- ----------------------------
INSERT INTO `xxl_job_log_report` VALUES (1, '2022-09-07 00:00:00', 0, 1, 3, NULL);
INSERT INTO `xxl_job_log_report` VALUES (2, '2022-09-06 00:00:00', 0, 0, 0, NULL);
INSERT INTO `xxl_job_log_report` VALUES (3, '2022-09-05 00:00:00', 0, 0, 0, NULL);
INSERT INTO `xxl_job_log_report` VALUES (4, '2022-09-13 00:00:00', 0, 0, 0, NULL);
INSERT INTO `xxl_job_log_report` VALUES (5, '2022-09-12 00:00:00', 0, 0, 0, NULL);
INSERT INTO `xxl_job_log_report` VALUES (6, '2022-09-11 00:00:00', 0, 0, 0, NULL);

-- ----------------------------
-- Table structure for xxl_job_logglue
-- ----------------------------
DROP TABLE IF EXISTS `xxl_job_logglue`;
CREATE TABLE `xxl_job_logglue`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `job_id` int(0) NOT NULL COMMENT '任务，主键ID',
  `glue_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'GLUE类型',
  `glue_source` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'GLUE源代码',
  `glue_remark` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'GLUE备注',
  `add_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of xxl_job_logglue
-- ----------------------------
INSERT INTO `xxl_job_logglue` VALUES (1, 2, 'GLUE_GROOVY', 'package com.xxl.job.service.handler;\n\nimport com.xxl.job.core.context.XxlJobHelper;\nimport com.xxl.job.core.handler.IJobHandler;\n\nimport java.io.BufferedReader;\nimport java.io.InputStreamReader;\nimport java.net.HttpURLConnection;\nimport java.net.URL;\n\n/**\n * @author loulan\n * @desc\n */\npublic class HttpJobHandler extends IJobHandler {\n    @Override\n    public void execute() throws Exception {\n        String target = XxlJobHelper.getJobParam();\n        XxlJobHelper.log(\"received job target:\"+target);\n\n        boolean isPostMethod= false;\n\n        // request\n        HttpURLConnection connection = null;\n        BufferedReader bufferedReader = null;\n        try {\n            // connection\n            URL realUrl = new URL(target);\n            connection = (HttpURLConnection) realUrl.openConnection();\n\n            // connection setting\n//            connection.setRequestMethod(method);\n            connection.setDoOutput(isPostMethod);\n            connection.setDoInput(true);\n            connection.setUseCaches(false);\n            connection.setReadTimeout(5 * 1000);\n            connection.setConnectTimeout(3 * 1000);\n            connection.setRequestProperty(\"connection\", \"Keep-Alive\");\n            connection.setRequestProperty(\"Content-Type\", \"application/json;charset=UTF-8\");\n            connection.setRequestProperty(\"Accept-Charset\", \"application/json;charset=UTF-8\");\n\n            // do connection\n            connection.connect();\n\n            // data\n//            if (isPostMethod && data!=null && data.trim().length()>0) {\n//                DataOutputStream dataOutputStream = new DataOutputStream(connection.getOutputStream());\n//                dataOutputStream.write(data.getBytes(\"UTF-8\"));\n//                dataOutputStream.flush();\n//                dataOutputStream.close();\n//            }\n\n            // valid StatusCode\n            int statusCode = connection.getResponseCode();\n            if (statusCode != 200) {\n                throw new RuntimeException(\"Http Request StatusCode(\" + statusCode + \") Invalid.\");\n            }\n\n            // result\n            bufferedReader = new BufferedReader(new InputStreamReader(connection.getInputStream(), \"UTF-8\"));\n            StringBuilder result = new StringBuilder();\n            String line;\n            while ((line = bufferedReader.readLine()) != null) {\n                result.append(line);\n            }\n            String responseMsg = result.toString();\n\n            XxlJobHelper.log(responseMsg);\n\n            return;\n        } catch (Exception e) {\n            XxlJobHelper.log(e);\n\n            XxlJobHelper.handleFail();\n            return;\n        } finally {\n            try {\n                if (bufferedReader != null) {\n                    bufferedReader.close();\n                }\n                if (connection != null) {\n                    connection.disconnect();\n                }\n            } catch (Exception e2) {\n                XxlJobHelper.log(e2);\n            }\n        }\n    }\n}\n', 'httpJobHandler', '2022-09-07 17:44:22', '2022-09-07 17:44:22');

-- ----------------------------
-- Table structure for xxl_job_registry
-- ----------------------------
DROP TABLE IF EXISTS `xxl_job_registry`;
CREATE TABLE `xxl_job_registry`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `registry_group` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `registry_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `registry_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `i_g_k_v`(`registry_group`, `registry_key`, `registry_value`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of xxl_job_registry
-- ----------------------------
INSERT INTO `xxl_job_registry` VALUES (2, 'EXECUTOR', 'xxl-job-executor-sample', 'http://192.168.65.48:9999/', '2022-09-13 18:12:05');

-- ----------------------------
-- Table structure for xxl_job_user
-- ----------------------------
DROP TABLE IF EXISTS `xxl_job_user`;
CREATE TABLE `xxl_job_user`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '账号',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `role` tinyint(0) NOT NULL COMMENT '角色：0-普通用户、1-管理员',
  `permission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限：执行器ID列表，多个逗号分割',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `i_username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of xxl_job_user
-- ----------------------------
INSERT INTO `xxl_job_user` VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 1, NULL);

SET FOREIGN_KEY_CHECKS = 1;
