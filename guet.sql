/*
Navicat MySQL Data Transfer

Source Server         : 127.0.0.1
Source Server Version : 80028
Source Host           : localhost:3306
Source Database       : guet

Target Server Type    : MYSQL
Target Server Version : 80028
File Encoding         : 65001

Date: 2026-03-17 08:54:43
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `basicdata`
-- ----------------------------
DROP TABLE IF EXISTS `basicdata`;
CREATE TABLE `basicdata` (
  `base_id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int DEFAULT NULL,
  `base_name` varchar(20) NOT NULL,
  `base_desc` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`base_id`),
  KEY `FK_sub_basic` (`parent_id`),
  CONSTRAINT `FK_sub_basic` FOREIGN KEY (`parent_id`) REFERENCES `basicdata` (`base_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of basicdata
-- ----------------------------
INSERT INTO `basicdata` VALUES ('1', null, '常用区间', '');
INSERT INTO `basicdata` VALUES ('2', null, '运货方式', null);
INSERT INTO `basicdata` VALUES ('3', null, '付款方式', null);
INSERT INTO `basicdata` VALUES ('8', '1', '白云区', '白云区');
INSERT INTO `basicdata` VALUES ('9', '2', '海运', '');
INSERT INTO `basicdata` VALUES ('10', '2', '空运', null);
INSERT INTO `basicdata` VALUES ('11', '2', '陆运', null);
INSERT INTO `basicdata` VALUES ('12', '3', '全款', null);
INSERT INTO `basicdata` VALUES ('13', '3', '预付定金', null);
INSERT INTO `basicdata` VALUES ('14', '3', '到付', null);
INSERT INTO `basicdata` VALUES ('15', null, '取货方式', null);
INSERT INTO `basicdata` VALUES ('16', '15', '上门取件', null);
INSERT INTO `basicdata` VALUES ('17', '15', '自动配送', null);
INSERT INTO `basicdata` VALUES ('18', '15', '快递邮寄', null);
INSERT INTO `basicdata` VALUES ('21', null, '单位', '单位');
INSERT INTO `basicdata` VALUES ('22', '21', '斤', '斤');
INSERT INTO `basicdata` VALUES ('24', '21', '件', '件');
INSERT INTO `basicdata` VALUES ('25', '21', '个', '个');
INSERT INTO `basicdata` VALUES ('36', null, '测试1', '测试');
INSERT INTO `basicdata` VALUES ('43', '36', '11', '11');
INSERT INTO `basicdata` VALUES ('44', '36', '22', '22');
INSERT INTO `basicdata` VALUES ('45', '36', '33', '33');
INSERT INTO `basicdata` VALUES ('68', '1', '黄埔区', '黄埔区');
INSERT INTO `basicdata` VALUES ('69', '21', '台', '台');
INSERT INTO `basicdata` VALUES ('70', null, '运输路线', '路线管理');
INSERT INTO `basicdata` VALUES ('71', '70', '大连-上海', '800km,海运25h,空运1h,陆运10h');
INSERT INTO `basicdata` VALUES ('72', '70', '大连-北京', '400km,海运16h,空运0.5h,陆运5h');
INSERT INTO `basicdata` VALUES ('73', '70', '上海-广州', '1500km,海运60h,空运2h,陆运19h');
INSERT INTO `basicdata` VALUES ('74', '70', '广州-深圳', '150km,海运6h,空运0.2h,陆运2h');
INSERT INTO `basicdata` VALUES ('75', '70', '深圳-香港', '50km,海运2h,空运0.1h,陆运1h');
INSERT INTO `basicdata` VALUES ('76', null, '运输成本', '每公里成本');
INSERT INTO `basicdata` VALUES ('77', '71', '海运成本', '0.8');
INSERT INTO `basicdata` VALUES ('78', '71', '空运成本', '5.0');
INSERT INTO `basicdata` VALUES ('79', '71', '陆运成本', '2.0');
INSERT INTO `basicdata` VALUES ('80', '71', '海运成本', '0.8');
INSERT INTO `basicdata` VALUES ('81', '71', '空运成本', '5.0');
INSERT INTO `basicdata` VALUES ('82', '71', '陆运成本', '2.0');
INSERT INTO `basicdata` VALUES ('83', '76', '海运成本', '0.8');
INSERT INTO `basicdata` VALUES ('84', '76', '空运成本', '5.0');
INSERT INTO `basicdata` VALUES ('85', '76', '陆运成本', '2.0');
INSERT INTO `basicdata` VALUES ('86', '1', '越秀区', '越秀区');
INSERT INTO `basicdata` VALUES ('87', '1', '海珠区', '海珠区');
INSERT INTO `basicdata` VALUES ('88', '1', '荔枝区', '荔枝区');
INSERT INTO `basicdata` VALUES ('89', '1', '天河区', '天河区');

-- ----------------------------
-- Table structure for `brand`
-- ----------------------------
DROP TABLE IF EXISTS `brand`;
CREATE TABLE `brand` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '品牌名称',
  `logo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '品牌图标',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '删除标记（0:不可用 1:可用）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分类品牌';

-- ----------------------------
-- Records of brand
-- ----------------------------
INSERT INTO `brand` VALUES ('1', '小米', 'http://139.198.127.41:9000/sph/20230506/小米.png', '2023-05-06 09:30:27', '2023-06-02 09:40:24', '0');
INSERT INTO `brand` VALUES ('2', '华为', 'http://139.198.127.41:9000/sph/20230506/华为.png', '2023-05-06 09:31:19', '2023-05-06 09:31:19', '0');
INSERT INTO `brand` VALUES ('3', '14', '1', '2023-07-18 16:09:22', '2025-12-12 01:47:45', '0');
INSERT INTO `brand` VALUES ('4', 'opop4', 'http://127.0.0.1:9000/spzx-bucket/20230718/fc34453767a245b5836d3693dd4a5be2.jpg', '2023-07-18 16:21:12', '2023-07-18 16:29:20', '1');

-- ----------------------------
-- Table structure for `guet_customer`
-- ----------------------------
DROP TABLE IF EXISTS `guet_customer`;
CREATE TABLE `guet_customer` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `order_id` int DEFAULT NULL,
  `customer_name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `customer_phone` bigint DEFAULT NULL,
  `customer_email` varchar(255) DEFAULT NULL,
  `customer_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `customer_sex` varchar(1) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of guet_customer
-- ----------------------------
INSERT INTO `guet_customer` VALUES ('1', '12', null, '王总', null, null, null, null, null);
INSERT INTO `guet_customer` VALUES ('2', '1', '33', '小红', '13471927256', '3021988923@qq.com', '上海', '女', '喜欢吃美食');
INSERT INTO `guet_customer` VALUES ('5', '12', null, '马化腾', null, null, null, null, null);
INSERT INTO `guet_customer` VALUES ('7', '12', null, '小张', null, null, null, null, null);
INSERT INTO `guet_customer` VALUES ('8', null, null, '张无忌123', null, null, null, null, null);
INSERT INTO `guet_customer` VALUES ('15', '5', null, '杨', '18776423429', '3021988923@qq.com', '广西水利电力职业技术学院（长堽校区）', '男', 'hello');
INSERT INTO `guet_customer` VALUES ('16', '1', null, '杨某', '18776423429', '3021988923@qq.com', '桂林电子科技大学（花江校区）', '男', '喝酒一杯就醉');
INSERT INTO `guet_customer` VALUES ('17', '1', null, '张三', '18776423429', '3021988923@qq.com', '桂林航天工业学院', '男', '兴趣是研究新科技');
INSERT INTO `guet_customer` VALUES ('18', '14', null, '小明明', '18776423429', '3021988923@qq.com', '广西水利电力职业技术学院（长堽校区）', '男', null);
INSERT INTO `guet_customer` VALUES ('19', '14', null, '杨', '18776423429', '3021988923@qq.com', '广西水利电力职业技术学院（长堽校区）', '女', null);
INSERT INTO `guet_customer` VALUES ('20', '29', null, '杨无敌', '18776423429', '3021988923@qq.com', '广西水利电力职业技术学院（长堽校区）', '男', null);

-- ----------------------------
-- Table structure for `guet_finance`
-- ----------------------------
DROP TABLE IF EXISTS `guet_finance`;
CREATE TABLE `guet_finance` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `paid_amount` decimal(10,2) DEFAULT '0.00',
  `unpaid_amount` decimal(10,2) NOT NULL,
  `payment_status` tinyint DEFAULT '1' COMMENT '1未付 2部分付 3已付',
  `payment_count` int DEFAULT '0',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of guet_finance
-- ----------------------------
INSERT INTO `guet_finance` VALUES ('39', '11', '25000.00', '25000.00', '0.00', '3', '5', '2026-01-22 00:03:50', '2026-03-06 15:21:17', '客户要求分期付款');
INSERT INTO `guet_finance` VALUES ('40', '13', '136.00', '136.00', '0.00', '3', '1', '2026-01-22 00:03:50', '2026-01-22 00:03:50', '已全额付款');
INSERT INTO `guet_finance` VALUES ('41', '14', '77770.00', '30500.00', '47270.00', '2', '3', '2026-01-22 00:03:50', '2026-03-14 09:52:49', '首付已收，尾款待收');
INSERT INTO `guet_finance` VALUES ('42', '15', '440.00', '440.00', '0.00', '3', '1', '2026-01-22 00:03:50', '2026-03-14 09:42:24', '现金交易');
INSERT INTO `guet_finance` VALUES ('43', '16', '8.00', '0.00', '8.00', '1', '0', '2026-01-22 00:03:50', '2026-01-22 00:03:50', '待付款');
INSERT INTO `guet_finance` VALUES ('44', '17', '450.00', '0.00', '450.00', '1', '0', '2026-01-22 00:03:50', '2026-01-22 00:03:50', '待付款');
INSERT INTO `guet_finance` VALUES ('45', '18', '2340.00', '1016.00', '1324.00', '2', '5', '2026-01-22 00:03:50', '2026-03-05 20:45:20', '已付定金');
INSERT INTO `guet_finance` VALUES ('46', '32', '726.00', '0.00', '726.00', '1', '0', '2026-02-06 18:22:42', '2026-02-06 18:22:42', null);
INSERT INTO `guet_finance` VALUES ('47', '33', '79980.00', '30000.00', '49980.00', '2', '1', '2026-02-06 18:24:15', '2026-02-06 18:25:07', null);
INSERT INTO `guet_finance` VALUES ('48', '34', '1980.00', '4.00', '1976.00', '2', '1', '2026-02-06 18:24:15', '2026-03-05 20:44:47', null);
INSERT INTO `guet_finance` VALUES ('49', '35', '2430.00', '2430.00', '0.00', '3', '2', '2026-02-06 19:53:34', '2026-03-05 20:09:45', null);
INSERT INTO `guet_finance` VALUES ('50', '36', '78.00', '78.00', '0.00', '3', '2', '2026-03-05 23:31:49', '2026-03-06 14:56:24', null);
INSERT INTO `guet_finance` VALUES ('51', '37', '396.00', '108.00', '288.00', '2', '2', '2026-03-06 15:02:49', '2026-03-08 21:43:12', null);
INSERT INTO `guet_finance` VALUES ('52', '38', '3887.00', '3887.00', '0.00', '3', '2', '2026-03-06 15:20:09', '2026-03-06 15:22:02', null);
INSERT INTO `guet_finance` VALUES ('53', '39', '39990.00', '0.00', '39990.00', '1', '0', '2026-03-08 20:53:02', '2026-03-08 20:53:02', null);
INSERT INTO `guet_finance` VALUES ('54', '40', '9998.00', '9998.00', '0.00', '3', '2', '2026-03-08 21:04:07', '2026-03-15 17:50:25', null);
INSERT INTO `guet_finance` VALUES ('55', '41', '23996.00', '1800.00', '22196.00', '2', '2', '2026-03-08 21:04:07', '2026-03-08 22:23:42', null);
INSERT INTO `guet_finance` VALUES ('56', '42', '796.00', '0.00', '796.00', '1', '0', '2026-03-10 21:09:40', '2026-03-10 21:09:40', null);
INSERT INTO `guet_finance` VALUES ('57', '43', '198.00', '8.00', '190.00', '2', '1', '2026-03-11 20:54:23', '2026-03-15 20:04:02', null);
INSERT INTO `guet_finance` VALUES ('58', '44', '1180.00', '1180.00', '0.00', '3', '1', '2026-03-11 22:31:41', '2026-03-15 17:50:12', null);
INSERT INTO `guet_finance` VALUES ('59', '45', '180.00', '180.00', '0.00', '3', '1', '2026-03-14 09:18:46', '2026-03-15 17:42:58', null);
INSERT INTO `guet_finance` VALUES ('60', '46', '20.00', '0.00', '20.00', '1', '0', '2026-03-15 11:41:23', '2026-03-15 11:41:23', null);

-- ----------------------------
-- Table structure for `guet_logistics`
-- ----------------------------
DROP TABLE IF EXISTS `guet_logistics`;
CREATE TABLE `guet_logistics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL COMMENT '订单ID',
  `status` tinyint NOT NULL COMMENT '状态: 1待取件 2已取件 3运输中 4已到达 5派送中 6已签收',
  `location` varchar(100) DEFAULT NULL COMMENT '当前位置',
  `operator` varchar(50) DEFAULT NULL COMMENT '操作人',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of guet_logistics
-- ----------------------------
INSERT INTO `guet_logistics` VALUES ('1', '13', '3', '北京', '自己人', '贵重物品 轻拿轻放', '2025-12-19 14:02:22');
INSERT INTO `guet_logistics` VALUES ('2', '13', '5', '我家', '自己人', '', '2025-12-19 14:14:17');
INSERT INTO `guet_logistics` VALUES ('3', '16', '2', '福建', '自己人', '物件较大', '2025-12-19 14:22:15');
INSERT INTO `guet_logistics` VALUES ('4', '16', '3', '广西', '自己人', '', '2025-12-19 14:26:15');
INSERT INTO `guet_logistics` VALUES ('5', '15', '4', ' 广西水利电力职业技术学院（长堽校区）', '自己人', '', '2025-12-19 14:27:08');
INSERT INTO `guet_logistics` VALUES ('6', '15', '5', ' 广西水利电力职业技术学院（长堽校区', '自己人', '', '2025-12-19 14:29:29');
INSERT INTO `guet_logistics` VALUES ('7', '14', '2', '大连', '自己人', '', '2025-12-19 14:29:41');
INSERT INTO `guet_logistics` VALUES ('8', '14', '3', '广西', '自己人', '', '2025-12-19 14:30:04');
INSERT INTO `guet_logistics` VALUES ('9', '14', '4', '广西水利电力职业技术学院', '自己人', '', '2025-12-19 14:30:38');
INSERT INTO `guet_logistics` VALUES ('10', '21', '1', '广西水利电力职业技术学院（长堽校区）', null, '订单已创建，等待取件', '2025-12-20 11:19:52');
INSERT INTO `guet_logistics` VALUES ('11', '22', '1', '广西水利电力职业技术学院（长堽校区）', null, '订单已创建，等待取件', '2025-12-20 11:19:52');
INSERT INTO `guet_logistics` VALUES ('12', '21', '3', '越南', '马化腾', '', '2025-12-20 11:21:08');
INSERT INTO `guet_logistics` VALUES ('13', '17', '4', '上海', '111', '', '2025-12-20 11:23:51');
INSERT INTO `guet_logistics` VALUES ('14', '23', '1', '广西水利电力职业技术学院（长堽校区）', null, '订单已创建，等待取件', '2025-12-20 11:25:22');
INSERT INTO `guet_logistics` VALUES ('15', '24', '1', '广西水利电力职业技术学院（长堽校区）', null, '订单已创建，等待取件', '2025-12-20 11:25:22');
INSERT INTO `guet_logistics` VALUES ('16', '25', '1', '广西水利电力职业技术学院（长堽校区）', null, '订单已创建，等待取件', '2025-12-20 11:25:22');
INSERT INTO `guet_logistics` VALUES ('17', '18', '3', '贵州', '马化腾', '1234', '2025-12-24 14:13:39');
INSERT INTO `guet_logistics` VALUES ('18', '11', '3', '上海', '张三33', '1', '2026-01-20 23:01:18');
INSERT INTO `guet_logistics` VALUES ('19', '26', '1', '广西水利电力职业技术学院（长堽校区）', null, '订单已创建，等待取件', '2026-01-20 23:42:23');
INSERT INTO `guet_logistics` VALUES ('20', '27', '1', '广西区桂林市金鸡路1号', null, '订单已创建，等待取件', '2026-01-20 23:46:48');
INSERT INTO `guet_logistics` VALUES ('21', '28', '1', '广西区桂林市金鸡路1号', null, '订单已创建，等待取件', '2026-01-21 19:27:06');
INSERT INTO `guet_logistics` VALUES ('22', '29', '1', '广西区桂林市金鸡路1号', null, '订单已创建，等待取件', '2026-01-21 19:27:06');
INSERT INTO `guet_logistics` VALUES ('23', '30', '1', '广西水利电力职业技术学院（长堽校区）', null, '订单已创建，等待取件', '2026-01-21 23:47:17');
INSERT INTO `guet_logistics` VALUES ('24', '31', '1', '广西水利电力职业技术学院（长堽校区）', null, '订单已创建，等待取件', '2026-01-21 23:47:17');
INSERT INTO `guet_logistics` VALUES ('25', '32', '1', '广西水利电力职业技术学院（长堽校区）', null, '订单已创建，等待取件', '2026-02-06 18:22:42');
INSERT INTO `guet_logistics` VALUES ('26', '33', '1', '广西区桂林市金鸡路1号', null, '订单已创建，等待取件', '2026-02-06 18:24:15');
INSERT INTO `guet_logistics` VALUES ('27', '34', '1', '广西区桂林市金鸡路1号', null, '订单已创建，等待取件', '2026-02-06 18:24:15');
INSERT INTO `guet_logistics` VALUES ('28', '32', '4', '上海', '小明111', '', '2026-02-06 18:29:27');
INSERT INTO `guet_logistics` VALUES ('29', '30', '4', '热热', '1', '', '2026-02-06 19:53:14');
INSERT INTO `guet_logistics` VALUES ('30', '35', '1', '广西水利电力职业技术学院（长堽校区）', null, '订单已创建，等待取件', '2026-02-06 19:53:34');
INSERT INTO `guet_logistics` VALUES ('31', '35', '5', '888', '1', '', '2026-02-06 19:54:07');
INSERT INTO `guet_logistics` VALUES ('32', '26', '3', '广西', '张三33', '', '2026-03-05 20:27:06');
INSERT INTO `guet_logistics` VALUES ('33', '26', '4', '桂林', '张三33', '', '2026-03-05 20:27:34');
INSERT INTO `guet_logistics` VALUES ('34', '36', '1', '广东深圳', null, '订单已创建，等待取件', '2026-03-05 23:31:49');
INSERT INTO `guet_logistics` VALUES ('35', '36', '4', '广州塔', '小马', '', '2026-03-06 14:56:52');
INSERT INTO `guet_logistics` VALUES ('36', '37', '1', '北京天安门', null, '订单已创建，等待取件', '2026-03-06 15:02:49');
INSERT INTO `guet_logistics` VALUES ('37', '37', '4', '上海', '小马', '', '2026-03-06 15:03:37');
INSERT INTO `guet_logistics` VALUES ('38', '38', '1', '美国', null, '订单已创建，等待取件', '2026-03-06 15:20:09');
INSERT INTO `guet_logistics` VALUES ('39', '38', '5', '旧金山', '小马', '', '2026-03-06 15:22:25');
INSERT INTO `guet_logistics` VALUES ('40', '39', '1', '北京大学', null, '订单已创建，等待取件', '2026-03-08 20:53:02');
INSERT INTO `guet_logistics` VALUES ('41', '40', '1', '广州市天河区龙岗路沙河大街 89 号', null, '订单已创建，等待取件', '2026-03-08 21:04:07');
INSERT INTO `guet_logistics` VALUES ('42', '41', '1', '广州市天河区龙岗路沙河大街 89 号', null, '订单已创建，等待取件', '2026-03-08 21:04:07');
INSERT INTO `guet_logistics` VALUES ('43', '41', '2', '广东东站', '小马', '', '2026-03-08 21:14:14');
INSERT INTO `guet_logistics` VALUES ('44', '41', '3', '天河区', '小马', '', '2026-03-08 21:14:35');
INSERT INTO `guet_logistics` VALUES ('45', '41', '4', '龙岗路沙河大街 89 号', '小马', '', '2026-03-08 21:15:01');
INSERT INTO `guet_logistics` VALUES ('46', '22', '2', '桂林电子科技大学', '小马', 'a配送员', '2026-03-10 16:29:50');
INSERT INTO `guet_logistics` VALUES ('47', '22', '3', '花江校区', '小马', '今日有雨，配送可能会延迟，配送员a：18776423429', '2026-03-10 16:32:02');
INSERT INTO `guet_logistics` VALUES ('48', '42', '1', '深圳黄铺区', null, '订单已创建，等待取件', '2026-03-10 21:09:40');
INSERT INTO `guet_logistics` VALUES ('49', '43', '1', '广东中山', null, '订单已创建，等待取件', '2026-03-11 20:54:23');
INSERT INTO `guet_logistics` VALUES ('50', '44', '1', '桂电金鸡岭校区', null, '订单已创建，等待取件', '2026-03-11 22:31:41');
INSERT INTO `guet_logistics` VALUES ('51', '45', '1', '桂林电子科技大学', null, '订单已创建，等待取件', '2026-03-14 09:18:46');
INSERT INTO `guet_logistics` VALUES ('52', '45', '2', '广西自治区', '小马', '', '2026-03-14 09:19:22');
INSERT INTO `guet_logistics` VALUES ('53', '46', '1', '象鼻山山顶', null, '订单已创建，等待取件', '2026-03-15 11:41:23');

-- ----------------------------
-- Table structure for `guet_operation_log`
-- ----------------------------
DROP TABLE IF EXISTS `guet_operation_log`;
CREATE TABLE `guet_operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL COMMENT '操作用户ID',
  `username` varchar(50) DEFAULT NULL COMMENT '操作用户名',
  `module` varchar(50) DEFAULT NULL COMMENT '操作模块：用户管理/订单管理/客户管理等',
  `operation` varchar(50) DEFAULT NULL COMMENT '操作类型：新增/修改/删除/查询/登录/登出',
  `method` varchar(200) DEFAULT NULL COMMENT '请求方法',
  `params` text COMMENT '请求参数',
  `ip` varchar(50) DEFAULT NULL COMMENT '操作IP',
  `status` tinyint DEFAULT '1' COMMENT '状态：1成功 0失败',
  `error_msg` text COMMENT '错误信息',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=321 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作日志表';

-- ----------------------------
-- Records of guet_operation_log
-- ----------------------------
INSERT INTO `guet_operation_log` VALUES ('1', '1', '未知用户', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"北京\",\"brand\":\"欧莱雅\",\"citi\":\"大连\",\"customerId\":2,\"desc\":\"护肤品\",\"name\":\"洗面奶\",\"number\":30,\"payment\":\"全款\",\"person\":\"张记\",\"phone\":\"18776423429\",\"pickup\":\"上门取件\",\"price\":78,\"shipping\":\"海运\",\"total\":2340,\"unit\":\"件\",\"userId\":1}]', '127.0.0.1', '1', null, '2025-12-20 02:11:12');
INSERT INTO `guet_operation_log` VALUES ('2', '1', '自己人', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-20 02:31:25');
INSERT INTO `guet_operation_log` VALUES ('3', '1', '自己人', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2025-12-20 02:35:46');
INSERT INTO `guet_operation_log` VALUES ('4', '14', '111', '用户管理', '保存用户', 'com.yang.guetconsumerr.controller.GuetController.saveUser()', '[{\"roleIds\":[10,36,9],\"user\":{\"id\":1,\"memo\":\"管理员账号\",\"name\":\"马化腾\",\"password\":\"123456\",\"phone\":\"15011113652\",\"sex\":\"男\",\"username\":\"admin\"}}]', '127.0.0.1', '1', null, '2025-12-20 02:40:57');
INSERT INTO `guet_operation_log` VALUES ('5', '14', '111', '用户管理', '保存用户', 'com.yang.guetconsumerr.controller.GuetController.saveUser()', '[{\"roleIds\":[10,9],\"user\":{\"id\":1,\"memo\":\"管理员账号\",\"name\":\"马化腾\",\"password\":\"123456\",\"phone\":\"15011113652\",\"sex\":\"男\",\"username\":\"admin\"}}]', '127.0.0.1', '1', null, '2025-12-20 02:43:02');
INSERT INTO `guet_operation_log` VALUES ('6', '14', '111', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-20 02:56:54');
INSERT INTO `guet_operation_log` VALUES ('7', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-20 02:56:58');
INSERT INTO `guet_operation_log` VALUES ('8', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2025-12-20 02:59:43');
INSERT INTO `guet_operation_log` VALUES ('9', '14', '111', '客户管理', '新增客户', 'com.yang.guetconsumerr.controller.CustomerController.insert()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"email\":\"3021988923@qq.com\",\"name\":\"杨\",\"phone\":\"18776423429\",\"sex\":\"女\",\"userId\":14}]', '127.0.0.1', '1', null, '2025-12-20 02:59:55');
INSERT INTO `guet_operation_log` VALUES ('10', '14', '111', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-20 03:15:24');
INSERT INTO `guet_operation_log` VALUES ('11', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2025-12-20 10:26:25');
INSERT INTO `guet_operation_log` VALUES ('12', '14', '111', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-20 10:26:46');
INSERT INTO `guet_operation_log` VALUES ('13', '1', '马化腾', '用户管理', '保存用户', 'com.yang.guetconsumerr.controller.GuetController.saveUser()', '[{\"roleIds\":[9],\"user\":{\"id\":13,\"memo\":\"hello\",\"name\":\"hello\",\"password\":\"123456\",\"phone\":\"12343423423\",\"sex\":\"女\",\"username\":\"hello\"}}]', '127.0.0.1', '1', null, '2025-12-20 10:27:02');
INSERT INTO `guet_operation_log` VALUES ('14', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2025-12-20 10:27:27');
INSERT INTO `guet_operation_log` VALUES ('15', '14', '111', '用户管理', '保存用户', 'com.yang.guetconsumerr.controller.GuetController.saveUser()', '[{\"roleIds\":[9],\"user\":{\"id\":14,\"memo\":\"77\",\"name\":\"111\",\"password\":\"123456\",\"phone\":\"444\",\"sex\":\"\",\"username\":\"hello\"}}]', '127.0.0.1', '1', null, '2025-12-20 10:27:44');
INSERT INTO `guet_operation_log` VALUES ('16', '14', '111', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2025-12-20 10:27:57');
INSERT INTO `guet_operation_log` VALUES ('17', '14', '111', '用户管理', '保存用户', 'com.yang.guetconsumerr.controller.GuetController.saveUser()', '[{\"roleIds\":[10],\"user\":{\"id\":14,\"memo\":\"77\",\"name\":\"111\",\"password\":\"123456\",\"phone\":\"444\",\"sex\":\"\",\"username\":\"hello\"}}]', '127.0.0.1', '1', null, '2025-12-20 10:28:18');
INSERT INTO `guet_operation_log` VALUES ('18', '14', '111', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2025-12-20 10:28:32');
INSERT INTO `guet_operation_log` VALUES ('19', '14', '111', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-20 10:33:06');
INSERT INTO `guet_operation_log` VALUES ('20', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-20 10:33:32');
INSERT INTO `guet_operation_log` VALUES ('21', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2025-12-20 10:33:44');
INSERT INTO `guet_operation_log` VALUES ('22', '14', '111', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2025-12-20 10:33:57');
INSERT INTO `guet_operation_log` VALUES ('23', '14', '111', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-20 10:34:02');
INSERT INTO `guet_operation_log` VALUES ('24', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2025-12-20 10:39:13');
INSERT INTO `guet_operation_log` VALUES ('25', '14', '111', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-20 10:39:42');
INSERT INTO `guet_operation_log` VALUES ('26', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2025-12-20 10:40:17');
INSERT INTO `guet_operation_log` VALUES ('27', '14', '111', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-20 11:07:16');
INSERT INTO `guet_operation_log` VALUES ('28', '1', '马化腾', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"citi\":\"海珠区\",\"customerId\":2,\"desc\":\"生活用品\",\"items\":[{\"brand\":\"温州货\",\"name\":\"被子\",\"number\":3,\"price\":99,\"total\":297,\"unit\":\"件\"},{\"brand\":\"地摊货\",\"name\":\"鞋子\",\"number\":4,\"price\":19,\"total\":76,\"unit\":\"个\"}],\"payment\":\"预付定金\",\"person\":\"杨怡\",\"phone\":\"18776423429\",\"pickup\":\"自动配送\",\"shipping\":\"空运\",\"userId\":1}]', '127.0.0.1', '0', '[400] during [POST] to [http://guet-provide/logistics/init?location=%E5%B9%BF%E8%A5%BF%E6%B0%B4%E5%88%A9%E7%94%B5%E5%8A%9B%E8%81%8C%E4%B8%9A%E6%8A%80%E6%9C%AF%E5%AD%A6%E9%99%A2%EF%BC%88%E9%95%BF%E5%A0%BD%E6%A0%A1%E5%8C%BA%EF%BC%89] [LogisticsService#initLogistics(Integer,String,String)]: [{\"timestamp\":\"2025-12-20T03:13:37.698+00:00\",\"status\":400,\"error\":\"Bad Request\",\"path\":\"/logistics/init\"}]', '2025-12-20 11:13:37');
INSERT INTO `guet_operation_log` VALUES ('29', '1', '马化腾', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"citi\":\"海珠区\",\"customerId\":2,\"desc\":\"生活用品\",\"items\":[{\"brand\":\"温州货\",\"name\":\"被子\",\"number\":3,\"price\":99,\"total\":297,\"unit\":\"件\"},{\"brand\":\"地摊货\",\"name\":\"鞋子\",\"number\":4,\"price\":19,\"total\":76,\"unit\":\"个\"}],\"payment\":\"预付定金\",\"person\":\"杨怡\",\"phone\":\"18776423429\",\"pickup\":\"自动配送\",\"shipping\":\"空运\",\"userId\":1}]', '127.0.0.1', '0', '[400] during [POST] to [http://guet-provide/logistics/init?location=%E5%B9%BF%E8%A5%BF%E6%B0%B4%E5%88%A9%E7%94%B5%E5%8A%9B%E8%81%8C%E4%B8%9A%E6%8A%80%E6%9C%AF%E5%AD%A6%E9%99%A2%EF%BC%88%E9%95%BF%E5%A0%BD%E6%A0%A1%E5%8C%BA%EF%BC%89] [LogisticsService#initLogistics(Integer,String,String)]: [{\"timestamp\":\"2025-12-20T03:14:07.106+00:00\",\"status\":400,\"error\":\"Bad Request\",\"path\":\"/logistics/init\"}]', '2025-12-20 11:14:07');
INSERT INTO `guet_operation_log` VALUES ('30', '1', '马化腾', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"citi\":\"海珠区\",\"customerId\":2,\"desc\":\"生活用品\",\"items\":[{\"brand\":\"温州货\",\"name\":\"被子\",\"number\":3,\"price\":99,\"total\":297,\"unit\":\"件\"},{\"brand\":\"地摊货\",\"name\":\"鞋子\",\"number\":4,\"price\":19,\"total\":76,\"unit\":\"个\"}],\"payment\":\"预付定金\",\"person\":\"杨怡\",\"phone\":\"18776423429\",\"pickup\":\"自动配送\",\"shipping\":\"空运\",\"userId\":1}]', '127.0.0.1', '1', null, '2025-12-20 11:19:52');
INSERT INTO `guet_operation_log` VALUES ('31', '1', '马化腾', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"越南\",\"operator\":\"马化腾\",\"orderId\":21,\"remark\":\"\",\"status\":3,\"statusText\":\"运输中\"}]', '127.0.0.1', '1', null, '2025-12-20 11:21:08');
INSERT INTO `guet_operation_log` VALUES ('32', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2025-12-20 11:21:31');
INSERT INTO `guet_operation_log` VALUES ('33', '14', '111', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"上海\",\"operator\":\"111\",\"orderId\":17,\"remark\":\"\",\"status\":4,\"statusText\":\"已送达\"}]', '127.0.0.1', '1', null, '2025-12-20 11:23:51');
INSERT INTO `guet_operation_log` VALUES ('34', '14', '111', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"citi\":\"白云区\",\"customerId\":19,\"desc\":\"生活用品\",\"items\":[{\"brand\":\"温州货\",\"name\":\"被子\",\"number\":3,\"price\":99,\"total\":297,\"unit\":\"斤\"},{\"brand\":\"耐克\",\"name\":\"衣服\",\"number\":5,\"price\":88,\"total\":440,\"unit\":\"件\"},{\"brand\":\"海飞丝\",\"name\":\"洗发水\",\"number\":2,\"price\":39,\"total\":78,\"unit\":\"个\"}],\"payment\":\"全款\",\"person\":\"杨怡\",\"phone\":\"18776423429\",\"pickup\":\"上门取件\",\"shipping\":\"海运\",\"userId\":14}]', '127.0.0.1', '1', null, '2025-12-20 11:25:22');
INSERT INTO `guet_operation_log` VALUES ('35', '14', '111', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-20 11:25:46');
INSERT INTO `guet_operation_log` VALUES ('36', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-24 13:42:01');
INSERT INTO `guet_operation_log` VALUES ('37', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-24 13:42:03');
INSERT INTO `guet_operation_log` VALUES ('38', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-24 13:42:09');
INSERT INTO `guet_operation_log` VALUES ('39', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2025-12-24 13:46:59');
INSERT INTO `guet_operation_log` VALUES ('40', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-24 13:48:54');
INSERT INTO `guet_operation_log` VALUES ('41', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2025-12-24 13:48:59');
INSERT INTO `guet_operation_log` VALUES ('42', '1', '马化腾', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"贵州\",\"operator\":\"马化腾\",\"orderId\":18,\"remark\":\"1234\",\"status\":3,\"statusText\":\"运输中\"}]', '127.0.0.1', '1', null, '2025-12-24 14:13:39');
INSERT INTO `guet_operation_log` VALUES ('43', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2025-12-24 14:18:07');
INSERT INTO `guet_operation_log` VALUES ('44', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-20 21:11:52');
INSERT INTO `guet_operation_log` VALUES ('45', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-20 22:27:41');
INSERT INTO `guet_operation_log` VALUES ('46', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-20 22:27:44');
INSERT INTO `guet_operation_log` VALUES ('47', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-20 22:31:37');
INSERT INTO `guet_operation_log` VALUES ('48', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-20 22:31:39');
INSERT INTO `guet_operation_log` VALUES ('49', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-20 22:31:46');
INSERT INTO `guet_operation_log` VALUES ('50', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-01-20 23:00:36');
INSERT INTO `guet_operation_log` VALUES ('51', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-01-20 23:00:41');
INSERT INTO `guet_operation_log` VALUES ('52', '5', '张三33', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"上海\",\"operator\":\"张三33\",\"orderId\":11,\"remark\":\"1\",\"status\":3,\"statusText\":\"运输中\"}]', '127.0.0.1', '1', null, '2026-01-20 23:01:18');
INSERT INTO `guet_operation_log` VALUES ('53', '5', '张三33', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"citi\":\"越秀区\",\"customerId\":15,\"desc\":\"1\",\"items\":[{\"brand\":\"小米制造\",\"name\":\"筷子\",\"number\":10,\"price\":9,\"total\":90,\"unit\":\"个\"}],\"payment\":\"全款\",\"person\":\"张无忌\",\"phone\":\"18776423429\",\"pickup\":\"上门取件\",\"shipping\":\"海运\",\"userId\":5}]', '127.0.0.1', '1', null, '2026-01-20 23:42:23');
INSERT INTO `guet_operation_log` VALUES ('54', '5', '张三33', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广西区桂林市金鸡路1号\",\"citi\":\"越秀区\",\"customerId\":15,\"desc\":\"到底\",\"items\":[{\"brand\":\"三五产品\",\"name\":\"袋子\",\"number\":20,\"price\":2,\"total\":40,\"unit\":\"个\"}],\"payment\":\"到付\",\"person\":\"啊\",\"phone\":\"18776423429\",\"pickup\":\"快递邮寄\",\"shipping\":\"空运\",\"userId\":5}]', '127.0.0.1', '1', null, '2026-01-20 23:46:48');
INSERT INTO `guet_operation_log` VALUES ('55', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 16:00:25');
INSERT INTO `guet_operation_log` VALUES ('56', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-01-21 17:04:29');
INSERT INTO `guet_operation_log` VALUES ('57', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-01-21 17:04:32');
INSERT INTO `guet_operation_log` VALUES ('58', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 17:05:07');
INSERT INTO `guet_operation_log` VALUES ('59', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 17:05:12');
INSERT INTO `guet_operation_log` VALUES ('60', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 17:05:16');
INSERT INTO `guet_operation_log` VALUES ('61', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-01-21 17:53:14');
INSERT INTO `guet_operation_log` VALUES ('62', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-01-21 17:53:18');
INSERT INTO `guet_operation_log` VALUES ('63', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 17:57:13');
INSERT INTO `guet_operation_log` VALUES ('64', '1', '马化腾', '用户管理', '保存用户', 'com.yang.guetconsumerr.controller.GuetController.saveUser()', '[{\"roleIds\":[10,9,36],\"user\":{\"id\":1,\"memo\":\"管理员账号\",\"name\":\"马化腾\",\"password\":\"123456\",\"phone\":\"15011113652\",\"sex\":\"男\",\"username\":\"admin\"}}]', '127.0.0.1', '1', null, '2026-01-21 18:35:17');
INSERT INTO `guet_operation_log` VALUES ('65', '1', '马化腾', '用户管理', '删除用户', 'com.yang.guetconsumerr.controller.GuetController.deleteUserPhysicallyById()', '[30]', '127.0.0.1', '1', null, '2026-01-21 18:35:25');
INSERT INTO `guet_operation_log` VALUES ('66', '1', '马化腾', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广西区桂林市金鸡路1号\",\"citi\":\"越秀区\",\"customerId\":2,\"desc\":\"到底\",\"items\":[{\"brand\":\"3\",\"name\":\"1\",\"number\":2,\"price\":2,\"total\":4,\"unit\":\"斤\"},{\"brand\":\"3\",\"name\":\"2\",\"number\":1,\"price\":2,\"total\":2,\"unit\":\"件\"}],\"payment\":\"全款\",\"person\":\"啊\",\"phone\":\"18776423429\",\"pickup\":\"上门取件\",\"shipping\":\"海运\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-01-21 19:27:06');
INSERT INTO `guet_operation_log` VALUES ('67', '1', '马化腾', '订单管理', '删除订单', 'com.yang.guetconsumerr.controller.GuetOrderController.delete()', '[29]', '127.0.0.1', '1', null, '2026-01-21 19:27:50');
INSERT INTO `guet_operation_log` VALUES ('68', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-01-21 19:35:18');
INSERT INTO `guet_operation_log` VALUES ('69', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-01-21 19:35:21');
INSERT INTO `guet_operation_log` VALUES ('70', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 19:43:57');
INSERT INTO `guet_operation_log` VALUES ('71', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 19:44:02');
INSERT INTO `guet_operation_log` VALUES ('72', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:25:42');
INSERT INTO `guet_operation_log` VALUES ('73', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:33:05');
INSERT INTO `guet_operation_log` VALUES ('74', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:38:10');
INSERT INTO `guet_operation_log` VALUES ('75', '1', '马化腾', '订单管理', '删除订单', 'com.yang.guetconsumerr.controller.GuetOrderController.delete()', '[18]', '127.0.0.1', '1', null, '2026-01-21 23:39:50');
INSERT INTO `guet_operation_log` VALUES ('76', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:40:45');
INSERT INTO `guet_operation_log` VALUES ('77', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:41:06');
INSERT INTO `guet_operation_log` VALUES ('78', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:41:59');
INSERT INTO `guet_operation_log` VALUES ('79', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:42:18');
INSERT INTO `guet_operation_log` VALUES ('80', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:43:05');
INSERT INTO `guet_operation_log` VALUES ('81', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:44:33');
INSERT INTO `guet_operation_log` VALUES ('82', '1', '马化腾', '用户管理', '禁用用户', 'com.yang.guetconsumerr.controller.GuetController.deleteUserById()', '[5]', '127.0.0.1', '1', null, '2026-01-21 23:45:05');
INSERT INTO `guet_operation_log` VALUES ('83', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:45:11');
INSERT INTO `guet_operation_log` VALUES ('84', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:45:18');
INSERT INTO `guet_operation_log` VALUES ('85', '1', '马化腾', '用户管理', '启用用户', 'com.yang.guetconsumerr.controller.GuetController.updateStatus()', '[5]', '127.0.0.1', '1', null, '2026-01-21 23:45:22');
INSERT INTO `guet_operation_log` VALUES ('86', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"test1212\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:45:40');
INSERT INTO `guet_operation_log` VALUES ('87', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:45:47');
INSERT INTO `guet_operation_log` VALUES ('88', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"lucy1\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:45:58');
INSERT INTO `guet_operation_log` VALUES ('89', '12', '1', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"citi\":\"天河区\",\"customerId\":7,\"desc\":\"\",\"items\":[{\"brand\":\"HUAWEI\",\"name\":\"华为手机\",\"number\":10,\"price\":3999,\"total\":39990,\"unit\":\"台\"},{\"brand\":\"MI\",\"name\":\"红米手机\",\"number\":5,\"price\":1999,\"total\":9995,\"unit\":\"台\"}],\"payment\":\"全款\",\"person\":\"计算机\",\"phone\":\"18776423429\",\"pickup\":\"上门取件\",\"shipping\":\"海运\",\"userId\":12}]', '127.0.0.1', '1', null, '2026-01-21 23:47:17');
INSERT INTO `guet_operation_log` VALUES ('90', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-21 23:47:27');
INSERT INTO `guet_operation_log` VALUES ('91', '1', '马化腾', '用户管理', '删除用户', 'com.yang.guetconsumerr.controller.GuetController.deleteUserPhysicallyById()', '[12]', '127.0.0.1', '1', null, '2026-01-21 23:47:33');
INSERT INTO `guet_operation_log` VALUES ('92', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-22 00:58:49');
INSERT INTO `guet_operation_log` VALUES ('93', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-22 01:06:05');
INSERT INTO `guet_operation_log` VALUES ('94', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-22 01:14:30');
INSERT INTO `guet_operation_log` VALUES ('95', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-22 01:25:34');
INSERT INTO `guet_operation_log` VALUES ('96', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-22 01:47:08');
INSERT INTO `guet_operation_log` VALUES ('97', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-01-22 01:47:44');
INSERT INTO `guet_operation_log` VALUES ('98', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 17:28:03');
INSERT INTO `guet_operation_log` VALUES ('99', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 17:29:31');
INSERT INTO `guet_operation_log` VALUES ('100', '1', '马化腾', '财务管理', '添加收款', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":41,\"operatorId\":1,\"orderId\":14,\"paymentAmount\":1000,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '0', '[500] during [POST] to [http://guet-provide/finance/payment] [FinanceService#addPayment(PaymentDTO)]: [{\"timestamp\":\"2026-02-06T09:30:50.888+00:00\",\"status\":500,\"error\":\"Internal Server Error\",\"path\":\"/finance/payment\"}]', '2026-02-06 17:30:50');
INSERT INTO `guet_operation_log` VALUES ('101', '1', '马化腾', '财务管理', '添加收款', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":41,\"operatorId\":1,\"orderId\":14,\"paymentAmount\":1000,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '0', '[500] during [POST] to [http://guet-provide/finance/payment] [FinanceService#addPayment(PaymentDTO)]: [{\"timestamp\":\"2026-02-06T09:31:04.303+00:00\",\"status\":500,\"error\":\"Internal Server Error\",\"path\":\"/finance/payment\"}]', '2026-02-06 17:31:04');
INSERT INTO `guet_operation_log` VALUES ('102', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 17:57:47');
INSERT INTO `guet_operation_log` VALUES ('103', '1', '马化腾', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":45,\"operatorId\":1,\"orderId\":18,\"paymentAmount\":2,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-02-06 18:05:11');
INSERT INTO `guet_operation_log` VALUES ('104', '1', '马化腾', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":45,\"operatorId\":1,\"orderId\":18,\"paymentAmount\":5,\"paymentMethod\":\"微信\"}]', '127.0.0.1', '1', null, '2026-02-06 18:05:34');
INSERT INTO `guet_operation_log` VALUES ('105', '1', '马化腾', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":45,\"operatorId\":1,\"orderId\":18,\"paymentAmount\":3,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-02-06 18:05:49');
INSERT INTO `guet_operation_log` VALUES ('106', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 18:20:46');
INSERT INTO `guet_operation_log` VALUES ('107', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"小明111\"},{}]', '127.0.0.1', '1', null, '2026-02-06 18:20:57');
INSERT INTO `guet_operation_log` VALUES ('108', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"小明111\"},{}]', '127.0.0.1', '1', null, '2026-02-06 18:21:00');
INSERT INTO `guet_operation_log` VALUES ('109', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"小明111\"},{}]', '127.0.0.1', '1', null, '2026-02-06 18:21:02');
INSERT INTO `guet_operation_log` VALUES ('110', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"小明111\"},{}]', '127.0.0.1', '1', null, '2026-02-06 18:21:06');
INSERT INTO `guet_operation_log` VALUES ('111', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 18:21:16');
INSERT INTO `guet_operation_log` VALUES ('112', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 18:21:20');
INSERT INTO `guet_operation_log` VALUES ('113', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"广西234\"},{}]', '127.0.0.1', '1', null, '2026-02-06 18:21:36');
INSERT INTO `guet_operation_log` VALUES ('114', '29', '小明111', '客户管理', '新增客户', 'com.yang.guetconsumerr.controller.CustomerController.insert()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"email\":\"3021988923@qq.com\",\"name\":\"杨无敌\",\"phone\":\"18776423429\",\"sex\":\"男\",\"userId\":29}]', '127.0.0.1', '1', null, '2026-02-06 18:21:55');
INSERT INTO `guet_operation_log` VALUES ('115', '29', '小明111', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"citi\":\"越秀区\",\"customerId\":20,\"desc\":\"33\",\"items\":[{\"brand\":\"华硕\",\"name\":\"键盘\",\"number\":22,\"price\":33,\"total\":726,\"unit\":\"个\"}],\"payment\":\"预付定金\",\"person\":\"2\",\"phone\":\"18776423429\",\"pickup\":\"上门取件\",\"shipping\":\"海运\",\"userId\":29}]', '127.0.0.1', '1', null, '2026-02-06 18:22:42');
INSERT INTO `guet_operation_log` VALUES ('116', '29', '小明111', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广西区桂林市金鸡路1号\",\"citi\":\"海珠区\",\"customerId\":20,\"desc\":\"\",\"items\":[{\"brand\":\"苹果\",\"name\":\"笔记本\",\"number\":3999,\"price\":20,\"total\":79980,\"unit\":\"台\"},{\"brand\":\"\",\"name\":\"碗\",\"number\":20,\"price\":99,\"total\":1980,\"unit\":\"个\"}],\"payment\":\"全款\",\"person\":\"张三\",\"phone\":\"18776423429\",\"pickup\":\"上门取件\",\"shipping\":\"海运\",\"userId\":29}]', '127.0.0.1', '1', null, '2026-02-06 18:24:15');
INSERT INTO `guet_operation_log` VALUES ('117', '29', '小明111', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":47,\"operatorId\":29,\"orderId\":33,\"paymentAmount\":30000,\"paymentMethod\":\"微信\"}]', '127.0.0.1', '1', null, '2026-02-06 18:25:07');
INSERT INTO `guet_operation_log` VALUES ('118', '29', '小明111', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"上海\",\"operator\":\"小明111\",\"orderId\":32,\"remark\":\"\",\"status\":4,\"statusText\":\"已送达\"}]', '127.0.0.1', '1', null, '2026-02-06 18:29:27');
INSERT INTO `guet_operation_log` VALUES ('119', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 18:48:24');
INSERT INTO `guet_operation_log` VALUES ('120', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"广西234\"},{}]', '127.0.0.1', '1', null, '2026-02-06 18:48:38');
INSERT INTO `guet_operation_log` VALUES ('121', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 19:00:11');
INSERT INTO `guet_operation_log` VALUES ('122', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 19:18:55');
INSERT INTO `guet_operation_log` VALUES ('123', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 19:36:10');
INSERT INTO `guet_operation_log` VALUES ('124', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 19:45:13');
INSERT INTO `guet_operation_log` VALUES ('125', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"lucy1\"},{}]', '127.0.0.1', '1', null, '2026-02-06 19:51:53');
INSERT INTO `guet_operation_log` VALUES ('126', '12', '1', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"热热\",\"operator\":\"1\",\"orderId\":30,\"remark\":\"\",\"status\":4,\"statusText\":\"已送达\"}]', '127.0.0.1', '1', null, '2026-02-06 19:53:14');
INSERT INTO `guet_operation_log` VALUES ('127', '12', '1', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"citi\":\"越秀区\",\"customerId\":7,\"desc\":\"3453\",\"items\":[{\"brand\":\"4\",\"name\":\"3453\",\"number\":54,\"price\":45,\"total\":2430,\"unit\":\"斤\"}],\"payment\":\"全款\",\"person\":\"5454\",\"phone\":\"18776423429\",\"pickup\":\"上门取件\",\"shipping\":\"海运\",\"userId\":12}]', '127.0.0.1', '1', null, '2026-02-06 19:53:34');
INSERT INTO `guet_operation_log` VALUES ('128', '12', '1', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"888\",\"operator\":\"1\",\"orderId\":35,\"remark\":\"\",\"status\":5,\"statusText\":\"已签收\"}]', '127.0.0.1', '1', null, '2026-02-06 19:54:07');
INSERT INTO `guet_operation_log` VALUES ('129', '12', '1', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":49,\"operatorId\":12,\"orderId\":35,\"paymentAmount\":100,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-02-06 19:54:20');
INSERT INTO `guet_operation_log` VALUES ('130', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 19:58:12');
INSERT INTO `guet_operation_log` VALUES ('131', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 19:59:02');
INSERT INTO `guet_operation_log` VALUES ('132', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2026-02-06 19:59:54');
INSERT INTO `guet_operation_log` VALUES ('133', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 20:00:06');
INSERT INTO `guet_operation_log` VALUES ('134', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 20:10:37');
INSERT INTO `guet_operation_log` VALUES ('135', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-02-06 20:10:50');
INSERT INTO `guet_operation_log` VALUES ('136', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 20:11:02');
INSERT INTO `guet_operation_log` VALUES ('137', '26', 'demo001', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello123\"},{}]', '127.0.0.1', '1', null, '2026-02-06 20:11:20');
INSERT INTO `guet_operation_log` VALUES ('138', '14', '111', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello\"},{}]', '127.0.0.1', '1', null, '2026-02-06 20:11:24');
INSERT INTO `guet_operation_log` VALUES ('139', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 20:11:34');
INSERT INTO `guet_operation_log` VALUES ('140', '17', '33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"hello1\"},{}]', '127.0.0.1', '1', null, '2026-02-06 20:12:02');
INSERT INTO `guet_operation_log` VALUES ('141', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-06 20:18:36');
INSERT INTO `guet_operation_log` VALUES ('142', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:05:41');
INSERT INTO `guet_operation_log` VALUES ('143', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:05:50');
INSERT INTO `guet_operation_log` VALUES ('144', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:05:52');
INSERT INTO `guet_operation_log` VALUES ('145', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:06:02');
INSERT INTO `guet_operation_log` VALUES ('146', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"000000\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:06:10');
INSERT INTO `guet_operation_log` VALUES ('147', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:06:22');
INSERT INTO `guet_operation_log` VALUES ('148', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:06:23');
INSERT INTO `guet_operation_log` VALUES ('149', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:06:32');
INSERT INTO `guet_operation_log` VALUES ('150', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"111111\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:06:47');
INSERT INTO `guet_operation_log` VALUES ('151', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:06:52');
INSERT INTO `guet_operation_log` VALUES ('152', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"admin\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:06:53');
INSERT INTO `guet_operation_log` VALUES ('153', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:08:48');
INSERT INTO `guet_operation_log` VALUES ('154', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:08:54');
INSERT INTO `guet_operation_log` VALUES ('155', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:10:14');
INSERT INTO `guet_operation_log` VALUES ('156', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:10:24');
INSERT INTO `guet_operation_log` VALUES ('157', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:12:17');
INSERT INTO `guet_operation_log` VALUES ('158', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:12:18');
INSERT INTO `guet_operation_log` VALUES ('159', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:12:19');
INSERT INTO `guet_operation_log` VALUES ('160', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:12:30');
INSERT INTO `guet_operation_log` VALUES ('161', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:12:42');
INSERT INTO `guet_operation_log` VALUES ('162', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:26:21');
INSERT INTO `guet_operation_log` VALUES ('163', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"000000\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:26:41');
INSERT INTO `guet_operation_log` VALUES ('164', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:33:00');
INSERT INTO `guet_operation_log` VALUES ('165', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:33:01');
INSERT INTO `guet_operation_log` VALUES ('166', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:33:02');
INSERT INTO `guet_operation_log` VALUES ('167', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"1234567\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:40:06');
INSERT INTO `guet_operation_log` VALUES ('168', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:40:20');
INSERT INTO `guet_operation_log` VALUES ('169', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:40:25');
INSERT INTO `guet_operation_log` VALUES ('170', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:44:14');
INSERT INTO `guet_operation_log` VALUES ('171', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:44:20');
INSERT INTO `guet_operation_log` VALUES ('172', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:44:41');
INSERT INTO `guet_operation_log` VALUES ('173', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:47:58');
INSERT INTO `guet_operation_log` VALUES ('174', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:48:00');
INSERT INTO `guet_operation_log` VALUES ('175', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:48:05');
INSERT INTO `guet_operation_log` VALUES ('176', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:52:54');
INSERT INTO `guet_operation_log` VALUES ('177', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:53:43');
INSERT INTO `guet_operation_log` VALUES ('178', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:55:30');
INSERT INTO `guet_operation_log` VALUES ('179', '1', '马化腾', '用户管理', '保存用户', 'com.yang.guetconsumerr.controller.GuetController.saveUser()', '[{\"roleIds\":[10,9,36],\"user\":{\"id\":1,\"memo\":\"管理员账号\",\"name\":\"马化腾\",\"password\":\"123456\",\"phone\":\"15011113652\",\"sex\":\"男\",\"username\":\"admin\"}}]', '127.0.0.1', '1', null, '2026-02-22 20:55:59');
INSERT INTO `guet_operation_log` VALUES ('180', '1', '马化腾', '用户管理', '保存用户', 'com.yang.guetconsumerr.controller.GuetController.saveUser()', '[{\"roleIds\":[45],\"user\":{\"id\":5,\"memo\":\"\",\"name\":\"张三33\",\"password\":\"123456\",\"phone\":\"13589658968\",\"sex\":\"男\",\"username\":\"zhangsan\"}}]', '127.0.0.1', '1', null, '2026-02-22 20:56:34');
INSERT INTO `guet_operation_log` VALUES ('181', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"1234561\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:58:59');
INSERT INTO `guet_operation_log` VALUES ('182', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"77\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 20:59:10');
INSERT INTO `guet_operation_log` VALUES ('183', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:00:09');
INSERT INTO `guet_operation_log` VALUES ('184', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:00:12');
INSERT INTO `guet_operation_log` VALUES ('185', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:00:14');
INSERT INTO `guet_operation_log` VALUES ('186', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:00:15');
INSERT INTO `guet_operation_log` VALUES ('187', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:00:15');
INSERT INTO `guet_operation_log` VALUES ('188', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:00:16');
INSERT INTO `guet_operation_log` VALUES ('189', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:00:17');
INSERT INTO `guet_operation_log` VALUES ('190', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:00:18');
INSERT INTO `guet_operation_log` VALUES ('191', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:01:39');
INSERT INTO `guet_operation_log` VALUES ('192', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:05:19');
INSERT INTO `guet_operation_log` VALUES ('193', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:05:39');
INSERT INTO `guet_operation_log` VALUES ('194', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:07:25');
INSERT INTO `guet_operation_log` VALUES ('195', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:07:54');
INSERT INTO `guet_operation_log` VALUES ('196', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-02-22 21:09:17');
INSERT INTO `guet_operation_log` VALUES ('197', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-03-05 19:27:27');
INSERT INTO `guet_operation_log` VALUES ('198', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 19:34:25');
INSERT INTO `guet_operation_log` VALUES ('199', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 19:40:47');
INSERT INTO `guet_operation_log` VALUES ('200', '1', '马化腾', '订单管理', '删除订单', 'com.yang.guetconsumerr.controller.GuetOrderController.delete()', '[20]', '127.0.0.1', '1', null, '2026-03-05 20:05:14');
INSERT INTO `guet_operation_log` VALUES ('201', '1', '马化腾', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":49,\"operatorId\":1,\"orderId\":35,\"paymentAmount\":2330,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-05 20:09:45');
INSERT INTO `guet_operation_log` VALUES ('202', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:22:41');
INSERT INTO `guet_operation_log` VALUES ('203', '5', '张三33', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":39,\"operatorId\":5,\"orderId\":11,\"paymentAmount\":4,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-05 20:23:42');
INSERT INTO `guet_operation_log` VALUES ('204', '5', '张三33', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":39,\"operatorId\":5,\"orderId\":11,\"paymentAmount\":9,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-05 20:23:50');
INSERT INTO `guet_operation_log` VALUES ('205', '5', '张三33', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"广西\",\"operator\":\"张三33\",\"orderId\":26,\"remark\":\"\",\"status\":3,\"statusText\":\"运输中\"}]', '127.0.0.1', '1', null, '2026-03-05 20:27:06');
INSERT INTO `guet_operation_log` VALUES ('206', '5', '张三33', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"桂林\",\"operator\":\"张三33\",\"orderId\":26,\"remark\":\"\",\"status\":4,\"statusText\":\"已送达\"}]', '127.0.0.1', '1', null, '2026-03-05 20:27:34');
INSERT INTO `guet_operation_log` VALUES ('207', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:29:55');
INSERT INTO `guet_operation_log` VALUES ('208', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:33:58');
INSERT INTO `guet_operation_log` VALUES ('209', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:37:30');
INSERT INTO `guet_operation_log` VALUES ('210', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:42:26');
INSERT INTO `guet_operation_log` VALUES ('211', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:43:41');
INSERT INTO `guet_operation_log` VALUES ('212', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:43:58');
INSERT INTO `guet_operation_log` VALUES ('213', '1', '马化腾', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":48,\"operatorId\":1,\"orderId\":34,\"paymentAmount\":4,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-05 20:44:47');
INSERT INTO `guet_operation_log` VALUES ('214', '1', '马化腾', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":45,\"operatorId\":1,\"orderId\":18,\"paymentAmount\":6,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-05 20:45:20');
INSERT INTO `guet_operation_log` VALUES ('215', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:45:48');
INSERT INTO `guet_operation_log` VALUES ('216', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:48:45');
INSERT INTO `guet_operation_log` VALUES ('217', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:48:59');
INSERT INTO `guet_operation_log` VALUES ('218', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:49:11');
INSERT INTO `guet_operation_log` VALUES ('219', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:51:19');
INSERT INTO `guet_operation_log` VALUES ('220', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:51:47');
INSERT INTO `guet_operation_log` VALUES ('221', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:52:41');
INSERT INTO `guet_operation_log` VALUES ('222', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 20:54:23');
INSERT INTO `guet_operation_log` VALUES ('223', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:05:06');
INSERT INTO `guet_operation_log` VALUES ('224', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:05:33');
INSERT INTO `guet_operation_log` VALUES ('225', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:10:00');
INSERT INTO `guet_operation_log` VALUES ('226', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:10:06');
INSERT INTO `guet_operation_log` VALUES ('227', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:10:42');
INSERT INTO `guet_operation_log` VALUES ('228', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:10:58');
INSERT INTO `guet_operation_log` VALUES ('229', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:11:07');
INSERT INTO `guet_operation_log` VALUES ('230', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:11:25');
INSERT INTO `guet_operation_log` VALUES ('231', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:11:33');
INSERT INTO `guet_operation_log` VALUES ('232', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:11:53');
INSERT INTO `guet_operation_log` VALUES ('233', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:12:31');
INSERT INTO `guet_operation_log` VALUES ('234', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:13:28');
INSERT INTO `guet_operation_log` VALUES ('235', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:13:39');
INSERT INTO `guet_operation_log` VALUES ('236', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:16:11');
INSERT INTO `guet_operation_log` VALUES ('237', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:19:19');
INSERT INTO `guet_operation_log` VALUES ('238', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:20:17');
INSERT INTO `guet_operation_log` VALUES ('239', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:21:01');
INSERT INTO `guet_operation_log` VALUES ('240', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 21:53:05');
INSERT INTO `guet_operation_log` VALUES ('241', '1', '马化腾', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-05 23:23:48');
INSERT INTO `guet_operation_log` VALUES ('242', '1', '马化腾', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广东深圳\",\"citi\":\"越秀区\",\"customerId\":2,\"desc\":\"\",\"items\":[{\"brand\":\"雅诗\",\"name\":\"水壶\",\"number\":2,\"price\":39,\"total\":78,\"unit\":\"个\"}],\"payment\":\"全款\",\"person\":\"杨恩\",\"phone\":\"1839273492\",\"pickup\":\"上门取件\",\"shipping\":\"海运\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-05 23:31:49');
INSERT INTO `guet_operation_log` VALUES ('243', '1', '马化腾', '用户管理', '保存用户', 'com.yang.guetconsumerr.controller.GuetController.saveUser()', '[{\"roleIds\":[10,9,36],\"user\":{\"id\":1,\"memo\":\"管理员账号\",\"name\":\"小马\",\"password\":\"123456\",\"phone\":\"15011113652\",\"sex\":\"男\",\"username\":\"admin\"}}]', '127.0.0.1', '1', null, '2026-03-06 14:09:11');
INSERT INTO `guet_operation_log` VALUES ('244', '1', '小马', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-06 14:09:19');
INSERT INTO `guet_operation_log` VALUES ('245', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":50,\"operatorId\":1,\"orderId\":36,\"paymentAmount\":7,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-06 14:39:57');
INSERT INTO `guet_operation_log` VALUES ('246', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":50,\"operatorId\":1,\"orderId\":36,\"paymentAmount\":71,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-06 14:56:24');
INSERT INTO `guet_operation_log` VALUES ('247', '1', '小马', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"广州塔\",\"operator\":\"小马\",\"orderId\":36,\"remark\":\"\",\"status\":4,\"statusText\":\"已送达\"}]', '127.0.0.1', '1', null, '2026-03-06 14:56:52');
INSERT INTO `guet_operation_log` VALUES ('248', '1', '小马', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"北京天安门\",\"citi\":\"天河区\",\"customerId\":17,\"desc\":\"\",\"items\":[{\"brand\":\"橡皮制造\",\"name\":\"汽车轮子\",\"number\":4,\"price\":99,\"total\":396,\"unit\":\"个\"}],\"payment\":\"预付定金\",\"person\":\"祝分\",\"phone\":\"1857489573\",\"pickup\":\"自动配送\",\"shipping\":\"空运\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-06 15:02:49');
INSERT INTO `guet_operation_log` VALUES ('249', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":51,\"operatorId\":1,\"orderId\":37,\"paymentAmount\":8,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-06 15:03:16');
INSERT INTO `guet_operation_log` VALUES ('250', '1', '小马', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"上海\",\"operator\":\"小马\",\"orderId\":37,\"remark\":\"\",\"status\":4,\"statusText\":\"已送达\"}]', '127.0.0.1', '1', null, '2026-03-06 15:03:37');
INSERT INTO `guet_operation_log` VALUES ('251', '1', '小马', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-06 15:17:50');
INSERT INTO `guet_operation_log` VALUES ('252', '1', '小马', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"美国\",\"citi\":\"荔枝区\",\"customerId\":16,\"desc\":\"电脑4080T处理器\",\"items\":[{\"brand\":\"百亿补贴\",\"name\":\"显卡\",\"number\":13,\"price\":299,\"total\":3887,\"unit\":\"个\"}],\"payment\":\"预付定金\",\"person\":\"马克\",\"phone\":\"18473847393·\",\"pickup\":\"自动配送\",\"shipping\":\"空运\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-06 15:20:09');
INSERT INTO `guet_operation_log` VALUES ('253', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":52,\"operatorId\":1,\"orderId\":38,\"paymentAmount\":5,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-06 15:20:22');
INSERT INTO `guet_operation_log` VALUES ('254', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":39,\"operatorId\":1,\"orderId\":11,\"paymentAmount\":9987,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-06 15:21:17');
INSERT INTO `guet_operation_log` VALUES ('255', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":52,\"operatorId\":1,\"orderId\":38,\"paymentAmount\":3882,\"paymentMethod\":\"支付宝\"}]', '127.0.0.1', '1', null, '2026-03-06 15:22:02');
INSERT INTO `guet_operation_log` VALUES ('256', '1', '小马', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"旧金山\",\"operator\":\"小马\",\"orderId\":38,\"remark\":\"\",\"status\":5,\"statusText\":\"已签收\"}]', '127.0.0.1', '1', null, '2026-03-06 15:22:25');
INSERT INTO `guet_operation_log` VALUES ('257', '1', '小马', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '10.33.157.78', '1', null, '2026-03-07 13:42:47');
INSERT INTO `guet_operation_log` VALUES ('258', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin3\"},{}]', '10.33.157.78', '1', null, '2026-03-08 17:42:54');
INSERT INTO `guet_operation_log` VALUES ('259', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin3\"},{}]', '10.33.157.78', '1', null, '2026-03-08 17:42:55');
INSERT INTO `guet_operation_log` VALUES ('260', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"1234563\",\"username\":\"admin\"},{}]', '10.33.157.78', '1', null, '2026-03-08 17:42:59');
INSERT INTO `guet_operation_log` VALUES ('261', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"1234563\",\"username\":\"admin\"},{}]', '10.33.157.78', '1', null, '2026-03-08 17:43:00');
INSERT INTO `guet_operation_log` VALUES ('262', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"1234563\",\"username\":\"admin\"},{}]', '10.33.157.78', '1', null, '2026-03-08 17:43:00');
INSERT INTO `guet_operation_log` VALUES ('263', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"1234563\",\"username\":\"admin\"},{}]', '10.33.157.78', '1', null, '2026-03-08 17:43:01');
INSERT INTO `guet_operation_log` VALUES ('264', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"1234563\",\"username\":\"admin\"},{}]', '10.33.157.78', '1', null, '2026-03-08 17:43:01');
INSERT INTO `guet_operation_log` VALUES ('265', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"1234563\",\"username\":\"admin\"},{}]', '10.33.157.78', '1', null, '2026-03-08 17:43:01');
INSERT INTO `guet_operation_log` VALUES ('266', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"1234563\",\"username\":\"admin\"},{}]', '10.33.157.78', '1', null, '2026-03-08 17:43:02');
INSERT INTO `guet_operation_log` VALUES ('267', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"1234563\",\"username\":\"admin\"},{}]', '10.33.157.78', '1', null, '2026-03-08 20:49:41');
INSERT INTO `guet_operation_log` VALUES ('268', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"1234563\",\"username\":\"admin\"},{}]', '10.33.157.78', '1', null, '2026-03-08 20:49:43');
INSERT INTO `guet_operation_log` VALUES ('269', null, '未知用户', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"1234563\",\"username\":\"admin\"},{}]', '10.33.157.78', '1', null, '2026-03-08 20:49:44');
INSERT INTO `guet_operation_log` VALUES ('270', '1', '小马', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '10.33.157.78', '1', null, '2026-03-08 20:49:46');
INSERT INTO `guet_operation_log` VALUES ('271', '1', '小马', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"北京大学\",\"citi\":\"荔枝区\",\"customerId\":17,\"desc\":\"openClaw最新技术\",\"items\":[{\"brand\":\"小米\",\"name\":\"小米17\",\"number\":10,\"price\":3999,\"total\":39990,\"unit\":\"台\"}],\"payment\":\"全款\",\"person\":\"小黑\",\"phone\":\"18776423429\",\"pickup\":\"自动配送\",\"shipping\":\"空运\",\"userId\":1}]', '10.33.157.78', '1', null, '2026-03-08 20:53:02');
INSERT INTO `guet_operation_log` VALUES ('272', '1', '小马', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广州市天河区龙岗路沙河大街 89 号\",\"citi\":\"天河区\",\"customerId\":16,\"desc\":\"电子产品\",\"items\":[{\"brand\":\"华硕\",\"name\":\"笔记本电脑\",\"number\":2,\"price\":4999,\"total\":9998,\"unit\":\"台\"},{\"brand\":\"苹果\",\"name\":\"phone 17\",\"number\":4,\"price\":5999,\"total\":23996,\"unit\":\"台\"}],\"payment\":\"全款\",\"person\":\"张三\",\"phone\":\"18776423429\",\"pickup\":\"上门取件\",\"shipping\":\"海运\",\"userId\":1}]', '10.33.157.78', '1', null, '2026-03-08 21:04:07');
INSERT INTO `guet_operation_log` VALUES ('273', '1', '小马', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"广东东站\",\"operator\":\"小马\",\"orderId\":41,\"remark\":\"\",\"status\":2,\"statusText\":\"已取件\"}]', '10.33.157.78', '1', null, '2026-03-08 21:14:14');
INSERT INTO `guet_operation_log` VALUES ('274', '1', '小马', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"天河区\",\"operator\":\"小马\",\"orderId\":41,\"remark\":\"\",\"status\":3,\"statusText\":\"运输中\"}]', '10.33.157.78', '1', null, '2026-03-08 21:14:35');
INSERT INTO `guet_operation_log` VALUES ('275', '1', '小马', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"龙岗路沙河大街 89 号\",\"operator\":\"小马\",\"orderId\":41,\"remark\":\"\",\"status\":4,\"statusText\":\"已送达\"}]', '10.33.157.78', '1', null, '2026-03-08 21:15:01');
INSERT INTO `guet_operation_log` VALUES ('276', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":51,\"operatorId\":1,\"orderId\":37,\"paymentAmount\":100,\"paymentMethod\":\"支付宝\"}]', '10.33.157.78', '1', null, '2026-03-08 21:43:12');
INSERT INTO `guet_operation_log` VALUES ('277', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":55,\"operatorId\":1,\"orderId\":41,\"paymentAmount\":1000,\"paymentMethod\":\"支付宝\"}]', '10.33.157.78', '1', null, '2026-03-08 22:23:11');
INSERT INTO `guet_operation_log` VALUES ('278', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":55,\"operatorId\":1,\"orderId\":41,\"paymentAmount\":800,\"paymentMethod\":\"现金\"}]', '10.33.157.78', '1', null, '2026-03-08 22:23:42');
INSERT INTO `guet_operation_log` VALUES ('279', '1', '小马', '客户管理', '修改客户', 'com.yang.guetconsumerr.controller.CustomerController.updateById()', '[{\"address\":\"桂林电子科技大学（花江校区）\",\"email\":\"3021988923@qq.com\",\"id\":16,\"name\":\"杨某\",\"phone\":\"18776423429\",\"sex\":\"男\",\"userId\":1}]', '10.33.157.78', '1', null, '2026-03-08 22:27:17');
INSERT INTO `guet_operation_log` VALUES ('280', '1', '小马', '客户管理', '修改客户', 'com.yang.guetconsumerr.controller.CustomerController.updateById()', '[{\"address\":\"桂林航天工业学院\",\"desc\":\"我的兴趣是研究新科技\",\"email\":\"3021988923@qq.com\",\"id\":17,\"name\":\"张三\",\"phone\":\"18776423429\",\"sex\":\"男\",\"userId\":1}]', '10.33.157.78', '1', null, '2026-03-08 22:28:39');
INSERT INTO `guet_operation_log` VALUES ('281', '1', '小马', '客户管理', '修改客户', 'com.yang.guetconsumerr.controller.CustomerController.updateById()', '[{\"address\":\"上海\",\"desc\":\"我喜欢吃\",\"email\":\"3021988923@qq.com\",\"id\":2,\"name\":\"小红\",\"orderId\":33,\"phone\":\"13471927256\",\"sex\":\"女\",\"userId\":1}]', '10.33.157.78', '1', null, '2026-03-08 22:29:43');
INSERT INTO `guet_operation_log` VALUES ('282', '1', '小马', '客户管理', '修改客户', 'com.yang.guetconsumerr.controller.CustomerController.updateById()', '[{\"address\":\"上海\",\"desc\":\"喜欢吃\",\"email\":\"3021988923@qq.com\",\"id\":2,\"name\":\"小红\",\"orderId\":33,\"phone\":\"13471927256\",\"sex\":\"女\",\"userId\":1}]', '10.33.157.78', '1', null, '2026-03-08 22:29:51');
INSERT INTO `guet_operation_log` VALUES ('283', '1', '小马', '客户管理', '修改客户', 'com.yang.guetconsumerr.controller.CustomerController.updateById()', '[{\"address\":\"桂林航天工业学院\",\"desc\":\"兴趣是研究新科技\",\"email\":\"3021988923@qq.com\",\"id\":17,\"name\":\"张三\",\"phone\":\"18776423429\",\"sex\":\"男\",\"userId\":1}]', '10.33.157.78', '1', null, '2026-03-08 22:29:57');
INSERT INTO `guet_operation_log` VALUES ('284', '1', '小马', '客户管理', '修改客户', 'com.yang.guetconsumerr.controller.CustomerController.updateById()', '[{\"address\":\"上海\",\"desc\":\"喜欢吃美食\",\"email\":\"3021988923@qq.com\",\"id\":2,\"name\":\"小红\",\"orderId\":33,\"phone\":\"13471927256\",\"sex\":\"女\",\"userId\":1}]', '10.33.157.78', '1', null, '2026-03-08 22:30:13');
INSERT INTO `guet_operation_log` VALUES ('285', '1', '小马', '客户管理', '修改客户', 'com.yang.guetconsumerr.controller.CustomerController.updateById()', '[{\"address\":\"桂林电子科技大学（花江校区）\",\"desc\":\"喝酒一杯就醉\",\"email\":\"3021988923@qq.com\",\"id\":16,\"name\":\"杨某\",\"phone\":\"18776423429\",\"sex\":\"男\",\"userId\":1}]', '10.33.157.78', '1', null, '2026-03-08 22:30:51');
INSERT INTO `guet_operation_log` VALUES ('286', '1', '小马', '角色管理', '修改角色', 'com.yang.guetconsumerr.controller.GuetRoleController.updateRole()', '[{\"id\":37,\"memo\":\"\",\"roleCode\":\"业务人员\",\"roleName\":\"业务人员\"}]', '10.33.157.78', '1', null, '2026-03-08 22:46:26');
INSERT INTO `guet_operation_log` VALUES ('287', '1', '小马', '角色管理', '修改角色', 'com.yang.guetconsumerr.controller.GuetRoleController.updateRole()', '[{\"id\":45,\"memo\":\"老板\",\"roleCode\":\"234234\",\"roleName\":\"总经理\"}]', '10.33.157.78', '1', null, '2026-03-08 22:47:42');
INSERT INTO `guet_operation_log` VALUES ('288', '1', '小马', '角色管理', '修改角色', 'com.yang.guetconsumerr.controller.GuetRoleController.updateRole()', '[{\"id\":9,\"memo\":\"平台管理员\",\"roleCode\":\"ptgly\",\"roleName\":\"平台管理员\"}]', '10.33.157.78', '1', null, '2026-03-08 22:49:06');
INSERT INTO `guet_operation_log` VALUES ('289', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":54,\"operatorId\":1,\"orderId\":40,\"paymentAmount\":6,\"paymentMethod\":\"银行转账\"}]', '10.33.157.78', '1', null, '2026-03-08 22:57:49');
INSERT INTO `guet_operation_log` VALUES ('290', '1', '小马', '订单管理', '删除订单', 'com.yang.guetconsumerr.controller.GuetOrderController.delete()', '[21]', '10.33.157.78', '1', null, '2026-03-08 22:58:06');
INSERT INTO `guet_operation_log` VALUES ('291', '1', '小马', '客户管理', '修改客户', 'com.yang.guetconsumerr.controller.CustomerController.updateById()', '[{\"address\":\"上海\",\"desc\":\"喜欢吃美食\",\"email\":\"3021988923@qq.com\",\"id\":2,\"name\":\"小红\",\"orderId\":33,\"phone\":\"13471927256\",\"sex\":\"女\",\"userId\":1}]', '10.33.157.78', '1', null, '2026-03-08 22:58:17');
INSERT INTO `guet_operation_log` VALUES ('292', '1', '小马', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '10.33.157.78', '1', null, '2026-03-08 22:58:23');
INSERT INTO `guet_operation_log` VALUES ('293', '1', '小马', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"桂林电子科技大学\",\"operator\":\"小马\",\"orderId\":22,\"remark\":\"a配送员\",\"status\":2,\"statusText\":\"已取件\"}]', '10.33.157.78', '1', null, '2026-03-10 16:29:50');
INSERT INTO `guet_operation_log` VALUES ('294', '1', '小马', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"花江校区\",\"operator\":\"小马\",\"orderId\":22,\"remark\":\"今日有雨，配送可能会延迟，配送员a：18776423429\",\"status\":3,\"statusText\":\"运输中\"}]', '10.33.157.78', '1', null, '2026-03-10 16:32:02');
INSERT INTO `guet_operation_log` VALUES ('295', '1', '小马', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"深圳黄铺区\",\"citi\":\"黄埔区\",\"customerId\":16,\"desc\":\"保密发货\",\"items\":[{\"brand\":\"耐克\",\"name\":\"鞋子\",\"number\":4,\"price\":199,\"total\":796,\"unit\":\"个\"}],\"payment\":\"预付定金\",\"person\":\"王大家\",\"phone\":\"18776423429\",\"pickup\":\"自动配送\",\"shipping\":\"陆运\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-10 21:09:40');
INSERT INTO `guet_operation_log` VALUES ('296', '1', '小马', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"广东中山\",\"citi\":\"白云区\",\"customerId\":2,\"desc\":\"\",\"items\":[{\"brand\":\"杂牌\",\"name\":\"刀\",\"number\":2,\"price\":99,\"total\":198,\"unit\":\"件\"}],\"payment\":\"预付定金\",\"person\":\"李张\",\"phone\":\"18776423429\",\"pickup\":\"自动配送\",\"shipping\":\"空运\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-11 20:54:23');
INSERT INTO `guet_operation_log` VALUES ('297', '1', '小马', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"桂电金鸡岭校区\",\"citi\":\"白云区\",\"customerId\":2,\"desc\":\"c语言数据结构20本\",\"items\":[{\"brand\":\"正品\",\"name\":\"c语言数据结构\",\"number\":20,\"price\":59,\"total\":1180,\"unit\":\"个\"}],\"payment\":\"预付定金\",\"person\":\"杨饿哦\",\"phone\":\"18776423429\",\"pickup\":\"自动配送\",\"shipping\":\"陆运\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-11 22:31:41');
INSERT INTO `guet_operation_log` VALUES ('298', '5', '张三33', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"zhangsan\"},{}]', '127.0.0.1', '1', null, '2026-03-12 18:18:34');
INSERT INTO `guet_operation_log` VALUES ('299', '1', '小马', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-12 18:18:42');
INSERT INTO `guet_operation_log` VALUES ('300', '1', '小马', '订单管理', '修改订单', 'com.yang.guetconsumerr.controller.GuetOrderController.update()', '[{\"address\":\"广西区桂林市金鸡路1号\",\"brand\":\"京东甄选\",\"citi\":\"黄埔区\",\"customerId\":16,\"desc\":\"轻拿轻放\",\"id\":13,\"name\":\"被子\",\"number\":10,\"payment\":\"预付定金\",\"person\":\"暂放小卖部\",\"phone\":\"18776423429\",\"price\":17,\"shipping\":\"空运\",\"total\":170,\"unit\":\"个\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-13 12:00:07');
INSERT INTO `guet_operation_log` VALUES ('301', '1', '小马', '订单管理', '修改订单', 'com.yang.guetconsumerr.controller.GuetOrderController.update()', '[{\"address\":\"广西区桂林市金鸡路1号\",\"brand\":\"京东甄选1\",\"citi\":\"黄埔区\",\"customerId\":16,\"desc\":\"轻拿轻放\",\"id\":13,\"name\":\"被子\",\"number\":10,\"payment\":\"预付定金\",\"person\":\"暂放小卖部\",\"phone\":\"18776423429\",\"price\":17,\"shipping\":\"空运\",\"total\":170,\"unit\":\"个\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-13 12:00:28');
INSERT INTO `guet_operation_log` VALUES ('302', '1', '小马', '订单管理', '修改订单', 'com.yang.guetconsumerr.controller.GuetOrderController.update()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"brand\":\"华为\",\"citi\":\"黄埔区\",\"customerId\":16,\"desc\":\"666\",\"id\":14,\"name\":\"笔记本\",\"number\":19,\"payment\":\"全款\",\"person\":\"小黑\",\"phone\":\"18776423429\",\"pickup\":\"上门取件\",\"price\":7777,\"shipping\":\"海运\",\"total\":147763,\"unit\":\"斤\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-13 12:01:13');
INSERT INTO `guet_operation_log` VALUES ('303', '1', '小马', '订单管理', '修改订单', 'com.yang.guetconsumerr.controller.GuetOrderController.update()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"brand\":\"华为\",\"citi\":\"黄埔区\",\"customerId\":16,\"desc\":\"666\",\"id\":14,\"name\":\"笔记本\",\"number\":10,\"payment\":\"全款\",\"person\":\"小黑\",\"phone\":\"18776423429\",\"price\":7777,\"shipping\":\"海运\",\"total\":77770,\"unit\":\"斤\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-13 12:07:04');
INSERT INTO `guet_operation_log` VALUES ('304', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":41,\"operatorId\":1,\"orderId\":14,\"paymentAmount\":10000,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-13 12:08:45');
INSERT INTO `guet_operation_log` VALUES ('305', '1', '小马', '订单管理', '修改订单', 'com.yang.guetconsumerr.controller.GuetOrderController.update()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"brand\":\"华为\",\"citi\":\"黄埔区\",\"customerId\":16,\"desc\":\"666\",\"id\":14,\"name\":\"笔记本\",\"number\":20,\"payment\":\"全款\",\"person\":\"小黑\",\"phone\":\"18776423429\",\"price\":7777,\"shipping\":\"海运\",\"total\":155540,\"unit\":\"斤\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-13 12:09:09');
INSERT INTO `guet_operation_log` VALUES ('306', '1', '小马', '订单管理', '修改订单', 'com.yang.guetconsumerr.controller.GuetOrderController.update()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"brand\":\"华为\",\"citi\":\"黄埔区\",\"customerId\":16,\"desc\":\"666\",\"id\":14,\"name\":\"笔记本\",\"number\":10,\"payment\":\"全款\",\"person\":\"小黑\",\"phone\":\"18776423429\",\"price\":7777,\"shipping\":\"海运\",\"total\":77770,\"unit\":\"台\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-13 12:11:24');
INSERT INTO `guet_operation_log` VALUES ('307', '1', '小马', '订单管理', '修改订单', 'com.yang.guetconsumerr.controller.GuetOrderController.update()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"brand\":\"华为1\",\"citi\":\"黄埔区\",\"customerId\":16,\"desc\":\"666\",\"id\":14,\"name\":\"笔记本\",\"number\":11,\"payment\":\"全款\",\"person\":\"小黑\",\"phone\":\"18776423429\",\"price\":7777,\"shipping\":\"海运\",\"total\":85547,\"unit\":\"台\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-13 12:14:49');
INSERT INTO `guet_operation_log` VALUES ('308', '1', '小马', '订单管理', '修改订单', 'com.yang.guetconsumerr.controller.GuetOrderController.update()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"brand\":\"华为\",\"citi\":\"黄埔区\",\"customerId\":17,\"desc\":\"666\",\"id\":14,\"name\":\"笔记本1\",\"number\":11,\"payment\":\"全款\",\"person\":\"小黑\",\"phone\":\"18776423429\",\"price\":7777,\"shipping\":\"空运\",\"total\":85547,\"unit\":\"台\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-13 12:16:12');
INSERT INTO `guet_operation_log` VALUES ('309', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":41,\"operatorId\":1,\"orderId\":14,\"paymentAmount\":500,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-13 12:16:45');
INSERT INTO `guet_operation_log` VALUES ('310', '1', '小马', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-14 08:32:39');
INSERT INTO `guet_operation_log` VALUES ('311', '1', '小马', '系统', '用户登录', 'com.yang.guetconsumerr.controller.GuetController.verifyLogin()', '[{\"password\":\"123456\",\"username\":\"admin\"},{}]', '127.0.0.1', '1', null, '2026-03-14 08:59:00');
INSERT INTO `guet_operation_log` VALUES ('312', '1', '小马', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"桂林电子科技大学\",\"citi\":\"白云区\",\"customerId\":2,\"desc\":\"化妆品\",\"items\":[{\"brand\":\"白云山\",\"name\":\"维生素E护肤\",\"number\":20,\"price\":9,\"total\":180,\"unit\":\"个\"}],\"payment\":\"预付定金\",\"person\":\"张三\",\"phone\":\"18776423429\",\"pickup\":\"自动配送\",\"shipping\":\"空运\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-14 09:18:46');
INSERT INTO `guet_operation_log` VALUES ('313', '1', '小马', '物流管理', '更新物流状态', 'com.yang.guetconsumerr.controller.LogisticsController.addLogistics()', '[{\"location\":\"广西自治区\",\"operator\":\"小马\",\"orderId\":45,\"remark\":\"\",\"status\":2,\"statusText\":\"已取件\"}]', '127.0.0.1', '1', null, '2026-03-14 09:19:22');
INSERT INTO `guet_operation_log` VALUES ('314', '1', '小马', '订单管理', '修改订单', 'com.yang.guetconsumerr.controller.GuetOrderController.update()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"brand\":\"拼多多\",\"citi\":\"黄埔区\",\"customerId\":17,\"desc\":\"\",\"id\":15,\"name\":\"椅子\",\"number\":5,\"payment\":\"全款\",\"person\":\"杨果\",\"phone\":\"18776423429\",\"price\":88,\"shipping\":\"海运\",\"total\":440,\"unit\":\"斤\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-14 09:42:24');
INSERT INTO `guet_operation_log` VALUES ('315', '1', '小马', '订单管理', '修改订单', 'com.yang.guetconsumerr.controller.GuetOrderController.update()', '[{\"address\":\"广西水利电力职业技术学院（长堽校区）\",\"brand\":\"华为\",\"citi\":\"黄埔区\",\"customerId\":17,\"desc\":\"666\",\"id\":14,\"name\":\"笔记本1\",\"number\":10,\"payment\":\"全款\",\"person\":\"小黑\",\"phone\":\"18776423429\",\"price\":7777,\"shipping\":\"空运\",\"total\":77770,\"unit\":\"台\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-14 09:52:49');
INSERT INTO `guet_operation_log` VALUES ('316', '1', '小马', '订单管理', '新增订单', 'com.yang.guetconsumerr.controller.GuetOrderController.addOrder()', '[{\"address\":\"象鼻山山顶\",\"citi\":\"白云区\",\"customerId\":2,\"desc\":\"米线\",\"items\":[{\"brand\":\"桂林特产\",\"name\":\"桂林米粉\",\"number\":10,\"price\":2,\"total\":20,\"unit\":\"斤\"}],\"payment\":\"预付定金\",\"person\":\"刘三姐\",\"phone\":\"18776423429\",\"pickup\":\"自动配送\",\"shipping\":\"空运\",\"userId\":1}]', '127.0.0.1', '1', null, '2026-03-15 11:41:24');
INSERT INTO `guet_operation_log` VALUES ('317', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":59,\"operatorId\":1,\"orderId\":45,\"paymentAmount\":180,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-15 17:42:58');
INSERT INTO `guet_operation_log` VALUES ('318', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":58,\"operatorId\":1,\"orderId\":44,\"paymentAmount\":1180,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-15 17:50:12');
INSERT INTO `guet_operation_log` VALUES ('319', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":54,\"operatorId\":1,\"orderId\":40,\"paymentAmount\":9992,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-15 17:50:25');
INSERT INTO `guet_operation_log` VALUES ('320', '1', '小马', '运费结算', '添加结算', 'com.yang.guetconsumerr.controller.FinanceController.addPayment()', '[{\"financeId\":57,\"operatorId\":1,\"orderId\":43,\"paymentAmount\":8,\"paymentMethod\":\"银行转账\"}]', '127.0.0.1', '1', null, '2026-03-15 20:04:02');

-- ----------------------------
-- Table structure for `guet_order`
-- ----------------------------
DROP TABLE IF EXISTS `guet_order`;
CREATE TABLE `guet_order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `customer_id` int DEFAULT NULL,
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `order_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `order_number` int DEFAULT NULL,
  `order_price` int DEFAULT NULL,
  `order_total` bigint DEFAULT NULL,
  `order_status` tinyint DEFAULT NULL,
  `order_address` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `order_payment` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `order_shipping` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `order_citi` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `order_phone` varchar(255) DEFAULT NULL,
  `order_person` varchar(255) DEFAULT NULL,
  `order_pickup` varchar(30) DEFAULT NULL,
  `order_unit` varchar(20) DEFAULT NULL,
  `order_brand` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of guet_order
-- ----------------------------
INSERT INTO `guet_order` VALUES ('11', '5', '15', 'td5916659401', '电脑', '5', '5000', '25000', '1', '广西区桂林市金鸡路1号', '2025-12-17 04:24:19', '全款', '海运', '大连', '不要报错', '18776423429', '自己人', '上门取件', '斤', '苹果');
INSERT INTO `guet_order` VALUES ('13', '1', '16', 'td5938365049', '被子', '10', '17', '170', '1', '广西区桂林市金鸡路1号', '2026-03-13 12:00:28', '预付定金', '空运', '黄埔区', '轻拿轻放', '18776423429', '暂放小卖部', '快递邮寄', '个', '京东甄选1');
INSERT INTO `guet_order` VALUES ('14', '1', '17', 'td5938555898', '笔记本1', '10', '7777', '77770', '1', '广西水利电力职业技术学院（长堽校区）', '2026-03-14 09:52:49', '全款', '空运', '黄埔区', '666', '18776423429', '小黑', '上门取件', '台', '华为');
INSERT INTO `guet_order` VALUES ('15', '1', '17', 'td5938678491', '椅子', '5', '88', '440', '1', '广西水利电力职业技术学院（长堽校区）', '2026-03-14 09:42:24', '全款', '海运', '黄埔区', '', '18776423429', '杨果', '上门取件', '斤', '拼多多');
INSERT INTO `guet_order` VALUES ('16', '1', '17', 'td6125165963', '塑料颗', '10', '0', '8', '1', '广西水利电力职业技术学院（长堽校区）', '2025-12-19 14:19:25', '全款', '海运', '宁波', '塑料', '18776423429', '张经理', '上门取件', '斤', '三无产品');
INSERT INTO `guet_order` VALUES ('17', '14', '18', 'td6126046782', '内裤', '50', '9', '450', '1', '广西水利电力职业技术学院（长堽校区）', '2025-12-19 14:34:06', '全款', '海运', '大连', '急用，请优先发货', '18776423429', '杨总', '上门取件', '件', '纯棉');
INSERT INTO `guet_order` VALUES ('19', '1', '2', 'td6200417647', '被子', '3', '99', '297', '1', '广西水利电力职业技术学院（长堽校区）', '2025-12-20 11:13:37', '预付定金', '空运', '海珠区', '生活用品', '18776423429', '杨怡', '自动配送', '件', '温州货');
INSERT INTO `guet_order` VALUES ('22', '1', '2', 'td6200792098', '鞋子', '4', '19', '76', '1', '广西水利电力职业技术学院（长堽校区）', '2025-12-20 11:19:52', '预付定金', '空运', '海珠区', '生活用品', '18776423429', '杨怡', '自动配送', '个', '地摊货');
INSERT INTO `guet_order` VALUES ('23', '14', '19', 'td6201121999', '被子', '3', '99', '297', '1', '广西水利电力职业技术学院（长堽校区）', '2025-12-20 11:25:22', '全款', '海运', '白云区', '生活用品', '18776423429', '杨怡', '上门取件', '斤', '温州货');
INSERT INTO `guet_order` VALUES ('24', '14', '19', 'td6201122020', '衣服', '5', '88', '440', '1', '广西水利电力职业技术学院（长堽校区）', '2025-12-20 11:25:22', '全款', '海运', '白云区', '生活用品', '18776423429', '杨怡', '上门取件', '件', '耐克');
INSERT INTO `guet_order` VALUES ('25', '14', '19', 'td6201122036', '洗发水', '2', '39', '78', '1', '广西水利电力职业技术学院（长堽校区）', '2025-12-20 11:25:22', '全款', '海运', '白云区', '生活用品', '18776423429', '杨怡', '上门取件', '个', '海飞丝');
INSERT INTO `guet_order` VALUES ('26', '5', '15', 'td8923743823', '筷子', '10', '9', '90', '1', '广西水利电力职业技术学院（长堽校区）', '2026-01-20 23:42:23', '全款', '海运', '越秀区', '1', '18776423429', '张无忌', '上门取件', '个', '小米制造');
INSERT INTO `guet_order` VALUES ('27', '5', '15', 'td8924008434', '袋子', '20', '2', '40', '1', '广西区桂林市金鸡路1号', '2026-01-20 23:46:48', '到付', '空运', '越秀区', '到底', '18776423429', '啊', '快递邮寄', '个', '三五产品');
INSERT INTO `guet_order` VALUES ('28', '1', '2', 'td8994826556', '1', '2', '2', '4', '1', '广西区桂林市金鸡路1号', '2026-01-21 19:27:06', '全款', '海运', '越秀区', '到底', '18776423429', '啊', '上门取件', '斤', '3');
INSERT INTO `guet_order` VALUES ('30', '12', '7', 'td9010437026', '华为手机', '10', '3999', '39990', '1', '广西水利电力职业技术学院（长堽校区）', '2026-01-21 23:47:17', '全款', '海运', '天河区', '', '18776423429', '计算机', '上门取件', '台', 'HUAWEI');
INSERT INTO `guet_order` VALUES ('31', '12', '7', 'td9010437053', '红米手机', '5', '1999', '9995', '1', '广西水利电力职业技术学院（长堽校区）', '2026-01-21 23:47:17', '全款', '海运', '天河区', '', '18776423429', '计算机', '上门取件', '台', 'MI');
INSERT INTO `guet_order` VALUES ('32', '29', '20', 'td373362194', '键盘', '22', '33', '726', '1', '广西水利电力职业技术学院（长堽校区）', '2026-02-06 18:22:42', '预付定金', '海运', '越秀区', '33', '18776423429', '2', '上门取件', '个', '华硕');
INSERT INTO `guet_order` VALUES ('33', '29', '20', 'td373455610', '笔记本', '3999', '20', '79980', '1', '广西区桂林市金鸡路1号', '2026-02-06 18:24:15', '全款', '海运', '海珠区', '', '18776423429', '张三', '上门取件', '台', '苹果');
INSERT INTO `guet_order` VALUES ('34', '29', '20', 'td373455646', '碗', '20', '99', '1980', '1', '广西区桂林市金鸡路1号', '2026-02-06 18:24:15', '全款', '海运', '海珠区', '', '18776423429', '张三', '上门取件', '个', '');
INSERT INTO `guet_order` VALUES ('35', '12', '7', 'td378814075', '3453', '54', '45', '2430', '1', '广西水利电力职业技术学院（长堽校区）', '2026-02-06 19:53:34', '全款', '海运', '越秀区', '3453', '18776423429', '5454', '上门取件', '斤', '4');
INSERT INTO `guet_order` VALUES ('36', '1', '2', 'td2724709428', '水壶', '2', '39', '78', '1', '广东深圳', '2026-03-05 23:31:49', '全款', '海运', '越秀区', '', '1839273492', '杨恩', '上门取件', '个', '雅诗');
INSERT INTO `guet_order` VALUES ('37', '1', '17', 'td2780569464', '汽车轮子', '4', '99', '396', '1', '北京天安门', '2026-03-06 15:02:49', '预付定金', '空运', '天河区', '', '1857489573', '祝分', '自动配送', '个', '橡皮制造');
INSERT INTO `guet_order` VALUES ('38', '1', '16', 'td2781609052', '显卡', '13', '299', '3887', '1', '美国', '2026-03-06 15:20:09', '预付定金', '空运', '荔枝区', '电脑4080T处理器', '18473847393·', '马克', '自动配送', '个', '百亿补贴');
INSERT INTO `guet_order` VALUES ('39', '1', '17', 'td2974382040', '小米17', '10', '3999', '39990', '1', '北京大学', '2026-03-08 20:53:02', '全款', '空运', '荔枝区', 'openClaw最新技术', '18776423429', '小黑', '自动配送', '台', '小米');
INSERT INTO `guet_order` VALUES ('40', '1', '16', 'td2975047362', '笔记本电脑', '2', '4999', '9998', '1', '广州市天河区龙岗路沙河大街 89 号', '2026-03-08 21:04:07', '全款', '海运', '天河区', '电子产品', '18776423429', '张三', '上门取件', '台', '华硕');
INSERT INTO `guet_order` VALUES ('41', '1', '16', 'td2975047394', 'phone 17', '4', '5999', '23996', '1', '广州市天河区龙岗路沙河大街 89 号', '2026-03-08 21:04:07', '全款', '海运', '天河区', '电子产品', '18776423429', '张三', '上门取件', '台', '苹果');
INSERT INTO `guet_order` VALUES ('42', '1', '16', 'td3148180712', '鞋子', '4', '199', '796', '1', '深圳黄铺区', '2026-03-10 21:09:40', '预付定金', '陆运', '黄埔区', '保密发货', '18776423429', '王大家', '自动配送', '个', '耐克');
INSERT INTO `guet_order` VALUES ('43', '1', '2', 'td3233663863', '刀', '2', '99', '198', '1', '广东中山', '2026-03-11 20:54:23', '预付定金', '空运', '白云区', '', '18776423429', '李张', '自动配送', '件', '杂牌');
INSERT INTO `guet_order` VALUES ('44', '1', '2', 'td3239501369', 'c语言数据结构', '20', '59', '1180', '1', '桂电金鸡岭校区', '2026-03-11 22:31:41', '预付定金', '陆运', '白云区', 'c语言数据结构20本', '18776423429', '杨饿哦', '自动配送', '个', '正品');
INSERT INTO `guet_order` VALUES ('45', '1', '2', 'td3451126053', '维生素E护肤', '20', '9', '180', '1', '桂林电子科技大学', '2026-03-14 09:18:46', '预付定金', '空运', '白云区', '化妆品', '18776423429', '张三', '自动配送', '个', '白云山');
INSERT INTO `guet_order` VALUES ('46', '1', '2', 'td3546083907', '桂林米粉', '10', '2', '20', '1', '象鼻山山顶', '2026-03-15 11:41:23', '预付定金', '空运', '白云区', '米线', '18776423429', '刘三姐', '自动配送', '斤', '桂林特产');

-- ----------------------------
-- Table structure for `guet_payment_record`
-- ----------------------------
DROP TABLE IF EXISTS `guet_payment_record`;
CREATE TABLE `guet_payment_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `finance_id` bigint NOT NULL,
  `order_id` int NOT NULL,
  `payment_amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(20) NOT NULL,
  `payment_time` timestamp NOT NULL,
  `operator_id` bigint DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of guet_payment_record
-- ----------------------------
INSERT INTO `guet_payment_record` VALUES ('1', '1', '11', '10000.00', '转账', '2025-12-18 10:30:00', '1', '2026-01-22 00:03:50');
INSERT INTO `guet_payment_record` VALUES ('2', '1', '11', '5000.00', '支付宝', '2025-12-19 14:20:00', '1', '2026-01-22 00:03:50');
INSERT INTO `guet_payment_record` VALUES ('3', '2', '13', '136.00', '现金', '2025-12-17 11:00:00', '1', '2026-01-22 00:03:50');
INSERT INTO `guet_payment_record` VALUES ('4', '3', '14', '20000.00', '微信', '2025-12-17 15:30:00', '1', '2026-01-22 00:03:50');
INSERT INTO `guet_payment_record` VALUES ('5', '4', '15', '440.00', '转账', '2025-12-18 09:00:00', '1', '2026-01-22 00:03:50');
INSERT INTO `guet_payment_record` VALUES ('6', '7', '18', '1000.00', '支付宝', '2025-12-20 10:00:00', '1', '2026-01-22 00:03:50');
INSERT INTO `guet_payment_record` VALUES ('7', '45', '18', '2.00', '银行转账', '2026-02-06 18:05:11', '1', '2026-02-06 18:05:11');
INSERT INTO `guet_payment_record` VALUES ('8', '45', '18', '5.00', '微信', '2026-02-06 18:05:35', '1', '2026-02-06 18:05:35');
INSERT INTO `guet_payment_record` VALUES ('9', '45', '18', '3.00', '银行转账', '2026-02-06 18:05:50', '1', '2026-02-06 18:05:50');
INSERT INTO `guet_payment_record` VALUES ('10', '47', '33', '30000.00', '微信', '2026-02-06 18:25:07', '29', '2026-02-06 18:25:07');
INSERT INTO `guet_payment_record` VALUES ('11', '49', '35', '100.00', '银行转账', '2026-02-06 19:54:20', '12', '2026-02-06 19:54:20');
INSERT INTO `guet_payment_record` VALUES ('12', '49', '35', '2330.00', '银行转账', '2026-03-05 20:09:46', '1', '2026-03-05 20:09:46');
INSERT INTO `guet_payment_record` VALUES ('13', '39', '11', '4.00', '银行转账', '2026-03-05 20:23:42', '5', '2026-03-05 20:23:42');
INSERT INTO `guet_payment_record` VALUES ('14', '39', '11', '9.00', '银行转账', '2026-03-05 20:23:50', '5', '2026-03-05 20:23:50');
INSERT INTO `guet_payment_record` VALUES ('15', '48', '34', '4.00', '银行转账', '2026-03-05 20:44:47', '1', '2026-03-05 20:44:47');
INSERT INTO `guet_payment_record` VALUES ('16', '45', '18', '6.00', '银行转账', '2026-03-05 20:45:21', '1', '2026-03-05 20:45:21');
INSERT INTO `guet_payment_record` VALUES ('17', '50', '36', '7.00', '银行转账', '2026-03-06 14:39:58', '1', '2026-03-06 14:39:58');
INSERT INTO `guet_payment_record` VALUES ('18', '50', '36', '71.00', '银行转账', '2026-03-06 14:56:24', '1', '2026-03-06 14:56:24');
INSERT INTO `guet_payment_record` VALUES ('19', '51', '37', '8.00', '银行转账', '2026-03-06 15:03:16', '1', '2026-03-06 15:03:16');
INSERT INTO `guet_payment_record` VALUES ('20', '52', '38', '5.00', '银行转账', '2026-03-06 15:20:23', '1', '2026-03-06 15:20:23');
INSERT INTO `guet_payment_record` VALUES ('21', '39', '11', '9987.00', '银行转账', '2026-03-06 15:21:17', '1', '2026-03-06 15:21:17');
INSERT INTO `guet_payment_record` VALUES ('22', '52', '38', '3882.00', '支付宝', '2026-03-06 15:22:02', '1', '2026-03-06 15:22:02');
INSERT INTO `guet_payment_record` VALUES ('23', '51', '37', '100.00', '支付宝', '2026-03-08 21:43:13', '1', '2026-03-08 21:43:13');
INSERT INTO `guet_payment_record` VALUES ('24', '55', '41', '1000.00', '支付宝', '2026-03-08 22:23:12', '1', '2026-03-08 22:23:12');
INSERT INTO `guet_payment_record` VALUES ('25', '55', '41', '800.00', '现金', '2026-03-08 22:23:42', '1', '2026-03-08 22:23:42');
INSERT INTO `guet_payment_record` VALUES ('26', '54', '40', '6.00', '银行转账', '2026-03-08 22:57:49', '1', '2026-03-08 22:57:49');
INSERT INTO `guet_payment_record` VALUES ('27', '41', '14', '10000.00', '银行转账', '2026-03-13 12:08:45', '1', '2026-03-13 12:08:45');
INSERT INTO `guet_payment_record` VALUES ('28', '41', '14', '500.00', '银行转账', '2026-03-13 12:16:45', '1', '2026-03-13 12:16:45');
INSERT INTO `guet_payment_record` VALUES ('29', '59', '45', '180.00', '银行转账', '2026-03-15 17:42:59', '1', '2026-03-15 17:42:59');
INSERT INTO `guet_payment_record` VALUES ('30', '58', '44', '1180.00', '银行转账', '2026-03-15 17:50:12', '1', '2026-03-15 17:50:12');
INSERT INTO `guet_payment_record` VALUES ('31', '54', '40', '9992.00', '银行转账', '2026-03-15 17:50:25', '1', '2026-03-15 17:50:25');
INSERT INTO `guet_payment_record` VALUES ('32', '57', '43', '8.00', '银行转账', '2026-03-15 20:04:02', '1', '2026-03-15 20:04:02');

-- ----------------------------
-- Table structure for `guet_role`
-- ----------------------------
DROP TABLE IF EXISTS `guet_role`;
CREATE TABLE `guet_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `role_name` varchar(20) NOT NULL DEFAULT '' COMMENT '角色名称',
  `role_code` varchar(20) DEFAULT NULL COMMENT '角色编码',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '删除标记（0:不可用 1:可用）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb3 COMMENT='角色';

-- ----------------------------
-- Records of guet_role
-- ----------------------------
INSERT INTO `guet_role` VALUES ('9', '平台管理员', 'ptgly', '平台管理员', '2025-09-03 21:23:41', '2026-03-08 22:49:06', '0');
INSERT INTO `guet_role` VALUES ('10', '用户管理员', 'yhgly', '用户管理员', '2025-09-03 21:23:41', '2025-12-11 23:21:15', '0');
INSERT INTO `guet_role` VALUES ('36', '销售人员', '销售', null, '2025-09-03 21:23:41', '2025-12-11 23:21:17', '0');
INSERT INTO `guet_role` VALUES ('37', '业务人员', '业务人员', '', '2025-09-03 21:23:41', '2026-03-08 22:46:26', '0');
INSERT INTO `guet_role` VALUES ('38', '开发人员', 'dev', null, '2025-09-03 21:23:41', '2025-12-11 23:21:20', '0');
INSERT INTO `guet_role` VALUES ('39', '运维人员', 'yw', null, '2025-09-03 21:23:41', '2025-12-11 23:21:25', '0');
INSERT INTO `guet_role` VALUES ('45', '总经理', '234234', '老板', '2025-12-12 01:48:45', '2026-03-08 22:47:42', '0');

-- ----------------------------
-- Table structure for `guet_user`
-- ----------------------------
DROP TABLE IF EXISTS `guet_user`;
CREATE TABLE `guet_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '会员id',
  `username` varchar(20) NOT NULL DEFAULT '' COMMENT '用户名',
  `password` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '瀵嗙爜',
  `name` varchar(50) DEFAULT NULL COMMENT '姓名',
  `phone` varchar(11) DEFAULT NULL COMMENT '手机',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态（1：正常 0：停用）',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `sex` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';

-- ----------------------------
-- Records of guet_user
-- ----------------------------
INSERT INTO `guet_user` VALUES ('1', 'admin', '$2a$10$4Gpr.8tQfycdlBHynJWrleIDReLXozC30igqBi/aRiO.P209xLvMO', '小马', '15011113652', 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg', '管理员账号', '1', '2026-01-01 10:17:18', '2026-03-08 22:50:50', '男');
INSERT INTO `guet_user` VALUES ('5', 'zhangsan', '$2a$10$EBAjGQz4zfn8SiX1WF4G6upRfWOqJ8w9xIEpTpYPO//SmM4pWiagy', '张三33', '13589658968', 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg', '', '1', '2026-01-02 10:17:18', '2026-03-08 22:50:57', '男');
INSERT INTO `guet_user` VALUES ('6', 'test1212', '$2a$10$EBAjGQz4zfn8SiX1WF4G6upRfWOqJ8w9xIEpTpYPO//SmM4pWiagy', 'test12', '15011245632', 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg', 'test12', '0', '2026-01-03 10:17:18', '2026-03-08 22:51:03', '男');
INSERT INTO `guet_user` VALUES ('12', 'lucy1', '$2a$10$EBAjGQz4zfn8SiX1WF4G6upRfWOqJ8w9xIEpTpYPO//SmM4pWiagy', '1', '1', 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg', '1', '1', '2026-01-04 10:17:18', '2026-03-08 22:51:09', '男');
INSERT INTO `guet_user` VALUES ('13', 'hello', '$2a$10$sO8ytR6bCq1CLeP1W7Qi3eWyEf7ronQ0lAyA0iFmbkT1dUNEfoeMm', 'hello', '12343423423', 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg', 'hello', '1', '2026-01-05 10:17:18', '2026-03-08 22:51:18', '女');
INSERT INTO `guet_user` VALUES ('14', 'hello', '$2a$10$0bOajXwm0Lv2Mr0mxCk2.uFj9yz1zgz7ttpHqt4SOimIc4G6Zk27q', '111', '444', '444', '77', '1', '2025-12-12 04:03:33', '2025-12-20 10:28:18', '');
INSERT INTO `guet_user` VALUES ('16', 'hello1', '$2a$10$EBAjGQz4zfn8SiX1WF4G6upRfWOqJ8w9xIEpTpYPO//SmM4pWiagy', '222', '55', '33', '88', '1', '2025-12-12 04:18:44', '2025-12-16 07:42:57', '');
INSERT INTO `guet_user` VALUES ('17', 'hello1', '$2a$10$EBAjGQz4zfn8SiX1WF4G6upRfWOqJ8w9xIEpTpYPO//SmM4pWiagy', '33', '66', '222', '99', '1', '2025-12-12 04:18:45', '2025-12-16 07:42:57', null);
INSERT INTO `guet_user` VALUES ('26', 'hello123', '$2a$10$EBAjGQz4zfn8SiX1WF4G6upRfWOqJ8w9xIEpTpYPO//SmM4pWiagy', 'demo001', '', null, '', '0', '2025-12-12 22:57:17', '2025-12-16 07:42:57', '');
INSERT INTO `guet_user` VALUES ('29', '广西234', '$2a$10$EBAjGQz4zfn8SiX1WF4G6upRfWOqJ8w9xIEpTpYPO//SmM4pWiagy', '小明111', '', null, '', '1', '2025-12-15 09:23:56', '2025-12-16 07:42:57', '');

-- ----------------------------
-- Table structure for `guet_user_role`
-- ----------------------------
DROP TABLE IF EXISTS `guet_user_role`;
CREATE TABLE `guet_user_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `role_id` bigint NOT NULL DEFAULT '0' COMMENT '角色id',
  `user_id` bigint NOT NULL DEFAULT '0' COMMENT '用户id',
  PRIMARY KEY (`id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_admin_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb3 COMMENT='用户角色';

-- ----------------------------
-- Records of guet_user_role
-- ----------------------------
INSERT INTO `guet_user_role` VALUES ('26', '45', '30');
INSERT INTO `guet_user_role` VALUES ('27', '10', '30');
INSERT INTO `guet_user_role` VALUES ('28', '38', '30');
INSERT INTO `guet_user_role` VALUES ('54', '9', '13');
INSERT INTO `guet_user_role` VALUES ('56', '10', '14');
INSERT INTO `guet_user_role` VALUES ('63', '45', '5');
INSERT INTO `guet_user_role` VALUES ('64', '10', '1');
INSERT INTO `guet_user_role` VALUES ('65', '9', '1');
INSERT INTO `guet_user_role` VALUES ('66', '36', '1');
