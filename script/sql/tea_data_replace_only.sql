SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

USE `ry_tea`;

-- 首次执行脚本：补齐茶叶字段（再次执行可能因重复列报错）
ALTER TABLE `wms_item` ADD COLUMN `tea_type` varchar(20) NULL COMMENT '茶类';
ALTER TABLE `wms_item` ADD COLUMN `tea_origin` varchar(60) NULL COMMENT '产区';
ALTER TABLE `wms_item` ADD COLUMN `tea_level` varchar(10) NULL COMMENT '等级';
ALTER TABLE `wms_item` ADD COLUMN `harvest_season` varchar(20) NULL COMMENT '采摘季';

-- 清空业务数据（保留系统用户/角色主体）
TRUNCATE TABLE `wms_inventory_history`;
TRUNCATE TABLE `wms_check_order_detail`;
TRUNCATE TABLE `wms_check_order`;
TRUNCATE TABLE `wms_movement_order_detail`;
TRUNCATE TABLE `wms_movement_order`;
TRUNCATE TABLE `wms_shipment_order_detail`;
TRUNCATE TABLE `wms_shipment_order`;
TRUNCATE TABLE `wms_receipt_order_detail`;
TRUNCATE TABLE `wms_receipt_order`;
TRUNCATE TABLE `wms_inventory`;
TRUNCATE TABLE `wms_item_sku`;
TRUNCATE TABLE `wms_item`;
TRUNCATE TABLE `wms_item_category`;
TRUNCATE TABLE `wms_item_brand`;
TRUNCATE TABLE `wms_merchant`;
TRUNCATE TABLE `wms_warehouse`;

-- 茶仓
INSERT INTO `wms_warehouse` (`id`,`warehouse_code`,`warehouse_name`,`remark`,`order_num`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1828364609002311682,'HZ-MAIN','杭州龙井主仓','浙江茶区成品主仓',1,'admin',NOW(),'admin',NOW()),
(1828364740028174337,'FJ-QA','福鼎白茶审评仓','审评与抽检仓',2,'admin',NOW(),'admin',NOW()),
(1840317750635581441,'BJ-FIN','北京渠道成品仓','华北经销中转仓',3,'admin',NOW(),'admin',NOW());

-- 茶企
INSERT INTO `wms_merchant` (`id`,`merchant_code`,`merchant_name`,`merchant_type`,`merchant_level`,`bank_name`,`bank_account`,`address`,`mobile`,`tel`,`contact_person`,`email`,`remark`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1828354016258199554,'buyer_001','杭州国茶商贸有限公司',1,'A','中国银行杭州西湖支行','622200000000000001','浙江省杭州市西湖区龙井路88号','13888880001','0571-88880001','王雨桐','buyer@guochatea.cn','核心采购方','admin',NOW(),'admin',NOW()),
(1828354153193836545,'supplier_001','福建武夷山岩茶股份有限公司',2,'S','中国工商银行武夷山支行','622200000000000002','福建省南平市武夷山市度假区1号','13888880002','0599-88880002','陈建华','supplier@wuyitea.cn','武夷岩茶供应商','admin',NOW(),'admin',NOW()),
(1828354284882399233,'dealer_001','北京华茗茶业连锁有限公司',3,'A','中国建设银行北京朝阳支行','622200000000000003','北京市朝阳区建国路86号','13888880003','010-88880003','刘子墨','dealer@huamingtea.cn','全国经销合作方','admin',NOW(),'admin',NOW());

-- 茶品品牌
INSERT INTO `wms_item_brand` (`id`,`brand_name`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1828364846953566209,'西湖牌','admin',NOW(),'admin',NOW()),
(1828364873889386498,'八马茶业','admin',NOW(),'admin',NOW()),
(1828364927610032129,'武夷星','admin',NOW(),'admin',NOW()),
(1828407151135723522,'大益','admin',NOW(),'admin',NOW()),
(1828407291103842306,'品品香','admin',NOW(),'admin',NOW());

