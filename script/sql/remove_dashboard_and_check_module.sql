SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
USE `ry-vue`;

-- 1) 移除茶仓盘点菜单权限
DELETE FROM `sys_role_menu`
WHERE `menu_id` IN (
  SELECT `menu_id` FROM `sys_menu`
  WHERE `path` IN ('teaCheck', 'checkOrder', 'checkOrderEdit')
     OR `menu_name` IN ('茶仓盘点', '茶仓盘点单', '编辑茶仓盘点单')
);

DELETE FROM `sys_menu`
WHERE `path` IN ('teaCheck', 'checkOrder', 'checkOrderEdit')
   OR `menu_name` IN ('茶仓盘点', '茶仓盘点单', '编辑茶仓盘点单');

-- 2) 清理盘点字典（模块已下线）
DELETE FROM `sys_dict_data` WHERE `dict_type` = 'wms_check_status';
DELETE FROM `sys_dict_type` WHERE `dict_type` = 'wms_check_status';
-- 库存流水筛选项移除「盘点」类型（value=4）
DELETE FROM `sys_dict_data` WHERE `dict_type` = 'wms_inventory_history_type' AND `dict_value` = '4';

-- 3) 清理盘点业务数据与盘点流水
DELETE FROM `wms_check_order_detail`;
DELETE FROM `wms_check_order`;
DELETE FROM `wms_inventory_history` WHERE `order_type` = 4 OR `order_no` LIKE 'PK%';

SET FOREIGN_KEY_CHECKS = 1;
