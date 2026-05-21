SET NAMES utf8mb4;
USE `ry-vue`;

-- 用户资料茶叶化
UPDATE `sys_user`
SET `nick_name`='国茶系统管理员',
    `email`='admin@guochatea.cn',
    `remark`='茶叶经营管理系统管理员',
    `update_by`='admin',
    `update_time`=NOW()
WHERE `user_id`=1;

UPDATE `sys_user`
SET `nick_name`='茶仓运营专员',
    `email`='warehouse@guochatea.cn',
    `remark`='茶仓运营与库存执行',
    `update_by`='admin',
    `update_time`=NOW()
WHERE `user_id`=1829105396288688129;

-- 组织架构茶叶化
UPDATE `sys_dept` SET `dept_name`='国茶集团', `leader`='林正山', `email`='group@guochatea.cn', `update_by`='admin', `update_time`=NOW() WHERE `dept_id`=100;
UPDATE `sys_dept` SET `dept_name`='国茶运营中心', `leader`='叶知秋', `email`='ops@guochatea.cn', `update_by`='admin', `update_time`=NOW() WHERE `dept_id`=101;
UPDATE `sys_dept` SET `dept_name`='华东茶区分公司', `leader`='周青岚', `email`='east@guochatea.cn', `update_by`='admin', `update_time`=NOW() WHERE `dept_id`=102;
UPDATE `sys_dept` SET `dept_name`='采购与品控中心', `leader`='顾明远', `email`='qa@guochatea.cn', `update_by`='admin', `update_time`=NOW() WHERE `dept_id`=103;
UPDATE `sys_dept` SET `dept_name`='渠道营销中心', `leader`='苏听雨', `email`='channel@guochatea.cn', `update_by`='admin', `update_time`=NOW() WHERE `dept_id`=104;
UPDATE `sys_dept` SET `dept_name`='茶仓运营中心', `leader`='韩墨白', `email`='warehouse@guochatea.cn', `update_by`='admin', `update_time`=NOW() WHERE `dept_id`=105;
UPDATE `sys_dept` SET `dept_name`='财务结算中心', `leader`='沈若棠', `email`='finance@guochatea.cn', `update_by`='admin', `update_time`=NOW() WHERE `dept_id`=106;
UPDATE `sys_dept` SET `dept_name`='信息运维中心', `leader`='宋远航', `email`='itops@guochatea.cn', `update_by`='admin', `update_time`=NOW() WHERE `dept_id`=107;
UPDATE `sys_dept` SET `dept_name`='电商事业部', `leader`='程书晚', `email`='ecom@guochatea.cn', `update_by`='admin', `update_time`=NOW() WHERE `dept_id`=108;
UPDATE `sys_dept` SET `dept_name`='连锁渠道部', `leader`='白清禾', `email`='retail@guochatea.cn', `update_by`='admin', `update_time`=NOW() WHERE `dept_id`=109;
UPDATE `sys_dept` SET `dept_name`='茶样审评组', `leader`='陆闻笙', `email`='tasting@guochatea.cn', `update_by`='admin', `update_time`=NOW() WHERE `dept_id`=1811589666899832833;

-- 岗位茶叶化
UPDATE `sys_post` SET `post_name`='茶业总经理', `post_code`='tea_ceo', `remark`='负责集团茶业经营', `update_by`='admin', `update_time`=NOW() WHERE `post_id`=1;
UPDATE `sys_post` SET `post_name`='采购品控经理', `post_code`='tea_qa_manager', `remark`='负责采购与品质管控', `update_by`='admin', `update_time`=NOW() WHERE `post_id`=2;
UPDATE `sys_post` SET `post_name`='渠道运营专员', `post_code`='tea_channel_op', `remark`='负责经销与渠道运营', `update_by`='admin', `update_time`=NOW() WHERE `post_id`=3;
UPDATE `sys_post` SET `post_name`='茶仓执行专员', `post_code`='tea_warehouse_op', `remark`='负责茶仓收发存执行', `update_by`='admin', `update_time`=NOW() WHERE `post_id`=4;
UPDATE `sys_post` SET `post_name`='财务结算专员', `post_code`='tea_finance_op', `remark`='负责茶企结算与对账', `update_by`='admin', `update_time`=NOW() WHERE `post_id`=1811656351757385729;

-- 角色茶叶化
UPDATE `sys_role` SET `role_name`='茶叶系统管理员', `remark`='全量管理权限', `update_by`='admin', `update_time`=NOW() WHERE `role_id`=1;
UPDATE `sys_role` SET `role_name`='茶企运营角色', `remark`='茶企日常运营权限', `update_by`='admin', `update_time`=NOW() WHERE `role_id`=2;
UPDATE `sys_role` SET `role_name`='茶样审评角色A', `remark`='审评与抽检权限', `update_by`='admin', `update_time`=NOW() WHERE `role_id`=1811607750859661314;
UPDATE `sys_role` SET `role_name`='茶样审评角色B', `remark`='审评与复核权限', `update_by`='admin', `update_time`=NOW() WHERE `role_id`=1811629311809396737;
UPDATE `sys_role` SET `role_name`='茶企试用角色', `remark`='演示与试用权限', `update_by`='admin', `update_time`=NOW() WHERE `role_id`=1829105952432427010;

-- 公告茶叶化
UPDATE `sys_notice`
SET `notice_title`='温馨提示：茶业系统功能已升级',
    `notice_type`='2',
    `notice_content`='本次升级已完成茶企档案、采购入仓、销售出仓、库存分析等模块优化。',
    `update_by`='admin',
    `update_time`=NOW()
WHERE `notice_id`=1;

UPDATE `sys_notice`
SET `notice_title`='维护通知：茶业系统例行维护',
    `notice_type`='1',
    `notice_content`='系统将在凌晨进行茶品数据归档与索引维护，请提前保存操作。',
    `update_by`='admin',
    `update_time`=NOW()
WHERE `notice_id`=2;

-- 菜单补充修正（防止个别环境遗留）
UPDATE `sys_menu` SET `menu_name`='茶仓库存', `update_by`='admin', `update_time`=NOW() WHERE `menu_id`=1820729144067321858;
UPDATE `sys_menu` SET `menu_name`='库存流水', `update_by`='admin', `update_time`=NOW() WHERE `menu_id`=1821075355068559361;