-- 茶类
INSERT INTO `wms_item_category` (`id`,`parent_id`,`category_name`,`order_num`,`status`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1828364988754595841,0,'绿茶',0,'1','admin',NOW(),'admin',NOW()),
(1828365014901886978,0,'红茶',1,'1','admin',NOW(),'admin',NOW()),
(1828365043024695297,0,'乌龙茶',2,'1','admin',NOW(),'admin',NOW()),
(1828405743737016322,0,'白茶',3,'1','admin',NOW(),'admin',NOW()),
(1828405773474631681,1828405743737016322,'白牡丹',0,'1','admin',NOW(),'admin',NOW()),
(1828405825714688001,1828405743737016322,'寿眉',1,'1','admin',NOW(),'admin',NOW()),
(1828408600515219457,0,'黑茶',4,'1','admin',NOW(),'admin',NOW()),
(1829397860466749441,0,'普洱茶',5,'1','admin',NOW(),'admin',NOW()),
(1829397958923841538,1829397860466749441,'生普',0,'1','admin',NOW(),'admin',NOW()),
(1829398007993004034,1829397860466749441,'熟普',1,'1','admin',NOW(),'admin',NOW()),
(1840282771834667010,1828405743737016322,'贡眉',2,'1','admin',NOW(),'admin',NOW());

-- 茶品
INSERT INTO `wms_item` (`id`,`item_code`,`item_name`,`item_category`,`unit`,`item_brand`,`tea_type`,`tea_origin`,`tea_level`,`harvest_season`,`remark`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1828402622516334594,'TEA-LJ-001','西湖龙井','1828364988754595841','斤',1828364846953566209,'green','浙江杭州西湖区','S','mingqian','明前头采','admin',NOW(),'admin',NOW()),
(1828406450112335874,'TEA-TGY-001','安溪铁观音','1828365043024695297','斤',1828364873889386498,'oolong','福建安溪','A','autumn','浓香型','admin',NOW(),'admin',NOW()),
(1829398701680553985,'TEA-JJ-001','金骏眉','1828365014901886978','斤',1828364927610032129,'black','福建武夷山','S','mingqian','桐木关工艺','admin',NOW(),'admin',NOW()),
(1840282974297915394,'TEA-BMD-001','白牡丹','1840282771834667010','斤',1828407291103842306,'white','福建福鼎','A','yuqian','福鼎白茶','admin',NOW(),'admin',NOW());

-- 茶品规格
INSERT INTO `wms_item_sku` (`id`,`sku_name`,`item_id`,`barcode`,`sku_code`,`length`,`width`,`height`,`gross_weight`,`net_weight`,`cost_price`,`selling_price`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1828402624005312514,'明前特级 250g',1828402622516334594,'6930000000001','LJ-250-S',NULL,NULL,NULL,NULL,0.250,580.00,680.00,'admin',NOW(),'admin',NOW()),
(1828406451399987201,'浓香型 250g',1828406450112335874,'6930000000002','TGY-250-A',NULL,NULL,NULL,NULL,0.250,260.00,328.00,'admin',NOW(),'admin',NOW()),
(1829398702011904001,'桐木关 特级 125g',1829398701680553985,'6930000000003','JJM-125-S',NULL,NULL,NULL,NULL,0.125,420.00,528.00,'admin',NOW(),'admin',NOW()),
(1840282974629265410,'白牡丹 一级 350g',1840282974297915394,'6930000000004','BMD-350-A',NULL,NULL,NULL,NULL,0.350,188.00,258.00,'admin',NOW(),'admin',NOW()),
(1840282974696374273,'白牡丹 特级 500g',1840282974297915394,'6930000000005','BMD-500-S',NULL,NULL,NULL,NULL,0.500,268.00,358.00,'admin',NOW(),'admin',NOW());

-- 单据与库存
INSERT INTO `wms_receipt_order` (`id`,`order_no`,`opt_type`,`merchant_id`,`biz_order_no`,`total_quantity`,`total_amount`,`order_status`,`warehouse_id`,`remark`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1843920012030070785,'RC24050988',1,1828354153193836545,'PO-20241009001',200.00,47200.00,1,1828364609002311682,'福建春茶采购入仓','admin',NOW(),'admin',NOW());

