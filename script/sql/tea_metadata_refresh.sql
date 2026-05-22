SET NAMES utf8mb4;
USE `ry_tea`;

UPDATE `sys_dict_type` SET `dict_name` = '茶企角色类型', `remark`='茶企角色类型' WHERE `dict_type`='merchant_type';
UPDATE `sys_dict_type` SET `dict_name` = '采购入仓状态' WHERE `dict_type`='wms_receipt_status';
UPDATE `sys_dict_type` SET `dict_name` = '采购入仓类型' WHERE `dict_type`='wms_receipt_type';
UPDATE `sys_dict_type` SET `dict_name` = '销售出仓状态' WHERE `dict_type`='wms_shipment_status';
UPDATE `sys_dict_type` SET `dict_name` = '销售出仓类型' WHERE `dict_type`='wms_shipment_type';
UPDATE `sys_dict_type` SET `dict_name` = '加工调拨状态' WHERE `dict_type`='wms_movement_status';
UPDATE `sys_dict_type` SET `dict_name` = '茶仓盘点状态' WHERE `dict_type`='wms_check_status';
UPDATE `sys_dict_type` SET `dict_name` = '茶仓流水操作类型' WHERE `dict_type`='wms_inventory_history_type';

INSERT INTO `sys_dict_type` (`dict_id`,`dict_name`,`dict_type`,`status`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1823182238898274310,'茶类','wms_tea_type','1','admin',NOW(),'',NULL,'中国茶类'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_type`='wms_tea_type');
INSERT INTO `sys_dict_type` (`dict_id`,`dict_name`,`dict_type`,`status`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1823182238898274311,'茶叶等级','wms_tea_level','1','admin',NOW(),'',NULL,'茶叶等级'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_type`='wms_tea_level');
INSERT INTO `sys_dict_type` (`dict_id`,`dict_name`,`dict_type`,`status`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1823182238898274312,'采摘季','wms_harvest_season','1','admin',NOW(),'',NULL,'采摘季'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_type`='wms_harvest_season');

DELETE FROM `sys_dict_data` WHERE `dict_type` IN ('merchant_type','wms_receipt_status','wms_receipt_type','wms_shipment_status','wms_shipment_type','wms_inventory_history_type','wms_movement_status','wms_check_status','wms_tea_type','wms_tea_level','wms_harvest_season');
INSERT INTO `sys_dict_data` (`dict_code`,`dict_sort`,`dict_label`,`dict_value`,`dict_type`,`css_class`,`list_class`,`is_default`,`status`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`) VALUES
(1825000000000000001,0,'采购方','1','merchant_type',NULL,'default','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000002,1,'供应方','2','merchant_type',NULL,'default','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000003,2,'经销方','3','merchant_type',NULL,'default','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000010,0,'待入仓','0','wms_receipt_status',NULL,'info','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000011,1,'已入仓','1','wms_receipt_status',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000020,0,'春茶采购入仓','1','wms_receipt_type',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000021,1,'秋茶采购入仓','2','wms_receipt_type',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000022,2,'退货回仓','3','wms_receipt_type',NULL,'warning','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000030,0,'待出仓','0','wms_shipment_status',NULL,'info','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000031,1,'已出仓','1','wms_shipment_status',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000040,0,'渠道销售出仓','1','wms_shipment_type',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000041,1,'电商零售出仓','2','wms_shipment_type',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000042,2,'样品出仓','3','wms_shipment_type',NULL,'warning','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000050,0,'入仓','1','wms_inventory_history_type',NULL,'success','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000051,1,'出仓','2','wms_inventory_history_type',NULL,'danger','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000052,2,'调拨','3','wms_inventory_history_type',NULL,'warning','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000053,3,'盘点','4','wms_inventory_history_type',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000060,0,'待调拨','0','wms_movement_status',NULL,'info','N','1','admin',NOW(),'',NULL,NULL),
(1825000000000000061,1,'已调拨','1','wms_movement_status',NULL,'primary','N','1','admin',NOW(),'',NULL,NULL),
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
SELECT 1900000000000000001,'采购入仓',0,20,'teaReceipt',NULL,NULL,0,0,'M','1','1',NULL,'exit-fullscreen','admin',NOW(),'',NULL,'采购入仓目录'
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id`=1900000000000000001);
INSERT INTO `sys_menu` (`menu_id`,`menu_name`,`parent_id`,`order_num`,`path`,`component`,`query_param`,`is_frame`,`is_cache`,`menu_type`,`visible`,`status`,`perms`,`icon`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1900000000000000002,'销售出仓',0,30,'teaShipment',NULL,NULL,0,0,'M','1','1',NULL,'fullscreen','admin',NOW(),'',NULL,'销售出仓目录'
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id`=1900000000000000002);
INSERT INTO `sys_menu` (`menu_id`,`menu_name`,`parent_id`,`order_num`,`path`,`component`,`query_param`,`is_frame`,`is_cache`,`menu_type`,`visible`,`status`,`perms`,`icon`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1900000000000000003,'加工调拨',0,40,'teaMovement',NULL,NULL,0,0,'M','1','1',NULL,'drag','admin',NOW(),'',NULL,'加工调拨目录'
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id`=1900000000000000003);
INSERT INTO `sys_menu` (`menu_id`,`menu_name`,`parent_id`,`order_num`,`path`,`component`,`query_param`,`is_frame`,`is_cache`,`menu_type`,`visible`,`status`,`perms`,`icon`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1900000000000000004,'茶仓盘点',0,50,'teaCheck',NULL,NULL,0,0,'M','1','1',NULL,'example','admin',NOW(),'',NULL,'茶仓盘点目录'
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id`=1900000000000000004);
INSERT INTO `sys_menu` (`menu_id`,`menu_name`,`parent_id`,`order_num`,`path`,`component`,`query_param`,`is_frame`,`is_cache`,`menu_type`,`visible`,`status`,`perms`,`icon`,`create_by`,`create_time`,`update_by`,`update_time`,`remark`)
SELECT 1900000000000000005,'库存分析',0,60,'teaInventory',NULL,NULL,0,0,'M','1','1',NULL,'chart','admin',NOW(),'',NULL,'库存分析目录'
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
SELECT 1829105952432427010,1900000000000000001
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id`=1829105952432427010 AND `menu_id`=1900000000000000001);
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 1829105952432427010,1900000000000000002
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id`=1829105952432427010 AND `menu_id`=1900000000000000002);
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 1829105952432427010,1900000000000000003
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id`=1829105952432427010 AND `menu_id`=1900000000000000003);
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 1829105952432427010,1900000000000000004
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id`=1829105952432427010 AND `menu_id`=1900000000000000004);
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 1829105952432427010,1900000000000000005
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id`=1829105952432427010 AND `menu_id`=1900000000000000005);
