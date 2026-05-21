SET NAMES utf8mb4;
USE `ry-vue`;

-- 茶仓智能查询助手菜单（位于茶企档案之前，order_num=9）
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 1900000000000000009, '茶仓智能查询助手', 0, 9, 'teaAgent', 'wms/teaAgent/index', NULL, 0, 0, 'C', '1', '1', 'wms:teaAgent:chat', 'message', 'admin', NOW(), '', NULL, '茶仓智能问数-仅查询'
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 1900000000000000009);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1829105952432427010, 1900000000000000009
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1829105952432427010 AND `menu_id` = 1900000000000000009);