INSERT INTO `wms_receipt_order_detail` (`id`,`order_id`,`sku_id`,`quantity`,`amount`,`warehouse_id`,`remark`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1843920012088791042,1843920012030070785,1840282974696374273,120.00,32160.00,1828364609002311682,'白牡丹特级入仓','admin',NOW(),'admin',NOW()),
(1843920012105568258,1843920012030070785,1840282974629265410,80.00,15040.00,1828364609002311682,'白牡丹一级入仓','admin',NOW(),'admin',NOW());

INSERT INTO `wms_shipment_order` (`id`,`order_no`,`opt_type`,`biz_order_no`,`merchant_id`,`total_amount`,`total_quantity`,`order_status`,`warehouse_id`,`remark`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1843920133316759553,'SC24050945',1,'SO-20241009001',1828354284882399233,5160.00,20.00,1,1828364609002311682,'华北渠道补货','admin',NOW(),'admin',NOW());

INSERT INTO `wms_shipment_order_detail` (`id`,`order_id`,`warehouse_id`,`sku_id`,`quantity`,`amount`,`remark`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1843920133354508289,1843920133316759553,1828364609002311682,1840282974629265410,20.00,5160.00,'白牡丹一级发运','admin',NOW(),'admin',NOW());

INSERT INTO `wms_movement_order` (`id`,`order_no`,`source_warehouse_id`,`target_warehouse_id`,`order_status`,`total_amount`,`total_quantity`,`remark`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1843920257199722498,'TR24050967',1828364609002311682,1840317750635581441,1,NULL,36.00,'华东主仓调拨到华北成品仓','admin',NOW(),'admin',NOW());

INSERT INTO `wms_movement_order_detail` (`id`,`order_id`,`sku_id`,`quantity`,`amount`,`remark`,`source_warehouse_id`,`target_warehouse_id`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1843920257237471233,1843920257199722498,1840282974696374273,36.00,NULL,'白牡丹特级调拨',1828364609002311682,1840317750635581441,'admin',NOW(),'admin',NOW());

INSERT INTO `wms_check_order` (`id`,`order_no`,`order_status`,`total_quantity`,`total_amount`,`warehouse_id`,`remark`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1843920323943682049,'CK24050915',1,78.00,NULL,1828364740028174337,'福鼎审评仓季度盘点','admin',NOW(),'admin',NOW());

INSERT INTO `wms_check_order_detail` (`id`,`order_id`,`sku_id`,`quantity`,`amount`,`check_quantity`,`warehouse_id`,`remark`,`inventory_id`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1843920323981430786,1843920323943682049,1840282974696374273,48.00,NULL,48.00,1828364740028174337,'白牡丹特级季末盘点',NULL,'admin',NOW(),'admin',NOW()),
(1843920323981430787,1843920323943682049,1840282974629265410,30.00,NULL,30.00,1828364740028174337,'白牡丹一级季末盘点',NULL,'admin',NOW(),'admin',NOW());

INSERT INTO `wms_inventory` (`id`,`sku_id`,`warehouse_id`,`quantity`,`remark`,`create_by`,`create_time`,`update_by`,`update_time`) VALUES
(1843920012193648642,1840282974696374273,1828364609002311682,120.00,'龙井与白牡丹主仓库存','admin',NOW(),'admin',NOW()),
(1843920012193648643,1840282974629265410,1828364609002311682,80.00,'白牡丹一级库存','admin',NOW(),'admin',NOW()),
(1843920257526878210,1840282974696374273,1840317750635581441,36.00,'华北成品仓库存','admin',NOW(),'admin',NOW()),
(1843920324082094081,1840282974696374273,1828364740028174337,48.00,'审评样仓库存','admin',NOW(),'admin',NOW()),
(1843920324082094082,1840282974629265410,1828364740028174337,30.00,'审评样仓库存','admin',NOW(),'admin',NOW());

INSERT INTO `wms_inventory_history` (`id`,`warehouse_id`,`sku_id`,`quantity`,`before_quantity`,`after_quantity`,`amount`,`remark`,`order_id`,`order_no`,`order_type`,`create_time`) VALUES
(1843920012248174593,1828364609002311682,1840282974696374273,120.00,0.00,120.00,32160.00,'春茶批次入仓',1843920012030070785,'RC24050988',1,NOW()),
(1843920012248174594,1828364609002311682,1840282974629265410,80.00,0.00,80.00,15040.00,'白牡丹入仓',1843920012030070785,'RC24050988',1,NOW()),
(1843920133446782977,1828364609002311682,1840282974629265410,-20.00,80.00,60.00,5160.00,'渠道发货',1843920133316759553,'SC24050945',2,NOW()),
(1843920257560432641,1828364609002311682,1840282974696374273,-36.00,120.00,84.00,NULL,'调拨至华北仓',1843920257199722498,'TR24050967',3,NOW()),
(1843920257581404162,1840317750635581441,1840282974696374273,36.00,0.00,36.00,NULL,'华北仓入账',1843920257199722498,'TR24050967',3,NOW()),
(1843920324149202945,1828364740028174337,1840282974696374273,48.00,0.00,48.00,NULL,'季度盘点建账',NULL,'CK24050915',4,NOW()),
(1843920324157591554,1828364740028174337,1840282974629265410,30.00,0.00,30.00,NULL,'季度盘点建账',NULL,'CK24050915',4,NOW());

-- 字典改成茶叶语义
UPDATE `sys_dict_type` SET `dict_name` = '茶企角色类型', `remark`='茶企角色类型' WHERE `dict_type`='merchant_type';
UPDATE `sys_dict_type` SET `dict_name` = '采购入仓状态' WHERE `dict_type`='wms_receipt_status';
UPDATE `sys_dict_type` SET `dict_name` = '采购入仓类型' WHERE `dict_type`='wms_receipt_type';
UPDATE `sys_dict_type` SET `dict_name` = '销售出仓状态' WHERE `dict_type`='wms_shipment_status';
UPDATE `sys_dict_type` SET `dict_name` = '销售出仓类型' WHERE `dict_type`='wms_shipment_type';
UPDATE `sys_dict_type` SET `dict_name` = '加工调拨状态' WHERE `dict_type`='wms_movement_status';
UPDATE `sys_dict_type` SET `dict_name` = '茶仓盘点状态' WHERE `dict_type`='wms_check_status';
UPDATE `sys_dict_type` SET `dict_name` = '茶仓流水操作类型' WHERE `dict_type`='wms_inventory_history_type';

INSERT INTO `sys_dict_type` (`dict_id`,`dict_name`,`dict_type`,`status`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1823182238898274310,'茶类','wms_tea_type','1','admin',NOW(),'',NULL, '中国茶类'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_type`='wms_tea_type');

INSERT INTO `sys_dict_type` (`dict_id`,`dict_name`,`dict_type`,`status`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1823182238898274311,'茶叶等级','wms_tea_level','1','admin',NOW(),'',NULL, '茶叶等级'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_type`='wms_tea_level');

INSERT INTO `sys_dict_type` (`dict_id`,`dict_name`,`dict_type`,`status`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1823182238898274312,'采摘季','wms_harvest_season','1','admin',NOW(),'',NULL, '采摘季'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_type`='wms_harvest_season');

DELETE FROM `sys_dict_data` WHERE `dict_type` IN ('merchant_type','wms_receipt_status','wms_receipt_type','wms_shipment_status','wms_shipment_type','wms_inventory_history_type','wms_movement_status','wms_check_status','wms_tea_type','wms_tea_level','wms_harvest_season');

INSERT INTO `sys_dict_data` (`dict_code`,`dict_sort`,`dict_label`,`dict_value`,`dict_type`,`css_class`,`list_class`,`is_default`,`status`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`) VALUES
(1825000000000000001,0,'采购方','1','merchant_type',NULL,'default','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000002,1,'供应方','2','merchant_type',NULL,'default','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000003,2,'经销方','3','merchant_type',NULL,'default','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000010,0,'待入仓','0','wms_receipt_status',NULL,'info','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000011,1,'已入仓','1','wms_receipt_status',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000012,2,'作废','-1','wms_receipt_status',NULL,'danger','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000020,0,'春茶采购入仓','1','wms_receipt_type',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000021,1,'秋茶采购入仓','2','wms_receipt_type',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000022,2,'退货回仓','3','wms_receipt_type',NULL,'warning','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000030,0,'待出仓','0','wms_shipment_status',NULL,'info','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000031,1,'已出仓','1','wms_shipment_status',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000032,2,'作废','-1','wms_shipment_status',NULL,'danger','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000040,0,'渠道销售出仓','1','wms_shipment_type',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000041,1,'电商零售出仓','2','wms_shipment_type',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000042,2,'样品出仓','3','wms_shipment_type',NULL,'warning','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000050,0,'入仓','1','wms_inventory_history_type',NULL,'success','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000051,1,'出仓','2','wms_inventory_history_type',NULL,'danger','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000052,2,'调拨','3','wms_inventory_history_type',NULL,'warning','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000053,3,'盘点','4','wms_inventory_history_type',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000060,0,'待调拨','0','wms_movement_status',NULL,'info','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000061,1,'已调拨','1','wms_movement_status',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000062,2,'作废','-1','wms_movement_status',NULL,'danger','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000070,0,'待盘点','0','wms_check_status',NULL,'info','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000071,1,'已盘点','1','wms_check_status',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000072,2,'作废','-1','wms_check_status',NULL,'danger','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000080,0,'绿茶','green','wms_tea_type',NULL,'success','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000081,1,'红茶','black','wms_tea_type',NULL,'danger','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000082,2,'乌龙茶','oolong','wms_tea_type',NULL,'warning','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000083,3,'白茶','white','wms_tea_type',NULL,'info','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000084,4,'黑茶','dark','wms_tea_type',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000085,5,'普洱茶','puer','wms_tea_type',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000090,0,'特级','S','wms_tea_level',NULL,'success','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000091,1,'一级','A','wms_tea_level',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000092,2,'二级','B','wms_tea_level',NULL,'warning','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000093,3,'三级','C','wms_tea_level',NULL,'info','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000100,0,'明前','mingqian','wms_harvest_season',NULL,'success','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000101,1,'雨前','yuqian','wms_harvest_season',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000102,2,'春尾','late_spring','wms_harvest_season',NULL,'warning','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000103,3,'夏茶','summer','wms_harvest_season',NULL,'danger','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000104,4,'秋茶','autumn','wms_harvest_season',NULL,'info','N','1','admin',NOW(),'',NULL,NULL);

-- 菜单语义修正（不改前端代码）
UPDATE `sys_menu` SET `menu_name`='茶企档案', `path`='teaOrg', `order_num`=10 WHERE `menu_id`=1808758090157985794;
UPDATE `sys_menu` SET `menu_name`='茶企管理' WHERE `menu_id`=1809059968309743618;
UPDATE `sys_menu` SET `menu_name`='茶企查询' WHERE `menu_id`=1809059968309743619;
UPDATE `sys_menu` SET `menu_name`='茶企修改' WHERE `menu_id`=1809059968309743621;
UPDATE `sys_menu` SET `menu_name`='茶仓管理' WHERE `menu_id`=1813458070128599041;
UPDATE `sys_menu` SET `menu_name`='茶品档案' WHERE `menu_id`=1813820131794837506;
UPDATE `sys_menu` SET `menu_name`='品牌产地' WHERE `menu_id`=1818123963605549057;
UPDATE `sys_menu` SET `menu_name`='茶仓查询' WHERE `menu_id`=1829349433573822466;
UPDATE `sys_menu` SET `menu_name`='茶仓编辑' WHERE `menu_id`=1829350022131142658;
UPDATE `sys_menu` SET `menu_name`='品牌产地查询' WHERE `menu_id`=1829350164603260929;
UPDATE `sys_menu` SET `menu_name`='品牌产地编辑' WHERE `menu_id`=1829350944311791617;
UPDATE `sys_menu` SET `menu_name`='茶品查询' WHERE `menu_id`=1829351081448755202;
UPDATE `sys_menu` SET `menu_name`='茶品编辑' WHERE `menu_id`=1829351166857367553;

INSERT INTO `sys_menu` (`menu_id`,`menu_name`,`parent_id`,`order_num`,`path`,`component`,`query_param`,`is_frame`,`is_cache`,`menu_type`,`visible`,`status`,`perms`,`icon`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1900000000000000001,'采购入仓',0,20,'teaReceipt',NULL,NULL,0,0,'M','1','1',NULL,'exit-fullscreen','admin',NOW(),'',NULL, '采购入仓目录'
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id`=1900000000000000001);

INSERT INTO `sys_menu` (`menu_id`,`menu_name`,`parent_id`,`order_num`,`path`,`component`,`query_param`,`is_frame`,`is_cache`,`menu_type`,`visible`,`status`,`perms`,`icon`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1900000000000000002,'销售出仓',0,30,'teaShipment',NULL,NULL,0,0,'M','1','1',NULL,'fullscreen','admin',NOW(),'',NULL, '销售出仓目录'
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id`=1900000000000000002);

INSERT INTO `sys_menu` (`menu_id`,`menu_name`,`parent_id`,`order_num`,`path`,`component`,`query_param`,`is_frame`,`is_cache`,`menu_type`,`visible`,`status`,`perms`,`icon`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1900000000000000003,'加工调拨',0,40,'teaMovement',NULL,NULL,0,0,'M','1','1',NULL,'drag','admin',NOW(),'',NULL, '加工调拨目录'
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id`=1900000000000000003);

INSERT INTO `sys_menu` (`menu_id`,`menu_name`,`parent_id`,`order_num`,`path`,`component`,`query_param`,`is_frame`,`is_cache`,`menu_type`,`visible`,`status`,`perms`,`icon`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1900000000000000004,'茶仓盘点',0,50,'teaCheck',NULL,NULL,0,0,'M','1','1',NULL,'example','admin',NOW(),'',NULL, '茶仓盘点目录'
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id`=1900000000000000004);

INSERT INTO `sys_menu` (`menu_id`,`menu_name`,`parent_id`,`order_num`,`path`,`component`,`query_param`,`is_frame`,`is_cache`,`menu_type`,`visible`,`status`,`perms`,`icon`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1900000000000000005,'库存分析',0,60,'teaInventory',NULL,NULL,0,0,'M','1','1',NULL,'chart','admin',NOW(),'',NULL, '库存分析目录'
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id`=1900000000000000005);

UPDATE `sys_menu` SET `menu_name`='采购入仓单', `parent_id`=1900000000000000001 WHERE `menu_id`=1818466281474822145;
UPDATE `sys_menu` SET `menu_name`='编辑采购入仓单', `parent_id`=1900000000000000001 WHERE `menu_id`=1815207165755183105;
UPDATE `sys_menu` SET `menu_name`='销售出仓单', `parent_id`=1900000000000000002 WHERE `menu_id`=1818854933803638785;
UPDATE `sys_menu` SET `menu_name`='编辑销售出仓单', `parent_id`=1900000000000000002 WHERE `menu_id`=1818855673632727042;
UPDATE `sys_menu` SET `menu_name`='加工调拨单', `parent_id`=1900000000000000003 WHERE `menu_id`=1822820194307051521;
UPDATE `sys_menu` SET `menu_name`='编辑加工调拨单', `parent_id`=1900000000000000003 WHERE `menu_id`=1822862323595145218;
UPDATE `sys_menu` SET `menu_name`='茶仓盘点单', `parent_id`=1900000000000000004 WHERE `menu_id`=1823187248797270018;
UPDATE `sys_menu` SET `menu_name`='编辑茶仓盘点单', `parent_id`=1900000000000000004 WHERE `menu_id`=1823190638784757762;
UPDATE `sys_menu` SET `menu_name`='茶仓库存', `parent_id`=1900000000000000005 WHERE `menu_id`=1820729144067321858;
UPDATE `sys_menu` SET `menu_name`='库存流水', `parent_id`=1900000000000000005 WHERE `menu_id`=1821075355068559361;

INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 1829105952432427010, 1900000000000000001 WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id`=1829105952432427010 AND `menu_id`=1900000000000000001);
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 1829105952432427010, 1900000000000000002 WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id`=1829105952432427010 AND `menu_id`=1900000000000000002);
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 1829105952432427010, 1900000000000000003 WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id`=1829105952432427010 AND `menu_id`=1900000000000000003);
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 1829105952432427010, 1900000000000000004 WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id`=1829105952432427010 AND `menu_id`=1900000000000000004);
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 1829105952432427010, 1900000000000000005 WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id`=1829105952432427010 AND `menu_id`=1900000000000000005);

SET FOREIGN_KEY_CHECKS = 1;
